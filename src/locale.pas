{
 ****************************************************************************
    $Id: locale.pas,v 1.8 2004-10-13 23:24:35 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Localization and date/time unit

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}

{** 
    @author(Carl Eric Codere)
    @abstract(Localisation unit)
    This unit is used to convert different 
    locale information. ISO Standards are
    used where appropriate.

    The exact representations that are supported
    are the following:
      Calendar Date: Complete Representation - basic
      Caldedar Date: Complete Representation - extended
      Calendar Date: Representations with reduced precision
      Time of the day: Local time of the day: Complete representation - basic
      Time of the day: Local time of the day: Complete representation - extended
      Time of the day: UTC Time : Complete representation - basic
      Time of the day: UTC Time: Complete representation - extended
      Time of the day: Local and UTC Time: extended format
    
    Credits where credits are due, information
    on the ISO and date formats where taken from
    http://www.cl.cam.ac.uk/~mgk25/iso-time.html
}
unit locale;


interface

uses
  dpautils,
  vpautils,
  fpautils,
  gpautils,
  tpautils;

{** Returns the extended format representation of a date as recommended
    by ISO 8601 (Gregorian Calendar).

    Returns an empty string if there is an error. The extended
    representation separates each member (year,month,day) with a dash
    character (-).

    @param(year Year of the date - valid values are from 0000 to 9999)
    @param(month Month of the date - valid values are from 0 to 12)
    @param(day Day of the month - valid values are from 1 to 31)
}
function GetISODateString(Year, Month, Day: Word): shortstring;

{** Returns the basic format representation of a date as recommended
    by ISO 8601 (Gregorian Calendar).

    Returns an empty string if there is an error.

    @param(year Year of the date - valid values are from 0000 to 9999)
    @param(month Month of the date - valid values are from 0 to 12)
    @param(day Day of the month - valid values are from 1 to 31)
}
function GetISODateStringBasic(Year, Month, Day: Word): shortstring;


{** @abstract(Verifies if the date is in a valid ISO 8601 format)

    @param(datestr Date string in valid ISO 8601 format)
    @returns(TRUE if the date string is valid otherwise false)
}
function IsValidISODateString(datestr: shortstring): boolean;

{** @abstract(Verifies if the time is in a valid ISO 8601 format)

    Currently does not support the fractional second parameters,
    and only the extemded time format recommended by W3C when used
    with the time zone designator.

    @param(timestr Time string in valid ISO 8601 format)
    @returns(TRUE if the time string is valid otherwise false)
}
function IsValidISOTimeString(timestr: shortstring): boolean;

{** @abstract(Verifies if the date and time is in a valid ISO 8601 format)

    Currently does not support the fractional second parameters,
    and only the format recommended by W3C when used with the
    time zone designator.

    @param(str Date-Time string in valid ISO 8601 format)
    @returns(TRUE if the date-time string is valid otherwise false)
}
function IsValidISODateTimeString(str: shortstring): boolean;

{** Returns the extended format representation of a time as recommended
    by ISO 8601 (Gregorian Calendar).

    Returns an empty string if there is an error. The extended
    representation separates each member (hour,minute,second) with a colon
    (:).
}
function GetISOTimeString(Hour, Minute, Second: Word; UTC: Boolean):
  shortstring;

{** Returns the basic format representation of a time as recommended
    by ISO 8601 (Gregorian Calendar).

    Returns an empty string if there is an error. The extended
    representation separates each member (hour,minute,second) with a colon
    (:).
}
function GetISOTimeStringBasic(Hour, Minute, Second: Word; UTC: Boolean):
  shortstring;


function GetISODateTimeString(Year, Month, Day, Hour, Minute, Second: Word; UTC:
  Boolean): shortstring;

{** Converts a UNIX styled time (the number of seconds since 1970)
    to a standard date and time representation.
}
procedure UNIXToDateTime(epoch: longword; var year, month, day, hour, minute, second:
  Word);

{** Using a registered ALIAS name for a specific character encoding,
    return the common or MIME name associated with this character set, 
    and indicate the type of stream format used. The type of stream 
    format used can be one of the @code(CHAR_ENCODING_XXXX) constants.
}
function GetCharEncoding(alias: string; var _name: string): integer;


const
  {** @abstract(Character encoding value: UTF-8 storage format)}
  CHAR_ENCODING_UTF8 = 0;
  {** @abstract(Character encoding value: unknown format)}
  CHAR_ENCODING_UNKNOWN = -1;
  {** @abstract(Character encoding value: UTF-32 Big endian)}
  CHAR_ENCODING_UTF32BE = 1;
  {** @abstract(Character encoding value: UTF-32 Little endian)}
  CHAR_ENCODING_UTF32LE = 2;
  {** @abstract(Character encoding value: UTF-16 Little endian)}
  CHAR_ENCODING_UTF16LE = 3;
  {** @abstract(Character encoding value: UTF-16 Big endian)}
  CHAR_ENCODING_UTF16BE = 4;
  {** @abstract(Character encoding value: One byte per character storage format)}
  CHAR_ENCODING_BYTE = 5;
  {** @abstract(Character encoding value: UTF-16 unknown endian (determined by BOM))}
  CHAR_ENCODING_UTF16 = 6;
  {** @abstract(Character encoding value: UTF-32 unknown endian (determined by BOM))}
  CHAR_ENCODING_UTF32 = 7;



implementation

uses utils;

{ IANA Registered character set table }
{$i charset.inc}
{ Character encodings }
{$i charenc.inc}

function fillwithzeros(s: shortstring; newlength: Integer): shortstring;
begin
  while length(s) < newlength do s:='0'+s;
  fillwithzeros:=s;
end;


function GetISODateString(Year,Month,Day:Word): shortstring;
var
  yearstr:string[4];
  monthstr: string[2];
  daystr: string[2];
begin
  GetISODateString := '';
  if year > 9999 then exit;
  if Month > 12 then exit;
  if day > 31 then exit;
  str(year,yearstr);
  str(month,monthstr);
  str(day,daystr);
  GetIsoDateString := fillwithzeros(yearstr,4)+'-'+ fillwithzeros(monthstr,2)+
    '-'+ fillwithzeros(daystr,2);
end;

function GetISODateStringBasic(Year,Month,Day:Word): shortstring;
var
  yearstr:string[4];
  monthstr: string[2];
  daystr: string[2];
begin
  GetISODateStringBasic := '';
  if year > 9999 then exit;
  if Month > 12 then exit;
  if day > 31 then exit;
  str(year,yearstr);
  str(month,monthstr);
  str(day,daystr);
  GetIsoDateStringBasic := fillwithzeros(yearstr,4)+ fillwithzeros(monthstr,2)
    + fillwithzeros(daystr,2);
end;

function GetISOTimeString(Hour,Minute,Second: Word; UTC: Boolean):
  shortstring;
var
  hourstr: string[2];
  minutestr: string[2];
  secstr: string[2];
  s: shortstring;
begin
  GetISOTimeString := '';
  if Hour > 23 then exit;
  if Minute > 59 then exit;
  if Second > 59 then exit;
  str(hour,hourstr);
  str(minute,minutestr);
  str(second,secstr);
  s := fillwithzeros(HourStr,2)+':'+ fillwithzeros(MinuteStr,2)+':'+
    fillwithzeros(SecStr,2);
  if UTC then s:=s+'Z';
  GetISOTimeString := s;
end;

function GetISOTimeStringBasic(Hour,Minute,Second: Word; UTC: Boolean):
  shortstring;
var
  hourstr: string[2];
  minutestr: string[2];
  secstr: string[2];
  s: shortstring;
begin
  GetISOTimeStringBasic := '';
  if Hour > 23 then exit;
  if Minute > 59 then exit;
  if Second > 59 then exit;
  str(hour,hourstr);
  str(minute,minutestr);
  str(second,secstr);
  s := fillwithzeros(HourStr,2)+ fillwithzeros(MinuteStr,2)+
    fillwithzeros(SecStr,2);
  if UTC then s:=s+'Z';
  GetISOTimeStringBasic := s;
end;


function GetISODateTimeString(Year,Month,Day,Hour,Minute,Second: Word; UTC:
  Boolean): shortstring;
var
  s1,s2: shortstring;
begin
  GetISODateTimeString:='';
  s1:=GetISODateString(year,month,day);
  if s1 = '' then exit;
  s2:=GetISOTimeString(Hour,Minute,Second,UTC);
  if s2 = '' then exit;
  GetISODatetimeString := s1 + 'T' + s2;
end;


const
{Date Calculation}
  C1970 = 2440588;
  D0 = 1461;
  D1 = 146097;
  D2 = 1721119;


procedure JulianToGregorian(JulianDN:Longint;var Year,Month,Day:Word);
var
  YYear,XYear,Temp,TempMonth : word;
begin
  Temp:=((JulianDN-D2) shl 2)-1;
  JulianDN:=Temp div D1;
  XYear:=(Temp mod D1) or 3;
  YYear:=(XYear div D0);
  Temp:=((((XYear mod D0)+4) shr 2)*5)-3;
  Day:=((Temp mod 153)+5) div 5;
  TempMonth:=Temp div 153;
  if TempMonth>=10 then
  begin
    inc(YYear);
    dec(TempMonth,12);
  end;
  inc(TempMonth,3);
  Month := TempMonth;
  Year:=YYear+(JulianDN*100);
end;



procedure UNIXToDateTime(epoch:longword;var year,month,day,hour,minute,second:
  Word);
{
  Transforms Epoch time into local time (hour, minute,seconds)
}
var
  DateNum: longword;
begin
  Datenum:=(Epoch div 86400) + c1970;
  JulianToGregorian(DateNum,Year,Month,day);
  Epoch:=longword(Abs(Epoch mod 86400));
  Hour:=Epoch div 3600;
  Epoch:=Epoch mod 3600;
  Minute:=Epoch div 60;
  Second:=Epoch mod 60;
end;


function isdigits(s: string):boolean;
var
 i: integer;
begin
 isdigits:=false;
 for I:=1 to length(s) do
   begin
     if not (s[i] in ['0'..'9']) then
        exit;
   end;
 isdigits:=true;
end;

function IsValidISODateString(datestr: shortstring): boolean;
const
 DATE_SEPARATOR = '-';
var
 monthstr: string[2];
 yearstr: string[4];
 daystr: string[2];
 yearval: integer;
 monthval: integer;
 dayval: integer;
 code: integer;
begin
  IsValidIsoDateString:=false;
  monthstr:='';
  yearstr:='';
  daystr:='';
  { search the possible cases }
  case length(datestr) of  
  { preferred format: YYYY-MM-DD }
  10:
      begin
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,6,2);
        daystr:=copy(datestr,9,2);
        if datestr[5] <> DATE_SEPARATOR then
           exit;
        if datestr[8] <> DATE_SEPARATOR then
           exit;
      end;
  { compact format: YYYYMMDD     }
   8:
      begin
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,5,2);
        daystr:=copy(datestr,7,2);
      end;
  { month format: YYYY-MM }
   7: 
      begin
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,6,2);
        if datestr[5] <> DATE_SEPARATOR then
           exit;
      end;
  { year format : YYYY }
   4:
      begin
        yearstr:=copy(datestr,1,4);
      end;
  else
     begin
        exit;
     end;
  end;   
  if yearstr = '' then
    exit;
  { verify the validity of the year }
  if yearstr <> '' then
    begin
      if not isdigits(yearstr) then
         exit;
      val(yearstr,yearval,code);
      if code <> 0 then 
        exit;
    end;  
  { verify the validity of the year }
  if monthstr <> '' then
    begin
      if not isdigits(monthstr) then
         exit;
      val(monthstr,monthval,code);
      if code <> 0 then 
        exit;
      if (monthval < 1) or (monthval > 12) then
        exit;
    end;  
  { verify the validity of the year }
  if daystr <> '' then
    begin
      if not isdigits(daystr) then
         exit;
      val(daystr,dayval,code);
      if code <> 0 then 
        exit;
      if (dayval < 1) or (dayval > 31) then
        exit;
    end;  
    
  IsValidIsoDateString:=true;
end;    


function IsValidISOTimeString(timestr: shortstring): boolean;
const
 TIME_SEPARATOR = ':';
var
 hourstr: string[2];
 secstr: string[2];
 minstr: string[2];
 offsetminstr: string[2];
 offsethourstr: string[2];
 offsetminval: integer;
 offsethourval: integer;
 minval: integer;
 secval: integer;
 hourval: integer;
 code: integer;
begin
  IsValidIsoTimeString:=false;
  minstr:='';
  secstr:='';
  hourstr:='';
  offsethourstr:='';
  offsetminstr:='';
  { search the possible cases }
  case length(timestr) of  
  { preferred format: hh:mm:ss }
  8,9,11,14:
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,4,2);
        secstr:=copy(timestr,7,2);
        if timestr[3] <> TIME_SEPARATOR then
           exit;
        if timestr[6] <> TIME_SEPARATOR then
           exit;
        { With Z TZD }   
        if length(timestr) = 9 then
          begin
            if timestr[length(timestr)] <> 'Z' then
              exit;
          end
        else
        if length(timestr) = 14 then
          begin
            if (timestr[9] in ['+','-']) and (timestr[12] = ':') then
              begin
                offsethourstr:=copy(timestr,10,2);
                offsetminstr:=copy(timestr,13,2);
              end
            else
              exit;
          end;
        if length(timestr) = 11 then
          begin
            if (timestr[9] in ['+','-']) and (timestr[12] = ':') then
              begin
                offsethourstr:=copy(timestr,10,2);
                offsetminstr:='00';
              end
            else
              exit;
          end;

      end;
  { compact format: hhmmss     }
   6,7:
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,3,2);
        secstr:=copy(timestr,5,2);
        { With Z TZD }   
        if length(timestr) = 7 then
          begin
            if timestr[length(timestr)] <> 'Z' then
              exit;
          end
      end;
  { hour/min format: hh:mm }
   5: 
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,4,2);
        if timestr[3] <> TIME_SEPARATOR then
           exit;
      end;
  { compact hour:min format hhmm }
   4:
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,3,2);
      end;
  else
     begin
        exit;
     end;
  end;   
  if hourstr = '' then
    exit;
  { verify the validity of the time }
  if minstr <> '' then
    begin
      if not isdigits(minstr) then
         exit;
      val(minstr,minval,code);
      if code <> 0 then 
        exit;
      if (minval < 0) or (minval > 59) then
        exit;
    end;  
  { verify the validity of the year }
  if offsetminstr <> '' then
    begin
      if not isdigits(offsetminstr) then
         exit;
      val(offsetminstr,offsetminval,code);
      if code <> 0 then 
        exit;
      if (offsetminval < 0) or (offsetminval > 59) then
        exit;
    end;  
  if offsethourstr <> '' then
    begin
      if not isdigits(offsethourstr) then
         exit;
      val(offsethourstr,offsethourval,code);
      if code <> 0 then 
        exit;
      if (offsethourval < 0) or (offsethourval > 23) then
        exit;
    end;  
    
  { verify the validity of the year }
  if secstr <> '' then
    begin
      if not isdigits(secstr) then
         exit;
      val(secstr,secval,code);
      if code <> 0 then
        exit;
      if (secval < 0) or (secval > 59) then
        exit;
    end;
  if hourstr <> '' then
    begin
      if not isdigits(hourstr) then
         exit;
      val(hourstr,hourval,code);
      if code <> 0 then
        exit;
      if (hourval < 0) or (hourval > 23) then
        exit;
    end;

  IsValidIsoTimeString:=true;
end;

function IsValidISODateTimeString(str: shortstring): boolean;
var
 idx:integer;
begin
  IsValidISODateTimeString:=false;
  idx:=pos('T',str);
  if IsValidISODateString(copy(str,1,idx-1)) then
    if IsValidISOTimeString(copy(str,idx+1,length(str))) then
     IsValidISODateTimeString:=true;
end;



function CompareString(s1,s2: shortstring): integer;
VAR I, J: integer; P1, P2: ^shortString;
  BEGIN
    P1 := @s1;                               { String 1 pointer }
    P2 := @s2;                               { String 2 pointer }
    If (Length(P1^)<Length(P2^)) Then 
      J := Length(P1^)
    Else 
      J := Length(P2^);                           { Shortest length }
    I := 1;                                            { First character }
    While (I<J) AND (P1^[I]=P2^[I]) Do 
      Inc(I);         { Scan till fail }
    If (I=J) Then 
      Begin                                { Possible match }
       If (P1^[I]<P2^[I]) Then 
        CompareString := -1 
       Else       { String1 < String2 }
       If (P1^[I]>P2^[I]) Then 
        CompareString := 1 
       Else      { String1 > String2 }
       If (Length(P1^)>Length(P2^)) Then 
        CompareString := 1 { String1 > String2 }
       Else 
       If (Length(P1^)<Length(P2^)) Then       { String1 < String2 }
        CompareString := -1 
       Else 
          CompareString := 0;           { String1 = String2 }
      End 
     Else 
     If (P1^[I]<P2^[I]) Then 
      CompareString := -1     { String1 < String2 }
     Else CompareString := 1;                               { String1 > String2 }
  END;

function GetCharEncoding(alias: string; var _name: string): integer;
  type
    tcharsets =  array[1..CHARSET_RECORDS] of charsetrecord;
    pcharsets = ^tcharsets;
  var
    L,H,C,I,j: integer;
    Search: boolean;
    Index: integer;
    char_sets: pcharsets;
{$ifdef tp}    
    p: pchar;
{$endif}    
  begin
    _name:='';
    alias:=upstring(alias);
    { Search for the appropriate name }
    GetCharEncoding:=CHAR_ENCODING_UNKNOWN;
    if alias = '' then exit;
    new(char_sets);
{$ifdef tp}
    p:=@charsetsproc;
    move(p^,char_sets^,sizeof(tcharsets));
{$else}    
    move(charsets,char_sets^,sizeof(tcharsets));
{$endif}
    Search:=false;
    { Search for the name }
    L := 1;                                            { Start count }
    H := CHARSET_RECORDS;                              { End count }
    While (L <= H) Do
      Begin
        I := (L + H) SHR 1;                            { Mid point }
        C := CompareString(char_sets^[I].setname, alias);   { Compare with key }
        If (C < 0) Then 
          L := I + 1 
        Else 
        Begin            { Item to left }
          H := I - 1;                                   { Item to right }
          If C = 0 Then 
            Begin                                       { Item match found }
              Search := True;                           { Result true }
            End;
        End;
      End;
    Index := L;                                        { Return result }
    { If the value has been found, then easy, nothing else to do }
    if Search then
      begin
        _name:=char_sets^[index].setname;
        getcharencoding:=charencoding[index].encoding;
        dispose(char_sets);
        exit;
      end;  
    { not found, then search for all aliases }
    for i:=1 to CHARSET_RECORDS do
      begin
        for j:=1 to CHARSET_MAX_ALIASES do
          begin
            if alias = char_sets^[i].aliases[j] then
              begin
                _name:=char_sets^[i].setname;
                getcharencoding:=charencoding[i].encoding;
                dispose(char_sets);
                exit;
              end
            else
            { no more entries, stop the loop }
            if char_sets^[i].aliases[j] = '' then
              break;
          end;
      end;
    dispose(char_sets);
  end;


end.

{
  $Log: not supported by cvs2svn $
  Revision 1.7  2004/09/29 00:57:46  carl
    + added dateutil unit
    + added more support for parsing different ISO time/date strings

  Revision 1.6  2004/08/19 00:18:52  carl
    - no ansistring support in this unit

  Revision 1.5  2004/07/05 02:26:39  carl
    - remove some compiler warnings

  Revision 1.4  2004/06/20 18:49:39  carl
    + added  GPC support

  Revision 1.3  2004/06/17 11:46:25  carl
    + GetCharEncoding

  Revision 1.2  2004/05/13 23:04:06  carl
    + routines to verify the validity of ISO date/time strings

  Revision 1.1  2004/05/05 16:28:20  carl
    Release 0.95 updates

}





