

uses sysutils,dos,dateutil,go32,unicode;

const


 {** Maximum length of unicode buffers }
 MAX_UNICODE_BUFSIZE = 63;
 MAX_PATH = 255;

Type

{ This is the record returned by Windows 95 }
TWin95FileInfo = packed record
  Attributes: longword;
  ctime: dateutil.tfiletime;
  atime: dateutil.tfiletime;
  mtime: dateutil.tfiletime;
  volume: longword;
  filesize_high: longword;
  filesize_low: longword;
  links: longword;
  uid_high: longword;
  uid_low: longword;
end;


{*******************************************************************************}
{                            UTILITY FUNCTIONS                                  }
{*******************************************************************************}
{** Returns the active code page }
function getactivecodepage: word;
var
  dosregs : registers;
begin
  dosregs.ax:=$6601;
  msdos(dosregs);
  { By default suppose 850 code page if there was an error in the call }
  if (dosregs.flags and fcarry) <> 0 then
    getactivecodepage:=850
  else
    getactivecodepage:=dosregs.bx;
end;


{ Tries to retrieve information by file handle by using the Win95 extended
  file information function, if fails, returns false, otherwise true }
function getinfobyhandle(handle: word; var info: TWin95FileInfo): boolean;
var
 dosregs: registers;
begin
 fillchar(info, sizeof(info), #0);
 copytodos(info,sizeof(info));
 dosregs.ax:=$71a6;
 dosregs.bx:=handle;
 dosregs.edx:=tb_offset;
 dosregs.ds:=tb_segment;
 dosregs.flags:=dosregs.flags or fcarry;
 msdos(dosregs);
 copyfromdos(info,sizeof(info));
 { By default suppose 850 code page if there was an error in the call }
 if (dosregs.flags and fcarry) <> 0 then
   getinfobyhandle:=false;
 getinfobyhandle:=true;
end;

{ Converts an UTF-8 encoded string to the active code page string }
function ConvertUTF8ToLocale(p: putf8char): string;
var
 ActiveCodePage: integer;
 CodePageStr: string;
begin
  ConvertUTF8ToLocale:='';
  ActiveCodePage:=GetActiveCodePage;
  CodePageStr:=MicrosoftLangageCodeToISOCode(ActiveCodePage);
  { No conversion required }
  if CodePageStr = 'UTF-8' then
    begin
      ConvertUTF8ToLocale:=s;
      exit;
    end;
  ConvertUTF8ToLocale:=utf8strpastostring(p,CodePageStr);
end;

{ Converts a locale encoded string to an UTF-8 string }
function ConvertLocaleToUTF8(s: string): utf8string;
var
 ActiveCodePage: integer;
 CodePageStr: string;
 outstr: utf8string;
 ucs4str: ucs4string;
begin
  ConvertLocaleToUTF8:='';
  ActiveCodePage:=GetActiveCodePage;
  CodePageStr:=MicrosoftLangageCodeToISOCode(ActiveCodePage);
  { No conversion required }
  if CodePageStr = 'UTF-8' then
    begin
      ConvertLocaleToUTF8:=s;
      exit;
    end;
  ConvertToUCS4(s,ucs4str,CodePageStr);  
  ConvertUCS4ToUTF8(ucs4str, outstr);
  ConvertLocaleToUTF8:=outstr;
end;

{ Convert Windows attributes to our pascal format of attributes }
function DosAttrToExtAttr(dwAttributes: longword): TResourceAttributes;
var
  Attributes: TResourceAttributes;
begin
  Attributes:=[];
  if (dwAttributes and dos.readonly)<>0 then
    Include(Attributes, attr_readonly);
  if (dwAttributes and dos.hidden)<>0 then
    Include(Attributes, attr_hidden);
  if (dwAttributes and dos.system)<>0 then
    Include(Attributes, attr_system);
  if (dwAttributes and dos.archive)<>0 then
    Include(Attributes, attr_archive);
  if (dwAttributes and dos.volumeid)<>0 then
    Include(Attributes, attr_device);
  if (dwAttributes and dos.directory)<>0 then
    Include(Attributes, attr_directory);
  if (dwAttributes = 0) then
    Attributes:=[];
  DosAttrToExtAttr:=attributes;
end;

{ Convert our attribute format to Windows attributes }
function ExtAttrToDosAttr(attr: TResourceAttributes): longword;
var
 dwAttr: longword;
begin
  dwAttr:=0;
  if attr_system in attr then
    dwAttr:=dwAttr or dos.sysfile;
  if attr_archive in attr then
    dwAttr:=dwAttr or dos.archive;
  if attr_device in attr then
    dwAttr:=dwAttr or dos.volumeid;
  if attr_directory in attr then
    dwAttr:=dwAttr or dos.directory;
  if attr = [] then
    dwAttr:=0;
  ExtAttrToDosAttr:=dwAttr;
end;

{ Unsupported }
procedure GetShellAssociationInfo(const ext: utf8string; var assoc: TFileAssociation;
  var comment: utf8string);
begin  
  FillChar(assoc,sizeof(assoc),#0);
  comment:='';
end;


{**************************************************************************}


function getfileatime(fname: putf8char; var atime: TJulianDate): integer;
var
  F: File;
  status: integer;
  ucs4str: pucs4char;
  ucs2str: pucs2char;
  info: TWin95FileInfo;
begin
  atime:=0;
  getfileatime:=EXTDOS_STATUS_UNSUPPORTED;
  FileAssign(F,ConvertUTF8ToLocale(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfileatime:=status;
      exit;
    end;
  FileReset(F,fmReadOnly);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfileatime:=status;
      exit;
    end;
  if not getInfoByHandle(Handle,info) then
      exit;
  if info.atime = 0 then
      exit;
  if not TryFileTimeToDateTimeExt(info.atime, atime, UTC) then
    getfileatime:= EXTDOS_STATUS_DATE_CONVERT_ERROR;           
  getfileatime:=EXTDOS_STATUS_OK;    
  FileClose(F);
end;

function getfilectime(fname: putf8char; var ctime: TJulianDate): integer;
var
  F: File;
  status: integer;
  ucs4str: pucs4char;
  ucs2str: pucs2char;
  info: TWin95FileInfo;
begin
  atime:=0;
  getfilectime:=EXTDOS_STATUS_UNSUPPORTED;
  FileAssign(F,ConvertUTF8ToLocale(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilectime:=status;
      exit;
    end;
  FileReset(F,fmReadOnly);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilectime:=status;
      exit;
    end;
  if not getInfoByHandle(Handle,info) then
      exit;
  if info.ctime = 0 then
      exit;
  if not TryFileTimeToDateTimeExt(info.ctime, ctime, UTC) then
    getfilectime:= EXTDOS_STATUS_DATE_CONVERT_ERROR;           
  getfilectime:=EXTDOS_STATUS_OK;    
  FileClose(F);
end;

function getfilemtime(fname: putf8char; var mtime: TJulianDate): integer;
var
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  mtime:=0;
  getfilemtime:=EXTDOS_STATUS_UNSUPPORTED;
  FileAssign(F,ConvertUTF8ToLocale(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilemtime:=status;
      exit;
    end;
  FileReset(F,fmReadOnly);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilemtime:=status;
      exit;
    end;
  dos.getftime()  
  if not TryFileTimeToDateTimeExt(info.ctime, ctime, UTC) then
    getfilectime:= EXTDOS_STATUS_DATE_CONVERT_ERROR;           
  getfilectime:=EXTDOS_STATUS_OK;    
  FileClose(F);
end;

function getfileowner(fname: putf8char): utf8string;
begin
  getfileowner:='';
end;

function setfileatime(fname: putf8char; newatime: TJulianDate): integer;
const
  FILE_WRITE_ATTRIBUTES = $100;
var
  ResultVal: BOOL;
  LastAccessTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
  security : TSecurityAttributes;
  ucs4str: pucs4char;
  ucs2str: pucs2char;
begin
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfileatime:=status;
      exit;
    end;
{ We must open the file with a special access mode not 

  modify the last access time. }
  security.nLength := Sizeof(TSecurityAttributes);
  security.bInheritHandle:=true;
  security.lpSecurityDescriptor:=nil;

  ucs4str:=ucs4strnew(fname,'UTF-8');
  ucs2str:=ucs2strnew(ucs4str);
  filerec(f).handle:=PCreateFileW(pwidechar(ucs2str),FILE_WRITE_ATTRIBUTES,FILE_SHARE_READ,@security,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
  ucs2strdispose(ucs2str);
  ucs4strdispose(ucs4str);
  
  { handle -1 is returned sometimes !! (PM) }
  if (filerec(f).handle=0) or (filerec(f).handle=-1) then
    begin
      status:=GetLastError;
    end;
  if status <> 0 then
    begin
      setfileatime:=status;
      exit;
    end;
  DecodeDateTime(newatime, FileTimeInfo.wYear,
    FileTimeInfo.wMonth, FileTimeInfo.wDay,
    FileTimeInfo.wHour, FileTimeInfo.wMinute,
    FileTimeInfo.wSecond, FileTimeInfo.wMilliSeconds);
  { Check if this is a valid year or not }
  if FileTimeInfo.wYear < MIN_FILE_YEAR then
    begin
      setfileatime:=EXTDOS_STATUS_DATE_UNSUPPORTED;
      FileClose(F);
      exit;
    end;
  ResultVal:=SystemTimeToFileTime(FileTimeInfo,LastAccessTime);
  if ResultVal then
    begin
      ResultVal:=SetFileTime(FileRec(F).handle,nil,@LastAccessTime,nil);
      if ResultVal then
        status:=EXTDOS_STATUS_OK
      else
        status:=GetLastError;
    end
  else
    begin
       setfileatime:=GetLastError;
       exit;
    end;
  setfileatime:=status;
  CloseHandle(filerec(F).handle);
{  FileClose(F);}
end;


function setfilemtime(fname: putf8char; newmtime: TJulianDate): integer;
var
  ResultVal: BOOL;
  LastWriteTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfilemtime:=status;
      exit;
    end;
  FileReset(F,fmOpenReadWrite);
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfilemtime:=status;
      exit;
    end;
  DecodeDateTime(newmtime, FileTimeInfo.wYear,
    FileTimeInfo.wMonth, FileTimeInfo.wDay,
    FileTimeInfo.wHour, FileTimeInfo.wMinute,
    FileTimeInfo.wSecond, FileTimeInfo.wMilliSeconds);
  { Check if this is a valid year or not }
  if FileTimeInfo.wYear < MIN_FILE_YEAR then
    begin
      setfilemtime:=EXTDOS_STATUS_DATE_UNSUPPORTED;
      FileClose(F);
      exit;
    end;
  ResultVal:=SystemTimeToFileTime(FileTimeInfo,LastWriteTime);
  if ResultVal then
    begin
      ResultVal:=SetFileTime(FileRec(F).handle,nil,nil,@LastWriteTime);
      if ResultVal then
        status:=EXTDOS_STATUS_OK
      else
        status:=GetLastError;
    end
  else
    begin
       setfilemtime:=GetLastError;
       exit;
    end;
  setfilemtime:=status;
  FileClose(F);
end;


function setfilectime(fname: putf8char; newctime: TJulianDate): integer;
var
  ResultVal: BOOL;
  CreationTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfilectime:=status;
      exit;
    end;
  FileReset(F,fmOpenReadWrite);
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfilectime:=status;
      exit;
    end;
  DecodeDateTime(newctime, FileTimeInfo.wYear, 
    FileTimeInfo.wMonth, FileTimeInfo.wDay, 
    FileTimeInfo.wHour, FileTimeInfo.wMinute,
    FileTimeInfo.wSecond, FileTimeInfo.wMilliSeconds);
  { Check if this is a valid year or not }
  if FileTimeInfo.wYear < MIN_FILE_YEAR then
    begin
      setfilectime:=EXTDOS_STATUS_DATE_UNSUPPORTED;
      FileClose(F);
      exit;    
    end;
  ResultVal:=SystemtimeToFileTime(FileTimeInfo,CreationTime);
  if ResultVal then
    begin
      ResultVal:=SetFileTime(FileRec(F).handle,@CreationTime,nil,nil);
      if ResultVal then
        status:=EXTDOS_STATUS_OK
      else
        status:=GetLastError;
    end
  else
    begin
       setfilectime:=GetLastError;
       exit;
    end;
  setfilectime:=status;
  FileClose(F);
end;




function getfilestats(fname: putf8char; var stats: TFileStats): integer;
var
 F: file;
 ResultVal: BOOL;
 info: BY_HANDLE_FILE_INFORMATION;
 name: namestr;
 status: integer;
 dir: dirstr;
 ext: extstr;
 FileTimeInfo: SYSTEMTIME;
 s: string;
begin
  fillchar(stats,sizeof(stats),#0);
  FileAssign(F,ConvertUTF8ToLocale(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilestats:=status;
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilestats:=status;
      exit;
    end;
{$IFDEF FPC}
  ResultVal:=GetFileInformationByHandle(FileRec(F).handle,@info);
{$ELSE}
  ResultVal:=GetFileInformationByHandle(FileRec(F).handle,info);
{$ENDIF}
  if ResultVal then
    begin
      {***** Unsupported information ****}
      stats.accesses:=-1;
      stats.streamcount:=-1;
      {***** Supported returned information ****}
      stats.utc:=true;
      s:=hexstr(longint(info.dwVolumeSerialNumber),8);
      move(s[1],stats.dev[0],length(s));
      { Now the file serial number }
      s:=hexstr(longint(info.nFileIndexLow),8);
      move(s[1],stats.ino[0],length(s));
      s:=hexstr(longint(info.nFileIndexHigh),8);
      move(s[1],stats.ino[8],length(s));
      {** Name of the resource on disk }
      FSplit(strpas(fname),dir,name,ext);
      s:=name+ext;
      stats.name:=s;
      { Fill up shell file assocations and comment strings }
      GetShellAssociationInfo(ext,stats.association,stats.comment);
      stats.nlink:=info.nNumberOfLinks;
      stats.attributes:=WinAttrToExtAttr(info.dwFileAttributes);
      stats.owner:=getfileowner(fname);
      stats.size:=getfilesize(fname);
      ResultVal:=FileTimeToSystemTime(info.ftLastWriteTime,FileTimeInfo);
      { Error if value is exactly zero, probably indicates that this FileSystem
        does not support this timestamp }
      if ResultVal and not
      ((info.ftLastWriteTime.dwLowDateTime = 0) and (info.ftLastWriteTime.dwHighDateTime = 0)
      ) then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,stats.mtime) then
         end;
      ResultVal:=FileTimeToSystemTime(info.ftCreationTime,FileTimeInfo);
      if ResultVal and not
      ((info.ftCreationTime.dwLowDateTime = 0) and (info.ftCreationTime.dwHighDateTime = 0)
      ) then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,stats.ctime) then
             status:=EXTDOS_STATUS_OK;
         end;
      ResultVal:=FileTimeToSystemTime(info.ftLastAccessTime,FileTimeInfo);
      if ResultVal and not
      ((info.ftLastAccessTime.dwLowDateTime = 0) and (info.ftLastAccessTime.dwHighDateTime = 0)
      ) then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,stats.atime) then
             status:=EXTDOS_STATUS_OK;
         end;
    end
  else
     getfilestats:=GetLastError;
  FileClose(F);
end;


function getfilesize(fname: putf8char): big_integer_t;
var
 F: File;
 status: integer;
begin
  FileAssign(F,ConvertUTF8ToLocale(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilesize:=big_integer_t(-1);
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilesize:=big_integer_t(-1);
      exit;
    end;
  getfilesize:=FileGetSize(F);
  FileClose(F);  
end;


function DirectoryExists(DName : utf8string): Boolean;
var
 utf: putf8char;
 searchinfo: TSearchRecExt;
 Volume: boolean;
 status: integer;
begin
  Volume:=false;
  DirectoryExists:=false;
  { Special handling for volume }
  if (length(dname) = 3) and (dname[2] = ':') then
    begin
      Volume:=true;
      Dname:=dname+'*';
    end
  else
    begin
      if Dname[length(Dname)] = DirectorySeparator then
        delete(DName,length(DName),1);
    end;
  utf:=utf8strnewstr(dname);
  if not volume then
     status:=FindFirstEx(utf,[attr_directory],SearchInfo)
  else
     status:=FindFirstEx(utf,[attr_any],SearchInfo);
  if status = 0 then
    begin
      DirectoryExists:=true;
    end;
  FindCloseEx(SearchInfo);  
  utf8strdispose(utf);
end;


function FileExists(const FName : utf8string): Boolean;
var
 utf: putf8char;
 searchinfo: TSearchRecExt;
 status: integer;
begin
  FileExists:=false;
  utf:=utf8strnewstr(fname);
  status:=FindFirstEx(utf,[attr_any],SearchInfo);
  if status = 0 then
    begin
      if not
         (
         (attr_directory in SearchInfo.stats.Attributes) or
         (attr_directory in SearchInfo.stats.Attributes)
         )
         then
         FileExists:=true;
    end;
  FindCloseEx(SearchInfo);  
  utf8strdispose(utf);
end;




function getuserfullname(account: utf8string): utf8string;
var
 p: pointer;
 wc: pucs2char;
 ucs4accountname: pucs4char;
 ui: P_USER_INFO_2;
 pnetusergetinfo: tnetusergetinfo;
 UCS4FinalName: pucs4char;
begin
  getuserfullname:='';
  if not assigned(pointer(NetApi32Handle)) then exit;
  p:=(GetProcAddress(NetApi32Handle,'NetUserGetInfo'));
  PNetUserGetInfo:=tnetusergetinfo(p);
  if not assigned(p) then exit;
  { Convert the account name to UCS-2 }
  ucs4accountname:=ucs4strnewstr(account,'UTF-8');
  wc:=ucs2strnew(ucs4accountname);
  ucs4strdispose(ucs4accountname);
  { Success on 0 }
  if PNetUserGetInfo(nil,pwidechar(wc),2,ui) =0 then
    begin
       UCS4FinalName:=ucs4strnewucs2(ui^.usri2_full_name);
       getuserfullname:=ucs4strpastoUTF8(UCS4FinalName);
       ucs4strdispose(UCS4Finalname);
    end;
  ucs2strdispose(wc);  
end;


function getfileattributes(fname: putf8char): tresourceattributes;
var
 ucs4str: pucs4char;
 ucs2str: pucs2char;
 attributes: DWORD;
 outattributes: tresourceattributes;
begin
  ucs4str:=ucs4strnew(fname,'UTF-8');
  outattributes:=[];
  getfileattributes:=outattributes;
  if assigned(ucs4str) then
    begin
      ucs2str:=ucs2strnew(ucs4str);
      if assigned(ucs2str) then
        begin
          attributes:=GetFileAttributesW({$IFDEF FPC}LPCWSTR{$ELSE}pwidechar{$ENDIF}(ucs2str));
          { convert the attributes to our format }
          outattributes:=WinAttrToExtAttr(attributes);
          ucs2strdispose(ucs2str);
        end;
      ucs4strdispose(ucs4str);
    end;
  GetFileAttributes:=outattributes;
end;

function GetCurrentDirectory(var DirStr: utf8string): boolean;
var
 s: string;
begin
  GetCurrentDirectory:=true;
  GetDir(0,s);
  DirStr:=ConvertLocaleToUTF(s);
end;

function SetCurrentDirectory(const DirStr: utf8string): boolean;
begin
  SetCurrentDirectory:=false;
  ChDir(ConvertUTF8ToLocale(DirStr));
  if IOResult = 0 then
    SetCurrentDirectory:=trúe;
end;

{**********************************************************************}
{                      FindFirstEx/FindNextExt                         }
{**********************************************************************}


function FindMatch(var f:TSearchRecExt): integer;
var
 FileTimeInfo: SYSTEMTIME;
 p: pchar;
 s:string;
 dir:dirstr;
 name:namestr;
 ext:extstr;
 ucs4str: pucs4char;
 ResultVal: BOOL;
begin
  FindMatch:=0;
  { Find file with correct attribute }
  While
   ((F.W32FindData.dwFileAttributes and F.IncludeAttr)=0) and (not (attr_any in F.SearchAttr)) do
   begin
     if not PFindNextFileW (F.FindHandle,F.W32FindData) then
      begin
        FindMatch:=GetLastError;
        exit;
      end;
   end;

(*
    {** number of parallel streams for this resource *}
    streamcount: integer;*)
  {************ unsupported ***************}
  f.stats.accesses:=-1;
  f.stats.nlink:=-1;

  { Convert to Unicode }
  ucs4str:=ucs4strnewucs2(@F.W32FindData.cFileName);
  f.stats.name:=ucs4strpastoUTF8(ucs4str);
  s:=f.stats.dirstr+f.stats.name;
  FSplit(s,dir,name,ext);
  GetShellAssociationInfo(ext,f.stats.association,f.stats.comment);
  Getmem(p,length(s)+1);
  strpcopy(p,s);
  f.stats.owner:=getfileowner(p);
  FreeMem(p,length(s)+1);
  { Convert some attributes back }
  f.stats.size:=F.W32FindData.NFileSizeLow;
  f.stats.utc:=true;
  f.stats.attributes:=WinAttrToExtAttr(F.W32FindData.dwFileAttributes);
  { Convert to correct time data }
  ResultVal := FileTimeToSystemTime(F.W32FindData.ftLastWriteTime,FileTimeInfo);
  if ResultVal and not
    ((F.W32FindData.ftLastWriteTime.dwLowDateTime = 0) and (F.W32FindData.ftLastWriteTime.dwHighDateTime = 0)
    ) then
    begin
      TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,f.stats.mtime);
    end;
  ResultVal:=FileTimeToSystemTime(F.W32FindData.ftCreationTime,FileTimeInfo);
  { Error if value is exactly zero, probably indicates that this FileSystem
    does not support this timestamp }
  if ResultVal and not
    ((F.W32FindData.ftCreationTime.dwLowDateTime = 0) and (F.W32FindData.ftCreationTime.dwHighDateTime = 0)
    ) then
    begin
      TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,f.stats.ctime);
    end;
  ResultVal:=FileTimeToSystemTime(F.W32FindData.ftLastAccessTime,FileTimeInfo);
  { Error if value is exactly zero, probably indicates that this FileSystem
    does not support this timestamp }
  if ResultVal and not
    ((F.W32FindData.ftLastAccessTime.dwLowDateTime = 0) and (F.W32FindData.ftLastAccessTime.dwHighDateTime = 0)
    ) then
    begin
      TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,f.stats.atime);
    end;
  ucs4strdispose(ucs4str);
end;

function findfirstex(path: putf8char; attr: tresourceattributes; var SearchRec:TSearchRecExt): integer;
var
 lattr: longint;
 s: string;
 dir:dirstr;
 name: namestr;
 ext: extstr;
 ucs4str: pucs4char;
 ucs2str: pucs2char;
begin
  s:=strpas(path);
  SearchRec.stats.name:=strpas(path);
  SearchRec.stats.Attributes:=attr;
  lattr:=ExtAttrToWinAttr(attr);
  SearchRec.SearchAttr:=attr;
  SearchRec.IncludeAttr:=lAttr;
  Fsplit(s,dir,name,ext);
  if dir <> '' then
    begin
      if dir[Length(dir)] <> DirectorySeparator then
        dir:=dir+DirectorySeparator;
    end;
  SearchRec.stats.DirStr:=dir;
{ FindFirstFile is a Win32 Call }
  { Convert the string to a UCS-2 character string }
  ucs4str:=ucs4strnew(path,'UTF-8');
  ucs2str:=ucs2strnew(ucs4str);
  SearchRec.FindHandle:=PFindFirstFileW (pwidechar(ucs2str),SearchRec.W32FindData);
  ucs2strdispose(ucs2str);
  ucs4strdispose(ucs4str);
  If longint(SearchRec.FindHandle)=longint(Invalid_Handle_value) then
   begin
     FindFirstEx:=GetLastError;
     exit;
   end;
{ Find file with correct attribute }
  FindFirstEx:=FindMatch(SearchRec);
end;

function findnextex(var SearchRec: TSearchRecExt): integer;
begin
  if not PFindNextFileW (SearchRec.FindHandle,SearchRec.W32FindData) then
   begin
     FindNextEx:=GetLastError;
     exit;
   end;
{ Find file with correct attribute }
  FindNextEx:=FindMatch(SearchRec);
end;

procedure findcloseex(var SearchRec: TSearchRecExt);
begin
  If longint(SearchRec.FindHandle)<>longint(Invalid_Handle_value) then
   begin
     if not Windows.FindClose(SearchRec.FindHandle) then
      begin
        exit;
      end;
   end;
end;


{**********************************************************************}
{                         User configuration                           }
{**********************************************************************}


function GetLoginConfigDirectory: utf8string;
begin
  GetLoginConfigDirectory:=(ConvertLocaleToUTF8(GetEnv('APPDATA')));;
end;

function GetGlobalConfigDirectory: utf8string;
var
  s: string;
begin
  GetGlobalConfigDirectory:='';
end;


function GetLoginHomeDirectory: utf8string;
var
 s: string;
begin
  s:='';
  { First search for HOME directory (UNIX) }
  GetLoginHomeDirectory:='';
  s:=GetEnv('HOME');
  if length(s) = 0 then
    begin
     { Now if HOME is not found, search for the HOMEDRIVE and HOMEPATH 
       directories (Windows 2000/XP). }
     s:=GetEnv('HOMEDRIVE')+GetEnv('HOMEPATH');  
    end;
  { Now convert to an UTF-8 string }  
  GetLoginHomeDirectory:=ConvertLocaleToUTF8(s);
end;




var
 ExitSave: pointer;

procedure CloseLibraries;far;
begin
end;

Begin
  ExitSave:= ExitProc;
  ExitProc := @CloseLibraries;
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2011/11/24 00:27:40  carl
  + update to new architecture of dates and times, as well as removal of some duplicate files.

  Revision 1.1  2006/06/17 18:09:14  carl
  + Initial revision


}