{ See documentation in header file }
function TryStrToDateTimeExt(const S: string; var Value: TJulianDateTime; var UTC: boolean) : Boolean;
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
 error: boolean;
 outs: string;
 s1: string;
begin
  error:=false;
  TryStrToDateTimeExt:=false;
  MSecVal:=0;
  utc:=false;
  Value:=0;
  { Check for complete ISO 8601 string }
  idx:=pos('T',s);
  if idx <> 0 then
    begin
      datestring:=copy(s,1,idx-1);
      timestring:=copy(s,idx+1,length(s));
      if not parsetimeISO(timestring,hourval,minval,secval,offsethourval,offsetminval,UTC) then
         error:=true;
      if not parsedateISO(datestring,yearval,monthval,dayval) then
         error:=true;
      if IsValidDateTime(YearVal,MonthVal,DayVal,HourVal,Minval,SecVal,MSecVal) then
        begin
          Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);

         { Convert to UTC if required }
         if (offsethourval <> 0) or (offsetminval <> 0) then
           utc:=true;
         Value:=IncHour(Value,offsethourval);
         Value:=IncMinute(Value,offsetminval);
        end;
         if not error then
           begin
             TryStrToDatetimeExt:=true;
             exit;
        end;
    end;
  { Check for non-standard string with space that separates the date
    and time.
  }
  { Reset error, we are trying a new parsing method }
  utc:=false;
  error:=false;
  outs:=trim(s);
  idx:=pos(' ',outs);
  if idx <> 0 then
    begin
      datestring:=copy(outs,1,idx-1);
      timestring:=copy(outs,idx+1,length(outs));
      timestring:=converttoisotime(timestring);
      if not parsetimeISO(timestring,hourval,minval,secval,offsethourval,offsetminval,utc) then
         error:=true;
      if not parsedateISO(datestring,yearval,monthval,dayval) then
         error:=true;
      if IsValidDateTime(YearVal,MonthVal,DayVal,HourVal,Minval,SecVal,MSecVal) then
        begin

          Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);
          { Convert to UTC if required }
          if (offsethourval <> 0) or (offsetminval <> 0) then
             utc:=true;
          Value:=IncHour(Value,offsethourval);
          Value:=IncMinute(Value,offsetminval);
          if not error then
            begin
             TryStrToDatetimeExt:=true;
             exit;
            end;
        end;
    end;
  { Openoffice HTML output date/time format }
  utc:=false;
  error:=false;
  idx:=pos(';',outs);
  if idx <> 0 then
    begin
      datestring:=copy(outs,1,idx-1);
      timestring:=copy(outs,idx+1,length(outs));
      timestring:=converttoisotime(timestring);
      if not parsetimeISO(timestring,hourval,minval,secval,offsethourval,offsetminval,utc) then
         error:=true;
      if not parsedateISO(datestring,yearval,monthval,dayval) then
         error:=true;
      if IsValidDateTime(YearVal,MonthVal,DayVal,HourVal,Minval,SecVal,MSecVal) then
        begin
          Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);
          { Convert to UTC if required }
          if (offsethourval <> 0) or (offsetminval <> 0) then
             utc:=true;
          Value:=IncHour(Value,offsethourval);
          Value:=IncMinute(Value,offsetminval);
          if not error then
            begin
              TryStrToDatetimeExt:=true;
              exit;
            end;
        end;
    end;
  { PDF date/time format }
  utc:=false;
  error:=false;
  idx:=pos('D:',outs);
  if idx = 1 then
    begin
      { Convert to an ISO date }
      outs:=AdobeDateToISODate(outs);
      if TryStrToDateTimeExt(outs,value,utc) then
        begin
          TryStrToDatetimeExt:=true;
          exit;
        end;
    end;
  { RFC 822/RFC 1123 Date/Time format}
  utc:=false;
  error:=false;
  { Convert to an ISO date }
  if length(outs) <> 0 then
    begin
     s1:=RFC822ToISODateTime(outs);
     if s1 <> '' then
       begin
         if TryStrToDateTimeExt(s1,value,utc) then
           begin
              TryStrToDatetimeExt:=true;
              exit;
           end;
       end;
    end;
  { ISO 8601 date only }
  datestring:=outs;
  utc:=false;
  error:=false;
  { use default values }
  monthval:=1;
  dayval:=1;
  yearval:=0;
  if not parsedateISO(datestring,yearval,monthval,dayval) then
     error:=true;
  HourVal:=0;
  MinVal:=0;
  SecVal:=0;
  MSecVal:=0;
  Value:=datetojd(Yearval,Monthval,Dayval,HourVal,MinVal,SecVal,MSecval);
  { NO time conversion here since we assume it is a date only string }
  if not error then
    begin
      TryStrToDatetimeExt:=true;
      exit;
    end;
end;


{  See documentation in header file }
function TryEncodeDateAndTimeToStr(const Year, Month, Day, Hour, Minute, Second, MilliSecond: 
  word; UTC: boolean; var AValue: string):boolean;
 var
  ADateTime: TJulianDateTime;
  finalstring: string;
 begin
   FinalString:='' ;
   TryEncodeDateAndTimeToStr:=false;
   if TryEncodeDateTime(Year,Month,Day,Hour,Minute,Second,Millisecond,ADateTime) then
     begin
       TryEncodeDateAndTimeToStr:=true;
       FinalString:=DateTimeToStr(ADateTime);
       { Add the UTC modifier signature if this is an UTC string }
       if UTC then 
         FinalString:=FinalString+'Z';
     end;
   AValue:=FinalString;     
 end;

function DateTimeToStrExt(DateTime: TJulianDateTime; utc: boolean): string; 
var
 tzstr: string;
begin
  if utc then
    tzstr:='Z'
  else
    tzstr:='';
  DateTimeToStrExt:=DateTimeToStr(DateTime)+tzstr;
end;

procedure GetCurrentDate(var Year,Month,Day,DayOfWeek: integer);
var
 aYear,aMonth,aDay,aDayOfWeek: platformword;
begin
  Dos.GetDate(aYear,aMonth,aDay,aDayOfWeek);
  Year:=integer(aYear);
  Month:=integer(aMonth);
  Day:=integer(aDay);
  DayOfWeek:=integer(aDayOfWeek);
end;

procedure GetCurrentTime(var Hour,Minute,Second,Sec100: integer);
var
 aHour,aMinute,aSecond,aSec100: platformword;
begin
  Dos.GetTime(aHour,aMinute,aSecond,aSec100);
  Hour:=integer(aHour);
  Minute:=integer(aMinute);
  Second:=integer(aSecond);
  Sec100:=integer(aSec100);
end;

function TryUNIXToDateTimeExt(unixtime: big_integer_t; var DateTime: TJulianDateTime; var UTC: boolean): boolean;
var
  year,month,day,minute,hour,second: word;
begin
  utc:=true;
  Locale.UNIXToDateTime(unixtime, year,month,day,minute,hour,second);
  TryUNIXToDateTimeExt:=TryEncodeDateTime(Year, Month, Day, Hour, Minute, Second, 0,
   DateTime);
end;

function TryFileTimeToDateTimeExt(ftime: tfiletime; var DateTime: TJulianDateTime; var UTC: boolean): boolean;
var
  julianday: float;
  d: float;
  fracvalue:float;
  HighDateTime: float;
begin
  utc:=true;
  TryFileTimeToDateTimeExt:=false;
  { Check if the format of the data is actually encoded as signed value }
  if (Low(ftime.LowDateTime)<0) and (ftime.LowDateTime < 0) then
    begin
      exit;
    end
  else
  julianday:=ftime.LowDateTime;
  if (Low(ftime.HighDateTime)<0) and (ftime.HighDateTime < 0) then
    begin
      exit;
    end
  else
    HighDateTime:=ftime.HighDateTime;

  julianday:=julianday+(HighDateTime*4294967295.0);
  d:=julianday / 864000000000.0 + 2305813.5;
  { Now do some adjustements so that the seconds are valid.
    How do we do this? Well simple, we only keep two digits
    for the hour, minute and seconds parts. }
  fracvalue:=frac(d);
  fracvalue:=fracvalue*10000.0;
  { Round up or down the .00X digit }
  fracvalue:=round(fracvalue);
  d:=int(d);
  { Re-add these digits to the resulting floating point value }
  d:=d+(fracvalue / 10000.0);
  DateTime:=d;
  TryFileTimeToDateTimeExt:=true;
end;

{
  $Log: not supported by cvs2svn $
  Revision 1.3  2004/11/29 03:50:23  carl
    + UNIX and FILETIME to DateTime conversion

  Revision 1.2  2004/11/23 03:44:51  carl
    * fixes for compilation with Virtual Pascal 2.x

  Revision 1.1  2004/10/31 19:53:06  carl
    + Add support for extended format conversion (Ext routines)

}