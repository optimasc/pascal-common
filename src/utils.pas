{
 ****************************************************************************
    $Id: utils.pas,v 1.3 2004-06-17 11:46:54 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Common utilities

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}


{** @author(Carl Eric Codere)
    @abstract(General utilities common to all platforms.)}
Unit utils;

Interface

uses
 tpautils,
 vpautils,
 fpautils,
 dpautils,
 objects
 ;

{$IFNDEF TP}
{$H-}
{$ENDIF}


TYPE
    PshortString = ^ShortString;


CONST
  { Filemode constant defines }
  READ_MODE = 0;
  WRITE_MODE = 1;
  READ_WRITE_MODE = 2;

  { Possible error codes returned to DOS by program }
  EXIT_DOSERROR = 2;
  EXIT_ERROR = 1;


  {** 
     @abstract(Verifies the existence of a filename)
     This routine verifies if the file named can be
     opened or if it actually exists.

     @param FName Name of the file to check
     @returns FALSE if the file cannot be opened or if it does not exist.
  }
  Function FileExists(FName : string): Boolean;

  {** @abstract(Change the endian of a 32-bit value) }
  Procedure SwapLong(var x : longword);

  {** @abstract(Change the endian of a 16-bit value) }
  Procedure SwapWord(var x : word);

  {** @abstract(Convert a string to uppercase ASCII) }
  function UpString(s : string): string;

  {** @abstract(Generic stream error procedure)
      Generic stream error procedure that
      can be used to set @code(streamerror)
  }
  procedure StreamErrorProcedure(Var S: TStream);

  {** @abstract(Remove all whitespace from the start of a string) }
  function TrimLeft(const S: string): string;

  {** @abstract(Remove all whitespace from the end of a string) }
  function TrimRight(const S: string): string;

  {** @abstract(Convert a value to an ASCII hexadecimal representation) }
  function hexstr(val : longint;cnt : byte) : string;

  {** @abstract(Convert a value to an ASCII decimal representation) 
  
      To avoid left padding with zeros, set @code(cnt) to zero.
  }      
  function decstr(val : longint;cnt : byte) : string;
  
 {** @abstract(Convert a boolean value to an ASCII representation) 
  
      To avoid left padding with spaces, set @code(cnt) to zero.
  }      
  function boolstr(val: boolean; cnt: byte): string; 
  
  function CompareByte(buf1,buf2: pchar;len:longint):integer;
   
   
  
  {** 
     @abstract(Format a string and print it out to the console)
     This routine formats the string specified in s to
     the format specified and returns the resulting
     string.

     The following specifiers are allowed:
     %d : The buffer contents contains an integer
     %s : The buffer contents contains a string, terminated
           by a null character.
     %bh : The buffer contents contains a byte coded in
           BCD format, only the high byte will be kept.
     %bl : The buffer contents contains a byte coded in
           BCD format, only the low byte will be kept.


     @param s The string to format, with format specifiers
     @param buf The buffer containing the data
     @param size The size of the data in the buffer
     @returns The resulting formatted string
  }
  function Printf(const s : string; var Buf; size : word): string;


  function FillTo(s : string; tolength: integer): string;

  function stringdup(const s : string) : pShortstring;
  procedure stringdispose(var p : pShortstring);

  {** Converts a C style string (containing escape characters), to
      a pascal style string. Returns the converted string. If there
      is no error in the conversion, @code(code) will be equal to
      zero.

      @param(s String to convert)
      @param(code Result of operation, 0 when there is no error)
  }
  function EscapeToPascal(const s:string; var code: integer): string;
  {** Convert a decimal value represented by a string to its
      numerical value. If there is no error, @code(code) will be
      equal to zero.
  }
  function ValDecimal(const S:String; var code: integer):longint;
  {** Convert an octal value represented by a string to its
      numerical value. If there is no error, @code(code) will be
      equal to zero.
  }
  function ValOctal(const S:String;var code: integer):longint;
  {** Convert a binary value represented by a string to its
      numerical value. If there is no error, @code(code) will be
      equal to zero.
  }
  function ValBinary(const S:String; var code: integer):longint;
  {** Convert an hexadecimal value represented by a string to its
      numerical value. If there is no error, @code(code) will be
      equal to zero.
  }
  function ValHexadecimal(const S:String; var code: integer):longint;
  
  
  function uppercase(s: string):string;


  function ChangeFileExt(const FileName, Extension: string): string;

Implementation

Const WhiteSpace = [' ',#10,#13,#9];


  Function RemoveUpToNull(const s: string): string;
   Begin
     if (Pos(#0,s) <> 0) then
       RemoveUpToNull := Copy(s, 1, Pos(#0,s)-1)
     else
       RemoveUpToNull := s;
   End;

  Procedure SwapLong(var x : longword);
  var
    y : word;
    z : word;
  Begin
   y := (x shr 16) and $FFFF;
   y := word((y shl 8) or ((y shr 8) and $ff));
   z := x and $FFFF;
   z := word((z shl 8) or ((z shr 8) and $ff));
   x := longword((longword(z) shl 16) or longword(y));
  End;

  Procedure SwapWord(var x : word);
  var
   z : byte;
  Begin
    z := (x shr 8) and $ff;
    x := x and $ff;
    x := (x shl 8);
    x := x or z;
  End;


  function UpString(s : string): string;
    var
     i : integer;
    Begin
      for I:=1 to length(s) do
        s[i] := Upcase(s[i]);
      UpString := s;
    End;

   Function FillTo(s : string; tolength: integer): string;
    Begin
      while length(s) < tolength do
        s := s + ' ';
      FillTo := s;
    End;


  { this is equivalent to the printf format specifier }
  { except only one parameter is possible             }
   Function Printf(const s : string; var Buf; size : word): string;
   var
    LeftStr : string;
    RightStr : string;
    l: longint;
    OutStr : string;
    Position : integer;
    b: byte;
    NumStr : string[2];
    Code : integer;
   Begin
     LeftStr := '';
     RightStr := '';
     { integer value }
     Position := Pos('%d',s);
     if Position <> 0 then
       Begin
         l:=0;
         { separate the strings before the specifier and }
         { after the specifier.                          }
         LeftStr := Copy(s, 1, Position-1);
         RightStr := Copy(s, Position+2, Length(s));
         case size of
           1 :
               Begin
                 l := byte(Buf);
               End;
           2 :
                 l := word(Buf);
           4 :
                 l := longint(Buf);
         end;
         Str(l,  OutStr);
         LeftStr := LeftStr + OutStr + RightStr;
       End
     else
     { string value }
     if Pos('%s',s)<> 0 then
       Begin
         Position := Pos('%s',s);
         { separate the strings before the specifier and }
         { after the specifier.                          }
         LeftStr := Copy(s, 1, Position-1);
         RightStr := Copy(s, Position+2, Length(s));
         { the string removes all null characters }
         LeftStr := LeftStr + RemoveUpToNull(string(Buf)) + RightStr;
       end
     Else
     { string value with length }
     If Pos('%.',s) <> 0 then
       Begin
         Position := Pos('%.',s);
         { indicate the number of characters to print }
         if (Position <> 0) and (s[Position + 3] = 's') then
            Begin
               { separate the strings before the specifier and }
               { after the specifier.                          }
               LeftStr := Copy(s, 1, Position-1);
               RightStr := Copy(s, Position+4, Length(s));
               { now convert the number of characters to output }
               b := byte(s[Position + 2]) - $30;
               { correct numeric value ? }
               if b in [0..9] then
                  Begin
                     OutStr := Copy(String(Buf),1,b);
                     { remove up to null character }
                     OutStr := RemoveUpToNull(OutStr);
                  End
                else
                   OutStr := '';
                { only copy certain characters of the string }
                LeftStr := LeftStr + OutStr + RightStr;
            End
         Else
            { indicate the number of characters to print }
            if (Position <> 0) and (s[Position + 4] = 's') then
               Begin
                  { separate the strings before the specifier and }
                  { after the specifier.                          }
                  LeftStr := Copy(s, 1, Position-1);
                  RightStr := Copy(s, Position+5, Length(s));
                  { now convert the number of characters to output }
                  NumStr  := s[Position + 2] + s[Position + 3];
                  Val(NumStr,b,Code);
                  if Code = 0 then
                     Begin
                        { correct numeric value ? }
                        OutStr := Copy(String(Buf),1,b);
                        { remove up to null character }
                        OutStr := RemoveUpToNull(OutStr);
                     End
                  else
                     OutStr := '';
                  { only copy certain characters of the string }
                  LeftStr := LeftStr + OutStr + RightStr;
               End;
       End
      Else
      if Pos('%bh',s) <> 0 then
       Begin
         l:=0;
         Position := Pos('%bh',s);
         { separate the strings before the specifier and }
         { after the specifier.                          }
         LeftStr := Copy(s, 1, Position-1);
         RightStr := Copy(s, Position+3, Length(s));
         case size of
            1 : l := (byte(Buf) and $f0) shr 4;
         end;
         Str(l,  OutStr);
         LeftStr := LeftStr + OutStr + RightStr;
       End
      Else
      if Pos('%bl',s) <> 0 then
       Begin
         l:=0;
         Position := Pos('%bl',s);
         { separate the strings before the specifier and }
         { after the specifier.                          }
         LeftStr := Copy(s, 1, Position-1);
         RightStr := Copy(s, Position+3, Length(s));
         case size of
            1 : l := (byte(Buf) and $0f);
         end;
         Str(l,  OutStr);
         LeftStr := LeftStr + OutStr + RightStr;
       End
       Else
           { normal string without control characters }
           Begin
            LeftStr := s;
           End;
     Printf := LeftStr;
   End;


    Function FileExists(FName: String) : Boolean;
     Var
      F: File;
      OldMode : Byte;
     Begin
{$IFOPT I+}
{$DEFINE IO_ON}
{$I-}
{$ENDIF}
       { Bug, would not detect read only files }
       { therefore try in read only mode       }
       OldMode := FileMode;
       FileMode := READ_MODE;
       Assign(F,FName);
       Reset(F,1);
       FileMode := OldMode;
       If IOResult <> 0 then
         FileExists := FALSE
       else
       Begin
         FileExists := TRUE;
         Close(F);
       End;
{$IFDEF IO_ON}
{$I+}
{$ENDIF}
     end;


(*************************************************************************)
(* Create a stream error procedure which will be called on error of the  *)
(* stream. Will Terminate executing program, ar well as display info     *)
(* on the type of error encountered.                                     *)
(*************************************************************************)
Procedure StreamErrorProcedure(Var S: TStream);
Begin
 If S.Status = StError then
 Begin
  WriteLn('ERROR: General Access failure. Halting');
  Halt(1);
 end;
 If S.Status = StInitError then
 Begin
  WriteLn('ERROR: Cannot Init Stream. Halting');
  Case S.ErrorInfo of
  2: WriteLn('File not found.');
  3: WriteLn('Path not found.');
  5: Writeln('Access denied.');
  end;
  Halt(1);
 end;
 If S.Status = StReadError then
 Begin
  WriteLn('ERROR: Read beyond end of Stream. Halting');
  Halt(1);
 end;
 If S.Status = StWriteError then
 Begin
  WriteLn('ERROR: Cannot expand Stream. Halting');
  Halt(1);
 end;
 If S.Status = StGetError then
 Begin
  WriteLn('ERROR: Get of Unregistered type. Halting');
  Halt(1);
 end;
 If S.Status = StPutError then
 Begin
  WriteLn('ERROR: Put of Unregistered type. Halting');
  Halt(1);
 end;
end;


function hexstr(val : longint;cnt : byte) : string;
const
  HexTbl : array[0..15] of char='0123456789ABCDEF';
var
  i : longint;
begin
  hexstr[0]:=char(cnt);
  for i:=cnt downto 1 do
   begin
     hexstr[i]:=hextbl[val and $f];
     val:=val shr 4;
   end;
end;

function fillwithzero(s: string; newlength: integer): string;
 begin
   while length(s) < newlength do
     s:='0'+s;
   fillwithzero:=s;
 end;


function fillwithspace(s: string; newlength: integer): string;
 begin
   while length(s) < newlength do
     s:=' '+s;
   fillwithspace:=s;
 end;

function boolstr(val: boolean; cnt: byte): string; 
const
 vals:array[FALSE..TRUE] of string[16] =
   ('FALSE','TRUE');
var
 s: string;
begin
  s:=vals[val];
  boolstr:=fillwithspace(s,cnt);
end;


function decstr(val : longint;cnt : byte) : string;
var
  s: string;
begin
  str(val,s);
  decstr:=fillwithzero(s,cnt);
end;


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



    procedure stringdispose(var p : pshortstring);
      begin
         if assigned(p) then
           freemem(p,length(p^)+1);
         p:=nil;
      end;


    function stringdup(const s : string) : pshortstring;
      var
         p : pshortstring;
      begin
         getmem(p,length(s)+1);
         p^:=s;
         stringdup:=p;
      end;


function ChangeFileExt(const FileName, Extension: string): string;
var i: longint;
begin
  I := Length(FileName);
  while (I > 0) and not(FileName[I] in ['/', '.', '\', ':']) do 
    Dec(I);
  if (I = 0) or (FileName[I] <> '.') then 
    I := Length(FileName)+1;
  ChangeFileExt := Copy(FileName, 1, I - 1) + Extension;
end;


Function ValDecimal(const S:String; var code: integer):longint;
{ Converts a decimal string to longint }
var
  vs,c : longint;
Begin
  vs:=0;
  code := 0;
  for c:=1 to length(s) do
   begin
     vs:=vs*10;
     if s[c] in ['0'..'9'] then
      inc(vs,ord(s[c])-ord('0'))
     else
      begin
        code := -1;
        ValDecimal:=0;
        exit;
      end;
   end;
  ValDecimal:=vs;
end;

Function ValOctal(const S:String;var code: integer):longint;
{ Converts an octal string to longint }
var
  vs,c : longint;
Begin
  vs:=0;
  code := 0;
  for c:=1 to length(s) do
   begin
     vs:=vs shl 3;
     if s[c] in ['0'..'7'] then
      inc(vs,ord(s[c])-ord('0'))
     else
      begin
        code:=-1;
        ValOctal:=0;
        exit;
      end;
   end;
  ValOctal:=vs;
end;


Function ValBinary(const S:String; var code: integer):longint;
{ Converts a binary string to longint }
var
  vs,c : longint;
Begin
  vs:=0;
  code := 0;
  for c:=1 to length(s) do
   begin
     vs:=vs shl 1;
     if s[c] in ['0'..'1'] then
      inc(vs,ord(s[c])-ord('0'))
     else
      begin
        code := -1;
        ValBinary:=0;
        exit;
      end;
   end;
  ValBinary:=vs;
end;


Function ValHexadecimal(const S:String; var code: integer):longint;
{ Converts a binary string to longint }
var
  vs,c : longint;
Begin
  vs:=0;
  code := 0;
  for c:=1 to length(s) do
   begin
     vs:=vs shl 4;
     case s[c] of
       '0'..'9' :
         inc(vs,ord(s[c])-ord('0'));
       'A'..'F' :
         inc(vs,ord(s[c])-ord('A')+10);
       'a'..'f' :
         inc(vs,ord(s[c])-ord('a')+10);
       else
         begin
           code := -1;
           ValHexadecimal:=0;
           exit;
         end;
     end;
   end;
  ValHexadecimal:=vs;
end;





Function EscapeToPascal(const s:string; var code: integer): string;
{ converts a C styled string - which contains escape }
{ characters to a pascal style string.               }
var
  i,len : longint;
  hs    : string;
  temp  : string;
  c     : char;
Begin
  code := 0;
  hs:='';
  len:=0;
  i:=0;
  while (i<length(s)) and (len<255) do
   begin
     Inc(i);
     if (s[i]='\') and (i<length(s)) then
      Begin
        inc(i);
        case s[i] of
        '#' :
              c := '#';
        'a' :
              c := #7;
        'b' :
              c := #8;
        'f' :
              c := #12;
        'n' :
              c := #10;
        'r' :
              c := #13;
        't' :
              c := #9;
        'v' :
              c := #11;
        '?' :
              c := '?';
        '''' :
              c := '''';
        '"' :
              c := '"';
        '\' :
              c := '\';
        ' ' :
              c := ' ';
        '<' :
             c := '<';
         '0'..'7':
           Begin
             { check if actual octal or null character }
             { BUG in freepascal with octal values !!  }
             temp:=s[i];
             if (s[i+1] in ['0'..'7']) then
             Begin
                temp:=temp+s[i+1];
                inc(i);
                if (s[i+1] in ['0'..'7']) then
                 Begin
                    temp:=temp+s[i+1];
                    inc(i);
                 End;
             End;
             c:=chr(ValOctal(temp,code));
           end;
         'x':
           Begin
             temp:=s[i+1];
             temp:=temp+s[i+2];
             inc(i,2);
             c:=chr(ValHexaDecimal(temp,code));
           end;
         else
           Begin
             code := -1;
             c:=s[i];
           end;
        end;
      end
     else
      c:=s[i];
     inc(len);
     hs[len]:=c;
   end;
  hs[0]:=chr(len);
  EscapeToPascal:=hs;
end;

function uppercase(s: string):string;
var
 i:integer;
begin
 for i:=1 to length(s) do
  s[i]:=upcase(s[i]);
 uppercase:=s; 
end;

function CompareByte(buf1,buf2: pchar;len:longint):integer;
type
  bytearray    = array [0..high(word)-1] of byte;
var
  I : longint;
begin
  I:=0;
  if (Len<>0) and (Buf1<>Buf2) then
   begin
     while (Buf1[I]=Buf2[I]) and (I<Len) do
      inc(I);
     if I=Len then  {No difference}
      I:=0
     else
      begin
        I:=ord(Buf1[I])-ord(Buf2[I]);
        if I>0 then
         I:=1
        else
         if I<0 then
          I:=-1;
      end;
   end;
  CompareByte:=I;
end;



end.
{
  $Log: not supported by cvs2svn $
  Revision 1.2  2004/05/13 23:03:40  carl
    + added decstr()
    + added boolstr()

  Revision 1.1  2004/05/05 16:28:23  carl
    Release 0.95 updates

}
