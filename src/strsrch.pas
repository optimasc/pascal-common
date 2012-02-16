{** @abstract(Unit implementing Boyer-Moore string searching)

   This is one of the fastest string search algorithms.
   See a description in:

     R. Boyer and S. Moore.
     A fast string searching algorithm.
     Communications of the ACM 20, 1977, Pags 762-772
     
   The author and license of this unit is unknown. It has
   been modified to be portable across different compilers.

}
unit strsrch;
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



interface

uses objects;


type
{$IFDEF TP}
  size_t = word;
{$ELSE}
  size_t = cardinal;
{$ENDIF}


type
   TTranslationTable = array[char] of char;  { translation table }

   {** Main object for pattern searching. 
   
       This class implements searching on either ASCII or ISO-8859-1 / ANSI
       encoded string or byte array (encoded as pchars, null termination
       characters are ignored).
       
       The CharSet parameter for search setup shall either be ISO-8859-1,
       or ASCII. These are case-sensitive. If the CharSet parameter is 
       left empty, then it is considered being an ASCII binary comparison.
   }
   TStringSearch = Object(TObject)
   private
      FTranslate  : TTranslationTable;     { translation table }
      FJumpTable  : array[char] of Byte;   { Jumping table }
      FShift_1    : integer;
      FPattern    : pchar;
      FPatternLen : size_t;
   public
      {** @abstract(Prepares a search.)
       
          @param(Pattern Pattern that we will match against. This is considered a BYTE array not
            a null terminated string)
          @param(PatternLen Number of bytes in the pattern)
          @param(IgnoreCase Indicates if the search will be case sensitive or case insensitive)
      }
      procedure Prepare( Pattern: pchar; PatternLen: size_t; CharSet: string; IgnoreCase: Boolean );
      {** @abstract(Prepares a search.)
       
          @param(Pattern Pattern that we will match against as a string)
          @param(PatternLen Number of bytes in the pattern)
          @param(CharSet Character set of the encoding of the pattern and buffer)
          @param(IgnoreCase Indicates if the search will be case sensitive or case insensitive)
      }
      procedure PrepareStr( const Pattern: string; CharSet: string; IgnoreCase: Boolean );
      {** @abstract(Searches for the previously-specified pattern in the byte array Text)
      
         @param(Text The actual byte array encoded as a pchar to search in)
         @param(TextLen The length of the byte array)
         @returns(nil if not found, otherwise the positiion of the first match in the buffer)
      }   
      function  Search( Text: pchar; TextLen: size_t ): pchar;
      {** @abstract(Searches for the previously-specified pattern in the string S)
      
         @param(S String to search in)
         @returns(returns 0 if the pattern is not found)
      }   
      function  Pos( const S: string ): integer;
   end;




implementation


uses  unicode,sysutils;



(* -------------------------------------------------------------------
   Ignore Case Table Translation
------------------------------------------------------------------- *)

procedure CreateTranslationTable( var T: TTranslationTable; CharSet: string; IgnoreCase: Boolean );
var
   c: char;
   i: integer;
begin
   for c := #0 to #255 do
       T[c] := c;

   if not IgnoreCase then
      exit;
      
   for c := 'a' to 'z' do
      T[c] := UpCase(c);

   { Mapping all accented characters to their uppercase equivalent }
   if CharSet = 'ISO-8859-1' then
     begin
       for i:=$80 to $ff do
        T[chr(i)]:=char(ucs4_upcase((ucs4char(i)))); 
    end;        
end;



(* -------------------------------------------------------------------
   Preparation of the jumping table
------------------------------------------------------------------- *)

procedure TStringSearch.Prepare( Pattern: pchar; PatternLen: size_t; CharSet: string;
                             IgnoreCase: Boolean );
var
   i: integer;
   c, lastc: char;
begin
   FPattern := Pattern;
   FPatternLen := PatternLen;

   if FPatternLen < 1 then
      FPatternLen := strlen(FPattern);

   { This algorythm is based in a character set of 256 }

   if FPatternLen > 256 then
      exit;


   { 1. Preparing translating table }

   CreateTranslationTable( FTranslate, CharSet, IgnoreCase);


   { 2. Preparing jumping table }

   for c := #0 to #255 do
      FJumpTable[c] := FPatternLen;

   for i := FPatternLen - 1 downto 0 do begin
      c := FTranslate[FPattern[i]];
      if FJumpTable[c] >= FPatternLen - 1 then
         FJumpTable[c] := FPatternLen - 1 - i;
   end;

   FShift_1 := FPatternLen - 1;
   lastc := FTranslate[Pattern[FPatternLen - 1]];

   for i := FPatternLen - 2 downto 0 do
      if FTranslate[FPattern[i]] = lastc  then begin
         FShift_1 := FPatternLen - 1 - i;
         break;
      end;

   if FShift_1 = 0 then
      FShift_1 := 1;
end;


procedure TStringSearch.PrepareStr( const Pattern: string; CharSet: string; IgnoreCase: Boolean );
var
   str: pchar;
begin
   if Pattern <> '' then begin
      str := @Pattern[1];
      Prepare( str, Length(Pattern), CharSet, IgnoreCase);
   end;
end;



{ Searching Last char & scanning right to left }

function TStringSearch.Search( Text: pchar; TextLen: size_t ): pchar;
var
   shift, m1, j: integer;
   jumps: size_t;
begin
   Search := nil;
   if FPatternLen > 256 then
      exit;

   if TextLen < 1 then
      TextLen := strlen(Text);


   m1 := FPatternLen - 1;
   shift := 0;
   jumps := 0;

   { Searching the last character }

   while jumps <= TextLen do begin
      Inc( Text, shift);
      shift := FJumpTable[FTranslate[Text^]];
      while shift <> 0 do begin
          Inc( jumps, shift);
          if jumps > TextLen then
             exit;

          Inc( Text, shift);
          shift := FJumpTable[FTranslate[Text^]];
      end;

      { Compare right to left FPatternLen - 1 characters }

      if jumps >= m1 then begin
         j := 0;
         while FTranslate[FPattern[m1 - j]] = FTranslate[(Text - j)^] do begin
            Inc(j);
            if j = FPatternLen then begin
               Search := Text - m1;
               exit;
            end;
         end;
      end;

      shift := FShift_1;
      Inc( jumps, shift);
   end;
end;


function TStringSearch.Pos( const S: string ): integer;
var
   str, p: pchar;
begin
   Pos:= 0;
   if S <> '' then begin
      str := @S[1];
      p := Search( str, Length(S));
      if p <> nil then
         Pos := 1 + (p - str);
   end;
end;



end.

{
  $Log: not supported by cvs2svn $
  Revision 1.1  2007/01/03 01:40:29  carl
   - Remove and rename for better delphi compatibility

  Revision 1.1  2006/12/06 21:13:56  ccodere
    + char based canonical analysis (unicode.pas)
    + Boyer-Moore search algorithm

}