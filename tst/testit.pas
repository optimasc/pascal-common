{ This program tests the features of the common units
  as well as unicode support
}

{ Takes as a parameter the path where the execution will take place }
Program Testit;

{$I+}
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
     strings,
     iso639,
     utils,
     testdate
     ;

  var
   infilepath:string;

  { Convert UTF-8 to UTF-32 and then convert it to ISO8859-1 }
  procedure testreadutf8;
  var
   F: file;
   utfstr,outstr: utf8string;
   utf32str: ucs4string;
   c: char;
   i: integer;
   s: string;
  begin
   Assign(F,infilepath+'t-utf8.txt');
   Reset(F,1);
   i:=1;
   Seek(F,3);
   utf8_setlength(utfstr,0);
   Repeat
     BlockRead(F, c,sizeof(c));
     utfstr:=utfstr+c;
     inc(i);
   Until Eof(F);
   utf8_setlength(utfstr,i-1);
   Close(F);
   if (ConvertUTF8ToUCS4(utfstr,utf32str) <> 0) then
      RunError(255);
   if (ConvertFromUCS4(utf32str, s,'ISO-8859-1') <> 0) then
      RunError(255);
   WriteLn(s);
   { Now verify if we get the original value by reconverting to
     an UTF-8 stream
   }
   if (ConvertUCS4ToUTF8(utf32str,outstr) <> 0) then
      RunError(255);
   for i:=1 to utf8_length(utfstr) do
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
   utf32str: ucs4string;
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
   if (ConvertUTF16ToUCS4(utfstr,utf32str) <> 0) then
      RunError(255);
   if (ConvertFromUCS4(utf32str, s,'ISO-8859-1') <> 0) then
      RunError(255); 
   WriteLn(s);   
   { Now verify if we get the original value by reconverting to
     an UTF-16 stream
   }
   if (ConvertUCS4ToUTF16(utf32str,outstr) <> 0) then
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
   utf32str: ucs4string;
   i: integer;
   s: string;
   c: char;
  begin
   Assign(F,infilepath+'t-cp850.txt');
   Reset(F,1);
   i:=1;
   setLength(utfstr,0);
   Repeat
     BlockRead(F, c,sizeof(c));
     utfstr:=utfstr+c;
     inc(i);
   Until Eof(F);
   SetLength(utfstr,i-1);
   Close(F);
   if (ConvertToUCS4(utfstr,utf32str,'cp850') <> 0) then
      RunError(255);
   if (ConvertFromUCS4(utf32str, s,'ISO-8859-1') <> 0) then
      RunError(255); 
   WriteLn(s);
  end;


  {
  procedure ucs4_delete(var s: ucs4string; index: integer; count: integer);
}

  { 255 character string, to test the limits }
  const
   limitstr: string[255] =
   ('012345678901234567890123456789012345678901234567890123456789'+
    '012345678901234567890123456789012345678901234567890123456789'+
    '012345678901234567890123456789012345678901234567890123456789'+
    '012345678901234567890123456789012345678901234567890123456789'+
    '012345678901234'
  );
  procedure testutf32;
  var
   s1ascii: string;
   s2ascii: string;
   s1utf: ucs4string;
   s2utf: ucs4string;
   resultstr: ucs4string;
   s3ascii: string;
   utfchar: array[1..1] of ucs4char;
   utfstr: ucs4string;
   idx: integer;
  begin
   s1ascii:='Hello';
   s2ascii:='This is a small Hello';
   ConvertToUCS4(s1ascii,s1utf,'ASCII');
   if ucs4_length(s1utf) <> length(s1ascii) then
     RunError(255);
   ConvertToUCS4(s2ascii,s2utf,'ASCII');
   if ucs4_length(s2utf) <> length(s2ascii) then
     RunError(255);

   ucs4_copy(resultstr,s2utf,6,200);
   ConvertFromUCS4(resultstr,s3ascii,'ASCII');
   if s3ascii <> 'is a small Hello' then
     RunError(255);
   if ucs4_pos(s1utf,s2utf) <> pos(s1ascii,s2ascii) then
     RunError(255);
   ucs4_copy(resultstr,s2utf,ucs4_pos(s1utf,s2utf),ucs4_length(s2utf));
   ConvertFromUCS4(resultstr,s3ascii,'ASCII');
   WriteLn(s3ascii);
   if s3ascii <> s1ascii then
     RunError(255);
   utfchar[1]:=ord('!');
   ucs4_setlength(resultstr,0);
   ucs4_copy(resultstr,s1utf,1,ucs4_length(s1utf));
   ucs4_concat(resultstr,s1utf,utfchar);
   if ucs4_length(resultstr) <> (length(s1ascii)+1) then
     Runerror(255);
   ConvertFromUCS4(resultstr,s3ascii,'ASCII');
   if s3ascii <> 'Hello!' then
     RunError(255);
   ucs4_setlength(resultstr,0);
   ucs4_concat(resultstr,s1utf,s2utf);
   if ucs4_length(resultstr) <> (length(s1ascii)+length(s2ascii)) then
     Runerror(255);
   ConvertFromUCS4(resultstr,s3ascii,'ASCII');
   if s3ascii <> (s1ascii+s2ascii) then
     RunError(255);
   ucs4_setlength(resultstr,0);
   ucs4_concat(resultstr,resultstr,s2utf);
   if ucs4_length(resultstr) <> (length(s2ascii)) then
     Runerror(255);
   ConvertFromUCS4(resultstr,s3ascii,'ASCII');
   if s3ascii <> (s2ascii) then
     RunError(255);
   { delete testing }

   ucs4_copy(resultstr,s2utf,1,255);
   ucs4_delete(resultstr,1,ucs4_length(resultstr));
   if ucs4_length(resultstr) <> 0 then
     Runerror(255);


   ucs4_copy(resultstr,s1utf,1,255);
   ucs4_setlength(utfstr,0);
   utfchar[1]:=ord('o');
   ucs4_concat(utfstr,utfstr,utfchar);
   idx:=ucs4_pos(utfstr,resultstr);
   ucs4_delete(resultstr,idx,ucs4_length(resultstr));
   if ucs4_length(resultstr) <> length('Hell') then
     Runerror(255);
   ConvertFromUCS4(resultstr,s3ascii,'ASCII');
   if s3ascii <> 'Hell' then
     RunError(255);

   ucs4_copy(resultstr,s1utf,1,255);
   ucs4_setlength(utfstr,0);
   utfchar[1]:=ord('l');
   ucs4_concat(utfstr,utfstr,utfchar);
   idx:=ucs4_pos(utfstr,resultstr);
   ucs4_delete(resultstr,idx,2);
   ConvertFromUCS4(resultstr,s3ascii,'ASCII');
   if s3ascii <> 'Heo' then
     RunError(255);
   { UCS4_Concat limit values }
   ucs4_setlength(s1utf,0);
   idx:=length(limitstr);
   if idx <> 255 then
     RunError(255);
   for idx:=1 to length(limitStr) do
     begin
       ucs4_concatascii(s1utf,s1utf,limitstr[idx]);
     end;
   ConvertFromUCS4(s1utf,s3ascii,'ASCII');
   if s3ascii <> limitstr then
     RunError(255);
   { Try adding more! }
   for idx:=1 to length(limitStr) do
     begin
       ucs4_concatascii(s1utf,s1utf,limitstr[idx]);
     end;
   if s3ascii <> limitstr then
     RunError(255);
   { Try adding more! }
   for idx:=1 to length(limitStr) do
     begin
       ucs4_concatascii(s1utf,s1utf,'');
     end;
   if s3ascii <> limitstr then
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
   _name: string;
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
   utf32null: array[0..5] of ucs4char =
   (ord('H'),ord('e'),Ord('l'),Ord('l'),Ord('o'),0);
   utf32string: array[0..8] of ucs4char =
   (8,ord('H'),ord('e'),Ord('l'),Ord('l'),Ord('o'),0,0,ord('J'));
   strnull:pchar = 'Hello';
   utf8null: pchar =
   'récéption donnée pour mon reçu.'#0;
  var
   utf32s: ucs4string;
   utf32buffer: array[0..1023] of ucs4char;
   p: pchar;
   putf: pucs4char;
   s: string;
  begin
    if ucs4strlen(nil) <> 0 then
       RunError(255);
    if ucs4strlen(pucs4char(@utf32null)) <> ((sizeof(utf32null) div sizeof(ucs4char)) - 1) then
       RunError(255);
    ucs4strpas(nil,utf32s);
    if ucs4_length(utf32s) <> 0 then
       RunError(255);
    ucs4strpas(pucs4char(@utf32null),utf32s);
    if not ucs4_equalascii(utf32s,'Hello') then
       RunError(255);
    if ucs4strpasToISO8859_1(nil) <> '' then
       RunError(255);
    if ucs4strpasToISO8859_1(pucs4char(@utf32null)) <> 'Hello' then
       RunError(255);
    if ucs4StrPCopy(nil, utf32s) <> nil then
       RunError(255);
    { Check that null are removed from the resulting string,
      first create an UTF-32 string.
    }
    move(utf32string,utf32s,sizeof(utf32string));
    ucs4StrPCopy(pucs4char(@utf32buffer),utf32s);
    s:=ucs4strpastoiso8859_1(pucs4char(@utf32buffer));
    if s <> 'HelloJ' then
      RunError(255);

    p:=UTF8StrNew(pucs4char(@utf32null));
    if strcomp(p,'Hello') <> 0 then
      RunError(255);
    putf:=ucs4Strnew(strnull,'CP850');
    if assigned(putf) then
       RunError(255);
    putf:=ucs4Strnew(strnull,'cp850');
    putf:=ucs4Strdispose(putf);
    if assigned(putf) then
       RunError(255);
    putf:=ucs4Strnew(nil,'cp850');
    if assigned(putf) then
       RunError(255);
    putf:=ucs4Strdispose(putf);
    putf:=ucs4Strnew(utf8null,'UTF-8');
    s:=ucs4strpastoiso8859_1(putf);
    putf:=ucs4Strdispose(putf);
  end;

  procedure testiso639;
  var
   b: boolean;
   s: string;
  begin
    b:=isvalidlangcode('');
    if b = TRUE then
       RunError(255);
    b:=isvalidlangcode('fr');
    if not b then
       RunError(255);
    b:=isvalidlangcode('xal');
    if not b then
       RunError(255);
    b:=isvalidlangcode('francais');
    if b then
       RunError(255);
    { Verify French decoding }
    s:=getlangname_fr('');
    if s <> '' then
        RunError(255);
    s:=getlangname_fr('en');
    if upstring(s) <> 'ANGLAIS' then
        RunError(255);
    s:=getlangname_fr('english');
    if upstring(s) <> '' then
        RunError(255);
    s:=getlangname_fr('xal');
    if upstring(s) <> 'KALMOUK' then
        RunError(255);
    { Verify english decoding }
    s:=getlangname_en('');
    if s <> '' then
        RunError(255);
    s:=getlangname_en('fr');
    if upstring(s) <> 'FRENCH' then
        RunError(255);
    s:=getlangname_en('xal');
    if upstring(s) <> 'KALMYK' then
        RunError(255);
    s:=getlangname_en('english');
    if upstring(s) <> '' then
        RunError(255);
  end;

  procedure testremovenulls;
  var
   s1,s2: string;
  begin
   s1:=removenulls('Hello');
   if s1 <> 'Hello' then
     RunError(255);
   s1:=removenulls('Hello'#0#0'Je');
   if s1 <> 'HelloJe' then
     RunError(255);
   s1:=removenulls('');
   if s1 <> '' then
     RunError(255);
   s1:=removenulls(#0);
   if s1 <> '' then
     RunError(255);
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
  testdate.test_unit;
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
  testiso639;
  testremovenulls;
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.11  2004/09/06 20:35:17  carl
    + new test files

  Revision 1.10  2004/08/27 02:09:49  carl
    + more unicode testing

  Revision 1.9  2004/08/20 00:50:16  carl
    + release 0.99

  Revision 1.8  2004/08/19 00:24:00  carl
    * more testing routines for unicode
    + iso639 testing

  Revision 1.7  2004/07/15 01:02:23  carl
    + more testing of unicode

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
