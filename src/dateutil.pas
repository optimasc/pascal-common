{
    $Id: dateutil.pas,v 1.1 2004-09-29 00:57:46 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere (Optima SC Inc.)

    Date and time utility routines

    See License.txt for more information on the licensing terms
    for this source code.

 **********************************************************************}
{** @author(Carl Eric Codere)
    @abstract(Date and time utility routines)

    This unit is quite similar to the unit dateutils provided
    with Delphi 6 and Delphi 7. Only a subset of the API found
    in those units is implemented in this unit.

    There are subtle differences with the Delphi implementation:
    1. All string related parameters and function results use ISO 8601
    formatted date and time strings. 
    2. The internal format of TDatetime is not the same as on the Delphi
    compilers.
    3. The milliseconds field is only an approximation, and should not
    be considered as accurate.

    All dates are assumed to be in Gregorian calendar date
    format (proleptic).

}
unit dateutil;

interface

uses
{$IFDEF VPASCAL}
 use32,
{$ENDIF}
 tpautils,
 dpautils,
 fpautils,
 vpautils
 ;

type
 {** This is the Julian Day number }
 TDatetime = extended;

 float = extended;


{ Provide symbolic constants for ISO 8601-compliant day of the week values. }
const
  DayMonday = 1;
  DayTuesday = 2;
  DayWednesday = 3;
  DayThursday = 4;
  DayFriday = 5;
  DaySaturday = 6;
  DaySunday = 7;

{** Returns the current year }
function CurrentYear: word;

{** Returns the current date, with the time value equal to midnight. }
function Date: TDatetime;

{** Strips the time portion from a TDateTime value.}
function DateOf(const AValue: TDateTime): TDateTime;

{** Converts a TDateTime value to a string in standard ISO 8601 format.}
function DateTimeToStr(DateTime: TDateTime): string; 

{** Converts a TDatetime value to a string in ISO 8601 format }
function DateToStr(date: TDatetime): string;

{** Returns the day of the month represented by a TDateTime value.}
function DayOf(const AValue: TDateTime): Word;

{** Returns the number of days between two specified TDateTime values.}
function DaysBetween(const ANow, AThen: TDateTime): integer;

{** Returns Year, Month, and Day values for a TDateTime value. }
procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word);

{** Returns Year, Month, Day, Hour, Minute, Second, and Millisecond values for a TDateTime. }
procedure DecodeDateTime(const AValue: TDateTime; var Year, Month, Day, Hour, Minute, Second, MilliSecond: Word);

{** Breaks a TDateTime value into hours, minutes, seconds, and milliseconds.}
procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word);

{** Returns the hour of the day represented by a TDateTime value.}
function HourOf(const AValue: TDateTime): Word;

{** Returns a date shifted by a specified number of days.}
function IncDay(const AValue: TDateTime; const ANumberOfDays: Integer): TDateTime;

{** Returns a date/time value shifted by a specified number of hours. }
function IncHour(const AValue: TDateTime; const ANumberOfHours: longint): TDateTime;

{** Returns a date/time value shifted by a specified number of milliseconds.}
function IncMilliSecond(const AValue: TDateTime; const ANumberOfMilliSeconds: big_integer_t): TDateTime;

{** Returns a date/time value shifted by a specified number of minutes. }
function IncMinute(const AValue: TDateTime; const ANumberOfMinutes: big_integer_t): TDateTime;

{** Returns a date/time value shifted by a specified number of seconds.}
function IncSecond(const AValue: TDateTime; const ANumberOfSeconds: big_integer_t): TDateTime;

{** Returns a date shifted by a specified number of weeks.}
function IncWeek(const AValue: TDateTime; const ANumberOfWeeks: Integer): TDateTime;

{**Indicates whether the time portion of a specified TDateTime value occurs after noon.}
function IsPM(const AValue: TDateTime): Boolean;

{** Indicates whether a specified year, month, and day represent a valid date. }
function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;

{** Indicates whether a specified year, month, day, hour, minute, second, and millisecond represent a valid date and time. }
function IsValidDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;

{** Indicates whether a specified hour, minute, second, and millisecond represent a valid date and time. }
function IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;


{** Returns the minute of the hour represented by a TDateTime value.}
function MinuteOf(const AValue: TDateTime): Word;

{** Returns the month of the year represented by a TDateTime value.}
function MonthOf(const AValue: TDateTime): Word;

{** Returns the current date and time.}
function Now: TDateTime;


{** Indicates whether two TDateTime values represent the same year, month, and day.}
function SameDate(const A, B: TDateTime): Boolean;

{** Indicates whether two TDateTime values represent the same year, month, day, hour, minute, second, and millisecond.}
function SameDateTime(const A, B: TDateTime): Boolean;

{** Indicates whether two TDateTime values represent the same time of day, ignoring the date portion.}
function SameTime(const A, B: TDateTime): Boolean;

{** Returns the second of the minute represented by a TDateTime value.}
function SecondOf(const AValue: TDateTime): Word;

{** Returns the current time.}
function Time: TDateTime;
{** Returns the current time.}
function GetTime: TDateTime;

{** Strips the date portion from a TDatetime value }
function TimeOf(const AValue: TDateTime): TDatetime;

{** Returns a string that represents a TDateTime value.}
function TimeToStr(Time: TDateTime): string;

{** Returns a TDateTime value that represents the current date. }
function Today: TDateTime;

{** Returns a TDateTime value that represents a specified Year, Month, and Day.}
function TryEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;

{** Returns a TDateTime value for a specified Hour, Min, Sec, and MSec. }
function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;

{** Returns a TDateTime that represents a specified year, month, day, hour, minute, second, and millisecond. }
function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
   var AValue: TDateTime): Boolean;

{** Converts a string to a TDateTime value, with a Boolean success code.}
function TryStrToDate(const S: string; var Value: TDateTime): Boolean;

{** Converts a string to a TDateTime value with a Boolean success code.

    The string should conform to the format of Complete Representation
    for calendar dates (as specified in ISO 8601), which should include
    the Time designator character.

    The string can also use Timezone offsets, as specified
    in ISO 8601, the returned value will be according to UTC
    if timezone information is specified.
}
function TryStrToDateTime(const S: string; var Value: TDateTime): Boolean;

{** Converts a string to a TDateTime value with an error default,
    The string can also use Timezone offsets, as specified
    in ISO 8601, the returned value will be according to UTC
    if timezone information is specified. The Date field is
    truncated and is equal to zero upon return.
}
function TryStrToTime(const S: string; var Value: TDateTime): Boolean;

{** Returns the year represented by a TDateTime value.}
function YearOf(const AValue: TDateTime): Word;


implementation

uses locale,dos;

{**************************************************************************}
{                          Local  routines                                 }
{**************************************************************************}

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


{** Convert a Gregorian calendar date to a Julian Day (JD) }

function datetojd(year,month,day,hour,minute,second,millisecond: word): float;
var
 a: float;
 rjd:float;
 j1: float;
 h: float;
 s: float;
begin
    h := hour + (minute / 60.0) + (second / 3600.0) + (millisecond / (3600.0*1000));
    rjd:= -1 * trunc(7 * (trunc((month + 9.0) / 12.0) + year) / 4.0);
    s:=1;
    if month - 9.0 < 0 then
      s:=-1;
    a:=abs(month -9.0);
    j1:= trunc((year + S * trunc(a / 7.0)));
    J1 := -1 * trunc((trunc(J1 / 100) + 1) * 3.0 / 4.0);
    rjd := rjd + trunc(275 * month / 9.0) + day + (1 * J1);
    rjd := rjd + 1721027.0 + 2.0 + 367.0 * year - 0.5;
    rjd := rjd + (h / 24.0);
    datetojd:=rjd;
end;
(*
begin

   extra := 100.0*year + month - 190002.5;
   rjd := 367.0*year;
   rjd := rjd - trunc(7.0*(year+trunc((month+9.0)/12.0))/4.0);
   rjd := rjd + trunc(275.0*month/9.0) ;
   rjd := rjd +  day;

   { add hours }
   rjd := rjd + hour / 24.0;
   { add minutes }
   rjd := rjd + minute/(60*24.0);
   { add seconds }
   rjd := rjd + second/(60*60*24.0);
   { add milliseconds }
   rjd := rjd + millisecond/(60*60*24.0*1000);

   rjd := rjd + 1721013.5;
   rjd := rjd - 0.5*extra/abs(extra);
   rjd := rjd + 0.5;


   datetojd:=rjd;
end;*)


{** Convert a Julian Day (JD) to a Gregorial calendar date }
procedure jdtodate (jday : float; var
  year,month,day,hour,minute,second,msec: word);
{takes a Julian Day "jday" and converts to local date & time according
to the time zone "tzone" specified.  "jday" can have values from 0 up to
several million, and a fractional part, so it has to be Extended type.
"tzone" is NOT an Integer because some of us are afflicted with strange
time zones!  The use of "Trunc" may occasionally cause an error of one
minute in the returned time.

A test value : JD 2450450.0000 = 1997 Jan 01 12:00 UT }
var
 Z,F,A,B,D,I,RJ,RH: float;
 C,T: longint;
 Y: integer;
begin
   Z := trunc(JDay+0.5);
   F := JDay+0.5 - Z;
{   if (Z < 2299161) then
      A := Z
   else}
   begin
     I := trunc((Z - 1867216.25)/36524.25);
     A := Z + 1 + I - trunc(I/4);
   end;
   B := A + 1524;
   C := trunc((B - 122.1)/365.25);
   D := trunc(365.25 * C);
   T := trunc((B - D)/ 30.600);
   RJ := B - D - trunc(30.6001 * T) + F;
   Day := trunc(RJ);
   RH := (RJ - trunc(RJ)) * 24;
   Hour:=trunc(RH);
   Minute := trunc((RH - Hour )*60);
   Second := round(((RH - Hour )*60.0 - Minute )*60.0);
   Msec:=0;
   if (T < 14) then
      Month := T - 1
   else
     begin
      if ((T = 14) or (T = 15)) then
        Month := T - 13;
     end;
   if (Month > 2) then
      Y := longint(C) - 4716
   else
      Y := longint(C) - 4715;
   if Y < 0 then
     Year:=0
   else
     Year:=Y;
end;
(*
var
    jd,alpha,a,b,c,d,e      : longint;
    tzone: float;
    jdf: float;

    { The value can be negative! }
    ayear: integer;
begin
  tzone:=0;
  if jday > 0 then       {Julian Day <= 0 is meaningless}
    begin
      {add the time zone to the Julian Day, and reset to UT midnight}
      jday:=jday+0.5+tzone/24;
      {cut out the whole and fractional parts}
      jd:=trunc(jday);
      jdf:=frac(jday);

      alpha:=trunc((jd-1867216.25)/36524.25);
      a:=jd+1+alpha-trunc(alpha/4);  {leap year correction}
      b:=a+1524;
      c:=trunc((b-122.1)/365.25);
      d:=trunc(365.25*c);
      e:=trunc((b-d)/30.6001);

      {extract the year month & day}
      day:=b-d-trunc(30.6001*e);
      if e<14 then month:=e-1 else month:=e-13;
      if month>2 then
        ayear:=c-4716
      else
        ayear:=c-4715;

      {extract hours and minutes from the julian day fraction}
      hour:=trunc(24*jdf);
      minute:=trunc(frac(24*jdf)*60);
      second:=trunc(frac(1440.0*jdf)*60);
      { we must round, since we seem to loose some precision here! }
      msec:=trunc(frac(24*jdf*60*60)*1000);
      if msec > 500 then
      begin
        msec:=0;
        inc(second);
      end;

      { The dateutil API only supports years AD }
      if ayear < 0 then
        year:=0
      else
        year:=ayear;
  end;
end;*)

{ Parse an ISO 8601 time string }
function parsetime(const timestr: string; var hourval,minval, secval: word;
  var offsethourval,offsetminval:integer): boolean;
const
 TIME_SEPARATOR = ':';
var
 hourstr: string[2];
 secstr: string[2];
 minstr: string[2];
 offsetminstr: string[2];
 offsethourstr: string[2];
 code: integer;
 negative: boolean;
begin
  ParseTime:=false;
  negative:=false;
  minstr:='';
  secstr:='';
  hourstr:='';
  offsethourstr:='00';
  offsetminstr:='00';
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
            if (timestr[9] in ['+','-']) then
              begin
                negative:=(timestr[9] = '-');
                offsethourstr:=copy(timestr,10,2);
                offsetminstr:=copy(timestr,13,2);
              end
            else
              exit;
          end;
        if length(timestr) = 11 then
          begin
            if (timestr[9] in ['+','-'])  then
              begin
                negative:=(timestr[9] = '-');
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
    end;
  if hourstr <> '' then
    begin
      if not isdigits(hourstr) then
         exit;
      val(hourstr,hourval,code);
      if code <> 0 then
        exit;
    end;
  { Now add any timezone offset }
  if negative then
    begin
      offsethourval:=-offsethourval;
      offsetminval:=-offsetminval;
    end;
  { Now check the validity of the time value }
  if Not IsValidTime(hourval,minval,secval,0) then
     exit;
  ParseTime:=true;
end;

{ Parse an ISO 8601 string date }
function parsedate(const datestr:string; var yearval,
 monthval,dayval: word): boolean;
const
 DATE_SEPARATOR = '-';
var
 monthstr: string[2];
 yearstr: string[4];
 daystr: string[2];
 code: integer;
begin
  ParseDate:=false;
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
    end;
  { verify the validity of the year }
  if daystr <> '' then
    begin
      if not isdigits(daystr) then
         exit;
      val(daystr,dayval,code);
      if code <> 0 then
        exit;
    end;
  { Now check if the values are valid }
  if not IsValidDate(YearVal,MonthVal,DayVal) then
    { nope, exit }
    exit;
  ParseDate:=true;
end;


{**************************************************************************}
function CurrentYear: word;
var
 Year,Month,Day,DayOfWeek: word;
begin
  Dos.GetDate(Year,Month,Day,DayOfWeek);
  CurrentYear:=Year;
end;

function Date: TDatetime;
var
 Year,Month,Day,DayOfWeek: word;
begin
  Dos.GetDate(Year,Month,Day,DayOfWeek);
  Date:=datetojd(Year,Month,Day,0,0,0,0);
end;

function DateOf(const AValue: TDateTime): TDateTime;
begin
  DateOf:=Round(AValue);
end;


function DateTimeToStr(DateTime: TDateTime): string; 
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (DateTime,year,month,day,hour,minute,second,msec);
  DateTimeToStr:=GetISODateTimeString(Year, Month, Day, Hour,
    Minute, Second, false);
end;

function DateToStr(date: TDatetime): string;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (Date,year,month,day,hour,minute,second,msec);
  DateToStr:=GetISODateString(Year, Month, Day);
end;

function DayOf(const AValue: TDateTime): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  DayOf:=Day;
end;

function DaysBetween(const ANow, AThen: TDateTime): integer;
begin
  DaysBetween:=abs(Trunc(Anow)-Trunc(AThen));
end;

procedure DecodeDate(Date: TDateTime; var Year, Month, Day: Word);
var
 hour,minute,second,msec: word;
begin
  jdtodate (Date,year,month,day,hour,minute,second,msec);
end;

procedure DecodeDateTime(const AValue: TDateTime; var Year, Month, Day, Hour, Minute, Second, MilliSecond: Word);
begin
  jdtodate (AValue,year,month,day,hour,minute,second,millisecond);
end;

procedure DecodeTime(Time: TDateTime; var Hour, Min, Sec, MSec: Word);
var
 year,month,day: word;
begin
  msec:=0;
  jdtodate (Time,year,month,day,hour,min,sec,msec);
end;

function HourOf(const AValue: TDateTime): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  HourOf:=Hour;
end;


function IncDay(const AValue: TDateTime; const ANumberOfDays: Integer): TDateTime;
begin
  IncDay:=AValue + ANumberOfDays;
end;

function IncHour(const AValue: TDateTime; const ANumberOfHours: longint): TDateTime;
begin
  IncHour:=AValue + (ANumberOfHours / 24.0);
end;

function IncMilliSecond(const AValue: TDateTime; const ANumberOfMilliSeconds: big_integer_t): TDateTime;
begin
  IncMillisecond:= AValue+(ANumberOfMilliSeconds / 24.0) / (60.0*60.0*1000.0);
end;

function IncMinute(const AValue: TDateTime; const ANumberOfMinutes: big_integer_t): TDateTime;
begin
 IncMinute:= AValue + (ANumberOfMinutes / 24.0) / 60.0;
end;


function IncSecond(const AValue: TDateTime; const ANumberOfSeconds: big_integer_t): TDateTime;
begin
  IncSecond:= AValue + (ANumberOfSeconds / 24.0) / (60.0*60.0);
end;

function IncWeek(const AValue: TDateTime; const ANumberOfWeeks: Integer): TDateTime;
begin
  IncWeek:= AValue + ANumberOfWeeks*7;
end;

function IsPM(const AValue: TDateTime): Boolean;
var
 d: TDatetime;
begin
 d:=frac(Avalue);
 if d >= 0.5 then
   IsPM:=false
 else
   IsPM:=true;
end;

function IsValidDate(const AYear, AMonth, ADay: Word): Boolean;
begin
  IsValidDate:=false;
  if (Amonth > 12) or (Amonth = 0) then
     exit;
  if (ADay > 31) or (ADay = 0) then
     exit;
  { We don't check the AYear value because we assume
    the user knows that this value is in the Gregorian calendar
  }
  IsValidDate:=true;
end;

function IsValidDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
begin
  IsValidDatetime:=true;
  if IsValidDate(AYear,Amonth,ADay) and
     IsValidTime(AHour,AMinute,ASecond,Amillisecond) then
    begin
      exit;
    end;
  IsValidDateTime:=false;
end;

function IsValidTime(const AHour, AMinute, ASecond, AMilliSecond: Word): Boolean;
begin
  IsValidTime:=false;
  if (AHour > 24) then
    exit;
  if (AMinute > 59) then
    exit;
  { 60 is possible with leap seconds! }
  if (ASecond > 60) then
    exit;
  If (AMillisecond > 999) then
    exit;
  IsValidTime:=true;
end;

function MinuteOf(const AValue: TDateTime): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  MinuteOf:=Minute;
end;

function MonthOf(const AValue: TDateTime): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  MonthOf:=Month;
end;


function Now: TDatetime;
var
 Year,Month,Day,DayOfWeek: word;
 Hour,Minute,Sec,Sec100: word;
begin
  Dos.GetDate(Year,Month,Day,DayOfWeek);
  Dos.GetTime(Hour,Minute,Sec,Sec100);
  Now:=datetojd(Year,Month,Day,Hour,Minute,Sec,Sec100);
end;

function SameDate(const A, B: TDateTime): Boolean;
begin
  if trunc(A) = trunc(B) then
    SameDate:=true
  else
    SameDate:=false;
end;

function SameDateTime(const A, B: TDateTime): Boolean;
begin
  SameDateTime:=true;
  if A-B=0 then
    exit;
  SameDateTime:=false;
end;


function SameTime(const A, B: TDateTime): Boolean;
begin
  if (abs(frac(A))-abs(frac(B))) = 0 then
    SameTime:=true
  else
    SameTime:=false;
end;

function SecondOf(const AValue: TDateTime): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  SecondOf:=Second;
end;

function Time: TDateTime;
var
  Hour,Minute,Second,Sec100: word;
begin
  Dos.GetTime(Hour,Minute,Second,Sec100);
  Time:=datetojd(0,0,0,Hour,Minute,Second,Sec100);
end;

function GetTime: TDateTime;
begin
  GetTime:=Time;
end;

function TimeOf(const AValue: TDateTime): TDatetime;
begin
  TimeOf:=frac(AValue);
end;


function TimeToStr(Time: TDateTime): string;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (Time,year,month,day,hour,minute,second,msec);
  TimeToStr:=GetISOTimeString(Hour,Minute, Second, false);
end;

function Today: TDatetime;
var
 Year,Month,Day,DayOfWeek: word;
begin
  Dos.GetDate(Year,Month,Day,DayOfWeek);
  Today:=trunc(datetojd(Year,Month,Day,0,0,0,0));
end;


function TryEncodeDate(Year, Month, Day: Word; var Date: TDateTime): Boolean;
begin
  TryEncodeDate:=false;
  if IsValidDate(Year,Month,Day) then
    begin
      Date:=datetojd(year,month,day,0,0,0,0);
      TryEncodeDate:=true;
      exit;
    end;
end;

function TryEncodeTime(Hour, Min, Sec, MSec: Word; var Time: TDateTime): Boolean;
begin
  TryEncodeTime:=false;
  if IsValidTime(Hour,Min,Sec,Msec) then
    begin
      Time:=datetojd(0,0,0,Hour,Min,Sec,MSec);
      TryEncodeTime:=true;
      exit;
    end;
end;

function TryEncodeDateTime(const AYear, AMonth, ADay, AHour, AMinute, ASecond, AMilliSecond: Word;
   var AValue: TDateTime): Boolean;
begin
  TryEncodeDateTime:=false;
  if IsValidTime(AHour,AMinute,ASecond,AMillisecond) and IsValidDate(AYear,AMonth,ADay) then
    begin
      AValue:=datetojd(AYear,AMonth,ADay,AHour,AMinute,ASecond,AMillisecond);
      TryEncodeDateTime:=true;
      exit;
    end;
end;


function TryStrToDate(const S: string; var Value: TDateTime): Boolean;
var
  yearval,monthval,dayval: word;
begin
  TryStrToDate:=false;
  if not parsedate(s,yearval,monthval,dayval) then
    exit;
  { Now convert to a Julian Day }
  Value:=datetojd(Yearval,Monthval,Dayval,0,0,0,0);
  trystrtodate:=true;
end;






function TryStrToDateTime(const S: string; var Value: TDateTime): Boolean;
var
 idx: integer;
 minval,
 secval,
 hourval:word;
 offsetminval,
 offsethourval: integer;
 datestring,timestring: string;
 yearval,monthval,dayval: word;
 MSecVal: word;
begin
  TryStrToDateTime:=false;
  MSecVal:=0;
  idx:=pos('T',s);
  datestring:=copy(s,1,idx-1);
  timestring:=copy(s,idx+1,length(s));
  if not parsetime(timestring,hourval,minval,secval,offsethourval,offsetminval) then
    exit;
  if not parsedate(datestring,yearval,monthval,dayval) then
    exit;
  Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);
  { Convert to UTC }
  Value:=IncHour(Value,offsethourval);
  Value:=IncMinute(Value,offsetminval);
  TryStrToDatetime:=true;
end;


function TryStrToTime(const S: string; var Value: TDateTime): Boolean;
var
    minval,
    secval,
    hourval:word;
    msecval:word;
    offsetminval,
    offsethourval: integer;
begin
  TryStrToTime:=false;
  MSecVal:=0;
  if not ParseTime(s,hourval,minval,secval,offsethourval,offsetminval) then
    exit;
  { Now convert it }
  Value:=datetojd(0,0,0,HourVal,MinVal,SecVal,MSecVal);
  Value:=IncHour(Value,offsethourval);
  Value:=IncMinute(Value,offsetminval);
  { Now strip the Date value, if it has increased }
  Value:=frac(Value);
  TryStrToTime:=true;
end;



function YearOf(const AValue: TDateTime): Word;
var
 year,month,day,hour,minute,second,msec: word;
begin
  jdtodate (AValue,year,month,day,hour,minute,second,msec);
  YearOf:=Year;
end;


end.
{
  $Log: not supported by cvs2svn $
}
