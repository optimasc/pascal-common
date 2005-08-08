{** This unit is used to validate and convert filenames 
    according to a specific filesystem convention. }
unit fs;



interface

uses unicode;


type

TDOSFileSystem = object
  function isValidFilename(s: ucs4string): boolean;
{ function isValidPathName(s: ucs4string): boolean;  }
{  function renameFileName(fname: ucs2string): utf8string;}
end;

TWin32FileSystem = object
  function isValidFilename(s: ucs4string): boolean;
end;


TPOSIXFileSystem = object
  function isValidFilename(s: ucs4string): boolean;
end;

TOS2FileSystem = object
  function isValidFilename(s: ucs4string): boolean;
end;

TAmigaFFSFileSystem = object
  function isValidFilename(s: ucs4string): boolean;
end;

TISO9660Level1FileSystem = object
  function isValidFilename(s: ucs4string): boolean;
end;

TISO9660Level2Filesystem = object
  function isValidFilename(s: ucs4string): boolean;
end;

TUDFFilesystem = object
  function isValidFilename(s: ucs4string): boolean;
end;

TJolietFileSystem = object
  function isValidFilename(s: ucs4string): boolean;
end;

THFSPlusFileSystem = object
  function isValidFilename(s: ucs4string): boolean;
end;


implementation

  {***************************************************************************************************}
  {                                MS-DOS / TOS / FAT12/FAT16 systems                                 }
  {***************************************************************************************************}
const  
  MAX_DOS_RESERVED = 22;
  MAX_DOS_FILENAME_LENGTH = 12;  { 8.3 }

  DOSFilenameChars = ['A'..'Z','0'..'9','_','^','$','~','!','#','%','&','-','{','}','(',')','@','''','`'];
  DOSSpecialNames : array[1..MAX_DOS_RESERVED] of string[16] =
   (
     'CON', 
     'PRN',
     'AUX',
     'NUL', 
     'COM1', 
     'COM2', 
     'COM3', 
     'COM4', 
     'COM5', 
     'COM6', 
     'COM7', 
     'COM8', 
     'COM9', 
     'LPT1', 
     'LPT2', 
     'LPT3', 
     'LPT4', 
     'LPT5', 
     'LPT6', 
     'LPT7', 
     'LPT8', 
     'LPT9'
   );

  function TDOSFileSystem.isValidFilename(s: ucs4string): boolean;
  var
    name: ucs4string;
    ext: ucs4string;
    idx: integer; 
    i: integer;
  begin
    isValidFilename:=false;
    ucs4_setlength(name,0);
    ucs4_setlength(ext,0);
    if (ucs4_length(s) > MAX_DOS_FILENAME_LENGTH) then
      exit;
    { Reserved names that are not allowed to be used in DOS systems }
    for i:=1 to MAX_DOS_RESERVED do
      begin
        if (ucs4_equalascii(s,DOSSpecialNames[i])) then
          exit;
        { Those reserved filenames with a dot are also not allowed }  
        if (ucs4_posascii(DOSSpecialNames[i]+'.',s)=1) then
          exit;
      end;
    { file extension separator }
    idx:=integer(ucs4_posascii('.',s));
    if idx > 0 then
      begin
        ucs4_copy(name,s,1,idx-1);
        ucs4_copy(ext,s,idx+1,ucs4_length(s));
      end
    else
      name:=s;
    for i:=1 to ucs4_length(name) do
      begin
        if not (chr(name[i]) in (DOSFilenameChars)) then
          exit;
      end;
    for i:=1 to ucs4_length(ext) do
      begin
        if not (chr(ext[i]) in DOSFilenameChars) then
          exit;
      end;
    isValidFilename:=true;
  end;

  {***************************************************************************************************}
  {                                  Windows / FAT12/FAT16 systems                                    }
  {***************************************************************************************************}
const
  MAX_WIN32_RESERVED = 22;
  MAX_WIN32_FILENAME_LENGTH = 255;

  WIN32DisallowedFilenameChars = [#0..#31,'<','>',':','"','/','\','|','?','*'];
  WIN32SpecialNames : array[1..MAX_WIN32_RESERVED] of string[16] =
   (
     'CON', 
     'PRN',
     'AUX',
     'NUL', 
     'COM1', 
     'COM2', 
     'COM3', 
     'COM4', 
     'COM5', 
     'COM6', 
     'COM7', 
     'COM8', 
     'COM9', 
     'LPT1', 
     'LPT2',
     'LPT3', 
     'LPT4', 
     'LPT5', 
     'LPT6', 
     'LPT7', 
     'LPT8', 
     'LPT9'
   );
  
  function TWin32FileSystem.isValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    isValidFilename:=false;
    if (ucs4_length(s) > MAX_WIN32_FILENAME_LENGTH) then
      exit;
    { Reserved names that are not allowed to be used in DOS systems }
    for i:=1 to MAX_WIN32_RESERVED do
      begin
        if (ucs4_equalascii(s,Win32SpecialNames[i])) then
          exit;
        { Those reserved filenames with a dot are also not allowed }  
        if (ucs4_posascii(Win32SpecialNames[i]+'.',s)=1) then
          exit;
      end;
    for i:=1 to ucs4_length(s) do 
      begin
        if (char(s[i]) in (Win32DisallowedFilenameChars)) then
          exit;      
        { Win32 only supports UCS-2, not UTF-16 nor UCS-4 }  
        if (s[i] > high(word)) or  (not ucs4_isvalid(s[i]) or (not ucs2_isvalid(s[i] and $ffff))) then
           exit;
      end;
    { The ending character of a filename should not be a . or space character }  
    if (s[ucs4_length(s)] = ucs4char(' ')) or (s[ucs4_length(s)] = ucs4char('.')) then
      exit;
    isValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                                     OS/2 filesystems                                              }
  {***************************************************************************************************}
  
const
  MAX_OS2_FILENAME_LENGTH = 254;

  function TOS2FileSystem.isValidFilename(s: ucs4string): boolean;
  var
    Win32Filesystem: TWin32FileSystem;
  begin
    isValidFilename:=false;
    if (ucs4_length(s) > MAX_OS2_FILENAME_LENGTH) then
      exit;
    { Every character is coded on a byte, it actually depends on the active codepage
      so only accept standard characters. 
    }  
(*    for i:=1 to ucs4_length(s) do
      begin
        if (s[i] > high(byte)) then
          
      end;*)
    isValidFilename:=Win32FileSystem.isValidFilename(s);   
  end;

  {***************************************************************************************************}
  {                               POSIX filesystems (with minimum values)                             }
  {***************************************************************************************************}
const
  MAX_POSIX_FILENAME_LENGTH = 14;
  MAX_POSIX_PATH_LENGTH = 256;
  POSIXFilenameChars = ['A'..'Z','a'..'z','0'..'9','.','_','-'];
  
  function TPOSIXFileSystem.isValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    isValidFilename:=false;
    if (ucs4_length(s) > MAX_POSIX_FILENAME_LENGTH) then
      exit;
    for i:=1 to ucs4_length(s) do
      begin
        if not (char(s[i]) in (POSIXFilenameChars)) then
          exit;      
      end;
    isValidFilename:=true;
  end;

  {***************************************************************************************************}
  {                               Amiga filesystems (FFS/OFS)                                         }
  {***************************************************************************************************}
const
  MAX_AMIGA_FILENAME_LENGTH = 30;
  {MAX_AMIGA_PATH_LENGTH = }
  
  { ISO-8859-1 characters are supported. }
  AmigaDisallowedFilenameChars = [#0..#31,'/',':',#128..#159];
  
  function TAmigaFFSFileSystem.isValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    isValidFilename:=false;
    if (ucs4_length(s) > MAX_AMIGA_FILENAME_LENGTH) then
      exit;
    for i:=1 to ucs4_length(s) do 
      begin
        if  (char(s[i]) in (AmigaDisallowedFilenameChars)) then
          exit;      
        { Noly the ISO-8859-1 character set is supported. }  
        if  (integer(s[i]) > high(byte)) then
          exit;
      end;
    isValidFilename:=true;
  end;

  {***************************************************************************************************}
  {                                  ISO 9660 filesystems                                             }
  {***************************************************************************************************}
const
  MAX_ISO9660LEVEL1_FILENAME_LENGTH = 12;
  MAX_ISO9660LEVEL2_FILENAME_LENGTH = 30;
  MAX_ISO9660LEVEL2_DIRECTORY_LENGTH = 31;
  MAX_PATH_DEPTH = 8;
  ISO9660FilenameChars = ['A'..'Z','0'..'9','_'];
  
  
  function TISO9660Level1FileSystem.isValidFilename(s: ucs4string): boolean;
  var
    name: ucs4string;
    ext: ucs4string;
    idx: integer; 
    i: integer;
  begin
    isValidFilename:=false;
    ucs4_setlength(name,0);
    ucs4_setlength(ext,0);
    if (ucs4_length(s) > MAX_ISO9660LEVEL1_FILENAME_LENGTH) then
      exit;
    { file extension separator }
    idx:=integer(ucs4_posascii('.',s));
    if idx > 0 then
      begin
        ucs4_copy(name,s,1,idx-1);
        ucs4_copy(ext,s,idx+1,ucs4_length(s));
      end
    else
      name:=s;
    for i:=1 to ucs4_length(name) do
      begin
        if not (chr(name[i]) in (ISO9660FilenameChars)) then
          exit;
      end;
    for i:=1 to ucs4_length(ext) do
      begin
        if not (chr(ext[i]) in ISO9660FilenameChars) then
          exit;
      end;
    isValidFilename:=true;
  end;

   function TISO9660Level2Filesystem.isValidFilename(s: ucs4string): boolean;
  var
    name: ucs4string;
    ext: ucs4string;
    idx: integer; 
    i: integer;
  begin
    isValidFilename:=false;
    ucs4_setlength(name,0);
    ucs4_setlength(ext,0);
    if (ucs4_length(s) > MAX_ISO9660LEVEL2_FILENAME_LENGTH) then
      exit;
    { file extension separator }
    idx:=integer(ucs4_posascii('.',s));
    if idx > 0 then
      begin
        ucs4_copy(name,s,1,idx-1);
        ucs4_copy(ext,s,idx+1,ucs4_length(s));
      end
    else
      name:=s;
    for i:=1 to ucs4_length(name) do 
      begin
        if not (chr(name[i]) in (ISO9660FilenameChars)) then
          exit;      
      end;
    for i:=1 to ucs4_length(ext) do
      begin
        if not (chr(ext[i]) in ISO9660FilenameChars) then
          exit;      
      end;
    isValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                                  UDF Filesystems (based on 1.02)                                  }
  {***************************************************************************************************}
const
  MAX_UDF_FILENAME_LENGTH = 255;
  MAX_UDF_PATH_LENGTH = 1023;
  
  function TUDFFileSystem.isValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    isValidFilename:=false;
    if (ucs4_length(s) > MAX_UDF_FILENAME_LENGTH) then
      exit;
    for i:=1 to ucs4_length(s) do 
      begin
        { Win32 only supports UCS-2, not UTF-16 nor UCS-4 }  
        if (s[i] > high(word)) or  (not ucs4_isvalid(s[i]) or (not ucs2_isvalid(s[i] and $ffff))) then
           exit;
      end;
    isValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                                  Joliet CDFS Extension                                            }
  {***************************************************************************************************}
const
  MAX_JOLIET_FILENAME_LENGTH = 64;
  JolietDisallowedFilenameChars = [#0..#31,'*','/',':',';','?','\'];
  
  function TJolietFileSystem.isValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    isValidFilename:=false;
    if (ucs4_length(s) > MAX_JOLIET_FILENAME_LENGTH) then
      exit;
    for i:=1 to ucs4_length(s) do 
      begin
        if char(s[i]) in JolietDisallowedFilenameChars then
           exit;
        { Joliet only supports UCS-2, not UTF-16 nor UCS-4 }  
        if (s[i] > high(word)) or  (not ucs4_isvalid(s[i]) or (not ucs2_isvalid(s[i] and $ffff))) then
           exit;
      end;
    isValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                                 HFS Plus Filesystem                                               }
  {***************************************************************************************************}
const
  MAX_HFSPLUS_FILENAME_LENGTH = 255;
  HFSPlusDisallowedFilenameChars = [':',#0];
  
  function THFSPlusFileSystem.isValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    isValidFilename:=false;
    if (ucs4_length(s) > MAX_HFSPLUS_FILENAME_LENGTH) then
      exit;
    for i:=1 to ucs4_length(s) do 
      begin
        if char(s[i]) in HFSPlusDisallowedFilenameChars then
           exit;
        { Joliet only supports UCS-2, not UTF-16 nor UCS-4 }  
        if (s[i] > high(word)) or  (not ucs4_isvalid(s[i]) or (not ucs2_isvalid(s[i] and $ffff))) then
           exit;
      end;
    isValidFilename:=true;
  end;
  
  
  
    
end.

{
  $Log: not supported by cvs2svn $
}




