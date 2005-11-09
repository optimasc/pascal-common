
const
 {** Minimal filesystem year for dates for this operating system **}
 MIN_FILE_YEAR   =  1601;
 
{$IFDEF FPC}
type
  TCHAR = ucs2char;
  TFileTime = FILETIME;
  _WIN32_FIND_DATAW = record
    dwFileAttributes: DWORD;
    ftCreationTime: TFileTime;
    ftLastAccessTime: TFileTime;
    ftLastWriteTime: TFileTime;
    nFileSizeHigh: DWORD;
    nFileSizeLow: DWORD;
    dwReserved0: DWORD;
    dwReserved1: DWORD;
    cFileName: array[0..MAX_PATH - 1] of WideChar;
    cAlternateFileName: array[0..13] of WideChar;
  end;
  TWin32FindDataW = _WIN32_FIND_DATAW;
{$ENDIF}

type
  TSearchRecExt = record
    Stats: TFileStats;
    {** Operating system specific data *}
    FindHandle  : THandle;
    W32FindData : TWin32FindDataW;
    IncludeAttr : longint;
    SearchAttr: TResourceAttributes;
  end;
