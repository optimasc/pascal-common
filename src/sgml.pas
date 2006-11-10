{
 ****************************************************************************
    $Id: sgml.pas,v 1.9 2006-11-10 04:07:20 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere (Optima SC Inc.)

    SGML related utility routines

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}
{** @abstract(SGML, HTML and XML Related routines) }
unit sgml;

interface
 {==== Compiler directives ===========================================}
 {$X+} { Extended syntax }
 {$V-} { Strict VAR strings }
 {$P-} { Implicit open strings }
 {$B-} { No full boolean evaluation }
 {$T+} { Typed pointers }
 {$IFNDEF TP}
 {$J+} { Writeable constants }
 {$ENDIF}
 {====================================================================}
uses 
 tpautils,
 fpautils,
 vpautils,
 dpautils,
 unicode;

 
const
  {** No error }
  SGML_STATUS_OK = 0;   
  {** Malformed SGML Element }
  SGML_STATUS_MALFORMED = 1;
  {** No DTD Presence in SGML }
  SGML_STATUS_NO_DTD = 2;

{** @abstract(Verifies a DOCTYPE declaration)

    Parses a DOCTYPE declaration for validity and if it is valid, returns
    the top_element tag, the availability information as well as the
    public identifier (registration information). The returned FPI is not
    in double quotes.

    @param(s Full DOCTYPE Declaration)
    @returns(SGML_STATUS_OK = no error, SGML_STATUS_MALFORMED = malformed DTD, 
       SGML_STATUS_NO_DTD = no DTD)
}
function SGMLGetDTDInfo(s: string; var top_element,availability,fpi: string): integer;

{** Parses and returns the name of an attribute as well as
    its value. Works with both SGML and XML syntax, assumes
    UTF-8 or SIO encoded characters }
procedure SGMLGetAttributeValue(attr: string; var name,value: string);

{** Parses and returns the name of an attribute as well as
    its value. Works with both SGML and XML syntax. }
procedure SGMLGetAttributeValueUCS4String(attr: ucs4string; var name,value: ucs4string);

{** Convert a string possibly containing main SGML/HTML/XML entities to 
    its ISO-8859-1 representation }    
function SGMLEntitiesToISO8859_1(s: string): string;

{** Convert an UCS-4 string possibly containing main SGML/HTML/XML entities to 
    its UCS-4 string representation }    
procedure SGMLEntitiesToUCS4String(instr: ucs4string; var outstr:ucs4string);



implementation

uses utils;

const
  space_character = [#9,#32];
  DOCTYPE_STR = '<!DOCTYPE';
  
  MIN_EXTRA_ENTITIES = 1;
  MAX_EXTRA_ENTITIES = 32;
  MIN_ENTITIES = 160;
  MAX_ENTITIES = 255;
  
type 
  tentity = record
   name: string[6];
   numeric: word;
  end;
  
  
{$i sgml.inc}  
  

function SGMLGetDTDInfo(s: string; var top_element,availability,fpi: string): integer;
var
 idx: integer;
 i: integer;
 strlength: integer;
begin
  SGMLGetDTDInfo:=SGML_STATUS_NO_DTD;
  idx:=pos(DOCTYPE_STR,s);
  if idx = 1 then
      SGMLGetDTDInfo:=SGML_STATUS_OK
  else
  if pos(DOCTYPE_STR,upstring(s))=1 then
    begin
      idx:=pos(DOCTYPE_STR,upstring(s));
      s:=upstring(s);
  { Check it is malformed }
      SGMLGetDTDInfo:=SGML_STATUS_MALFORMED;
     end;
  if idx = 1 then
    begin
      s:=copy(s,1,pos('>',s));
      if length(s) > 0 then
        begin
          { Delete the Doctype information }
          delete(s,1,length(DOCTYPE_STR));
          s:=trimleft(s);
          s:=trimright(s);
          top_element:='';
          i:=1;
          strlength:=length(s);
          while (i < strlength) and not (s[i] in space_character) do
            begin
              top_element:=top_element+s[i];
              inc(i);
            end;
          { impossible, top element must have at least 1 character }
          if i=1 then
            exit;
          { Delete the top element string }
          delete(s,1,i);
          s:=trimleft(s);
          s:=trimright(s);
          availability:='';
          i:=1;
          strlength:=length(s);
          while ( i < strlength) and not (s[i] in space_character) do
            begin
              availability:=availability+s[i];
              inc(i);
            end;
          { impossible, top element must have at least 1 character }
          if i=1 then
            exit;
          { Delete the availability string }
          delete(s,1,i);
          { now get the FPI, without the double quotes }
          s:=trimleft(s);
          s:=trimright(s);
          { starts with double quotes }
          if (pos('"',s) = 1) then
           begin
             delete(s,1,1);
             { end with double quotes }
             fpi:=copy(s,1,pos('"',s)-1);
             exit;
           end;
        end;
    end;
end;

  { Returns the string value enclosed either in single quotes or double
    quotes. Scraps the rest of the string.
  }
  function SGMLGetQuotedValue(s:string): string;
  var
   resultstr: string;
   i: integer;
   { this is the character which started the quote }
   c: char;
   strlength: integer;
  begin
    SGMLGetQuotedValue := '';
    i:=1;
    c:=#0;
    resultstr:='';
    strlength:=length(s);
    while i <= strlength do
    begin
     if (c = #0) and (s[i] = '''') then
       c:=''''
     else
     if (c = #0) and (s[i] = '"') then
       c:='"'
     else
     if (c <> #0) then
       begin
         { end of quoted string }
         if s[i] = c then
         begin
            SGMLGetQuotedValue := resultstr;
            exit;
         end;
         resultstr:=concat(resultstr,s[i]);
       end;
     inc(i);
    end;
  end;
  
  { Returns the string value enclosed either in single quotes or double
    quotes. Scraps the rest of the string.
  }
  procedure SGMLGetQuotedValueUCS4String(var resultstr: ucs4string; s:ucs4string);
  var
   i: integer;
   { this is the character which started the quote }
   c: ucs4char;
   strlength: integer;
  begin
    ucs4_setlength(resultstr,0);
    i:=1;
    c:=ucs4char(#0);
    strlength:=ucs4_length(s);
    while i <= strlength do
    begin
     if (c = 0) and (char(s[i]) = '''') then
       c:=ucs4char('''')
     else
     if (c = 0) and (char(s[i]) = '"') then
       c:=ucs4char('"')
     else
     if (c <> 0) then
       begin
         { end of quoted string }
         if s[i] = c then
         begin
            exit;
         end;
         ucs4_concat(resultstr,resultstr,s[i]);
       end;
     inc(i);
    end;
  end;
  

procedure SGMLGetAttributeValue(attr: string; var name,value: string);
var
 index: integer;
begin
 index:=pos('=',attr);
 name:='';
 value:='';
 if index <> 0 then
   begin
    name:=copy(attr,1,index-1);
    delete(attr,1,index);
    attr:=trimleft(attr);
    attr:=trimright(attr);
    if (pos('"',attr)=1) or (pos('''',attr)=1) then
       value:=SGMLGetQuotedValue(attr)
    else
       value:=attr;
   end;
end;

procedure SGMLGetAttributeValueUCS4String(attr: ucs4string; var name,value: ucs4string);
var
 index: integer;
begin
 index:=ucs4_posascii('=',attr);
 ucs4_setlength(name,0);
 ucs4_setlength(value,0);
 if index <> 0 then
   begin
    ucs4_copy(name,attr,1,index-1);
    ucs4_delete(attr,1,index);
    ucs4_trim(attr);
    if (ucs4_posascii('"',attr)=1) or (ucs4_posascii('''',attr)=1) then
       SGMLGetQuotedValueUCS4String(value,attr)
    else
       value:=attr;
   end;
end;



function SGMLEntitiesToISO8859_1(s: string): string;
var
 i: integer;
 j: integer;
 outstr: string;
 entitystr: string;
 inentity: boolean;
 code: integer;
 value: longint;
 strlength: integer;
begin
  SGMLEntitiesToISO8859_1:=s;
  SetLength(outstr,0);
  SetLength(entitystr,0);
  i:=1;
  inentity:=false;
  strlength:=length(s);
  while i <= strlength do
  begin
    case s[i] of
    '&':
          begin
            inentity:=true;
            inc(i);
          end;
    ';':
          begin
            if inentity then
              begin
                inentity:=false;
                if (length(entitystr) = 0) then
                  begin
                    inc(i);
                    continue;
                  end;
                { Check the type of entity we have }
                if (entitystr[1] = '#') and (entitystr[2] in ['X','x']) then
                  begin
                    { Hexadecimal representation }
                    delete(entitystr,1,2);
                    value:=ValHexaDecimal(entitystr,code);
                    { ISO 8859-1 are encoded one one byte, so ignore
                      all other characters.
                    }
                    if (code = 0) and (value < $FF) then
                      begin
                        outstr:=outstr+chr(value);
                      end;

                  end
                else
                if (entitystr[1] = '#') and not (entitystr[2] in ['X','x']) then
                  begin
                    { Decimal representation }
                    delete(entitystr,1,1);
                    value:=ValDecimal(entitystr,code);
                    { ISO 8859-1 are encoded one one byte, so ignore
                      all other characters.
                    }
                    if (code = 0) and (value < $FF) then
                      begin
                        outstr:=outstr+chr(value);
                      end;
                  end
                else
                  begin
                    { Entity reference - search the tables }
                    { now search the entity lists and convert them to characters }
                    for j:=1 to MAX_ENTITIES do
                      begin
                        if SGMLMappings[j].EntityName = entitystr then
                          begin
                            if (SGMLMappings[j].CodePoint > $ff) then
                              outstr:=outstr+'\u+'+HexStr(SGMLMappings[j].CodePoint,4)
                            else
                              outstr:=outstr+char(SGMLMappings[j].CodePoint);
                            break;
                          end;
                      end;
                  end;
               { reset entity string }
               entitystr:='';
              end { if inentity }
            else
                outstr:=outstr+s[i];
            inc(i);
          end; { end switch case }
    else
      begin
        { Fill up either the result string or the entity value }
        if not inentity then
           outstr:=outstr+s[i]
        else
           entitystr:=entitystr+s[i];
        inc(i);
      end;
    end;
  end;
  SGMLEntitiesToISO8859_1:=outstr;
end;


procedure SGMLEntitiesToUCS4String(instr: ucs4string; var outstr:ucs4string);
var
 i: integer;
 j: integer;
 entitystr: ucs4string;
 asciientitystr: string;
 inentity: boolean;
 code: integer;
 value: longint;
 found: boolean;
 strlength: integer;
begin
  UCS4_SetLength(outstr,0);
  UCS4_SetLength(entitystr,0);
  i:=1;
  inentity:=false;
  strlength:=ucs4_length(instr);
  while i <= strlength do
  begin
    case char(instr[i]) of
    '&':
          begin
            inentity:=true;
            inc(i);
          end;
    ';':
          begin
            if inentity then
              begin
                inentity:=false;
                if (ucs4_length(entitystr) = 0) then
                  begin
                    inc(i);
                    continue;
                  end;
                { Check the type of entity we have }
                if (entitystr[1] = ucs4char('#')) and (char(entitystr[2]) in ['X','x']) then
                  begin
                    { Hexadecimal representation }
                    ucs4_delete(entitystr,1,2);
                    asciientitystr:=ucs4_converttoiso8859_1(entitystr);
                    value:=ValHexaDecimal(asciientitystr,code);
                    if (code = 0) then
                      begin
                        ucs4_concat(outstr,outstr,ucs4char(value));
                      end;
                  end
                else
                if (entitystr[1] = ucs4char('#')) and not (char(entitystr[2]) in ['X','x']) then
                  begin
                    { Decimal representation }
                    ucs4_delete(entitystr,1,1);
                    asciientitystr:=ucs4_converttoiso8859_1(entitystr);
                    value:=ValDecimal(asciientitystr,code);
                    if (code = 0) then
                      begin
                        ucs4_concat(outstr,outstr,ucs4char(value));
                      end;
                  end
                else
                  begin
                    found:=false;
                    asciientitystr:=ucs4_converttoiso8859_1(entitystr);
                    if not found then
                      begin
                        for j:=1 to MAX_ENTITIES do
                           begin
                             if SGMLMappings[j].EntityName = asciientitystr then
                               begin
                                 value:=SGMLMappings[j].CodePoint;
                                 ucs4_concat(outstr,outstr,ucs4char(value));
                                 break;
                               end;
                           end;
                      end;
                  end;
               { reset entity string }
               ucs4_setlength(entitystr,0);
              end { if inentity }
            else
                ucs4_concat(outstr,outstr,instr[i]);
            inc(i);
          end; { end switch case }
    else
      begin
        { Fill up either the result string or the entity value }
        if not inentity then
           ucs4_concat(outstr,outstr,instr[i])
        else
           ucs4_concat(entitystr,entitystr,instr[i]);
        inc(i);
      end;
    end;
  end;
end;




end.
{
  $Log: not supported by cvs2svn $
  Revision 1.8  2006/08/31 03:04:46  carl
  + Better documentation

  Revision 1.7  2006/08/23 00:50:02  carl
  * Modified SGMLGetDTDInfo() to return better error status

  Revision 1.6  2005/11/21 00:18:13  carl
    - remove some compilation warnings/hints
    + speed optimizations
    + recreated case.inc file from latest unicode casefolding standard

  Revision 1.5  2005/01/30 20:07:31  carl
   * optimize for speed

  Revision 1.4  2004/11/29 03:45:03  carl
    + UCS-4 string version of SGML routinrd.

  Revision 1.3  2004/10/31 19:50:57  carl
    * range check error bugfix

  Revision 1.2  2004/10/27 02:00:19  carl
    * bugfix with infinit loop when validating the Doctype declaration

  Revision 1.1  2004/10/13 23:26:11  carl
    + initial revision

}
