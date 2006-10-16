uses strings;

procedure GetShellAssociationInfo(const ext: utf8string; var assoc: TFileAssociation;
  var comment: utf8string);
begin  
end;


{** @abstract(Return the active haracter set encoding).

    The values are retrieved according to the POSIX 1003.1 2001
    specification. The LOCALE definition in filenames are
    currently not supported in this implementation.

    The default character set, if not defined, is ISO-8859-1.
}
function GetActiveCharacterSet: string;
var
 s: string;
 idx: integer;
Begin
 { Assume by default the ISO-8859-1 character set }
 GetActiveCharacterSet:='ISO-8859-1';
 s:=dos.getenv('LC_ALL');
 if length(s) = 0 then
   begin
     s:=dos.getenv('LANG');
   end;
 if length(s) > 0 then
   begin
     { ASCII character set with these locales }
     if ((s = 'C') or (s='POSIX')) then
       begin
         GetActiveCharacterSet:='ASCII';
         exit;
       end;
     { Character set encoding via files currently unsupported }
     if s[1] = '/' then
       exit;
     { Check for the character set encoding string }
     idx:=pos('.',s);
     if idx > 0 then
       begin
         delete(s,1,idx);
         GetActiveCharacterSet:=UpString(s);
       end;
   end;
end;


function LocaleToUtf8(const s: string): utf8string;
var
 ucs4: ucs4string;
 charset: string;
 outstr: utf8string;
begin
  outstr:=s;
  LocaleToUTF8:=s;
  charset:=GetActiveCharacterSet;
  { Nothing to do, already correct format }
  if charset = 'UTF-8' then
    exit;
  ConvertToUCS4(s,ucs4,charset);
  ConvertUCS4ToUTF8(ucs4,outstr);
  LocaleToUTF8:=outstr;
end;


function UTF8ToLocale(const s: utf8string): string;
var
 ucs4: ucs4string;
 charset: string;
 outstr: utf8string;
begin
  outstr:=s;
  UTF8ToLocale:=s;
  { Nothing to do, already correct format }
  if charset = 'UTF-8' then
    exit;
  charset:=GetActiveCharacterSet;
  ConvertUTF8ToUCS4(s,ucs4);
  ConvertFromUCS4(ucs4,outstr,charset);
  UTF8ToLocale:=outstr;
end;

function getuserfullname(account: utf8string): utf8string;
var
 p: putf8char;
 pass: ppasswd;
 s: string;
begin
  getuserfullname:='';
  p:=utf8strnewstr(account);
  if not assigned(p) then
    exit;
  pass:=sys_getpwnam(p);
  if assigned(pass) then
    begin
      s:=ansistrpas(pass^.pw_gecos);
      { !GECOS format! }
      { If there is an Ampersand, then capitalize the first
        letter of the login name, and add it ,used by LDAP sometimes. }
      if s[1] = '&' then
        begin
          delete(s,1,1);
          UpCase(account[1]);
          s:=account+s;          
        end;
      { Just keep the full name, no other data }  
      if pos(',',s) <> 0 then
        begin
         delete(s,pos(',',s),length(s));
        end;
      getuserfullname:=s;
    end;
  utf8strdispose(p);    
end;



{ Include generic posix functions }
{$i ..\posix\gextdos.inc}
