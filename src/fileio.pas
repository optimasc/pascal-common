{
 ****************************************************************************
    $Id: fileio.pas,v 1.3 2004-11-18 21:22:55 user63 Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Generic portable file I/O routines with debug support.

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}

{** 
    @author(Carl Eric Codere)
    @abstract(File I/O unit)
    
}
unit fileio;
{$I-}
{$B+}
{$DEFINE DEBUG}



interface

uses
  dpautils,
  vpautils,
  fpautils,
  gpautils,
  tpautils;
  
  
procedure FileAssign(var F: file; Name: string);

procedure FileReset(var F: file; mode: integer);

procedure FileRewrite(var F: file; mode: integer);

procedure FileClose(var F: file);

function FileBlockRead(var F: file; var Buf; Count: integer): integer;

function FileBlockWrite(var F: file; var Buf; Count: integer): integer;

procedure FileSeek(var F: file; N: longint);

function FileGetSize(var F: file): big_integer_t;

function FileGetPos(var F: file): big_integer_t;

function FileIOResult: integer;

procedure FileTruncate(var F: file);


implementation

uses dos,collects,utils,strings;

{$IFDEF DEBUG}
  var OpenedFileCollection: TExtendedSortedStringCollection;
{$ENDIF}

var
 LastIOResult: integer;

function FileIOResult: integer;
begin
  FileIOResult:=LastIOResult;
  LastIOResult:=0;
end;

procedure FileAssign(var F: file; Name: string);
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  Assign(F,name);
end;

procedure FileReset(var F: file; mode: integer);
var
 OldFileMode: integer;
 FRec: FileRec;
 s: string;
 p: pshortstring;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
 OldFileMode:=FileMode;
 FileMode:=mode and $ff;
 Reset(F,1);
{$IFDEF DEBUG}
  FRec:=FileRec(F);
  s:=strpas(FRec.name);
  p:=stringdup(s);
  OpenedFileCollection.Insert(p);
{$ENDIF}
 FileMode:=OldFileMode;
 LastIOResult:=IOResult;
end;

procedure FileRewrite(var F: file; mode: integer);
var
 OldFileMode: integer;
 Frec: FileRec;
 s: string;
 p: pshortstring;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
{ OldFileMode:=FileMode;
 if (mode and fmOpenReadWrite) <> mode
 FileMode:=mode and $ff;}
 Rewrite(F);
{$IFDEF DEBUG}
  FRec:=FileRec(F);
  s:=strpas(FRec.name);
  p:=stringdup(s);
  OpenedFileCollection.Insert(p);
{$ENDIF}
  LastIOResult:=IOResult;
{ FileMode:=OldFileMode;}
end;

procedure FileClose(var F: file);
var
 Index: integer;
 Frec: FileRec;
 s: string;
 p: pshortstring;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  FRec:=FileRec(F);
  s:=strpas(Frec.name);
  p:=stringdup(s);
{$IFDEF DEBUG}
  if OpenedFileCollection.Search(p,Index) then
    begin
      OpenedFileCollection.Free(OpenedFileCollection.At(Index));
    end;
  stringdispose(p);  
{$ENDIF}
  Close(F);
  LastIOResult:=IOResult;
end;

function FileBlockRead(var F: file; var Buf; Count: integer): integer;
var
 _result: integer;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  BlockRead(F,Buf,count,_result);
  FileBlockRead:=_result;
  LastIOResult:=IOResult;
end;

function FileBlockWrite(var F: file; var Buf; Count: integer): integer;
var
 _result: integer;
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  BlockWrite(F,Buf,Count,_result);
  FileBlockWrite:=_result;
  LastIOResult:=IOResult;
end;

procedure FileSeek(var F: file; N: longint);
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  Seek(F,N);
  LastIOResult:=IOResult;
end;

function FileGetSize(var F: file): big_integer_t;
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  FileGetSize:=FileSize(F);
  LastIOResult:=IOResult;
end;

function FileGetPos(var F: file): big_integer_t;
var
 status: integer;
begin
{$IFDEF DEBUG}
 status:=FileIOResult;
 if status <> 0 then
   RunError(status and $ff);
{$ENDIF}
  FileGetPos:=FilePos(F);
  LastIOResult:=IOResult;
end;

procedure FileTruncate(var F: file);
var
 status: integer;
begin
{$IFDEF DEBUG}
 if FileIOResult <> 0 then
   RunError(FileIOResult and $ff);
{$ENDIF}
  Truncate(F);
  LastIOResult:=IOResult;
end;


{$IFDEF DEBUG}
var
  ExitSave: pointer;

procedure CheckFiles;far;
var
 i: integer;
 p: pshortstring;
begin
  ExitProc := ExitSave;
  for i:=0 to OpenedFileCollection.count -1 do
    begin
      p:=OpenedFileCollection.At(i);
      WriteLn('File not closed: ',p^);
    end;
  OpenedFileCollection.done;
end;
{$ENDIF}


Begin
{$IFDEF DEBUG}
  ExitSave:= ExitProc;
  ExitProc := @CheckFiles;
  OpenedFileCollection.init(8,8);
  { Allow duplicates }
  OpenedFileCollection.Duplicates:=true;
{$ENDIF}
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2004/11/17 22:12:36  user63
    * bugfix with memory allocation (big heap leak!)

  Revision 1.1  2004/11/17 04:02:15  carl
    + Portable API for reading and writing to and from files.


}





