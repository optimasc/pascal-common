{ See documentation in header file }
function TryStrToDateTimeExt(const S: string; var Value: TJulianDate; var UTC: boolean) : Boolean;
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
  { RFC 822/RFC 1123 Date/Time format }
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
  ADateTime: TJulianDate;
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

function DateTimeToStrExt(DateTime: TJulianDate; utc: boolean): string; 
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

function TryUNIXToDateTimeExt(unixtime: big_integer_t; var DateTime: TJulianDate; var UTC: boolean): boolean;
var
  year,month,day,minute,hour,second: word;
begin
  utc:=true;
  Locale.UNIXToDateTime(unixtime, year,month,day,minute,hour,second);
  TryUNIXToDateTimeExt:=TryEncodeDateTime(Year, Month, Day, Hour, Minute, Second, 0,
   DateTime);
end;

function TryFileTimeToDateTimeExt(ftime: tfiletime; var DateTime: TJulianDate; var UTC: boolean): boolean;
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


function TryStrToEncodedDateTimeExt(const S: string; var dt: TEncodedDateTime) : Boolean;
var
 idx: integer;
 minval,
 secval,
 hourval:word;
 offsetminval,
 offsethourval: integer;
 datestring,timestring: string;
 syearval,smonthval,sdayval: smallint;
 yearval,monthval,dayval: word;
 MSecVal: word;
 error: boolean;
 outs: string;
 utc: boolean;
 s1: string;
 value: word;
begin

  dt.date.year := 0;
  dt.date.month := 0;
  dt.date.day := 0;
  dt.time.hour := -1;
  dt.time.min := -1;
  dt.time.sec := -1;
  dt.time.fracsec := -1;
  dt.time.tzset := false;
  dt.time.tzhour := -1;
  dt.time.tzmin := -1;
  
  error:=false;
  TryStrToEncodedDateTimeExt:=false;
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
          dt.date.year := YearVal;
          dt.date.month := MonthVal;
          dt.date.day := DayVal;
          dt.time.hour := HourVal;
          dt.time.min := MinVal;
          dt.time.sec := SecVal;
          if not ((utc = false) and (offsethourval = 0) and (offsetminval = 0)) then
            begin
              dt.time.tzset := true;
              dt.time.tzhour := offsethourval;
              dt.time.tzmin := offsetminval;
            end;
          if utc then
            begin
              dt.time.tzhour := 0;
              dt.time.tzmin := 0;
            end;
        end;
         if not error then
           begin
             TryStrToEncodedDateTimeExt:=true;
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
          dt.date.year := YearVal;
          dt.date.month := MonthVal;
          dt.date.day := DayVal;
          dt.time.hour := HourVal;
          dt.time.min := MinVal;
          dt.time.sec := SecVal;
          if not ((utc = false) and (offsethourval = 0) and (offsetminval = 0)) then
            begin
              dt.time.tzset := true;
              dt.time.tzhour := shortint(offsethourval);
              dt.time.tzmin := shortint(offsetminval);
            end;
          if utc then
            begin
              dt.time.tzhour := 0;
              dt.time.tzmin := 0;
            end;
          if not error then
            begin
             TryStrToEncodedDateTimeExt:=true;
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
          dt.date.year := YearVal;
          dt.date.month := MonthVal;
          dt.date.day := DayVal;
          dt.time.hour := HourVal;
          dt.time.min := MinVal;
          dt.time.sec := SecVal;
          if not ((utc = false) and (offsethourval = 0) and (offsetminval = 0)) then
            begin
              dt.time.tzset := true;
              dt.time.tzhour := offsethourval;
              dt.time.tzmin := offsetminval;
            end;
          if utc then
            begin
              dt.time.tzhour := 0;
              dt.time.tzmin := 0;
            end;
          if not error then
            begin
              TryStrToEncodedDateTimeExt:=true;
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
      outs:=AdobeDateToISODateExt(outs);
      if TryStrToEncodedDateTimeExt(outs,dt) then
        begin
          TryStrToEncodedDatetimeExt:=true;
          exit;
        end;
    end;
  { RFC 822/RFC 1123 Date/Time format }
  utc:=false;
  error:=false;
  { Convert to an ISO date }
  if length(outs) <> 0 then
    begin
     s1:=RFC822ToISODateTime(outs);
     if s1 <> '' then
       begin
          if TryStrToEncodedDateTimeExt(s1,dt) then
            begin
             TryStrToEncodedDatetimeExt:=true;
             exit;
            end;
       end;
    end;
  { ISO 8601 date only }
  datestring:=outs;
  utc:=false;
  error:=false;
  { use default values }
  monthval:=0;
  dayval:=0;
  yearval:=0;

  if not IsValidISODateStringExt(s,False,yearval,monthval,dayval) then
    error := true;

  if YearVal <> 0 then
     dt.date.year := YearVal;
  if MonthVal <> 0 then   
   dt.date.month := MonthVal;
  if DayVal <> 0 then   
    dt.date.day := DayVal;
  dt.time.hour := -1;
  dt.time.min := -1;
  dt.time.sec := -1;
  dt.time.fracsec := -1;
  dt.time.tzset := false;
  dt.time.tzhour := -1;
  dt.time.tzmin := -1;
     
  { NO time conversion here since we assume it is a date only string }
  if not error then
    begin
      TryStrToEncodedDateTimeExt:=true;
      exit;
    end;
end;

function DecimalToString(const i : double): string;
 var
  s: string;
  s1: string;
  idx: integer;
  intval: big_integer_t;
  fracval: double;
  count: integer;
 begin
   intval:=trunc(i);
   s:=IntToStr(intval);
   { Get the number of digits in the fractional part }
   fracval:=frac(i);
   count:=0;
   while frac(fracval) <> 0 do
    begin
      if count > 8 then
        break;
      fracval:=fracval*10.00;
      inc(count);
    end;
   intval:=trunc(fracval);
   s1:=IntToStr(intval);
   {  Verify the sign of the fractional part, if
      negative, apply it to the integer part }
   if s1[1] = '-' then
     begin
       delete(s1,1,1);
       if s[1] <> '-'  then
         s:='-'+s;
     end;
   { Add fractional values as required }
   for idx:=1 to count do
    begin
      { The digits were not preceding zeros }
      if length(s1) = count then
        break;
      s1:='0' + s1;
    end;
   idx:=length(s1);
   { Remove all trailing zeros from the fractional part }
   while (s1[idx] = '0') and (idx >=1)  do
     dec(idx);
   s1:=copy(s1,1,idx);
   { In case, the fractional is empty, add 0 as required
     by the canonical representation }
   if length(s1) = 0 then
    s1:='0';
   DecimalToString:=s+'.'+s1;
 end;


function EncodedDateTimeToStrExt(DT: TEncodedDateTime): string;
const
 DATE_SEPARATOR = '-';
 TIME_SEPARATOR = ':';
var
 YearStr: string;
 MonthStr: string;
 DayStr: string;
 HourStr: string;
 MinStr: string;
 SecStr: string;
 TimezoneStr: string;
 DateString: string;
 TimeString: string;
 FracSecStr:string;
begin
   YearStr:='';
   Monthstr:='';
   DayStr:='';
   HourStr:='';
   MinStr:='';
   SecStr:='';
   TimezoneStr:='';
   DateString:='';
   TimeString:='';
   FracsecStr:='';
   if dt.date.year <> 0 then
     YearStr:=FillWithZero(IntToStr(dt.date.year),4);
   if dt.date.month > 0 then
     MonthStr:=FillWithZero(IntToStr(dt.date.month),2);
   if dt.date.day > 0 then
     DayStr:=FillWithZero(IntToStr(dt.date.day),2);
   if dt.time.hour >= 0 then
     begin
       { For the canonical representation, 24 is replaced by 00
       }
       if dt.time.hour = 24 then
         dt.time.hour:=00;
       HourStr:=FillWithZero(IntToStr(dt.time.hour),2);
     end;
   if dt.time.min >= 0 then
     MinStr:=FillWithZero(IntToStr(dt.time.min),2);
   if dt.time.sec >= 0 then
     SecStr:=FillWithZero(IntToStr(dt.time.sec),2);
   if dt.time.fracsec > 0 then
     begin
       FracSecStr:=DecimalToString(dt.time.Fracsec);
       { Delete the leading decimal
         canonical representation always has a leading zero.
        }
       delete(FracSecStr,1,1);
     end;
   { Add timezone information as required }
   if dt.time.tzset then
     begin
       if (dt.time.tzhour = 0) and (dt.time.tzmin = 0) then
         TimezoneStr:='Z'
       else
       if (dt.time.tzhour < 0) or (dt.time.tzmin < 0) then
          begin
            dt.time.tzhour:=integer(abs(dt.time.tzhour));
            dt.time.tzmin:=integer(abs(dt.time.tzmin));
            TimeZoneStr:='-'+FillWithZero(IntToStr(dt.time.tzhour),2)+
              ':'+FillWithZero(IntToStr(dt.time.tzmin),2);
          end
       else
          begin
            TimeZoneStr:='+'+FillWithZero(IntToStr(dt.time.tzhour),2)+
              ':'+FillWithZero(IntToStr(dt.time.tzmin),2);
          end;
     end;
    DateString:=YearStr;
    if length(MonthStr) > 0 then
     DateString:=DateString+DATE_SEPARATOR+MonthStr;
   if length(DayStr) > 0 then
     DateString:=DateString+DATE_SEPARATOR+DayStr;
    TimeString:=HourStr+TIME_SEPARATOR+MinStr+TIME_SEPARATOR+SecStr;
    { There is a time component }
    if length(TimeString) > 2 then
      begin
        { All time components must be present in that case }
        if (length(HourStr) = 0) or (length(MinStr) = 0) or (length(SecStr) = 0) then
          exit;
        { Add the fractional seconds, as required }
        if length(FracSecStr) > 0 then
          TimeString:=TimeString+FracSecStr;
        if length(DateString) > 0 then
          EncodedDateTimeToStrExt:=DateString+'T'+TimeString+TimeZoneStr
        else
          EncodedDateTimeToStrExt:=TimeString+TimeZoneStr;
        exit;
      end;
    EncodedDateTimeToStrExt:=DateString+TimeZoneStr;
end;


{
  $Log: not supported by cvs2svn $
  Revision 1.4  2011/11/24 00:27:36  carl
  + update to new architecture of dates and times, as well as removal of some duplicate files.

  Revision 1.3  2004/11/29 03:50:23  carl
    + UNIX and FILETIME to DateTime conversion

  Revision 1.2  2004/11/23 03:44:51  carl
    * fixes for compilation with Virtual Pascal 2.x

  Revision 1.1  2004/10/31 19:53:06  carl
    + Add support for extended format conversion (Ext routines)

}