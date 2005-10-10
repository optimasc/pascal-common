{$APPTYPE CONSOLE}
uses dos,extdos,unicode,dateutil,utils,strings;

var
 s: utf8string;
 SearchRec: TSearchRecExt;
 stats: TFileStats;
 i: integer;
 mtime: TDateTime;
 DateTime: TDateTime;
 Count: integer;
 ws: widestring;
Begin
  count:=1;
  s:=getfileowner('L:\*.*');
  TryStrToDateTime('1985-12-06T01:12:24',DateTime);
  i:=SetFileaTime('Y:\config_.bak',DateTime);
  i:=GetFileCTime('C:\config_.bak',DateTime);
  WriteLn(DateTimeToStr(DateTime));
  i:=GetFileATime('C:\config_.bak',DateTime);
  WriteLn(DateTimeToStr(DateTime));
  i:=GetFileMTime('C:\config_.bak',DateTime);
  WriteLn(DateTimeToStr(DateTime));
  i:=FindFirstEx('C:\*.*',[attr_archive,attr_directory],SearchRec);
  WriteLn(i);
  while FindNextEx(SearchRec)=0 do
    begin
      Write(fillto(SearchRec.stats.name,24));
      ws:=UTF8Decode(SearchRec.stats.name);
      Write(DateTimeToStr(SearchRec.stats.ctime),' ');
      Write(DateTimeToStr(SearchRec.stats.mtime),' ');
      Inc(Count);
{      Write(DateTimeToStr(SearchRec.stats.atime),' ');}
      WriteLn;
    end;
  FindCloseEx(SearchRec);
{  s:=GetLoginConfigDirectory;
  s:=GetGlobalConfigDirectory;
  s:=GetLoginHomeDirectory;

  s:=GetUserFullName('carl');}
{  i:=GetFileatime('G:\descript.ion',mtime);
  i:=GetFileStats('G:\index.htm',stats);}
end.
