{ Unit to test some routines of dateutil }
unit testdate;

interface

procedure test_unit;

implementation

uses
{$IFDEF VPASCAL}
 use32,
{$ENDIF}
 fpautils,
 dpautils,
 vpautils,
 tpautils,
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
 {*********************** ISO 8601 compatible *************************}
  { Check all TryStrXXX ISO 8601 routines }
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
  if TryStrToDateTime('1500-06-05',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Year<>1500) or (Month<>06) or (Day<>05) then
    RunError(255);
  if (Hour<>0) or (Minute<>0) or (Second<>0) then
    RunError(255);
  if TryStrToDateTime('1400',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Year<>1400) or (Month<>01) or (Day<>01) then
    RunError(255);
  if (Hour<>0) or (Minute<>0) or (Second<>0) then
    RunError(255);
 {*********************** NON ISO 8601 compatible *************************}
 { Format: YYYY-MM-DD HH:mm:ss TZ                                          }
  if TryStrToDateTime('2000-01-01  23:45:45  UT',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>45) or (Second<>45) then
    RunError(255);
  if (Year<>2000) or (Month<>01) or (Day<>01) then
    RunError(255);
  if TryStrToTime('  23:45:45  UT',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>45) or (Second<>45) then
    RunError(255);
 { Format: YYYYMMDD;HHmmssuu (Openoffice)                              }
  if TryStrToDateTime(' 20000101;23454588  ',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>45) or (Second<>45) then
    RunError(255);
  if (Year<>2000) or (Month<>01) or (Day<>01) then
    RunError(255);
  if TryStrToTime('  23454599',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>45) or (Second<>45) then
    RunError(255);
 { Format:D:YYYYMMDDHHmmssOhh'mm' (Adobe PDF)                               }
  if TryStrToDateTime(' D:2004 ',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>0) or (Minute<>00) or (Second<>00) then
    RunError(255);
  if (Year<>2004) or (Month<>01) or (Day<>01) then
    RunError(255);
  {***}
  if TryStrToDateTime(' D:20040912235959 ',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>59) or (Second<>59) then
    RunError(255);
  if (Year<>2004) or (Month<>09) or (Day<>12) then
    RunError(255);
  if TryStrToDateTime(' D:20040912235959Z',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>59) or (Second<>59) then
    RunError(255);
  if (Year<>2004) or (Month<>09) or (Day<>12) then
    RunError(255);
  if TryStrToDateTime(' D:20040912235959-05''30''',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>18) or (Minute<>29) or (Second<>59) then
    RunError(255);
  if (Year<>2004) or (Month<>09) or (Day<>12) then
    RunError(255);
end;

{ Same as above, except timezone is also indicated }
procedure test_encodeext;
var
 Year,Month,Day: word;
 Hour,Minute,Second,MSecond: word;
 AValue: TDatetime;
 UTC: boolean;
begin
 {*********************** ISO 8601 compatible *************************}
  {**************************************************}
  if TryStrToDateTimeExt('1500-06-05T12:59:01+01:00',AValue,utc) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>13) or (Minute<>59) or (Second<>01) then
    RunError(255);
  if (Year<>1500) or (Month<>06) or (Day<>05) then
    RunError(255);
  if not UTC then
    RunError(255);
  if TryStrToDateTimeExt('1979-06-05T12:59:01Z',AValue,utc) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>12) or (Minute<>59) or (Second<>01) then
    RunError(255);
  if (Year<>1979) or (Month<>06) or (Day<>05) then
    RunError(255);
  if not UTC then
    RunError(255);
  if TryStrToDateTimeExt('1500-06-05',AValue,UTC) = false then
    RunError(255);
  if UTC then
     RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Year<>1500) or (Month<>06) or (Day<>05) then
    RunError(255);
  if (Hour<>0) or (Minute<>0) or (Second<>0) then
    RunError(255);
  if TryStrToDateTime('1400',AValue) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Year<>1400) or (Month<>01) or (Day<>01) then
    RunError(255);
  if (Hour<>0) or (Minute<>0) or (Second<>0) then
    RunError(255);
  if UTC then
    RunError(255);
 {*********************** NON ISO 8601 compatible *************************}
 { Format: YYYY-MM-DD HH:mm:ss TZ                                          }
  if TryStrToDateTimeExt('2000-01-01  23:45:45  UT',AValue,UTC) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>45) or (Second<>45) then
    RunError(255);
  if (Year<>2000) or (Month<>01) or (Day<>01) then
    RunError(255);
  if not UTC then
    RunError(255);
 { Format: YYYYMMDD;HHmmssuu (Openoffice)                              }
  if TryStrToDateTimeExt(' 20000101;23454588  ',AValue,UTC) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>45) or (Second<>45) then
    RunError(255);
  if (Year<>2000) or (Month<>01) or (Day<>01) then
    RunError(255);
  if UTC then
    RunError(255);
 { Format:D:YYYYMMDDHHmmssOhh'mm' (Adobe PDF)                               }
  if TryStrToDateTimeExt(' D:2004 ',AValue,UTC) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>0) or (Minute<>00) or (Second<>00) then
    RunError(255);
  if (Year<>2004) or (Month<>01) or (Day<>01) then
    RunError(255);
  if UTC then
    RunError(255);
  {***}
  if TryStrToDateTimeExt(' D:20040912235959 ',AValue,UTC) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>59) or (Second<>59) then
    RunError(255);
  if (Year<>2004) or (Month<>09) or (Day<>12) then
    RunError(255);
  if UTC then
    Runerror(255);
  if TryStrToDateTimeExt(' D:20040912235959Z',AValue,UTC) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>23) or (Minute<>59) or (Second<>59) then
    RunError(255);
  if (Year<>2004) or (Month<>09) or (Day<>12) then
    RunError(255);
  if not UTC then
    RunError(255);
  if TryStrToDateTimeExt(' D:20040912235959-05''30''',AValue,UTC) = false then
    RunError(255);
  DecodeDateTime(AValue,Year,Month,Day,Hour,Minute,Second,MSecond);
  if (Hour<>18) or (Minute<>29) or (Second<>59) then
    RunError(255);
  if (Year<>2004) or (Month<>09) or (Day<>12) then
    RunError(255);
  if not UTC then
    RunError(255);
end;


procedure test_unit;
var
 Year,Month,Day,DayOfWeek: integer;
 Hour,Minute,Second,Sec100: integer;
begin
  GetCurrentDate(Year,Month,Day,DayOfWeek);
  WriteLn(Year,'-',Month,'-',Day,' ',DayOfWeek);
  GetCurrentTime(Hour,Minute,Second,Sec100);
  WriteLn(Hour,':',Minute,':',Second,' ',Sec100);
  test_date;
  test_tryencode;
  test_validate;
  test_same;
  test_encode;
  test_encodeext;
end;

{
var
 s: string;
Begin
  s:=AdobeDateToISODate('D:2004');
  WriteLn(s);
  s:=AdobeDateToISODate('D:200401');
  WriteLn(s);
  s:=AdobeDateToIsoDate('D:20040304');
  WriteLn(s);
  s:=AdobeDateToIsoDate('D:2004030423');
  WriteLn(s);
  s:=AdobeDateToIsoDate('D:200403042359');
  WriteLn(s);
  s:=AdobeDateToIsoDate('D:20040304235900');
  WriteLn(s);
  s:=AdobeDateToIsoDate('D:20040304235900Z');
  WriteLn(s);
  s:=AdobeDateToIsoDate('D:20040304235900+00');
  WriteLn(s);
  s:=AdobeDateToIsoDate('D:20040304235900-02');
  WriteLn(s);
  s:=AdobeDateToIsoDate('D:20040304235900+00''12''');
  WriteLn(s);
end.
}

end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2004/11/02 12:16:16  carl
    * More testing for dateutil unit

  Revision 1.1  2004/09/29 00:56:53  carl
    + update to include dateutil testing

}
