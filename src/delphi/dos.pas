{
    This file is part of the Free Pascal run time library.
    Copyright (c) 1999-2000 by the Free Pascal development team.

    Dos unit for BP7 compatible RTL.
    
    WARNING: Maximum sizes of files is limited to 2 Gbytes-1,
    if the file is over that value, the value returned for
    size shall be 2 Gb-1 anyways!

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}
unit dos;
interface

{$ifdef win32}
uses windows;
{$endif}

{$H-}

Const
  Max_Path = 260;

  {Bitmasks for CPU Flags}
  fcarry     = $0001;
  fparity    = $0004;
  fauxiliary = $0010;
  fzero      = $0040;
  fsign      = $0080;
  foverflow  = $0800;

  {Bitmasks for file attribute}
  readonly  = $01;
  hidden    = $02;
  sysfile   = $04;
  volumeid  = $08;
  directory = $10;
  archive   = $20;
  anyfile   = $3F;

  {File Status}
  fmclosed = $D7B0;
  fminput  = $D7B1;
  fmoutput = $D7B2;
  fminout  = $D7B3;

  Filenamelen = 255;
Type
{ Needed for Win95 LFN Support }
  ComStr  = String[Filenamelen];
  PathStr = String[Filenamelen];
  DirStr  = String[Filenamelen];
  NameStr = String[Filenamelen];
  ExtStr  = String[Filenamelen];

{
  filerec.inc contains the definition of the filerec.
  textrec.inc contains the definition of the textrec.
  It is in a separate file to make it available in other units without
  having to use the DOS unit for it.
}
const
  filerecnamelength = 255;
type
  FileRec = System.TFileRec;
  
const
  TextRecNameLength = 256;
  TextRecBufSize    = 256;
type
  TextBuf = array[0..TextRecBufSize-1] of char;
  TextRec = System.TTextRec;
  

  DateTime = packed record
    Year,
    Month,
    Day,
    Hour,
    Min,
    Sec   : word;
  End;




  registers = packed record
    case i : integer of
     0 : (ax,f1,bx,f2,cx,f3,dx,f4,bp,f5,si,f51,di,f6,ds,f7,es,f8,flags,fs,gs : word);
     1 : (al,ah,f9,f10,bl,bh,f11,f12,cl,ch,f13,f14,dl,dh : byte);
     2 : (eax,  ebx,  ecx,  edx,  ebp,  esi,  edi : longint);
    end;
    
{$ifdef WIN32}
{$i doswin32h.inc}
{$endif}

{$ifdef linux}
{$i doslinuxh.inc}
{$endif}
    

Var
  DosError : integer;

{Interrupt}
Procedure Intr(intno: byte; var regs: registers);
Procedure MSDos(var regs: registers);

{Info/Date/Time}
Function  DosVersion: Word;
Procedure GetDate(var year, month, mday, wday: word);
Procedure GetTime(var hour, minute, second, sec100: word);
procedure SetDate(year,month,day: word);
Procedure SetTime(hour,minute,second,sec100: word);
Procedure UnpackTime(p: longint; var t: datetime);
Procedure PackTime(var t: datetime; var p: longint);

{Exec}
Procedure Exec(const path: pathstr; const comline: comstr);
Function  DosExitCode: word;

{Disk}
Function  DiskFree(drive: byte) : int64;
Function  DiskSize(drive: byte) : int64;
Procedure FindFirst(const path: pathstr; attr: word; var f: searchRec);
Procedure FindNext(var f: searchRec);
Procedure FindClose(Var f: SearchRec);

{File}
Procedure GetFAttr(var f; var attr: word);
Procedure GetFTime(var f; var time: longint);
Function  FSearch(path: pathstr; dirlist: string): pathstr;
Function  FExpand(const path: pathstr): pathstr;
Procedure FSplit(path: pathstr; var dir: dirstr; var name: namestr; var ext: extstr);
{function  GetShortName(var p : String) : boolean;
function  GetLongName(var p : String) : boolean;}

{Environment}
Function  EnvCount: longint;
Function  EnvStr(index: integer): string;
Function  GetEnv(envvar: string): string;

{Misc}
Procedure SetFAttr(var f; attr: word);
Procedure SetFTime(var f; time: longint);
Procedure GetCBreak(var breakvalue: boolean);
Procedure SetCBreak(breakvalue: boolean);
Procedure GetVerify(var verify: boolean);
Procedure SetVerify(verify: boolean);

{Do Nothing Functions}
Procedure SwapVectors;
Procedure GetIntVec(intno: byte; var vector: pointer);
Procedure SetIntVec(intno: byte; vector: pointer);
Procedure Keep(exitcode: word);

Const
  { allow EXEC to inherited handles from calling process,
    needed for FPREDIR in ide/text
    now set to true by default because
    other OS also pass open handles to childs
    finally reset to false after Florian's response PM }
  ExecInheritsHandles= false;

implementation

{$ifdef WIN32}
{$i doswin32.inc}
{$endif}

{$ifdef linux}
{$i doslinux.inc}
{$endif}


initialization
  DosInit;

finalization
  DosDone;
end.
{
  $Log: not supported by cvs2svn $
  Revision 1.8  2005/03/21 00:22:53  carl
    * exec/diskfree/disksize/fexpand bugfixes

  Revision 1.7  2004/12/26 23:33:45  carl
    + support for Kylix

  Revision 1.6  2004/09/29 00:58:18  carl
    * GetDate() crash bugfix. now uses API from windows unit

  Revision 1.5  2004/09/06 19:46:17  carl
    * Wrong driveseparator value ;(

  Revision 1.4  2004/07/15 01:00:31  carl
    - remove some compiler warnings

  Revision 1.3  2004/07/01 22:26:26  carl
    * Bugfix with FindFirst and FindNext

  Revision 1.2  2004/06/17 11:40:31  carl
    * bugfix with textrec

  Revision 1.1  2004/05/05 16:28:24  carl
    Release 0.95 updates


}
