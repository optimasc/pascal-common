{
 ****************************************************************************
    $Id: fpautils.pas,v 1.1 2004-05-05 16:28:19 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Free Pascal version 1.0.6 and higher compatibility unit

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}
{** @author(Carl Eric Codere)
    @abstract(Free Pascal compatibility unit)

    This unit includes common definitions so
    that common code can be compiled under
    the Free pascal compilers. It
    supports Freepascal 1.0.6 and higher (all targets).

}
Unit fpautils;

interface


{$IFDEF FPC}
uses sysutils;

  TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = int64;
    Integer = longint;
    
{$IFDEF VER1_0}
    ptrint = longword;
{$ENDIF}
{$ENDIF}

implementation


end.

{
  $Log: not supported by cvs2svn $

}
