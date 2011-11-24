{
 ****************************************************************************
    $Id: iso639.pas,v 1.5 2011-11-24 00:27:38 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Language code unit

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}

{** 
    @author(Carl Eric Codere)
    @abstract(Language code unit)
    This unit is used to check the language codes
    as well as return information on the country,
    according to ISO 639-1 and ISO 639-2.
    
    The database was taken from the following site:
    http://www.loc.gov/standards/iso639-2/ISO-639-2_values_8bits.txt
    
    The database used is from 2004-10-19.
}
unit iso639;


interface

uses cmntyp, utils;


{** @abstract(Verifies if the 2 or 3 letter language code is valid)

    This routine checks if the two or three letter language code is
    valid (as defined in ISO 639, part 1 and part 2 respectively). 
    The language  code IS case sensitive and should be in lower case.
    
    @param(s The two or three digit language code)
    @returns(TRUE if the language code is valid, otherwise returns FALSE)
}
function isvalidlangcode(s: shortstring): boolean;

{** @abstract(Returns the language name in french for the specified language code.) 

  The language code IS case insensitive and can be either 2 or 3 characters
  in length (according to ISO 639-1 and ISO 639-2 respectively)
  
  The returned string is encoded according to ISO-8859-1. If there are alternate 
  names for the language, only the first alternate 
  name is returned.
  
  @param(s The two or three digit language code)
  
}
function getlangname_fr(s: shortstring): shortstring;

{** @abstract(Returns the language name in english for the specified language code.) 

  The language code IS case insensitive and can be either 2 or 3 characters
  in length (according to ISO 639-1 and ISO 639-2 respectively)
  
  The returned string is encoded according to ISO-8859-1. If there are alternate 
  names for the language, only the first alternate 
  name is returned.
  
  @param(s The two or three digit language code)
  
}
function getlangname_en(s: shortstring): shortstring;


{** @abstract(Returns the 2 character code related to the english name of the language.) 
    
    
    The search is not case sensitive (according to ISO 639-1). 
    If there is no 2 character language code for this language, or
    if the language name is not found, the routine 
    returns an empty string.
  
    The language name string should be encoded according to
    ISO-8859-1.
  
  @param(name The name of the language)
  @returns(The 2 character language code)
}
function getlangcode_en(name: shortstring): shortstring;

{** @abstract(Returns the 2 character code related to the french name of the language.) 
    
    
    The search is not case sensitive (according to ISO 639-1). 
    If there is no 2 character language code for this language, or
    if the language name is not found, the routine 
    returns an empty string.
  
    The language name string should be encoded according to
    ISO-8859-1.
  
  @param(name The name of the language)
  @returns(The 2 character language code)
}
function getlangcode_fr(name: shortstring): shortstring;



implementation

uses iso639d;


type
    tlangsets =  array[1..MAX_ENTRIES] of tlanginfo;
    plangsets = ^tlangsets;


var
    lang_info: plangsets;
    ExitSave: pointer;
{$ifdef tp}    
    p: pchar;
{$endif}


   {** this routine is used to clean a a language
       name, it removes any extra information (that
       is in parenthesis), as well as removing all
       extra whitespace }
   Function CleanName(s: string): string;
   var
    index: integer;
   begin
    index:=Pos('(',s);
    if index <> 0 then
      begin
        delete(s,index,pos(')',s));
      end;
    CleanName:=trim(s);
   end;


function isvalidlangcode(s: shortstring): boolean;
var
 i: integer;
begin
  isvalidlangcode:=false;
  if (length(s) > 3) or (length(s) = 0) then
    exit;
  for i:=1 to MAX_ENTRIES do
    begin
      if Lang_Info^[i].code = s then
         begin
            isvalidlangcode:=true;
            exit;
         end
      else
      if Lang_Info^[i].biblio_code = s then
         begin
            isvalidlangcode:=true;
            exit;
         end;
    end;
end;

function getlangname_fr(s: shortstring): shortstring;
var
 i: integer;
 index: integer;
 name: string;
begin
  getlangname_fr:='';
  if (length(s) > 3) or (length(s) = 0) then
    exit;
  for i:=1 to MAX_ENTRIES do
    begin
      { Check the 2-digit code }
      if Lang_Info^[i].code = s then
         begin
            index:=pos(';',Lang_Info^[i].name_fr);
            if index<>0 then
                name:=CleanName(copy(Lang_Info^[i].name_fr,1,index-1))
            else
                name:=CleanName(Lang_Info^[i].name_fr);
            getlangname_fr:=name;
            exit;
         end
      else
      { Check the 3-digit code }
      if Lang_Info^[i].biblio_code = s then
         begin
            index:=pos(';',Lang_Info^[i].name_fr);
            if index<>0 then
                name:=CleanName(copy(Lang_Info^[i].name_fr,1,index-1))
            else
                name:=CleanName(Lang_Info^[i].name_fr);
            getlangname_fr:=name;
            exit;
         end;
    end;
end;

function getlangname_en(s: shortstring): shortstring;
var
 i: integer;
 index: integer;
 name: string;
begin
  getlangname_en:='';
  if (length(s) > 3) or (length(s) = 0) then
    exit;
  for i:=1 to MAX_ENTRIES do
    begin
      { Check the 2-digit code }
      if Lang_Info^[i].code = s then
         begin
            index:=pos(';',Lang_Info^[i].name_en);
            if index<>0 then
                name:=CleanName(copy(Lang_Info^[i].name_en,1,index-1))
            else
                name:=CleanName(Lang_Info^[i].name_en);
            getlangname_en:=name;
            exit;
         end
      else
      { Check the 3-digit code }
      if Lang_Info^[i].biblio_code = s then
         begin
            index:=pos(';',Lang_Info^[i].name_en);
            if index<>0 then
                name:=CleanName(copy(Lang_Info^[i].name_en,1,index-1))
            else
                name:=CleanName(Lang_Info^[i].name_en);
            getlangname_en:=name;
            exit;
         end;
    end;
end;

function getlangcode_en(name: shortstring): shortstring;
var
 i: integer;
 name_en: string;
 s: string;
 index: integer;
begin
  name:=upstring(name);
  getlangcode_en:='';
  for i:=1 to MAX_ENTRIES do
    begin
      name_en:=CleanName(Lang_Info^[i].name_en);
      repeat
        index:=pos(';',name_en);
        if index<>0 then
         begin
          s:=copy(name_en,1,index-1);
          delete(name_en,1,index);
         end
        else
          s:=name_en;

         { Now check if there are several names for the same language,
           each alternate name is separated by the others with a ;
           character.
         }
         { Check the 2-digit code }
         if upstring(trim(s)) = name then
         begin
            getlangcode_en:=Lang_Info^[i].code;
            exit;
         end;
      until (index=0);
    end;
end;

function getlangcode_fr(name: shortstring): shortstring;
var
 i: integer;
 name_fr: string;
 s: string;
 index: integer;
begin
  getlangcode_fr:='';
  name:=upstring(name);
  for i:=1 to MAX_ENTRIES do
    begin
      name_fr:=CleanName(Lang_Info^[i].name_fr);
      repeat
        index:=pos(';',name_fr);
        if index<>0 then
         begin
          s:=copy(name_fr,1,index-1);
          delete(name_fr,1,index);
         end
        else
          s:=name_fr;

         { Now check if there are several names for the same language,
           each alternate name is separated by the others with a ;
           character.
         }
         { Check the 2-digit code }
         if upstring(trim(s)) = name then
         begin
            getlangcode_fr:=Lang_Info^[i].code;
            exit;
         end;
      until (index=0);
    end;
end;



procedure releaseresources;far;
begin
  ExitProc := ExitSave;
  if assigned(lang_info) then
    Dispose(lang_info);
end;


begin
  ExitSave:= ExitProc;
  ExitProc := @ReleaseResources;
  new(lang_info);
{$ifdef tp}
  p:=@langcodesproc;
  move(p^,lang_info^,sizeof(tlangsets));
{$else}    
  move(langinfo,lang_info^,sizeof(tlangsets));
{$endif}
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.4  2006/08/31 03:05:18  carl
  + Better documentation

  Revision 1.3  2004/11/21 19:54:25  carl
    * 10-25% speed optimizations (change some parameter types to const, code folding)

  Revision 1.2  2004/11/15 03:34:03  carl
    * alternate names are now individually parsed

  Revision 1.1  2004/08/19 00:21:16  carl
    + Language code unit

}