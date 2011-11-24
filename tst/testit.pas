{ This program tests the features of the common units
  as well as unicode support
}

{ Takes as a parameter the path where the execution will take place }
Program Testit;

{$I+}
{$X+}
{$T+}
uses cmntyp,
     locale,
     ietf,
     unicode,
     dos,
     strings,
     iso639,
     utils,
     testdate,
     testsgml,
     testietf,
     tiso639,
     collects
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
   { Raw UCS-4 string containing whitespace padding left and right }
   utf32string1: array[0..6] of ucs4char =
   (
    { Length }
    6,
    $20,$20,$30,$20,$20,$9
   );
   { Raw UCS-4 string containing no whitespace padding left and right }
   utf32string2: array[0..6] of ucs4char =
   (
    { Length }
    6,
    $31,$32,$33,$34,$35,$36
   );
   { Raw UCS-4 string containing no length of data at all }
   utf32string3: array[0..6] of ucs4char =
   (
    { Length }
    0,
    0,0,0,0,0,0
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
     
   { Test Trimming routines - with operation }
   UCS4_TrimLeft(utf32string1);
   if ucs4_length(utf32string1) <> 4 then
     RunError(255);
     
   UCS4_TrimRight(utf32string1);
   if ucs4_length(utf32string1) <> 1 then
     RunError(255);
     
   { Test Trimming routines - no operation }
     
   UCS4_TrimLeft(utf32string2);
   if ucs4_length(utf32string2) <> 6 then
     RunError(255);
     
   UCS4_TrimRight(utf32string2);
   if ucs4_length(utf32string2) <> 6 then
     RunError(255);
     
   { Test Trimming routines - empty strings }
     
   UCS4_TrimLeft(utf32string3);
   if ucs4_length(utf32string3) <> 0 then
     RunError(255);

   UCS4_TrimRight(utf32string3);
   if ucs4_length(utf32string3) <> 0 then
     RunError(255);

  end;

  procedure testisvalidisodatestring;
  begin
   if not IsValidIsoDateString('1998',false) then
     Runerror(255);
   if IsValidIsoDateString(' 998',false) then
     Runerror(255);
   if IsValidIsoDateString('C',false) then
     Runerror(255);
   if IsValidIsoDateString('20056',false) then
     Runerror(255);
   if IsValidIsoDateString('1998/06/12',false) then
     Runerror(255);
   if not IsValidIsoDateString('1998-02',false) then
     Runerror(255);
   if IsValidIsoDateString('1998-2',false) then
     Runerror(255);
   if not IsValidIsoDateString('19980201',false) then
     Runerror(255);
   if not IsValidIsoDateString('1998-02-01',false) then
     Runerror(255);
  end;
  
  procedure testisvalidisotimestring;
  begin
   if not IsValidIsoTimeString('00:59:59',false) then
     RunError(255);
   if IsValidIsoTimeString('25:59:59',false) then
     RunError(255);
   if IsValidIsoTimeString('00Z59:59',false) then
     RunError(255);
   if IsValidIsoTimeString('00:59Z59',false) then
     RunError(255);
   if IsValidIsoTimeString('00:59:77',false) then
     RunError(255);
   if not IsValidIsoTimeString('00:59:59+00:30',false) then
     RunError(255);
   if IsValidIsoTimeString('00:59:59+ZZ:30',false) then
     RunError(255);
   if IsValidIsoTimeString('00:59:59W00:30',false) then
     RunError(255);
   if not IsValidIsoTimeString('00:59:59-01:00',false) then
     RunError(255);
   if not IsValidIsoTimeString('00:59:59Z',false) then
     RunError(255);
   if not IsValidIsoTimeString('005959',false) then
     RunError(255);
   if not IsValidIsoTimeString('005959',false) then
     RunError(255);
   if not IsValidIsoTimeString('005959Z',false) then
     RunError(255);
   if not IsValidIsoTimeString('00:59',false) then
     RunError(255);
   if not IsValidIsoTimeString('0059',false) then
     RunError(255);

  end;
  

  procedure testisvalidisodatetimestring;
  begin
   if not IsValidIsoDateTimeString('1998-02-01T00:59:59',false) then
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

  procedure testcodepage;
  var
   s: string;
  begin
    s:=MicrosoftCodePageToMIMECharset(65001);
    if s<> 'UTF-8' then
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
    utf8strdispose(p);  
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

procedure testucs4strtrim;
  const
   utf32null: array[0..5] of ucs4char =
   (ord(#10),ord('e'),Ord('l'),Ord('l'),Ord('o'),0);
   utf32null1: array[0..0] of ucs4char =
   (ord(#0));
   utf32null2: array[0..2] of ucs4char =
   (ord(#10),ord(#13),0);
   utf32null3: array[0..7] of ucs4char =
   (ord(#10),ord('e'),Ord('l'),Ord('l'),Ord('o'),10,9,0);
begin
  ucs4strtrim(pucs4char(@utf32null));
  ucs4strtrim(pucs4char(@utf32null1));
  ucs4strtrim(pucs4char(@utf32null2));
  ucs4strtrim(pucs4char(@utf32null3));
end;

procedure testucs4removeaccents;
const
  s1: string = #201'rica est la m'#232're de mon p'#232're';
  s2: string = 'Erica est la mere de mon pere';
var  
  dest: Ucs4string;
  s3:string;
begin
   if ConvertToUCS4(s1,dest,'ISO-8859-1')<>0 then
     RunError(255);
   ucs4_removeaccents(dest,dest);
   s3:=ucs4_converttoiso8859_1(dest);
   if s2 <>  s3 then
     RunError(255);
end;


procedure testbasechar;
var
 c: char;
begin
  c:=char(ucs4_getbasechar(ucs4char(' ')));
  if c <> ' ' then
    RunError(255);
  { accented E character }  
  c:=char(ucs4_getbasechar(ucs4char($E9)));
  if c <> 'e' then
    RunError(255);
end;


{ Tests the ucs4_iswhitespace routine }
procedure testwhitespace;
const
  ucs4char1 = ucs4char($08);
  ucs4char2 = ucs4char($09);
  ucs4char3 = ucs4char($0B);
  ucs4char4 = ucs4char($0D);
  ucs4char5 = ucs4char($19FF);
  ucs4char6 = ucs4char($2028);
  ucs4char7 = ucs4char($2009);
  ucs4char8 = ucs4char($4000);
  ucs4char9 = ucs4char($2000);
Begin
 if ucs4_iswhitespace(ucs4char1) = true then
   RunError(255);
 if ucs4_iswhitespace(ucs4char2) = false then
   RunError(255);
 if ucs4_iswhitespace(ucs4char3) = false then
   RunError(255);
 if ucs4_iswhitespace(ucs4char4) = false then
   RunError(255);
 if ucs4_iswhitespace(ucs4char5) = true then
   RunError(255);
 if ucs4_iswhitespace(ucs4char6) = false then
   RunError(255);
 if ucs4_iswhitespace(ucs4char7) = false then
   RunError(255);
 if ucs4_iswhitespace(ucs4char8) = true then
   RunError(255);
 if ucs4_iswhitespace(ucs4char9) = false then
   RunError(255);
end;


procedure testhexdigit;
Begin
 if ucs4_ishexdigit($31) = false then
   RunError(255);
 if ucs4_ishexdigit($46) = false then
   RunError(255);
 if ucs4_ishexdigit($0A) = true then
   RunError(255);
end;

procedure testdigit;
Begin
 if ucs4_isdigit($39) = false then
   RunError(255);
 if ucs4_isdigit($46) = true then
   RunError(255);
 if ucs4_isdigit($0A) = true then
   RunError(255);
end;


procedure testisterminal;
Begin
 if ucs4_isterminal($39) = true then
   RunError(255);
 if ucs4_isterminal($46) = true then
   RunError(255);
 if ucs4_isterminal($0A) = true then
   RunError(255);
 if ucs4_isterminal($2E) = false then
   RunError(255);
 if ucs4_isterminal(ucs4char('!')) = false then
   RunError(255);
 if ucs4_isterminal($701) = false then
   RunError(255);
end;


procedure testgetvalue;
Begin
 if ucs4_getnumericvalue($39) <> 9 then
   RunError(255);
 if ucs4_getnumericvalue($46) <> -1 then
   RunError(255);
 if ucs4_getnumericvalue($137C) <> 10000 then
   RunError(255);
 if ucs4_getnumericvalue($F2A) <> -2 then
   RunError(255);
end;

const
 NAME_1 = 'CARL';
 NAME_2 = 'ERIC';
 NAME_3 = 'VALERIE';
 NAME_4 = ' VAL';
 NAME_5 = '"ERIC,CARL  ,"';
 NAME_6 = '"TEST"';

 SIMPLE_CASE_1 = NAME_1;
 SIMPLE_CASE_2 = ','+NAME_1+',';
 SIMPLE_CASE_3 = NAME_1+','+NAME_2+','+NAME_3+',';
 CASE_1 = NAME_5+','+NAME_3+','+NAME_6;
 CASE_2 = CASE_1+',""';
 { Invalid case }
 CASE_3 = CASE_2+'","';

{ Tests the stroken routine }
procedure TestStrToken;
var
 s: string;
 origstring: string;
Begin
 {********************** Case 1 ***********************}
 origstring:=SIMPLE_CASE_1;
 s:=StrToken(origstring,',',false);
 if s <> SIMPLE_CASE_1 then
   RunError(255);
 s:=StrToken(origstring,',',false);
 if s <> '' then
   RunError(255);

 if origString <> '' then
   RunError(255);
 {********************** Case 2 ***********************}
 origstring:=SIMPLE_CASE_2;
 s:=StrToken(origstring,',',false);
 if s <> '' then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',false);
 if s <> NAME_1 then
   RunError(255);
 s:=StrToken(origstring,',',false);
 if s <> '' then
   RunError(255);
 if origString <> '' then
   RunError(255);
 {********************** Case 3 ***********************}
 origstring:=SIMPLE_CASE_3;
 s:=StrToken(origstring,',',false);
 if s <> NAME_1 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',false);
 if s <> NAME_2 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',false);
 if s <> NAME_3 then
   RunError(255);
 if origString <> '' then
   RunError(255);
 {********************** Case 4 ***********************}
 origstring:='';
 s:=StrToken(origstring,',',false);
 if s <> '' then
   RunError(255);
 if origString <> '' then
   RunError(255);
 { Quotes are used.                                    }
 {********************** Case 5 ***********************}
 origstring:='';
 s:=StrToken(origstring,',',true);
 if s <> '' then
   RunError(255);
 if origString <> '' then
   RunError(255);
 {********************** Case 6 ***********************}
 origstring:=SIMPLE_CASE_3;
 s:=StrToken(origstring,',',true);
 if s <> NAME_1 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',false);
 if s <> NAME_2 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',false);
 if s <> NAME_3 then
   RunError(255);
 if origString <> '' then
   RunError(255);
 {********************** Case 7 ***********************}
 origstring:=CASE_1;
 s:=StrToken(origstring,',',true);
 if s <> NAME_5 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',true);
 if s <> NAME_3 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',true);
 if s <> NAME_6 then
   RunError(255);
 if origString <> '' then
   RunError(255);
 {********************** Case 8 ***********************}
 origstring:=CASE_2;
 s:=StrToken(origstring,',',true);
 if s <> NAME_5 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',true);
 if s <> NAME_3 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',true);
 if s <> NAME_6 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',true);
 if s <> '""' then
   RunError(255);
 if origString <> '' then
   RunError(255);
 {********************** Case 9 ***********************}
 { Just make sure there is no range-check error        }
 origstring:=CASE_3;
 s:=StrToken(origstring,',',true);
 if s <> NAME_5 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',true);
 if s <> NAME_3 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',true);
 if s <> NAME_6 then
   RunError(255);
 if origString = '' then
   RunError(255);
 s:=StrToken(origstring,',',true);
 s:=StrToken(origstring,',',true);
end;


{ This tests the Key Collection object }
procedure TestKeys;
var
 KeyValues: THashTable;
 count: integer;
 p: PHashItem;
 s: string;
 b: Boolean;
begin
  KeyValues.init(16,16);

  {-- Simple property verification --}

  { Try to retrieve a non existent property when property list is empty }
  p:=PHashItem(KeyValues.get(''));
  if p<>nil then
    RunError(255);
  b:=KeyValues.containsKey('MyOtherkey');
  if b then
    RunError(255);
  KeyValues.put('MyOtherkey',12,New(PStringHashItem, Init('value_new')));
  KeyValues.put('Mykey',13,New(PStringHashItem, Init('value_old')));

  p:=PHashItem(KeyValues.get('Mykey'));
  if p^.toString <> 'value_old' then
    RunError(255);
  p:=PHashItem(KeyValues.getByFastIndex(13));
  if p^.toString <> 'value_old' then
    RunError(255);
  { Try to retrieve a non existent property when property list is not empty }
  p:=PHashItem(KeyValues.get('MyInvalidkey'));
  if p<>nil then
    RunError(255);
  p:=PHashItem(KeyValues.getByFastIndex(12));
  if p^.toString <> 'value_new'  then
    RunError(255);
  p:=PHashItem(KeyValues.get('MyOtherkey'));
  if p^.toString <> 'value_new' then
    RunError(255);
  { Overwrite a property with an existing property }

  KeyValues.put('MyOtherkey',12,new(PStringHashITem, Init('new_value')));
  p:=nil;
  p:=PHashItem(KeyValues.getByFastIndex(12));
  if p^.toString <> 'new_value' then
    RunError(255);
  p:=nil;
  p:=PHashItem(KeyValues.get('MyOtherkey'));
  if p^.toString <> 'new_value' then
    RunError(255);

  { Overwrite a property with a new fast key index  }
  p:=nil;
  KeyValues.put('Mykey',14,new(PStringHashItem, Init('new_my_key_value')));

  p:=nil;   
  p:=PHashItem(KeyValues.getByFastIndex(14));
  if p^.toString <> 'new_my_key_value' then
    RunError(255);
  p:=nil;
  p:=PHashItem(KeyValues.get('Mykey'));
  if p^.toString <> 'new_my_key_value'  then
    RunError(255);


  { Verify that we return the correct values as indexes }
  s:=KeyValues.getKeyName(0);
  if s<>'MyOtherkey' then
    RunError(255);
  s:=KeyValues.getKeyName(1);
  if s<>'Mykey' then
    RunError(255);
  s:=KeyValues.getKeyName(2);
  if s<>'' then
    RunError(255);

  { Delete a property }
  if KeyValues.remove('MyOtherkey')<>true then
    RunError(255);
  s:=KeyValues.getKeyName(0);
  if s<>'Mykey' then
    RunError(255);
  s:=KeyValues.getKeyName(1);
  if s<>'' then
    RunError(255);


  { Verify that we get the correct number of items in count }
  KeyValues.done;

end;


procedure TestStrGetNextLine;
const
  GETLINE_CASE_1 = #10#10;
  GETLINE_CASE_2 = #10'c'#10'a';
  GETLINE_CASE_3 = #13#10'Carl'#13#10'Eric'#10'a'#13#10;
  GETLINE_CASE_4 = 'Caillou'#13#10'anchor';
  GETLINE_CASE_5 = 'A simple sentence. Hello world';
var
 s: string;
 s1: string;
Begin
 { Case 1 }
 s:=GETLINE_CASE_1;
 s1:=StrGetNextLine(s);
 IF S1 <> '' then
   RunError(255);
 s1:=StrGetNextLine(s);
 IF S1 <> '' then
   RunError(255);
 IF S <> '' then
   RunError(255);
 { Case 2 }
 s:=GETLINE_CASE_2;
 s1:=StrGetNextLine(s);
 IF S1 <> '' then
   RunError(255);
 s1:=StrGetNextLine(s);
 IF S1 <> 'c' then
   RunError(255);
 s1:=StrGetNextLine(s);
 IF S1 <> 'a' then
   RunError(255);
 IF S <> '' then
   RunError(255);
 { Case 3 }
 s:=GETLINE_CASE_3;
 s1:=StrGetNextLine(s);
 IF S1 <> '' then
   RunError(255);
 s1:=StrGetNextLine(s);
 IF S1 <> 'Carl' then
   RunError(255);
 s1:=StrGetNextLine(s);
 IF S1 <> 'Eric' then
   RunError(255);
 s1:=StrGetNextLine(s);
 IF S1 <> 'a' then
   RunError(255);
 IF S <> '' then
   RunError(255);
 { Case 4 }
 s:=GETLINE_CASE_4;
 s1:=StrGetNextLine(s);
 IF S1 <> 'Caillou' then
   RunError(255);
 s1:=StrGetNextLine(s);
 IF S1 <> 'anchor' then
   RunError(255);
 IF S <> '' then
   RunError(255);
 { Case 5 }
 s:=GETLINE_CASE_5;
 s1:=StrGetNextLine(s);
 IF S1 <> GETLINE_CASE_5 then
   RunError(255);
 IF S <> '' then
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
  testcodepage;
  testucs4removeaccents;
  testdate.test_unit;
  testsgml.test_unit;
  testietf.test_unit;
  tiso639.test_unit;
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
  testremovenulls;
  testucs4strtrim;
  teststrtoken;
  testwhitespace;
  testhexdigit;
  testdigit;
  testisterminal;
  testgetvalue;
  testbasechar;
  TestStrGetNextLine;
  testkeys;
  WriteLn(ErrOutput,'Std Error OUTPUT');
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.21  2011/04/12 00:46:03  carl
  + Hash Key value collection unitary tests
  + UCS4 Trim routine unitary tests

  Revision 1.20  2007/01/06 19:17:20  carl
    + Add testbasechar unicode testing

  Revision 1.19  2007/01/06 15:56:54  carl
    + add several unicode routines testsuit

  Revision 1.18  2005/10/10 17:43:56  carl
    + More testing software

  Revision 1.17  2004/11/29 03:52:22  carl
    + Support for new routines of dateutil

  Revision 1.16  2004/11/23 03:51:40  carl
    * more date testing / fixes for VP compilation

  Revision 1.15  2004/11/18 04:23:09  carl
    * more routine testing

  Revision 1.14  2004/11/02 12:16:18  carl
    * More testing for dateutil unit

  Revision 1.13  2004/10/13 23:40:52  carl
    + added sgml unit testing

  Revision 1.12  2004/09/29 00:56:54  carl
    + update to include dateutil testing

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
