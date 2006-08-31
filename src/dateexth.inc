{**********************************************************************}
{ These are extensions to the standard Delphi dateutil unit interface  }
{**********************************************************************}

type
  {** Win32 FILETIME timestamp }
  tfiletime = packed record
    LowDateTime: longword;
    HighDateTime: longword;
  end;


{** Returns Year, Month, Day, Hour, Minute, Second, and Millisecond values for a TDateTime.
    This routine uses extended format which permits negative years.
}
{procedure DecodeDateTimeExt(const AValue: TDateTime; var Year, Month, Day, Hour, Minute, Second, MilliSecond: Integer);}

{** Returns Year, Month, and Day values for a TDateTime value. This is
    the same as DecodeDateExt except that it also permits years in
    the negative range.
}
{procedure DecodeDateExt(Date: TDateTime; var Year, Month, Day: integer);}


{** @abstract(Converts a string to a TDateTime value with a Boolean success code.)

    This routine also gives information if the value was successfully
    converted to UTC time or not (if no timezone information was
    available in the string then the utc value will be false).

    Supported formats:
    1) Format of Complete Representation for calendar dates
    (as specified in ISO 8601), which should include the Time
    designator character.
    3) Format: 'YYYY-MM-DD HH:mm:ss [GMT|UTC|UT]'
    4) Openoffice 1.1.x HTML date format: 'YYYYMMDD;HHmmssuu'
    5) Adobe PDF 'D:YYYYMMDDHHMMSSOHH'mm'' format

    The returned value will be according to UTC if timezone
    information is specified.

    In the case where the date does not contain the full representation
    of a date (for examples, YYYY or YYYY-MM), then the missing values
    will be set to 1 to be legal.

}
function TryStrToDateTimeExt(const S: string; var Value: TDateTime; var UTC: boolean) : Boolean;

{** This routine encodes a complete date and time to its string
    representation. The encoded string conforms to the ISO 8601
    complete representation extended format (YYYY-MM-DDTHH:MM:SS[Z]).
    
    The year value is required, while all other fields are optional.
    The other fields can be set to EMPTY_DATETIME_FIELD to indicate that 
    they are empty. It also adds the UTC marker if required and if it
    is set and time information is present.
}    
function TryEncodeDateAndTimeToStr(const Year, Month, Day, Hour, Minute, Second, MilliSecond: 
  word; UTC: boolean; var AValue: string):boolean;
  
{** This routine encodes a complete date and time to its string
    representation. The encoded string conforms to the ISO 8601
    expanded date representation concatenated with an
    extended time format ([+|-]YYYYYY-MM-DDTHH:MM:SS[Z]).. 
    
    The year value is required, while all other fields are optional.
    The other fields can be set to EMPTY_DATETIME_FIELD to indicate that 
    they are empty. It also adds the UTC marker if required and if it
    is set and time information is present.
}    
{function EncodeDateAndTimeToStrExt(const Year, Month, Day, Hour, Minute, Second, MilliSecond: 
  integer; UTC: boolean):string;}


{** @abstract(Converts a TDateTime value to a string in extended ISO 8601 date and time representation.)

    Returns the extended format representation of a date and time as recommended
    by ISO 8601 (Gregorian Calendar). The extended format ISO 8601 representation
    is of the form: YYYY-MM-DDThh:mm:ss[Z]. Sets the timezone designator
    if required.
}
function DateTimeToStrExt(DateTime: TDateTime; utc: boolean): string; 


{** @abstract(Returns the current date set in the operating system) }
procedure GetCurrentDate(var Year,Month,Day,DayOfWeek: integer);

{** @abstract(Returns the current time set in the operating system) 

   Ranges of the values returned are Hour 0..23, Minute 0..59,
   Second 0..60, Sec100 0..99.
}
procedure GetCurrentTime(var Hour,Minute,Second,Sec100: integer);

{** @abstract(Converts a UNIX time_t to a TDateTime)

  This routine converts a UNIX time_t format time into a
  TDateTime format. The time_t is always according to UTC,
  so the UTC value shall always return TRUE.
  
  On Turbo Pascal and Virtual Pascal this routine shall fail
  with all values greater that represent years greater than
  2038.
}
function TryUNIXToDateTimeExt(unixtime: big_integer_t; var DateTime: TDateTime; var UTC: boolean): boolean;

{** @abstract(Converts a Win32 FILETIME to a TDateTime)

  This routine converts a 64-bit FILETIME format time into a
  TDateTime format. The value is always according to UTC,
  so the UTC value shall always return TRUE. Because floating
  point values are used, the precision of the returned timestamp
  will be +/- 2 seconds.

}
function TryFileTimeToDateTimeExt(ftime: tfiletime; var DateTime: TDateTime; var UTC: boolean): boolean;


{
  $Log: not supported by cvs2svn $
  Revision 1.3  2004/11/29 03:50:24  carl
    + UNIX and FILETIME to DateTime conversion

  Revision 1.2  2004/11/23 03:44:53  carl
    * fixes for compilation with Virtual Pascal 2.x

  Revision 1.1  2004/10/31 19:53:07  carl
    + Add support for extended format conversion (Ext routines)

}