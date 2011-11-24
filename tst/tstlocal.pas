program tstlocal;

uses locale,cmntyp;


var
 year,month,day: word;
 hour,min,sec,msec: word;
 offhour,offmin: smallint;
 
begin
 assert(IsValidISODateStringExt('1997',false,year,month,day)  = true);
 assert(year = 1997);
 assert(month = 00);
 assert(day = 00);
 assert(IsValidISODateStringExt('1997',true,year,month,day)  = false);
 assert(IsValidISODateStringExt('1997-07',false,year,month,day)  = true);
 assert(year = 1997);
 assert(month = 07);
 assert(day = 00);
 assert(IsValidISODateStringExt('1997-00',false,year,month,day)  = false);
 assert(IsValidISODateStringExt('1997-07',true,year,month,day)  = false);

 
 
 {  Complete date:
      YYYY-MM-DD (eg 1997-07-16) }
 
 assert(IsValidISODateStringExt('1997-07-16',false,year,month,day)  = true);
 assert(year = 1997);
 assert(month = 07);
 assert(day = 16);

(* NOT SUPPORTED 
 { Complete hours and minutes:
      hh:mmTZD (eg 19:20+01:00) }
 assert(IsValidISOTimeStringExt('19:20+01:00',false,hour,min,sec,offhour,offmin)  = true);
 assert(hour = 19);
 assert(min = 20);
 assert(sec = 00);
 assert(offhour = 01);
 assert(offmin = 00);
 
  { Complete hours and minutes:
       hh:mmTZD (eg 19:20+01:00) }
  assert(IsValidISOTimeStringExt('19:20-01:00',false,hour,min,sec,offhour,offmin)  = true);
  assert(hour = 19);
  assert(min = 20);
  assert(sec = 00);
  assert(offhour = -01);
  assert(offmin = 00);*)

      
      
 {  Complete hours, minutes and seconds:
      hh:mm:ssTZD (eg 19:20:30-01:00) }
  assert(IsValidISOTimeStringExt('19:20:30-01:00',false,hour,min,sec,offhour,offmin)  = true);
  assert(hour = 19);
  assert(min = 20);
  assert(sec = 30);
  assert(offhour = -01);
  assert(offmin = 00);
  
  assert(IsValidISOTimeStringExt('19:20:30-00:40',false,hour,min,sec,offhour,offmin)  = true);
  assert(hour = 19);
  assert(min = 20);
  assert(sec = 30);
  assert(offhour = 00);
  assert(offmin = -40);

 {  Invalid Complete hours, minutes and seconds: }
  assert(IsValidISOTimeStringExt('25:20:30-35:00',false,hour,min,sec,offhour,offmin)  = false);

 {  Invalid Complete hours, minutes and seconds: }
  assert(IsValidISOTimeStringExt('22:20:30-35:00',false,hour,min,sec,offhour,offmin)  = false);

{      
   Complete date plus hours, minutes, seconds and a decimal fraction of a
second
      YYYY-MM-DDThh:mm:ss.sTZD (eg 1997-07-16T19:20:30.45+01:00)
      
      NOT SUPPORTED YET
}
end.

{
 $Log: not supported by cvs2svn $
 Revision 1.1  2009/01/28 03:47:35  carl
 Added ISO Date tests.

} 