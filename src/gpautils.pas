{
 ****************************************************************************
    $Id: gpautils.pas,v 1.1 2004-06-20 18:49:37 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    GNU Pascal compatibility unit

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}
{** @author(Carl Eric Codere)
    @abstract(GNU Pascal Compatibility unit)

    This unit includes common definitions so
    that common code can be compiled under
    the GNU pascal compilers. 

}
unit gpautils;

interface

{$ifdef __GPC__}

const
 LineEnding : string = #13#10;
 LFNSupport = TRUE;
 DirectorySeparator = '/';
 DriveSeparator = ':';
 PathSeparator = ';';
 FileNameCaseSensitive = FALSE;
 
var
 {** This variable is not used in GPC }
 FileMode: byte;

type
  { The biggest integer type available on this machine }
  Card16 = Cardinal attribute (size = 16);
  big_integer_t = Integer attribute (size = 64);
  smallint = Integer attribute (size = 16);
  longword = Cardinal attribute (size = 32);
  shortint = Integer attribute (size = 8);
  word = Cardinal attribute (size = 16);
  shortstring = string;
  pstring = ^shortstring;
  cardinal = Cardinal attribute (size = 32);
  { An integer which has the size of a pointer }
  ptrint = longint;




{$endif}

implementation

{$ifdef __GPC__}




{$endif}

end.

{
  $Log: not supported by cvs2svn $

}  