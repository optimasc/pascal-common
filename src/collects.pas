{
    $Id: collects.pas,v 1.7 2010-01-21 12:01:09 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Collections (Object style)
    
    See License.txt for more information on the licensing terms
    for this source code.
    
 **********************************************************************}
{** @author(Carl Eric Codere) 
    @abstract(Collection units)
    
    This routine contains collection objects, being quite
    similar to those included in the objects unit. The only
    difference being that they compile on all compiler
    targets.
    
}
Unit collects;

Interface

uses
  vpautils,
  fpautils,
  tpautils,
  dpautils,
  utils;




const
 MaxCollectionSize = 8192;
{---------------------------------------------------------------------------}
{                          TExtendedCollection ERROR CODES                          }
{---------------------------------------------------------------------------}
CONST
   coIndexError = -1;                                 { Index out of range }
   coOverflow   = -2;                                 { Overflow }


TYPE
  TItemList = Array [0..MaxCollectionSize - 1] Of Pointer;
  PItemList = ^TItemList;
  
    PStackItem = ^TStackItem;
    TStackItem = record
      next: PStackItem;
      data: pointer;
    end;

  {** @abstract(Stack object)
      This implement an object that is used as a LIFO stack
      containing pointers as data. 
  }
  PStack = ^TStack;
  TStack = object
    constructor init;
    destructor done;
    procedure push(p: pointer);
    function pop: pointer;
    function peek: pointer;
    function isEmpty: boolean;
  private
     head: PStackItem;
  end;
  
TYPE
  ProcedureType = Function(Item: Pointer): Boolean;
  ForEachProc = Procedure(Item: Pointer);

{ ******************************* REMARK ****************************** }
{    The changes here look worse than they are. The Integer simply   }
{  switches between Integers and LongInts if switched between 16 and 32 }
{  bit code. All existing code will compile without any changes.        }
{ ****************************** END REMARK *** Leon de Boer, 10May96 * }

   {** @abstract(Base collection object) }
   TExtendedCollection = OBJECT
         Items: PItemList;                            { Item list pointer }
         Count: Integer;                           { Item count }
         Limit: Integer;                           { Item limit count }
         Delta: Integer;                           { Inc delta size }
      CONSTRUCTOR Init (ALimit, ADelta: Integer);
      DESTRUCTOR Done;                                               Virtual;
      FUNCTION At (Index: Integer): Pointer;
      FUNCTION IndexOf (Item: Pointer): Integer;                  Virtual;
      FUNCTION LastThat (Test: Pointer): Pointer;
      FUNCTION FirstThat (Test: Pointer): Pointer;
      PROCEDURE Pack;
      PROCEDURE FreeAll;
      PROCEDURE DeleteAll;
      PROCEDURE Free (Item: Pointer);
      PROCEDURE Insert (Item: Pointer);                              Virtual;
      PROCEDURE Delete (Item: Pointer);
      PROCEDURE AtFree (Index: Integer);
      PROCEDURE FreeItem (Item: Pointer);                            Virtual;
      PROCEDURE AtDelete (Index: Integer);
      PROCEDURE ForEach (Action: Pointer);
      PROCEDURE SetLimit (ALimit: Integer);                       Virtual;
      PROCEDURE Error (Code, Info: Integer);                         Virtual;
      PROCEDURE AtPut (Index: Integer; Item: Pointer);
      PROCEDURE AtInsert (Index: Integer; Item: Pointer);
   END;
   PExtendedCollection = ^TExtendedCollection;

{---------------------------------------------------------------------------}
{          TExtendedSortedCollection OBJECT - SORTED COLLECTION ANCESTOR    }
{---------------------------------------------------------------------------}
TYPE
   {** @abstract(Base sorted collection object) }
   TExtendedSortedCollection = OBJECT (TExtendedCollection)
         Duplicates: Boolean;                         { Duplicates flag }
      CONSTRUCTOR Init (ALimit, ADelta: Integer);
      FUNCTION KeyOf (Item: Pointer): Pointer;                       Virtual;
      FUNCTION IndexOf (Item: Pointer): Integer;                  Virtual;
      FUNCTION Compare (Key1, Key2: Pointer): Integer;            Virtual;
      FUNCTION Search (Key: Pointer; Var Index: Integer): Boolean;Virtual;
      PROCEDURE Insert (Item: Pointer);                              Virtual;
   END;
   PExtendedSortedCollection = ^TExtendedSortedCollection;
   
   {** @abstract(String pointer collection object) 
   
       This collection accepts pointers to shortstrings
       as input. The data is not sorted.
   }
   TExtendedStringCollection = OBJECT (TExtendedCollection)
      PROCEDURE FreeItem (Item: Pointer); Virtual;
   END;
   PExtendedStringCollection = ^TExtendedStringCollection;
   

   {** @abstract(Sorted string pointer collection object) 
   
       This collection accepts pointers to shortstrings
       as input. The data is sorted as it is added in.
   }
   TExtendedSortedStringCollection = OBJECT (TExtendedSortedCollection)
      CONSTRUCTOR Init (ALimit, ADelta: Integer);
      FUNCTION Compare (Key1, Key2: Pointer): Integer;            Virtual;
      PROCEDURE FreeItem (Item: Pointer); Virtual;
   END;
   PExtendedSortedStringCollection = ^TExtendedSortedStringCollection;
   
   
  TLongintCollection = object(TExtendedCollection)
    procedure FreeItem(Item: pointer); virtual;
  end;
  
  
  const KEY_NO_FASTKEY = high(word);

  type
  TKeyType = (typ_element, typ_array);
  PKeyValueArrayItems = ^TKeyValueArrayItems;
  PKeyValueCollection = ^TKeyValueCollection;

  PKeyValue = ^TKeyValue;  
  TKeyValue = record
    key: pshortstring;
    fastkey: word;
    qualifiers: PKeyValueCollection;
    case typ:TKeyType of
     {** Contains an individual attribute }
     typ_element: (value: pchar);
     {** Contains a SEQ, ALT or BAG }
     typ_array: (collection : PKeyValueCollection);
  end;


  TKeyValueArrayItems = object(TExtendedCollection)
    procedure FreeItem(Item: pointer); virtual;
  end;


  TKeyValueCollection = Object(TExtendedSortedCollection)
      CONSTRUCTOR Init (ALimit, ADelta: Integer);
      Destructor done; virtual;
      FUNCTION Compare (Key1, Key2: Pointer): Integer;            Virtual;
      PROCEDURE FreeItem (Item: Pointer); Virtual;

      {** Returns the property value associated with this key string. If the
          property does not exist or is a type array of values,
          this routine returns nil }
      function getProperty(ns,key: string): pchar;
      {** Returns the property value associated with this key index.
          If the property does not exist or is a type array of values,
          this routine returns nil. It returns the first value that has
          this fastkey value.
      }
      function getPropertyByFastIndex(fastkey: integer): pchar;
      {** Returns the qualifier associated with this key string. If the
          property does not exist or is a type array of values,
          this routine returns nil, or if the qualifier does not exist,
          the returned value is also nil. }
      function getPropertyQualifier(ns,key: string; qualNS, qualName: string): pchar;


      {** Sets the property value to associate with this key and fastkey.

          It shall overwrite any other property with the same name and shall
          return the old value associated with this property (possibly truncated).
          If this property did not exist or if trying to set a value to
          an array of values, the return value will be nil.

          WARNING: There is no verification to determine if the fastKey value is
          not already allocated in this key collection. The fastKey value can be from
          0..65534.

          The return value should be copied, since it may be destroyed
          by another call to this method.

          @param(key Key name associated with this value)
          @param(fastkey Numeric identifier associated with this value, 65535 (KEY_NO_FASTKEY) if no fastKey association)
      }
      function setProperty(ns,key: string; fastkey: integer; value: pchar): pchar;
      {** Sets a qualifier to a specified element property.
      }
      function setPropertyQualifier(ns,key, qualNS, qualName: string; value: pchar): pchar;


      {** Deletes the specified property. This method deletes
          the specified property, which can either be a simply property or
          an array, in which it cases all its sub-elements are also deleted.

          @param(key Key name to delete)
          @returns(true if successfull deletion, otherwise false such as is
            this property does not exist)
      }

      function deleteProperty(ns,key: string): boolean;

      {** Deletes the specified qualifier of the specified property. }
      function deletePropertyQualifier(ns,key: string; qualNS, qualName: string): boolean;
(*
      {** Deletes the specified array item of the specified property }
      function deletePropertyArrayItem(key: string; index: integer): boolean;
*)
      {** Adds a value to a list of values of a specified key. If
          the array does not exist, it is first created.

          @param(key This is the key associated with this array)
          @param(value  Actual value of the element in the array list)
          @returns(The index of this element in the array)
      }
      function appendPropertyArrayItem(ns,key: string; value: pchar): integer;
      {** Returns the number of items in the value array of a specified
          key. Returns -1 if this key does not exist. If the value exists, 
          but is not array type, this will always return 1.
      }
      function getPropertyArrayItemCount(ns,key: string): integer;
      {** Returns the specified item in the value array at the specified index,
          starting from index 0. If this is not an array type key, and the
          key exists, it will always retun that key value, ignoring the
          index parameter. Returns nil if the key does not exist.
      }
      function getPropertyArrayItem(ns,key: string;index: integer): pchar;
(*      
      function setPropertyArrayItem(key: string;index:integer; value: pchar): pchar;
*)      

      function setPropertyArrayItemQualifier(ns, key: string; qualNS, qualName: string; index: integer; value: pchar): pchar;
      function getPropertyArrayItemQualifier(ns, key: string; qualNS, qualName: string; index: integer): pchar;


      {** Returns the key name associated with the specified index, the index starting at 0 to count -1. The
          returns an empty string if out of bounds. The index is an internal value and is not
          the same as the fastKey index.
      }
      function getKeyName(index: integer): string;
   private
      returnedProperty: pchar;
      function getIndex(key: string): integer;
      function getFastKeyIndex(fastkey: integer): integer;
   END;


Implementation

uses strings;


     procedure TLongintCollection.FreeItem(Item: pointer);
     begin
       { Longint's are not pointers! so no freeing of memory }
     end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       TExtendedCollection OBJECT METHODS                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TExtendedCollection--------------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                 }
{---------------------------------------------------------------------------}
CONSTRUCTOR TExtendedCollection.Init (ALimit, ADelta: Integer);
BEGIN
   Items:= nil;                            { Item list pointer }
   Count:= 0;                           { Item count }
   Limit := 0;
   Delta := ADelta;                                   { Set increment }
   SetLimit(ALimit);                                  { Set limit }
END;


{--TExtendedCollection--------------------------------------------------------------}
{  Done -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                 }
{---------------------------------------------------------------------------}
DESTRUCTOR TExtendedCollection.Done;
BEGIN
   FreeAll;                                           { Free all items }
   SetLimit(0);                                       { Release all memory }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  At -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                   }
{---------------------------------------------------------------------------}
FUNCTION TExtendedCollection.At (Index: Integer): Pointer;
BEGIN
   If (Index < 0) OR (Index >= Count) Then Begin      { Invalid index }
     Error(coIndexError, Index);                      { Call error }
     At := Nil;                                       { Return nil }
   End Else At := Items^[Index];                      { Return item }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  IndexOf -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB              }
{---------------------------------------------------------------------------}
FUNCTION TExtendedCollection.IndexOf (Item: Pointer): Integer;
VAR I: Integer;
BEGIN
   If (Count>0) Then Begin                            { Count is positive }
     For I := 0 To Count-1 Do                         { For each item }
       If (Items^[I]=Item) Then Begin                 { Look for match }
         IndexOf := I;                                { Return index }
         Exit;                                        { Now exit }
       End;
   End;
   IndexOf := -1;                                     { Return index }
END;


{--TExtendedCollection--------------------------------------------------------------}
{  LastThat -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB             }
{---------------------------------------------------------------------------}
FUNCTION TExtendedCollection.LastThat (Test: Pointer): Pointer;

VAR I: LongInt;
    Proc : ProcedureType;

BEGIN
   Proc := ProcedureType(Test);
   For I := Count DownTo 1 Do
     Begin                   { Down from last item }
       IF Proc(Items^[I-1]) THEN
       Begin          { Test each item }
         LastThat := Items^[I-1];                     { Return item }
         Exit;                                        { Now exit }
       End;
     End;
   LastThat := Nil;                                   { None passed test }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  FirstThat -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB            }
{---------------------------------------------------------------------------}
FUNCTION TExtendedCollection.FirstThat (Test: Pointer): Pointer;
VAR I: LongInt;
    Proc : ProcedureType;
BEGIN
   Proc := ProcedureType(Test);
   For I := 1 To Count Do Begin                       { Up from first item }
     IF Proc(Items^[I-1]) THEN
       Begin          { Test each item }
       FirstThat := Items^[I-1];                      { Return item }
       Exit;                                          { Now exit }
     End;
   End;
   FirstThat := Nil;                                  { None passed test }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  Pack -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                 }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.Pack;
VAR I, J: Integer;
BEGIN
   I := 0;                                            { Initialize dest }
   J := 0;                                            { Intialize test }
   While (I<Count) AND (J<Limit) Do Begin             { Check fully packed }
     If (Items^[J]<>Nil) Then Begin                   { Found a valid item }
       If (I<>J) Then Begin
         Items^[I] := Items^[J];                      { Transfer item }
         Items^[J] := Nil;                            { Now clear old item }
       End;
       Inc(I);                                        { One item packed }
     End;
     Inc(J);                                          { Next item to test }
   End;
   If (I<Count) Then Count := I;                      { New packed count }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  FreeAll -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.FreeAll;
VAR I: Integer;
BEGIN
   for I := Count-1 downto 0 do
    FreeItem(At(I));
   Count := 0;                                        { Clear item count }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  DeleteAll -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB            }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.DeleteAll;
BEGIN
   Count := 0;                                        { Clear item count }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  Free -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                 }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.Free (Item: Pointer);
BEGIN
   Delete(Item);                                      { Delete from list }
   FreeItem(Item);                                    { Free the item }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  Insert -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB               }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.Insert (Item: Pointer);
BEGIN
   AtInsert(Count, Item);                             { Insert item }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  Delete -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB               }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.Delete (Item: Pointer);
BEGIN
   AtDelete(IndexOf(Item));                           { Delete from list }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  AtFree -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB               }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.AtFree (Index: Integer);
VAR Item: Pointer;
BEGIN
   Item := At(Index);                                 { Retreive item ptr }
   AtDelete(Index);                                   { Delete item }
   FreeItem(Item);                                    { Free the item }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  FreeItem -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.FreeItem (Item: Pointer);
BEGIN
  RunError(211);
END;

{--TExtendedCollection--------------------------------------------------------------}
{  AtDelete -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.AtDelete (Index: Integer);
BEGIN
   If (Index >= 0) AND (Index < Count) Then Begin     { Valid index }
     Dec(Count);                                      { One less item }
     If (Count>Index) Then Move(Items^[Index+1],
      Items^[Index], (Count-Index)*Sizeof(Pointer));  { Shuffle items down }
   End Else Error(coIndexError, Index);               { Index error }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  ForEach -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB              }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.ForEach (Action: Pointer);
VAR I: LongInt;
    Proc : ForEachProc;
BEGIN
   Proc := ForEachProc(Action);
   For I := 1 To Count Do                             { Up from first item }
    Proc(Items^[I-1]);   { Call with each item }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  SetLimit -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.SetLimit (ALimit: Integer);
VAR
  AItems: PItemList;
BEGIN
   If (ALimit < Count) Then
     ALimit := Count;
   If (ALimit > MaxCollectionSize) Then
     ALimit := MaxCollectionSize;
   If (ALimit <> Limit) Then
     Begin
       If (ALimit = 0) Then
         AItems := Nil
       Else
         Begin
           GetMem(AItems, ALimit * SizeOf(Pointer));
           If (AItems<>Nil) Then
             FillChar(AItems^,ALimit * SizeOf(Pointer), #0);
         End;
       If (AItems<>Nil) OR (ALimit=0) Then
         Begin
           If (AItems <>Nil) AND (Items <> Nil) Then
             Move(Items^, AItems^, Count*SizeOf(Pointer));
           If (Limit <> 0) AND (Items <> Nil) Then
             FreeMem(Items, Limit * SizeOf(Pointer));
         end;
       Items := AItems;
       Limit := ALimit;
     End;
END;

{--TExtendedCollection--------------------------------------------------------------}
{  Error -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.Error (Code, Info: Integer);
BEGIN
   RunError(212 - Code);                              { Run error }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  AtPut -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.AtPut (Index: Integer; Item: Pointer);
BEGIN
   If (Index >= 0) AND (Index < Count) Then           { Index valid }
     Items^[Index] := Item                            { Put item in index }
     Else Error(coIndexError, Index);                 { Index error }
END;

{--TExtendedCollection--------------------------------------------------------------}
{  AtInsert -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB             }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedCollection.AtInsert (Index: Integer; Item: Pointer);
VAR I: Integer;
BEGIN
   If (Index >= 0) AND (Index <= Count) Then Begin    { Valid index }
     If (Count=Limit) Then SetLimit(Limit+Delta);     { Expand size if able }
     If (Limit>Count) Then Begin
       If (Index < Count) Then Begin                  { Not last item }
         For I := Count-1 DownTo Index Do               { Start from back }
           Items^[I+1] := Items^[I];                  { Move each item }
       End;
       Items^[Index] := Item;                         { Put item in list }
       Inc(Count);                                    { Inc count }
     End Else Error(coOverflow, Index);               { Expand failed }
   End Else Error(coIndexError, Index);               { Index error }
END;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     TExtendedStringCollection OBJECT METHODS                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
PROCEDURE TExtendedStringCollection.FreeItem (Item: Pointer);
var
 p: PshortString;
BEGIN
   p:=PShortString(Item);
   StringDispose(p);
END;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                       TExtendedSortedCollection OBJECT METHODS                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TExtendedSortedCollection--------------------------------------------------------}
{  Init -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                 }
{---------------------------------------------------------------------------}
CONSTRUCTOR TExtendedSortedCollection.Init (ALimit, ADelta: Integer);
BEGIN
   Inherited Init(ALimit, ADelta);                    { Call ancestor }
   Duplicates := False;                               { Clear flag }
END;


{--TExtendedSortedCollection--------------------------------------------------------}
{  KeyOf -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB                }
{---------------------------------------------------------------------------}
FUNCTION TExtendedSortedCollection.KeyOf (Item: Pointer): Pointer;
BEGIN
   KeyOf := Item;                                     { Return item as key }
END;

{--TExtendedSortedCollection--------------------------------------------------------}
{  IndexOf -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB              }
{---------------------------------------------------------------------------}
FUNCTION TExtendedSortedCollection.IndexOf (Item: Pointer): Integer;
VAR I, J: Integer;
BEGIN
   J := -1;                                           { Preset result }
   If Search(KeyOf(Item), I) Then Begin               { Search for item }
     If Duplicates Then                               { Duplicates allowed }
       While (I < Count) AND (Item <> Items^[I]) Do
         Inc(I);                                      { Count duplicates }
     If (I < Count) Then J := I;                      { Index result }
   End;
   IndexOf := J;                                      { Return result }
END;

{--TExtendedSortedCollection--------------------------------------------------------}
{  Compare -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB              }
{---------------------------------------------------------------------------}
FUNCTION TExtendedSortedCollection.Compare (Key1, Key2: Pointer): Integer;
BEGIN
   RunError(211);
   Compare:=0;
END;

{--TExtendedSortedCollection--------------------------------------------------------}
{  Search -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB               }
{---------------------------------------------------------------------------}
FUNCTION TExtendedSortedCollection.Search (Key: Pointer; Var Index: Integer): Boolean;
VAR L, H, I, C: Integer;
BEGIN
   Search := False;                                   { Preset failure }
   L := 0;                                            { Start count }
   H := Count - 1;                                    { End count }
   While (L <= H) Do Begin
     I := (L + H) SHR 1;                              { Mid point }
     C := Compare(KeyOf(Items^[I]), Key);             { Compare with key }
     If (C < 0) Then L := I + 1 Else Begin            { Item to left }
       H := I - 1;                                    { Item to right }
       If C = 0 Then Begin                            { Item match found }
         Search := True;                              { Result true }
         If NOT Duplicates Then L := I;               { Force kick out }
       End;
     End;
   End;
   Index := L;                                        { Return result }
END;

{--TExtendedSortedCollection--------------------------------------------------------}
{  Insert -> Platforms DOS/DPMI/WIN/OS2 - Checked 22May96 LdB               }
{---------------------------------------------------------------------------}
PROCEDURE TExtendedSortedCollection.Insert (Item: Pointer);
VAR I: Integer;
BEGIN
   If NOT Search(KeyOf(Item), I) OR Duplicates Then   { Item valid }
     AtInsert(I, Item);                               { Insert the item }
END;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     TExtendedSortedStringCollection OBJECT METHODS                      }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}

{--TExtendedSortedStringCollection--------------------------------------------------------}
{  Compare -> Platforms DOS/DPMI/WIN/OS2 - Checked 21Aug97 LdB              }
{---------------------------------------------------------------------------}
FUNCTION TExtendedSortedStringCollection.Compare (Key1, Key2: Pointer): integer;
VAR I, J: integer; P1, P2: PShortString;
BEGIN
   P1 := PShortString(Key1);                               { String 1 pointer }
   P2 := PShortString(Key2);                               { String 2 pointer }
   If (Length(P1^)<Length(P2^)) Then J := Length(P1^)
     Else J := Length(P2^);                           { Shortest length }
   I := 1;                                            { First character }
   While (I<J) AND (P1^[I]=P2^[I]) Do Inc(I);         { Scan till fail }
   If (I=J) Then Begin                                { Possible match }
   { * REMARK * - Bug fix   21 August 1997 }
     If (P1^[I]<P2^[I]) Then Compare := -1 Else       { String1 < String2 }
       If (P1^[I]>P2^[I]) Then Compare := 1 Else      { String1 > String2 }
       If (Length(P1^)>Length(P2^)) Then Compare := 1 { String1 > String2 }
         Else If (Length(P1^)<Length(P2^)) Then       { String1 < String2 }
           Compare := -1 Else Compare := 0;           { String1 = String2 }
   { * REMARK END * - Leon de Boer }
   End Else If (P1^[I]<P2^[I]) Then Compare := -1     { String1 < String2 }
     Else Compare := 1;                               { String1 > String2 }
END;

PROCEDURE TExtendedSortedStringCollection.FreeItem (Item: Pointer);
var
 p: PshortString;
BEGIN
   p:=PShortString(Item);
   StringDispose(p);
END;

CONSTRUCTOR TExtendedSortedStringCollection.Init (ALimit, ADelta: Integer);
Begin
  Inherited Init(ALimit,ADelta);
end;


{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                     TKeyValueCollection OBJECT METHODS                    }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
FUNCTION TKeyValueCollection.Compare (Key1, Key2: Pointer): integer;
VAR I, J: integer; P1, P2: PShortString;
BEGIN
   P1 := PShortString(PKeyValue(Key1)^.key);                               { String 1 pointer }
   P2 := PShortString(PKeyValue(Key2)^.Key);                               { String 2 pointer }
   If (Length(P1^)<Length(P2^)) Then J := Length(P1^)
     Else J := Length(P2^);                           { Shortest length }
   I := 1;                                            { First character }
   While (I<J) AND (P1^[I]=P2^[I]) Do Inc(I);         { Scan till fail }
   If (I=J) Then Begin                                { Possible match }
   { * REMARK * - Bug fix   21 August 1997 }
     If (P1^[I]<P2^[I]) Then Compare := -1 Else       { String1 < String2 }
       If (P1^[I]>P2^[I]) Then Compare := 1 Else      { String1 > String2 }
       If (Length(P1^)>Length(P2^)) Then Compare := 1 { String1 > String2 }
         Else If (Length(P1^)<Length(P2^)) Then       { String1 < String2 }
           Compare := -1 Else Compare := 0;           { String1 = String2 }
   { * REMARK END * - Leon de Boer }
   End Else If (P1^[I]<P2^[I]) Then Compare := -1     { String1 < String2 }
     Else Compare := 1;                               { String1 > String2 }
END;

destructor TKeyValueCollection.done;
begin
  if assigned(returnedProperty) then
    strdispose(returnedProperty);
  Inherited Done;

end;



PROCEDURE TKeyValueCollection.FreeItem (Item: Pointer);
var
 p: PKeyValue;
BEGIN
   p:=PKeyValue(Item);
   if assigned(p) then
     begin
        if p^.typ = typ_element then
          begin
           if assigned(p^.value) then
             strdispose(p^.value);
          end
        else
          begin
            if assigned(p^.collection) then
               Dispose(p^.collection,done);
          end;
       if assigned(p^.key) then
         stringdispose(p^.key);
       if assigned(p^.qualifiers) then
         begin
           Dispose(p^.qualifiers, done);
           p^.qualifiers:=nil;
         end;
       dispose(p);
     end;
END;


{** This returns the index in the collection of the element
    associated with this key, or -1 if not found.
}
function TKeyValueCollection.getIndex(key: string): integer;
var
 KeyValue: PkeyValue;
 i: integer;
begin
  getIndex:=-1;
  if count > 0 then
    begin
      for i:=0 to count - 1 do
        begin
           KeyValue:=PKeyValue(At(i));
           if KeyValue^.Key^ = key then
             begin
                getIndex:=i;
                exit;
             end;
        end;
    end;
end;


{** This returns the index in the collection of the element
    associated with this fast key value, or -1 if not found.
}
function TKeyValueCollection.getFastKeyIndex(fastkey: integer): integer;
var
 KeyValue: PkeyValue;
 i: integer;
begin
  getFastKeyIndex:=-1;
  if fastKey = KEY_NO_FASTKEY then
    exit;
  if count > 0 then
    begin
      for i:=0 to count - 1 do
        begin
           KeyValue:=PKeyValue(At(i));
           { Always skip elements with no FAST ID }
           if KeyValue^.FastKey = KEY_NO_FASTKEY then
             continue;
           if KeyValue^.FastKey = fastkey then
             begin
                getFastKeyIndex:=i;
                exit;
             end;
        end;
    end;
end;



function TKeyValueCollection.getKeyName(index: integer): string;
var
 KeyValue: PKeyValue;
begin
  getKeyName:='';
  if (index < 0) or (index > count-1) then
    exit;
  KeyValue:=PKeyValue(At(index));
  getKeyName:=KeyValue^.key^;

  end;


{** This returns the property associated with this key. If there
    is no such key, then return nil.
}
function TKeyValueCollection.getProperty(ns,key: string): pchar;
var
 idx: integer;
 KeyValue: PKeyValue;
begin
  getProperty:=nil;
  idx:=getIndex(key);
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  if KeyValue^.typ <> typ_element then
    exit;
  getProperty:=KeyValue^.value;
end;


{** This returns the property associated with this index. If there
    is no such key, then return nil.
}
function TKeyValueCollection.getPropertyByFastIndex(fastkey: integer): pchar;
var
 idx: integer;
 KeyValue: PKeyValue;
begin
  getPropertyByFastIndex:=nil;
  idx:=getFastKeyIndex(fastkey);
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  if KeyValue^.typ <> typ_element then
    exit;
  getPropertyByFastIndex:=KeyValue^.value;
end;


function TKeyValueCollection.setProperty(ns,key: string;fastkey: integer; value: pchar): pchar;
var
 Prop: pchar;
 attr: shortstring;
 KeyValue: PKeyValue;
 idx: integer;
begin
  setProperty:=nil;
  idx:=getIndex(key);
  if idx <> -1 then
    begin
      KeyValue:=PKeyValue(At(idx));
      { This is an array of values, so you are using the wrong API }
      if KeyValue^.typ = typ_array then
        exit;
      if assigned(returnedProperty) then
        begin
          strdispose(returnedProperty);
          returnedProperty:=nil;
        end;
      returnedProperty:=strnew(KeyValue^.value);
      setProperty:=returnedProperty;
      Free(At(idx));
    end;
  new(KeyValue);
  KeyValue^.key:=stringdup(key);
  KeyValue^.value:=strnew(value);
  KeyValue^.typ:=typ_element;
  KeyValue^.Qualifiers:=nil;
  KeyValue^.fastkey:=FastKey;
  Insert(KeyValue);
end;

function TKeyValueCollection.appendPropertyArrayItem(ns,key: string; value: pchar): integer;
var
 KeyArray: PKeyValue;
 KeyValue: PKeyValue;
 idx: integer;
begin
  appendPropertyArrayItem:=-1;
  idx:=getIndex(key);
  { Not allowed to recreate an array that already exists }
  if idx <> -1 then
   begin
     KeyArray:=PKeyValue(At(idx));
   end
  else
   begin
     new(KeyArray);
     KeyArray^.typ:=typ_array;
     KeyArray^.key:=stringdup(key);
     KeyArray^.Qualifiers:=nil;
     KeyArray^.FastKey:=KEY_NO_FASTKEY;
     New(KeyArray^.collection,init(32,32));
     Insert(KeyArray);
   end;
  new(KeyValue);
  KeyValue^.key:=stringdup(key);
  KeyValue^.value:=strnew(value);
  KeyValue^.typ:=typ_element;
  KeyValue^.Qualifiers:=nil;
  KeyArray^.collection^.Insert(KeyValue);
  { The index is always the last element in the collection }
  appendPropertyArrayItem:=KeyArray^.collection^.count - 1;
end;



function TKeyValueCollection.getPropertyArrayItemCount(ns,key: string): integer;
var
 idx:integer;
 KeyValue: PKeyValue;
begin
  getPropertyArrayItemCount:=-1;
  idx:=getIndex(key);
  { Not found, then simply return -1 }
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  if KeyValue^.typ=typ_element then
    begin
      getPropertyArrayItemCount:=1;
      exit;
    end;
  getPropertyArrayItemCount:=KeyValue^.collection^.Count;
end;


function TKeyValueCollection.getPropertyArrayItem(ns,key: string;index: integer): pchar;
var
 idx:integer;
 KeyValue: PKeyValue;
 KeyElement: PKeyValue;
begin
  getPropertyArrayItem:=nil;
  idx:=getIndex(key);
  { Not found, then simply return nil }
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  { Return always the property if this is not an array element }
  if KeyValue^.typ=typ_element then
    begin
      getPropertyArrayItem:=getProperty(ns,key);
      exit;
    end;
  if index > (KeyValue^.collection^.Count-1) then
    exit;
  KeyElement:=KeyValue^.collection^.at(index);
  getPropertyArrayItem:=KeyElement^.value;
end;

(*
function TKeyValueCollection.setPropertyArrayItem(key: string;index:integer; value: pchar): pchar;
begin
end;*)

function TKeyValueCollection.deleteProperty(ns, key : string):Boolean;
 var
  idx: integer;
 begin
  deleteProperty:=false;
  idx:=getIndex(key);
  { Not found, then simply return nil }
  if idx = -1 then
    exit;
  AtFree(idx);
  deleteProperty:=true;  
 end;

(*
function TKeyValueCollection.deletePropertyArrayItem(key: string; index: integer):Boolean;
 begin
 end;*)

function TKeyValueCollection.setPropertyQualifier(ns,key, qualNS, qualName: string; value: pchar): pchar;
var
 Prop: pchar;
 KeyValue: PKeyValue;
 idx: integer;
begin
  setPropertyQualifier:=nil;
  idx:=getIndex(key);
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));

  if not assigned(KeyValue^.Qualifiers) then
    New(KeyValue^.Qualifiers, init(1,4));
  setPropertyQualifier:=keyValue^.Qualifiers^.setProperty(qualNS,qualName,KEY_NO_FASTKEY,value);
end;


function TKeyValueCollection.getPropertyQualifier(ns,key: string; qualNS, qualName: string): pchar;
var
 Prop: pchar;
 KeyValue: PKeyValue;
 idx: integer;
begin
  getPropertyQualifier:=nil;
  idx:=getIndex(key);
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  if not assigned(KeyValue^.Qualifiers) then
    exit;
  getPropertyQualifier:=keyValue^.Qualifiers^.getProperty(qualNS,qualName);
end;


function TKeyValueCollection.deletePropertyQualifier(ns,key: string; qualNS, qualName: string): boolean;
var
 Prop: pchar;
 KeyValue: PKeyValue;
 idx: integer;
begin
  deletePropertyQualifier:=false;
  idx:=getIndex(key);
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  if not assigned(KeyValue^.Qualifiers) then
    exit;
  deletePropertyQualifier:=keyValue^.Qualifiers^.deleteProperty(qualNS,qualName);
end;



function TKeyValueCollection.setPropertyArrayItemQualifier(ns, key: string; qualNS, qualName: string; index: integer; value: pchar): pchar;
var
 idx:integer;
 KeyValue: PKeyValue;
 KeyElement: PKeyValue;
begin
  setPropertyArrayItemQualifier:=nil;
  idx:=getIndex(key);
  { Not found, then simply return nil }
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  { Return always the property if this is not an array element }
  if KeyValue^.typ=typ_element then
    begin
      exit;
    end;
  if index > (KeyValue^.collection^.Count-1) then
    exit;
  KeyElement:=KeyValue^.collection^.at(index);
  KeyValue^.collection^.SetPropertyQualifier('',KeyElement^.value,qualNS,qualName,value);
end;


function TKeyValueCollection.getPropertyArrayItemQualifier(ns, key: string; qualNS, qualName: string; index: integer): pchar;
var
 idx:integer;
 KeyValue: PKeyValue;
 KeyElement: PKeyValue;
begin
  getPropertyArrayItemQualifier:=nil;
  idx:=getIndex(key);
  { Not found, then simply return nil }
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  { Return always the property if this is not an array element }
  if KeyValue^.typ=typ_element then
    begin
      exit;
    end;
  if index > (KeyValue^.collection^.Count-1) then
    exit;
  KeyElement:=KeyValue^.collection^.at(index);
  KeyValue^.collection^.GetPropertyQualifier('',KeyElement^.value,qualNS,qualName);
end;



CONSTRUCTOR TKeyValueCollection.Init (ALimit, ADelta: Integer);
Begin
  Inherited Init(ALimit,ADelta);
end;

{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}
{                              TKeyValueCollection                          }
{+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++}


procedure TKeyValueArrayItems.FreeItem(Item: pointer);
var
 p: PKeyValue;
BEGIN
   p:=PKeyValue(Item);
   if assigned(p) then
     begin
        if p^.typ = typ_element then
          begin
           if assigned(p^.value) then
             strdispose(p^.value);
          end
        else
          begin
            if assigned(p^.collection) then
               Dispose(p^.collection,done);
          end;
       if assigned(p^.key) then
         stringdispose(p^.key);
       dispose(p);
     end;
END;


{*****************************************************************************
                                 Stack
*****************************************************************************}



constructor TStack.init;
begin
  head := nil;
end;

procedure TStack.push(p: pointer);
var s: PStackItem;
begin
  new(s);
  s^.data := p;
  s^.next := head;
  head := s;
end;

function TStack.pop: pointer;
var s: PStackItem;
begin
  pop := peek;
  if assigned(head) then
    begin
      s := head^.next;
      dispose(head);
      head := s;
    end
end;

function TStack.peek: pointer;
begin
  if not isEmpty then
    peek := head^.data
  else peek := NIL;
end;

function TStack.isEmpty: boolean;
begin
  isEmpty := head = nil;
end;

destructor TStack.done;
var temp: PStackItem;
begin
  while head <> nil do
    begin
      temp := head^.next;
      dispose(head);
      head := temp;
    end;
end;


End.
{
  $Log: not supported by cvs2svn $
  Revision 1.6  2005/07/20 03:14:39  carl
   + Added TLongintCollection

  Revision 1.5  2004/11/19 01:37:25  carl
    + more documentation

  Revision 1.4  2004/11/18 04:23:41  carl
    + added non-sorted string collection

  Revision 1.3  2004/11/17 04:01:07  carl
    + Sorted string collection object

  Revision 1.2  2004/07/15 01:03:10  carl
    + Added Stack object

  Revision 1.1  2004/07/05 02:38:14  carl
    + add collects unit
    + some small changes in cases of identifiers

}