


{**************************************************************************}

{ Convert POSIX attributes to our pascal format of attributes }
function POSIXAttrToExtAttr(attr: mode_t): TResourceAttributes;
var
  Attributes: TResourceAttributes;
begin
  Attributes:=[];
  if S_ISREG(attr) then
    Attributes:=[];
  if S_ISCHR(attr) then
    Include(Attributes, attr_device);
  if S_ISBLK(attr) then
    Include(Attributes, attr_device);
  if S_ISFIFO(attr) then
    Include(Attributes, attr_device);
  if S_ISDIR(attr) then
    Include(Attributes, attr_directory);
  if S_ISLNK(attr) then
    Include(Attributes, attr_link);
  if S_ISSOCK(attr) then
    Include(Attributes, attr_device);
  POSIXAttrToExtAttr:=attributes;
end;

{ Convert our attribute format to Windows attributes }
function ExtAttrToPOSIXAttr(attr: TResourceAttributes): DWORD;
var
 dwAttr: DWORD;
begin
  dwAttr:=0;
{  
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
    dwAttr:=FILE_ATTRIBUTE_NORMAL;}
  ExtAttrToPOSIXAttr:=dwAttr;
end;

function DateTimeToPOSIXTime(DateTime: TDateTime): time_t;
var
 uday: big_integer_t;
begin
 uday:=round(DateTime+0.01)- 2440588; {* J.D. of 1.1.1970 *}
 { Beyond the possible epoch values }
 if (uday < 0) or (uday > 24755) then
   begin
    DateTimeToPOSIXTime:=time_t(-1);     
    exit;
   end;
 DateTimeToPosixTime:=time_t(uday*24*3600);
end;

{ Convert a UID to a name }
function POSIXUIDToName(uid: uid_t): utf8string;
var
 s: string;
 pass_info: ppasswd;
 p: pointer;
 l: longword;
begin
  POSIXUIDToName:='';
  p:=nil;
  l:=uid;
  p:=sys_getpwuid(l);
  pass_info:=ppasswd(p);
  if pass_info<>nil then
    begin
      s:=strpas(pass_info^.pw_name);
      POSIXUIDToName:=LocaleToUTF8(s);
    end;
end;

{**************************************************************************}


function getfileatime(fname: putf8char; var atime: TDateTime): integer;
var
 stats:TFileStats;
begin
  getfileatime:=getfilestats(fname,stats);
  atime:=stats.atime;
end;


function getfilectime(fname: putf8char; var ctime: TDateTime): integer;
var
 stats:TFileStats;
begin
  getfilectime:=getfilestats(fname,stats);
  ctime:=stats.ctime;
end;

function getfilemtime(fname: putf8char; var mtime: TDateTime): integer;
var
 stats:TFileStats;
begin
  getfilemtime:=getfilestats(fname,stats);
  mtime:=stats.mtime;
end;

function getfileowner(fname: putf8char): utf8string;
var
 stats:TFileStats;
begin
  getfileowner:='';
  if not assigned(fname) then 
     system.exit;
  if (getfilestats(fname,stats)=EXTDOS_STATUS_OK) then
    begin
      getfileowner:=stats.owner;
    end;
end;

function setfileatime(fname: putf8char; newatime: tdatetime): integer;
var
 info: posix.stat_t;
 res: cint;
 s: string;
 p: pchar;
 times: utimbuf;
begin
  fillchar(info,sizeof(info),#0);
  s:=UTF8ToLocale(strpas(fname));
  p:=ansistrnewstr(s);
  res:=sys_lstat(p,info);
  if res = 0 then
    begin
      fillchar(times,sizeof(times),#0);
      times.modtime:=info.st_mtime;
      times.actime:=DateTimeToPOSIXTime(newatime);
      res:=sys_utime(p,times);
    end;
  setfileatime:=res;
  ansistrdispose(p);
end;


function setfilemtime(fname: putf8char; newmtime: tdatetime): integer;
var
 info: posix.stat_t;
 res: cint;
 s: string;
 p: pchar;
 times: utimbuf;
begin
  fillchar(info,sizeof(info),#0);
  s:=UTF8ToLocale(strpas(fname));
  p:=ansistrnewstr(s);
  res:=sys_lstat(p,info);
  if res = 0 then
    begin
      fillchar(times,sizeof(times),#0);
      times.actime:=info.st_atime;
      times.modtime:=DateTimeToPOSIXTime(newmtime);
      res:=sys_utime(p,times);
    end;
  setfilemtime:=res;
  ansistrdispose(p);
end;


function setfilectime(fname: putf8char; newctime: tdatetime): integer;
begin
 setfilectime:=EXTDOS_STATUS_UNSUPPORTED;
end;




function getfilestats(fname: putf8char; var stats: TFileStats): integer;
var
 ResultVal: cint;
 status: integer;
 info: posix.stat_t;
 s: string;
 p: pchar;
 dir: dirstr;
 name: namestr;
 ext: extstr;
 utc: boolean;
begin
  fillchar(info,sizeof(info),#0);
  fillchar(stats,sizeof(stats),#0);
  s:=UTF8ToLocale(strpas(fname));
  p:=ansistrnewstr(s);
  ResultVal:=sys_lstat(p,info);
  if ResultVal=0 then
    begin
      {***** Unsupported information ****}
      stats.accesses:=-1;
      stats.streamcount:=-1;
      {***** Supported returned information ****}
      stats.utc:=true;
{      s:=hexstr(longint(info.st_dev),8);
      move(s[1],stats.dev[0],length(s));}
      { Now the file serial number }
      s:=hexstr(longint(info.st_ino),8);
      move(s[1],stats.ino[0],length(s));
      {** Name of the resource on disk }
      s:=strpas(fname);
      if s[length(s)] = '.' then
        begin
          dir:=s;
          delete(dir,length(dir),1);
          name:='.';
          if dir[length(dir)] = '.' then
            begin
              name:=name+'.';
              delete(dir,length(dir),1);
            end; 
          dir:=trim(dir);
          s:=name;  
        end
      else
        begin
          s:=FExpand(s);
          FSplit(s,dir,name,ext);
          s:=name+ext;
        end;
      stats.name:=s;
      stats.dirstr:=dir;
      { Fill up shell file assocations and comment strings }
      GetShellAssociationInfo(ext,stats.association,stats.comment);
      stats.nlink:=info.st_nlink;
      stats.attributes:=POSIXAttrToExtAttr(info.st_mode);
      stats.owner:=POSIXUIDToName(info.st_uid);
      stats.size:=big_integer_t(info.st_size);
      { Hidden files and directories always start with . }
      if (stats.name[1] = '.') and (length(stats.name)>1) then
        stats.attributes:=stats.attributes + [attr_hidden];
      
      TryUNIXToDateTimeExt(info.st_ctime,stats.ctime,utc);
      TryUNIXToDateTimeExt(info.st_mtime,stats.mtime,utc);
      TryUNIXToDateTimeExt(info.st_atime,stats.atime,utc);
    end;
   ansistrdispose(p);
   getfilestats:=ResultVal;
end;


function getfilesize(fname: putf8char): big_integer_t;
var
 F: File;
 status: integer;
begin
  FileAssign(F,utf8strpas(fname));
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilesize:=big_integer_t(-1);
      system.exit;
    end;
  FileReset(F,fmOpenRead);
  status:=FileIOResult;
  if status <> 0 then
    begin
      getfilesize:=big_integer_t(-1);
      system.exit;
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
    begin
     status:=FindFirstEx(utf,[attr_directory],SearchInfo);
     if (status = 0) and ((attr_directory in SearchInfo.stats.Attributes)) then
       begin
          DirectoryExists:=true;
       end;
    end
  else
    begin
       status:=FindFirstEx(utf,[attr_any],SearchInfo);
       if status = 0 then
         begin
          DirectoryExists:=true;
         end;
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
         (attr_device in SearchInfo.stats.Attributes) or
         (attr_offline in SearchInfo.stats.Attributes)
         )
         then
           FileExists:=true;
    end;
  FindCloseEx(SearchInfo);  
  utf8strdispose(utf);
end;




function getfileattributes(fname: putf8char): tresourceattributes;
var
 stats: TFileStats;
begin
  GetFileAttributes:=[];
  if GetFileStats(fname,stats)=EXTDOS_STATUS_OK then
    begin 
      GetFileAttributes:=stats.Attributes;
    end;
end;

function GetCurrentDirectory(var DirStr: utf8string): boolean;
var
 s: string;
begin
  GetCurrentDirectory:=true;
  system.getdir(0,S);
  if IOResult <> 0 then
    GetCurrentDirectory:=false;
  DirStr:=LocaleToUTF8(s);
end;

function SetCurrentDirectory(const DirStr: utf8string): boolean;
var
 s: string;
 p: pchar;
begin
  SetCurrentDirectory:=false;
  s:=UTF8ToLocale(DirStr);
  p:=ansistrnewstr(s);
  if posix.sys_chdir(p)=0 then
    SetCurrentDirectory:=true;
  ansistrdispose(p); 
end;

{**********************************************************************}
{                      FindFirstEx/FindNextExt                         }
{**********************************************************************}

  
  
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



Function FindGetFileInfo(const s: utf8string;var f:TSearchRecExt):boolean;
var
  p: putf8char;
begin
  FindGetFileInfo:=false;
  p:=utf8strnewstr(s);  
  if getfilestats(p,f.Stats)=EXTDOS_STATUS_OK then
   begin
       If (((f.SearchAttr * f.stats.Attributes) <> []) or (attr_any in f.SearchAttr)) Then
        Begin
          FindGetFileInfo:=true;
        End;
   end;
  utf8strdispose(p);
end;



  


procedure FindCloseEx(var SearchRec: TSearchRecExt);
{
  Closes dirptr if it is open
}
Begin
  { could already have been closed }
  if assigned(SearchRec.dirptr) then
     sys_closedir(pdir(SearchRec.dirptr));
  SearchRec.dirptr := nil;
End;



function FindNextEx(var SearchRec: TSearchRecExt): integer;
{
  re-opens dir if not already in array and calls FindWorkProc
}
Var
  FName,
  SName    : shortstring;
  s        : string;
  Found,
  Finished : boolean;
  p        : PDirEnt;
Begin
{Main loop}
  SName:=SearchRec.SearchSpec;
  Found:=False;
  Finished:=(SearchRec.dirptr=nil);
  While Not Finished Do
   Begin
     p:=sys_readdir(pdir(SearchRec.dirptr));
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
           Found:=FindGetFileInfo(SearchRec.SearchDir+LocaleToUTF8(FName),SearchRec);
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
     FindNextEx:=EXTDOS_STATUS_OK;
   End
  Else
   Begin
     FindCloseEx(SearchRec);
     { FindClose() might be called thereafter also... }
     SearchRec.dirptr := nil;
     FindNextEx:=18;
   End;
End;


function findfirstex(path: putf8char; attr: tresourceattributes; var SearchRec:TSearchRecExt): integer;
var
 s: string;
 dir:dirstr;
 name: namestr;
 ext: extstr;
 res: utf8string;
begin
  s:=UTF8ToLocale(strpas(path));
  SearchRec.stats.name:=s;
  SearchRec.stats.Attributes:=attr;
  SearchRec.DirPtr:=nil;
  SearchRec.SearchAttr:=attr;
  Fsplit(s,dir,name,ext);
  if dir <> '' then
    begin
      if dir[Length(dir)] <> DirectorySeparator then
        dir:=dir+DirectorySeparator;
    end;
  SearchRec.stats.DirStr:=dir;
{ FindFirstFile is a Win32 Call }
  { Convert the string to a UCS-2 character string }
  { Expand wildcards }
  if s = '*.*' then
    s:='*';
{Wildcards?}
  if (Pos('?',s)=0)  and (Pos('*',s)=0) then
   begin
     if FindGetFileInfo(s,SearchRec) then
      FindFirstEx:=EXTDOS_STATUS_OK
     else
      begin
        { According to tdos2 test it should return 18
        if ErrNo=Sys_ENOENT then
         DosError:=3
        else }
         FindFirstEx:=18;
      end;
     SearchRec.DirPtr:=nil;
   end
  else
{Find Entry}
   begin
     FSplit(s,Dir,Name,Ext);
     if Ext <> '' then
       res := Name + Ext
     else
       res := Name;
     SearchRec.SearchSpec := res;
     { if dir is an empty string }
     { then this indicates that  }
     { use the current working   }
     { directory.                }
     if dir = '' then
        dir := './';
     SearchRec.SearchDir := Dir;
     { add terminating null character }
     Dir := Dir + #0;
     SearchRec.dirptr := sys_opendir(@Dir[1]);
     if not assigned(SearchRec.dirptr) then
     begin
        FindFirstEx := 18;
        system.exit;
     end;
     FindFirstEx:=FindNextEx(SearchRec);
   end;
end;







{**********************************************************************}
{                         User configuration                           }
{**********************************************************************}

function GetLoginConfigDirectory: utf8string;
begin
  GetLoginConfigDirectory:=LocaleToUTF8(dos.GetEnv('HOME'));
end;

function GetGlobalConfigDirectory: utf8string;
begin
  GetGlobalConfigDirectory:='';
  if DirectoryExists('/etc') then
    GetGlobalConfigDirectory:='/etc';
end;


function GetLoginHomeDirectory: utf8string;
begin
  GetLoginHomeDirectory:=LocaleToUTF8(dos.GetEnv('HOME'));;
end;




var
 ExitSave: pointer;

procedure CloseLibraries;far;
begin
  ExitProc := ExitSave;
end;

Begin
  ExitSave:= ExitProc;
  ExitProc := @CloseLibraries;

end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2006/12/03 22:10:10  carl
    * Bugfix with special . directory

  Revision 1.1  2006/10/16 22:26:02  carl
    + Generic POSIX templates for extdos


}