Unit BitStrm;

interface

uses
{$IFDEF USE_OBJECTS}
 objects
{$ELSE}
 classes
{$ENDIF}
 ;


Type

{$IFDEF TP}
   longword = longint;
{$ENDIF}
   endian_t = (BF_UNKNOWN_ENDIAN, BF_LITTLE_ENDIAN, BF_BIG_ENDIAN);


   TBitWriter  = {$IFDEF USE_OBJECTS}object{$ELSE}class{$ENDIF}
     endian: endian_t;   {* endianess of architecture *}
     bitBuffer: byte;    {* bits waiting to be read/written *}
     bitCount: byte;     {* number of bits in bitBuffer *}
     procedure WriteBit(bit: byte);
     procedure ByteAlign;
     procedure WriteByte(b: byte);
     procedure WriteIntegerBE(value: longword; count: integer);
     procedure WriteIntegerLE(value: longword; count: integer);
   private
     {** Writes a byte directly to the output stream. }
     procedure WriteInternalByte(b: byte);virtual;{$IFNDEF USE_OBJECTS}abstract;{$ENDIF}
   end;


   TBitReader  = {$IFDEF USE_OBJECTS}object{$ELSE}class{$ENDIF}
     endian: endian_t;   {* endianess of architecture *}
     bitBuffer: byte;    {* bits waiting to be read/written *}
     bitCount: byte;     {* number of bits in bitBuffer *}
     TotalRead: longword;{**number of bytes actually read }
     function ReadBit: byte;
     procedure ByteAlign;
     function ReadByte: byte;
     function ReadIntegerBE(count: integer): longword;
     function ReadIntegerLE(count: integer): longword;
   private
     {** Reads a byte directly from the input stream. }
     function ReadInternalByte: byte;virtual;{$IFNDEF USE_OBJECTS}abstract;{$ENDIF}
   end;


   TStreamBitWriter = {$IFDEF USE_OBJECTS}object{$ELSE}class{$ENDIF}(TBitWriter)
     S: TStream;
     constructor Create(var Stream: TStream); {$IFNDEF USE_OBJECTS}virtual;{$ENDIF}
     destructor Destroy; {$IFNDEF USE_OBJECTS}override;{$ENDIF}
{$IFDEF USE_OBJECTS}
    procedure Free;
{$ENDIF}
   private
     procedure WriteInternalByte(b: byte);{$IFNDEF USE_OBJECTS}override;{$ELSE}virtual;{$ENDIF}
   end;

   TStreamBitReader = {$IFDEF USE_OBJECTS}object{$ELSE}class{$ENDIF}(TBitReader)
     S: TStream;
     constructor Create(var Stream: TStream); {$IFNDEF USE_OBJECTS}virtual;{$ENDIF}
     destructor Destroy; {$IFNDEF USE_OBJECTS}override;{$ENDIF}
{$IFDEF USE_OBJECTS}
    procedure Free;
{$ENDIF}
   private
     {** Reads a byte directly from the input stream. }
     function ReadInternalByte: byte;{$IFNDEF USE_OBJECTS}override;{$ELSE}virtual;{$ENDIF}
   end;


   TMemoryBitWriter = {$IFDEF USE_OBJECTS}object{$ELSE}class{$ENDIF}(TBitWriter)
     Buf: pchar;
     TotalWritten: longword;
     constructor Create(Buffer: pchar); {$IFNDEF USE_OBJECTS}virtual;{$ENDIF}
     destructor Destroy; {$IFNDEF USE_OBJECTS}override;{$ENDIF}
{$IFDEF USE_OBJECTS}
    procedure Free;
{$ENDIF}
    private
     procedure WriteInternalByte(b: byte);{$IFNDEF USE_OBJECTS}override;{$ELSE}virtual;{$ENDIF}
   end;

   TMemoryBitReader = {$IFDEF USE_OBJECTS}object{$ELSE}class{$ENDIF}(TBitReader)
     Buf: Pchar;
     constructor Create(Buffer: pchar); {$IFNDEF USE_OBJECTS}virtual;{$ENDIF}
     destructor Destroy; {$IFNDEF USE_OBJECTS}override;{$ENDIF}
{$IFDEF USE_OBJECTS}
    procedure Free;
{$ENDIF}
   private
     {** Reads a byte directly from the input stream. }
     function ReadInternalByte: byte;{$IFNDEF USE_OBJECTS}override;{$ELSE}virtual;{$ENDIF}
   end;



implementation

type
   TLongBuffer = array[0..3] of byte;

   {*************************************************************************}

   procedure TBitWriter.WriteIntegerBE(value: longword; count: integer);
    var
      tmp: byte;
      remaining, offset: integer;
      v: longword;
    begin
      offset := 0;
      remaining := count;
      v := value;

     {* write whole bytes *}
      while (remaining >= 8) do
       begin
         v := value shr (remaining - 8);
         WriteByte(byte(v));
         Inc(offset);
         dec(remaining, 8);
       end;

      if (remaining <> 0) then
       begin
         {* write remaining bits *}
        tmp := byte(value);

        while (remaining > 0) do
          begin
             tmp := byte(value shr (remaining - 1));
             WriteBit(tmp and $1);
             dec(remaining);
          end;
       end;
    end;

   procedure TBitWriter.WriteIntegerLE(value: longword; count: integer);
    var
      tmp: byte;
      remaining, offset: integer;
      v: longword;
    begin
      offset := 0;
      remaining := count;
      v := value;

     {* write whole bytes *}
      while (remaining >= 8) do
       begin
         WriteByte(byte(v));
         v := value shr (remaining - 8);
         Inc(offset);
         dec(remaining, 8);
       end;

      if (remaining <> 0) then
       begin
         {* write remaining bits *}
        tmp := byte(value);

        while (remaining > 0) do
          begin
             tmp := value shr (remaining - 1);
             WriteBit(tmp and $1);
             dec(remaining);
          end;
       end;
    end;
    
    
   procedure TBitWriter.WriteBit(bit: byte);
   begin
    Inc(bitCount);
    bitBuffer := byte(bitBuffer shl 1);

    if (bit <> 0) then
     bitBuffer := bitBuffer or 1;

    {* write bit buffer if we have 8 bits *}
    if (bitCount = 8) then
    begin
        WriteInternalByte(bitBuffer);

        {* reset buffer *}
        bitCount := 0;
        bitBuffer := 0;
    end;

   end;

   procedure TBitWriter.WriteByte(b: byte);
    var
      tmp: byte;
    begin
      { The data is already byte aligned }
      if bitCount = 0 then
        begin
          WriteInternalByte(b);
          exit;
        end;

      {* figure out what to write *}
      tmp := (byte(b)) shr (bitCount);
      tmp := tmp or ((bitBuffer) shl (8 - bitCount));

      WriteInternalByte(tmp);
      bitBuffer := b;
    end;


   procedure TBitWriter.ByteAlign;
    begin
        {* write out any unwritten bits *}
        if (bitCount <> 0) then
          begin
            bitBuffer := bitBuffer shl (8 - bitCount);
            WriteInternalByte(bitBuffer);
            bitBuffer := 0;
            bitCount := 0;
          end;
    end;
    
{$IFDEF USE_OBJECTS}
    procedure TBitWriter.WriteInternalByte(b: byte);
     Begin
       Abstract;
     end;
{$ENDIF}

   {*************************************************************************}


   destructor TStreamBitWriter.Destroy;
    begin
      { Flush and align the data }
      ByteAlign;
{$IFNDEF USE_OBJECTS}
      inherited Destroy;
{$ENDIF}
    end;

   constructor TStreamBitWriter.Create(var Stream: TStream);
    begin
{$IFNDEF USE_OBJECTS}
      Inherited Create;
{$ENDIF}
      S := Stream;
      bitBuffer:=0;
      bitCount:=0;
    end;


   procedure TStreamBitWriter.WriteInternalByte(b: byte);
    Begin
      S.Write(b,sizeof(b));
    end;


{$IFDEF USE_OBJECTS}
    Procedure TStreamBitWriter.Free;
     Begin
       Destroy;
     End;
{$ENDIF}

   {*************************************************************************}

{$IFDEF USE_OBJECTS}
 function TBitReader.ReadInternalByte: Byte;
   Begin
     Abstract;
   end;
{$ENDIF}



 function TBitReader.ReadBit: byte;
  var
   returnValue: byte;
  begin
    if bitCount = 0 then
     begin
        {* buffer is empty, read another character *}
        returnValue:=ReadInternalByte;
        bitCount := 8;
        bitBuffer := returnValue;
     end;

    {* bit to return is msb in buffer *}
    Dec(bitCount);

    returnValue := bitBuffer shr bitCount;

    ReadBit := returnValue and $01;
  end;

 function TBitReader.ReadByte: byte;
  var
   returnValue: byte;
   tmp: byte;
  begin

    returnValue := readInternalByte;

    if (bitCount = 0) then
      begin
        ReadByte := returnValue;
        exit;
      end;

    {* we have some buffered bits to return too *}
    {* figure out what to return *}
    tmp := (byte(returnValue)) shr bitCount;
    tmp := tmp or byte((bitBuffer) shl (8 - (bitCount)));

    {* put remaining in buffer. count shouldn't change. *}
    bitBuffer := returnValue;

    ReadByte := tmp;
  end;

 function TBitReader.ReadIntegerBE(count: integer): longword;
  var
   offset: integer;
   remaining: integer;
   returnValue: longword;
   b : byte;
   value: longword;
  begin
    offset := count;
    remaining := count;
    returnValue := 0;

    {* read whole bytes *}
    while (remaining >= 8) do
     begin
        Dec(offset, 8);
        Dec(Remaining, 8);
        returnValue := longword(returnValue) or longword(longword(ReadByte) shl (offset));
     end;

    if (remaining <> 0) then
      begin
        offset := 0;
        Value := 0;
        {* read remaining bits *}
        while (remaining > 0) do
          begin
            b := ReadBit;
            Value := longword(Value) or longword(longword(b) shl (remaining - 1));
            dec(Remaining);
            Inc(offset);
          end;
        returnValue :=  longword(returnValue) or longword(value);
      end;
    ReadIntegerBE := returnValue;
  end;

 function TBitReader.ReadIntegerLE(count: integer): longword;
  var
   offset: integer;
   remaining: integer;
   returnValue: longword;
   value: longword;
  begin
    offset := 0;
    remaining := count;
    returnValue := 0;
    

    {* read whole bytes *}
    while (remaining >= 8) do
     begin
        returnValue := longword(returnValue) or longword(longword(ReadByte) shl (offset));
        Dec(Remaining, 8);
        Inc(offset, 8);
     end;

    if (remaining <> 0) then
      begin
        Value := 0;
        returnValue :=  longword(returnValue) shl (count-offset);
        offset := 0;
        {* read remaining bits *}
        while (remaining > 0) do
          begin
            Value := longword(value) or longword(longword(ReadBit) shl (remaining - 1));
            dec(Remaining);
            Inc(offset);
          end;
        returnValue :=  longword(returnValue) or longword(value);
      end;
    ReadIntegerLE := returnValue;
  end;

  procedure TBitReader.ByteAlign;
   var
    b: byte;
   Begin
     While BitCount > 0 do
       Begin
         b:=ReadBit;
       end;
   end;


   {*************************************************************************}

 constructor TStreamBitReader.Create(var Stream: TStream);
  begin
{$IFNDEF USE_OBJECTS}
      Inherited Create;
{$ENDIF}
      S := Stream;
      bitBuffer:=0;
      bitCount:=0;
  end;

 destructor TStreamBitReader.Destroy;
  begin
{$IFNDEF USE_OBJECTS}
      inherited Destroy;
{$ENDIF}
  end;


 function TStreamBitReader.ReadInternalByte: Byte;
  var
   returnValue: byte;
  begin
   S.Read(returnValue,sizeof(returnValue));
   Inc(TotalRead);
   ReadInternalByte:=returnValue;
  end;


{$IFDEF USE_OBJECTS}
    Procedure TStreamBitReader.Free;
     Begin
       Destroy;
     End;
{$ENDIF}
  
   {*************************************************************************}
  
   destructor TMemoryBitWriter.Destroy;
    begin
      { Flush and align the data }
      ByteAlign;
{$IFNDEF USE_OBJECTS}
      inherited Destroy;
{$ENDIF}
    end;

   constructor TMemoryBitWriter.Create(Buffer: PChar);
    begin
{$IFNDEF USE_OBJECTS}
      Inherited Create;
{$ENDIF}
      Buf:=Buffer;
      TotalWritten:=0;
      bitBuffer:=0;
      bitCount:=0;
    end;

   procedure TMemoryBitWriter.WriteInternalByte(b: byte);
    Begin
      Buf^:=Chr(b);
      Inc(TotalWritten);
      Inc(Buf);
    end;


{$IFDEF USE_OBJECTS}
    Procedure TMemoryBitWriter.Free;
     Begin
       Destroy;
     End;
{$ENDIF}


   {*************************************************************************}


 constructor TMemoryBitReader.Create(Buffer: Pchar);
  begin
{$IFNDEF USE_OBJECTS}
      Inherited Create;
{$ENDIF}
      TotalRead := 0;
      Buf := Buffer;
      bitBuffer:=0;
      bitCount:=0;
  end;

 destructor TMemoryBitReader.Destroy;
  begin
{$IFNDEF USE_OBJECTS}
      inherited Destroy;
{$ENDIF}
  end;

 function TMemoryBitReader.ReadInternalByte: Byte;
  Begin
    ReadInternalByte:=Ord(Buf^);
    Inc(Buf);
    Inc(TotalRead);
  end;


{$IFDEF USE_OBJECTS}
    Procedure TMemoryBitReader.Free;
     Begin
       Destroy;
     End;
{$ENDIF}


end.