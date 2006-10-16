{
    $Id: posix.pas,v 1.1 2006-10-16 22:28:02 carl Exp $

    Implements POSIX 1003.1-2001 conforming interface

 ****************************************************************************
}
unit posix;

interface

  {$linklib localc}
  {$linklib extra}
  {$linklib gcc_eh}
//   {$linklib c}


  {$i posixh.inc}
  
  var
     Errno : cint; external name 'errno';


    { dirent.h }
    function sys_opendir(const dirname : pchar): pdir; cdecl; external name 'opendir';
    function sys_readdir(dirp : pdir) : pdirent;cdecl; external name 'readdir';
    function sys_closedir(dirp : pdir): cint; cdecl; external name 'closedir';
    
    { fcntl.h }
    function sys_open(const path: pchar; flags : cint; mode: mode_t):cint; cdecl; external name 'open';
    function sys_fcntl(fildes: cint; cmd: cint; lock: pflock): cint; cdecl; external name 'fcntl';
    
    { grp.h }
{    getgrgid()
    getgrnam()}
    
    { pwd.h }
    function sys_getpwuid(uid: longword): ppasswd; cdecl; external name 'getpwuid';
    function sys_getpwnam(const name: pchar): ppasswd; cdecl; external name 'getpwnam';
    
    { signal.h }    
    function sigaction(sig: cint; var act : sigactionrec; var oact : sigactionrec): cint; cdecl; external name 'sigaction';
(*    function sigemptyset(var sigset_t set):cint;
    function sigfillset(var sigset_t set):cint;
    function sigaddset(var sigset_t set; signo: cint): cint;
    function sigdelset(var sigset_t set; signo: cint): cint;
    function sigismember(const sigset_t set; signo: cint): cint;
    function sigprocmask(how: cint; const set: psigset_t; var oset: sigset_t): cint;
    function sigpending(var set: sigset_t): cint;
    function sigsuspend(const sigmask: psigset_t): cint;
    function sigwait(const sigmask: psigset_t; var sig: cint): cint;*)
    
    { stat.h }
    function sys_fstat(fd : cint; var sb : stat_t): cint; cdecl; external name 'fstat';
    function sys_stat(const path: pchar; var buf : stat_t): cint; cdecl; external name 'stat';
    function sys_lstat(const path: pchar; var buf : stat_t): cint; cdecl; external name 'lstat';
    function sys_chmod(const path: pchar; mode: mode_t): cint; cdecl; external name 'chmod';
    function sys_chown(const path: pchar; owner: uid_t; group: gid_t): cint; cdecl; external name 'chown';
    function sys_umask(cmask: mode_t): mode_t; cdecl; external name 'umask';
    
    { sys/times.h }
    {function times(): clock_t; cdecl; external name 'times';}
    
    { sys/utsname.h }
    function sys_uname(var name: utsname): cint; cdecl; external name 'uname';
    
    { sys/types.h }
    function sys_fork : pid_t; cdecl; external name 'fork';
    (*function kill(pid_t pid, int sig): cint;
    function getpid: pid_t;
    function getppid: pid_t;
    function getuid: uid_t;
    function geteuid: uid_t;
    function getgid: gid_t;
    function getegid: gid_t;
    function setuid(uid: uid_t): cint;
    function setgid(gid: gid_t): cint;*)
    
    { time.h }
    function sys_time(var tloc:time_t): time_t; cdecl; external name 'time';
    
    { wait.h }
    function sys_wait(var stat_loc: cint): pid_t; cdecl; external name 'wait';
    function sys_waitpid(pid : pid_t; var stat_loc : cint; options: cint): pid_t; cdecl; external name 'waitpid';
    
    { utime.h }
    function sys_utime(const path: pchar; const ptimes): cint; cdecl; external name 'utime';
    
    
    procedure sys_exit(status : cint); cdecl; external name '_exit';
    

    function sys_execve(const path : pchar; const argv : ppchar; const envp: ppchar): cint; cdecl; external name 'execve';
    
    function sys_alarm(seconds: cuint): cuint; cdecl; external name 'alarm';
    function sys_pause: cint; cdecl; external name 'pause';
    function sys_sleep(seconds: cuint): cuint; cdecl; external name 'sleep';
    function sys_getlogin: pchar; cdecl; external name 'getlogin';
    
    
    

    
    function sys_chdir(const path : pchar): cint; cdecl; external name 'chdir';
    function sys_mkdir(const path : pchar; mode: mode_t):cint; cdecl; external name 'mkdir';
    function sys_unlink(const path: pchar): cint; cdecl; external name 'unlink';
    function sys_rmdir(const path : pchar): cint; cdecl; external name 'rmdir';
    function sys_rename(const old : pchar; const newpath: pchar): cint; cdecl;external name 'rename';
    function sys_access(const pathname : pchar; amode : cint): cint; cdecl; external name 'access';
    function sys_close(fd : cint): cint; cdecl; external name 'close';
    function sys_read(fd: cint; buf: pchar; nbytes : size_t): ssize_t; cdecl; external name 'read';
    function sys_write(fd: cint;const buf:pchar; nbytes : size_t): ssize_t; cdecl; external name 'write';
    function sys_lseek(fd : cint; offset : off_t; whence : cint): off_t; cdecl; external name 'lseek';
    function sys_ftruncate(fd : cint; flength : off_t): cint; cdecl; external name 'ftruncate';
    function sys_getcwd(buf: pchar; size: size_t): pchar; cdecl; external name 'getcwd';
    
    function S_ISDIR(m : mode_t): boolean;
    function S_ISCHR(m : mode_t): boolean;
    function S_ISBLK(m : mode_t): boolean;
    function S_ISREG(m : mode_t): boolean;
    function S_ISLNK(m : mode_t): boolean;
    function S_ISSOCK(m: mode_t):boolean;
    function S_ISFIFO(m: mode_t):boolean;

    function wifexited(status : cint): cint;
    function wexitstatus(status : cint): cint;
    function wstopsig(status : cint): cint;
    function wifsignaled(status : cint): cint;

implementation


const
  { Constants to check stat.mode }
  STAT_IFMT   = $f000; {00170000}
  STAT_IFSOCK = $c000; {0140000}
  STAT_IFLNK  = $a000; {0120000}
  STAT_IFREG  = $8000; {0100000}
  STAT_IFBLK  = $6000; {0060000}
  STAT_IFDIR  = $4000; {0040000}
  STAT_IFCHR  = $2000; {0020000}
  STAT_IFIFO  = $1000; {0010000}
  STAT_ISUID  = $0800; {0004000}
  STAT_ISGID  = $0400; {0002000}
  STAT_ISVTX  = $0200; {0001000}



    function S_ISDIR(m : mode_t): boolean;
      begin
        S_ISDIR:=(m and STAT_IFMT)=STAT_IFDIR;
      end;

    function S_ISCHR(m : mode_t): boolean;
      begin
        S_ISCHR:=(m and STAT_IFMT)=STAT_IFCHR;
      end;

    function S_ISBLK(m : mode_t): boolean;
      begin
       S_ISBLK:=(m and STAT_IFMT)=STAT_IFBLK;
      end;

    function S_ISREG(m : mode_t): boolean;
      begin
       S_ISREG:=(m and STAT_IFMT)=STAT_IFREG;
      end;

    function S_ISFIFO(m : mode_t): boolean;
      begin
        S_ISFIFO:=(m and STAT_IFMT)=STAT_IFIFO;
      end;
      
    function S_ISLNK(m : mode_t): boolean;
      begin
       S_ISLNK:=(m and STAT_IFMT)=STAT_IFLNK;
      end;
      
    function S_ISSOCK(m:mode_t):boolean;
      begin
       S_ISSOCK:=(m and STAT_IFMT)=STAT_IFSOCK;
      end;


      function WTERMSIG(Status: Integer): Integer;
         begin
           WTERMSIG:=(Status and $7F);
         end;

      Function WIFSTOPPED(Status: Integer): Boolean;
         begin
           WIFSTOPPED:=((Status and $FF)=$7F);
         end;

       function wifexited(status : cint): cint;
         begin
           WIFEXITED:=cint(WTERMSIG(Status)=0);
         end;

       function wexitstatus(status : cint): cint;
        begin
          WEXITSTATUS:=(Status and $FF00) shr 8;
        end;

       function wstopsig(status : cint): cint;
        begin
          WSTOPSIG:=WEXITSTATUS(Status);
        end;

       function wifsignaled(status : cint): cint;
        begin
         WIFSIGNALED:=
         cint(
             (not (WIFSTOPPED(Status))) and 
             (WIFEXITED(Status)>0)
            );
        end;

Begin
end.
{

 $Log: not supported by cvs2svn $

}