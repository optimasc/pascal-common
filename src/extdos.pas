unit extdos;

interface


uses 
   tpautils,
   fpautils,
   dpautils,
   vpautils,
   windows,
   utils,
   unicode,
   dateutil,
   fileio,
   dos;




const
  {** File attribute: The filesystem has encrypted this file. }
  EXTDOS_FILE_ATTR_ENCRYPTED = $00000001;
  {** File attribute: This file is indicated as being a system file }
  EXTDOS_FILE_ATTR_SYSTEM    = $00000002;
  {** File attribute: This file is indicated as being a temporary file
      that can be deleted at any time. }
  EXTDOS_FILE_ATTR_TEMPORARY = $00000004;
  {** File attribute: The filesystem as compressed this file }
  EXTDOS_FILE_ATTR_COMPRESSED = $00000008;
  {** File attribute: The file is actually a device }
  EXTDOS_FILE_ATTR_DEVICE     = $00000010;
  {** File attribute: The file should not be indexed }
  EXTDOS_FILE_ATTR_NOINDEXING = $00000020;
  {** File attribute: The file is actually a directory }
  EXTDOS_FILE_ATTR_DIRECTORY = $00000040;
  {** File attribute: This file is an archive file. }
  EXTDOS_FILE_ATTR_ARCHIVE = $00000080;
  {** File attribute: This file is a hidden file. }
  EXTDOS_FILE_ATTR_HIDDEN = $00000100;
  {** File attribute: This file is a read only file. }
  EXTDOS_FILE_ATTR_READONLY = $00000200;
  

  {** Return code: No error in operation }  
  EXTDOS_STATUS_OK = 0;
  {** Return code: This routine is unsupported on this operating system. }
  EXTDOS_STATUS_UNSUPPORTED = -1;
  {** Return code: Conversion operation from native date to TDateTime was invalid. }
  EXTDOS_STATUS_DATE_CONVERT_ERROR = -2;
  

{** @abstract(Returns the file owner name)

    This routine returns the owner/creator of this resource. This 
    is usually the user name when the user logged on to the system. 
    If this routine is not supported, or if there was an error, this 
    routine returns an empty string.
    
    @param(fname The filename to access (UTF-8 encoded))
}    
function getfileowner(fname: putf8char): utf8string;

{** @abstract(Returns the last access date and time of a file) 

   This returns the last access time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file access date in UTC/GMT format)
}
function getfileatime(fname: putf8char; var atime: TDateTime): integer;

{** @abstract(Returns the last modification date and time of a file) 

   This returns the last modification time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file modification date in UTC/GMT format)
}
function getfilemtime(fname: putf8char; var mtime: TDateTime): integer;

{** @abstract(Returns the creation date and time of a file) 

   This returns the creation time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file creation date in UTC/GMT format)
}
function getfilectime(fname: putf8char; var ctime: TDateTime): integer;

{** @abstract(Returns the size of a file).

   @returns(If error returns big_integer_t(-1), otherwise
     the size of the file is returned.)
}  
function getfilesize(fname: putf8char): big_integer_t;


implementation

const
 {** Maximum length of unicode buffers }
 MAX_UNICODE_BUFSIZE = 63;

var
  AdvApi32Handle: HMODULE;
  
  
type

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



function getfileatime(fname: putf8char; var atime: TDateTime): integer;
var
  ResultVal: BOOL;
  LastAccessTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
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
  CreationTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
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
  ModificationTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
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
  DomaineNameLen: ULONG;
  DomainName: array[0..MAX_UNICODE_BUFSIZE-1] of widechar;
  FinalUserName: array[0..MAX_UNICODE_BUFSIZE-1] of ucs4char;
  peUse: SID_NAME_USE;
  resultval: BOOL;
  p: pointer;
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
       DomaineNameLen:= MAX_UNICODE_BUFSIZE;
       GetMem(AccountName,MAX_UNICODE_BUFSIZE);
       p:=GetProcAddress(AdvApi32Handle,'LookupAccountSidW');
       if assigned(p) then
         begin
          pLookupAccountSidW:=tLookupAccountSidW(p);
          resultval:=pLookupAccountSidW(nil,sidowner,AccountName,AccountNameLen,
             DomainName,DomaineNameLen,peUse);
          status:=GetLastError;
          if resultval then
            begin
              { Convert the value to an UTF-8 string }
              for i:=0 to MAX_UNICODE_BUFSIZE-1 do
                Begin
                  FinalUserName[i]:=ucs4char(word(AccountName[i]));
                end;
              getfileowner:=ucs4strpastoUTF8(pucs4char(@FinalUserName[0]));
            end;
         end;
       Freemem(AccountName,MAX_UNICODE_BUFSIZE);
    end;
  if assigned(ppSecurityDescriptor) then
    LocalFree(HLOCAL(ppSecurityDescriptor));
end;

function SetFileTime(hFile: THandle;
  lpCreationTime, lpLastAccessTime, lpLastWriteTime: PFileTime): BOOL; stdcall;
        external 'kernel32' name 'SetFileTime';


function setfileatime(fname: putf8char; newatime: tdatetime): integer;
var
  ResultVal: BOOL;
  LastAccessTime: FILETIME;
  F: File;
  status: integer;
  FileTimeInfo: SYSTEMTIME;
begin
  FileAssign(F,fname);
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfileatime:=status;
      exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      setfileatime:=status;
      exit;
    end;
  DecodeDateTime(newatime, FileTimeInfo.wYear, 
    FileTimeInfo.wMonth, FileTimeInfo.wDay, 
    FileTimeInfo.wHour, FileTimeInfo.wMinute, 
    FileTimeInfo.wSecond, FileTimeInfo.wMilliSeconds);
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
  FileClose(F);
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
  FileReset(F,fmOpenRead);
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
  FileReset(F,fmOpenRead);
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


(*
function getfileattributes(fname: putf8char): longint;
var
 ucs4str: pucs4char;
 ucs2str: pucs2char;
 index: integer;
 attributes: DWORD;
 outattributes: longint;
begin
  ucs4str:=ucs4strnew(fname,'UTF-8');
  outattributes:=0;
  getfileattributes:=outattributes;
  if assigned(ucs4str) then
    begin
      ucs2str:=ucs2strnew(ucs4str);
      if assigned(ucs2str) then
        begin
          attributes:=GetFileAttributesW(ucs2str);
          { convert the attributes to our format }
          {outattributes:=         }
          ucs2strdispose(ucs2str);
        end;
      ucs4strdispose(ucs4str);
    end;
end;*)


(*
function getlinkcount(fname: putf8char): integer;

function getfileaccesses(fname: putf8char): integer;

function getfilestreamcount(fname: putf8char): integer;
*)
var
 ExitSave: pointer;

procedure CloseLibraries;far;
begin
  ExitProc := ExitSave;
  { Close down the library if it is required }
  if assigned(@AdvApi32Handle) then
    FreeLibrary(AdvApi32Handle);
end;


Begin
  ExitSave:= ExitProc;
  ExitProc := @CloseLibraries;
  AdvApi32Handle:=LoadLibrary('advapi32.dll');
  
end.
