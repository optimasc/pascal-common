{ See documentation in header file }
function TryStrToDateTimeExt(const S: string; var Value: TDateTime; var UTC: boolean) : Boolean;
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
begin
  error:=false;
  TryStrToDateTimeExt:=false;
  MSecVal:=0;
  utc:=false;
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
  ADateTime: TDateTime;
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

function DateTimeToStrExt(DateTime: TDateTime; utc: boolean): string; 
var
 tzstr: string;
begin
  if utc then
    tzstr:='Z'
  else
    tzstr:='';
  DateTimeToStrExt:=DateTimeToStr(DateTime)+tzstr;
end;

{
  $Log: not supported by cvs2svn $
}