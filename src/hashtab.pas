{** @abstract(Hash table data structure and manipulation routines.) This module
    implements a chained hash table,which maps keys to values. Any non nil
    pointer can be used as a key or as a value.

    A hash table has one parameter that affects its performance: the capacity.
    The capacity is the number of buckets in the hash table. Note that the hash 
    table is chained: in the case of a "hash collision", a single bucket stores 
    multiple entries in a list, which must be then searched sequentially. This
    implementation has a fixed number of buckets which cannot grow dynamically
    but which can be configured when the hash table is created.

    @author(Carl Eric Codere)
}
Unit hashtab;
{==== Compiler directives ===========================================}
{$B-} { Full boolean evaluation          }
{$I-} { IO Checking                      }
{$F+} { FAR routine calls                }
{$P+} { Implicit open strings            }
{$T-} { Typed pointers                   }
{$V-} { Strict VAR strings checking      }
{$X+} { Extended syntax                  }
{$IFNDEF TP}
 {$H+} { Memory allocated strings        }
 {$DEFINE ANSISTRINGS}
 {$J+} { Writeable constants             }
 {$METHODINFO OFF}
{$ENDIF}
{====================================================================}
{$IFDEF FPC}
{$MODE OBJFPC}
{$ENDIF}
interface

Uses list
{$IFDEF TP}
     ,cmntyp
{$ENDIF};



Type

  {** Hash function prototype }
  THashFunction =    Function (const key: Pointer): Longword;

  PHashTableHandle = ^THashTableHandle;
  {** Hash table handle structure }
  THashTableHandle = record
    buckets: word;
    size: integer;
    hash: THashFunction;
    match: TMatchFunction;
    destroy_data: TDestroyFunction;
    destroy_key: TDestroyFunction;
    Table: PLinkedListTable;
  end;


{** Removes the element associated with key from the hash table. It frees the memory for the removed
    element (if the destroy value callback was set) and key (if the destroy key callback was set).

   @param(htbl The hash table handle)
   @param(key The key that identifies the data to remove)
   @return(The old value that has been removed if there was already a value
     with the same key and no callbacks to free element memory were set,
     otherwise @nil.)
}
Function hashtab_remove(var htbl: THashTableHandle; Key: Pointer): Pointer;

{** Returns the number of elements in this hash table.

   @param(htbl The hash table handle)
   @return(The current number of elements in this hash table)
}
Function hashtab_size(var htbl: THashTableHandle): Integer;

{** Creates an empty hash table with the initial specified number of
    buckets.

   @param(htbl The hash table handle that will be initialized)
   @param(buckets The number of buckets to allocate.
     if this is set to 0, then the default shall be used.)
   @param(hash A function callback that will be called to
     calculate the hash of the key. This value cannot be @nil.)
   @param(match A callback that is used to to compare two
     key values, it should return @true if both keys match. This value cannot be @nil.)
   @param(destroy_value A callback that is used to free the memory of the
     data elements, this can be @nil if the memory of the elements is not
     managed by this hash table.)
   @param(destroy_key A callback that is used to free the memory of the
     keys, this can be @nil if the memory of the elements is not
     managed by this hash table.)
   @return(@link(EXIT_SUCCESS) if ok otherwise @link(EXIT_FAILURE) in case of memory allocation error.)
}
Function hashtab_init(var htbl: THashTableHandle; buckets: word; hash: THashFunction; match: TMatchFunction;
  Destroy_Value: TDestroyFunction; Destroy_Key: TDestroyFunction): Integer;

{** Searches for the specified key in the hash table. Returns
    the data associated with the key or nil if it is not
    present in the hash table.
 
   @param(htbl The hash table handle)
   @param(key  The key to look for)
   @return(The data associated with the key, or nil if it is not found.)
}
Function hashtab_lookup(var htbl: THashTableHandle; Key: Pointer): Pointer;

{** Destroy this hash table and frees all allocated memory. It frees
    the memory of the hash table data (if the destroy data callback was set),
    and keys (if the destroy key callback was set).

    @param(htbl The hash table handle)
}
Procedure hashtab_destroy(var htbl: THashTableHandle);

{** Inserts the specified element with the specified key in the
    hash table, replacing the old value if it exists.
 
   @param(htbl The hash table handle)
   @param(key The key of the element)
   @param(data The element data to add to the hash table)
   @return(The old value that is replaced if there was already a value
     with the same key and no callbacks to free element memory were set,
     otherwise nil.)
 
}
Function hashtab_insert(var htbl: THashTableHandle; Key: Pointer; Data: Pointer): Pointer;

{** Iterate through each item in the hashtable by calling the iterator
    callback function. The iteration stops once the iterator
    function returns 0.
 
    @param(htbl The initialized hash table)
    @param(iterator The iterator callback function to call)
    @param(p The private data that should be passed to the iterator.)
}
Procedure hashtab_iterate(var htbl: THashTableHandle; IteratorFunc: TIteratorFunction; P :pointer);


implementation

Type
PHashTableEntry = ^THashTableEntry;
THashTableEntry = record
  {** Pointer to the key *}
  Key: Pointer;
  {** Pointer to the value. *}
  Value: Pointer;
end;


{------------------------------ Hash table -----------------------------------}
{** Internal routine to free up an entry, return the old value if supported. *}
Function hashtab_free_entry(var htbl: THashTableHandle; var entry: PHashTableEntry): Pointer;
var
  Value: Pointer;
Begin
  Value := nil;
  if Assigned(htbl.destroy_key) then
       htbl.destroy_key(entry^.key);

  if Assigned(htbl.destroy_data) then
   Begin
       htbl.destroy_data(entry^.value);
   end
  else
   Begin
      value:=entry^.value;
   end;


  entry^.key := nil;
  entry^.value := nil;
  dispose(entry);
  hashtab_free_entry := value;
end;

{** Internal routine to lookup a key value *}
Function hashtab_lookup_entry(const htbl: THashTableHandle; Key: Pointer): PHashTableEntry;
var
  element: PListElement;
  Entry: PHashTableEntry;
  bucket: longword;
Begin
  hashtab_lookup_entry := nil;
    {* Hash the key. *}
    bucket := htbl.hash(key) mod htbl.buckets;

        element := list_get_head_node(htbl.table^[bucket]);
        while Assigned(element) do
        Begin
           entry:= PHashTableEntry(list_data(element));
           if htbl.match(key, entry^.key) then
             Begin
                { Found the value, simply exit }
                hashtab_lookup_entry := entry;
                exit;
             end;
           element := list_next(element);
        end;
end;




Function hashtab_remove(var htbl: THashTableHandle; Key: Pointer): Pointer;
var
  element: PListElement;
  prev: PListElement;
  entry: Pointer;{PHashTableEntry;}
  bucket: longword;
Begin
  Assert(key <> nil);
  hashtab_remove := nil;
  {* Hash the key to retrieve the bucket number *}

  bucket := htbl.hash(key) mod htbl.buckets;

  {* Search for the data in the bucket. *}
  prev := nil;
  element := list_get_head_node(htbl.table^[bucket]);
  while (Assigned(element)) do
    Begin
       entry := PHashTableEntry(list_data(element));
       if htbl.match(key, PHashTableEntry(entry)^.key) then
    Begin
      {*  Remove the data from the bucket. *}
      if (list_rem_next(htbl.table^[bucket], prev, entry) = 0) then
      Begin
                       Dec(htbl.size);
                       hashtab_remove := hashtab_free_entry(htbl, PHashTableEntry(entry));
                       exit;
      end
      else
      Begin
                       hashtab_remove := hashtab_free_entry(htbl, PHashTableEntry(entry));
                       exit;
      end;
    end; {end if }
    prev := element;
        element := list_next(element);
  end; { end while }
end;

Function hashtab_size(var htbl: THashTableHandle): Integer;
var
 List: TLinkedListHandle;
 i: integer;
 size: integer;
 count: integer;
Begin
  size := 0;
  count := htbl.buckets - 1;
  for i := 0 to count do
  Begin
    list := htbl.table^[i];
    size := size + list_size(list);
  end;
  hashtab_size := size;
end;

Function hashtab_init(var htbl: THashTableHandle; buckets: word; hash: THashFunction; match: TMatchFunction;
  Destroy_Value: TDestroyFunction; Destroy_Key: TDestroyFunction): Integer;
var
  i: integer;
  count: integer;
Begin
  {* Allocate space for the hash table. *}
  GetMem(htbl.table,buckets*sizeof(TLinkedListHandle));
  if htbl.table = nil then
   Begin
     hashtab_init := EXIT_FAILURE;
     exit;
   end;

  {* Initialize the buckets. *}
  htbl.buckets := buckets;
  count := buckets - 1;
  for i := 0 to count  do
    Begin
    list_init(htbl.table^[i], nil);
    end;
  {*  Initialize the hash table. *}
  htbl.hash := hash;
  htbl.match := match;
  htbl.destroy_data := destroy_value;
  htbl.destroy_key := destroy_key;
  htbl.size := 0;
  hashtab_init := EXIT_SUCCESS;
end;

Function hashtab_lookup(var htbl: THashTableHandle; Key: Pointer): Pointer;
var
  Entry: PHashTableEntry;
Begin
  hashtab_lookup := nil;
  assert(key <> nil);

  entry := hashtab_lookup_entry(htbl,key);
  if Assigned(entry) then
    hashtab_lookup := entry^.value;
end;

Procedure hashtab_destroy(var htbl: THashTableHandle);
var
 i: integer;
 j: integer;
 size: longint;
 count: integer;
 list: TLinkedListHandle;
 Entry: PHashTableEntry;
 value: Pointer;
Begin

  count := htbl.buckets - 1;
  {*  Destroy each bucket. *}
  for i:=0 to count do
  Begin
    list := htbl.table^[i];
    size := list_size(htbl.table^[i]) - 1;
    for j := 0 to size do
     Begin
       entry := list_get(list, j);
       value:=hashtab_free_entry(htbl,entry);
     end;
     list_destroy(htbl.table^[i]);
  end;

  {* Free the storage allocated for the hash table. *}
  FreeMem(htbl.table,htbl.buckets*sizeof(TLinkedListHandle));

  {* Clear the structure as a precaution *}
  FillChar(htbl,sizeof(ThashTableHandle),0);

end;

Function hashtab_insert(var htbl: THashTableHandle; Key: Pointer; Data: Pointer): Pointer;
var
  Entry: PHashTableEntry;
  bucket: longword;
  oldData: Pointer;
Begin
  assert(key <> nil);

  oldData := nil;
  {*  Hash the key. *}
  bucket := htbl.hash(key) mod htbl.buckets;
  {* We replace the old data with the new one *}
  entry := hashtab_lookup_entry(htbl, key);
  {* The entry already exists - deallocate the data *}
  if Assigned(entry) then
   Begin
       assert(list_remove(htbl.table^[bucket], entry)=EXIT_SUCCESS);
       { We must return the old data }
       oldData := hashtab_free_entry(htbl,entry);
   end;


  {*  Insert the data into the bucket. *}
  New(Entry);
  entry^.key := key;
  entry^.value := data;

  if list_add(htbl.table^[bucket], entry)=EXIT_SUCCESS then
    Inc(htbl.size);

  hashtab_insert := oldData;
end;

Procedure hashtab_iterate(var htbl: THashTableHandle; IteratorFunc: TIteratorFunction; P :pointer);
var
   i: integer;
   j: integer;
   size: integer;
   count: integer;
   List: TLinkedListHandle;
   Entry: PHashTableEntry;
Begin
   Assert(Assigned(IteratorFunc));
   count := htbl.buckets - 1;
   for i:=0 to count do
    Begin
      list := htbl.table^[i];
      size := list_size(htbl.table^[i]) - 1;
      for j:=0 to size do
       Begin
     entry := list_get(list, j);
    if (iteratorFunc(entry^.key, entry^.value,p)=0) then
            exit;
        end;
     end;
end;



end.
