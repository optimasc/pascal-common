{
    $Id: doslinux.inc,v 1.2 2005-03-21 00:22:54 carl Exp $
    Copyright (c) 2001 by members of the Free Pascal
    development team

    DOS unit for Kylix/linux

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}


Uses
  Strings,dpautils,libc;


  { Used by AddDisk(), DiskFree() and DiskSize() }
const
  Drives   : byte = 4;
  MAX_DRIVES = 26;
var
  DriveStr : array[4..MAX_DRIVES] of pchar;


Function StringToPPChar(Var S:STring; var count : longint):ppchar;
{
  Create a PPChar to structure of pchars which are the arguments specified
  in the string S. Especially usefull for creating an ArgV for Exec-calls
}
var
  nr  : longint;
  Buf : pchar;
  p   : ppchar;
begin
  s:=s+#0;
  buf:=@s[1];
  nr:=0;
  while(buf^<>#0) do
   begin
     while (buf^ in [' ',#8,#10]) do
      inc(buf);
     inc(nr);
     while not (buf^ in [' ',#0,#8,#10]) do
      inc(buf);
   end;
  getmem(p,nr*4);
  StringToPPChar:=p;
  if p=nil then
   begin
//     Errno:=sys_enomem;
     count := 0;
     exit;
   end;
  buf:=@s[1];
  while (buf^<>#0) do
   begin
     while (buf^ in [' ',#8,#10]) do
      begin
        buf^:=#0;
        inc(buf);
      end;
     p^:=buf;
     inc(p);
     p^:=nil;
     while not (buf^ in [' ',#0,#8,#10]) do
      inc(buf);
   end;
   count := nr;
end;


{
  The Diskfree and Disksize functions need a file on the specified drive, since this
  is required for the statfs system call.
  These filenames are set in drivestr[0..26], and have been preset to :
   0 - '.'      (default drive - hence current dir is ok.)
   1 - '/floppy/.'  (either direct or contains dir with volume label of mounted device)
   2 - '/cdrom/.'   (either direct or contains dir with volume label of mounted device)
   3 - '/'       (C: equivalent of dos is the root partition)
   4..26          (can be set by you're own applications)
  ! Use AddDisk() to Add new drives !
  They both return -1 when a failure occurs.
  The drive names are OS specific
}
Const
  FixDriveStr : array[0..3] of pchar=(
    '.',            { the current directory    }
    '/floppy/.',    { manually mounted floppy  }
    '/cdrom/.',     { manually mounted cdrom   }
    '/'             { root partition           }
    );



Function DosVersion:Word;
Var
  Buffer : Array[0..255] of Char;
  Tmp2,
  TmpStr : String[40];
  TmpPos,
  SubRel,
  Rel    : LongInt;
  info   : ^utsname;
  code   : integer;
Begin
  new(info);
  uname(info^);
  Move(info^.release,buffer[0],40);
  TmpStr:=StrPas(Buffer);
  SubRel:=0;
  TmpPos:=Pos('.',TmpStr);
  if TmpPos>0 then
   begin
     Tmp2:=Copy(TmpStr,TmpPos+1,40);
     Delete(TmpStr,TmpPos,40);
   end;
  TmpPos:=Pos('.',Tmp2);
  if TmpPos>0 then
   Delete(Tmp2,TmpPos,40);
  Val(TmpStr,Rel,code);
  Val(Tmp2,SubRel,code);
  DosVersion:=Rel+(SubRel shl 8);
  dispose(info);
End;

Function DiskFree(Drive: Byte): int64;
var
  info : tstatvfs;
Begin
  DiskFree := -1;
  if (Drive < 4) and (FixDriveStr[Drive]<>nil) then
    begin
     if statvfs(FixDriveStr[Drive],info)=0 then
        DiskFree := int64(info.f_frsize)*int64(info.f_bavail);
    end
  else
  if (Drive>4) and (Drive<=MAX_DRIVES) and (drivestr[Drive]<>nil) then
    begin
     if statvfs(DriveStr[Drive],info)=0 then
        DiskFree := int64(info.f_frsize)*int64(info.f_bavail);
    end
  else
    begin
      exit;
    end;
End;



Function DiskSize(Drive: Byte): int64;
var
  info : tstatvfs;
Begin
  DiskSize:= -1;
  if (Drive < 4) and (FixDriveStr[Drive]<>nil) then
    begin
     if statvfs(FixDriveStr[Drive],info)=0 then
        DiskSize := int64(info.f_frsize)*int64(info.f_blocks);
    end
  else
  if (Drive>4) and (Drive<=MAX_DRIVES) and (drivestr[Drive]<>nil) then
    begin
     if statvfs(DriveStr[Drive],info)=0 then
        DiskSize := int64(info.f_frsize)*int64(info.f_blocks);
    end
  else
    begin
      exit;
    end;
End;

Procedure UnixDateToDt(SecsPast: time_t; Var Dt: DateTime);
var
 unixtime: PUnixTime;
Begin
  unixtime:=localtime(@SecsPast);
  if assigned(unixtime) then
    begin
      dt.Year:=unixtime^.tm_year+1900;
      dt.Month:=unixtime^.tm_mon;
      dt.Day:=unixtime^.tm_mday;
      dt.Hour:=unixtime^.tm_hour;
      dt.Min:=unixtime^.tm_min;
      dt.Sec:=unixtime^.tm_sec;
    end;
End;





{******************************************************************************
                        --- Info / Date / Time ---
******************************************************************************}


type
  GTRec = packed Record
    Year,
    Month,
    MDay,
    WDay,
    Hour,
    Minute,
    Second : Word;
  End;
Const
{Date Calculation}
  C1970 = 2440588;
  D0    = 1461;
  D1    = 146097;
  D2    = 1721119;


function WeekDay (y,m,d:longint):longint;
{
  Calculates th day of the week. returns -1 on error
}
var
  u,v : longint;
begin
  if (m<1) or (m>12) or (y<1600) or (y>4000) or
     (d<1) or (d>30+((m+ord(m>7)) and 1)-ord(m=2)) or
     ((m*d=58) and (((y mod 4>0) or (y mod 100=0)) and (y mod 400>0))) then
   WeekDay:=-1
  else
   begin
     u:=m;
     v:=y;
     if m<3 then
      begin
        inc(u,12);
        dec(v);
      end;
     WeekDay:=(d+2*u+((3*(u+1)) div 5)+v+(v div 4)-(v div 100)+(v div 400)+1) mod 7;
   end;
end;




Procedure JulianToGregorian(JulianDN:LongInt;Var Year,Month,Day:Word);
Var
  YYear,XYear,Temp,TempMonth : LongInt;
Begin
  Temp:=((JulianDN-D2) shl 2)-1;
  JulianDN:=Temp Div D1;
  XYear:=(Temp Mod D1) or 3;
  YYear:=(XYear Div D0);
  Temp:=((((XYear mod D0)+4) shr 2)*5)-3;
  Day:=((Temp Mod 153)+5) Div 5;
  TempMonth:=Temp Div 153;
  If TempMonth>=10 Then
   Begin
     inc(YYear);
     dec(TempMonth,12);
   End;
  inc(TempMonth,3);
  Month := TempMonth;
  Year:=YYear+(JulianDN*100);
end;






Procedure GetDate(Var Year, Month, MDay, WDay: Word);
var
  unixtime: punixtime;
  timeval : ptime_t;
Begin
  __time(timeval);
  unixtime:=localtime(timeval);
  if assigned(unixtime) then
    begin
      Year:=UnixTime^.tm_year+1900;
      Month:=UnixTime^.tm_mon;
      MDay:=UnixTime^.tm_mday;
    end;
  { convert the GMT time to local time }
  Wday:=weekday(Year,Month,MDay);
end;



Procedure SetDate(Year, Month, Day: Word);
Begin
  {!!}
End;




Procedure GetTime(Var Hour, Minute, Second, Sec100: Word);
var
 timeval : ptime_t;
 unixtime: punixtime;
Begin
  __time(timeval);
  unixtime:=localtime(timeval);
  if assigned(unixtime) then
    begin
      Hour:=UnixTime^.tm_hour;
      Minute:=UnixTime^.tm_min;
      Hour:=UnixTime^.tm_hour;
    end;
  Sec100 := 0;
end;



Procedure SetTime(Hour, Minute, Second, Sec100: Word);
Begin
  {!!}
End;



Procedure packtime(var t : datetime;var p : longint);
Begin
  p:=(t.sec shr 1)+(t.min shl 5)+(t.hour shl 11)+(t.day shl 16)+(t.month shl 21)+((t.year-1980) shl 25);
End;



Procedure unpacktime(p : longint;var t : datetime);
Begin
  t.sec:=(p and 31) shl 1;
  t.min:=(p shr 5) and 63;
  t.hour:=(p shr 11) and 31;
  t.day:=(p shr 16) and 31;
  t.month:=(p shr 21) and 15;
  t.year:=(p shr 25)+1980;
End;



{$ifndef DOS_HAS_EXEC}
{******************************************************************************
                               --- Exec ---
******************************************************************************}

var
  LastDosExitCode: word;


Function  InternalWaitProcess(Pid:pid_t):Longint; { like WaitPid(PID,@result,0) Handling of Signal interrupts (errno=EINTR), returning the Exitcode of Process (>=0) or -Status if terminated}
var
 s: integer;
 r: integer;
begin
  repeat
    s:=$7F00;
    r:=waitPid(Pid,@s,0);
  until (r<>-1) or (Errno<>EINTR);
  { When r = -1 or r = 0, no status is available, so there was an error. }
  if (r=-1) or (r=0) then
    InternalWaitProcess:=-1 { return -1 to indicate an error }
  else
   begin
     { process terminated normally }
     if wifexited(s) then
       begin
         { get status code }
         InternalWaitProcess := wexitstatus(s);
         exit;
       end;
     { process terminated due to a signal }
     if wifsignaled(s) then
       begin
         { get signal number }
         InternalWaitProcess := wstopsig(s);
         exit;
       end;
     InternalWaitProcess:=-1;
   end;
end;




Procedure Exec (Const Path: PathStr; Const ComLine: ComStr);
var
  pid    : pid_t;
  tmp : string;
  p : ppchar;
  count: longint;
  // The Error-Checking in the previous Version failed, since halt($7F) gives an WaitPid-status of $7F00
  F: File;
Begin
{$IFOPT I+}
{$DEFINE IOCHECK}
{$ENDIF}
{$I-}
  { verify if the file to execute exists }
  Assign(F,Path);
  Reset(F,1);
  if IOResult <> 0 then
    { file not found }
    begin
      DosError := 2;
      exit;
    end
  else
    Close(F); 
{$IFDEF IOCHECK}
{$I+}
{$UNDEF IOCHECK}
{$ENDIF}
  LastDosExitCode:=0;
  { Fork the process }
  pid:=Fork;
  if pid=0 then
   begin
   {The child does the actual execution, and then exits}
    tmp := Path+' '+ComLine;
    p:=StringToPPChar(tmp,count);
    if (p<>nil) and (p^<>nil) then
    begin
      execve(p^,p,Envp);
    end;  
   {If the execve fails, we return an exitvalue of 127, to let it be known}
     halt(127);
   end
  else
   if pid=-1 then         {Fork failed - parent only}
    begin
      DosError:=8;
      exit
    end;
{We're in the parent, let's wait.}
  LastDosExitCode:=InternalWaitProcess(pid); // WaitPid and result-convert
  if (LastDosExitCode>=0) and (LastDosExitCode<>127) then DosError:=0 else
     DosError:=8; // perhaps one time give an better error
End;

Function DosExitCode: Word;
Begin
  DosExitCode:=LastDosExitCode;
End;
{$ENDIF}


{******************************************************************************
                               --- Disk ---
******************************************************************************}


Procedure AddDisk(const path:string);
begin
  if not (DriveStr[Drives]=nil) then
   FreeMem(DriveStr[Drives],StrLen(DriveStr[Drives])+1);
  GetMem(DriveStr[Drives],length(Path)+1);
  StrPCopy(DriveStr[Drives],path);
  inc(Drives);
  if Drives>26 then
   Drives:=4;
end;


{******************************************************************************
                       --- Findfirst FindNext ---
******************************************************************************}


Function FNMatch(const Pattern,Name:string):Boolean;
Var
  LenPat,LenName : longint;

  Function DoFNMatch(i,j:longint):Boolean;
  Var
    Found : boolean;
  Begin
  Found:=true;
  While Found and (i<=LenPat) Do
   Begin
     Case Pattern[i] of
      '?' : Found:=(j<=LenName);
      '*' : Begin
            {find the next character in pattern, different of ? and *}
              while Found and (i<LenPat) do
                begin
                inc(i);
                case Pattern[i] of
                  '*' : ;
                  '?' : begin
                          inc(j);
                          Found:=(j<=LenName);
                        end;
                else
                  Found:=false;
                end;
               end;
            {Now, find in name the character which i points to, if the * or ?
             wasn't the last character in the pattern, else, use up all the
             chars in name}
              Found:=true;
              if (i<=LenPat) then
                begin
                repeat
                {find a letter (not only first !) which maches pattern[i]}
                while (j<=LenName) and (name[j]<>pattern[i]) do
                  inc (j);
                 if (j<LenName) then
                  begin
                    if DoFnMatch(i+1,j+1) then
                     begin
                       i:=LenPat;
                       j:=LenName;{we can stop}
                       Found:=true;
                     end
                    else
                     inc(j);{We didn't find one, need to look further}
                  end;
               until (j>=LenName);
                end
              else
                j:=LenName;{we can stop}
            end;
     else {not a wildcard character in pattern}
       Found:=(j<=LenName) and (pattern[i]=name[j]);
     end;
     inc(i);
     inc(j);
   end;
  DoFnMatch:=Found and (j>LenName);
  end;

Begin {start FNMatch}
  LenPat:=Length(Pattern);
  LenName:=Length(Name);
  FNMatch:=DoFNMatch(1,1);
End;


Procedure FindClose(Var f: SearchRec);
{
  Closes dirptr if it is open
}
Begin
  { could already have been closed }
  if assigned(f.dirptr) then
     closedir(pdirectorystream(f.dirptr));
  f.dirptr := nil;
End;


{ Returns a filled in searchRec structure }
{ and TRUE if the specified file in s is  }
{ found.                                  }
Function FindGetFileInfo(s:string;var f:SearchRec):boolean;
var
  DT   : DateTime;
  st   : tstatbuf;
  Fmode : byte;
  res: string;    { overlaid variable }
  Dir : DirsTr;
  Name : NameStr;
  Ext: ExtStr;
begin
  FindGetFileInfo:=false;
  res := s + #0;
  if stat(@res[1],st)<>0 then
   exit;
  if S_ISDIR(st.st_mode) then
   fmode:=directory
  else
   { contrary to DOS - all normal files have the archive bits set }
   { under POSIX.                                                 }
   fmode:=archive;
  if (st.st_mode and S_IWUSR)=0 then
   fmode:=fmode or readonly;
  If ((FMode and f.searchattr)<>0) or ((Fmode and Archive)<>0) Then
   Begin
     FSplit(s,Dir,Name,Ext);
     if Ext <> '' then
       res := Name + Ext
     else
       res := Name;
     f.Name:=res;
     f.Attr:=FMode;
     f.Size:=longint(st.st_size);
     UnixDateToDT(st.st_mtime, DT);
     PackTime(DT,f.Time);
     FindGetFileInfo:=true;
   End;
end;


Procedure FindNext(Var f: SearchRec);
{
  re-opens dir if not already in array and calls FindWorkProc
}
Var
  FName,
  SName    : string;
  Found,
  Finished : boolean;
  p        : PDirEnt;
Begin
{Main loop}
  SName:=f.SearchSpec;
  Found:=False;
  Finished:=(f.dirptr=nil);
  While Not Finished Do
   Begin
     p:=readdir(pdirectorystream(f.dirptr));
     if p=nil then
     begin
      FName:=''
     end
     else
      FName:=Strpas(@p^.d_name);
     If FName='' Then
      Finished:=True
     Else
      Begin
        If FNMatch(SName,FName) Then
         Begin
           Found:=FindGetFileInfo(f.SearchDir+FName,f);
           if Found then
           begin
            Finished:=true;
           end;
         End;
      End;
   End;
{Shutdown}
  If Found Then
   Begin
     DosError:=0;
   End
  Else
   Begin
     FindClose(f);
     { FindClose() might be called thereafter also... }
     f.dirptr := nil;
     DosError:=18;
   End;
End;


Procedure FindFirst(Const Path: PathStr; Attr: Word; Var f: SearchRec);
{
  opens dir
}
var
 res: string;
  Dir : DirsTr;
  Name : NameStr;
  Ext: ExtStr;
Begin
  { initialize f.dirptr because it is used    }
  { to see if we need to close the dir stream }
  f.dirptr := nil;
  if Path='' then
   begin
     DosError:=3;
     exit;
   end;
  f.SearchAttr := Attr;
{Wildcards?}
  if (Pos('?',Path)=0)  and (Pos('*',Path)=0) then
   begin
     if FindGetFileInfo(Path,f) then
      DosError:=0
     else
      begin
        if ErrNo=ENOENT then
         DosError:=3
        else
         DosError:=18;
      end;
     f.DirPtr:=nil;
   end
  else
{Find Entry}
   begin
     FSplit(Path,Dir,Name,Ext);
     if Ext <> '' then
       res := Name + Ext
     else
       res := Name;
     f.SearchSpec := res;
     { if dir is an empty string }
     { then this indicates that  }
     { use the current working   }
     { directory.                }
     if dir = '' then
        dir := './';
     f.SearchDir := Dir;
     { add terminating null character }
     Dir := Dir + #0;
     f.dirptr := opendir(@Dir[1]);
     if not assigned(f.dirptr) then
     begin
        DosError := 8;
        exit;
     end;
     FindNext(f);
   end;
End;


{******************************************************************************
                               --- File ---
******************************************************************************}
Procedure FSplit(path: pathstr; var dir: dirstr; var name: namestr; var ext: extstr);
Var
  DotPos,SlashPos,i : longint;
Begin
  SlashPos:=0;
  DotPos:=256;
  i:=Length(Path);
  While (i>0) and (SlashPos=0) Do
   Begin
     If (DotPos=256) and (Path[i]='.') Then
      begin
        DotPos:=i;
      end;
     If (Path[i]='/') Then
      SlashPos:=i;
     Dec(i);
   End;
  Ext:=Copy(Path,DotPos,255);
  Dir:=Copy(Path,1,SlashPos);
  Name:=Copy(Path,SlashPos + 1,DotPos - SlashPos - 1);
End;

{
function FExpand (const Path: PathStr): PathStr;
- declared in fexpand.inc
}
(*
{$DEFINE FPC_FEXPAND_TILDE} { Tilde is expanded to home }
*)
const
  LFNSupport = true;
  FileNameCaseSensitive = true;

{$I fexpand.inc}



Function FSearch(path:pathstr;dirlist:string):pathstr;
{
  Searches for a file 'path' in the list of direcories in 'dirlist'.
  returns an empty string if not found. Wildcards are NOT allowed.
  If dirlist is empty, it is set to '.'
}
Var
  NewDir : PathStr;
  p1     : Longint;
  Info   : TStatBuf;
  buffer : array[0..FileNameLen+1] of char;
Begin
  Move(path[1], Buffer, Length(path));
  Buffer[Length(path)]:=#0;
  if (length(Path)>0) and (path[1]='/') and (stat(pchar(@Buffer),info)=0) then
  begin
    FSearch:=path;
    exit;
  end;
{Replace ':' with ';'}
  for p1:=1to length(dirlist) do
   if dirlist[p1]=':' then
    dirlist[p1]:=';';
{Check for WildCards}
  If (Pos('?',Path) <> 0) or (Pos('*',Path) <> 0) Then
   FSearch:='' {No wildcards allowed in these things.}
  Else
   Begin
     Dirlist:='.;'+dirlist;{Make sure current dir is first to be searched.}
     Repeat
       p1:=Pos(';',DirList);
       If p1=0 Then
        p1:=255;
       NewDir:=Copy(DirList,1,P1 - 1);
       if NewDir[Length(NewDir)]<>'/' then
        NewDir:=NewDir+'/';
       NewDir:=NewDir+Path;
       Delete(DirList,1,p1);
       Move(NewDir[1], Buffer, Length(NewDir));
       Buffer[Length(NewDir)]:=#0;
       if stat(pchar(@Buffer),Info)=0 then
        Begin
          If Pos('./',NewDir)=1 Then
           Delete(NewDir,1,2);
        {DOS strips off an initial .\}
        End
       Else
        NewDir:='';
     Until (DirList='') or (Length(NewDir) > 0);
     FSearch:=NewDir;
   End;
End;



Procedure GetFAttr(var f; var attr : word);
Var
  info : TStatBuf;
  LinAttr : mode_t;
Begin
  DosError:=0;
  if stat(@textrec(f).name,info)<>0 then
   begin
     Attr:=0;
     DosError:=3;
     exit;
   end
  else
   LinAttr:=Info.st_Mode;
  if S_ISDIR(LinAttr) then
   Attr:=directory
  else
   Attr:=archive;
  if Access(@textrec(f).name,W_OK)<>0 then
   Attr:=Attr or readonly;
  if (not S_ISDIR(LinAttr)) and (filerec(f).name[0]='.')  then
   Attr:=Attr or hidden;
end;



Procedure getftime (var f; var time : longint);
Var
  Info: tstatbuf;
  DT: DateTime;
Begin
  doserror:=0;
  if fstat(filerec(f).handle,info)<>0 then
   begin
     Time:=0;
     doserror:=3;
     exit
   end
  else
   UnixDateToDT(Info.st_mtime,DT);
  PackTime(DT,Time);
End;


{******************************************************************************
                             --- Environment ---
******************************************************************************}

Function EnvCount: Longint;
var
  envcnt : longint;
  p      : ppchar;
Begin
  envcnt:=0;
  p:=envp;      {defined in syslinux}
  while (p^<>nil) do
   begin
     inc(envcnt);
     inc(p);
   end;
  EnvCount := envcnt
End;



Function EnvStr(Index: Integer): String;
Var
  i : longint;
  p : ppchar;
Begin
  p:=envp;      {defined in syslinux}
  i:=1;
  envstr:='';
  if (index < 1) or (index > EnvCount) then
    exit;
  while (i<Index) and (p^<>nil) do
   begin
     inc(i);
     inc(p);
   end;
  if p<>nil then
   envstr:=strpas(p^)
End;


Function GetEnv(EnvVar:string):string;
{
  Searches the environment for a string with name p and
  returns a pchar to it's value.
  A pchar is used to accomodate for strings of length > 255
}
var
  ep    : ppchar;
  found : boolean;
  p1 : pchar;
Begin
  EnvVar:=EnvVar+'=';            {Else HOST will also find HOSTNAME, etc}
  ep:=envp;
  found:=false;
  if ep<>nil then
   begin
     while (not found) and (ep^<>nil) do
      begin
        if strlcomp(@EnvVar[1],(ep^),length(EnvVar))=0 then
         found:=true
        else
         inc(ep);
      end;
   end;
  if found then
   p1:=ep^+length(EnvVar)
  else
   p1:=nil;
  if p1 = nil then
    GetEnv := ''
  else
    GetEnv := StrPas(p1);
end;



{******************************************************************************
                      --- Do Nothing Procedures/Functions ---
******************************************************************************}

Procedure Intr (intno: byte; var regs: registers);
Begin
  {! No POSIX equivalent !}
End;



Procedure msdos(var regs : registers);
Begin
  {! No POSIX equivalent !}
End;



Procedure getintvec(intno : byte;var vector : pointer);
Begin
  {! No POSIX equivalent !}
End;



Procedure setintvec(intno : byte;vector : pointer);
Begin
  {! No POSIX equivalent !}
End;



Procedure SwapVectors;
Begin
  {! No POSIX equivalent !}
End;



Procedure keep(exitcode : word);
Begin
  {! No POSIX equivalent !}
End;



Procedure setftime(var f; time : longint);
Begin
  {! No POSIX equivalent !}
End;



Procedure setfattr (var f;attr : word);
Begin
  {! No POSIX equivalent !}
End;



Procedure GetCBreak(Var BreakValue: Boolean);
Begin
{! No POSIX equivalent !}
  breakvalue:=true
End;



Procedure SetCBreak(BreakValue: Boolean);
Begin
  {! No POSIX equivalent !}
End;



Procedure GetVerify(Var Verify: Boolean);
Begin
  {! No POSIX equivalent !}
  Verify:=true;
End;



Procedure SetVerify(Verify: Boolean);
Begin
  {! No POSIX equivalent !}
End;

procedure DosInit;
begin
end;

procedure DosDone;
begin
end;

{
  $Log: not supported by cvs2svn $
  Revision 1.1  2004/12/26 23:34:05  carl
    + support for Kylix

}