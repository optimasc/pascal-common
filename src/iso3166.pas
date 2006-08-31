{
 ****************************************************************************
    $Id: iso3166.pas,v 1.4 2006-08-31 03:05:36 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Country code unit

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}

{** 
    @author(Carl Eric Codere)
    @abstract(Country code unit)
    This unit is used to check the country codes
    as well as return information on the country,
    according to ISO 3166.
    
    The lists were converted from the semicolon delimited
    version available here:
    http://www.iso.org/iso/en/prods-services/iso3166ma/    
    
    The version used is based on version of 2004-04-26.
}
unit iso3166;

interface

uses
  dpautils,
  vpautils,
  fpautils,
  gpautils,
  tpautils,
  utils;


{** @abstract(Verifies if the 2 letter country code is valid)
    This routine checks if the two letter country code is
    valid (as defined in ISO3166-1). The country code is
    not case sensitive.
    
    @param(s The three digit country code)
    @returns(TRUE if the country code is valid, otherwise
      returns FALSE)
}
function isvalidcountrycode(s: shortstring): boolean;

{** @abstract(Returns the country name in french 
  according to its country code.)

  The country code is case-insensitive.
  
  The returned string is encoded according to
  ISO-8859-1.
}
function getcountryname_fr(s: shortstring): shortstring;

{** @abstract(Returns the country name in english 
  according to its country code.)

  The country code is case-insensitive.
  
  The returned string is encoded according to
  ISO-8859-1.
}
function getcountryname_en(s: shortstring): shortstring;

implementation

{$i iso3166.inc}

{ Inactive country codes }
const
  { CURRENTLY THIS TABLE IS NEVER SEARCHED! }
  InactiveCountryIndo : array[1..7] of TCountryInfo = 
  (
    (
     name_fr: 'BIRMANIE';
     name_en: 'BURMA';
     code: 'BU';
     active: false
    ),
    (
     name_fr: 'ZONE NEUTRE';
     name_en: 'NEUTRAL ZONE';
     code: 'NT';
     active: false
    ),
    (
     name_fr: 'FINLANDE';
     name_en: 'FINLAND';
     code: 'SF';
     active: false
    ),
    (
     name_fr: 'UNION DES RÉPUBLIQUES SOCALISTES SOVIÉTIQUES';
     name_en: 'UNION OF SOVIET SOCIALIST REPUBLICS';
     code: 'SU';
     active: false
    ),
    (
     name_fr: 'TIMOR DE L''EST';
     name_en: 'EAST TIMOR';
     code: 'TP';
     active: false
    ),
    (
     name_fr: 'YUGOSLAVIE';
     name_en: 'YUGOSLAVIA';
     code: 'YU';
     active: false
    ),
    (
     name_fr: 'ZAIRE';
     name_en: 'ZAIRE';
     code: 'ZR';
     active: false
    )
  );

function isvalidcountrycode(s: shortstring): boolean;
var
 i: integer;
begin
  isvalidcountrycode:=false;
  if length(s) > 2 then
    exit;
  s:=upstring(s);
  for i:=1 to MAX_ENTRIES do
    begin
      if CountryInfo[i].code = s then
         begin
            isvalidcountrycode:=true;
            exit;
         end;
    end;
end;

function getcountryname_fr(s: shortstring): shortstring;
var
 i: integer;
begin
  getcountryname_fr:='';
  if length(s) > 2 then
    exit;
  s:=upstring(s);  
  for i:=1 to MAX_ENTRIES do
    begin
      if CountryInfo[i].code = s then
         begin
            getcountryname_fr:=CountryInfo[i].name_fr;
            exit;
         end;
    end;
end;

function getcountryname_en(s: shortstring): shortstring;
var
 i: integer;
begin
  getcountryname_en:='';
  if length(s) > 2 then
    exit;
  s:=upstring(s);  
  for i:=1 to MAX_ENTRIES do
    begin
      if CountryInfo[i].code = s then
         begin
            getcountryname_en:=CountryInfo[i].name_en;
            exit;
         end;
    end;
end;


end.
{
  $Log: not supported by cvs2svn $
  Revision 1.3  2006/08/23 00:50:40  carl
  * Small change in names

  Revision 1.2  2004/11/21 19:53:20  carl
    * speed optimizations

  Revision 1.1  2004/08/19 00:24:47  carl
    + iso3166 country code unit

}

