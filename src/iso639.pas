{
 ****************************************************************************
    $Id: iso639.pas,v 1.1 2004-08-19 00:21:16 carl Exp $
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
}
unit iso639;


interface

uses
  dpautils,
  vpautils,
  fpautils,
  gpautils,
  tpautils,
  utils;


{** @abstract(Verifies if the 2 or 3 letter language code is valid)
    This routine checks if the two or three letter language code is
    valid (as defined in ISO 639, part 1 and part 2 respectively). 
    The language  code IS case sensitive and should be in lower case.
    
    @param(s The two or three digit language code)
    @returns(TRUE if the language code is valid, otherwise returns FALSE)
}
function isvalidlangcode(s: shortstring): boolean;

{ This routine returns the language name in french 
  for the specified language code. The language code
  IS case insensitive and can be either 2 or 3 characters
  in length (according to ISO 639-1 and ISO 639-2 respectively)
  
  The returned string is encoded according to
  ISO-8859-1.
  
  @param(s The two or three digit language code)
  
}
function getlangname_fr(s: shortstring): shortstring;

{ This routine returns the language name in english
  for the specified language code. The language code
  IS case insensitive and can be either 2 or 3 characters
  in length (according to ISO 639-1 and ISO 639-2 respectively)
  
  The returned string is encoded according to
  ISO-8859-1.
  
  @param(s The two or three digit language code)
}
function getlangname_en(s: shortstring): shortstring;



implementation

{$I iso639.inc}

type
    tlangsets =  array[1..MAX_ENTRIES] of tlanginfo;
    plangsets = ^tlangsets;


var
    lang_info: plangsets;
    ExitSave: pointer;
{$ifdef tp}    
    p: pchar;
{$endif}    



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
begin
  getlangname_fr:='';
  if (length(s) > 3) or (length(s) = 0) then
    exit;
  for i:=1 to MAX_ENTRIES do
    begin
      { Check the 2-digit code }
      if Lang_Info^[i].code = s then
         begin
            getlangname_fr:=Lang_Info^[i].name_fr;
            exit;
         end
      else
      { Check the 3-digit code }
      if Lang_Info^[i].biblio_code = s then
         begin
            getlangname_fr:=Lang_Info^[i].name_fr;
            exit;
         end;
    end;
end;

function getlangname_en(s: shortstring): shortstring;
var
 i: integer;
begin
  getlangname_en:='';
  if (length(s) > 3) or (length(s) = 0) then
    exit;
  for i:=1 to MAX_ENTRIES do
    begin
      { Check the 2-digit code }
      if Lang_Info^[i].code = s then
         begin
            getlangname_en:=Lang_Info^[i].name_en;
            exit;
         end
      else
      { Check the 3-digit code }
      if Lang_Info^[i].biblio_code = s then
         begin
            getlangname_en:=Lang_Info^[i].name_en;
            exit;
         end;
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
}