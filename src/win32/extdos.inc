

uses strings,shfolder;

const


 {** Maximum length of unicode buffers }
 MAX_UNICODE_BUFSIZE = 63;
 MAX_PATH = 255;

    FILE_ATTRIBUTE_READONLY             =$00000001;
    FILE_ATTRIBUTE_HIDDEN               =$00000002;
    FILE_ATTRIBUTE_SYSTEM               =$00000004;
    FILE_ATTRIBUTE_DIRECTORY            =$00000010;
    FILE_ATTRIBUTE_ARCHIVE              =$00000020;
    FILE_ATTRIBUTE_DEVICE               =$00000040;
    FILE_ATTRIBUTE_NORMAL               =$00000080;
    FILE_ATTRIBUTE_TEMPORARY            =$00000100;
    FILE_ATTRIBUTE_SPARSE_FILE          =$00000200;
    FILE_ATTRIBUTE_REPARSE_POINT        =$00000400;
    FILE_ATTRIBUTE_COMPRESSED           =$00000800;
    FILE_ATTRIBUTE_OFFLINE              =$00001000;
    FILE_ATTRIBUTE_NOT_CONTENT_INDEXED  =$00002000;
    FILE_ATTRIBUTE_ENCRYPTED            =$00004000;
    
    ASSOCF_INIT_NOREMAPCLSID = $00000001;
    ASSOCF_INIT_BYEXENAME = $00000002;
    ASSOCF_OPEN_BYEXENAME = $00000002;
    ASSOCF_INIT_DEFAULTTOSTAR = $00000004;
    ASSOCF_INIT_DEFAULTTOFOLDER = $00000008;
    ASSOCF_NOUSERSETTINGS = $00000010;
    ASSOCF_NOTRUNCATE = $00000020;
    ASSOCF_VERIFY = $00000040;
    ASSOCF_REMAPRUNDLL = $00000080;
    ASSOCF_NOFIXUPS = $00000100;
    ASSOCF_IGNOREBASECLASS = $00000200;
    

    { Constants used with SHGetFolderPath routines }
    SHGFP_TYPE_CURRENT  = 0;   { current value for user, verify it exists }
    SHGFP_TYPE_DEFAULT  = 1;   { default value, may not exist }


var
  AdvApi32Handle: HMODULE;
  NetApi32Handle: HMODULE;
  ShlWApiHandle:  HMODULE;


  

type
    
   _USER_INFO_2 = packed record
     usri2_name: pucs2char;
     usri2_password: pucs2char;
     usri2_password_age: DWORD;
     usri2_priv: DWORD;
     usri2_home_dir: pucs2char;
     usri2_comment: pucs2char;
     usri2_flags: DWORD;
     usri2_script_path: pucs2char;
     usri2_auth_flags: DWORD;
     usri2_full_name: pucs2char;
     usri2_usr_comment: pucs2char;
     usri2_parms: pucs2char;
     usri2_workstations: pucs2char;
     usri2_last_logon: DWORD;
     usri2_last_logoff: DWORD;
     usri2_acct_expires: DWORD;
     usri2_max_storage: DWORD;
     usri2_units_per_week: DWORD;
     usri2_logon_hours: pchar;
     usri2_bad_pw_count: DWORD;
     usri2_num_logons: DWORD;
     usri2_logon_server: pucs2char;
     usri2_country_code: DWORD;
     usri2_code_page: DWORD;
   end;

   P_USER_INFO_2 = ^_USER_INFO_2;


  SE_OBJECT_TYPE = ( 
    SE_UNKNOWN_OBJECT_TYPE,
    SE_FILE_OBJECT,
    SE_SERVICE,
    SE_PRINTER,
    SE_REGISTRY_KEY,
    SE_LMSHARE,
    SE_KERNEL_OBJECT,
    SE_WINDOW_OBJECT,
    SE_DS_OBJECT,
    SE_DS_OBJECT_ALL,
    SE_PROVIDER_DEFINED_OBJECT,
    SE_WMIGUID_OBJECT
  );
  
  PPSID = ^PSID;
  

   tgetnamedsecurityinfo = function (pObjectName: PAnsiChar; ObjectType: SE_OBJECT_TYPE;
         SecurityInfo: SECURITY_INFORMATION; ppsidOwner, ppsidGroup: PPSID; ppDacl, ppSacl: PACL;
         var ppSecurityDescriptor: PSECURITY_DESCRIPTOR): DWORD; stdcall;
   tlookupaccountsidw = function (lpSystemName: PWideChar; Sid: PSID;
       Name: PWideChar; var cbName: DWORD; ReferencedDomainName: PWideChar;
       var cbReferencedDomainName: DWORD; var peUse: SID_NAME_USE): BOOL; stdcall;

   tnetusergetinfo = function (servername: pwidechar;
     username: pwidechar; level: DWORD; var buffer: P_USER_INFO_2): DWORD; stdcall;
  
  

     
     
   ASSOCF = DWORD;
   
   ASSOCSTR =  (
    ASSOCSTR_NONE,
    ASSOCSTR_COMMAND,
    ASSOCSTR_EXECUTABLE,
    ASSOCSTR_FRIENDLYDOCNAME,
    ASSOCSTR_FRIENDLYAPPNAME,
    ASSOCSTR_NOOPEN,
    ASSOCSTR_SHELLNEWVALUE,
    ASSOCSTR_DDECOMMAND,
    ASSOCSTR_DDEIFEXEC,
    ASSOCSTR_DDEAPPLICATION,
    ASSOCSTR_DDETOPIC
   );
   
   
{WINSHLWAPI HRESULT WINAPI AssocQueryStringA(ASSOCF,ASSOCSTR,LPCSTR,LPCSTR,LPSTR,DWORD*);
WINSHLWAPI HRESULT WINAPI AssocQueryStringByKeyA(ASSOCF,ASSOCSTR,HKEY,LPCSTR,LPSTR,DWORD*);
WINSHLWAPI HRESULT WINAPI AssocQueryStringByKeyW(ASSOCF,ASSOCSTR,HKEY,LPCWSTR,LPWSTR,DWORD*);
WINSHLWAPI HRESULT WINAPI AssocQueryStringW(ASSOCF,ASSOCSTR,LPCWSTR,LPCWSTR,LPWSTR,DWORD*);}
   

   tassocquerystring = function (
     flasgd: ASSOCF;
     str: DWORD; pszAssoc: pucs2char; pszExtra: pucs2char;
     pszOut: pucs2char; var pcchout: DWORD):HRESULT; stdcall;        
     
     
{**************************************************************************}

{ Convert Windows attributes to our pascal format of attributes }
function WinAttrToExtAttr(dwAttributes: DWORD): TResourceAttributes;
var
  Attributes: TResourceAttributes;
begin
  Attributes:=[];
  if (dwAttributes and FILE_ATTRIBUTE_READONLY)<>0 then
    Include(Attributes, attr_readonly);
  if (dwAttributes and FILE_ATTRIBUTE_HIDDEN)<>0 then
    Include(Attributes, attr_hidden);
  if (dwAttributes and FILE_ATTRIBUTE_SYSTEM)<>0 then
    Include(Attributes, attr_system);
  if (dwAttributes and FILE_ATTRIBUTE_ARCHIVE)<>0 then
    Include(Attributes, attr_archive);
  if (dwAttributes and FILE_ATTRIBUTE_DEVICE)<>0 then
    Include(Attributes, attr_device);
  if (dwAttributes and FILE_ATTRIBUTE_DIRECTORY)<>0 then
    Include(Attributes, attr_directory);
  if (dwAttributes and FILE_ATTRIBUTE_ENCRYPTED)<>0 then
    Include(Attributes, attr_encrypted);
  if (dwAttributes and FILE_ATTRIBUTE_TEMPORARY)<>0 then
    Include(Attributes, attr_temporary);
  if (dwAttributes and FILE_ATTRIBUTE_REPARSE_POINT)<>0 then
    Include(Attributes, attr_extended);
  if (dwAttributes and FILE_ATTRIBUTE_COMPRESSED)<>0 then
    Include(Attributes, attr_compressed);
  if (dwAttributes and FILE_ATTRIBUTE_NOT_CONTENT_INDEXED)<>0 then
    Include(Attributes, attr_no_indexing);
  if (dwAttributes and FILE_ATTRIBUTE_OFFLINE)<>0 then
    Include(Attributes, attr_offline);
  if (dwAttributes and FILE_ATTRIBUTE_SPARSE_FILE)<>0 then
    Include(Attributes, attr_sparse);
  if (dwAttributes = FILE_ATTRIBUTE_NORMAL) then
    Attributes:=[];
  WinAttrToExtAttr:=attributes;
end;

{ Convert our attribute format to Windows attributes }
function ExtAttrToWinAttr(attr: TResourceAttributes): DWORD;
var
 dwAttr: DWORD;
begin
  dwAttr:=0;
  if attr_readonly in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_READONLY;
  if attr_hidden in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_HIDDEN;
  if attr_system in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_SYSTEM;
  if attr_archive in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_ARCHIVE;
  if attr_device in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_DEVICE;
  if attr_directory in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_DIRECTORY;
  if attr_encrypted in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_ENCRYPTED;
  if attr_temporary in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_TEMPORARY;
  if attr_extended in attr then
    dwAttr:=dwAttr or  FILE_ATTRIBUTE_REPARSE_POINT;
  if attr_compressed in attr then
    dwAttr:=dwAttr or  FILE_ATTRIBUTE_COMPRESSED;
  if attr_no_indexing in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_NOT_CONTENT_INDEXED;
  if attr_offline in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_OFFLINE;
  if attr_sparse in attr then
    dwAttr:=dwAttr or FILE_ATTRIBUTE_SPARSE_FILE;
  if attr = [] then
    dwAttr:=FILE_ATTRIBUTE_NORMAL;
  ExtAttrToWinAttr:=dwAttr;
end;

procedure GetShellAssociationInfo(const ext: utf8string; var assoc: TFileAssociation;
  var comment: utf8string);
var
 p: pointer;
 passocquerystring: tassocquerystring;
 FinalName: pucs2char;
 UCS4FinalName: pucs4char;
 count: DWORD;
 pucs4: pucs4char;
 pucs2: pucs2char;
 resulth: HRESULT;
begin  
   fillchar(assoc,sizeof(assoc),#0);
   comment:='';
   p:=(GetProcAddress(ShlwApiHandle,'AssocQueryStringW'));
   PAssocQueryString:=tassocquerystring(p);
   if assigned(p) then
     begin
      count:=MAX_PATH;
      Getmem(FinalName, MAX_PATH*sizeof(ucs2char)+sizeof(ucs2char));
      pucs4:=ucs4strnewstr(ext,'UTF-8');
      pucs2:=ucs2strnew(pucs4);
      ucs4strdispose(pucs4);

      resulth:=passocquerystring(ASSOCF_REMAPRUNDLL,DWORD(ASSOCSTR_FRIENDLYAPPNAME),
        pucs2,nil,FinalName,count);
      if resulth = 0 then
        begin
          UCS4FinalName:=ucs4strnewucs2(FinalName);
          assoc.appname:=ucs4strpastoUTF8(UCS4FinalName);
          ucs4strdispose(UCS4FinalName);
        end;
      count:=MAX_PATH;
      resulth:=passocquerystring(ASSOCF_REMAPRUNDLL,DWORD(ASSOCSTR_EXECUTABLE),
        pucs2,nil,FinalName,count);
      if resulth = 0 then
        begin
          UCS4FinalName:=ucs4strnewucs2(FinalName);
          assoc.exename:=ucs4strpastoUTF8(UCS4FinalName);
          ucs4strdispose(UCS4FinalName);
        end;
      count:=MAX_PATH;
      resulth:=passocquerystring(ASSOCF_REMAPRUNDLL,DWORD(ASSOCSTR_FRIENDLYDOCNAME),
        pucs2,nil,FinalName,count);
      if resulth = 0 then
        begin
          UCS4FinalName:=ucs4strnewucs2(FinalName);
          comment:=ucs4strpastoUTF8(UCS4FinalName);
          ucs4strdispose(UCS4FinalName);
        end;
      ucs2strdispose(pucs2);
      Freemem(FinalName, MAX_PATH*sizeof(ucs2char)+sizeof(ucs2char));
    end;
end;


{**************************************************************************}


function getfileatime(fname: putf8char; var atime: TDateTime): integer;
var
  ResultVal: BOOL;
{$IFNDEF FPC}  
  LastAccessTime: _FILETIME;
{$ELSE}
  LastAccessTime: FILETIME;
{$ENDIF}
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  atime:=0;
  FileAssign(F,fname);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfileatime:=status;
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfileatime:=status;
      exit;
    end;
  ResultVal:=GetFileTime(FileRec(F).handle,nil,@LastAccessTime,nil);
  if (LastAccessTime.dwLowDateTime = 0) and (LastAccessTime.dwHighDateTime = 0) then
    begin
      getfileatime:=EXTDOS_STATUS_UNSUPPORTED;
      FileClose(F);
      exit;
    end;

  if ResultVal then
    begin
      ResultVal:=FileTimeToSystemTime(LastAccessTime,FileTimeInfo);
      if ResultVal then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,atime) then
             status:=EXTDOS_STATUS_OK
           else
             status:=EXTDOS_STATUS_DATE_CONVERT_ERROR;           
         end
      else
         status:=GetLastError;
    end
  else
    status:=GetLastError;
  getfileatime:=status;
  FileClose(F);
end;


function getfilectime(fname: putf8char; var ctime: TDateTime): integer;
var
  ResultVal: BOOL;
{$IFNDEF FPC}  
  CreationTime: _FILETIME;
{$ELSE}
  CreationTime: FILETIME;
{$ENDIF}
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  ctime:=0;
  FileAssign(F,fname);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilectime:=status;
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilectime:=status;
      exit;
    end;
  ResultVal:=GetFileTime(FileRec(F).handle,@CreationTime,nil,nil);
  if (CreationTime.dwLowDateTime = 0) and (CreationTime.dwHighDateTime = 0) then
    begin
      getfilectime:=EXTDOS_STATUS_UNSUPPORTED;
      FileClose(F);
      exit;
    end;
  if ResultVal then
    begin
      ResultVal:=FileTimeToSystemTime(CreationTime,FileTimeInfo);
      if ResultVal then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,ctime) then
             status:=EXTDOS_STATUS_OK
           else
             status:=EXTDOS_STATUS_DATE_CONVERT_ERROR;
         end
      else
         status:=GetLastError;
    end
  else
    status:=GetLastError;
  getfilectime:=status;
  FileClose(F);
end;

function getfilemtime(fname: putf8char; var mtime: TDateTime): integer;
var
  ResultVal: BOOL;
{$IFDEF FPC}
  ModificationTime: FILETIME;
{$ELSE}
  ModificationTime: _FILETIME;
{$ENDIF}  
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  mtime:=0;
  FileAssign(F,fname);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilemtime:=status;
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilemtime:=status;
      exit;
    end;
  ResultVal:=GetFileTime(FileRec(F).handle,nil,nil,@ModificationTime);
  if (ModificationTime.dwLowDateTime = 0) and (ModificationTime.dwHighDateTime = 0) then
    begin
      getfilemtime:=EXTDOS_STATUS_UNSUPPORTED;
      FileClose(F);
      exit;
    end;
  if ResultVal then
    begin
      ResultVal:=FileTimeToSystemTime(ModificationTime,FileTimeInfo);
      if ResultVal then
         begin
           if TryEncodeDateTime(FileTimeInfo.wYear,FileTimeInfo.wMonth,FileTimeInfo.wDay,
              FileTimeInfo.wHour, FileTimeInfo.wMinute, FileTimeInfo.wSecond,
              FileTimeInfo.wMilliseconds,mtime) then
             status:=EXTDOS_STATUS_OK
           else
             status:=EXTDOS_STATUS_DATE_CONVERT_ERROR;
         end
      else
         status:=GetLastError;
    end
  else
    status:=GetLastError;
  getfilemtime:=status;
  FileClose(F);
end;

function getfileowner(fname: putf8char): utf8string;
var
  PGetNamedSecurityInfo: tgetnamedsecurityinfo;
  PLookupAccountSidw: tlookupaccountsidw;
  sidOwner: PSID;
  ppSecurityDescriptor: PSECURITY_DESCRIPTOR;
  status: DWORD;
  AccountName: pwidechar;
  AccountNameLen: ULONG;
  DomainName: pwidechar;
  DomainNameLen: ULONG;
  FinalUserName: array[0..MAX_UNICODE_BUFSIZE-1] of ucs4char;
  peUse: SID_NAME_USE;
  resultval: BOOL;
  p: pointer;
  s: string;
  i: integer;
begin
  getfileowner:='';
  if not assigned(pointer(AdvApi32Handle)) then exit;
  p:=(GetProcAddress(AdvApi32Handle,'GetNamedSecurityInfoA'));
  PGetNamedSecurityInfo:=tgetnamedsecurityinfo(p);
  if not assigned(p) then exit;
  ppSecurityDescriptor:=nil;
  status:=PGetNamedSecurityInfo(fname, SE_FILE_OBJECT, OWNER_SECURITY_INFORMATION,@sidOwner,nil,nil,nil,ppSecurityDescriptor);
  if status = ERROR_SUCCESS then
    begin
       AccountNameLen:= MAX_UNICODE_BUFSIZE;
       DomainNameLen:=MAX_UNICODE_BUFSIZE;
       GetMem(AccountName,MAX_UNICODE_BUFSIZE*sizeof(widechar)+sizeof(widechar));
       GetMem(DomainName,MAX_UNICODE_BUFSIZE*sizeof(widechar)+sizeof(widechar));
       p:=GetProcAddress(AdvApi32Handle,'LookupAccountSidW');
       if assigned(p) then
         begin
          pLookupAccountSidW:=tLookupAccountSidW(p);
          resultval:=pLookupAccountSidW(nil,sidowner,AccountName,AccountNameLen,
             DomainName,DomainNameLen,peUse);
          status:=GetLastError;
          if resultval then
            begin
              { Convert the value to an UTF-8 string }
              for i:=0 to MAX_UNICODE_BUFSIZE-1 do
                Begin
                  FinalUserName[i]:=ucs4char(word(AccountName[i]));
                end;
              s:=ucs4strpastoUTF8(pucs4char(@FinalUserName[0]));
              { EVERYONE indicates unknown owner }
              if upstring(s) = 'EVERYONE' then
               s:='';
              getfileowner:=s;
            end;
         end;
       FreeMem(AccountName,MAX_UNICODE_BUFSIZE*sizeof(widechar)+sizeof(widechar));
       FreeMem(DomainName,MAX_UNICODE_BUFSIZE*sizeof(widechar)+sizeof(widechar));
    end;
  if assigned(ppSecurityDescriptor) then
    LocalFree(HLOCAL(ppSecurityDescriptor));
end;

function SetFileTime(hFile: THandle;
  lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall;
        external 'kernel32.dll' name 'SetFileTime';


function setfileatime(fname: putf8char; newatime: tdatetime): integer;
const
  FILE_WRITE_ATTRIBUTES = $100;
var
  ResultVal: BOOL;
  LastAccessTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
  security : TSecurityAttributes;
begin
  FileAssign(F,fname);
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
  filerec(f).handle:=CreateFile(fname,FILE_WRITE_ATTRIBUTES,FILE_SHARE_READ,@security,OPEN_EXISTING,FILE_ATTRIBUTE_NORMAL,0);
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


function setfilemtime(fname: putf8char; newmtime: tdatetime): integer;
var
  ResultVal: BOOL;
  LastWriteTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  FileAssign(F,fname);
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


function setfilectime(fname: putf8char; newctime: tdatetime): integer;
var
  ResultVal: BOOL;
  CreationTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  FileAssign(F,fname);
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
  FileAssign(F,fname);
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
  FileAssign(F,fname);
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


function getuserfullname(account: utf8string): utf8string;
var
 p: pointer;
 wc: pucs2char;
 ucs4accountname: pucs4char;
 ui: P_USER_INFO_2;
 pnetusergetinfo: tnetusergetinfo;
 namelength: integer;
 FinalName: pucs2char;
 UCS4FinalName: pucs4char;
 i: integer;
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



{**********************************************************************}
{                      FindFirstEx/FindNextExt                         }
{**********************************************************************}


function FindMatch(var f:TSearchRecExt): integer;
var
 FileTimeInfo: SYSTEMTIME;
 lengthtocopy: integer;
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
     if not FindNextFileW (F.FindHandle,{$ifdef fpc}@{$endif}F.W32FindData) then
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
  s:=f.stats.dirstr+ucs4strpastoUTF8(ucs4str);
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
  f.stats.name:=ucs4strpastoUTF8(ucs4str);
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
  { no error }
  findfirstex:=0;
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
  SearchRec.FindHandle:=FindFirstFileW ({$IFNDEF FPC}pwidechar{$ENDIF}(ucs2str),SearchRec.W32FindData);
  ucs2strdispose(ucs2str);
  ucs4strdispose(ucs4str);
  If longint(SearchRec.FindHandle)=longint(Invalid_Handle_value) then
   begin
     FindFirstEx:=GetLastError;
     exit;
   end;
{ Find file with correct attribute }
  FindMatch(SearchRec);
end;

function findnextex(var SearchRec: TSearchRecExt): integer;
begin
{ no error }
  findnextEx:=0;
  if not FindNextFileW (SearchRec.FindHandle,{$ifdef fpc}@{$endif}SearchRec.W32FindData) then
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

function SHGetFolderPathW(hwnd: HWND; csidl: Integer; hToken: THandle; dwFlags: DWord; pszPath: Pucs2Char): HRESULT; stdcall;
 external 'SHfolder.dll' name 'SHGetFolderPathW';


function GetLoginConfigDirectory: utf8string;
var
 PathValue: pucs2char;
 status: HRESULT;
 ucs4str: pucs4char;
begin
    GetLoginConfigDirectory:='';
    Getmem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
    status:=SHGetFolderPathW(0,CSIDL_APPDATA or CSIDL_FLAG_CREATE,0,SHGFP_TYPE_CURRENT,PathValue);
    if status = S_OK then
      begin
        { Convert to an UCS-4 character string, and then convert to
          an UTF-8 string. }
        ucs4str:=ucs4strnewucs2(PathValue);
        GetLoginConfigDirectory:=ucs4strpastoUTF8(ucs4str);
        ucs4strdispose(ucs4str);
      end;
    FreeMem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
end;

function GetGlobalConfigDirectory: utf8string;
var
 PathValue: pucs2char;
 status: HRESULT;
 ucs4str: pucs4char;
begin
    GetGlobalConfigDirectory:='';
    Getmem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
    status:=SHGetFolderPathW(0,CSIDL_COMMON_APPDATA or CSIDL_FLAG_CREATE,0,SHGFP_TYPE_CURRENT,PathValue);
    if status = S_OK then
      begin
        { Convert to an UCS-4 character string, and then convert to
          an UTF-8 string. }
        ucs4str:=ucs4strnewucs2(PathValue);
        GetGlobalConfigDirectory:=ucs4strpastoUTF8(ucs4str);
        ucs4strdispose(ucs4str);
      end;
    FreeMem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
end;


function GetLoginHomeDirectory: utf8string;
var
 PathValue: pucs2char;
 status: HRESULT;
 ucs4str: pucs4char;
begin
    GetLoginHomeDirectory:='';
    Getmem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
    status:=SHGetFolderPathW(0,CSIDL_PERSONAL or CSIDL_FLAG_CREATE,0,SHGFP_TYPE_CURRENT,PathValue);
    if status = S_OK then
      begin
        { Convert to an UCS-4 character string, and then convert to
          an UTF-8 string. }
        ucs4str:=ucs4strnewucs2(PathValue);
        GetLoginHomeDirectory:=ucs4strpastoUTF8(ucs4str);
        ucs4strdispose(ucs4str);
      end;
    FreeMem(PathValue,(MAX_PATH+1)*sizeof(ucs2char));
end;




var
 ExitSave: pointer;

procedure CloseLibraries;far;
begin
  ExitProc := ExitSave;
  { Close down the library if it is required }
  if assigned(pointer(AdvApi32Handle)) then
    FreeLibrary(AdvApi32Handle);
  { Close down the library if it is required }
  if assigned(pointer(NetApi32Handle)) then
    FreeLibrary(NetApi32Handle);
  if assigned(pointer(ShlWApiHandle)) then
    FreeLibrary(ShlWApiHandle);
end;


Begin
  ExitSave:= ExitProc;
  ExitProc := @CloseLibraries;
  AdvApi32Handle:=LoadLibrary('advapi32.dll');
  NetApi32Handle:=LoadLibrary('netapi32.dll');
  ShlWApiHandle:=LoadLibrary('shlwapi.dll');
end.

{
  $Log: not supported by cvs2svn $
}