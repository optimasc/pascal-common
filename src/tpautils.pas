{
 ****************************************************************************
    $Id: tpautils.pas,v 1.1 2004-05-05 16:28:21 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Turbo Pascal/Borland Pascal 7.0 compatibility unit

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}
{** @author(Carl Eric Codere)
    @abstract(Turbo Pascal 7 Compatibility unit)

    This unit includes common definitions so
    that common code can be compiled under
    the Turbo/Borland pascal compilers. It
    supports both Turbo Pascal 7.0 and Borland
    Pascal 7.0 and higher.

}
unit tpautils;

interface

{$ifdef tp}

const
 LineEnding : string = #13#10;
 LFNSupport = FALSE;
 DirectorySeparator = '\';
 DriveSeparator = ':';
 PathSeparator = ';';
 FileNameCaseSensitive = FALSE;

type
  { The biggest integer type available on this machine }
  big_integer_t = longint;
  smallint = integer;
  longword = longint;
  shortstring = string;
  pstring = ^shortstring;
  cardinal = word;
  { An integer which has the size of a pointer }
  ptrint = longint;




 procedure SetLength(var s: string; l: longint);



{$endif}

implementation

{$ifdef tp}



 procedure SetLength(var s: string; l: longint);
  begin
   s[0] := char(l and $ff);
  end;


{$endif}

end.

{
  $Log: not supported by cvs2svn $
}  