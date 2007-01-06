{ This program converts different character set properties
  to include/assembler files.

  The output is written to different files.
}
{$X+}
program unconvert;

uses
  fpautils,
  tpautils,
  utils,
  classes,
  dos,locale;



const
  MAX_LINES = 1024;
  
type
  TLangRecord = record
    upper_code: string[8];
    lower_code: string[8];
  end;
  
  { Returns the code point range }
  TCodePointRange = record
    upper_code: string[8];
    lower_code: string[8];
  end;



tcategory =
(
   letter_uppercase,
   letter_lowercase,
   letter_titlecase,
   letter_modifier,
   letter_other,
   mark_nonspacing,
   mark_spacinig,
   mark_enclosing,
   number_decimal_digit,
   number_letter,
   number_other,
   punctuation_connector,
   punctuation_dash,
   punctuation_open,
   punctuation_close,
   punctuation_initial_quote,
   punctuation_final_quote,
   punctuation_other,
   symbol_math,
   symbol_currency,
   symbol_modifier,
   symbol_other,
   separator_space,
   separator_line,
   separator_paragraph,
   other_control,
   other_format,
   other_surrogate,
   other_private,
   other_unassigned
 );

 TEntries = array[1..65535] of TCodePointRange;


const
  { UnicodeData.txt columns }
  IDX_CODEPOINT = 0;
  IDX_NAME      = 1;
  IDX_CATEGORY  = 2;
  IDX_CANONICAL_CLASS = 3;
  IDX_BIDI_CLASS = 4;
  IDX_DECOMPOSITION = 5;
  IDX_NUMERIC = 6;
  IDX_NUMERIC_ALL = 8;
  IDX_BIDI_MIRRORED = 9;
  IDX_UNICODE1_NAME = 10;
  IDX_ISO_COMMENT = 11;
  IDX_SIMPLE_UPPERCASE_MAPPING = 12;
  IDX_SIMPLE_LOWERCASE_MAPPING = 13;
  IDX_SIMPLE_TITLECASE_MAPPING = 14;

  COMMENT_CHAR = '#';


 CategoryStr:  array[tcategory] of string =
 (
 'Lu',
 'Ll',
 'Lt',
 'Lm',
 'Lo',
 'Mn',
 'Mc',
 'Me',
 'Nd',
 'Nl',
 'No',
 'Pc',
 'Pd',
 'Ps',
 'Pe',
 'Pi',
 'Pf',
 'Po',
 'Sm',
 'Sc',
 'Sk',
 'So',
 'Zs',
 'Zl',
 'Zp',
 'Cc',
 'Cf',
 'Cs',
 'Co',
 'Cn'
 );


var
 Entries: array[1..MAX_LINES] of TLangRecord;
 Data: TEntries;



 {** Returns a field string value }
 function GetField(s: string; idx: integer; delimiter: char): string;
 var
  valstr: string;
  i: integer;
 begin
   valstr:=s;
   for i:=0 to idx do
     begin
       GetField:=Trim(StrToken(ValStr,delimiter,False));
     end;

 end;

 {** Returns the code point range value 
    @param(field Code point range field).
    
    Returns true if no error.
 }
 function GetCodePointRange(field: string; var Range: TCodePointRange ): boolean;
 var
   idx: integer;
 begin
   field:=trim(field);
   idx:=pos('..',field);
   if idx > 1 then
     begin
       range.lower_code:=copy(field,1,idx-1);
       range.upper_code:=copy(field,idx+2,length(field));
     end
   else
      begin
        range.lower_code:=field;
        range.upper_code:=field;
      end;
 end;
 
 {** Returns the code point category, none if not valid }
 function GetGeneralCategory(field: string): tcategory;
 var
  i: tcategory;
 begin
  field:=trim(field);
  for i:=letter_uppercase to other_unassigned do
     begin
      if CategoryStr[i] = field then
        begin
          GetGeneralCategory:=i;
        end;
    end;
 end;


{** Read text until EOLN or until EOF }
procedure ReadLine(var EnFile: Text; var s: string);
var
 c: char;
begin
  s:='';
  if EOF(EnFile) then
    exit;
  { Just in case we had a $0A }
  Read(EnFile,c);
  if c <> chr($0A) then
    s:=c;
  while not EOF(EnFile) do
  begin
    Read(EnFile,c);
    if (c = chr($0A)) or (c = chr($0D)) then
     exit;
    s:=s+c;
  end;
end;


{** Actually writes out the data to a lower/upper table.

    @param(fname Output filename)
    @param(ucs2 Indicates if this is an UCS-2 table, yes if true, otherwise UCS-4)
    @param(Entries Entries in the data table)
    
    The name parameter is used for deriving the following:
      - Array name.
      - Structure name.
      - Comment in header
      - Constant value names (UPPERCASED)
}    
procedure WriteDataTableArray(fname: string; name: string; ucs2: boolean; entries: integer; const data: TEntries);
var
 T: Text;
 S: String;
 upname: string;
 structname: string;
 Year,Month,Day,DayOfWeek:word;
 UCS2Entries: integer;
 ASCIIEntries: integer;
 ANSIEntries: integer;
 i: integer;
 code_value: longword;
 code: integer;
 TypeName: string;
 MaxEntries: integer;
begin
 GetDate(Year,Month,Day,DayOfWeek);
 upname:=upstring(name);
 UCS2Entries:=-1;
 ANSIEntries:=-1;
 ASCIIEntrieS:=-1;
 {***************** Calculate the number of entries *********************}
 for i:=1 to Entries do
   begin
      code_value:=ValHexadecimal(Data[i].lower_code,code);
      if (code_value > $7f) and (ASCIIEntries = -1) then
         begin
           ASCIIEntries:=i-1;
         end;
       if (code_value > $ff) and (ANSIEntries = -1) then
         begin
           ANSIEntries:=i-1;
         end;
       if (code_value > $ffff) and (UCS2Entries = -1) then
         begin
           UCS2Entries:=i-1;
         end;
   end;
 { Nothing found, all are UCS-2 characters }
 if UCS2Entries = -1 then
     UCS2Entries:=Entries;
 if ASCIIEntries = -1 then
   ASCIIEntries:=Entries;
 if ANSIEntries = -1 then
   ANSIEntries:=Entries;
 

 { Now write the file }
 Assign(T,fname);
 Rewrite(T);
 S:=GetISODateString(Year, Month, Day);
 WriteLn(T,'{ Unicode '+name+' character property type');
 WriteLn(T,'  Generated on ',S);
 {if length(OriginalFileName) > 0 then
   WriteLn(T,'  From ',OriginalFilename);}
 WriteLN(T,'  Encoded in the ISO-8859-1 character set');
 WriteLn(T,'}');

 { Are we writing a UCS-2 or UCS-4 table?
   Or all the characters only UCS-2 characters, then
   use UCS-2
 }
 if (ucs2) or (Entries = UCS2Entries) then
   begin
      MaxEntries:=UCS2Entries;
      TypeName:='ucs2char';
   end
 else
   begin
      MaxEntries:=Entries;
      TypeName:='ucs4char';
   end;
 WriteLn(T,'const');
 WriteLn(T,'  MAX_'+upname+' =',MaxEntries,';');
 WriteLn(T,'  MAX_UCS2_'+upname+' =',UCS2Entries,';');
 WriteLn(T,'  MAX_ANSI_'+upname+' =',ANSIEntries,';');
 WriteLn(T,'  MAX_ASCII_'+upname+' =',ASCIIEntries,';');
 WriteLn(T,'type');
 structname:='T'+name+'Info';
 WriteLn(T,'  '+structname+' = record');
 WriteLn(T,'    lower: ',TypeName,';');
 WriteLn(T,'    upper: ',TypeName,';');
 WriteLn(T,'  end;');
 WriteLn(T);
 WriteLn(T);
 WriteLn(T,'const');
 WriteLn(T,'  ',name,': array[1..MAX_'+upname+'] of ',structname,' = (');
 { Depending on the Unicode format used }
 for i:=1 to MaxEntries do
   begin
     Write(T,'   (lower: $',Data[i].lower_code,'; upper: $',Data[i].upper_code,')' );
     if i <> Entries then
       WriteLn(T,',')
     else
       WriteLn(T)
   end;
 WriteLn(T,');');
 Close(T);
end;




{** This routine parses the UnicodeData.txt file and
    generates a table

    On output contains the table filled up with Entries, where
    lower_code contains the lower case character and the
    upper_code character contains the upper case character.

    @param(fname CaseFolding database filename)
    @param(ucs2 Don't support anything out of the BMP)
}
procedure CreateCaseFolding(fname: string; ucs2: boolean);
var
 EnFile: Text;
 i: integer;
 s: string;
 code: integer;
 codePoint: TCodePointRange;
 codeType: string;
 codeLowerCase: string;
 { Number of UCS-4 entries }
 Entries: integer;
 { Number of UCS-2 entries }
 UCS2Entries: integer;
 codeUpperCase: string;
 LineCount: integer;
 {** extract from source database }
 OriginalFileName: string;
 MaxEntries: integer;
 TypeName: string;
begin
 Fillchar(Data,sizeof(Data),#0);
 OriginalFileName:='';
 { Start reading the english text file }
 Assign(EnFile,fname);
 Reset(EnFile);
 Entries:=0;
 i:=1;
 LineCount:=0;
 Repeat
   ReadLine(EnFile,s);
   inc(LineCount);
   s:=trim(s);
   { Skip over comments }
   if (length(s) = 0) then
    continue;
   if (s[1] = COMMENT_CHAR) then
     begin
       { Just keep the first two lines for version information }
       if LineCount = 1 then
       begin
         delete(s,1,1);
         OriginalFileName:=trim(s);
       end;
       continue;
     end;
   codeLowerCase:=GetField(s,IDX_CODEPOINT,';');
   codeUpperCase:=GetField(s,IDX_SIMPLE_UPPERCASE_MAPPING,';');
   { Get the codePoint range }
   GetCodePointRange(codeUpperCase,codePoint);
   if (codePoint.upper_code <> codePoint.lower_code) then
     begin
       WriteLn('Error: Range in case folding database.');
     end;
   { Only add entries that have Simple case folding }
   if (codeUpperCase <> '') then
     begin
       inc(Entries);
       Data[Entries].upper_code:=CodeUpperCase;
       Data[Entries].lower_code:=CodeLowerCase;
     end;
 Until Eof(EnFile);
 WriteDataTableArray('Z:\case.inc','CaseTable',UCS2, Entries,Data);
end;

{** This routine parses the UnicodeData.txt file and
    generates a table of equivalent/simplified
    representations of a character.

    Currently supports the following decomposition forms:
     - Standard
     - <compat>
     - <font>
     - <wide>
     - <narrow>

    @param(fname CaseFolding database filename)
    @param(ucs2 Don't support anything out of the BMP)
}
procedure CreateDecomposition(fname: string; ucs2: boolean);
var
 EnFile: Text;
 i: integer;
 s: string;
 code: integer;
 codePoint: TCodePointRange;
 codeType: string;
 codeLowerCase: string;
 { Number of UCS-4 entries }
 Entries: integer;
 { Number of UCS-2 entries }
 UCS2Entries: integer;
 ASCIIEntries: integer;
 ANSIEntries: integer;
 codeUpperCase: string;
 code_value: integer;
 T: Text;
 Year,Month,Day,DayOfWeek:word;
 LineCount: integer;
 {** extract from source database }
 OriginalFileName: string;
 Tag: string;
 idx: integer;
 OriginalDate: string;
 MaxEntries: integer;
 codePointValue: string;
 TypeName: string;
 CodeDecomposition: string;
 SimplifiedCodePoint: string;
 ValStr: string;
begin
 GetDate(Year,Month,Day,DayOfWeek);
 Fillchar(Data,sizeof(Data),#0);
 OriginalFileName:='';
 OriginalDate:='';
 { Start reading the english text file }
 Assign(EnFile,fname);
 Reset(EnFile);
 Entries:=0;
 UCS2Entries:=-1;
 ANSIEntries:=-1;
 ASCIIEntrieS:=-1;
 i:=1;
 LineCount:=0;
 Repeat
   ReadLine(EnFile,s);
   inc(LineCount);
   s:=trim(s);
   { Skip over comments }
   if (length(s) = 0) then
    continue;
   if (s[1] = COMMENT_CHAR) then
     begin
       { Just keep the first two lines for version information }
       if LineCount = 1 then
       begin
         delete(s,1,1);
         OriginalFileName:='UnicodeData.txt';
       end;
       continue;
     end;

   codePointValue:=GetField(s,IDX_CODEPOINT,';');
   { Get the codePoint range }
   GetCodePointRange(codeUpperCase,codePoint);
   if (codePoint.upper_code <> codePoint.lower_code) then
     begin
       WriteLn('Error: Range in case folding database.');
     end;
   CodeDecomposition:=GetField(s,IDX_DECOMPOSITION,';');
   SimplifiedCodePoint:='';
   if CodeDecomposition <> '' then
     begin
        Tag:='';
        idx:=pos('>',CodeDecomposition);
        if idx > 0 then
          begin
            { This is the tag value }
            Tag:=trim(copy(CodeDecomposition,1,idx));
            delete(CodeDecomposition,1,idx);
          end;
         CodeDecomposition:=trim(CodeDecomposition);
         { Get the first token that represent the base value }
         if (length(Tag) = 0) or (Tag = '<font>') or (Tag = '<compat>') or
            (Tag = '<wide>') or (Tag = '<narrow>') then
            SimplifiedCodePoint:=StrToken(CodeDecomposition,' ',false);
     end;
   { Only add entries that have the Common or Simple case folding }
   if (SimplifiedCodePoint <> '') then
     begin
       inc(Entries);
       Data[Entries].upper_code:=CodePointValue;
       Data[Entries].lower_code:=SimplifiedCodePoint;
       code_value:=ValHexadecimal(Data[Entries].upper_code,code);
       if (code_value > $7f) and (ASCIIEntries = -1) then
         begin
           ASCIIEntries:=Entries-1;
         end;
       if (code_value > $ff) and (ANSIEntries = -1) then
         begin
           ANSIEntries:=Entries-1;
         end;
       if (code_value > $ffff) and (UCS2Entries = -1) then
         begin
           UCS2Entries:=Entries-1;
         end;
     end;
 Until Eof(EnFile);
 { Nothing found, all are UCS-2 characters }
 { Nothing found, all are UCS-2 characters }
 if UCS2Entries = -1 then
     UCS2Entries:=Entries;
 if ASCIIEntries = -1 then
   ASCIIEntries:=Entries;
 if ANSIEntries = -1 then
   ANSIEntries:=Entries;

 { Now write the file }
 Assign(T,'Z:\canonic.inc');
 Rewrite(T);
 S:=GetISODateString(Year, Month, Day);
 WriteLn(T,'{ Unicode character canonical character data');
 WriteLn(T,'  Generated on ',S);
 if length(OriginalFileName) > 0 then
   WriteLn(T,'  From ',OriginalFilename);
 WriteLN(T,'  Encoded in the ISO-8859-1 character set');
 WriteLn(T,'}');

 { Are we writing a UCS-2 or UCS-4 table? }
 if ucs2 then
   begin
      MaxEntries:=UCS2Entries;
      TypeName:='ucs2char';
   end
 else
   begin
      MaxEntries:=Entries;
      TypeName:='ucs4char';
   end;

 WriteLn(T,'const');
 WriteLn(T,'  MAX_CANONICAL_MAPPINGS =',MaxEntries,';');
 WriteLn(T,'  MAX_CANONICAL_UCS2_MAPPINGS =',UCS2Entries,';');
 WriteLn(T,'  MAX_CANONICAL_ANSI_MAPPINGS =',ANSIEntries,';');
 WriteLn(T,'  MAX_CANONICAL_ASCII_MAPPINGS =',ASCIIEntries,';');
 WriteLn(T,'type');
 WriteLn(T,'  TCanonicalInfo = record');
 WriteLn(T,'    CodePoint: ',TypeName,';');
 WriteLn(T,'    BaseChar: ',TypeName,';');
 WriteLn(T,'  end;');
 WriteLn(T);
 WriteLn(T,'{$ifndef tp}');
 WriteLn(T);
 WriteLn(T,'const');
 WriteLn(T,'  CanonicalMappings: array[1..MAX_CANONICAL_MAPPINGS] of TCanonicalInfo = (');
 { Depending on the Unicode format used }
 for i:=1 to MaxEntries do
   begin
     Write(T,'   (CodePoint: $',Data[i].upper_code,'; BaseChar: $',Data[i].lower_code,')' );
     if i <> Entries then
       WriteLn(T,',')
     else
       WriteLn(T)
   end;
 WriteLn(T,');');
 WriteLn(T);
 WriteLn(T,'{$else}');
 WriteLn(T);
 WriteLn(T,'procedure canonicmapping;external; {$L canoninc.obj}');
 WriteLn(T,'{$endif}');
 Close(T);

 {-- Write the assembler file also --}
 { First Turbo pascal assembler file }
 Assign(T, 'Z:\canoninc.asm');
 Rewrite(T);
 WriteLn(T,'.MODEL LARGE, PASCAL');
 WriteLn(T,'.CODE');
 WriteLn(T,'canonicmapping PROC FAR');
 WriteLn(T,#9'PUBLIC canonicmapping');
 { Depending on the Unicode format used }
 for i:=1 to MaxEntries do
   begin
     WriteLn(T,';-------------------------------------------------------');
     WriteLn(T,';  (CodePoint: $',Data[i].upper_code,'; BaseChar: $',Data[i].lower_code,')' );
     Write(T,#9'DD 0',Data[i].upper_code,'h, 0',Data[i].lower_code,'h' );
     WriteLn(T)
   end;
 WriteLn(T,'canonicmapping ENDP');
 WriteLn(T,'END');
 Close(T);
end;


{** Create all the characters from UnicodeData.txt
    that are digits. }
procedure CreateDigit(fname: string; ucs2: boolean);
var
 EnFile: Text;
 i: integer;
 s: string;
 code: integer;
 codePoint: TCodePointRange;
 codeType: string;
 { Number of UCS-4 entries }
 Entries: integer;
 { Number of UCS-2 entries }
 UCS2Entries: integer;
 ASCIIEntries: integer;
 ANSIEntries: integer;
 code_value: integer;
 T: Text;
 Year,Month,Day,DayOfWeek:word;
 LineCount: integer;
 {** extract from source database }
 OriginalFileName: string;
 Tag: string;
 idx: integer;
 OriginalDate: string;
 MaxEntries: integer;
 codePointValue: string;
 TypeName: string;
 CodeCategory: tcategory;
 ValStr: string;
begin
 GetDate(Year,Month,Day,DayOfWeek);
 Fillchar(Data,sizeof(Data),#0);
 OriginalFileName:='';
 OriginalDate:='';
 { Start reading the english text file }
 Assign(EnFile,fname);
 Reset(EnFile);
 Entries:=0;
 UCS2Entries:=-1;
 ANSIEntries:=-1;
 ASCIIEntrieS:=-1;
 i:=1;
 LineCount:=0;
 Repeat
   ReadLine(EnFile,s);
   inc(LineCount);
   s:=trim(s);
   { Skip over comments }
   if (length(s) = 0) then
    continue;
   if (s[1] = COMMENT_CHAR) then
     begin
       { Just keep the first two lines for version information }
       if LineCount = 1 then
       begin
         delete(s,1,1);
         OriginalFileName:='UnicodeData.txt';
       end;
       continue;
     end;
   codePointValue:=GetField(s,IDX_CODEPOINT,';');
   { Get the codePoint range }
   GetCodePointRange(codePointValue,codePoint);
   if (codePoint.upper_code <> codePoint.lower_code) then
     begin
       WriteLn('Error: Range in case folding database.');
     end;
   CodeCategory:=GetGeneralCategory(GetField(s,IDX_CATEGORY,';'));
   if CodeCategory = number_decimal_digit  then
     begin
       inc(Entries);
       Data[Entries].upper_code:=CodePointValue;
       code_value:=ValHexadecimal(Data[Entries].upper_code,code);
       if (code_value > $7f) and (ASCIIEntries = -1) then
         begin
           ASCIIEntries:=Entries-1;
         end;
       if (code_value > $ff) and (ANSIEntries = -1) then
         begin
           ANSIEntries:=Entries-1;
         end;
       if (code_value > $ffff) and (UCS2Entries = -1) then
         begin
           UCS2Entries:=Entries-1;
         end;
     end;
 Until Eof(EnFile);
 { Nothing found, all are UCS-2 characters }
 { Nothing found, all are UCS-2 characters }
 if UCS2Entries = -1 then
     UCS2Entries:=Entries;
 if ASCIIEntries = -1 then
   ASCIIEntries:=Entries;
 if ANSIEntries = -1 then
   ANSIEntries:=Entries;
 { Now write the file }
 Assign(T,'Z:\digits.inc');
 Rewrite(T);
 S:=GetISODateString(Year, Month, Day);
 WriteLn(T,'{ Unicode character digit character data');
 WriteLn(T,'  Generated on ',S);
 if length(OriginalFileName) > 0 then
   WriteLn(T,'  From ',OriginalFilename);
 WriteLN(T,'  Encoded in the ISO-8859-1 character set');
 WriteLn(T,'}');

 { Are we writing a UCS-2 or UCS-4 table? }
 if ucs2 then
   begin
      MaxEntries:=UCS2Entries;
      TypeName:='ucs2char';
   end
 else
   begin
      MaxEntries:=Entries;
      TypeName:='ucs4char';
   end;

 WriteLn(T,'const');
 WriteLn(T,'  MAX_DIGITS =',MaxEntries,';');
 WriteLn(T,'  MAX_UCS2_DIGITS =',UCS2Entries,';');
 WriteLn(T,'  MAX_ANSI_DIGITS =',ANSIEntries,';');
 WriteLn(T,'  MAX_ASCII_DIGITS =',ASCIIEntries,';');
 WriteLn(T);
 WriteLn(T);
 WriteLn(T,'const');
 WriteLn(T,'  Digits: array[1..MAX_DIGITS] of ',TypeName,' = (');
 { Depending on the Unicode format used }
 for i:=1 to MaxEntries do
   begin
     Write(T,'   $',Data[i].upper_code);
     if i <> Entries then
       WriteLn(T,',')
     else
       WriteLn(T)
   end;
 WriteLn(T,');');
 Close(T);
end;



type
  TPropInfo = record
    {** The name of the property in PropList.txt }
    propname: string;
    {** Output filename for this property }
    filename: string;
    {** The structure name to use for this property }
    name: string;
  end;

const
  MAX_PROPERTIES = 3;

  PropList: array[1..MAX_PROPERTIES] of TPropInfo =
  (
    (propname: 'Hex_Digit'; filename: 'hexdig.inc'; name: 'HexDigits'),
    (propname: 'White_Space'; filename: 'whitespc.inc'; name: 'WhiteSpace'),
    (propname: 'STerm'; filename: 'term.inc'; name: 'Terminals')
  );


procedure CreateProperties(fname: string; ucs2: boolean);
var
 EnFile: Text;
 i: integer;
 s: string;
 code: integer;
 codePoint: TCodePointRange;
 codeType: string;
 { Number of UCS-4 entries }
 Entries: integer;
 { Number of UCS-2 entries }
 LineCount: integer;
 {** extract from source database }
 OriginalFileName: string;
 Tag: string;
 idx: integer;
 codePointValue: string;
 CodeProperty: string;
 ValStr: string;
 counter: integer;
begin
 for counter:=1 to MAX_PROPERTIES do
    begin
     Fillchar(Data,sizeof(Data),#0);
     OriginalFileName:='';
     { Start reading the english text file }
     Assign(EnFile,fname);
     Reset(EnFile);
     Entries:=0;
     i:=1;
     LineCount:=0;
     Repeat
       ReadLine(EnFile,s);
       inc(LineCount);
       s:=trim(s);
       { Skip over comments }
       if (length(s) = 0) then
        continue;
       if (s[1] = COMMENT_CHAR) then
        begin
           { Just keep the first two lines for version information }
           if LineCount = 1 then
           begin
             delete(s,1,1);
             OriginalFileName:='UnicodeData.txt';
           end;
           continue;
         end;
       codePointValue:=GetField(s,IDX_CODEPOINT,';');
       { Get the codePoint range }
       GetCodePointRange(codePointValue,codePoint);
       CodeProperty:=GetField(s,1,';');
       if pos(PropList[counter].propname,CodeProperty) = 1  then
         begin
           inc(Entries);
           Data[Entries].upper_code:=CodePoint.upper_code;
           Data[Entries].lower_code:=CodePoint.lower_code;
         end;
     Until Eof(EnFile);
     WriteDataTableArray(PropList[counter].filename,PropList[counter].name,UCS2, Entries,Data);
  end;
end;

procedure CreateNumberValue(fname: string; ucs2: boolean);
var
 EnFile: Text;
 i: integer;
 s: string;
 code: integer;
 codePoint: TCodePointRange;
 codeType: string;
 codeLowerCase: string;
 { Number of UCS-4 entries }
 Entries: integer;
 { Number of UCS-2 entries }
 UCS2Entries: integer;
 ASCIIEntries: integer;
 ANSIEntries: integer;
 codeUpperCase: string;
 code_value: integer;
 T: Text;
 Year,Month,Day,DayOfWeek:word;
 LineCount: integer;
 {** extract from source database }
 OriginalFileName: string;
 CodeNumeric: string;
 Tag: string;
 idx: integer;
 OriginalDate: string;
 MaxEntries: integer;
 codePointValue: string;
 TypeName: string;
 CodeDecomposition: string;
 SimplifiedCodePoint: string;
 ValStr: string;
begin
 GetDate(Year,Month,Day,DayOfWeek);
 Fillchar(Data,sizeof(Data),#0);
 OriginalFileName:='';
 OriginalDate:='';
 { Start reading the english text file }
 Assign(EnFile,fname);
 Reset(EnFile);
 Entries:=0;
 UCS2Entries:=-1;
 ANSIEntries:=-1;
 ASCIIEntrieS:=-1;
 i:=1;
 LineCount:=0;
 Repeat
   ReadLine(EnFile,s);
   inc(LineCount);
   s:=trim(s);
   { Skip over comments }
   if (length(s) = 0) then
    continue;
   if (s[1] = COMMENT_CHAR) then
     begin
       { Just keep the first two lines for version information }
       if LineCount = 1 then
       begin
         delete(s,1,1);
         OriginalFileName:='UnicodeData.txt';
       end;
       continue;
     end;

   codePointValue:=GetField(s,IDX_CODEPOINT,';');
   { Get the codePoint range }
   GetCodePointRange(codeUpperCase,codePoint);
   if (codePoint.upper_code <> codePoint.lower_code) then
     begin
       WriteLn('Error: Range in case folding database.');
     end;
   CodeNumeric:=GetField(s,IDX_NUMERIC_ALL,';');
   if CodeNumeric <> '' then
     begin
       { Verify if this value be represented in as an integer numeric value }
       ValDecimal(CodeNumeric,code);
       if code <> 0 then
         { Same syntax as getNumericValue of java }
         CodeNumeric:='-2';
       inc(Entries);
       Data[Entries].upper_code:=CodePointValue;
       Data[Entries].lower_code:=CodeNumeric;
       code_value:=ValHexadecimal(Data[Entries].upper_code,code);
       if (code_value > $7f) and (ASCIIEntries = -1) then
         begin
           ASCIIEntries:=Entries-1;
         end;
       if (code_value > $ff) and (ANSIEntries = -1) then
         begin
           ANSIEntries:=Entries-1;
         end;
       if (code_value > $ffff) and (UCS2Entries = -1) then
         begin
           UCS2Entries:=Entries-1;
         end;
     end;
 Until Eof(EnFile);
 { Nothing found, all are UCS-2 characters }
 { Nothing found, all are UCS-2 characters }
 if UCS2Entries = -1 then
     UCS2Entries:=Entries;
 if ASCIIEntries = -1 then
   ASCIIEntries:=Entries;
 if ANSIEntries = -1 then
   ANSIEntries:=Entries;

 { Now write the file }
 Assign(T,'Z:\numeric.inc');
 Rewrite(T);
 S:=GetISODateString(Year, Month, Day);
 WriteLn(T,'{ Unicode character numerical equivalent character data');
 WriteLn(T,'  Generated on ',S);
 if length(OriginalFileName) > 0 then
   WriteLn(T,'  From ',OriginalFilename);
 WriteLN(T,'  Encoded in the ISO-8859-1 character set');
 WriteLn(T,'}');

 { Are we writing a UCS-2 or UCS-4 table? }
 if ucs2 then
   begin
      MaxEntries:=UCS2Entries;
      TypeName:='ucs2char';
   end
 else
   begin
      MaxEntries:=Entries;
      TypeName:='ucs4char';
   end;

 WriteLn(T,'const');
 WriteLn(T,'  MAX_NUMERIC_MAPPINGS =',MaxEntries,';');
 WriteLn(T,'  MAX_NUMERIC_UCS2_MAPPINGS =',UCS2Entries,';');
 WriteLn(T,'  MAX_NUMERIC_ANSI_MAPPINGS =',ANSIEntries,';');
 WriteLn(T,'  MAX_NUMERIC_ASCII_MAPPINGS =',ASCIIEntries,';');
 WriteLn(T,'type');
 WriteLn(T,'  TNumericInfo = record');
 WriteLn(T,'    CodePoint: ',TypeName,';');
 WriteLn(T,'    value: longint;');
 WriteLn(T,'  end;');
 WriteLn(T);
 WriteLn(T);
 WriteLn(T,'const');
 WriteLn(T,'  NumericalMappings: array[1..MAX_NUMERIC_MAPPINGS] of TNumericInfo = (');
 { Depending on the Unicode format used }
 for i:=1 to MaxEntries do
   begin
     Write(T,'   (CodePoint: $',Data[i].upper_code,'; value: ',Data[i].lower_code,')' );
     if i <> Entries then
       WriteLn(T,',')
     else
       WriteLn(T)
   end;
 WriteLn(T,');');
 Close(T);
end;


procedure CreateSGMLEntityTable(fname: string; ucs2: boolean);
var
 EnFile: Text;
 i: integer;
 s: string;
 code: integer;
 codePoint: TCodePointRange;
 codeType: string;
 codeLowerCase: string;
 { Number of UCS-4 entries }
 Entries: integer;
 { Number of UCS-2 entries }
 UCS2Entries: integer;
 ASCIIEntries: integer;
 ANSIEntries: integer;
 codeUpperCase: string;
 code_value: integer;
 T: Text;
 Year,Month,Day,DayOfWeek:word;
 LineCount: integer;
 {** extract from source database }
 OriginalFileName: string;
 CodeNumeric: string;
 Tag: string;
 idx: integer;
 OriginalDate: string;
 MaxEntries: integer;
 codePointValue: string;
 TypeName: string;
 CodeDecomposition: string;
 EntityName: string;
 ValStr: string;
begin
 GetDate(Year,Month,Day,DayOfWeek);
 Fillchar(Data,sizeof(Data),#0);
 OriginalFileName:='';
 OriginalDate:='';
 { Start reading the english text file }
 Assign(EnFile,fname);
 Reset(EnFile);
 Entries:=0;
 UCS2Entries:=-1;
 ANSIEntries:=-1;
 ASCIIEntrieS:=-1;
 i:=1;
 LineCount:=0;
 Repeat
   ReadLine(EnFile,s);
   inc(LineCount);
   s:=trim(s);
   { Skip over comments }
   if (length(s) = 0) then
    continue;
   if (s[1] = COMMENT_CHAR) then
     begin
       { Just keep the first two lines for version information }
       if LineCount = 1 then
       begin
         delete(s,1,1);
         OriginalFileName:='UnicodeData.txt';
       end;
       continue;
     end;

   EntityName:=GetField(s,0,#9);
   CodePointValue:=GetField(s,2,#9);
   { Remove 0x }
   delete(CodePointValue,1,2);
   { Get the codePoint range }
   GetCodePointRange(codeUpperCase,codePoint);
   if EntityName <> '' then
     begin
       { Verify if this value be represented in as an integer numeric value }
       ValHexaDecimal(CodePointValue,code);
       if code <> 0 then
         continue;
       inc(Entries);
       Data[Entries].upper_code:=EntityName;
       Data[Entries].lower_code:=CodePointValue;
       code_value:=ValHexadecimal(Data[Entries].upper_code,code);
       if (code_value > $7f) and (ASCIIEntries = -1) then
         begin
           ASCIIEntries:=Entries-1;
         end;
       if (code_value > $ff) and (ANSIEntries = -1) then
         begin
           ANSIEntries:=Entries-1;
         end;
       if (code_value > $ffff) and (UCS2Entries = -1) then
         begin
           UCS2Entries:=Entries-1;
         end;
     end;
 Until Eof(EnFile);
 { Nothing found, all are UCS-2 characters }
 { Nothing found, all are UCS-2 characters }
 if UCS2Entries = -1 then
     UCS2Entries:=Entries;
 if ASCIIEntries = -1 then
   ASCIIEntries:=Entries;
 if ANSIEntries = -1 then
   ANSIEntries:=Entries;

 { Now write the file }
 Assign(T,'Z:\sgml.inc');
 Rewrite(T);
 S:=GetISODateString(Year, Month, Day);
 WriteLn(T,'{ SGML Entity to Unicode mapping table');
 WriteLn(T,'  Generated on ',S);
 if length(OriginalFileName) > 0 then
   WriteLn(T,'  From ',OriginalFilename);
 WriteLN(T,'  Encoded in the ISO-8859-1 character set');
 WriteLn(T,'}');

 { Are we writing a UCS-2 or UCS-4 table? }
 if ucs2 then
   begin
      MaxEntries:=UCS2Entries;
      TypeName:='ucs2char';
   end
 else
   begin
      MaxEntries:=Entries;
      TypeName:='ucs2char';
   end;

 WriteLn(T,'const');
 WriteLn(T,'  MAX_SGML_MAPPINGS =',MaxEntries,';');
 WriteLn(T,'type');
 WriteLn(T,'  TSGMLInfo = record');
 WriteLn(T,'    EntityName: string[8];');
 WriteLn(T,'    CodePoint:',TypeName,';');
 WriteLn(T,'  end;');
 WriteLn(T);
 WriteLn(T);
 WriteLn(T,'const');
 WriteLn(T,'  SGMLMappings: array[1..MAX_SGML_MAPPINGS] of TSGMLInfo = (');
 { Depending on the Unicode format used }
 for i:=1 to MaxEntries do
   begin
     Write(T,'   (EntityName: ''',Data[i].upper_code,'''; CodePoint: $',Data[i].lower_code,')' );
     if i <> Entries then
       WriteLn(T,',')
     else
       WriteLn(T)
   end;
 WriteLn(T,');');
 Close(T);
end;





Begin
 CreateCaseFolding('Z:\UnicodeData.txt',false);
 CreateDecomposition('Z:\UnicodeData.txt',false);
 CreateDigit('Z:\UnicodeData.txt',false);
 CreateProperties('Z:\PropList.txt',false);
 CreateNumberValue('Z:\UnicodeData.txt',false);
 CreateSGMLEntityTable('Z:\sgml.txt',false);
end.
