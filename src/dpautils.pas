{
 ****************************************************************************
    $Id: dpautils.pas,v 1.1 2004-05-05 16:28:18 carl Exp $
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

{$IFDEF LINUX}
Error Unsupported target
{$ENDIF}

  TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = int64;
    Integer = longint;
    { An integer which has the size of a pointer }
    ptrint = longint;
    
const
 LineEnding : string = #13#10;
 LFNSupport = TRUE;
 DirectorySeparator = '\';
 DriveSeparator = ':';
 PathSeparator = ';';
 FileNameCaseSensitive = FALSE;
    

{$ENDIF DELPHI_COMPILER}    
    
implementation



end.

{
  $Log: not supported by cvs2svn $

}
