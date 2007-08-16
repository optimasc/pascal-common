{
    $Id: doswin32.inc,v 1.6 2007-08-16 02:50:42 carl Exp $
    Copyright (c) 2001 by members of the Free Pascal
    development team

    DOS unit for Kylix/linux

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{$H-}
uses strings;

type
   OSVERSIONINFO = record
        dwOSVersionInfoSize : DWORD;
        dwMajorVersion : DWORD;
        dwMinorVersion : DWORD;
        dwBuildNumber : DWORD;
        dwPlatformId : DWORD;
        szCSDVersion : array[0..127] of char;
     end;

   LPOSVERSIONINFO = ^OSVERSIONINFO;


{******************************************************************************
                           --- Conversion ---
******************************************************************************}


type
  Longrec=packed record
    lo,hi : word;
  end;

function Last2DosError(d:dword):integer;
begin
  case d of
    87 : { Parameter invalid -> Data invalid }
      Last2DosError:=13;
    else
      Last2DosError:=d;
  end;
end;


Function DosToWinAttr (Const Attr : Longint) : longint;
begin
  DosToWinAttr:=Attr;
end;


Function WinToDosAttr (Const Attr : Longint) : longint;
begin
  WinToDosAttr:=Attr;
end;


Function DosToWinTime (DTime:longint;Var Wtime : TFileTime):longbool;
var
  lft : TFileTime;
begin
  DosToWinTime:=DosDateTimeToFileTime(longrec(dtime).hi,longrec(dtime).lo,lft) and
                LocalFileTimeToFileTime(lft,Wtime);
end;


Function WinToDosTime (Const Wtime : TFileTime;var DTime:longint):longbool;
var
  lft : TFileTime;
begin
  WinToDosTime:=FileTimeToLocalFileTime(WTime,lft) and
                FileTimeToDosDateTime(lft,longrec(dtime).hi,longrec(dtime).lo);
end;


{******************************************************************************
                           --- Dos Interrupt ---
******************************************************************************}

procedure intr(intno : byte;var regs : registers);
begin
  { !!!!!!!! }
end;

procedure msdos(var regs : registers);
begin
  { !!!!!!!! }
end;


{******************************************************************************
                        --- Info / Date / Time ---
******************************************************************************}


function dosversion : word;
begin
  { only keep version number }
  dosversion:=GetVersion and $ffff;
end;


procedure getdate(var year,month,mday,wday : word);
var
  t : TSystemTime;
begin
  GetLocalTime(t);
  year:=t.wYear;
  month:=t.wMonth;
  mday:=t.wDay;
  wday:=t.wDayOfWeek;
end;


procedure setdate(year,month,day : word);
var
  t : TSystemTime;
begin
  { we need the time set privilege   }
  { so this function crash currently }
  {!!!!!}
  GetLocalTime(t);
  t.wYear:=year;
  t.wMonth:=month;
  t.wDay:=day;
  { only a quite good solution, we can loose some ms }
  SetLocalTime(t);
end;


procedure gettime(var hour,minute,second,sec100 : word);
var
  t : TSystemTime;
begin
   GetLocalTime(t);
   hour:=t.wHour;
   minute:=t.wMinute;
   second:=t.wSecond;
   sec100:=t.wMilliSeconds div 10;
end;


procedure settime(hour,minute,second,sec100 : word);
var
   t : TSystemTime;
begin
   { we need the time set privilege   }
   { so this function crash currently }
   {!!!!!}
   GetLocalTime(t);
   t.wHour:=hour;
   t.wMinute:=minute;
   t.wSecond:=second;
   t.wMilliSeconds:=sec100*10;
   SetLocalTime(t);
end;


Procedure packtime(var t : datetime;var p : longint);
Begin
  p:=(t.sec shr 1)+(t.min shl 5)+(t.hour shl 11)+(t.day shl 16)+(t.month shl 21)+((t.year-1980) shl 25);
End;


Procedure unpacktime(p : longint;var t : datetime);
Begin
  with t do
   begin
     sec:=(p and 31) shl 1;
     min:=(p shr 5) and 63;
     hour:=(p shr 11) and 31;
     day:=(p shr 16) and 31;
     month:=(p shr 21) and 15;
     year:=(p shr 25)+1980;
   end;
End;


{******************************************************************************
                               --- Exec ---
******************************************************************************}

var
  lastdosexitcode : longint;

procedure exec(const path : pathstr;const comline : comstr);
var
  SI: TStartupInfo;
  PI: TProcessInformation;
  CommandLine : array[0..1023] of char;
  AppParam : array[0..255] of char;
  pathlocal : string;
  lw: longword;
begin
  DosError := 0;
  FillChar(SI, SizeOf(SI), 0);
  FillChar(PI, SizeOf(PI), 0);
  SI.cb:=SizeOf(SI);
  SI.wShowWindow:=1;
  { always surroound the name of the application by quotes
    so that long filenames will always be accepted. But don't
    do it if there are already double quotes, since Win32 does not
    like double quotes which are duplicated!
  }
  if pos('"',path) = 0 then
    pathlocal:='"'+path+'"'
  else
    pathlocal := path;
  Move(Pathlocal[1],CommandLine,length(Pathlocal));

  AppParam[0]:=' ';
  AppParam[1]:=' ';
  Move(ComLine[1],AppParam[2],length(Comline));
  AppParam[Length(ComLine)+2]:=#0;
  { concatenate both pathnames }
  Move(Appparam[0],CommandLine[length(Pathlocal)],strlen(Appparam)+1);
  if not CreateProcessA(nil, pchar(@CommandLine),
           Nil, Nil, ExecInheritsHandles,
           NORMAL_PRIORITY_CLASS,
           Nil, Nil, SI, PI) then
   begin
     DosError:=Last2DosError(GetLastError);
     exit;
   end;
  if WaitForSingleObject(PI.hProcess, dword(Infinite)) <> WAIT_FAILED then
    GetExitCodeProcess(PI.hProcess,lw)
  else
    lw:=longword(-1);
  CloseHandle(PI.HProcess);
  CloseHandle(PI.hThread);
  LastDosExitCode:=longint(lw);
end;


function dosexitcode : word;
begin
  dosexitcode:=lastdosexitcode and $ffff;
end;


procedure getcbreak(var breakvalue : boolean);
begin
{ !! No Win32 Function !! }
  breakvalue := true;
end;


procedure setcbreak(breakvalue : boolean);
begin
{ !! No Win32 Function !! }
end;


procedure getverify(var verify : boolean);
begin
{ !! No Win32 Function !! }
 verify := true;
end;


procedure setverify(verify : boolean);
begin
{ !! No Win32 Function !! }
end;


{******************************************************************************
                               --- Disk ---
******************************************************************************}

   function GetDiskFreeSpaceA(drive:pchar;var sector_cluster,bytes_sector,
                             freeclusters,totalclusters:longword):BOOL;
     external 'kernel32.dll' name 'GetDiskFreeSpaceA';
type
   TGetDiskFreeSpaceExA = function (lpDirectoryName: PAnsiChar;
  var lpFreeBytesAvailableToCaller, lpTotalNumberOfBytes, lpTotalNumberOfFreeBytes): BOOL; stdcall;


var
   GetDiskFreeSpaceExA : TGetDiskFreeSpaceExA;

function diskfree(drive : byte) : int64;
var
  disk : array[1..4] of char;
  secs,bytes,
  free,total : longword;
  qwtotal,qwfree,qwcaller : int64;


begin
  if drive=0 then
   begin
     disk[1]:='\';
     disk[2]:=#0;
   end
  else
   begin
     disk[1]:=chr(drive+64);
     disk[2]:=':';
     disk[3]:='\';
     disk[4]:=#0;
   end;
  if assigned(GetDiskFreeSpaceExA) then
    begin
       if GetDiskFreeSpaceExA(@disk,qwcaller,qwtotal,qwfree) then
         diskfree:=qwfree
       else
         diskfree:=-1;
    end
  else
    begin
       if GetDiskFreeSpace(@disk,secs,bytes,free,total) then
         diskfree:=int64(free)*secs*bytes
       else
         diskfree:=-1;
    end;
end;


function disksize(drive : byte) : int64;
var
  disk : array[0..3] of char;
  p: pchar;
  secs,bytes,
  free,total : longword;
  qwtotal,qwfree,qwcaller : TLargeInteger;

begin
  if drive=0 then
   begin
     p:=nil;
   end
  else
   begin
     disk[0]:=chr(drive+64);
     disk[1]:=':';
     disk[2]:='\';
     disk[3]:=#0;
     p:=disk;
   end;
  if assigned(GetDiskFreeSpaceExA) then
    begin
       if GetDiskFreeSpaceExA(p,qwcaller,qwtotal,qwfree) then
         disksize:=qwtotal
       else
         disksize:=-1;
    end
  else
    begin
       if GetDiskFreeSpaceA(p,secs,bytes,free,total) then
         disksize:=int64(total)*secs*bytes
       else
         disksize:=-1;
    end;
end;


{******************************************************************************
                         --- Findfirst FindNext ---
******************************************************************************}

{ Needed kernel calls }


Procedure StringToPchar (Var S : String);
Var L : Longint;
    idx: integer;
begin
  l:=length(s);
  for idx:=0 to l do
    s[idx+1]:=s[idx];
  S[L]:=#0;
end;

Procedure PCharToString (Var S : String);
Var L : Longint;
begin
  L:=strlen(pchar(@S[0]));
  Move (S[0],S[1],L);
  S[0]:=char(l);
end;


procedure FindMatch(var f:searchrec);
begin
{ Find file with correct attribute }
  While (F.W32FindData.dwFileAttributes and F.ExcludeAttr)<>0 do
   begin
     if not FindNextFile (F.FindHandle,F.W32FindData) then
      begin
        DosError:=Last2DosError(GetLastError);
        if DosError=2 then
         DosError:=18;
        exit;
      end;
   end;
{ Convert some attributes back }
  if (longword(F.W32FindData.NFileSizeLow)) > (longword(high(longint))) then
    f.size:=high(longint)
  else
    f.size:=longint(F.W32FindData.NFileSizeLow);
  f.attr:=WinToDosAttr(F.W32FindData.dwFileAttributes);
  WinToDosTime(F.W32FindData.ftLastWriteTime,f.Time);
  f.Name:=StrPas(F.W32FindData.cFileName);
end;


procedure findfirst(const path : pathstr;attr : word;var f : searchRec);
var
 pFileName: array[0..MAX_PATH-1] of char;
begin
{ no error }
  doserror:=0;
  F.Name:=Path;
  F.Attr:=attr;
  F.ExcludeAttr:=(not Attr) and ($1e); {hidden,sys,dir,volume}
  fillchar(pFileName,sizeof(pFileName),#0);
  strpcopy(pFileName,path);
{ FindFirstFile is a Win32 Call }
  F.FindHandle:=FindFirstFile (pFileName,F.W32FindData);
  If longint(F.FindHandle)=longint(Invalid_Handle_value) then
   begin
     DosError:=Last2DosError(GetLastError);
     if DosError=2 then
      DosError:=18;
     exit;
   end;
{ Find file with correct attribute }
  FindMatch(f);
end;


procedure findnext(var f : searchRec);
begin
{ no error }
  doserror:=0;
  if not FindNextFile (F.FindHandle,F.W32FindData) then
   begin
     DosError:=Last2DosError(GetLastError);
     if DosError=2 then
      DosError:=18;
     exit;
   end;
{ Find file with correct attribute }
  FindMatch(f);
end;


procedure swapvectors;
begin
end;


Procedure FindClose(Var f: SearchRec);
begin
  DosError:=0;
  If longint(F.FindHandle)<>longint(Invalid_Handle_value) then
   begin
     if not Windows.FindClose(F.FindHandle) then
      begin
        DosError:=Last2DosError(GetLastError);
        exit;
      end;
   end;
end;


{******************************************************************************
                               --- File ---
******************************************************************************}

   function GetFileTime(h : longint;creation,lastaccess,lastwrite : PFileTime) : longbool;
     external 'kernel32.dll' name 'GetFileTime';
   function SetFileTime(h : longint;creation,lastaccess,lastwrite : PFileTime) : longbool;
     external 'kernel32.dll' name 'SetFileTime';
   function GetFileAttributes(lpFileName : pchar) : longint;
     external 'kernel32.dll' name 'GetFileAttributesA';

const 
  ExtensionSeparator = '.';
  
Procedure FSplit (Path: PathStr; var Dir: DirStr; var Name: NameStr; var Ext: ExtStr);
var
  DirEnd, ExtStart: Longint;
const
 DirectorySeparator = '\';
 DriveSeparator = ':';
 LFNSupport = true;  
begin
  {** Remove Double quote characters **}
  if path[length(path)] = '"' then
   delete(path,length(path),1);
  if path[1] = '"' then
   delete(path,1,1);

  if DirectorySeparator = '/' then
  { allow backslash as slash }
    for DirEnd := 1 to Length (Path) do
      begin
        if Path [DirEnd] = '\' then Path [DirEnd] := DirectorySeparator
      end
  else
    if DirectorySeparator = '\' then
    { allow slash as backslash }
      for DirEnd := 1 to Length (Path) do
        if Path [DirEnd] = '/' then Path [DirEnd] := DirectorySeparator;

{ Find the first DirectorySeparator or DriveSeparator from the end. }
  DirEnd := Length (Path);
{ Avoid problems with platforms having DriveSeparator = DirectorySeparator. }
  if DirectorySeparator = DriveSeparator then
   while (DirEnd > 0) and (Path [DirEnd] <> DirectorySeparator) do
    Dec (DirEnd)
  else
   while (DirEnd > 0) and
                 (Path [DirEnd] <> DirectorySeparator) and
                                           (Path [DirEnd] <> DriveSeparator) do
    Dec (DirEnd);

{ The first "extension" should be returned if LFN }
{ support not available, the last one otherwise.  }
  if LFNSupport then
    begin
      ExtStart := Length (Path);
      while (ExtStart > DirEnd) and (Path [ExtStart] <> ExtensionSeparator) do
        Dec (ExtStart);
      if ExtStart = 0 then
        ExtStart := Length (Path) + 1
      else
        if Path [ExtStart] <> ExtensionSeparator then
          ExtStart := Length (Path) + 1;
    end
  else
    begin
      ExtStart := DirEnd + 1;
      while (ExtStart <= Length (Path)) and (Path [ExtStart] <> ExtensionSeparator) do
        Inc (ExtStart);
    end;

  Dir := Copy (Path, 1, DirEnd);
  Name := Copy (Path, DirEnd + 1, ExtStart - DirEnd - 1);
  Ext := Copy (Path, ExtStart, Length (Path) - ExtStart + 1);
end;


{ <immobilizer> }

function GetFullPathName(lpFileName: PChar; nBufferLength: Longint; lpBuffer: PChar; var lpFilePart : PChar):DWORD;
    external 'kernel32.dll' name 'GetFullPathNameA';

function GetShortPathName(lpszLongPath:pchar; lpszShortPath:pchar; cchBuffer:DWORD):DWORD;
    external 'kernel32.dll' name 'GetShortPathNameA';


(*
function FExpand (const Path: PathStr): PathStr;
- declared in fexpand.inc
*)

{$DEFINE FPC_FEXPAND_UNC} (* UNC paths are supported *)
{$DEFINE FPC_FEXPAND_DRIVES} (* Full paths begin with drive specification *)

const
  LFNSupport = true;
  FilenamecaseSensitive = false;
  DirectorySeparator = '\';
  DriveSeparator = ':';

{$I fexpand.inc}

{$UNDEF FPC_FEXPAND_DRIVES}
{$UNDEF FPC_FEXPAND_UNC}


  function SearchPath(lpPath : PChar; lpFileName : PChar; lpExtension : PChar; nBufferLength : Longint; lpBuffer : PChar;
    var lpFilePart : PChar) : Longint; external 'kernel32.dll' name 'SearchPathA';

Function FSearch(path: pathstr; dirlist: string): pathstr;
var temp        : PChar;
    value       : Array [0..255] of char;
    i           : Longint;
    dir,dir2    : dirstr;
    lastchar    : char;
    name        : namestr;
    ext         : extstr;
    s           : SearchRec;
    found       : boolean;
begin
{ check if the file specified exists }
  findfirst(path,anyfile,s);
  found:=(doserror=0);
  findclose(s);
  if found then
   begin
     fsearch:=path;
     exit;
   end;
{ search the path }
  fsearch:='';
  for i:=1 to length(path) do
   if path[i]='/' then
    path[i]:='\';
  fsplit(path,dir,name,ext);
  for i:=1 to length(dirlist) do
   if dirlist[i]='/' then
    dirlist[i]:='\';
  { bugfix here : Win98SE returns a path, when the name is NULL! }
  { so if the name of the file to search is '' then simply exit  }
  { immediately (WinNT behavior is correct).                     }
  if name='' then
    exit;

  { allow slash as backslash }
  StringToPchar(name);
  StringToPchar(ext);

  StringToPchar(dir);
  if SearchPath(@dir, @name, @ext, 255, @value, temp)>0 then
    begin
      fsearch := strpas(value);
      exit;
    end;
  PCharToString(dir);

  repeat
    i:=pos(';',dirlist);
    while i=1 do
      begin
        delete(dirlist,1,1);
        i:=pos(';',dirlist);
      end;
    if i=0 then
      begin
        dir2:=dirlist;
        dirlist:='';
      end
    else
      begin
        dir2:=Copy(dirlist,1,i-1);
        dirlist:=Copy(dirlist,i+1,255);
      end;
  { don't add anything if dir2 is empty string }
  if dir2<>'' then
    lastchar:=dir2[length(dir2)]
  else
    lastchar:='\';
  if (lastchar<>'\') and (lastchar<>':') then
    dir2:=dir2+'\'+dir
  else
    dir2:=dir2+dir;
  StringToPchar(dir2);
  if SearchPath(@dir2, @name, @ext, 255, @value, temp)>0 then
    begin
      fsearch := strpas(value);
      exit;
    end;
  until dirlist='';

end;

{ </immobilizer> }

procedure getftime(var f;var time : longint);
var
   ft : TFileTime;
begin
  doserror:=0;
  if GetFileTime(filerec(f).Handle,nil,nil,@ft) and
     WinToDosTime(ft,time) then
    exit
  else
    begin
      DosError:=Last2DosError(GetLastError);
      time:=0;
    end;
end;


procedure setftime(var f;time : longint);
var
  ft : TFileTime;
begin
  doserror:=0;
  if DosToWinTime(time,ft) and
     SetFileTime(filerec(f).Handle,nil,nil,@ft) then
   exit
  else
   DosError:=Last2DosError(GetLastError);
end;


procedure getfattr(var f;var attr : word);
var
   l : longint;
begin
  doserror:=0;
  l:=GetFileAttributes(filerec(f).name);
  if l=-1 then
   begin
     DosError:=Last2DosError(GetLastError);
     attr:=0;
   end
  else
   attr:=l and $ffff;
end;


procedure setfattr(var f;attr : word);
var
 valattr: DWORD;
begin
  doserror:=0;
  valattr:=attr;
  if not(SetFileAttributesA(filerec(f).name,valattr)) then
   DosError:=Last2DosError(GetLastError);
end;

{ change to short filename if successful win32 call PM }
function GetShortName(var p : String) : boolean;
var
  buffer   : array[0..255] of char;
  ret : longint;
begin
  {we can't mess with p, because we have to return it if call is
      unsuccesfully.}

  if Length(p)>0 then                   {copy p to array of char}
   move(p[1],buffer[0],length(p));
  buffer[length(p)]:=chr(0);

  {Should return value load loaddoserror?}

  ret:=GetShortPathName(@buffer,@buffer,255);
  if ret=0 then
   begin
     DosError:=0;
     p:=strpas(buffer)
   end
  else
   DosError:=Last2DosError(GetLastError);
  GetShortName:=ret<>0;
end;


{ change to long filename if successful DOS call PM }
function GetLongName(var p : String) : boolean;
var
  lfn,sfn   : array[0..255] of char;
  filename  : pchar;
  ret       : longint;
begin
  {contrary to shortname, SDK does not mention input buffer can be equal
   to output.}

  if Length(p)>0 then                   {copy p to array of char}
   move(p[1],sfn[0],length(p));
  sfn[length(p)]:=chr(0);
  fillchar(lfn,sizeof(lfn),#0);
  filename:=nil;

  {Should return value load loaddoserror?}

  ret:=GetFullPathName(@sfn,255,@lfn,filename);
  if ret=0 then
   begin
     DosError:=0;
     p:=strpas(lfn);              {lfn here returns full path, filename only fn}
   end
  else
   DosError:=Last2DosError(GetLastError);
  GetLongName:=ret<>0;
end;

{******************************************************************************
                             --- Environment ---
******************************************************************************}


function envcount : longint;
var
   hp,p : pchar;
   count : longint;
begin
   p:=GetEnvironmentStrings;
   hp:=p;
   count:=0;
   while  hp^<>#0 do
     begin
        { next string entry}
        hp:=hp+strlen(hp)+1;
        inc(count);
     end;
   FreeEnvironmentStrings(p);
   envcount:=count;
end;


function uppercase(s: string):string;
var
 i:integer;
begin
 for i:=1 to length(s) do
  s[i]:=upcase(s[i]);
 uppercase:=s; 
end;


Function  EnvStr(index: integer): string;
var
   hp,p : pchar;
   count,i : longint;
begin
   { envcount takes some time in win32 }
   count:=envcount;

   { range checking }
   if (index<=0) or (index>count) then
     begin
        envstr:='';
        exit;
     end;
   p:=GetEnvironmentStrings;
   hp:=p;

   { retrive the string with the given index }
   for i:=2 to index do
     hp:=hp+strlen(hp)+1;

   envstr:=strpas(hp);
   FreeEnvironmentStrings(p);
end;


Function  GetEnv(envvar: string): string;
var
   s : string;
   i : longint;
   hp,p : pchar;
begin
   getenv:='';
   p:=GetEnvironmentStrings;
   hp:=p;
   while hp^<>#0 do
     begin
        s:=strpas(hp);
        i:=pos('=',s);
        if uppercase(copy(s,1,i-1))=uppercase(envvar) then
          begin
             getenv:=copy(s,i+1,length(s)-i);
             break;
          end;
        { next string entry}
        hp:=hp+strlen(hp)+1;
     end;
   FreeEnvironmentStrings(p);
end;


{******************************************************************************
                             --- Not Supported ---
******************************************************************************}

Procedure keep(exitcode : word);
Begin
End;

Procedure getintvec(intno : byte;var vector : pointer);
Begin
End;

Procedure setintvec(intno : byte;vector : pointer);
Begin
End;


var
 Kernel32Handle: HMODULE;


procedure DosInit;
var
 p: pointer;
begin
  Kernel32Handle:=LoadLibrary('kernel32.dll');
  GetDiskFreeSpaceExA:=nil;
  if assigned(pointer(Kernel32Handle)) then
    begin
       p:=(GetProcAddress(Kernel32Handle,'GetDiskFreeSpaceExA'));
       if assigned(p) then
         begin
          GetDiskFreeSpaceExA:=TGetDiskFreeSpaceExA(p);
         end;
    end;
end;

procedure DosDone;
begin
  if assigned(pointer(Kernel32Handle)) then
    FreeLibrary(Kernel32Handle);
end;

{
  $Log: not supported by cvs2svn $
  Revision 1.5  2005/11/21 00:17:36  carl
    - remove some compilation warnings/hints
    + speed optimizations

  Revision 1.4  2005/10/10 17:44:46  carl
    * Bugfix with double quote characters in Find routines

  Revision 1.3  2005/03/21 00:22:55  carl
    * exec/diskfree/disksize/fexpand bugfixes

  Revision 1.2  2005/03/06 20:14:47  carl
    * bugfix of Fexpand with path in double quotes

  Revision 1.1  2004/12/26 23:34:07  carl
    + support for Kylix

}