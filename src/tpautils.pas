{
 ****************************************************************************
    $Id: tpautils.pas,v 1.3 2004-07-15 01:02:45 carl Exp $
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

uses dos;

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
 
 Procedure FindClose(Var f: SearchRec);

 {** @abstract(Reallocates a dynamic variable) 
 
     This has the same functionality of the ReallocMem
     routine of Delphi, except that the block has never
     its size changed. This is a hack to able fast
     compilation, and should not be used.
 }
 procedure ReallocMem(var P: Pointer; Size: Integer);

 procedure Assert(b: boolean);

{$endif}

implementation

{$ifdef tp}



 procedure SetLength(var s: string; l: longint);
  begin
   s[0] := char(l and $ff);
  end;
  
 Procedure FindClose(Var f: SearchRec);
 begin
 end;

 procedure Assert(b: boolean);
 begin
   if not b then RunError(227);
 end;
 
 procedure ReallocMem(var P: Pointer; Size: Integer);
 begin
   { If P is nil and Size is zero, ReallocMem does nothing. }
   if not assigned(p) and (size = 0) then exit;
   { If P is nil and Size is not zero, ReallocMem allocates a 
     new block of the given size and sets P to point to the block. 
     This corresponds to a call to GetMem.
   }  
   If not assigned(p) and (size <> 0) then
    begin
      GetMem(p,size);
      exit;
    end;
   { If P is not nil and Size is zero, ReallocMem disposes the block 
     referenced by P and sets P to nil. This corresponds to a call to 
     FreeMem, except that FreeMem doesn't clear the pointer. }
   If assigned(p) and (size = 0) then
    begin
      RunError(255);
      { Hopw can we determine the size of the block? }
      FreeMem(p,size);
      p:=nil;
      exit;
    end;
  { If P is not nil and Size is not zero, ReallocMem reallocates the 
    block referenced by P to the size given by Size. Existing data in 
    the block is not affected by the reallocation, but if the block is 
    made larger, the contents of the newly allocated portion of the block 
    are undefined. If the block cannot be reallocated in place, it is moved 
    to a new location in the heap, and P is updated accordingly.        
  }
   
 end;
 
  


{$endif}

end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2004/07/05 02:26:08  carl
    + Reallocmem (mostly a hack)

  Revision 1.1  2004/05/05 16:28:21  carl
    Release 0.95 updates

}  