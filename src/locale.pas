{
 ****************************************************************************
    $Id: locale.pas,v 1.1 2004-05-05 16:28:20 carl Exp $
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
  tpautils;


{** Returns the preferred date string as recommended
    by ISO 8601 (Gregorian Calendar). 
    
    Returns an empty string if there is an error.
    
    @param(year Year of the date - valid values are from 0000 to 9999)
    @param(month Month of the date - valid values are from 0 to 12)
    @param(day Day of the month - valid values are from 1 to 31)
}
function GetISODateString(Year, Month, Day: Word): shortstring;


{** Returns the preferred time string as recommended
    by ISO 8601 (Gregorian Calendar). 
    
    @Returns(Empty string if there is an error).
}
function GetISOTimeString(Hour, Minute, Second: Word; UTC: Boolean):
  shortstring;

function GetISODateTimeString(Year, Month, Day, Hour, Minute, Second: Word; UTC:
  Boolean): shortstring;

{** Converts a UNIX styled time (the number of seconds since 1970) 
    to a standard date and time representation.
}
procedure UNIXToDateTime(epoch: longword; var year, month, day, hour, minute, second:
  Word);




implementation


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
  Epoch:=Abs(Epoch mod 86400);
  Hour:=Epoch div 3600;
  Epoch:=Epoch mod 3600;
  Minute:=Epoch div 60;
  Second:=Epoch mod 60;
end;


end.

{
  $Log: not supported by cvs2svn $
}





