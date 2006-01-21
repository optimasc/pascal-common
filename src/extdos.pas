unit extdos;

interface


uses 
   tpautils,
   fpautils,
   dpautils,
   vpautils,
   utils,
   unicode,
   dateutil,
{$IFDEF WIN32}
   windows,
{$ENDIF}
   fileio,
   dos;




const
  {** Return code: No error in operation }  
  EXTDOS_STATUS_OK = 0;
  {** Return code: This routine is unsupported on this operating system. }
  EXTDOS_STATUS_UNSUPPORTED = -1;
  {** Return code: Conversion operation from native date to TDateTime was invalid. }
  EXTDOS_STATUS_DATE_CONVERT_ERROR = -2;
  {** Return code: Filesystem does not support this date }
  EXTDOS_STATUS_DATE_UNSUPPORTED = -3;

type
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



  {** Information on file associations for the shell }
  TFileAssociation = record
    appname: utf8string;
    exename: utf8string;
  end;


  tresourceattributes = set of tresourceattribute;

  TFileStats = record
    {** Name of the resource on disk }
    name: utf8string;
    {** Size of the resource on disk }
    size: big_integer_t;
    {** Owner (User name) of the resource on disk }
    owner: utf8string;
    {** Creation time of the resource }
    ctime: TDateTime;
    {** Last modification time of the resource }
    mtime: TDateTime;
    {** Last access time of the resource }
    atime: TDateTime;
    {** Number of links to resource }
    nlink: integer;
    {** Attributes for this file *}
    attributes: tresourceattributes;
    {** association for this file (operating system) *}
    association: tfileassociation;
    {** number of parallel streams for this resource *}
    streamcount: integer;
    {** number of file accesses since file's creation *}
    accesses: integer;
    {** indicates if the times are in UTC format,
        this is always true, unless the filesystem
        does not support this information.
    *}
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
    {** Directory where this file is located *}
    dirstr: utf8string;
  end;
  
  
{$i extdosh.inc}  



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
function getfileowner(fname: putf8char): utf8string;

{** @abstract(Returns the last access date and time of a file)

   This returns the last access time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file access date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function getfileatime(fname: putf8char; var atime: TDateTime): integer;

{** @abstract(Returns the last modification date and time of a file) 

   This returns the last modification time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file modification date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function getfilemtime(fname: putf8char; var mtime: TDateTime): integer;

{** @abstract(Returns the creation date and time of a file) 

   This returns the creation time of a file in UTC 
   coordinates. Returns 0 if there was no error, otherwise
   returns an operating system (if positive) or module (if negative)  
   specific error code.

   @param(fname The filename to access (UTF-8 encoded))
   @param(atime The file creation date in UTC/GMT format)
   @returns(0 on success, otherwise an error code)
}
function getfilectime(fname: putf8char; var ctime: TDateTime): integer;

{** @abstract(Returns the size of a file).

   @returns(If error returns big_integer_t(-1), otherwise
     the size of the file is returned.)
}
function getfilesize(fname: putf8char): big_integer_t;

{** @abstract(Returns the attributes of a file).

   @returns(If error returns big_integer_t(-1), otherwise
     the size of the file is returned.)
}
function getfileattributes(fname: putf8char): tresourceattributes;



{** @abstract(Returns information on a file).

   Returns information on a directory or file given
   by the complete file specification to the file.

   @returns(0 if no error, otherwise, an error code)
}
function getfilestats(fname: putf8char; var stats: TFileStats): integer;


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
function setfileatime(fname: putf8char; newatime: tdatetime): integer;

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
function setfilemtime(fname: putf8char; newmtime: tdatetime): integer;

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
function setfilectime(fname: putf8char; newctime: tdatetime): integer;

{**
   @returns(0 on success, otherwise an error code)
}   
function findfirstex(path: putf8char; attr: tresourceattributes; var SearchRec:TSearchRecExt): integer;

{**
   @returns(0 on success, otherwise an error code)
}   
function findnextex(var SearchRec: TSearchRecExt): integer;

procedure findcloseex(var SearchRec: TSearchRecExt);



{************************************************************************}
{                           Account management                           }
{************************************************************************}



{** @abstract(Returns a full name from an account name)

    From a login name, returns the full name of the
    user of this account.
    
    @param(fname The account name)
    @returns(The full name of the user, or an empty string
      upon error or if unknown or unsupported.
}    
function getuserfullname(account: utf8string): utf8string;

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

{$i extdos.inc}

{
  $Log: not supported by cvs2svn $
  Revision 1.5  2005/11/09 05:15:34  carl
    + DirectoryExists and FileExists added

  Revision 1.4  2005/07/20 03:13:25  carl
   + Documentation

  Revision 1.3  2004/12/26 23:31:34  carl
    * now empty skeleton, so it is portable

}
