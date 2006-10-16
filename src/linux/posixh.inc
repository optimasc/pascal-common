{
    $Id: posixh.inc,v 1.1 2006-10-16 22:28:04 carl Exp $

 **********************************************************************}
 
const
    { POSIX limits, used for buffer and stack allocation }
    ARG_MAX = 131072;   { Maximum number of argument size     }
    NAME_MAX = 255;     { Maximum number of bytes in filename }
    PATH_MAX = 4096;    { Maximum number of bytes in pathname }
    


{***********************************************************************}
{                       POSIX TYPE DEFINITIONS                          }
{***********************************************************************}

type
    { the following type definitions are compiler dependant }
    { and system dependant                                  }

    cint  = longint;        { minimum range is : 32-bit                   }
    cuint = longword;       { minimum range is : 32-bit                   }


    dev_t  = array[1..8] of byte;        { used for device numbers      }
    gid_t  = longword;        { used for group IDs           }
    ino_t  = longword;        { used for file serial numbers }
    mode_t = longword;        { used for file attributes     }
    nlink_t  = longword;      { used for link counts         }
    off_t  = longword;        { used for file sizes          }
    pid_t  = longword;        { used as process identifier   }
    size_t = longword;        { as definied in the C standard }
    ssize_t = longword;       { used by function for returning number of bytes }
    uid_t = longword;         { used for user ID type        }
    time_t = longword;        { used for returning the time (C standard)  }

{***********************************************************************}
{                         POSIX STRUCTURES                              }
{***********************************************************************}
CONST

     _POSIX_VERSION = 199506;
     
     
    _UTSNAME_LENGTH = 64;
    _UTSNAME_NODENAME_LENGTH = 0;

TYPE
   { system information services }
   utsname = packed record   { don't forget to verify the alignment }
    sysname,
    nodename,
    release,
    version,
    machine,
    domainname : Array[0.._UTSNAME_LENGTH] of char;
   end;


  { file characteristics services }
   stat_t = packed record { verify the alignment of the members }
    st_dev     : dev_t;    
    pad1       : word;
    apad1      : word;  { alignment padding }
    st_ino     : ino_t;
    st_mode    : mode_t;
    st_nlink  : nlink_t;
    st_uid    : uid_t;
    st_gid    : gid_t;
    st_rdev    : dev_t;
    pad2      : word;
    apad2      : word;  { alignment padding }
    st_size   : off_t;
    st_blksze  : longword;
    st_blocks  : longword;
    st_atime   : time_t;
    unused1 : longword;
    st_mtime   : time_t;
    unused2 : longword;
    st_ctime   : time_t;
    unused3,
    unused4,
    unused5 : longword;
{    reserved: array[0..255] of byte;}
   end;

  { directory services }
   pdirent = ^dirent;
   dirent = packed record    { directory entry record - verify alignment }
    d_ino    : ino_t;
    d_off    : off_t;
    d_reclen : word;
    d_type : byte;
    d_name   : array [0..NAME_MAX] of char;
   end;

   pdir = ^dir;
   dir = packed record
   end;

   { Password structure }
   ppasswd = ^passwd;
   passwd = packed record
     pw_name: pchar;        { user name }
     pw_passwrd: pchar;     { user password }
     pw_uid    : uid_t;     { user ID       }
     pw_gid    : gid_t;     { group ID      }
     pw_gecos  : pchar;     { real name     }
     pw_dir    : pchar;     { home directory }
     pw_shell  : pchar;     { shell program  }
   end;
   
   { Filetime modification buffer }
   utimbuf = packed record
    actime: time_t;
    modtime: time_t;
   end;
   
   { Flock structure }
   pflock = ^flock;
   flock = packed record
     l_type: word;
     l_whence: word;
     l_start: off_t;
     l_len: off_t;
     l_pid: off_t;
   end;

{***********************************************************************}
{                  POSIX CONSTANT ROUTINE DEFINITIONS                   }
{***********************************************************************}
CONST
    { access routine - these maybe OR'ed together }
    F_OK        =  0;   { test for existence of file }
    R_OK        =  4;   { test for read permission on file }
    W_OK        =  2;   { test for write permission on file }
    X_OK        =  1;   { test for execute or search permission }
    
    { seek routine }
    SEEK_SET    = 0;    { seek from beginning of file }
    SEEK_CUR    = 1;    { seek from current position  }
    SEEK_END    = 2;    { seek from end of file       }
    { open routine                                 }
    { File access modes for `open' and `fcntl'.    }
    O_RDONLY    =  0; { Open read-only.  }
    O_WRONLY    =  1; { Open write-only. }
    O_RDWR      =  2; { Open read/write. }
    { Bits OR'd into the second argument to open.  }
    O_CREAT     =  1 shl 6; { Create file if it doesn't exist.  }
    O_EXCL      =  2 shl 6; { Fail if file already exists.      }
    O_TRUNC     =  1 shl 9; { Truncate file to zero length.     }
    O_NOCTTY    =  4 shl 6; { Don't assign a controlling terminal. }
    { File status flags for `open' and `fcntl'.  }
    O_APPEND    =  2 shl 9; { Writes append to the file.        }
    O_NONBLOCK =   4 shl 9; { Non-blocking I/O.                 }

    { mode_t possible values                                 }
     S_IRWXO = $7;
     S_IROTH = $4;
     S_IWOTH = $2;
     S_IXOTH = $1;

     S_IRWXG = S_IRWXO shl 3;
     S_IRGRP = S_IROTH shl 3;
     S_IWGRP = S_IWOTH shl 3;
     S_IXGRP = S_IXOTH shl 3;

     S_IRWXU = S_IRWXO shl 6;
     S_IRUSR = S_IROTH shl 6;
     S_IWUSR = S_IWOTH shl 6;

    { Used for waitpid }
    WNOHANG   = 1;               { don't block waiting               }
    WUNTRACED = 2;               { report status of stopped children }
    
    F_GETLK   = 5;
    F_SETLK   = 6; 
    F_SETLKW  = 7; 

    
    {*************************************************************************}
    {                               SIGNALS                                   }
    {*************************************************************************}
    
    {$i signal.inc}


{
  $Log: not supported by cvs2svn $

}