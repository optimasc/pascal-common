Unit BitStrm;
{$IFDEF FPC}
{$MODE OBJFPC}
{$ENDIF}

interface

uses
{$IFDEF USE_OBJECTS}
 objects
{$ELSE}
 classes
{$ENDIF}
 ;


Type

{$IFNDEF USE_OBJECTS}
   PStream = ^TStream;
{$ENDIF}


{$IFDEF TP}
   longword = longint;
{$ENDIF}
   endian_t = (BF_UNKNOWN_ENDIAN, BF_LITTLE_ENDIAN, BF_BIG_ENDIAN);


   TBitWriter  = {$IFDEF USE_OBJECTS}object(TObject){$ELSE}class{$ENDIF}
     endian: endian_t;   {* endianess of architecture *}
     bitBuffer: word;    {* bits waiting to be read/written *}
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


   TBitReader  = {$IFDEF USE_OBJECTS}object(TObject){$ELSE}class{$ENDIF}
     endian: endian_t;   {* endianess of architecture *}
     bitBuffer: word;    {* bits waiting to be read/written *}
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
     S: PStream;
     constructor Create(var Stream: TStream); {$IFNDEF USE_OBJECTS}virtual;{$ENDIF}
     destructor Destroy; {$IFNDEF USE_OBJECTS}override;{$ENDIF}
{$IFDEF USE_OBJECTS}
    procedure Free;
{$ENDIF}
   private
     procedure WriteInternalByte(b: byte);{$IFNDEF USE_OBJECTS}override;{$ELSE}virtual;{$ENDIF}
   end;

   TStreamBitReader = {$IFDEF USE_OBJECTS}object{$ELSE}class{$ENDIF}(TBitReader)
     S: PStream;
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


   {*************************************************************************}

   procedure TBitWriter.WriteIntegerBE(value: longword; count: integer);
    var
     i: integer;
    begin
     for i := count - 1 downto  0 do
      Begin
{          writeBit((Value shr i) and $01);}

           {-- Unrolled the call here --}
           bitBuffer := bitBuffer or  (((Value shr i) and $01) shl bitCount);
           inc(bitCount);

           if (BitCount = 8) then
            Begin
              WriteInternalByte(bitBuffer);

             {* reset buffer *}
             bitCount := 0;
             bitBuffer := 0;
           end;
         
      End;
    end;

   procedure TBitWriter.WriteIntegerLE(value: longword; count: integer);
    var
      i: integer;
    begin
        for i := 0 to count-1 do
        Begin
{          writeBit((Value shr i) and $01);}

           {-- Unrolled the call here --}
           bitBuffer := bitBuffer or  (((Value shr i) and $01) shl bitCount);
           inc(bitCount);

           if (BitCount = 8) then
            Begin
              WriteInternalByte(bitBuffer);

             {* reset buffer *}
             bitCount := 0;
             bitBuffer := 0;
           end;
        end;
    end;


  procedure TBitWriter.WriteBit(bit: byte);
    Begin
      bitBuffer := bitBuffer or  (Bit shl bitCount);
      inc(bitCount);

      if (BitCount = 8) then
      Begin
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
      tmp := (byte(b)) shl (bitCount);
      tmp := tmp or ((bitBuffer) shr (8 - bitCount));

      WriteInternalByte(tmp);
      bitBuffer := b;
    end;


   procedure TBitWriter.ByteAlign;
    begin
        {* write out any unwritten bits *}
        if (bitCount <> 0) then
          begin
{            bitBuffer := bitBuffer shl (8 - bitCount); }
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
{$ELSE}
      inherited done;
{$ENDIF}
    end;

   constructor TStreamBitWriter.Create(var Stream: TStream);
    begin
{$IFNDEF USE_OBJECTS}
      Inherited Create;
{$ENDIF}
      S := @Stream;
      bitBuffer:=0;
      bitCount:=0;
    end;


   procedure TStreamBitWriter.WriteInternalByte(b: byte);
    Begin
      S^.Write(b,sizeof(b));
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
    if bitCount = 8 then
     begin
        {* buffer is empty, read another character *}
        returnValue:=ReadInternalByte;
        bitCount := 0;
        bitBuffer := returnValue;
     end;

    returnValue := bitBuffer and (1 shl bitCount);
    {* bit to return is msb in buffer *}
    Inc(bitCount);

    if (returnValue = 0) then
      readbit :=0
    else
      readBit := 1;
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
   returnValue: longword;
   i: integer;
   return: longword;
   readbitval: byte;
  begin
    return := 0;
      for i := count - 1 downto 0 do
       Begin
{         returnValue := returnValue or  (readBit shl i);}

           {-- Unrolled call to readBit --}
           if bitCount = 8 then
             begin
              {* buffer is empty, read another character *}
              returnValue:=ReadInternalByte;
              bitCount := 0;
              bitBuffer := returnValue;
             end;

           returnValue := bitBuffer and (1 shl bitCount);
          {* bit to return is msb in buffer *}
          Inc(bitCount);

          if (returnValue = 0) then
            readbitval :=0
          else
            readBitval := 1;

          return := return or (ReadBitval shl i);
        end;

    ReadIntegerBE := return;
  end;

 function TBitReader.ReadIntegerLE(count: integer): longword;
  var
   returnValue: longword;
   return: longword;
   i: integer;
   readbitval: byte;
  begin
        return := 0;
        for i := 0 to count-1 do
        Begin
{          returnValue := returnValue or (ReadBit shl i);}

           {-- Unrolled call to readBit --}
           if bitCount = 8 then
             begin
              {* buffer is empty, read another character *}
              returnValue:=ReadInternalByte;
              bitCount := 0;
              bitBuffer := returnValue;
             end;

           returnValue := bitBuffer and (1 shl bitCount);
          {* bit to return is msb in buffer *}
          Inc(bitCount);

          if (returnValue = 0) then
            readbitval :=0
          else
            readBitval := 1;

          return := return or (ReadBitVal shl i);
        end;

    ReadIntegerLE := return;
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
{$ELSE}
      Inherited Init;
{$ENDIF}
      S := @Stream;
      bitBuffer:=0;
      bitCount:=8;
  end;

 destructor TStreamBitReader.Destroy;
  begin
{$IFNDEF USE_OBJECTS}
      inherited Destroy;
{$ELSE}
      inherited done;
{$ENDIF}
  end;


 function TStreamBitReader.ReadInternalByte: Byte;
  var
   returnValue: byte;
  begin
   S^.Read(returnValue,sizeof(returnValue));
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
{$ELSE}
      inherited done;
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
{$ELSE}
      Inherited Init;
{$ENDIF}
      TotalRead := 0;
      Buf := Buffer;
      bitBuffer:=0;
      bitCount:=8;
  end;

 destructor TMemoryBitReader.Destroy;
  begin
{$IFNDEF USE_OBJECTS}
      inherited Destroy;
{$ELSE}
      inherited done;
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