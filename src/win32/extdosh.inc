
const
 {** Minimal filesystem year for dates for this operating system **}
 MIN_FILE_YEAR   =  1601;
 
{$IFDEF FPC}
type
  TCHAR = ucs2char;
{$ENDIF}

type
  TSearchRecExt = record
    Stats: TFileStats;
    {** Operating system specific data *}
    FindHandle  : THandle;
{$IFDEF FPC}
    W32FindData :WIN32_FIND_DATA;
{$ELSE}
    W32FindData : TWin32FindDataW;
{$ENDIF}
    IncludeAttr : longint;
    SearchAttr: TResourceAttributes;
  end;
