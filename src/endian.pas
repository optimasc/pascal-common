unit endian;

interface

{$i defines.inc}


uses classes;

Type
{$IFDEF SUPPORTS_POINTERMATH}
 TData = Byte;
 TBufferData = PByte;
{$ELSE} 
 TBufferData = PAnsiChar;
 TData = AnsiChar;
{$ENDIF} 

function readbe16(buffer: TBufferData; offset: longint): word;
function readle16(buffer: TBufferData; offset: longint): word;
function readbe32(buffer: TBufferData; offset: longint): longword;
function readle32(buffer: TBufferData; offset: longint): longword;
function readle64(buffer: TBufferData; offset: longint): int64;
function readbe64(buffer: TBufferData; offset: longint): int64;
function readlef32(buffer: TBufferData; offset: longint): single;
function readbef32(buffer: TBufferData; offset: longint): single;
function readlef64(buffer: TBufferData; offset: longint): double;
function readbef64(buffer: TBufferData; offset: longint): double;
function readoctet(buffer: TBufferData; offset: longint): byte;


function hosttobe32(value: longword): longword;
function hosttole32(value: longword): longword;
function hosttobe16(value: word): word;
function hosttole16(value: word): word;

function be32tohost(value: longword): longword;
function le32tohost(value: longword): longword;
function be16tohost(value: word): word;
function le16tohost(value: word): word;


procedure writebe32(buffer: TBufferData; offset: longint; value: longword);
procedure writele32(buffer: TBufferData; offset: longint; value: longword);
procedure writebe16(buffer: TBufferData; offset: longint; value: word);
procedure writele16(buffer: TBufferData; offset: longint; value: word);
procedure writeoctet(buffer: TBufferData; offset: longint; value: byte);

procedure writelef32(buffer: TBufferData; offset: longint; value: single);
procedure writebef32(buffer: TBufferData; offset: longint; value: single);
procedure writelef64(buffer: TBufferData; offset: longint; value: double);
procedure writebef64(buffer: TBufferData; offset: longint; value: double);

implementation

var
 big_endian: boolean;
 BufferDataptr: TBufferData;

function readbe32(buffer: TBufferData; offset: longint): longword;
 begin
     readbe32:= longword((ord(buffer[offset]) shl 24) or ((ord(buffer[offset + 1]) and $ff) shl 16)
        or ((ord(buffer[offset + 2]) and $ff) shl 8) or (ord(buffer[offset + 3]) and $ff));
 end;


function readlef32(buffer: TBufferData; offset: longint): single;
 var 
   value: single;
   longValue: longword;
 begin
   Assert(sizeof(single) = 4);
   longValue:=readle32(buffer,offset);
   Move(longValue,value,sizeof(value));
   readlef32:=value;
 end;
 
function readbef32(buffer: TBufferData; offset: longint): single;
 var
   value: single;
   longValue: longword;
 begin
   Assert(sizeof(single) = 4);
   longValue:=readbe32(buffer,offset);
   Move(longValue,value,sizeof(value));
   readbef32:=value;
 end;
 
function readle32(buffer: TBufferData; offset: longint): longword;
 begin
    readle32:= (ord(buffer[offset + 3]) shl 24) or ((ord(buffer[offset + 2]) and $ff) shl 16)
       or ((ord(buffer[offset + 1]) and $ff) shl 8) or (ord(buffer[offset]) and $ff);
 end;
  
function readbe16(buffer: TBufferData; offset: longint): word;
 begin
   readbe16 :=  (ord(buffer[offset]) and $ff) shl 8 or (ord(buffer[offset + 1]) and $ff);
 end;
 
function readle16(buffer: TBufferData; offset: longint): word;
 begin
   readle16 :=  (ord(buffer[offset + 1]) and $ff) shl 8 or (ord(buffer[offset]) and $ff);
 end;
 
function readoctet(buffer: TBufferData; offset: longint): byte;
 begin
   readoctet:=byte(buffer[offset]);
 end;
 
function readle64(buffer: TBufferData; offset: longint): int64;
 var
   outbuf: array[0..7] of byte;
   value: int64;
 Begin
         outbuf[0] := byte(buffer[offset+0]);
         outbuf[1] := byte(buffer[offset+1]);
         outbuf[2] := byte(buffer[offset+2]);
         outbuf[3] := byte(buffer[offset+3]);
         outbuf[4] := byte(buffer[offset+4]);
         outbuf[5] := byte(buffer[offset+5]);
         outbuf[6] := byte(buffer[offset+6]);
         outbuf[7] := byte(buffer[offset+7]);
   Move(outbuf,value,sizeof(outbuf));
   readle64:=value;
 end;

function readbe64(buffer: TBufferData; offset: longint): int64;
 var
   outbuf: array[0..7] of byte;
   value: int64;
 Begin
         outbuf[0] := byte(buffer[offset+7]);
         outbuf[1] := byte(buffer[offset+6]);
         outbuf[2] := byte(buffer[offset+5]);
         outbuf[3] := byte(buffer[offset+4]);
         outbuf[4] := byte(buffer[offset+3]);
         outbuf[5] := byte(buffer[offset+2]);
         outbuf[6] := byte(buffer[offset+1]);
         outbuf[7] := byte(buffer[offset+0]);
   Move(outbuf,value,sizeof(outbuf));
   readbe64:=value;
 end;

function readlef64(buffer: TBufferData; offset: longint): double;
 Begin
 end;
 
function readbef64(buffer: TBufferData; offset: longint): double;
 var
   outbuf: array[0..7] of byte;
   value: double;
 Begin
  if big_endian then
      Begin
         outbuf[0] := byte(buffer[offset+0]);
         outbuf[1] := byte(buffer[offset+1]);
         outbuf[2] := byte(buffer[offset+2]);
         outbuf[3] := byte(buffer[offset+3]);
         outbuf[4] := byte(buffer[offset+4]);
         outbuf[5] := byte(buffer[offset+5]);
         outbuf[6] := byte(buffer[offset+6]);
         outbuf[7] := byte(buffer[offset+7]);
      end
    else
      Begin
         outbuf[0] := byte(buffer[offset+7]);
         outbuf[1] := byte(buffer[offset+6]);
         outbuf[2] := byte(buffer[offset+5]);
         outbuf[3] := byte(buffer[offset+4]);
         outbuf[4] := byte(buffer[offset+3]);
         outbuf[5] := byte(buffer[offset+2]);
         outbuf[6] := byte(buffer[offset+1]);
         outbuf[7] := byte(buffer[offset+0]);
      end;
   Move(outbuf,value,sizeof(value));
   readbef64:=value;
 end;
 

function hosttobe32(value: longword): longword;
  var
    y : word;
    z : word;
 begin
   if big_endian then
     hosttobe32:=value
   else
     begin
       y := (value shr 16) and $FFFF;
       y := word((y shl 8) or ((y shr 8) and $ff));
       z := value and $FFFF;
       z := word((z shl 8) or ((z shr 8) and $ff));
       hosttobe32 := longword((longword(z) shl 16) or longword(y));
     end;
 end;

function hosttole32(value: longword): longword;
  var
    y : word;
    z : word;
 begin
   if big_endian=false then
     hosttole32:=value
   else
     begin
       y := (value shr 16) and $FFFF;
       y := word((y shl 8) or ((y shr 8) and $ff));
       z := value and $FFFF;
       z := word((z shl 8) or ((z shr 8) and $ff));
       hosttole32 := longword((longword(z) shl 16) or longword(y));
     end;
 end;

function hosttobe16(value: word): word;
 var
  z: word;
 begin
   if big_endian then
     hosttobe16:=value
   else
     begin
      z := (value shr 8) and $ff;
      value := value and $ff;
      value := (value shl 8);
      hosttobe16 := value or z;
     end;
 end;

function hosttole16(value: word): word;
 var
  z: word;
 begin
   if big_endian=false then
     hosttole16:=value
   else
     begin
      z := (value shr 8) and $ff;
      value := value and $ff;
      value := (value shl 8);
      hosttole16 := value or z;
     end;
 end;

function be32tohost(value: longword): longword;
var
  y : word;
  z : word;
begin
 if big_endian=true then
   be32tohost:=value
 else
   begin
     y := (value shr 16) and $FFFF;
     y := word((y shl 8) or ((y shr 8) and $ff));
     z := value and $FFFF;
     z := word((z shl 8) or ((z shr 8) and $ff));
     be32tohost := longword((longword(z) shl 16) or longword(y));
   end;
end;

function le32tohost(value: longword): longword;
var
  y : word;
  z : word;
begin
 if big_endian=false then
   le32tohost:=value
 else
   begin
     y := (value shr 16) and $FFFF;
     y := word((y shl 8) or ((y shr 8) and $ff));
     z := value and $FFFF;
     z := word((z shl 8) or ((z shr 8) and $ff));
     le32tohost := longword((longword(z) shl 16) or longword(y));
   end;
end;

function be16tohost(value: word): word;
var
 z: word;
 begin
   if big_endian=true then
     be16tohost:=value
   else
     begin
      z := (value shr 8) and $ff;
      value := value and $ff;
      value := (value shl 8);
      be16tohost := value or z;
     end;
 end;

function le16tohost(value: word): word;
var
 z: word;
 begin
   if big_endian=false then
     le16tohost:=value
   else
     begin
      z := (value shr 8) and $ff;
      value := value and $ff;
      value := (value shl 8);
      le16tohost := value or z;
     end;
 end;

procedure writebe32(buffer: TBufferData; offset: longint; value: longword);
 begin
  buffer[offset] := TData((value shr 24) and $ff);
  buffer[offset+1] := TData((value shr 16) and $ff);
  buffer[offset+2] := TData((value shr 8) and $ff);
  buffer[offset+3] := TData(value and $ff);
 end;
 
procedure writele32(buffer: TBufferData; offset: longint; value: longword);
 begin
   buffer[offset+3] := TData((value shr 24) and $ff);
   buffer[offset+2] := TData((value shr 16) and $ff);
   buffer[offset+1] := TData((value shr 8) and $ff);
   buffer[offset] := TData(value and $ff);
 end;
 
procedure writebe16(buffer: TBufferData; offset: longint; value: word);
 begin
   buffer[offset] := TData((value shr 8) and $ff);
   buffer[offset+1] := TData((value) and $ff);
 end;
 
procedure writele16(buffer: TBufferData; offset: longint; value: word);
 begin
   buffer[offset+1] := TData((value shr 8) and $ff);
   buffer[offset] := TData((value) and $ff);
 end;
 
procedure writeoctet(buffer: TBufferData; offset: longint; value: byte);
 begin
  buffer[offset] := TData(value);
 end;

procedure writelef32(buffer: TBufferData; offset: longint; value: single);
 var
  lw: longword;
 Begin
   Move(value,lw,sizeof(lw));
   writele32(buffer,offset,lw);
 end;

procedure writebef32(buffer: TBufferData; offset: longint; value: single);
 var
  lw: longword;
 Begin
   Move(value,lw,sizeof(lw));
   writele32(buffer,offset,lw);
 end;

procedure writelef64(buffer: TBufferData; offset: longint; value: double);
var
  outbuf: array[0..7] of TData;
 Begin
  Move(value,outbuf,sizeof(value));
  if big_endian then
       Begin
          buffer[offset+0] := TData(outbuf[0]);
          buffer[offset+1] := TData(outbuf[1]);
          buffer[offset+2] := TData(outbuf[2]);
          buffer[offset+3] := TData(outbuf[3]);
          buffer[offset+4] := TData(outbuf[4]);
          buffer[offset+5] := TData(outbuf[5]);
          buffer[offset+6] := TData(outbuf[6]);
          buffer[offset+7] := TData(outbuf[7]);
       end
     else
       Begin
          buffer[offset+0] := TData(outbuf[7]);
          buffer[offset+1] := TData(outbuf[6]);
          buffer[offset+2] := TData(outbuf[5]);
          buffer[offset+3] := TData(outbuf[4]);
          buffer[offset+4] := TData(outbuf[3]);
          buffer[offset+5] := TData(outbuf[2]);
          buffer[offset+6] := TData(outbuf[1]);
          buffer[offset+7] := TData(outbuf[0]);
       end;
 end;

procedure writebef64(buffer: TBufferData; offset: longint; value:double);
var
  outbuf: array[0..7] of TData;
 Begin
  Move(value,outbuf,sizeof(value));
  if big_endian then
       Begin
          buffer[offset+0] := TData(outbuf[0]);
          buffer[offset+1] := TData(outbuf[1]);
          buffer[offset+2] := TData(outbuf[2]);
          buffer[offset+3] := TData(outbuf[3]);
          buffer[offset+4] := TData(outbuf[4]);
          buffer[offset+5] := TData(outbuf[5]);
          buffer[offset+6] := TData(outbuf[6]);
          buffer[offset+7] := TData(outbuf[7]);
       end
     else
       Begin
          buffer[offset+0] := TData(outbuf[7]);
          buffer[offset+1] := TData(outbuf[6]);
          buffer[offset+2] := TData(outbuf[5]);
          buffer[offset+3] := TData(outbuf[4]);
          buffer[offset+4] := TData(outbuf[3]);
          buffer[offset+5] := TData(outbuf[2]);
          buffer[offset+6] := TData(outbuf[1]);
          buffer[offset+7] := TData(outbuf[0]);
       end;
 end;

const
 i: word = 1;


begin
  BufferDataptr:=TBufferData(@i);
  { Do sanity checking }
  Assert(sizeof(single)=4);
  Assert(sizeof(double)=8);
  if (BufferDataptr[0] = TData(#0)) then
    big_endian := True
  else
    big_endian := False;
end.
