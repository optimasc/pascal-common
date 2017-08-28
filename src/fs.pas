{** @abstract(Returns information on different filesystem types.) 

    @author(Carl Eric Codere)
}
unit fs;
{==== Compiler directives ===========================================}
{$B-} { Full boolean evaluation          }
{$I-} { IO Checking                      }
{$F+} { FAR routine calls                }
{$P-} { Implicit open strings            }
{$T-} { Typed pointers                   }
{$V+} { Strict VAR strings checking      }
{$X-} { Extended syntax                  }
{$IFNDEF TP}
 {$H-} { Memory allocated strings        }
 {$DEFINE ANSISTRINGS}
 {$J+} { Writeable constants             }
 {$METHODINFO OFF}
{$ENDIF}
{====================================================================}
{$IFDEF FPC}
{$MODE OBJFPC}
{$ENDIF}


interface

uses unicode;


type

  {** Enumeration of possible filesystem types }
  TFilesystem = 
   (
    {** FAT12/FAT16 MS-DOS compatible filesystem }
    fsFAT,
    {** NTFS compatible filesystem (Windows NT and later) }
    fsNTFS,
    {** Base POSIX-1995 filesystem.  }
    fsPOSIX,
    {** HPFS compatible filesystem (OS/2)}
    fsHPFS,
    {** FFS compatible filesystem (AmigaOS)}
    fsFFS,
    {** ISO 9660 Level 1 compatible filesystem }
    fsISO9660lvl1,
    {** ISO 9660 Level 2 compatible filesystem }
    fsISO9660lvl2,
    {** UDF compatible filesystem }
    fsUDF,
    {** MacOS HFS+ compatible filesystem }
    fsHFSPlus,
    {** Joliet compatible filesystem }
    fsJoliet
    );
    
    
    
{** @abstract(Returns true if the specified filename is valid for the specified filesystem) 

    @param(s The name to verify)
    @param(fs The filesystem to check against)
    @returns(true if the filename is valid, otherwise returns false)
}
Function FSIsValidFileName(s: ucs4string; fs: TFileSystem): boolean;    

{** @abstract(Returns the maximum filename length allowed for the specified filesystem) 

    @param(fs The filesystem to check against)
    @returns(The maximum allowed length of the filename in bytes)
}
Function FSGetMaxFilenameLength(fs: TFileSystem): integer;    


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

  function fsFATisValidFilename(s: ucs4string): boolean;
  var
    name: ucs4string;
    ext: ucs4string;
    idx: integer; 
    i: integer;
  begin
    fsFATisValidFilename:=false;
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
    fsFATisValidFilename:=true;
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
  
  function fsNTFSisValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    fsNTFSisValidFilename:=false;
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
    fsNTFSisValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                                     OS/2 filesystems                                              }
  {***************************************************************************************************}
  
const
  MAX_OS2_FILENAME_LENGTH = 254;

  function fsHPFSisValidFilename(s: ucs4string): boolean;
  begin
    fsHPFSisValidFilename:=false;
    if (ucs4_length(s) > MAX_OS2_FILENAME_LENGTH) then
      exit;
    { Every character is coded on a byte, it actually depends on the active codepage
      so only accept standard characters. 
    }  
(*    for i:=1 to ucs4_length(s) do
      begin
        if (s[i] > high(byte)) then
          
      end;*)
    fsHPFSisValidFilename:=fsNTFSisValidFilename(s);   
  end;

  {***************************************************************************************************}
  {                               POSIX filesystems (with minimum values)                             }
  {***************************************************************************************************}
const
  MAX_POSIX_FILENAME_LENGTH = 14;
  MAX_POSIX_PATH_LENGTH = 256;
  POSIXFilenameChars = ['A'..'Z','a'..'z','0'..'9','.','_','-'];
  
  function fsPosixisValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    fsPosixisValidFilename:=false;
    if (ucs4_length(s) > MAX_POSIX_FILENAME_LENGTH) then
      exit;
    for i:=1 to ucs4_length(s) do
      begin
        if not (char(s[i]) in (POSIXFilenameChars)) then
          exit;      
      end;
    fsPosixisValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                               Amiga filesystems (FFS/OFS)                                         }
  {***************************************************************************************************}
const
  MAX_AMIGA_FILENAME_LENGTH = 30;
  {MAX_AMIGA_PATH_LENGTH = }
  
  { ISO-8859-1 characters are supported. }
  AmigaDisallowedFilenameChars = [#0..#31,'/',':',#128..#159];
  
  function fsFFSisValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    fsFFSisValidFilename:=false;
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
    fsFFSisValidFilename:=true;
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
  
  
  function fsISO9660Level1isValidFilename(s: ucs4string): boolean;
  var
    name: ucs4string;
    ext: ucs4string;
    idx: integer; 
    i: integer;
  begin
    fsISO9660Level1isValidFilename:=false;
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
    fsISO9660Level1isValidFilename:=true;
  end;

  function fsISO9660Level2isValidFilename(s: ucs4string): boolean;
  var
    name: ucs4string;
    ext: ucs4string;
    idx: integer; 
    i: integer;
  begin
    fsISO9660Level2isValidFilename:=false;
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
    fsISO9660Level2isValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                                  UDF Filesystems (based on 1.02)                                  }
  {***************************************************************************************************}
const
  MAX_UDF_FILENAME_LENGTH = 255;
  MAX_UDF_PATH_LENGTH = 1023;
  
  function fsUDFisValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    fsUDFisValidFilename:=false;
    if (ucs4_length(s) > MAX_UDF_FILENAME_LENGTH) then
      exit;
    for i:=1 to ucs4_length(s) do 
      begin
        { Win32 only supports UCS-2, not UTF-16 nor UCS-4 }  
        if (s[i] > high(word)) or  (not ucs4_isvalid(s[i]) or (not ucs2_isvalid(s[i] and $ffff))) then
           exit;
      end;
    fsUDFisValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                                  Joliet CDFS Extension                                            }
  {***************************************************************************************************}
const
  MAX_JOLIET_FILENAME_LENGTH = 64;
  JolietDisallowedFilenameChars = [#0..#31,'*','/',':',';','?','\'];
  
  function fsJolietisValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    fsJolietisValidFilename:=false;
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
    fsJolietisValidFilename:=true;
  end;
  
  {***************************************************************************************************}
  {                                 HFS Plus Filesystem                                               }
  {***************************************************************************************************}
const
  MAX_HFSPLUS_FILENAME_LENGTH = 255;
  HFSPlusDisallowedFilenameChars = [':',#0];
  
  function fsHFSPlusisValidFilename(s: ucs4string): boolean;
  var
    i: integer;
  begin
    fsHFSPlusisValidFilename:=false;
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
    fsHFSPlusisValidFilename:=true;
  end;

Type
 TIsValidFileNameFunc = function (s: ucs4string): boolean;

const ValidFileNameFuncs : Array[TFileSystem] of TIsValidFilenameFunc = 
(
  {$ifdef fpc}@{$endif}fsFATisValidFilename,
  {$ifdef fpc}@{$endif}fsNTFSisValidFilename,
  {$ifdef fpc}@{$endif}fsPOSIXisValidFilename,
  {$ifdef fpc}@{$endif}fsHPFSisValidFilename,
  {$ifdef fpc}@{$endif}fsFFSisValidFilename,
  {$ifdef fpc}@{$endif}fsISO9660Level1isValidFilename,
  {$ifdef fpc}@{$endif}fsISO9660Level2isValidFilename,
  {$ifdef fpc}@{$endif}fsUDFisValidFilename,
  {$ifdef fpc}@{$endif}fsHFSPlusIsValidFilename,
  {$ifdef fpc}@{$endif}fsJolietIsValidFilename
);

const MaxFilenameLength: Array[TFileSystem] of integer =
(
    {** FAT12/FAT16 MS-DOS compatible filesystem }
    MAX_DOS_FILENAME_LENGTH,
    {** NTFS compatible filesystem (Windows NT and later) }
    MAX_WIN32_FILENAME_LENGTH,
    {** Base POSIX-1995 filesystem.  }
    MAX_POSIX_FILENAME_LENGTH,
    {** HPFS compatible filesystem (OS/2)}
    MAX_OS2_FILENAME_LENGTH,
    {** FFS compatible filesystem (AmigaOS)}
    MAX_AMIGA_FILENAME_LENGTH,
    {** ISO 9660 Level 1 compatible filesystem }
    MAX_ISO9660LEVEL1_FILENAME_LENGTH,
    {** ISO 9660 Level 2 compatible filesystem }
    MAX_ISO9660LEVEL2_FILENAME_LENGTH,
    {** UDF compatible filesystem }
    MAX_UDF_FILENAME_LENGTH,
    {** MacOS HFS+ compatible filesystem }
    MAX_HFSPLUS_FILENAME_LENGTH,
    {** Joliet compatible filesystem }
    MAX_JOLIET_FILENAME_LENGTH
);
 
  
Function FSIsValidFileName(s: ucs4string; fs: TFileSystem): boolean;
var 
 Func:TIsValidFileNameFunc;
Begin
  Func:=ValidFileNameFuncs[fs];
  FSIsValidFileName:=Func(s);
end;


Function FSGetMaxFilenameLength(fs: TFileSystem): integer;    
Begin
 FSGetMaxFilenameLength:=MaxFileNameLength[fs]; 
end;
  
    
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2005/11/09 05:18:57  carl
    + GetMaxFileNameLength added

  Revision 1.1  2005/08/08 12:03:44  carl
    + AddDoubleQuotes/RemoveDoubleQuotes
    + Add support for RemoveAccents in unicode

}




