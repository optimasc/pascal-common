{ Unit to test some routines of dateutil }
unit testdate;

interface

procedure test_unit;

implementation

uses
{$IFDEF VPASCAL}
 use32,
{$ENDIF}
 dateutil;


procedure test_date;
var
 d: TDatetime;
 Hour,Minute,Second,Year,Month,Day,Msec: word;
begin
  { Testing Date }
  d:=Date;
  { Should always be valid since it is returned by the operating system }
  DecodeDate(d,Year,Month,Day);
  DecodeTime(d,Hour,Minute,Second,Msec);
  if not IsValidDate(Year,Month,Day) then
    RunError(255);
  { Verify that the value is actually midnight }
  if (Hour <> 24) and (Hour <> 0) then
     RunError(255);
  if not IsValidTime(Hour,Minute,Second,MSec) then
    RunError(255);
  WriteLn(DateToStr(d));
  WriteLn(DateTimeToStr(d));
end;

procedure test_tryencode;
var
 Year,Month,Day: word;
 Hour,Minute,Second,MSecond: word;
 AValue: TDateTime;
 DateValue:TDateTime;
 TimeValue:TDatetime;
 AYear,AMonth,ADay: word;
 AHour,AMinute,ASecond,AMSecond: word;
 s: string;
begin
 { First try : 1997-01-01T22:34:54 }
 Year:=1997;
 Month:=01;
 Day:=01;
 Hour:=22;
 Minute:=34;
 Second:=54;
 MSecond:=200;
 if TryEncodeDateTime(Year,Month,Day,Hour,Minute,Second,MSecond,AValue)=false then
   RunError(255);
 if not IsPM(AValue) then
   RunError(255);
 DateValue:=DateOf(AValue);
 s:=DateToStr(DateValue);
 if s<>'1997-01-01' then
   RunError(255);
 TimeValue:=TimeOf(AValue);
 s:=TimeToStr(TimeValue);
 if s<>'22:34:54' then
   RunError(255);
 s:=DateTimeToStr(AValue);
 if s<>'1997-01-01T22:34:54' then
   RunError(255);
 DecodeDateTime(AValue,AYear,AMonth,ADay,AHour,AMinute,ASecond,AMSecond);
 if Year <> AYear then
   RunError(255);
 if Month <> AMonth then
   RunError(255);
 if Day <> ADay then
   RunError(255);
 if Ahour <> Hour then
   RunError(255);
 if Minute<>AMinute then
   RunError(255);
 if Second<>ASecond then
   RunError(255);
{ if MSecond<>AMSecond then
   RunError(255);}
 AYear:=0;
 AMonth:=0;
 ADay:=0;
 AHour:=0;
 Aminute:=0;
 ASecond:=0;
 AMSecond:=0;
 DecodeDate(AValue,AYear,AMonth,ADay);
 DecodeTime(AValue,AHour,Aminute,ASecond,AMSecond);
 if Year <> AYear then
   RunError(255);
 if Month <> AMonth then
   RunError(255);
 if Day <> ADay then
   RunError(255);
 if Ahour <> Hour then
   RunError(255);
 if Minute<>AMinute then
   RunError(255);
 if Second<>ASecond then
   RunError(255);
 { First try : 2004-01-01T08:34:54 }
 Year:=2004;
 Month:=01;
 Day:=01;
 Hour:=08;
 Minute:=34;
 Second:=54;
 MSecond:=200;
 if TryEncodeDateTime(Year,Month,Day,Hour,Minute,Second,MSecond,AValue)=false then
   RunError(255);
 if IsPM(AValue) then
   RunError(255);
 DateValue:=DateOf(AValue);
 s:=DateToStr(DateValue);
 if s<>'2004-01-01' then
   RunError(255);
 TimeValue:=TimeOf(AValue);
 s:=TimeToStr(TimeValue);
 if s<>'08:34:54' then
   RunError(255);
 s:=DateTimeToStr(AValue);
 if s<>'2004-01-01T08:34:54' then
   RunError(255);
 DecodeDateTime(AValue,AYear,AMonth,ADay,AHour,AMinute,ASecond,AMSecond);
 if Year <> AYear then
   RunError(255);
 if Month <> AMonth then
   RunError(255);
 if Day <> ADay then
   RunError(255);
 if Ahour <> Hour then
   RunError(255);
 if Minute<>AMinute then
   RunError(255);
 if Second<>ASecond then
   RunError(255);
{ if MSecond<>AMSecond then
   RunError(255);}
 AYear:=0;
 AMonth:=0;
 ADay:=0;
 AHour:=0;
 Aminute:=0;
 ASecond:=0;
 AMSecond:=0;
 DecodeDate(AValue,AYear,AMonth,ADay);
 DecodeTime(AValue,AHour,Aminute,ASecond,AMSecond);
 if Year <> AYear then
   RunError(255);
 if Month <> AMonth then
   RunError(255);
 if Day <> ADay then
   RunError(255);
 if Ahour <> Hour then
   RunError(255);
 if Minute<>AMinute then
   RunError(255);
 if Second<>ASecond then
   RunError(255);
end;

procedure test_validate;
var
 Year,Month,Day: word;
 Hour,Minute,Second,MSecond: word;
begin
 Year:=2004;
 Month:=01;
 Day:=01;
 Hour:=08;
 Minute:=34;
 Second:=54;
 MSecond:=200;
 if not IsValidDateTime(Year,Month,Day,Hour,Minute,Second,MSecond) then
   RunError(255);
 if not IsValidtime(Hour,Minute,Second,MSecond) then
   RunError(255);
 if not IsValidDate(Year,Month,Day) then
   RunError(255);
 Year:=2004;
 Month:=14;
 Day:=01;
 Hour:=08;
 Minute:=90;
 Second:=54;
 MSecond:=200;
 if IsValidDateTime(Year,Month,Day,Hour,Minute,Second,MSecond) then
   RunError(255);
 if IsValidtime(Hour,Minute,Second,MSecond) then
   RunError(255);
 if IsValidDate(Year,Month,Day) then
   RunError(255);
end;

procedure test_same;
var
 Year,Month,Day: word;
 Hour,Minute,Second,MSecond: word;
 AValueA: TDatetime;
 AValueB: TDatetime;
begin
 Year:=0;
 Month:=06;
 Day:=01;
 Hour:=23;
 Minute:=59;
 Second:=54;
 MSecond:=200;
 TryEncodeDatetime(Year,Month,Day,Hour,Minute,Second,MSecond,AValueA);
 Year:=0;
 Month:=06;
 Day:=01;
 Hour:=23;
 Minute:=59;
 Second:=54;
 MSecond:=200;
 TryEncodeDateTime(Year,Month,Day,Hour,Minute,Second,MSecond,AValueB);
 if not SameTime(AValueA,AValueB) then
   RunError(255);
 if not SameDate(AValueA,AValueB) then
   Runerror(255);
 if not SameDateTime(AValueA,AValueB) then
   RunError(255);
 Year:=0;
 Month:=06;
 Day:=01;
 Hour:=23;
 Minute:=59;
 Second:=55;
 MSecond:=200;
 TryEncodeDateTime(Year,Month,Day,Hour,Minute,Second,MSecond,AValueB);
 if SameTime(AValueA,AValueB) then
   RunError(255);
 if not SameDate(AValueA,AValueB) then
   Runerror(255);
 if SameDateTime(AValueA,AValueB) then
   RunError(255);
end;

procedure test_encode;
var
 Year,Month,Day: word;
 Hour,Minute,Second,MSecond: word;
 AValue: TDatetime;
begin
  { Check all TryStrXXX routines }
  {**************************************************}
  if TryStrToDate('0001-01-01',AValue) = false then
    RunError(255);
  DecodeDate(AValue,Year,Month,Day);
  if (Year<>0001) or (Month<>01) or (Day<>01) then
    RunError(255);
  { Invalid dates }
  if TryStrToDate('10000-01-01',AValue) = true then
    RunError(255);
  if TryStrToDate('1000-13-01',AValue) = true then
    RunError(255);
  if TryStrToDate('1000-12-35',AValue) = true then
    RunError(255);
  {**************************************************}
  if TryStrToTime('12:59:01',AValue) = false then
    RunError(255);
  DecodeTime(AValue,Hour,Minute,Second,MSecond);
  if (Hour<>12) or (Minute<>59) or (Second<>01) then
    RunError(255);
  if TryStrToTime('125901',AValue) = false then
    RunError(255);
  DecodeTime(AValue,Hour,Minute,Second,MSecond);
  if (Hour<>12) or (Minute<>59) or (Second<>01) then
    RunError(255);
  if TryStrToTime('12:59:01Z',AValue) = false then
    RunError(255);
  DecodeTime(AValue,Hour,Minute,Second,MSecond);
  if (Hour<>12) or (Minute<>59) or (Second<>01) then
    RunError(255);
  if TryStrToTime('235901Z',AValue) = false then
    RunError(255);
  DecodeTime(AValue,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>59) or (Second<>01) then
    RunError(255);
  { With UTC offset }
  if TryStrToTime('23:59:01+02:00',AValue) = false then
    RunError(255);
  DecodeTime(AValue,Hour,Minute,Second,MSecond);
  if (Hour<>01) or (Minute<>59) or (Second<>01) then
    RunError(255);
  if TryStrToTime('23:59:01-02:30',AValue) = false then
    RunError(255);
  DecodeTime(AValue,Hour,Minute,Second,MSecond);
  if (Hour<>21) or (Minute<>29) or (Second<>01) then
    RunError(255);
  { Invalid times }
  if TryStrToTime('05:05:05+99',AValue) = true then
    RunError(255);
  if TryStrToTime('05:99',AValue) = true then
    RunError(255);
  if TryStrToTime('22:99:34',AValue) = true then
    RunError(255);
  if TryStrToTime('12:59:99Z',AValue) = true then
    RunError(255);
  {**************************************************}
  if TryStrToDateTime('1500-06-05T12:59:01+01:00',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>13) or (Minute<>59) or (Second<>01) then
    RunError(255);
  if (Year<>1500) or (Month<>06) or (Day<>05) then
    RunError(255);
end;

procedure test_unit;
begin
  test_date;
  test_tryencode;
  test_validate;
  test_same;
  test_encode;
end;

end.

{
  $Log: not supported by cvs2svn $
}
