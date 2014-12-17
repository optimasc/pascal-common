{
    $Id$
    Copyright (c) 2014 by Carl Eric Codere

    Data structure testing implementation

    See License.txt for more information on the licensing terms
    for this source code.
    
}
{**
    @author(Carl Eric Codere)
}
{==== Compiler directives ===========================================}
{$B-} { Full boolean evaluation          }
{$I+} { IO Checking                      }
{$F+} { FAR routine calls                }
{$P-} { Implicit open strings            }
{$T-} { Typed pointers                   }
{$V+} { Strict VAR strings checking      }
{$X+} { Extended syntax                  }
{$IFNDEF TP}
 {$C+} { Assertions on                   }
 {$H+} { Memory allocated strings        }
 {$DEFINE ANSISTRINGS}
 {$J+} { Writeable constants             }
 {$METHODINFO OFF} 
{$ENDIF}
{====================================================================}
Unit testdata;


interface


{** Tests the list implementation }
Procedure test_List;
{** Tests the hash table static implementation }
Procedure test_hash_table_static;
{** Tests the hash table dynamic implementation }
Procedure test_hash_table_dynamic;

Function generateString(maxLength: integer): PAnsiChar;

implementation

Uses SysUtils, list, hashtab;



const
  char_sample: PAnsiChar =
  'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor'+
  'incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis'+
  'nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat'+
  'Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore'+
  'eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident,'+
  'sunt in culpa qui officia deserunt mollit anim id est laborum.';

 CONST_KEY = 'Canada';

 HASH_DYNAMIC_ENTRIES = 8;


  strings: Array[0..9] of PAnsiChar =
  (
    'String 1',
    'String 2',
    'String 3',
    'String 4',
    'String 5',
    'String 6',
    'String 7',
    'String 8',
    'String 9',
    'String 10'
  );


  {*********** hash table testing ********}
 HASH_ENTRIES  = 13;
 hash_keys: array[0..HASH_ENTRIES - 1] of PAnsiChar =
 (
  'ynKnemuz',
  'YctJgqZL',
  'T66TL1yv',
  'w9r5OA8S',
  'WTa6MgAS',
  'fu3VqGyB',
  'iGvj7XKd',
  '664cqf8H',
  'niVmk3GF',
  '2K8Uj6Wj',
  'USNbeP0K',
  'ky2BK4pB',
  'MPg2almN'
  );

  hash_values: array[0..HASH_ENTRIES - 1] of PAnsiChar =
(
  'otNhu8YXP5bKJgosNXaqX5oxVwW0uASS',
  'MQw9T0JpOpHjdzRhgAEri9lLf6P4_Zus',
  'uQbNkvqZwSm5t3tFrE8ad8D4HpEiR3ED',
  'abvTVYb_RdAXqpF9ndarGf0n1cLkp8b0',
  'A9xvdJEkYK9OyOyzgTs9nqPjysWhVCS3',
  'vFu_kz5aZxjwa0mFB_L9vXsWqjLZsayq',
  '1YnKDZssO31h1RGepzDoMCpxi5_PP3Zd',
  'cKHt50Ea4JRaMfWo0CUDDf0uXGrB1CRE',
  'p8gdhvvJk8HUQEBOiz4rBI3myHyqU3ea',
  'lK6f1lBvTgFRbc2CHCz7cJ4L7nE6pNz3',
  'EN05sq0lwejH1TRh7XbUx7etIQ0bP8mL',
  'v_3zA43cmab46qo6dFubspJwzOJjoSCb',
  'BW8D9GU4qZvlGtZ67X1LrTLjWAGlgCRe'
);

{ To be used to indicate if we have iterated through all elements of
  the hash table.
 }
hash_traversed: array[0..HASH_ENTRIES - 1] of integer =
(
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0,
 0
);


Function generateString(maxLength: integer): PAnsiChar;
var
   s: PAnsiChar;
   newLength: integer;
   sampleLength: integer;
   i,j: Integer;
Begin

 s := nil;
 GetMem(s,maxLength+sizeof(AnsiChar));
 {* length to copy *}
 sampleLength := strlen(PAnsiChar(char_sample));
 if sampleLength > maxLength then
 Begin
	strlcopy(s,char_sample,maxLength);
	s[maxLength] := #0;
        generateString := s;
        exit;
 end;

 {* We must copy the data more than once *}
 j := 0;
 for i:=0 to maxLength - 1 do
 Begin
    s[i] := char_sample[j];
    Inc(J);

	 {** Would overflow, reset counter to first value *}
	 if (j >= sampleLength) then
		 j := 0;
 end;
 s[maxLength] := #0;
 generateString:=s;
end;


  Function List_Iterator(Data: Pointer; p: Pointer): Integer;
  var
    ctr: pinteger;
  Begin
    ctr  := Pinteger(p);

    assert(strcomp(strings[ctr^],PAnsiChar(data))=0);
    ctr^ := ctr^ - 1;
    List_Iterator := 1;
  end;

  procedure Test_List;
   var
      List: TLinkedListHandle;
      i: integer;
      counter: integer;
      str: PAnsiChar;
      ListElement: PListElement;
   Begin
     WriteLn('Testing linked list routines...');

     list_init(list,nil);
     {** Test: list_size() *}
     assert(list_size(list)=0);

     Assert(list_get_head_node(list)=nil);
     Assert(list_get_tail_node(list)=nil);


     {** Test: list_add() *}
     for i := 0 to 7 do
      Begin
     	list_add(list,strings[i]);
      end;
     {** Retrieve the elements from the list }
     {** Test: list_size() *}
     assert(list_size(list)=8);
     {** Test: list_get() *}
     for i := 0 to 7 do
     Begin
     	str := PAnsiChar(list_get(list,i));
     	{ In the linked list we created everything is added in reverse order }
     	assert(strcomp(str,strings[7-i])=0);
     end;

     i:=0;
     ListElement := list_get_head_node(list);
     while Assigned(ListElement) do
      Begin
         str := PAnsiChar(list_data(listElement));
       	 assert(strcomp(str,strings[7-i])=0);
         ListElement:=list_next(ListElement);
         Inc(i);
      end;



     { Check the iteration routine }
     counter := 7;
     list_iterate(list,{$ifndef delphi}@{$endif}list_iterator,@counter);

     {!!!! ADDED }
     Assert(list_remove(list,PAnsiChar('hello'))=EXIT_FAILURE);
     assert(list_remove(list,strings[5])=EXIT_SUCCESS);
     assert(list_size(list)=7);

     list_destroy(list);

   end;


   {************** Hash testing *****************}
   Function hash_pjw(const key: Pointer): Longword;
   var
     Ptr: PAnsiChar;
     val: longword;
     tmp: longword;
   Begin
      val:=0;
      ptr:=PAnsiChar(key);

   while (ptr^ <> #00) do
     Begin
      val := val shl 4;
      val := val + longword(ptr^);
      tmp := val and (longword($f0000000));

      if tmp <> 0 then
        Begin
         val := val xor (tmp shr 24);
         val := val xor tmp;
        end;
      Inc(Ptr);
     end;
     hash_pjw:=val;
   end;



   Function hash_match(const key1: Pointer; const Key2: Pointer): Boolean;
   var
      res: Integer;
   Begin
        hash_match := False;
        res := strcomp(key1,key2);
   	if (res = 0) then
            hash_match := True;
   end;

   Function hash_iterator(key: Pointer; Data: Pointer; P: Pointer): Integer;
   var
    i: integer;
   Begin
   	{ Search for a match }
        for i:=0 to HASH_ENTRIES - 1 do
   	Begin
   		if (strcomp(key,hash_keys[i])=0) then
   		Begin
   			if (strcomp(data,hash_values[i])=0) then
   			Begin
   				hash_traversed[i] := 1;
   				hash_iterator:=1;
   			end;
   		end;
   	end;
   	hash_iterator:=1;
   end;



   Procedure test_hash_table_static;
   var
     result: integer;
     htbl: THashTableHandle;
     ptr: Pointer;
     data: PansiChar;
     i: integer;
     dynamic_key: PAnsiChar;
     dynamic_value: PAnsiChar;
   Begin

      dynamic_key  := 'DynamicKey';
      dynamic_value := 'DynamicValue';

      { Initializes a hash table }
      result := hashtab_init(htbl, 8, {$ifdef fpc}@{$endif}hash_pjw, {$ifdef fpc}@{$endif}hash_match, nil, nil);
      assert(result = EXIT_SUCCESS);

      { Look for empty value that is certainly not in the table }
      ptr := hashtab_lookup(htbl,PAnsiChar('Canada'));
      assert(ptr = nil);

      for i := 0 to HASH_ENTRIES - 1 do
      Begin
   	 hashtab_insert(htbl, hash_keys[i], hash_values[i]);
      end;
      { Look for empty value that is certainly not in the table }
      ptr := hashtab_lookup(htbl,PAnsiChar('Canada'));
      assert(ptr = nil);

      { Verfiy if we iterate through all items in the hash table. }
      hashtab_iterate(htbl,{$ifdef fpc}@{$endif}hash_iterator,nil);
      { Verify if we have iterated through all items }
      for i := 0 to HASH_ENTRIES - 1 do
      Begin
   	 assert(hash_traversed[i]=1);
      end;
      { Lookup for all keys and check if we can find them as well as the }
      for i := 0 to HASH_ENTRIES - 1 do
      Begin
         data := hashtab_lookup(htbl,hash_keys[i]);
   	 assert(strcomp(data,hash_values[i])=0);
      end;
      i := hashtab_size(htbl);
      assert(i = 13);

      { Add a dynamic key entry }
      hashtab_insert(htbl, dynamic_key, dynamic_value);
      i := hashtab_size(htbl);
      assert(i = 14);

      { Remove a key entry from the hash table }
      data :=  hashtab_remove(htbl,dynamic_key);
      data := hashtab_lookup(htbl,dynamic_value);
      assert(data = nil);

      { Lookup for all keys and check if we can find them as well as the }
      for i := 0 to HASH_ENTRIES - 1 do
      Begin
   	 data := hashtab_lookup(htbl,hash_keys[i]);
   	 assert(strcomp(data,hash_values[i])=0);
      end;

      i := hashtab_size(htbl);
      assert(i = 13);
      hashtab_destroy(htbl);
   end;


Procedure destroy_data(data: Pointer);
Begin
   Freemem(Data,StrLen(PAnsiChar(data))+sizeof(AnsiChar));
end;

Procedure destroy_key(key: Pointer);
Begin
  Freemem(Key,StrLen(PAnsiChar(Key))+sizeof(AnsiChar));
end;



 Procedure test_hash_table_dynamic;
 var
    htbl: THashTableHandle;
    result: integer;
    Ptr: Pointer;
    tmpData: PAnsiChar;
    tmpKey: PAnsiChar;
    i: integer;
    len: integer;
    data: PAnsiChar;
    dynamicKey: PAnsiChar;
 Begin

    GetMem(dynamicKey,strlen(PAnsiChar(CONST_KEY))+sizeof(AnsiChar));
    strcopy(dynamicKey,'Canada');

    { Initializes a hash table }
    result := hashtab_init(htbl, 8, {$ifdef fpc}@{$endif}hash_pjw,
      {$ifdef fpc}@{$endif}hash_match, {$ifdef fpc}@{$endif}destroy_data, {$ifdef fpc}@{$endif}destroy_key);
    assert(result = EXIT_SUCCESS);

    { Look for empty value that is certainly not in the table }
    ptr := hashtab_lookup(htbl,PAnsiChar(CONST_KEY));
    assert(ptr = nil);
    len := strlen(PAnsiChar(char_sample));

    for i := 0 to HASH_DYNAMIC_ENTRIES - 1 do
    Begin
       hashtab_insert(htbl, generateString(i+1), generateString(16+2*i));
    end;
    { Look for empty value that is certainly not in the table }
    ptr := hashtab_lookup(htbl,PAnsiChar(CONST_KEY));
    assert(ptr = nil);

    { Add a dynamic key entry }
    hashtab_insert(htbl, dynamicKey, generateString(HASH_DYNAMIC_ENTRIES*8));
    i := hashtab_size(htbl);
    assert(i = (HASH_DYNAMIC_ENTRIES+1));

    { Remove a key entry from the hash table }
    tmpdata := generateString(HASH_DYNAMIC_ENTRIES*8);
    data := hashtab_lookup(htbl,PAnsiChar(CONST_KEY));
    { Verify if the value returned is really the one really returned }
    assert(strcomp(tmpdata,data)=0);
    data := hashtab_remove(htbl,PAnsiChar(CONST_KEY));
    assert(data = nil);
    data := hashtab_lookup(htbl,PAnsiChar(CONST_KEY));
    assert(data = nil);
    Freemem(tmpdata,StrLen(tmpData)+sizeof(AnsiChar));


    { Verfiy if we iterate through all items in the hash table. }
    // Lookup for all keys and check if we can find them as well as the
    for i:= 0 to HASH_DYNAMIC_ENTRIES - 1 do
    Begin
 	 tmpkey  := generateString(i+1);
 	 data := hashtab_lookup(htbl,tmpkey);
 	 tmpdata := generateString(16+2*i);
 	 assert(strcomp(data,tmpdata)=0);
         Freemem(tmpdata,strlen(tmpData)+sizeof(ansiChar));
         Freemem(tmpKey,strlen(tmpKey)+sizeof(ansiChar));
    end;
    i := hashtab_size(htbl);
    assert(i = HASH_DYNAMIC_ENTRIES);


    hashtab_destroy(htbl);
 end;


end.
