{
    $Id: collects.pas,v 1.1 2004-07-05 02:38:14 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Collections (Object style)
    
    See License.txt for more information on the licensing terms
    for this source code.
    
 **********************************************************************}
{** @author(Carl Eric Codere) 
    @abstract(Collection units)
    
    This routine contains collection objects, being quite
    similar to those included in the objects unit. The only
    difference being that they compiler on all compiler
    targets.
    
}
Unit collects;

Interface

uses
  vpautils,
  fpautils,
  tpautils,
  dpautils;




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
TYPE
  ProcedureType = Function(Item: Pointer): Boolean;
  ForEachProc = Procedure(Item: Pointer);

{ ******************************* REMARK ****************************** }
{    The changes here look worse than they are. The Integer simply   }
{  switches between Integers and LongInts if switched between 16 and 32 }
{  bit code. All existing code will compile without any changes.        }
{ ****************************** END REMARK *** Leon de Boer, 10May96 * }

{---------------------------------------------------------------------------}
{              TExtendedCollection OBJECT - COLLECTION ANCESTOR OBJECT              }
{---------------------------------------------------------------------------}
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
   PCollection = ^TExtendedCollection;

{---------------------------------------------------------------------------}
{          TExtendedSortedCollection OBJECT - SORTED COLLECTION ANCESTOR            }
{---------------------------------------------------------------------------}
TYPE
   TExtendedSortedCollection = OBJECT (TExtendedCollection)
         Duplicates: Boolean;                         { Duplicates flag }
      CONSTRUCTOR Init (ALimit, ADelta: Integer);
      FUNCTION KeyOf (Item: Pointer): Pointer;                       Virtual;
      FUNCTION IndexOf (Item: Pointer): Integer;                  Virtual;
      FUNCTION Compare (Key1, Key2: Pointer): Integer;            Virtual;
      FUNCTION Search (Key: Pointer; Var Index: Integer): Boolean;Virtual;
      PROCEDURE Insert (Item: Pointer);                              Virtual;
   END;
   PSortedCollection = ^TExtendedSortedCollection;


Implementation
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

End.
{
  $Log: not supported by cvs2svn $
}