{** Implementation of basic Sysutils routine for Turbo Pascal compatibility.

    The API is compatible with Freepascal 1.0.10a as well as Delphi 4. The
    categories have been implemented: 
      -> String routines
      -> General purpose and memory routines.
}
unit sysutils;

interface

uses cmntyp;

type
  TReplaceFlags = set of (rfReplaceAll, rfIgnoreCase);
  TSysCharSet = set of Char;
  
  TProcedure = procedure;
  PString    = ^shortstring;

{procedure Abort;}
procedure AddExitProc(Proc: TProcedure);
{function AdjustLineBreaks(const S: string): string;}
function AllocMem(Size: Cardinal): Pointer;
{procedure AddTerminateProc(TermProc: TTerminateProc);}
procedure AppendStr(var Dest: string; const S: string);
procedure AssignStr(var P: PString; const S: string);
{function CallTerminateProcs: Boolean;}
function CompareMem(P1, P2: Pointer; Length: Longint): Boolean; 
function CompareStr(const S1, S2: string): Integer;
function CompareText(const S1, S2: string): Integer;
procedure DisposeStr(P: PString);
{function FloatToStr(Value: Extended): string;
function FloatToStrF(Value: Extended; Format: TFloatFormat; Precision, Digits: Integer): string;}
function IntToHex(Value: Longint; Digits: Integer): string;
function IntToStr(Value: Longint): string;
{function LoadStr(Ident: Integer): string;}
function LowerCase(S: string): string;
function NewStr(const S: string): PString;
{function QuotedStr(const S: string): string;}
{function StringReplace(const S, OldPattern, NewPattern: string; Flags: TReplaceFlags): string;}
function Trim(const S: string): string;
function TrimLeft(const S: string): string;
function TrimRight(const S: string): string;
function UpperCase(S: string): string;

 {*********************************************************************}
 { Returns the number of Characters in Str,not counting the Null       }
 { chracter.                                                           }
 {*********************************************************************}

function StrLen(Str: PChar): longint;


function StrEnd(Str: PChar): PChar;

  {*********************************************************************}
  {  Description: Move count characters from source to dest.            }
  {   Do not forget to use StrLen(source)+1 as l parameter to also move }
  {   the null character.                                               }
  {  Return value: Dest                                                 }
  {   Remarks: Source and Dest may overlap.                             }
  {*********************************************************************}

function StrMove(Dest,Source : Pchar;l : Longint) : pchar;


function StrCopy(Dest, Source: PChar): PChar;

 {*********************************************************************}
 {  Input: Source -> Source of the null-terminated string to copy.     }
 {         Dest   -> Destination of null terminated string to copy.    }
 {    Return Value: Pointer to the end of the copied string of Dest.   }
 {  Output: Dest ->   Pointer to the copied string.                    }
 {*********************************************************************}
function StrECopy(Dest, Source: PChar): PChar;

  {*********************************************************************}
  {  Copies at most MaxLen characters from Source to Dest.              }
  {                                                                     }
  {   Remarks: According to the Turbo Pascal programmer's Reference     }
  {    this routine performs length checking. From the code of the      }
  {    original strings unit, this does not seem true...                }
  {   Furthermore, copying a null string gives two null characters in   }
  {   the destination according to the Turbo Pascal routine.            }
  {*********************************************************************}

function StrLCopy(Dest, Source: PChar; MaxLen: Longint): PChar;

 {*********************************************************************}
 {  Input: Source -> Source of the pascal style string to copy.        }
 {         Dest   -> Destination of null terminated string to copy.    }
 {    Return Value: Dest. (with noew copied string)                    }
 {*********************************************************************}

function StrPCopy(Dest: PChar; Source: String): PChar;

 {*********************************************************************}
 {  Description: Appends a copy of Source to then end of Dest and      }
 {               return Dest.                                          }
 {*********************************************************************}

function StrCat(Dest, Source: PChar): PChar;

 {*********************************************************************}
 { Description: Appends at most MaxLen - StrLen(Dest) characters from  }
 { Source to the end of Dest, and returns Dest.                        }
 {*********************************************************************}

      function strlcat(dest,source : pchar;l : Longint) : pchar;

  {*********************************************************************}
  {  Compares two strings. Does the ASCII value substraction of the     }
  {  first non matching characters                                      }
  {   Returns 0 if both strings are equal                               }
  {   Returns < 0 if Str1 < Str2                                        }
  {   Returns > 0 if Str1 > Str2                                        }
  {*********************************************************************}

function StrComp(Str1, Str2: PChar): Integer;

  {*********************************************************************}
  {  Compares two strings without case sensitivity. See StrComp for more}
  {  information.                                                       }
  {   Returns 0 if both strings are equal                               }
  {   Returns < 0 if Str1 < Str2                                        }
  {   Returns > 0 if Str1 > Str2                                        }
  {*********************************************************************}

function StrIComp(Str1, Str2: PChar): Integer;

  {*********************************************************************}
  {  Compares two strings up to a maximum of MaxLen characters.         }
  {                                                                     }
  {   Returns 0 if both strings are equal                               }
  {   Returns < 0 if Str1 < Str2                                        }
  {   Returns > 0 if Str1 > Str2                                        }
  {*********************************************************************}

function StrLComp(Str1, Str2: PChar; MaxLen: Longint): Integer;

  {*********************************************************************}
  {  Compares two strings up to a maximum of MaxLen characters.         }
  {  The comparison is case insensitive.                                }
  {   Returns 0 if both strings are equal                               }
  {   Returns < 0 if Str1 < Str2                                        }
  {   Returns > 0 if Str1 > Str2                                        }
  {*********************************************************************}

function StrLIComp(Str1, Str2: PChar; MaxLen: Longint): Integer;

 {*********************************************************************}
 {  Input: Str  -> String to search.                                   }
 {         Ch   -> Character to find in Str.                           }
 {  Return Value: Pointer to first occurence of Ch in Str, nil if      }
 {                not found.                                           }
 {  Remark: The null terminator is considered being part of the string }
 {*********************************************************************}

function StrScan(Str: PChar; Ch: Char): PChar;

 {*********************************************************************}
 {  Input: Str  -> String to search.                                   }
 {         Ch   -> Character to find in Str.                           }
 {  Return Value: Pointer to last occurence of Ch in Str, nil if       }
 {                not found.                                           }
 {  Remark: The null terminator is considered being part of the string }
 {*********************************************************************}


function StrRScan(Str: PChar; Ch: Char): PChar;

 {*********************************************************************}
 {  Input: Str1 -> String to search.                                   }
 {         Str2 -> String to match in Str1.                            }
 {  Return Value: Pointer to first occurence of Str2 in Str1, nil if   }
 {                not found.                                           }
 {*********************************************************************}

function StrPos(Str1, Str2: PChar): PChar;

 {*********************************************************************}
 {  Input: Str -> null terminated string to uppercase.                 }
 {  Output:Str -> null terminated string in upper case characters.     }
 {    Return Value: null terminated string in upper case characters.   }
 {  Remarks: Case conversion is dependant on upcase routine.           }
 {*********************************************************************}

function StrUpper(Str: PChar): PChar;

 {*********************************************************************}
 {  Input: Str -> null terminated string to lower case.                }
 {  Output:Str -> null terminated string in lower case characters.     }
 {    Return Value: null terminated string in lower case characters.   }
 {  Remarks: Only converts standard ASCII characters.                  }
 {*********************************************************************}

function StrLower(Str: PChar): PChar;

{ StrPas converts Str to a Pascal style string.                 }

function StrPas(Str: PChar): String;

 {*********************************************************************}
 {  Input: Str  -> String to duplicate.                                }
 {  Return Value: Pointer to the new allocated string. nil if no       }
 {                  string allocated. If Str = nil then return value   }
 {                  will also be nil (in this case, no allocation      }
 {                  occurs). The size allocated is of StrLen(Str)+1    }
 {                  bytes.                                             }
 {*********************************************************************}
function StrNew(P: PChar): PChar;

{ StrDispose disposes a string that was previously allocated    }
{ with StrNew. If Str is NIL, StrDispose does nothing.          }

procedure StrDispose(P: PChar);


implementation

uses strings;


Type
  PExitProcInfo = ^TExitProcInfo;
  TExitProcInfo = Record
    Next     : PExitProcInfo;
    SaveExit : Pointer;
    Proc     : TProcedure;
  End;
const
  ExitProcList: PExitProcInfo = nil;

Procedure DoExitProc;
var
  P    : PExitProcInfo;
  Proc : TProcedure;
Begin
  P:=ExitProcList;
  ExitProcList:=P^.Next;
  ExitProc:=P^.SaveExit;
  Proc:=P^.Proc;
  DisPose(P);
  Proc;
End;


Procedure AddExitProc(Proc: TProcedure);
var
  P : PExitProcInfo;
Begin
  New(P);
  P^.Next:=ExitProcList;
  P^.SaveExit:=ExitProc;
  P^.Proc:=Proc;
  ExitProcList:=P;
  ExitProc:=@DoExitProc;
End;


function AllocMem(Size: Cardinal): Pointer;
 var 
  P: Pointer;
 Begin
   GetMem(P, Size);
   FillChar(P^,Size,#0);
 end;
 
 
procedure AppendStr(var Dest: String; const S: string);
 Begin
   Dest := Dest + S;
 end ;
 
procedure AssignStr(var P: PString; const S: string);
begin
  P^ := s;
end ;


{ Compare a memory area and determines if the memory areas
  are equal or not }
function CompareMem(P1, P2: Pointer; Length: Longint): Boolean;
 var
   p1c,p2c: pchar;
begin
  CompareMem:=false;
  p1c:=pchar(p1);
  p2c:=pchar(p2);
  While Length> 0 do
    Begin
      if p1c^ <> p2c^ then
       Begin
        exit;
       end;
      Inc(p1c);
      Inc(p2c);
      Dec(Length);
    end;
  CompareMem:=true;
end;


{   CompareMemRange returns the result of comparison of Length bytes at P1 and P2
    case       result
    P1 < P2    < 0
    P1 > P2    > 0
    P1 = P2    = 0    }

function CompareMemRange(P1, P2: Pointer; Length: cardinal): integer;

var 
  i: cardinal;
  r: integer;
  p1c,p2c: Pchar;
begin
  i := 0;
  CompareMemRange := 0;
  r := 0;
  p1c:=Pchar(P1);
  p2c:=PChar(P2);
  while (r=0) and (I<length) do
    begin
    r:=byte(P1C^)-byte(P2C^);
    Inc(P1C);
    Inc(P2C);
    i := i + 1;
   end ;
  CompareMemRange := r;
end ;


{   CompareStr compares S1 and S2, the result is the based on
    substraction of the ascii values of the characters in S1 and S2
    case     result
    S1 < S2  < 0
    S1 > S2  > 0
    S1 = S2  = 0     }

function CompareStr(const S1, S2: string): Integer;
var count, count1, count2: integer;
    r: integer;
begin
  CompareStr := 0;
  Count1 := Length(S1);
  Count2 := Length(S2);
  if Count1>Count2 then 
    Count:=Count2
  else 
    Count:=Count1;
  r := CompareMemRange(Pointer(S1[1]),Pointer(S2[1]), Count);
  if (r=0) and (Count1<>Count2) then
    begin
    if Count1>Count2 then
      r:=ord(s1[Count+1])
    else
      r:=-ord(s2[Count+1]);
    end;
  CompareStr := r;
end;

{   CompareText compares S1 and S2, the result is the based on
    substraction of the ascii values of characters in S1 and S2
    comparison is case-insensitive
    case     result
    S1 < S2  < 0
    S1 > S2  > 0
    S1 = S2  = 0     }

function CompareText(const S1, S2: string): integer;

var 
  i, count, count1, count2: integer; Chr1, Chr2: byte;
  r: integer;
begin
  CompareText := 0;
  Count1 := Length(S1);
  Count2 := Length(S2);
  if (Count1>Count2) then 
    Count := Count2
  else 
    Count := Count1;
  i := 0;
  while (r=0) and (i<count) do
    begin
    inc (i);
     Chr1 := byte(s1[i]);
     Chr2 := byte(s2[i]);
     if Chr1 in [97..122] then 
       dec(Chr1,32);
     if Chr2 in [97..122] then 
       dec(Chr2,32);
     r := Chr1 - Chr2;
     end ;
  if (r = 0) then
    r:=(count1-count2);
  CompareText := r;
end;

{   DisposeStr frees the memory occupied by S   }
procedure DisposeStr(P: PString);
begin
  if P <> Nil then
   begin
     Freemem(P,Length(P^)+1);
     P:=nil;
   end;
end;

function IntToStr(Value: Longint): string;
 var
  s: String;
 Begin
   Str(Value,S);
   IntToStr:=s;
 end;


const
   HexDigits: array[0..15] of char = '0123456789ABCDEF';

function IntToHex(Value: Longint; Digits: integer): string;
var i: integer;
    s : string;
begin
 SetLength(s, digits);
 for i := 0 to digits - 1 do
  begin
   s[digits - i] := HexDigits[value and 15];
   value := value shr 4;
  end ;
 IntToHex := s;
end ;

  function LowerCase(s : string): string;
    var
     i : integer;
    Begin
      for I:=1 to length(s) do
        if s[i] in ['A'..'Z'] then
          s[i]:=chr(ord(s[i])+ord(#$20));
      LowerCase := s;
    End;


{   NewStr creates a new PString and assigns S to it
    if length(s) = 0 NewStr returns Nil   }
function NewStr(const S: string): PString;
var
 P: PString;
begin
  NewStr := nil;
  if (S='') then
   NewStr:=nil
  else
   begin
     getmem(P,length(s)+1);
     if (P<>nil) then
      NewStr^:=s;
   end;
end;


{   Trim returns a copy of S with blanks characters on the left and right stripped off   }

Const WhiteSpace = [' ',#10,#13,#9];

function Trim(const S: string): string;
var Ofs, Len: integer;
begin
  len := Length(S);
  while (Len>0) and (S[Len] in WhiteSpace) do
   dec(Len);
  Ofs := 1;
  while (Ofs<=Len) and (S[Ofs] in WhiteSpace) do
   Inc(Ofs);
  Trim := Copy(S, Ofs, 1 + Len - Ofs);
end ;

{   TrimLeft returns a copy of S with all blank characters on the left stripped off  }

function TrimLeft(const S: string): string;
var i,l:integer;
begin
  l := length(s);
  i := 1;
  while (i<=l) and (s[i] in whitespace) do
   inc(i);
  TrimLeft := copy(s, i, l);
end ;

{   TrimRight returns a copy of S with all blank characters on the right stripped off  }

function TrimRight(const S: string): string;
var l:integer;
begin
  l := length(s);
  while (l>0) and (s[l] in whitespace) do
   dec(l);
  TrimRight := copy(s,1,l);
end ;




  function UpperCase(s : string): string;
    var
     i : integer;
    Begin
      for I:=1 to length(s) do
        if s[i] in ['a'..'z'] then
          s[i]:=chr(ord(s[i])-ord(#$20));
      UpperCase := s;
    End;


{------------------------------ Null terminated strings ------------------------}

function strlen(Str : pchar) : Longint;
 Begin
   StrLen:=Strings.strlen(str);
 end;



 Function strpas(Str: pchar): string;
 Begin
   strpas:=Strings.StrPas(str);
 end;

 Function StrEnd(Str: PChar): PChar;
 begin
   StrEnd:=Strings.StrEnd(Str);
 end;


 Function StrCopy(Dest, Source:PChar): PChar;
 Begin
   StrCopy:=Strings.StrCopy(Dest,Source);
 end;


 function StrCat(Dest,Source: PChar): PChar;
 begin
   StrCat := Strings.StrCat(Dest,Source);
 end;

 function StrUpper(Str: PChar): PChar;
 begin
   StrUpper:=Strings.StrUpper(Str);
 end;

 function StrLower(Str: PChar): PChar;
 begin
   StrLower := Strings.StrLower(Str);
 end;


  function StrPos(Str1,Str2: PChar): PChar;
  Begin
   StrPos:=Strings.StrPos(Str1,Str2);
  end;


 function StrScan(Str: PChar; Ch: Char): PChar;
  Begin
    Strscan:=Strings.StrScan(Str,Ch);
   end;



 function StrRScan(Str: PChar; Ch: Char): PChar;
 Var
  count: Longint;
  index: Longint;
 Begin
   count := Strlen(Str);
   { As in Borland Pascal , if looking for NULL return null }
   if ch = #0 then
   begin
     StrRScan := @(Str[count]);
     exit;
   end;
   Dec(count);
   for index := count downto 0 do
   begin
     if Ch = Str[index] then
      begin
          StrRScan := @(Str[index]);
          exit;
      end;
   end;
   { nothing found. }
   StrRScan := nil;
 end;


 function StrNew(p:PChar): PChar;
      var
         len : Longint;
         tmp : pchar;
      begin
         strnew:=nil;
         if (p=nil) or (p^=#0) then
           exit;
         len:=strlen(p)+1;
         getmem(tmp,len);
         if tmp<>nil then
            move(p^,tmp^,len);
         StrNew := tmp;
      end;


  Function StrECopy(Dest, Source: PChar): PChar;
  Begin
   StrECopy:=Strings.StrECopy(Dest,Source);
  end;


   Function StrPCopy(Dest: PChar; Source: String):PChar;
  Begin
   { if empty pascal string  }
   { then setup and exit now }
   if Source = '' then
   Begin
     Dest[0] := #0;
     StrPCopy := Dest;
     exit;
   end;
   Move(Source[1],Dest^,length(Source));
   { terminate the string }
   Dest[length(Source)] := #0;
   StrPCopy:=Dest;
 end;


 procedure strdispose(p : pchar);
 begin
   if p<>nil then
      freemem(p,strlen(p)+1);
 end;


 function strmove(dest,source : pchar;l : Longint) : pchar;
 begin
   move(source^,dest^,l);
   strmove:=dest;
 end;


 function strlcat(dest,source : pchar;l : Longint) : pchar;
 var
   destend : pchar;
 begin
   destend:=strend(dest);
   l:=l-(destend-dest);
   strlcat:=strlcopy(destend,source,l);
 end;


 Function StrLCopy(Dest,Source: PChar; MaxLen: Longint): PChar;
 Begin
   StrLCopy:=Strings.StrLCopy(Dest,Source,MaxLen);
 end;


 function StrComp(Str1, Str2 : PChar): Integer;
 begin
   StrComp:=Strings.StrComp(Str1,Str2);
 end;

     function StrIComp(Str1, Str2 : PChar): Integer;
     Begin
       StrIComp:=Strings.StrIComp(Str1,Str2);
     end;


     function StrLComp(Str1, Str2 : PChar; MaxLen: Longint): Integer;
     var
      counter: Longint;
      c1, c2: char;
     Begin
       counter := 0;
       if MaxLen = 0 then
       begin
         StrLComp := 0;
         exit;
       end;
       Repeat
         c1 := str1[counter];
         c2 := str2[counter];
         if (c1 = #0) or (c2 = #0) then break;
         Inc(counter);
      Until (c1 <> c2) or (counter >= MaxLen);
       StrLComp := ord(c1) - ord(c2);
     end;



     function StrLIComp(Str1, Str2 : PChar; MaxLen: Longint): Integer;
     var
      counter: Longint;
      c1, c2: char;
     Begin
       counter := 0;
       if MaxLen = 0 then
       begin
         StrLIComp := 0;
         exit;
       end;
       Repeat
         c1 := upcase(str1[counter]);
         c2 := upcase(str2[counter]);
         if (c1 = #0) or (c2 = #0) then break;
         Inc(counter);
       Until (c1 <> c2) or (counter >= MaxLen);
       StrLIComp := ord(c1) - ord(c2);
     end;

end.