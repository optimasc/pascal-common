{
 ****************************************************************************
    $Id: vpautils.pas,v 1.3 2004-08-27 02:11:08 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Virtual pascal 2.1 or higher compatibility unit (Win32 or OS/2 targets)

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}

{** @author(Carl Eric Codere)
    @abstract(Virtual Pascal Compatibility unit)

    This unit includes common definitions so
    that common code can be compiled under
    the Virtual pascal compiler. It
    supports Virtual Pascal 2.1 and higher for 
    the Win32, DOS and OS/2 targets.

}
Unit vpautils;

interface

{$IFDEF VPASCAL}

{$IFDEF LINUX}
Error Unsupported target
{$ENDIF}

  TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = longint;
    Integer = longint;
    longword = longint;
    { An integer which has the size of a pointer }
    ptrint = longint;
    
const
 LineEnding : string = #13#10;
 LFNSupport = TRUE;
 DirectorySeparator = '\';
 DriveSeparator = ':';
 PathSeparator = ';';
 FileNameCaseSensitive = FALSE;
 

 { Filemode symbolic constants }
 const
{$IFDEF WIN32} 
    fmOpenRead       = $0000;
    fmOpenWrite      = $0001;
    fmOpenReadWrite  = $0002;

    fmShareExclusive = $0010;
    fmShareDenyWrite = $0020;
    fmShareDenyNone  = $0040;
{$ENDIF}    
{$IFDEF OS2} 
    fmOpenRead       = $0000;
    fmOpenWrite      = $0001;
    fmOpenReadWrite  = $0002;

    fmShareExclusive = $0010;
    fmShareDenyWrite = $0020;
    fmShareDenyNone  = $0040;
{$ENDIF}    
 
  procedure Assert(b: boolean);

    
{$ENDIF}

implementation

 procedure Assert(b: boolean);
 begin
   if not b then RunError(227);
 end;



end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2004/08/19 00:18:21  carl
    + assert routine

  Revision 1.1  2004/05/05 16:28:23  carl
    Release 0.95 updates

}
