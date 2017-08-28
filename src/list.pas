{
    $Id$
    Copyright (c) 2014 by Carl Eric Codere

    List data structure implementation

    See License.txt for more information on the licensing terms
    for this source code.
    
}
{** @abstract(Linked list data structure and manipulation routines.) This
    implements a linked list structure where each item is added at the head
    of the linked list.

    @author(Carl Eric Codere)
}
Unit list;
{==== Compiler directives ===========================================}
{$B-} { Full boolean evaluation          }
{$I-} { IO Checking                      }
{$F+} { FAR routine calls                }
{$P-} { Implicit open strings            }
{$T-} { Typed pointers                   }
{$V+} { Strict VAR strings checking      }
{$X-} { Extended syntax                  }
{$IFNDEF TP}
 {$H-} { Memory allocated strings        }
 {$DEFINE ANSISTRINGS}
 {$J+} { Writeable constants             }
 {$METHODINFO OFF}
{$ENDIF}
{====================================================================}
{$IFDEF FPC}
{$MODE OBJFPC}
{$ENDIF}
interface

{$IFDEF TP}
Uses cmntyp;
{$ENDIF}

Type
  {** Key-Value Iterator function prototype }
  TIteratorFunction =  Function (Key: Pointer; Data: Pointer; p: Pointer): Integer;
  {** List Iterator function prototype }
  TListIteratorFunction = Function (Data: Pointer; p: Pointer): Integer;
  {** Data object memory cleanup prototype. Should be implemented to free up the
      memory of the different pointer objects. }
  TDestroyFunction = Procedure (value: Pointer);
  {** Comparison and match value. Should return true if both values are equal. }
  TMatchFunction =   Function (const key1, key2: Pointer): Boolean;


  PListElement = ^TListElement;
  {** Linked list element }
  TListElement = record
    {** Pointer to the data. }
    data: Pointer;
    {** Pointer to the next item in the list }
    Next: PListElement;
  end;
  
  PLinkedListHandle = ^TLinkedListHandle;
  TLinkedListHandle = record
    size: integer;
    Destroy: TDestroyFunction;
    Match  : TMatchFunction;
    head: PListElement;
    tail: PListElement;
  end;

  PLinkedListTable = ^TLinkedListTable;
{$IFNDEF TP}  
  TlinkedListTable = Array[0..high(word)] of TLinkedListHandle;
{$ELSE}
  TlinkedListTable = Array[0..1024] of TLinkedListHandle;
{$ENDIF}


const
   EXIT_SUCCESS = 0;
   EXIT_FAILURE = 1;


{** Initializes the linked list specified by list. This operation must be called for a
    linked list before the list can be used with any other operation. The @link(destroy)
    argument provides a way to free dynamically allocated data when @link(list_destroy) is
    called. For example, if the list contains data dynamically allocated memory,
    destroy should be set to free free the data as the linked list is destroyed.
    For structured data containing several dynamically allocated members, destroy
    should be set to a user-defined function that calls free for each dynamically
    allocated member as well as for the structure itself. For a linked list containing
    data that should not be freed, destroy should be set to @nil.
  
    @param(list The initialized list)
    @param(destroy A callback that is used to free the memory of the elements, 
          this can be @nil if the memory of the elements is not
      managed by this list.)
 
}
Procedure list_init(var List: TLinkedListHandle; Destroy: TDestroyFunction);

{** Destroys the linked list specified by list. No other operations are permitted after
    calling list_destroy unless list_init is called again. The list_destroy operation
    removes all elements from a linked list and calls the function passed as
    destroy to @link(list_init) once for each element as it is removed to free the data memory,
    provided destroy was not set to nil.
 
   @param(list The initialized list)
}
Procedure list_destroy(var List: TLinkedListHandle);

{** Inserts a new element at the head of the list. The new element contains a
    pointer to data, so the memory referenced by data should remain valid as long as the
    element remains in the list. It is the responsibility of the caller to manage the
    storage associated with data if the destroy callback was not set when the list
    was initialized.
 
   @param(list The initialized list)
   @param(data The data to place in the linked list)
   @return(@link(EXIT_SUCCESS) if the data was succesfully added to the list)
 }
Function list_add(var List: TLinkedListHandle; const data: Pointer): integer;

{** Inserts an element just after element in the linked list specified by list. If element is
    @nil, the new element is inserted at the head of the list. The new element contains a
    pointer to data, so the memory referenced by data should remain valid as long as the
    element remains in the list. It is the responsibility of the caller to manage the
    storage associated with data if the destroy callback was not set when the list 
    was initialized.
 
   @param(list The initialized list)
   @param(element The location where the new element should be placed after, can be
     NULL if the element should be placed at the head of the list.)
   @param(data The data to place in the linked list)
   @return(@link(EXIT_SUCCESS) if the data was succesfully added to the list)
}
Function list_ins_next(var List: TLinkedListHandle; Element: PListelement; const data: Pointer): integer;

{** Removes the element just after element from the linked list specified by list.
    If element is @nil, the element at the head of the list is removed. Upon return,
    data points to the data stored in the element that was removed. It is the
    responsibility of the caller to manage the storage associated with the data.
 
   @param(list The initialized list)
   @param(element The location where the next element should be removed, can be
     @nil if the head element should be removed.)
   @param(data The old data, this value is only valid if the destroy callback
     was not set, otherwise the memory is automatically freed.)
   @return(@link(EXIT_SUCCESS) if the data was succesfully added to the list)
}   
Function  list_rem_next(var List: TLinkedListHandle; Element: PListElement; var data: Pointer): Integer;

{** Returns the number of elements in the list.
 
   @param(list The initialized list)
   @return(The number of element in the linked list.)
} 
Function list_size(var List: TLinkedListHandle): Integer;

{** Returns the first element in the linked list.
 
   @param(list The initialized list)
   @return(The head element, or if @nil if there is no head.)
}
Function list_get_head_node(var List: TLinkedListHandle): PListElement;

{** Returns the last element in the linked list.
 
   @param(list The initialized list)
   @return(The tail element, or if @nil if there is no tail.)
}
Function list_get_tail_node(var List: TLinkedListHandle): PListElement;

{**  Returns the nth element's data in the list. The first element
     has index 0.

     @param(list The initialized list)
     @param(n The index of the element to retrieve)
     @return(The data associated with the element n or @nil
     if n is out of bounds.)
}
Function list_get(var List: TLinkedListHandle; n: integer):Pointer;

{** Removes the first occurrence of the specified data value in this
    list. If the list does not contain the element, it is unchanged.
 
   @param(list The initialized list.)
   @param(data The data to remove from the list)
   @return(@link(EXIT_SUCCESS) if the list contained the specified data.)
} 
Function list_remove(var List: TLinkedListHandle; data: Pointer): integer;

Function list_is_head(var List: TLinkedListHandle; element: PListElement): Boolean;
Function list_is_tail(var List: TLinkedListHandle; element: PListElement): Boolean;

{** Returns the data associated with this element.
 
    @param(element The linked list element)
    @return(The data associated with this element or @nil if there is no data.)
}
Function list_data(Element: PListElement): Pointer;

{** Returns the next element in this linked list, or @nil if this
    is the last element.
 
    @param(element The element)
    @return(The next element in the linked list or @nil if this is the last element.)
}
Function list_next(Element: PListElement): PListElement;

{** Iterate through each item in the list by calling the iterator
    callback function. The iteration stops once the iterator
    function returns 0.

    @param(list The initialized list)
    @param(iterator The iterator callback function to call)
    @param(p The private data that should be passed to the iterator)
}
Procedure list_iterate(var List: TLinkedListHandle; Iterator: TListIteratorFunction; p: Pointer);


implementation

Procedure list_init(var List: TLinkedListHandle; Destroy: TDestroyFunction);
Begin
  list.size := 0;
  list.destroy := Destroy;
  list.head :=  nil;
  list.tail := nil;
end;

Procedure  list_destroy(var List: TLinkedListHandle);
var
   Data: Pointer;
Begin

  {*****************************************************************************
   *                                                                            *
   *  Remove each element.                                                      *
   *                                                                            *
   *****************************************************************************}

  while (list_size(list) > 0) do
        Begin
      if (list_rem_next(list, nil, data) = 0) and
              assigned(list.destroy) then
          list.destroy(data);
  end;
        Fillchar(list, sizeof(list),0);
end;

Function list_add(var List: TLinkedListHandle; const data: Pointer): integer;
var
 new_element: PListElement;
Begin
  list_add := EXIT_SUCCESS;

  New(New_Element);
  if not Assigned(New_Element) then
    Begin
      list_add := EXIT_FAILURE;
      exit;
    end;

  {*****************************************************************************
   *                                                                            *
   *  Insert the element into the list.                                         *
   *                                                                            *
   *****************************************************************************}
   new_element^.data := data;

  {**************************************************************************
   *                                                                         *
   *  Handle insertion at the head of the list.                              *
   *                                                                         *
   **************************************************************************}
  if (list_size(list) = 0) then
    list.tail := new_element;

  new_element^.next := list.head;
  list.head := new_element;

  Inc(list.size);
end;

Function list_ins_next(var List: TLinkedListHandle; Element: PListelement; const data: Pointer): integer;
var
  new_element: PListElement;
Begin
  list_ins_next := EXIT_SUCCESS;

  New(New_Element);
  if not Assigned(New_Element) then
    Begin
      list_ins_next := EXIT_FAILURE;
      exit;
    end;

  {*****************************************************************************
   *                                                                            *
   *  Insert the element into the list.                                         *
   *                                                                            *
   *****************************************************************************}

  new_element^.data := data;

  if (element = nil) then
    Begin

    {**************************************************************************
     *                                                                         *
     *  Handle insertion at the head of the list.                              *
     *                                                                         *
     **************************************************************************}

    if (list_size(list) = 0) then
            list.tail := new_element;


    new_element^.next := list.head;
    list.head := new_element;
  end
  else
  Begin

    {**************************************************************************
     *                                                                         *
     *  Handle insertion somewhere other than at the head.                     *
     *                                                                         *
     **************************************************************************}

    if (element^.next = nil) then
      list.tail := new_element;

    new_element^.next := element^.next;
    element^.next := new_element;

  end;

  {*****************************************************************************
   *                                                                            *
   *  Adjust the size of the list to account for the inserted element.          *
   *                                                                            *
   *****************************************************************************}

  Inc(list.size);
end;

Function list_rem_next(var List: TLinkedListHandle; Element: PListElement; var data: Pointer): Integer;
var
  old_element: PListElement;
Begin
  old_element := nil;
  list_rem_next := EXIT_SUCCESS;

  {*****************************************************************************
   *                                                                            *
   *  Do not allow removal from an empty list.                                  *
   *                                                                            *
   *****************************************************************************}

  if (list_size(list) = 0) then
          Begin
       list_rem_next:=EXIT_FAILURE;
             exit;
          end;

  {*****************************************************************************
   *                                                                            *
   *  Remove the element from the list.                                         *
   *                                                                            *
   *****************************************************************************}

  if (element = nil) then
   Begin

    {**************************************************************************
     *                                                                         *
     *  Handle removal from the head of the list.                              *
     *                                                                         *
     **************************************************************************}

                data := list.head^.data;
    old_element := list.head;
    list.head := list.head^.next;

    if (list_size(list) = 0) then
      list.tail := nil;

   end
  else
  Begin

    {**************************************************************************
     *                                                                         *
     *  Handle removal from somewhere other than the head.                     *
     *                                                                         *
     **************************************************************************}

    if (element^.next = nil) then
                   Begin
                      list_rem_next:=EXIT_FAILURE;
                      exit;
                    end;
    data := element^.next^.data;
    old_element := element^.next;
    element^.next := element^.next^.next;

    if (element^.next = nil) then
      list.tail := element;

  end;

  {*****************************************************************************
   *                                                                            *
   *  Free the storage allocated by the abstract data type.                     *
   *                                                                            *
   *****************************************************************************}
         dispose(old_element);

  {*****************************************************************************
   *                                                                            *
   *  Adjust the size of the list to account for the removed element.           *
   *                                                                            *
   *****************************************************************************}
        Dec(list.size);
end;

Function list_size(var List: TLinkedListHandle): Integer;
Begin
   list_size := list.size;
end;

Function list_get_head_node(var List: TLinkedListHandle): PListElement;
Begin
  list_get_head_node:=list.head;
end;

Function list_get_tail_node(var List: TLinkedListHandle): PListElement;
Begin
  list_get_tail_node:=list.tail;
end;

Function list_get(var List: TLinkedListHandle; n: integer):Pointer;
var
   tmp: PListElement;
   k: integer;
Begin
  tmp := nil;
  Assert(n < list.size);

  if (list.head = nil) then
    Begin
      list_get := nil;
      exit;
    end;

  tmp := list.head;

  { Zero-based values }
  Dec(n);
  for k := 0 to n  do
    tmp := tmp^.next;

  if (tmp = nil) then
    Begin
      list_get := nil;
      exit;
    end;

   list_get:=tmp^.data;
end;

Function list_remove(var List: TLinkedListHandle; data: Pointer): integer;
var
  cur, prev: PListElement;
Begin
  list_remove := EXIT_SUCCESS;
  if (list.head = nil) then
    Begin
      list_remove := EXIT_FAILURE;
      exit;
    end;

  if list.head^.data = data then
  Begin
    cur := list.head;
    list.head := list.head^.next;
    { Free up the memory as required }
    if Assigned(list.destroy) then
    Begin
       list.destroy(cur^.data);
    end;
        Dec(list.size);
        exit;
  end;

  cur := list.head;
  prev := nil;

  while (cur <> nil) and (not (cur^.data = data)) do
  Begin
    prev := cur;
    cur := cur^.next;
  end;

  if cur = nil then
   Begin
     list_remove:=EXIT_FAILURE;
     exit;
   end;

  { delete current node  }
  prev^.next := cur^.next;
  { Free up the memory as required }
  if Assigned(list.destroy) then
  Begin
     list.destroy(cur^.data);
  end;
  Dispose(cur);
  Dec(list.size);
end;

Function list_is_head(var List: TLinkedListHandle; element: PListElement): Boolean;
Begin
  list_is_head := False;
  if element = List.head then
   list_is_head := True;
end;

Function list_is_tail(var List: TLinkedListHandle; element: PListElement): Boolean;
Begin
  list_is_tail := False;
  if Element^.next = nil then
    list_is_tail := True;
end;

Function list_data(Element: PListElement): Pointer;
Begin
   list_data:=Element^.Data;
end;

Function list_next(Element: PListElement): PListElement;
Begin
  list_next:=Element^.Next;
end;

Procedure list_iterate(var List: TLinkedListHandle; Iterator: TListIteratorFunction; p: Pointer);
var
 k: integer;
 tmp: PListElement;
 size: integer;
Begin
  Assert(Assigned(Iterator));
  size := list_size(list) - 1;

  if list.head = nil then
    exit;

  tmp := list.head;
  if (iterator(tmp^.data, p) = 0) then
    exit;
  for k:=0 to size - 1 do
    Begin
    tmp := tmp^.next;
    if (iterator(tmp^.data, p) = 0) then
      exit;
    end;
end;



end.
