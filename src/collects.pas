{
    $Id: collects.pas,v 1.11 2012-10-24 15:13:12 Carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Collections (Object style)
    
    See license.txt for more information on the licensing terms
    for this source code.
    
 **********************************************************************}
{** @author(Carl Eric Codere) 
    @abstract(Collection units)
    
    This unit contains collection and utility objects, being quite
    similar to those included in the objects and classes units. The only
    difference being that they compile on all compiler targets.
    
}
Unit collects;

Interface

uses cmntyp, objects, cmnutils;




const
 MaxCollectionSize = 8192;
{---------------------------------------------------------------------------}
{                          TExtendedCollection ERROR CODES                          }
{---------------------------------------------------------------------------}
CONST
   coIndexError = -1;                                 { Index out of range }
   coOverflow   = -2;                                 { Overflow }


TYPE
  {** @exclude }
  TItemList = Array [0..MaxCollectionSize - 1] Of Pointer;
  {** @exclude }
  PItemList = ^TItemList;


type
 
  PStack = ^TStack;
  {** @abstract(Stack object)
      Implement an object that is used as a LIFO stack containing 
      pointers as data. 
  }
  TStack = object
    constructor init;
    destructor done;
    {** Push the specified data on the stack. }
    procedure push(p: pointer);
    {** Pop the last element pushed from the stack }
    function pop: pointer;
    {** Peek at the element on top of the stack }
    function peek: pointer;
    {** Returns true if the stack is empty. }
    function isEmpty: boolean;
  private
     head: Pointer; { Pointer to PStackItem }
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
   
  
  {** @abstract(Collection of numeric longint values.) 
  
      This collection is a collection of longint values instead of pointers, 
      so instead of pointers you pass it directly the value to store in the
      collection.
  }
  TLongintCollection = object(TExtendedCollection)
    procedure FreeItem(Item: pointer); virtual;
  end;


  TObjectCollection = Object(TExtendedCollection)
    procedure FreeItem(Item: pointer); virtual;
  end;
  
  
  const KEY_NO_FASTKEY = high(word);

  type
  PObject = ^TObject;
  PHashTable = ^THashTable;




  {** @exclude }
  PKeyValue = ^TKeyValue;  
  {** @exclude }
  TKeyValue = record
    key: pshortstring;
    fastkey: word;
    value: PObject;
  end;

  {** @abstract(Hash table that is used to store and retrieve key-value pairs.)
  
      The key is a string, while the value is any old styled object data. Duplicates
      are not allowed.
  }
  THashTable = Object(TExtendedSortedCollection)
  public
      CONSTRUCTOR Init (ALimit, ADelta: Integer);
      Destructor done; virtual;
      
      {** Returns the value to which the specified key is mapped in this 
          hashtable.

          @param(key A key in the hashtable)
          @returns(the value to which the key is mapped in this hashtable; 
           nil if the key is not mapped to any value in this hashtable).

      }
      Function get(const key: string): PObject;
      
      {** Returns the value to which the specified fast key is mapped in this 
          hashtable. 
      
          @param(key A key in the hashtable)
          @returns(the value to which the key is mapped in this hashtable; 
           nil if the key is not mapped to any value in this hashtable).

      }
      Function getByFastIndex(fastkey: integer): PObject;
      

      {** Maps the specified key to the specified value in this hashtable. 
          Neither the key nor the value can be nil. 
          
          If not faskey is required, set the fastKey parameter to
          KEY_NO_FASTKEY.
          
      }
      procedure put(key: string;fastkey: integer; obj: PObject);
      
      {** Removes the key (and its corresponding value) from this hashtable. 
          This method does nothing if the key is not in the hashtable. }
      Function remove(key: string): Boolean;

      {** Returns the number of elements in this hashtable }
      Function size: integer;
      
      {** Determines whether a key is in this hash table }
      function containsKey(const key: string): Boolean;
      
      {** Removes all keys and elements from this HashTable }
      procedure clear;
      
      {** Returns the key name associated with the specified index, the index starting at 0 to count -1. The
          returns an empty string if out of bounds. The index is an internal value and is not
          the same as the fastKey index.
      }
      function getKeyName(index: integer): string;
   private
      returnedProperty: pchar;
      function getIndex(key: string): integer;
      function getFastKeyIndex(fastkey: integer): integer;
      FUNCTION Compare (Key1, Key2: Pointer): Integer;            Virtual;
      PROCEDURE FreeItem (Item: Pointer); Virtual;
  end;



  PCollectionItem = ^TCollectionItem;  
  {** @abstract(Basic item that stores data for use in THashTable/TCollection.) }
  TCollectionItem = Object(TObject)
    Constructor Init;
    Destructor Done; virtual;
    {** Returns the string representation of this item }
    Function toString: string; virtual;
  end;
  
  
  
  PKeyValueItem = ^TKeyValueItem;
  {** @abstract(Simple item that stores a key-value pair for use in THashTable/TCollection.)

      The pchar is simply stored and the value is disposed when the object is freed.
  }
  TKeyValueItem = Object(TCollectionItem)
  public
    Constructor Init(k: shortstring; p: pchar);
    Destructor Done; virtual;
    Function toString: string; virtual;
    Function getKey: string;
    Function getValue: pchar;
  private
    key: pshortstring;
    value: pchar;
  end;

  
  PStringItem = ^TStringItem;
  {** @abstract(Simple String item that stores strings for use in THashTable/TCollection.) }
  TStringItem = Object(TCollectionItem)
  public
    Constructor Init(s: String);
    Destructor Done; virtual;
    Function toString: string; virtual;
  private
    value: String;
  end;

  PPCharItem = ^TPCharItem;
  {** @abstract(Simple PCHAR item that stores strings for use in THashTable/TCollection.)

      The pchar is simply stored and the value is disposed when the object is freed.
  }
  TPCharItem = Object(TCollectionItem)
  public
    Constructor Init(p: pchar);
    Destructor Done; virtual;
    Function toString: string; virtual;
  private
    value: pchar;
  end;


Implementation

uses sysutils,unicode;


type
  {** Internal type information for the stack. Each element on the
      stack is of this structure. }
  PStackItem = ^TStackItem;
  TStackItem = record
    next: PStackItem;
    data: pointer;
  end;

    procedure TObjectCollection.FreeItem(Item: pointer);
     var
      O: PObject;
     Begin
       O:=PObject(Item);
       if assigned(O) then
         Dispose(O, Done);
     end;

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
FUNCTION THashTable.Compare (Key1, Key2: Pointer): integer;
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

destructor THashTable.done;
begin
  if assigned(returnedProperty) then
    strdispose(returnedProperty);
  Inherited Done;
end;



PROCEDURE THashTable.FreeItem (Item: Pointer);
var
 p: PKeyValue;
BEGIN
   p:=PKeyValue(Item);
   if assigned(p) then
     begin
       if assigned(p^.key) then
         stringdispose(p^.key);
       Dispose(p^.value, done);  
       dispose(p);
     end;
END;


{** This returns the index in the collection of the element
    associated with this key, or -1 if not found.
}
function THashTable.getIndex(key: string): integer;
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
function THashTable.getFastKeyIndex(fastkey: integer): integer;
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



function THashTable.getKeyName(index: integer): string;
var
 KeyValue: PKeyValue;
begin
  getKeyName:='';
  if (index < 0) or (index > count-1) then
    exit;
  KeyValue:=PKeyValue(At(index));
  getKeyName:=KeyValue^.key^;

  end;


Function THashTable.get(const key: string): PObject;
var
 idx: integer;
 KeyValue: PKeyValue;
begin
  get:=nil;
  idx:=getIndex(key);
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  get:=KeyValue^.value;
end;


function THashTable.getByFastIndex(fastkey: integer): PObject;
var
 idx: integer;
 KeyValue: PKeyValue;
begin
  getByFastIndex:=nil;
  idx:=getFastKeyIndex(fastkey);
  if idx = -1 then
    exit;
  KeyValue:=PKeyValue(At(idx));
  getByFastIndex:=KeyValue^.value;
end;

Function THashTable.remove(key: string): Boolean;
var
 idx: integer;
begin
  remove := false;
  idx:=getIndex(key);
  if idx <> -1 then
    begin
      Free(At(idx));
      remove := true;
    end;
end;

procedure THashTable.put(key: string;fastkey: integer; obj: PObject);
var
 KeyValue: PKeyValue;
 idx: integer;
begin
  idx:=getIndex(key);
  if idx <> -1 then
    begin
      KeyValue:=PKeyValue(At(idx));
      Free(At(idx));
    end;
  new(KeyValue);
  KeyValue^.key:=stringdup(key);
  KeyValue^.value:=obj;
  KeyValue^.fastkey:=FastKey;
  Insert(KeyValue);
end;

Function THashTable.size: integer;
begin
  Size := Count;
end;

function THashTable.containsKey(const key: string): Boolean;
var
 idx: integer;
Begin
  containsKey := false;
  idx:=getIndex(key);
  if idx <> -1 then
    begin
      containsKey := true;
    end;
end;

procedure THashTable.clear;
begin
 FreeAll;
end;


CONSTRUCTOR THashTable.Init (ALimit, ADelta: Integer);
Begin
  Inherited Init(ALimit,ADelta);
  returnedProperty:=nil;
end;

{*****************************************************************************
                             Hash Item
*****************************************************************************}


Constructor TCollectionItem.Init;
Begin
  Inherited Init;
end;

Destructor TCollectionItem.Done;
Begin
  Inherited Done;
end;

Function TCollectionItem.toString: string;
Begin
  toString := '';
end;


{*****************************************************************************
                             Hash String Item
*****************************************************************************}


Constructor TStringItem.Init(s: String);
Begin
  Inherited Init;
  value := s;
end;

Destructor TStringItem.Done;
Begin
  Inherited Done;
end;

Function TStringItem.toString: string;
Begin
  toString := value;
end;


{*****************************************************************************
                             Hash PChar Item
*****************************************************************************}


Constructor TPCharItem.Init(p: pchar);
Begin
  Inherited Init;
  value := p;
end;

Destructor TPCharItem.Done;
Begin
  Inherited Done;
  if assigned(Value) then
    Begin
      Strdispose(value);
      value:=nil;
    end;
end;

Function TPCharItem.toString: string;
Begin
  toString:='';
  if assigned(value) then
     toString := strpas(value);
end;


{*****************************************************************************
                             Key-Value Item
*****************************************************************************}

Constructor TKeyValueItem.Init(k: shortstring; p: pchar);
Begin
  Inherited Init;
  value := p;
  key:=stringdup(k);
end;

Destructor TKeyValueItem.Done;
Begin
  Inherited Done;
  if assigned(Value) then
    Begin
      FreeMem(value,StrLen(value)+sizeof(char));
      value:=nil;
    end;
  if assigned(Key) then
    Begin
      Stringdispose(key);
      key:=nil;
    end;
end;

Function TKeyValueItem.getKey: string;
 Begin
   getKey:='';
   if assigned(key) then
     getKey:=Key^; 
 end;
 
Function TKeyValueItem.getValue: pchar;
 Begin
   getValue:=nil;
   if assigned(value) then
     getValue:=value;
 end;
 

Function TKeyValueItem.toString: string;
var
 s1: string;
 s2: string;
Begin
  toString:='';
  if assigned(value) and assigned(key) then
    Begin
     s1:=key^;
     s2:=ansistrpas(value);
     toString := s1 + s2;
    end;
end;

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
      s := PStackItem(head)^.next;
      dispose(PStackItem(head));
      head := s;
    end
end;

function TStack.peek: pointer;
begin
  if not isEmpty then
    peek := PStackItem(head)^.data
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
      temp := PStackItem(head)^.next;
      dispose(PStackItem(head));
      head := temp;
    end;
end;


End.
{
  $Log: not supported by cvs2svn $
  Revision 1.10  2012/02/16 05:38:27  carl
  + Added key-value collection type

  Revision 1.9  2011/11/24 00:27:36  carl
  + update to new architecture of dates and times, as well as removal of some duplicate files.

  Revision 1.8  2011/04/12 00:46:54  carl
  + String Hash Key value collection

  Revision 1.7  2010/01/21 12:01:09  carl
   + Add TKeyValueCollection class

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