{
    $Id: signal.inc,v 1.1 2006-10-16 22:28:05 carl Exp $

 **********************************************************************}

type
    sigset_t = longint;          { used for additional signal   }


   sighandler_t = procedure (signo: cint); cdecl;

   { signal services }
   sigactionrec = packed record
    sa_handler: sighandler_t; 
    sa_mask     : sigset_t;
    sa_flags    : cint;
    Sa_restorer : pointer; { Obsolete - Don't use }
   end;


const

    {************************ signals *****************************}
    { more can be provided. Herein are only included the required  }
    { values.                                                      }
    {**************************************************************}
  SIG_DFL = 0 ;
  SIG_IGN = 1 ;
  SIG_ERR = -1 ;

  SIGHUP     = 1;
  SIGINT     = 2;
  SIGQUIT    = 3;
  SIGILL     = 4;
  SIGTRAP    = 5;
  SIGABRT    = 6;
  SIGIOT     = 6;
  SIGBUS     = 7;
  SIGFPE     = 8;
  SIGKILL    = 9;
  SIGUSR1    = 10;
  SIGSEGV    = 11;
  SIGUSR2    = 12;
  SIGPIPE    = 13;
  SIGALRM    = 14;
  SIGTerm    = 15;
  SIGSTKFLT  = 16;
  SIGCHLD    = 17;
  SIGCONT    = 18;
  SIGSTOP    = 19;
  SIGTSTP    = 20;
  SIGTTIN    = 21;
  SIGTTOU    = 22;
  SIGURG     = 23;
  SIGXCPU    = 24;
  SIGXFSZ    = 25;
  SIGVTALRM  = 26;
  SIGPROF    = 27;
  SIGWINCH   = 28;
  SIGIO      = 29;
  SIGPOLL    = SIGIO;
  SIGPWR     = 30;
  SIGUNUSED  = 31;


{
  $Log: not supported by cvs2svn $
}