{
 ****************************************************************************
    $Id: vpautils.pas,v 1.1 2004-05-05 16:28:23 carl Exp $
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
    
{$ENDIF}

implementation


end.

{
  $Log: not supported by cvs2svn $
}
