{
 ****************************************************************************
    $Id: locale.pas,v 1.2 2004-05-13 23:04:06 carl Exp $
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

{** @abstract(Verifies if the date is in a valid ISO 8601 format)

    @param(datestr Date string in valid ISO 8601 format)
    @returns(TRUE if the date string is valid otherwise false)
}
function IsValidISODateString(datestr: shortstring): boolean;

{** @abstract(Verifies if the time is in a valid ISO 8601 format)

    Currently does not support the fractional second parameters,
    and only the format recommended by W3C when used with the
    time zone designator.

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
  8,9,14:
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
  { verify the validity of the year }
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


end.

{
  $Log: not supported by cvs2svn $
  Revision 1.1  2004/05/05 16:28:20  carl
    Release 0.95 updates

}





