{
 ****************************************************************************
    $Id: extdos.pas,v 1.10 2012-02-16 05:40:08 carl Exp $
    Copyright (c) 2004-2006 by Carl Eric Codere

    Extended Operating system routines

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}
{** @author(Carl Eric Codère)
    @abstract(Extended Operating system routines)

    Routines that extend the capabilities of the 
    pascal DOS unit. It supports more information extraction
    from the operating system.
    
    Everything string returned and input is/should be encoded
    in UTF-8 format.
    
    Currently this unit is only supported on the Win32 platform.

}
unit extdos;

interface


uses 
   cmntyp,
   sysutils,
   cmnutils,
   unicode,
   dateutil,
{$IFDEF WIN32}
   windows,
{$ENDIF}
{$IFDEF UNIX}
   posix,
{$ENDIF}
   fileio,
   dos;




const
  {** Return code: No error in operation }  
  EXTDOS_STATUS_OK = 0;
  {** Return code: This routine is unsupported on this operating system. }
  EXTDOS_STATUS_UNSUPPORTED = -1;
  {** Return code: Conversion operation from native date to TJuliandDate was invalid. }
  EXTDOS_STATUS_DATE_CONVERT_ERROR = -2;
  {** Return code: Filesystem does not support this date }
  EXTDOS_STATUS_DATE_UNSUPPORTED = -3;

type
  {** @abstract(Possible attributes of a resource) }
  tresourceattribute =
   (
     { Any attribute, including no attributes, FOR FIND routines only }
     attr_any,
     {** Resource is read-only globally }
     attr_readonly,
     {** Resource is hidden }
     attr_hidden,
     {** Resource is a system resource }
     attr_system,
     {** Resource is an archive }
     attr_archive,
     {** Resource is a link }
     attr_link,
     {** Resource is a directory }
     attr_directory,
     {** resource is a temporary resource }
     attr_temporary,
     {** resource is encrypted by the operating system }
     attr_encrypted,
     {** resource should not be indexed }
     attr_no_indexing,
     {** resource is a device }
     attr_device,
     {** resource contains extended attributes/reparse point }
     attr_extended,
     {** resource is compressed by the filesystem }
     attr_compressed,
     {** Resource is actually offline }
     attr_offline,
     {** Resource is a sparse file }
     attr_sparse
   );



  {** @abstract(Information on file associations for the shell) }
  TFileAssociation = record
    {** Application name associated with this resource }
    appname: utf8string;
    {** Application executable and parameters to use on this type of resource }
    exename: utf8string;
  end;


  tresourceattributes = set of tresourceattribute;

  {** Statistics for a resource on disk. as returned by @link(getfilestats) }
  TFileStats = record
    {** Name of the resource on disk }
    name: utf8string;
    {** Size of the resource on disk }
    size: big_integer_t;
    {** Owner (User name) of the resource on disk }
    owner: utf8string;
    {** Creation time of the resource }
    ctime: TJuliandDate;
    {** Last modification time of the resource }
    mtime: TJuliandDate;
    {** Last access time of the resource }
    atime: TJuliandDate;
    {** Number of links to resource }
    nlink: integer;
    {** Attributes for this file }
    attributes: tresourceattributes;
    {** association for this file (operating system) }
    association: tfileassociation;
    {** number of parallel streams for this resource }
    streamcount: integer;
    {** number of file accesses since file's creation }
    accesses: integer;
    {** indicates if the times are in UTC format,
        this is always true, unless the filesystem
        does not support this information.
    }
    utc: boolean;
    {** Device where this file resides, this value
        is represented as an hexadecimal null terminated
        string and is operating system dependent. }
    dev: array[0..127] of char;
    {** Unique file serial number, this may change from
        one boot to the next.}
    ino: array[0..127] of char;
    {** Comment associated with this file type (as stored by the operating system) }
    comment: utf8string;
    {** Directory where this file is located }
    dirstr: utf8string;
  end;
  
{$IFNDEF PASDOC}  
{$i extdosh.inc}  
{$ELSE}
{$i win32\extdosh.inc}  
{$ENDIF}



{************************************************************************}
{                         File management routines                       }
{************************************************************************}

{** @abstract(Returns the file owner account name)

    This routine returns the owner/creator of this resource as a
    login user name. This is usually the user name when the user logged 
    on to the system.  If this routine is not supported, or if there was an error, 
    this  routine returns an empty string.
    
    @param(fname The filename to access (UTF-8 encoded))
    @returns(The account name on success, otherwise an empty string)
}    
function GetFileOwner(fname: putf8char): utf8string;

{** @abstract(Returns the last access date and time of a file)

   This returns the last access time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file access date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function GetFileATime(fname: putf8char; var atime: TJuliandDate): integer;

{** @abstract(Returns the last modification date and time of a file) 

   This returns the last modification time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file modification date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function GetFileMTime(fname: putf8char; var mtime: TJuliandDate): integer;

{** @abstract(Returns the creation date and time of a file) 

   This returns the creation time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file creation date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function GetFileCTime(fname: putf8char; var ctime: TJuliandDate): integer;

{** @abstract(Returns the size of a file).

   @returns(If error returns big_integer_t(-1), otherwise
     the size of the file is returned.)
}
function GetFilesize(fname: putf8char): big_integer_t;

{** @abstract(Returns the attributes of a file).

   @returns(If error returns big_integer_t(-1), otherwise
     the size of the file is returned.)
}
function GetFileAttributes(fname: putf8char): tresourceattributes;



{** @abstract(Returns information on a file).

   Returns information on a directory or file given
   by the complete file specification to the file.

   @returns(0 if no error, otherwise, an error code)
}
function GetFilestats(fname: putf8char; var stats: TFileStats): integer;


{** 
     @abstract(Verifies the existence of a directory)
     This routine verifies if the directory named can be
     opened or if it actually exists.

     @param DName Name of the directory to check
     @returns FALSE if the directory cannot be opened or if it does not exist.
}
function DirectoryExists(DName : utf8string): Boolean;

{** 
     @abstract(Verifies the existence of a filename)
     This routine verifies if the file named can be
     opened or if it actually exists.

     @param FName Name of the file to check
     @returns FALSE if the file cannot be opened or if it does not exist.
}
Function FileExists(const FName : utf8string): Boolean;


{**
   @abstract(Returns the current active directory)
   
   @param(DirStr The current directory for the process)
   @return(true on success, otherwise false)
}
function GetCurrentDirectory(var DirStr: utf8string): boolean;

{**
   @abstract(Sets the current active directory)
   
   @param(DirStr The current directory to select for the process)
   @return(true on success, otherwise false)
}
function SetCurrentDirectory(const DirStr: utf8string): boolean;


{** @abstract(Change the last access time of a file) 

   Changes the access time of a file. The time
   should be in UTC coordinates. 
   
   If the time is not supported (for example
   a year of 1900 on UNIX system), then an error
   will be reported and no operation will be performed.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The new access time)
   @returns(0 on success, otherwise an error code)
}
function SetFileATime(fname: putf8char; newatime: TJuliandDate): integer;

{** @abstract(Change the modification time of a file) 

   Changes the modification time of a file. The time
   should be in UTC coordinates. 
   
   If the time is not supported (for example
   a year of 1900 on UNIX system), then an error
   will be reported and no operation will be performed.

   @param(fname The filename to access (UTF-8 encoded))
   @param(mtime The new modification time)
   @returns(0 on success, otherwise an error code)
}
function SetFileMTime(fname: putf8char; newmtime: TJuliandDate): integer;

{** @abstract(Change the creation time of a file) 

   Changes the creation time of a file. The time
   should be in UTC coordinates. 
   
   If the time is not supported (for example
   a year of 1900 on UNIX system), then an error
   will be reported and no operation will be performed.

   @param(fname The filename to access (UTF-8 encoded))
   @param(mtime The new modification time)
   @returns(0 on success, otherwise an error code)
}
function SetFileCTime(fname: putf8char; newctime: TJuliandDate): integer;

{** @abstract(Searches the specified directory for the first entry
     matching the specified file name and set of attributes.)
     
   @returns(0 on success, otherwise an error code)
}   
function FindFirstEx(path: putf8char; attr: tresourceattributes; var SearchRec:TSearchRecExt): integer;

{** @abstract(Returns the next entry that matches the name and
      name specified in a previous call to @link(FindFirstEx).)

   @returns(0 on success, otherwise an error code)
}   
function FindNextEx(var SearchRec: TSearchRecExt): integer;

{** @abstract(Closes the search and frees the resources
      previously allocated by a call to  @link(FindFirstEx).)

   @returns(0 on success, otherwise an error code)
}   
procedure FindCloseEx(var SearchRec: TSearchRecExt);



{************************************************************************}
{                           Account management                           }
{************************************************************************}



{** @abstract(Returns a full name from an account name)

    From a login name, returns the full name of the
    user of this account.
    
    @param(fname The account name)
    @returns(The full name of the user, or an empty string
      upon error or if unknown or unsupported.)
}    
function GetUserFullName(account: utf8string): utf8string;

{** @abstract(Returns the path of the current
        user's application data configuration directory)

   This routine returns the current path where private
   application configuration data should be stored for the 
   logged-on user. If the path does not exist, it is created
   first. 
        
   @returns(The full path to the requested information, or
      an empty string if an error occured).
}
function GetLoginConfigDirectory: utf8string;

{** @abstract(Returns the path of the current
        shared application data configuration directory)
        
   This routine returns the current path where shared
   application configuration data should be stored for the 
   logged-on user. If the path does not exist, it is created
   first.
        
   @returns(The full path to the requested information, or
      an empty string if an error occured).

}
function GetGlobalConfigDirectory: utf8string;


{** @abstract(Returns the path of the user's home directory)

    This routine returns the path of the currently logged in
    user's home directory.
}
function GetLoginHomeDirectory: utf8string;


{** @abstract(Returns the configured language code of the user)
}
{function GetLoginLanguage: string;}

{** @abstract(Returns the configured country code of the user)
}
{function GetLoginCountryCode: string}

{** @abstract(Returns the account name of the currently logged in user)
}
{function GetLogin: utf8string}


implementation

{$IFNDEF PASDOC}  
{$i extdos.inc}  
{$ELSE}
{$i win32\extdos.inc}  
{$ENDIF}

{
  $Log: not supported by cvs2svn $
  Revision 1.9  2011/11/24 00:27:37  carl
  + update to new architecture of dates and times, as well as removal of some duplicate files.

  Revision 1.8  2006/10/16 22:21:51  carl
  + extdos Initial Linux support

  Revision 1.7  2006/08/31 03:08:31  carl
  + Better documentation
  * Change case of some routines so they are consistent with other routines of this unit

  Revision 1.6  2006/01/21 22:32:18  carl
    + GetCurrentDirectory/SetCurrentDirectory

  Revision 1.5  2005/11/09 05:15:34  carl
    + DirectoryExists and FileExists added

  Revision 1.4  2005/07/20 03:13:25  carl
   + Documentation

  Revision 1.3  2004/12/26 23:31:34  carl
    * now empty skeleton, so it is portable

}
