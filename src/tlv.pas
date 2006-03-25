{** This unit implements routines to work with
    BER-TLV structures. All offsets from the
    are based on indexes that start from 0.
    
    Currently has the following limitations:
       - Supports data length of up to 4 Gbytes
         (length encoding on 1,2 3 or 4 bytes in
          long or short form only, indefinite form
          is not supported).
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

{** Returns the value part of a TLV strcture currently pointed
    to by srcBuffer. 
    
    @param(srcBuffer Should point to a valid TLV structure buffer)
    @retrns(Number of bytes copied, or -1 if there was an error
      in the operation)
}    

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
      getValueLength:=ValueLength;
      exit;
    end;
  { Encoding follows according to the number of bytes }  
  case ValueLength of 
  { Length is encoded on an unsigned byte }
  1: begin
       Inc(i);
       getValueLength:=srcBuffer[i];
       exit;
     end;
  { Length is encoded on a word, big-endian }   
  2: begin
       getValueLength:=0;
       inc(i);
       getValueLength:=srcBuffer[i] shl 8;
       inc(i);
       getValueLength:=getValueLength or srcBuffer[i];
       exit;
     end;
  { 3 bytes encoding }   
  3: begin
       getValueLength:=0;
       inc(i);
       getValueLength:=srcBuffer[i] shl 16;
       inc(i);
       getValueLength:=srcBuffer[i] shl 8;
       inc(i);
       getValueLength:=getValueLength or srcBuffer[i];
       exit;
     end;
  { Length is encoded on a longword big-endian }   
  4: begin
       getValueLength:=0;
       inc(i);
       getValueLength:=srcBuffer[i] shl 24;
       inc(i);
       getValueLength:=srcBuffer[i] shl 16;
       inc(i);
       getValueLength:=srcBuffer[i] shl 8;
       inc(i);
       getValueLength:=getValueLength or srcBuffer[i];
       exit;
     end;
  else
    begin
      { Currently unsupported }
      exit;
    end;
  getValueLength:=ValueLength;
end;

function getValue(const srcBuffer: array of byte; const dstBuffer: array of byte; dstLength: integer): integer;
var
  tagLength: integer;
  lengthLength: integer;
begin
  getValue:=-1;
  tagLength:=getTagLength(srcBuffer)
  LengthLength:=getLengthLegth(srcBuffer);
  if (tagLength = -1) or (lengthLength = -1) then
    exit;
  getValue:=getValueLength(srcBuffer);
  { Out of bounds? }
  if High(dstBuffer) > getValue then
    begin
       getValue:=-1;
       exit;
    end; 
  { Copy the data }
  Move(srcBuffer[tagLength+LengthLength],dstBuffer,getValue);
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
  LengthLength:=1;
  if srcBuffer[i] and $80 = $80 then
   begin
     Inc(i);
     LengthLength:=srcBuffer[i]+1;
   end
  getLengthLength:=LengthLength;
end;

function getNextTagOffset(const srcBuffer: array of byte): integer;
begin
end;

function appendTLV(const srcBuffer: array of byte; tag: integer; var dstBuffer: array of byte; dstLength: integer): integer;
begin
end;




end.





