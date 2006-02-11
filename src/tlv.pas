{** This unit implements routines to work with
    BER-TLV structures. All offsets from the
    are based on indexes that start from 0.
    }
unit TLV;

interface

{** Searches in a buffer for nth occurence of the TLV
    defined by the tag parameter. Returns an offset
    in the buffer to the actual TLV structure of
    that occurence, or -1 if nout found.

    @param(srcBuffer Should point to one or more TLV structures)
    @param(tag Tag to find)
    @param(occurence Ocurrence number to find (first occurence is 1))
    @returns(Offset in srcBuffer to the found TLV structure, or -1
      if not found, or if the tag format is not supported)
*}
function findTLV(srcBuffer: array of byte; tag: integer; occurence: integer): integer;

{** Constructs and appends a TLV structure at buffer[dstOffset], it
    returns dstOffset+length of the newly allocated TLV structure. }
function appendTLV(const srcBuffer: array of byte; tag: integer; var dstBuffer: array of byte; dstLength: integer): integer;

{** Returns the length in bytes of the value part of the TLV
    structure currently pointed to by srcBuffer. -1
    if this is not a valid TLV structure.

    @param(srcBuffer Should point to a valid TLV structure buffer)
    @returns(Number of bytes in the value field, or -1 if this is not a valid
      TLV structure)
}
function getValueLength(const srcBuffer: array of byte): integer;

function getValue(const srcBuffer: array of byte; const dstBuffer: array of byte; dstLength: integer): integer;

{** On entry the srcBuffer should point to the start of a TLV
    structure. It returns the Tag part of that structure.

    @param(srcBuffer Should point to a valid TLV structure buffer)
    @returns(The tag value of this TLV structure)
}
function getTag(const srcBuffer: array of byte): integer;

{** On entry the srcBuffer should point to the start of a TLV
    structure. It returns the length in bytes of the tag value.

    @param(srcBuffer Should point to a valid TLV structure buffer)
    @returns(The length of the tag in bytes, or -1 if this is
      an invalid BER encoded value)
}
function getTagLength(const srcBuffer: array of byte): integer;

{** On entry the srcBuffer should point to the start of a TLV
    structure. It returns the length in bytes of the length value.

    @param(srcBuffer Should point to a valid TLV structure buffer)
    @returns(The length of the length in bytes)
}
function getLengthLength(const srcBuffer: array of byte): integer;

{** On entry srcBuffer should point to the start of a TLV structure,
    it returns the next offset in the buffer where the next TLV structure
    is located, or -1 if there are no more TLV structures in this buffer.
}
function getNextTagOffset(const srcBuffer: array of byte): integer;

implementation

const
  {** Mask that indicates that there are more tag bytes }
  TAG_MASK_LENGTH = $1F;

function findTLV(srcBuffer: array of byte; tag: integer; occurence: integer): integer;
var
 i: integer;
begin
 i:=0;
 findTLV:=-1;
 while i <= High(srcBuffer) do
  begin

  end;
end;


function getValueLength(const srcBuffer: array of byte): integer;
var
  i: integer;
  ValueLength: integer;
begin
  getValueLength:=-1;
  i:=getTagLength(srcBuffer);
  ValueLength:=0;
  ValueLength:=srcBuffer[i] and $7F;
  { Only single byte for length }
  if srcBuffer[i] and $80 = 0 then
    begin
      exit;
    end;
  for i:=1 to ValueLength do
    begin
{!!!!}
    end;
  getValueLength:=ValueLength;
end;

function getValue(const srcBuffer: array of byte; const dstBuffer: array of byte; dstLength: integer): integer;
begin
end;

function getTag(const srcBuffer: array of byte): integer;
begin
end;


function getTagLength(const srcBuffer: array of byte): integer;
var
 tagLength: integer;
 tag: byte;
 i: integer;
begin
 i:=0;
 getTagLength:=-1;
 tagLength:=0;
 tag:=srcBuffer[i];
 Inc(tagLength);
 Inc(i);
 { Is it a constructed tag? }
 if (tag and TAG_MASK_LENGTH) = TAG_MASK_LENGTH then
   begin
    while i <= High(srcBuffer) do
      begin
        if srcBuffer[i] and $80 = $80 then
          begin
            Inc(i);
            inc(tagLength);
          end
        else
          begin
           Inc(tagLength);
           break;
          end;
      end;
   end;
  getTagLength:=tagLength;
end;

function getLengthLength(const srcBuffer: array of byte): integer;
var
  i: integer;
  LengthLength: integer;
begin
  getLengthLength:=-1;
  i:=getTagLength(srcBuffer);
  LengthLength:=0;
  while i <= High(srcBuffer) do
  begin
        if srcBuffer[i] and $80 = $80 then
          begin
            Inc(i);
            inc(LengthLength);
          end
        else
          begin
           Inc(LengthLength);
           break;
          end;
  end;
  getLengthLength:=LengthLength;
end;

function getNextTagOffset(const srcBuffer: array of byte): integer;
begin
end;

function appendTLV(const srcBuffer: array of byte; tag: integer; var dstBuffer: array of byte; dstLength: integer): integer;
begin
end;




end.





