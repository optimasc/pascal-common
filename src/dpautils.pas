{
 ****************************************************************************
    $Id: dpautils.pas,v 1.4 2004-12-26 23:32:59 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Routines for Delphi 6/7 (Win32 target) compatibility

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}

{** @author(Carl Eric Codere)
    @abstract(Delphi/Kylix compatbility unit) 

    This unit includes common definitions so
    that common code can be compiled under
    the Delphicompilers. It
    supports Delphi 6 and higher that are targeted
    for Win32 as well as WDOSX/DOS.
}
Unit dpautils;

{$IFDEF VER140}
{$DEFINE DELPHI_COMPILER}
{$ENDIF}
{$IFDEF VER150}
{$DEFINE DELPHI_COMPILER}
{$ENDIF}
{$IFDEF VER160}
{$DEFINE DELPHI_COMPILER}
{$ENDIF}

interface


{$IFDEF DELPHI_COMPILER}
uses SysUtils;


  TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = int64;
    Integer = longint;
    { An integer which has the size of a pointer }
    ptrint = longint;
    
const
{$IFDEF WIN32}
 LineEnding : string = #13#10;
 LFNSupport = TRUE;
 DirectorySeparator = '\';
 DriveSeparator = ':';
 PathSeparator = ';';
 FileNameCaseSensitive = FALSE;
{$ELSE}
 LineEnding : string = #10;
 LFNSupport = TRUE;
 DirectorySeparator = '/';
 DriveSeparator = '';
 PathSeparator = ':';
 FileNameCaseSensitive = TRUE;
{$ENDIF}
 
 { Symbolic filemode constant }
 fmOpenRead       = Sysutils.fmOpenRead;
 fmOpenWrite      = Sysutils.fmOpenWrite;
 fmOpenReadWrite  = Sysutils.fmOpenReadWrite;

 fmShareExclusive = Sysutils.fmShareExclusive;
 fmShareDenyWrite = Sysutils.fmShareDenyWrite;
 fmShareDenyNone  = Sysutils.fmShareDenyNone;
    

{$ENDIF DELPHI_COMPILER}    
    
implementation



end.

{
  $Log: not supported by cvs2svn $
  Revision 1.3  2004/12/08 04:25:50  carl
    + make it compile under kylix

  Revision 1.2  2004/08/27 02:11:06  carl
    + added filemodes, as defined in sysutils

  Revision 1.1  2004/05/05 16:28:18  carl
    Release 0.95 updates


}
