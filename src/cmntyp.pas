{
 ****************************************************************************
    $Id: cmntyp.pas,v 1.2 2012-02-16 05:40:07 carl Exp $
    Copyright (c) 2004-2011 by Carl Eric Codere

    Common compatibility units for different compilers

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}

{** @author(Carl Eric Codere)
    @abstract(Pascal Compatibility unit)

    This unit declares common type definitions and constants for different 
    compiler tags so as to make the code more portable. The current supported
    compilers are as follows: Freepascal 1.0.10 and later, Borland Pascal 7.0,
    GNU Pascal compiler, 
    
    

}
unit cmntyp;

interface

{$IFDEF VER140}
{$DEFINE DELPHI_COMPILER}
{$ENDIF}
{$IFDEF VER150}
{$DEFINE DELPHI_COMPILER}
{$ENDIF}
{$IFDEF VER160}
{$DEFINE DELPHI_COMPILER}
{$ENDIF}
{$IFDEF VER180}
{$DEFINE DELPHI_COMPILER}
{$ENDIF}
{$IFDEF VER190}
{$DEFINE DELPHI_COMPILER}
{$ENDIF}



{***************************** Virtual Pascal *******************************}

{$IFDEF VPASCAL}

{$IFDEF LINUX}
Error Unsupported target
{$ENDIF}


  TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = longint;
    Integer = longint;
    { Cardinal is not a true unsigned 32-bit value, so we
      need to map to longint for this target
    }      
    longword = longint;
    { An integer which has the size of a pointer }
    ptrint = longint;
    word = smallword;
    TDateTime = Double;
    
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

 var
    ErrOutput:Text;

 
  procedure Assert(b: boolean);

    
{$ENDIF}

{***************************** Freepascal *******************************}

{$IFDEF FPC}
uses sysutils;

  TYPE
    { The biggest integer type available to this compiler }
    big_integer_t = int64;
    Integer = longint;
    
{$IFDEF VER1_0}
    ptrint = longword;
{$ENDIF}

const
 { Symbolic filemode constant }
 fmOpenRead       = Sysutils.fmOpenRead;
 fmOpenWrite      = Sysutils.fmOpenWrite;
 fmOpenReadWrite  = Sysutils.fmOpenReadWrite;

 fmShareExclusive = Sysutils.fmShareExclusive;
 fmShareDenyWrite = Sysutils.fmShareDenyWrite;
 fmShareDenyNone  = Sysutils.fmShareDenyNone;
 
var 
 ErrOutput: Text;

{$ENDIF}
{****************************************************************************}


{***************************** GNU     Pascal *******************************}
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
  TDateTime = Double;
  { An integer which has the size of a pointer }
  ptrint = longint;




{$endif}

{****************************************************************************}

{***************************** Delphi compiler ******************************}
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
{$ENDIF}

{*****************************  Turbo Pascal  *******************************}
{$ifdef tp}

{$IFNDEF WINDOWS}
uses Dos;
{$ENDIF}

const
 LineEnding : string = #13#10;
 LFNSupport = FALSE;
 DirectorySeparator = '\';
 DriveSeparator = ':';
 PathSeparator = ';';
 FileNameCaseSensitive = FALSE;


 { Filemode symbolic constants }
 const
    fmOpenRead       = $0000;
    fmOpenWrite      = $0001;
    fmOpenReadWrite  = $0002;

    fmShareExclusive = $0010;
    fmShareDenyWrite = $0020;
    fmShareDenyNone  = $0040;
    


type
  { The biggest integer type available on this machine }
  big_integer_t = longint;
  smallint = integer;
  longword = longint;
  shortstring = string;
  ansistring = shortstring;
  pstring = ^shortstring;
  cardinal = word;
  { An integer which has the size of a pointer }
  ptrint = longint;
  pinteger = ^integer;
  TDateTime = Double;
  ansichar = char;
  pansichar = PChar;
  pbyte = ^byte;




 procedure SetLength(var s: OpenString; l: longint);

{$IFNDEF WINDOWS}
 Procedure FindClose(Var f: SearchRec);
{$ENDIF}

 {** @abstract(Reallocates a dynamic variable) 
 
     This has the same functionality of the ReallocMem
     routine of Delphi, except that the block has never
     its size changed. This is a hack to able fast
     compilation, and should not be used.
 }
 procedure ReallocMem(var P: Pointer; Size: Integer);

 procedure Assert(b: boolean);

 var
    ErrOutput:Text;
 

{$endif}


implementation


{***************************** Virtual Pascal *******************************}

{$IFDEF VPASCAL}

 procedure Assert(b: boolean);
 begin
   if not b then RunError(227);
 end;

procedure initialize;
Begin
  Move(Output,ErrOutput,sizeof(Output));
end;  
{$ENDIF}
{****************************************************************************}

{***************************** Freepascal *******************************}

{$IFDEF FPC}
procedure initialize;
begin
 move(StdErr,ErrOutput, sizeof(StdErr));
end; 
{$ENDIF}

{****************************************************************************}

{*****************************  Turbo Pascal  *******************************}

{$ifdef tp}



 procedure SetLength(var s: OpenString; l: longint);
  begin
   if l < 0 then
     l:=0;
   if l > 255 then
     l:=255;
   s[0] := char(l);
  end;

{$IFNDEF WINDOWS}
 Procedure FindClose(Var f: SearchRec);
 begin
 end;
{$ENDIF}

 procedure Assert(b: boolean);
 begin
   if not b then
     RunError(227);
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
      Assert(False);
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


procedure initialize;
Begin
  Move(Output,ErrOutput,sizeof(Output));
end;  

{$ENDIF TP}

{****************************************************************************}
{$IFDEF DELPHI_COMPILER}
procedure initialize;
 Begin
 end;


{$ENDIF DELPHI_COMPILER}

Begin
 initialize;
end.



