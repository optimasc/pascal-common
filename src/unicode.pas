{
 ****************************************************************************
    $Id: unicode.pas,v 1.1 2004-05-05 16:28:22 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Unicode related routines

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}
{** @author(Carl Eric Codere)
    @abstract(unicode support unit)

    This unit contains routines to convert
    between the different unicode encoding
    schemes. The code was converted to Pascal
    from the C code located at:
    http://www.unicode.org/Public/PROGRAMS/CVTUTF/
}
unit unicode;

interface

uses 
  tpautils,
  vpautils,
  dpautils,
  fpautils,
  utils;

type
  {** UTF-8 base data type }
  utf8 = char;
  {** UTF-16 base data type }
  utf16 = word;
  {** UTF-32 base data type }
  utf32 = longword;

  {** UTF-8 string declaration }
  utf8string = array[0..1024] of utf8;
  {** UTF-32 string declaration }
  utf32string = array[0..255] of utf32;
  {** UTF-16 string declaration }
  utf16string = array[0..255] of utf16;

const  
  {** Return status: conversion successful }
  UNICODE_ERR_OK =     0;
  {** Return status: source sequence is illegal/malformed }
  UNICODE_ERR_SOURCEILLEGAL = -1;
  
  {** @abstract(Returns the current length of an UTF-16 string) }
  function lengthUTF16(s: array of utf16): integer;

  {** @abstract(Returns the current length of an UTF-8 string) }
  function lengthutf8(s: array of utf8): integer;

  {** @abstract(Set the length of an UTF-8 string) }
  procedure setlengthUTF8(var s: array of utf8; l: integer);

  {** @abstract(Set the length of an UTF-16 string) }
  procedure setlengthUTF16(var s: array of utf16; l: integer);

  {** @abstract(Convert an UTF-16 string to an UTF-8 string) 
  }
  function convertUTF16toUTF8(s: array of utf16; var outstr: utf8string): integer;

  {** @abstract(Convert an UTF-8 string to an ASCII string) 
  }
  function convertUTF8toASCII(s: array of utf8): shortstring;



implementation

const
  {* Some fundamental constants *}
  UNI_REPLACEMENT_CHAR = $0000FFFD;
  UNI_MAX_BMP          = $0000FFFF;
  UNI_MAX_UTF16        = $0010FFFF;
  UNI_MAX_UTF32        = $7FFFFFFF;

   const 
    halfShift  = 10; {* used for shifting by 10 bits *}

    halfBase = $0010000;
    halfMask = $3FF;

    UNI_SUR_HIGH_START = $D800;
    UNI_SUR_HIGH_END   = $DBFF;
    UNI_SUR_LOW_START  = $DC00;
    UNI_SUR_LOW_END    = $DFFF;
    
    

{*
 * Once the bits are split out into bytes of UTF-8, this is a mask OR-ed
 * into the first byte, depending on how many bytes follow.  There are
 * as many entries in this table as there are UTF-8 sequence types.
 * (I.e., one byte sequence, two byte... six byte sequence.)
 *}
 const firstByteMark: array[0..6] of utf8 = 
 (
   #$00, #$00, #$C0, #$E0, #$F0, #$F8, #$FC
 );  
   
  function convertUTF16toUTF8(s: array of utf16; var outstr: utf8string): integer;
  const
    byteMask : utf32 = $BF;
    byteMark : utf32 = $80;
  var
   ch,ch2: utf32;
   OutStringLength : byte;
   OutIndex : integer;
   i: integer;
   BytesToWrite: integer;
   Currentindex: integer;
  begin
    OutIndex := 1;
    OutStringLength := 0;
    fillchar(outstr,1024,#0);
    for i:=1 to lengthUTF16(s) do
    begin
      ch:=s[i];
      {* If we have a surrogate pair, convert to UTF32 first. *}
    
      if (ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_HIGH_END) and (i < lengthUTF16(s)) then
        begin
          ch2:=s[i+1];
          if (ch2 >= UNI_SUR_LOW_START) and (ch2 <= UNI_SUR_LOW_END) then
            begin
              ch := ((ch - UNI_SUR_HIGH_START) shl halfShift) + (ch2 - UNI_SUR_LOW_START) + halfBase;
            end 
          else 
            begin
              {* it's an unpaired high surrogate *}
              convertUTF16toUTF8 := UNICODE_ERR_SOURCEILLEGAL;
              exit;
            end  
        end
      else 
        if (ch >= UNI_SUR_LOW_START) and (ch <= UNI_SUR_LOW_END) then
          begin
            {* it's an unpaired high surrogate *}
            convertUTF16toUTF8 := UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end;
      {* Figure out how many bytes the result will require *}
      if (ch < utf32($80)) then
        bytesToWrite := 1
      else 
      if (ch < $800) then
        bytesToWrite := 2
      else 
      if (ch < $10000) then
        bytesToWrite := 3
      else 
      if (ch < $200000) then
        bytesToWrite := 4
      else 
        begin
          bytesToWrite := 2;
          ch := UNI_REPLACEMENT_CHAR;
        end;
      Inc(outindex,BytesToWrite);  
    
      CurrentIndex := BytesToWrite;
      if CurrentIndex = 4 then
      begin
        dec(OutIndex);
        outstr[outindex] := utf8((ch or byteMark) and ByteMask);
        ch:=ch shr 6;
        dec(CurrentIndex);
      end;
      if CurrentIndex = 3 then
      begin
        dec(OutIndex);
        outstr[outindex] := utf8((ch or byteMark) and ByteMask);
        ch:=ch shr 6;
        dec(CurrentIndex);
      end;
      if CurrentIndex = 2 then
      begin
        dec(OutIndex);
        outstr[outindex] := utf8((ch or byteMark) and ByteMask);
        ch:=ch shr 6;
        dec(CurrentIndex);
      end;
      if CurrentIndex = 1 then
      begin
        dec(OutIndex);
        outstr[outindex] := utf8((byte(ch) or byte(FirstbyteMark[BytesToWrite])));
        dec(CurrentIndex);
      end;  
      
      inc(OutStringLength);
      Inc(OutIndex,BytesToWrite);

      end;
     setlengthutf8(outstr,OutStringLength);
  end;

  function lengthUTF16(s: array of utf16): integer;
  begin
   LengthUTF16:=integer(s[0]);
  end;

  function lengthutf8(s: array of utf8): integer;
  begin
   LengthUTF8:=integer(s[0]);
  end;
  

  procedure setlengthutf8(var s: array of utf8; l: integer);
  begin
    s[0]:=utf8(l);
  end;

  procedure setlengthutf16(var s: array of utf16; l: integer);
  begin
   s[0]:=utf16(l);
  end;


  function convertUTF8toASCII(s: array of utf8): shortstring;
  var
   i: integer;
   outstr: shortstring;
  begin
    outstr:='';
    for i:=1 to lengthUTF8(s) do
    begin
      if s[i] in [#01..#127] then
      begin
        outstr:=outstr + s[i];
      end;
    end;
   convertUTF8toAscii:=outstr;
  end;

end.

{
  $Log: not supported by cvs2svn $

}
  
  

