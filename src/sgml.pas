{
 ****************************************************************************
    $Id: sgml.pas,v 1.1 2004-10-13 23:26:11 carl Exp $
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
 {$T+} { Typed pointers }
 {$IFNDEF TP}
 {$J+} { Writeable constants }
 {$ENDIF}
 {====================================================================}
uses 
 tpautils,
 fpautils,
 vpautils,
 dpautils;

 


{** Parses a DOCTYPE declaration for validity and if it is valid, returns
    the top_element tag, the availability information as well as the
    public identifier (registration information). The returned FPI is not
    in double quotes.

    @returns(true if this is a valid DTD declaration)
}
function SGMLGetDTDInfo(s: string; var top_element,availability,fpi: string): boolean;

{** Parses and returns the name of an attribute as well as
    its value. Works with both SGML and XML syntax. }
procedure SGMLGetAttributeValue(attr: string; var name,value: string);

{** Convert a string possibly containing main SGML/HTML/XML entities to 
    its ISO-8859-1 representation }    
function SGMLEntitiesToISO8859_1(s: string): string;




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
  
const
  { Standard ISOLat entity table }
  main_entities : array[MIN_ENTITIES..MAX_ENTITIES] of string[6] =
  (
   ' nbsp',
    'iexcl',
    'cent',
    'pound', 
    'curren',
    'yen',
    'brvbar',
    'sect',
    'uml',
    'copy',
    'ordf',
    'laquo',
    'not',
    'shy',
    'reg',
    'macr',
    'deg',
    'plusmn',
    'sup2',
    'sup3',
    'acute',
    'micro',
    'para',
    'middot',
    'cedil',
    'sup1',
    'ordm',
    'raquo',
    'frac14',
    'frac12',
    'frac34',
    'iquest',
    'Agrave',
    'Aacute',
    'Acirc',
    'Atilde',
    'Auml',
    'Aring',
    'AElig',
    'Ccedil',
    'Egrave',
    'Eacute',
    'Ecirc',
    'Euml',
    'Igrave',
    'Iacute',
    'Icirc',
    'Iuml',
    'ETH',
    'Ntilde',
    'Ograve',
    'Oacute',
    'Ocirc',
    'Otilde',
    'Ouml',
    'times',
    'Oslash',
    'Ugrave',
    'Uacute',
    'Ucirc',
    'Uuml',
    'Yacute',
    'THORN',
    'szlig',
    'agrave',
    'aacute',
    'acirc',
    'atilde',
    'auml',
    'aring',
    'aelig',
    'ccedil',
    'egrave',
    'eacute',
    'ecirc',
    'euml',
    'igrave',
    'iacute',
    'icirc',
    'iuml',
    'eth',
    'ntilde',
    'ograve',
    'oacute',
    'ocirc',
    'otilde',
    'ouml',
    'divide',
    'oslash',
    'ugrave',
    'uacute',
    'ucirc',
    'uuml',
    'yacute',
    'thorn',
    'yuml'
   );

  extra_entities: array[MIN_EXTRA_ENTITIES..MAX_EXTRA_ENTITIES] of tentity =
  (
    (name: 'quot'; numeric:  34),   {  quotation mark = APL quote }
    (name: 'amp'; numeric:  38),   {  ampersand, U+0026 ISOnum }
    (name: 'lt'; numeric:  60),   {  less-than sign, U+003C ISOnum }
    (name: 'gt'; numeric:  62),   {  greater-than sign, U+003E ISOnum }
    (name: 'OElig'; numeric:  338),  {  latin capital ligature O }
    (name: 'oelig'; numeric:  339),  {  latin small ligature oe, U+0153 ISOlat2 }
    (name: 'Scaron'; numeric:  352),  {  latin capital letter S with caron }
    (name: 'scaron'; numeric:  353),  {  latin small letter s with caron }
    (name: 'Yuml'; numeric:  376),  {  latin capital letter Y with diaeresis }
    (name: 'circ'; numeric:  710),  {  modifier letter circumflex accent }
    (name: 'tilde'; numeric:  732),  {  small tilde, U+02DC ISOdia }
    (name: 'ensp'; numeric:  8194), {  en space, U+2002 ISOpub }
    (name: 'emsp'; numeric:  8195), {  em space, U+2003 ISOpub }
    (name: 'thinsp'; numeric:  8201), {  thin space, U+2009 ISOpub }
    (name: 'zwnj'; numeric:  8204), {  zero width non-joiner }
    (name: 'zwj'; numeric:  8205), {  zero width joiner, U+200D NEW RFC 2070 }
    (name: 'lrm'; numeric:  8206), {  left-to-right mark, U+200E NEW RFC 2070 }
    (name: 'rlm'; numeric:  8207), {  right-to-left mark, U+200F NEW RFC 2070 }
    (name: 'ndash'; numeric:  8211), {  en dash, U+2013 ISOpub }
    (name: 'mdash'; numeric:  8212), {  em dash, U+2014 ISOpub }
    (name: 'lsquo'; numeric:  8216), {  left single quotation mark, }
    (name: 'rsquo'; numeric:  8217), {  right single quotation mark }
    (name: 'sbquo'; numeric:  8218), {  single low-9 quotation mark, U+201A NEW }
    (name: 'ldquo'; numeric:  8220), {  left double quotation mark }
    (name: 'rdquo'; numeric:  8221), {  right double quotation mark }
    (name: 'bdquo'; numeric:  8222), {  double low-9 quotation mark, U+201E NEW }
    (name: 'dagger'; numeric:  8224), {  dagger, U+2020 ISOpub }
    (name: 'Dagger'; numeric:  8225), {  double dagger, U+2021 ISOpub }
    (name: 'permil'; numeric:  8240), {  per mille sign, U+2030 ISOtech }
    (name: 'lsaquo'; numeric:  8249), {  single left-pointing angle quotation mark }
    (name: 'rsaquo'; numeric:  8250), {  single right-pointing angle quotation mark }
    (name: 'euro'; numeric:  8364)  {  euro sign, U+20AC NEW }
  );    
  

function SGMLGetDTDInfo(s: string; var top_element,availability,fpi: string): boolean;
var
 idx: integer;
 i: integer;
begin
  SGMLGetDTDInfo:=false;
  idx:=pos(DOCTYPE_STR,s);
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
          while not (s[i] in space_character) do
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
          while not (s[i] in space_character) do
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
          if pos('"',s) = 1 then
           begin
             delete(s,1,1);
             { end with double quotes }
             fpi:=copy(s,1,pos('"',s)-1);
             SGMLGetDTDInfo:=true;
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
  begin
    SGMLGetQuotedValue := '';
    i:=1;
    c:=#0;
    resultstr:='';
    while i <= length(s) do
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

function SGMLEntitiesToISO8859_1(s: string): string;
var
 i: integer;
 j: integer;
 outstr: string;
 entitystr: string;
 inentity: boolean;
 code: integer;
 value: longint;
 found: boolean;
begin
  SGMLEntitiesToISO8859_1:=s;
  SetLength(outstr,0);
  SetLength(entitystr,0);
  i:=1;
  inentity:=false;
  while i <= length(s) do
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
                    found:=false;
                    { Entity reference - search the tables }
                    { now search the entity lists and convert them to characters }
                    for j:=MIN_ENTITIES to MAX_ENTITIES do
                      begin
                        if main_entities[j] = entitystr then
                          begin
                            outstr:=outstr+chr(j);
                            found:=true;
                            break;
                          end;
                      end;
                    { special entities search? }
                    if not found then
                      begin
                        for j:=MIN_EXTRA_ENTITIES to MAX_EXTRA_ENTITIES do
                           begin
                             if extra_entities[j].name = entitystr then
                               begin
                                 outstr:=outstr+chr(extra_entities[j].numeric);
                                 break;
                               end;
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


end.
{
  $Log: not supported by cvs2svn $
}
