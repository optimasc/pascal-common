{
 ****************************************************************************
    $Id: cmnutils.pas,v 1.1 2012-02-16 05:40:10 carl Exp $
    Copyright (c) 2004-2011 by Carl Eric Codere

    Common string, numeric and pchar related utilities

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}


{** @author(Carl Eric Codere)
    @abstract(General string utilities common to all platforms.)}
    
{==== Compiler directives ===========================================}
{$B-} { Full boolean evaluation          }
{$I-} { IO Checking                      }
{$F+} { FAR routine calls                }
{$P-} { Implicit open strings            }
{$T-} { Typed pointers                   }
{$V+} { Strict VAR strings checking      }
{$X+} { Extended syntax                  }
{$IFNDEF TP}
 {$H+} { Memory allocated strings        }
 {$DEFINE ANSISTRINGS}
 {$J+} { Writeable constants             }
 {$METHODINFO OFF} 
{$ENDIF}
{====================================================================}
Unit cmnutils;

Interface

uses cmntyp, objects;
 
 
TYPE
    PshortString = ^ShortString;


CONST

  { Possible error codes returned to DOS by program }
  EXIT_DOSERROR = 2;
  EXIT_ERROR = 1;


  {** @abstract(Change the endian of a 32-bit value) }
  Procedure SwapLong(var x : longword);

  {** @abstract(Change the endian of a 16-bit value) }
  Procedure SwapWord(var x : word);


  {-------------------------- String utilities --------------------------}

  {** @abstract(Trims and adds double quotes to the string if
       it contains spaces).

  }
  function AddDoubleQuotes(s: string): string;

  {** @abstract(Removes the leading and ending double quotes from
     a string)

     If there is no double quotes at the beginning or end of the
     string, it returns the unmodified string.
  }
  function RemoveDoubleQuotes(s: string): string;


{** @abstract(Separates a string into its individual token representations)

    @param(Text Text string to tokenize, deletes itself)
    @param(Delimiter The character delimiter for tokens)
    @param(UseQuotes Are Quotes allowed for escaping the delimiter)
    @returns(The current token)

    When Text returns an empty string, this indicates that all the
    data has been parsed. If no separater exists within the string,
    then the entire string is returned and Text is immediately empty.
}
function StrToken(var Text: String; Delimiter: string; UseQuotes: boolean) : String;

{** @abstract(Returns the next-line in a possible multiple line string)

    This routine is used to retrive a line that may contain end
    of line ASCII characters in one of the standard Operating
    System formats.
    
    @param(Text Text string to parse, deletes itself)
    @returns(The string, excluding the EOLN characters)
}
function StrGetNextLine(var Text: String) : String;


  function FillTo(s : string; tolength: integer): string;

  function stringdup(const s : string) : PShortString;
  procedure stringdispose(var p : pShortString);
  

  {** Converts a C style string (containing escape characters), to
      a pascal style string. Returns the converted string. If there
      is no error in the conversion, @code(code) will be equal to
      zero.

      @param(s String to convert)
      @param(code Result of operation, 0 when there is no error)
  }
  function EscapeToPascal(const s:string; var code: integer): string;
  
  
  {** Converts a pascal style string to a C style string that contains
      escape sequences.. Returns the converted string. 

      @param(s String to convert)
  }
  function PascalToEscape(const s:string): string;
  


 {** @abstract(Trim removes leading and trailing spaces and control 
     characters from the given string S)}
{  function Trim(const S: string): string;  }


  {** @abstract(Remove all whitespace from the start of a string) }
{  function TrimLeft(const S: string): string; }

  {** @abstract(Remove all whitespace from the end of a string) }
{  function TrimRight(const S: string): string; }

  {** @abstract(Convert a value to an ASCII hexadecimal representation) 
  
     Convert a value to an ASCII hexadecimal representation. All ascii
     character are returned in upper case letters.
  }
  function hexstr(val : longint;cnt : byte) : string;

  {** @abstract(Convert a value to an ASCII decimal representation) 

      To avoid left padding with zeros, set @code(cnt) to zero.

      @param(val Signed 32-bit value to convert)
  }      
  function decstr(val : longint;cnt : byte) : string;
  
  {** @abstract(Convert a value to an ASCII decimal representation) 
  
      To avoid left padding with zeros, set @code(cnt) to zero.

      @param(val Real value to convert)
  }      
  function realstr(val : real;cnt : byte) : string;
  
  
  {** @abstract(Convert a value to an ASCII decimal representation) 
  
      To avoid left padding with zeros, set @code(cnt) to zero.
      
      @param(val unsigned 32-bit value to convert)
  }      
  function decstrunsigned(l : longword;cnt: byte): string;
  
  
 {** @abstract(Convert a boolean value to an ASCII representation) 
  
      To avoid left padding with spaces, set @code(cnt) to zero.
  }      
  function boolstr(val: boolean; cnt: byte): string; 

  
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



  {** @abstract(Generic stream error procedure)
      Generic stream error procedure that
      can be used to set @code(streamerror)
  }
  procedure StreamErrorProcedure(Var S: TStream);


  
  
  {** Convert a decimal value represented by a string to its
      numerical value. If there is no error, @code(code) will be
      equal to zero.
  }
  function ValDecimal(const S:String; var code: integer):longint;
  
  {** Convert a decimal value represented by a string to its
      numerical value. If there is no error, @code(code) will be
      equal to zero.
  }
  function ValUnsignedDecimal(const S:String; var code: integer):longword;
  
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
  
  {** Cleans up a string of illegal control characters, newlines
      and tabs. It does the following on the string:
      
      This only works on UTF-8/ASCII/ISO-8859 strings.
      
      1) Removes characters from code #0..#31 at any location
         in the string.
      2) Trims spaces at the begining and end of the string. }   
  function CleanString(const s: string): string;
  

  function ChangeFileExt(const FileName, Extension: string): string;
  

function fillwithzero(s: string; newlength: integer): string;

  {** Remove all null characters from a string.
  }
function removenulls(const s: string): string;  

{** Reads a text line from a text file. Both \r\n (Windows) and \n (UNIX) line 
    endings are supported. 
}
Function ReadLine(var T: Text): String;


const
 WHITESPACE_PRESERVE = 1;
 WHITESPACE_REPLACE  = 2;
 WHITESPACE_COLLAPSE = 3;

{** This routine is used to normalize the whitespace in a string. It can be
    used in three different ways:
    
    If normtype is WHITESPACE_PRESERVE nothing is done on the string and it is returned as is,
    if normtype is WHITESPACE_REPLACE all occurrences of #x9 (tab), #xA (line feed) and #xD
    (carriage return) are replaced with #x20 (space).
    if normtype is WHITESPACE_COLLAPSE after the processing implied by WHITESPACE_REPLACE, contiguous
    sequences of #x20's are collapsed to a single #x20, and leading and trailing #x20's 
    are removed.
    
    The values returned is a newly allocated string.
*}
function NormalizeString(instr: pchar; normtype: word): pchar;

const
 CR = #13;
 LF = #10;



Const WhiteSpace = [' ',LF,CR,#9];

Implementation

uses sysutils;

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


    
  function CleanString(const s: string): string;
  var
   outstr:string;
   i: integer;
  begin
    outstr:='';
    for i:=1 to length(s) do
      begin
        if s[i] in [#32..#255] then
          outstr:=outstr+s[i];
      end;
    { Finally remove whitespace at end and start
      of the string }
    CleanString:=trim(outstr);  
  end;

    
    
  function AddDoubleQuotes(s: string): string;
  begin
    s:=trim(s);
    AddDoubleQuotes:=s;
    if pos(' ',s) > 0 then
      AddDoubleQuotes:='"'+s+'"';
  end;

  function RemoveDoubleQuotes(s: string): string;
  begin
     if s[length(s)] = '"' then
       delete(s,length(s),1);
     if s[1] = '"' then
       delete(s,1,1);
     RemoveDoubleQuotes:=s;
  end;
  
    



   Function FillTo(s : string; tolength: integer): string;
    Begin
{$IFNDEF ANSISTRINGS}    
    { Error limit checking }
    if tolength > high(s) then
       tolength:=high(s);
{$ENDIF}
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
         LeftStr := LeftStr + RemoveUpToNull(Shortstring(Buf)) + RightStr;
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
                     OutStr := Copy(ShortString(Buf),1,b);
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
                        OutStr := Copy(ShortString(Buf),1,b);
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
   

 
 function removenulls(const s: string): string;  
 var
  outstr: string;
  i,j: integer;
 begin
  { Allocate at least enough memory if using ansistrings }
  setlength(outstr,length(s));
  j:=1;
  for i:=1 to length(s) do
    begin
      if s[i] <> #0 then
      begin
        outstr[j]:=s[i];
        inc(j);
      end;
    end;
  setlength(outstr,j-1);
  removenulls:=outstr;
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
  s: string;
begin
  SetLength(s,cnt);
  for i:=cnt downto 1 do
   begin
     s[i]:=hextbl[val and $f];
     val:=val shr 4;
   end;
  hexstr:=s; 
end;

function fillwithzero(s: string; newlength: integer): string;
 begin
{$IFNDEF ANSISTRINGS}    
    { Error limit checking }
    if newlength > high(s) then
       newlength:=high(s);
{$ENDIF}
   while length(s) < newlength do
     s:='0'+s;
   fillwithzero:=s;
 end;


function fillwithspace(s: string; newlength: integer): string;
 begin
{$IFNDEF ANSISTRINGS}    
    { Error limit checking }
    if newlength > high(s) then
       newlength:=high(s);
{$ENDIF}
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

function realstr(val : real;cnt : byte) : string;
var
  s: string;
begin
  str(val:2:2,s);
  realstr:=fillwithzero(s,cnt);
end;



function decstr(val : longint;cnt : byte) : string;
var
  s: string;
begin
  str(val,s);
  decstr:=fillwithzero(s,cnt);
end;

function decstrunsigned(l : longword;cnt: byte): string;
var
 s: string;
begin
  s:='';
  if l = 0 then
  begin
    decstrunsigned := fillwithzero('0',cnt);
    exit;
  end;
  while l>0 do
    begin
       s:=char(ord('0')+(l mod 10))+s;
       l:=l div 10;
    end;
  decstrunsigned:=fillwithzero(s,cnt);
end;

function Trim(const S: string): string;
var
 s1: string;
begin
  s1:=TrimLeft(s);
  s1:=TrimRight(s1);
  Trim:=s1;
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


function ValUnsignedDecimal(const S:String; var code: integer):longword;
{ Converts a decimal string to longint }
var
  vs: longword;
  c: longword;
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
        ValUnsignedDecimal:=0;
        exit;
      end;
   end;
  ValUnsignedDecimal:=longword(vs);
end;

Function ValDecimal(const S:String; var code: integer):longint;
{ Converts a decimal string to longint }
var
  vs: longint;
  c: longint;
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
  ValDecimal:=longint(vs);
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



function PascalToEscape(const s:string): string;
 var
  tmpString: string;
  i: integer;
 Begin
  tmpString := '';
  for i:=1 to length(s) do
    Begin
      case s[i] of
       #07:
         Begin
           tmpString := tmpString + '\a';
         end;
       #08:
         Begin
           tmpString := tmpString + '\b';
         end;
       #$0C:
         Begin
           tmpString := tmpString + '\f';
         end;
       #10:
         Begin
           tmpString := tmpString + '\n';
         end;
       #13:
         Begin
           tmpString := tmpString + '\r';
         end;
       #09:
         Begin
           tmpString := tmpString + '\t';
         end;
       #$0B:
         Begin
           tmpString := tmpString + '\v';
         end;
        '''':
         Begin
           tmpString := tmpString + '\''';
         end;
        '"': 
         Begin
           tmpString := tmpString + '\"';
         end;
        '\': 
         Begin
           tmpString := tmpString + '\\';
         end;
        else
         Begin
           tmpString := tmpString + s[i];
         end;
       end; { end case }
    end; { endif }
    PascalToEscape := tmpString;
 end;


Function EscapeToPascal(const s:string; var code: integer): string;
{ converts a C styled string - which contains escape }
{ characters to a pascal style string.               }
var
  i,len : longint;
  hs    : shortstring;
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
             if ((i+1) <= length(s)) then
               begin
                if  (s[i+1] in ['0'..'7'])  then
                   Begin
                      temp:=temp+s[i+1];
                      inc(i);
                      if (s[i+1] in ['0'..'7']) then
                         Begin
                          temp:=temp+s[i+1];
                           inc(i);
                         End;
                   End;
               end;
                c:=chr(ValOctal(temp,code));

           end;
         'x':
           Begin
             temp:=s[i+1];
             inc(i);
             if ((i+1) <= length(s)) then
             begin
                temp:=temp+s[i+1];
                inc(i);
             end;
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
     hs:=hs+c;
   end;
  EscapeToPascal:=hs;
end;



function min(a,b, val: integer): integer;
begin
  if (a < val) then
    begin
      min:=b;
      exit;
    end;
  if (b < val) then
    begin
      min:=a;
      exit;
    end;
  if (a > b)  then
    min:=b
  else
    min:=a;
end;


    {** Reads a text line from a text file. Both \r\n (Windows) and \n (UNIX) line 
        endings are supported. 
    }
    Function ReadLine(var T: Text): String;
      var
       outStr: String;
       c: char;
      Begin
        outStr := '';
        ReadLine := OutStr;
        if EOF(T) then 
          exit;
        Read(T,c);  
        Repeat 
          case c of
           CR:
           Begin
             Read(T,c);
             { We exit the loop we have finished reading, CR+LF mode (Windows,DOS) }
             if c=LF then
               begin
                  break;
               end;
             outStr := outStr + c;
           end;
          LF:
           Begin
             break;
           end;
          else
           Begin
             outStr:= outStr + c;
           end; 
          end; { end case }
          Read(T,c); 
        Until EOF(T);
        ReadLine := OutStr;
      end;



function StrGetNextLine(var Text: String) : String;
var
 s: string;
 dosidx: integer;
 unixidx: integer;
 macidx: integer;
 idx: integer;
 chars: integer;
begin
  StrGetNextLine:='';
  dosidx:=pos(#13#10,Text);
  unixidx:=pos(#10,Text);
  macidx:=pos(#13,Text);
  idx:=0;
  { Now we must use the one which is closer }
  idx:=min(dosidx,unixidx,1);
  idx:=min(idx,macidx,1);
  if idx = dosidx then
    chars:=2
  else
    chars:=1;
  if idx > 0 then
    begin
      StrGetNextLine:=Copy(Text,1,idx-1);
      delete(Text,1,idx+chars-1);
      exit;
    end;
  { No newline character - then return the entire string }
  StrGetNextLine:=Text;
  Text:='';
end;


function StrToken(var Text: String; Delimiter: String; UseQuotes: boolean) : String;
var
 apos: integer;
 dqpos: integer;
 tmpstr: string;
 idx: integer;
begin
 StrToken:='';
 TmpStr:='';
 apos := Pos(Delimiter, Text);
 { Check if there are quotes }
 if UseQuotes then
   begin
     dqpos:=pos('"',Text);
     if (dqpos > 0) and (dqpos < apos) then
       begin
         tmpstr:=Copy(Text,1,dqpos);
         delete(Text,1,dqpos);
         idx:=1;
         while (idx < length(Text)) and (Text[idx] <> '"') do
           begin
             tmpstr:=tmpstr+Text[idx];
             inc(idx);
           end;
         tmpstr:=tmpstr+'"';
         delete(Text,1,idx);
         StrToken:=TmpStr;
         apos := Pos(Delimiter, Text);
         if (apos <= 0) then
           Begin
             exit;
             Text:='';
           end;
       end;
     { No special separation to do... }
   end;

 if (apos > 0) then
 begin
   StrToken := TmpStr+Copy(Text, 1, apos - 1);
   Delete(Text, 1, apos - 1 + length(Delimiter));
 end
 else
  begin
      StrToken := Text;
      Text := '';
  end;
end;


function NormalizeString(instr: pchar; normtype: word): pchar;
var
 p,p1: pchar;
 inlen: integer;
 outidx: integer;

 outlen: integer;
 outstr: pchar;
 i: integer;
type
 utf8char = ansichar;
const
 SPACE_CHARACTER = #32;
begin
 inlen:=strlen(instr);
 { Do not forget the terminating null character }
 Getmem(p, inlen+sizeof(utf8char));
 if normtype = WHITESPACE_PRESERVE then
   begin
     NormalizeString:=strnew(instr);
     exit;
   end;
 i:=0;
 { We have here at least WHITESPACE_REPLACE }
 outidx:=0;
 while instr[i] <> #0 do
   begin
     if instr[i] in [#9,#10,#13] then
        p[outidx]:=#$20
     else   
        p[outidx]:=instr[i];
     inc(outidx);
     inc(i);
   end;
 p[outidx]:=#0;
 if normtype = WHITESPACE_REPLACE then
   begin
     { Add one more byte for the null character }
     outlen:=strlen(p)+sizeof(utf8char);
     getmem(outstr,outlen);
     move(p^,outstr^,outlen);
     freemem(p,inlen);
     NormalizeString:=outstr;
     exit;
   end;
 i:=0;
 outidx:=0;
 if normtype = WHITESPACE_COLLAPSE then
   begin
    getmem(p1,inlen);       
    while p[i] <> #0 do
     begin
       if p[i] = SPACE_CHARACTER then
         begin
           inc(i);
           p1[outidx]:=SPACE_CHARACTER;
           while p[i] = SPACE_CHARACTER do
             inc(i);
         end
       else
         begin
          p1[outidx]:=p[i];
          inc(i);
         end;
       inc(outidx);
     end; { end while }
     p1[outidx]:=#0;
     { Add one more byte for the null character }
     outlen:=strlen(p1)+sizeof(utf8char);
     getmem(outstr,outlen);
     move(p1^,outstr^,outlen);
     freemem(p1,inlen);
     NormalizeString:=outstr;
     exit;
   end;
end;


end.
{
  $Log: not supported by cvs2svn $
  Revision 1.30  2011/11/24 00:27:39  carl
  + update to new architecture of dates and times, as well as removal of some duplicate files.

  Revision 1.29  2011/04/12 00:27:45  carl
  + Added realstr routine to convert floating point values to a string representation.

  Revision 1.28  2007/02/14 04:44:08  carl
    * Bugfix of infinite loop in certain instances with strings and when ansistrings are not enabled.

  Revision 1.27  2007/01/06 20:23:13  carl
    - Remove extdos reference

  Revision 1.26  2006/12/23 23:15:39  carl
    + Added support for ValUnsignedDecimal()

  Revision 1.25  2006/12/03 22:08:41  carl
    + StrGetNextLine() added

  Revision 1.24  2006/11/10 04:07:25  carl
     + Unicode: ucs4_iswhitespace(), ucs4_isterminal(), ucs4_getnumericvalue()
        ucs4_ishexdigit(), ucs4_isdigit(). All tables are now public
        for easier parsing for ISO-8859-1 and ASCII character sets.
     + Utils: StrToken.
     + SGML: Support for all known entities

  Revision 1.23  2006/08/31 03:02:33  carl
  + Better documentation

  Revision 1.22  2005/11/21 00:18:15  carl
    - remove some compilation warnings/hints
    + speed optimizations
    + recreated case.inc file from latest unicode casefolding standard

  Revision 1.21  2005/11/09 05:14:56  carl
    * Renamed FileExists and DirectoryExists to AnsiFileExists and AnsiDirectoryExists

  Revision 1.20  2005/08/12 20:19:38  ccodere
    + more documentation of hexstr()

  Revision 1.19  2005/08/08 12:03:52  carl
    + AddDoubleQuotes/RemoveDoubleQuotes
    + Add support for RemoveAccents in unicode

  Revision 1.18  2005/01/06 03:20:51  carl
    * overflow error bugfix

  Revision 1.17  2004/11/29 03:45:55  carl
    + speed optimization of upcase (no longer calls system unit routine)

  Revision 1.16  2004/11/23 03:45:25  carl
    + ErrOutput standard error stream support

  Revision 1.15  2004/11/21 19:54:26  carl
    * 10-25% speed optimizations (change some parameter types to const, code folding)

  Revision 1.14  2004/11/09 03:50:23  carl
    + added lowstring routine

  Revision 1.13  2004/10/27 02:01:11  carl
    + trim added

  Revision 1.12  2004/09/13 02:41:57  carl
    + DirectoryExists routine

  Revision 1.11  2004/09/06 19:40:24  carl
    * clear IOResult before using I/O routines in FileExists

  Revision 1.10  2004/08/27 02:11:07  carl
    + added filemodes, as defined in sysutils

  Revision 1.9  2004/08/20 04:08:01  carl
    * range check error bugfixes in EscapeToPascal

  Revision 1.8  2004/08/19 00:25:10  carl
    + removenull routine

  Revision 1.7  2004/08/01 05:33:49  carl
   - remove uppercase routine (use upstring instead)

  Revision 1.6  2004/07/15 01:01:07  carl
    + unsigned decimal conversion

  Revision 1.5  2004/07/05 02:25:45  carl
    + fix some compiler option targets
    - remove some compiler warnings

  Revision 1.4  2004/06/20 18:49:40  carl
    + added  GPC support

  Revision 1.3  2004/06/17 11:46:54  carl
    + CompareByte routine

  Revision 1.2  2004/05/13 23:03:40  carl
    + added decstr()
    + added boolstr()

  Revision 1.1  2004/05/05 16:28:23  carl
    Release 0.95 updates

}
