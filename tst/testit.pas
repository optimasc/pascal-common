{ This program tests the features of the common units
  as well as unicode support
}

{ Takes as a parameter the path where the execution will take place }
Program Testit;

{$I+}
{$ifndef tp}
{$H-}
{$endif}
{$X+}
{$T+}
uses dpautils,
     vpautils,
     fpautils,
     tpautils,
     gpautils,
     locale,
     ietf,
     unicode,
     dos,
     strings
     ;

  var
   infilepath:string;
  
  { Convert UTF-8 to UTF-32 and then convert it to ISO8859-1 }
  procedure testreadutf8;
  var
   F: file;
   utfstr,outstr: utf8string;
   utf32str: utf32string;
   i: integer;
   s: string;
  begin
   Assign(F,infilepath+'t-utf8.txt');
   Reset(F,1);
   i:=1;
   Seek(F,3);
   Repeat
     BlockRead(F, utfstr[i],sizeof(utfstr[i]));
     inc(i);
   Until Eof(F);
   utfstr[0]:=chr(i-1);
   Close(F);
   if (ConvertUTF8ToUTF32(utfstr,utf32str) <> 0) then
      RunError(255);
   if (ConvertFromUTF32(utf32str, s,'ISO-8859-1') <> 0) then
      RunError(255);
   WriteLn(s);
   { Now verify if we get the original value by reconverting to
     an UTF-8 stream
   }
   if (ConvertUTF32ToUTF8(utf32str,outstr) <> 0) then
      RunError(255);
   for i:=1 to ord(utfstr[0]) do
       begin
         if outstr[i] <> utfstr[i] then
           RunError(255);
       end;
  end;
  
  { Convert UTF-16 to UTF-32 and then convert it to ISO8859-1 }
  procedure testreadutf16le;
  var
   F: file;
   utfstr,outstr: utf16string;
   utf32str: utf32string;
   i: integer;
   s: string;
  begin
   Assign(F,infilepath+'t-utf16l.txt');
   Reset(F,1);
   i:=1;
   Seek(F,2);
   Repeat
     BlockRead(F, utfstr[i],sizeof(utfstr[i]));
{$ifdef endian_big}
     SwapWord(utfstr[i]);
{$endif}
     inc(i);
   Until Eof(F);
   utfstr[0]:=i-1;
   Close(F);
   if (ConvertUTF16ToUTF32(utfstr,utf32str) <> 0) then
      RunError(255);
   if (ConvertFromUTF32(utf32str, s,'ISO-8859-1') <> 0) then
      RunError(255); 
   WriteLn(s);   
   { Now verify if we get the original value by reconverting to
     an UTF-16 stream
   }
   if (ConvertUTF32ToUTF16(utf32str,outstr) <> 0) then
      RunError(255);
   for i:=1 to ord(utfstr[0]) do
       begin
         if outstr[i] <> utfstr[i] then
           RunError(255);
       end;
  end;
  
  { Convert CP850 to UTF-32 and then convert it to ISO8859-1 }
  procedure testreadcp850;
  var
   F: file;
   utfstr: string;
   utf32str: utf32string;
   i: integer;
   s: string;
  begin
   Assign(F,infilepath+'t-cp850.txt');
   Reset(F,1);
   i:=1;
   Repeat
     BlockRead(F, utfstr[i],sizeof(utfstr[i]));
     inc(i);
   Until Eof(F);
   SetLength(utfstr,i-1);
   Close(F);
   if (ConvertToUTF32(utfstr,utf32str,'cp850') <> 0) then
      RunError(255);
   if (ConvertFromUTF32(utf32str, s,'ISO-8859-1') <> 0) then
      RunError(255); 
   WriteLn(s);
  end;


  {
  procedure utf32_delete(var s: utf32string; index: integer; count: integer);
}
  
  procedure testutf32;
  var
   s1ascii: string;
   s2ascii: string;
   s1utf: utf32string;
   s2utf: utf32string;
   resultstr: utf32string;
   s3ascii: string;
   utfchar: array[1..1] of utf32;
   utfstr: utf32string;
   idx: integer;
  begin
   s1ascii:='Hello';
   s2ascii:='This is a small Hello';
   ConvertToUTF32(s1ascii,s1utf,'ASCII');
   if utf32_length(s1utf) <> length(s1ascii) then
     RunError(255);
   ConvertToUTF32(s2ascii,s2utf,'ASCII');
   if utf32_length(s2utf) <> length(s2ascii) then
     RunError(255);

   utf32_copy(resultstr,s2utf,6,200);
   ConvertFromUTF32(resultstr,s3ascii,'ASCII');
   if s3ascii <> 'is a small Hello' then
     RunError(255);
   if utf32_pos(s1utf,s2utf) <> pos(s1ascii,s2ascii) then
     RunError(255);
   utf32_copy(resultstr,s2utf,utf32_pos(s1utf,s2utf),utf32_length(s2utf));
   ConvertFromUTF32(resultstr,s3ascii,'ASCII');
   WriteLn(s3ascii);
   if s3ascii <> s1ascii then
     RunError(255);
   utfchar[1]:=ord('!');
   utf32_setlength(resultstr,0);
   utf32_copy(resultstr,s1utf,1,utf32_length(s1utf));
   utf32_concat(resultstr,s1utf,utfchar);
   if utf32_length(resultstr) <> (length(s1ascii)+1) then
     Runerror(255);
   ConvertFromUTF32(resultstr,s3ascii,'ASCII');
   if s3ascii <> 'Hello!' then
     RunError(255);
   utf32_setlength(resultstr,0);
   utf32_concat(resultstr,s1utf,s2utf);
   if utf32_length(resultstr) <> (length(s1ascii)+length(s2ascii)) then
     Runerror(255);
   ConvertFromUTF32(resultstr,s3ascii,'ASCII');
   if s3ascii <> (s1ascii+s2ascii) then
     RunError(255);
   utf32_setlength(resultstr,0);
   utf32_concat(resultstr,resultstr,s2utf);
   if utf32_length(resultstr) <> (length(s2ascii)) then
     Runerror(255);
   ConvertFromUTF32(resultstr,s3ascii,'ASCII');
   if s3ascii <> (s2ascii) then
     RunError(255);
   { delete testing }

   utf32_copy(resultstr,s2utf,1,255);
   utf32_delete(resultstr,1,utf32_length(resultstr));
   if utf32_length(resultstr) <> 0 then
     Runerror(255);


   utf32_copy(resultstr,s1utf,1,255);
   utf32_setlength(utfstr,0);
   utfchar[1]:=ord('o');
   utf32_concat(utfstr,utfstr,utfchar);
   idx:=utf32_pos(utfstr,resultstr);
   utf32_delete(resultstr,idx,utf32_length(resultstr));
   if utf32_length(resultstr) <> length('Hell') then
     Runerror(255);
   ConvertFromUTF32(resultstr,s3ascii,'ASCII');
   if s3ascii <> 'Hell' then
     RunError(255);

   utf32_copy(resultstr,s1utf,1,255);
   utf32_setlength(utfstr,0);
   utfchar[1]:=ord('l');
   utf32_concat(utfstr,utfstr,utfchar);
   idx:=utf32_pos(utfstr,resultstr);
   utf32_delete(resultstr,idx,2);
   ConvertFromUTF32(resultstr,s3ascii,'ASCII');
   if s3ascii <> 'Heo' then
     RunError(255);

  end;

  procedure testisvalidisodatestring;
  begin
   if not IsValidIsoDateString('1998') then
     Runerror(255);
   if IsValidIsoDateString(' 998') then
     Runerror(255);
   if IsValidIsoDateString('C') then
     Runerror(255);
   if IsValidIsoDateString('20056') then
     Runerror(255);
   if IsValidIsoDateString('1998/06/12') then
     Runerror(255);
   if not IsValidIsoDateString('1998-02') then
     Runerror(255);
   if IsValidIsoDateString('1998-2') then
     Runerror(255);
   if not IsValidIsoDateString('19980201') then
     Runerror(255);
   if not IsValidIsoDateString('1998-02-01') then
     Runerror(255);
  end;
  
  procedure testisvalidisotimestring;
  begin
   if not IsValidIsoTimeString('00:59:59') then
     RunError(255);
   if IsValidIsoTimeString('25:59:59') then
     RunError(255);
   if IsValidIsoTimeString('00Z59:59') then
     RunError(255);
   if IsValidIsoTimeString('00:59Z59') then
     RunError(255);
   if IsValidIsoTimeString('00:59:77') then
     RunError(255);
   if not IsValidIsoTimeString('00:59:59+00:30') then
     RunError(255);
   if IsValidIsoTimeString('00:59:59+ZZ:30') then
     RunError(255);
   if IsValidIsoTimeString('00:59:59W00:30') then
     RunError(255);
   if not IsValidIsoTimeString('00:59:59-01:00') then
     RunError(255);
   if not IsValidIsoTimeString('00:59:59Z') then
     RunError(255);
   if not IsValidIsoTimeString('005959') then
     RunError(255);
   if not IsValidIsoTimeString('005959') then
     RunError(255);
   if not IsValidIsoTimeString('005959Z') then
     RunError(255);
   if not IsValidIsoTimeString('00:59') then
     RunError(255);
   if not IsValidIsoTimeString('0059') then
     RunError(255);
     
  end;
  

  procedure testisvalidisodatetimestring;
  begin
   if not IsValidIsoDateTimeString('1998-02-01T00:59:59') then
     RunError(255);
  end;

  procedure testurn;
  begin
   if urn_isvalid('urn:@34') then
     RunError(255);
   if not urn_isvalid('urn:34-4567:345') then
     RunError(255);
   if urn_isvalid('urn:3:345%%') then
     RunError(255);
   if urn_isvalid('urn::345') then
     RunError(255);
   if not urn_isvalid('urn:ISBN:345-4567') then
     RunError(255);
   if not urn_isvalid('urn:ISBN:345-%ff4567') then
     RunError(255);
  end;

  procedure testmime;
  begin
    if not mime_isvalidcontenttype('audio/x-test') then
      RunError(255);
    if mime_isvalidcontenttype('audio-x-test') then
      RunError(255);
    if mime_isvalidcontenttype('audio') then
      RunError(255);
  end;

  procedure testcharencoding;
  var
   _name: shortstring;
  begin
    if GetCharEncoding('',_name)<>CHAR_ENCODING_UNKNOWN then
      RunError(255);
    if _name <> '' then
      RunError(255);
    if GetCharEncoding('ASCII',_name)<>CHAR_ENCODING_BYTE then
      RunError(255);
    if _name<>'US-ASCII' then
      RunError(255);
    GetCharEncoding('ISO-IR-84',_name);
    if _name <> 'PT2' then
      RunError(255);
    if GetCharEncoding('UTF-8',_name)<>CHAR_ENCODING_UTF8 then
       RunError(255);
    if _name <> 'UTF-8' then
      RunError(255);
  end;


  { Test UTF-32 and UTF-8 null terminated string encodings }
  procedure testutfnull;
  const
   utf32null: array[0..5] of utf32 =
   (ord('H'),ord('e'),Ord('l'),Ord('l'),Ord('o'),0);
   strnull:pchar = 'Hello';
   utf8null: pchar =
   'récéption donnée pour mon reçu.'#0;
  var
   utf32s: utf32string;
   utf32buffer: array[0..1023] of utf32;
   p: pchar;
   putf: putf32char;
   s: string;
  begin
    if utf32strlen(nil) <> 0 then
       RunError(255);
    if utf32strlen(putf32char(@utf32null)) <> ((sizeof(utf32null) div sizeof(utf32)) - 1) then
       RunError(255);
    utf32strpas(nil,utf32s);
    if utf32_length(utf32s) <> 0 then
       RunError(255);
    utf32strpas(putf32char(@utf32null),utf32s);
    if not utf32_equalascii(utf32s,'Hello') then
       RunError(255);
    if utf32strpasToISO8859_1(nil) <> '' then
       RunError(255);
    if utf32strpasToISO8859_1(putf32char(@utf32null)) <> 'Hello' then
       RunError(255);
    if UTF32StrPCopy(nil, utf32s) <> nil then
       RunError(255);
    if UTF32StrPCopyISO8859_1(nil, 'Hello') <> nil then
       RunError(255);
    p:=UTF8StrNew(putf32char(@utf32null));
    if strcomp(p,'Hello') <> 0 then
      RunError(255);
    putf:=utf32strnew(strnull,'CP850');
    if assigned(putf) then
       RunError(255);
    putf:=utf32strnew(strnull,'cp850');
    putf:=utf32strdispose(putf);
    if assigned(putf) then
       RunError(255);
    putf:=utf32strnew(nil,'cp850');
    if assigned(putf) then
       RunError(255);
    putf:=utf32strdispose(putf);
    putf:=utf32strnew(utf8null,'UTF-8');
    s:=utf32strpastoiso8859_1(putf);
    putf:=utf32strdispose(putf);
  end;
  


var
  s: string;
  b: boolean;
  myptrtypecast: ptrint;
  path: pathstr;
  savedpath: string;
  Dir: DirStr;
  _Name: NameStr;
  Ext: Extstr;
Begin
  path:=paramstr(0);
  { Takes as a parameter the path where the execution will take place }
  if paramcount <> 0 then
    begin
      infilepath:=paramstr(1);
    end
  else
      infilepath:='';
  path:=FExpand(path);
  WriteLn(Infilepath);
  Fsplit(Path,Dir,_Name,Ext);
  s:=LineEnding;
  s:=DirectorySeparator;
  s:=PathSeparator;
  b:=FileNameCaseSensitive;
  testreadutf8;
  testreadutf16le;
  testreadcp850;
  testisvalidisodatestring;
  testisvalidisotimestring;
  testisvalidisodatetimestring;
  testurn;
  testmime;
  testutf32;
  testcharencoding;
  testutfnull;
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.6  2004/07/05 02:29:26  carl
    + add testsuit for UTF null terminated strings

  Revision 1.5  2004/06/20 18:46:02  carl
    + updated for GPC support

  Revision 1.4  2004/06/17 11:43:13  carl
    + tests for utf-32
    + tests for character encoding

  Revision 1.3  2004/05/13 23:05:19  carl
    + add tests for ietf unit
    + more tests for ISO Date/time conversion

  Revision 1.2  2004/05/06 15:29:55  carl
    + tests for unicode conversion

}
