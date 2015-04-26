{$i defines.inc}


{** Hash algorithm testing }
unit testhsh;

interface

uses SysUtils,cksum,hashdrv;

procedure testit;

implementation

type
 TTinyByteArray = array[1..9] of byte;
 THashResult = record
   id: integer;
   value: string;
 end;
 THashResultArray = Array[1..HASH_COUNT] of THashResult;


const
 VALUE_TINY: array[1..9] of byte = 
 { '123456789' }
 ($31,$32,$33,$34,$35,$36,$37,$38,$39);
 
 
 TinyTestHashResult: THashResultArray = 
 (
  (id: HASH_CRC32_ID;     value: 'CBF43926'),
  (id: HASH_ADLER32_ID;   value: '091E01DE'),
  (id: HASH_CRC16_ID;     value: '906E'),
  (id: HASH_CRC_ID;       value: 'BB3D'),
  (id: HASH_FLETCHER16_ID;value: '1EDE'),
  (id: HASH_MD5_ID;       value: '25F9E794323B453885F5181F1B624D0B'),
  (id: HASH_SHA1_ID;      value: 'F7C3BC1D808E04732ADF679965CCC34CA7AE3441'),
  (id: HASH_SHA256_ID;    value: '15E2B0D3C33891EBB0F1EF609EC419420C20E320CE94C65FBC8C3312448EB225'),
  (id: HASH_CRC32C_ID;    value: 'E3069283'),
  (id: HASH_CRC8_ID;      value: 'F4'),
  (id: HASH_ELF_ID;       value: '0678AEE9'),
  (id: HASH_PJW_ID;       value: '0678AEE9'),
  (id: HASH_DJB_ID;       value: '35CDBB82'),
  (id: HASH_LARSON_ID;    value: 'E1AFDBDD'),
  (id: HASH_SUM8_ID;      value: 'DD')
 );
 
 
 { a.txt }
 File01HashResult: THashResultArray = 
 (
  (id: HASH_CRC32_ID;     value: 'E8B7BE43'),
  (id: HASH_ADLER32_ID;   value: '00620062'),
  (id: HASH_CRC16_ID;     value: '82F7'),
  (id: HASH_CRC_ID;       value: 'E8C1'),
  (id: HASH_FLETCHER16_ID;value: '6161'),
  (id: HASH_MD5_ID;       value: '0CC175B9C0F1B6A831C399E269772661'),
  (id: HASH_SHA1_ID;      value: '86F7E437FAA5A7FCE15D1DDCB9EAEAEA377667B8'),
  (id: HASH_SHA256_ID;    value: 'CA978112CA1BBDCAFAC231B39A23DC4DA786EFF8147C4E72B9807785AFEE48BB'),
  (id: HASH_CRC32C_ID;    value: 'C1D04330'),
  (id: HASH_CRC8_ID;      value: '20'),
  (id: HASH_ELF_ID;       value: '00000061'),
  (id: HASH_PJW_ID;       value: '00000061'),
  (id: HASH_DJB_ID;       value: '0002B606'),
  (id: HASH_LARSON_ID;    value: '00000061'),
  (id: HASH_SUM8_ID;      value: '61')
 );

 { book1 }
 File02HashResult: THashResultArray = 
 (
  (id: HASH_CRC32_ID;     value: '24E19972'),
  (id: HASH_ADLER32_ID;   value: 'D4D3613E'),
  (id: HASH_CRC16_ID;     value: 'EAC3'),
  (id: HASH_CRC_ID;       value: 'C90D'),
  (id: HASH_FLETCHER16_ID;value: 'E4F8'),
  (id: HASH_MD5_ID;       value: '0A0FDBAF0589C9713BDE9120CBB20199'),
  (id: HASH_SHA1_ID;      value: '673C583D45544003EB0EDD57F32A683B3C414A18'),
  (id: HASH_SHA256_ID;    value: '9FFA47CD93BCCD732F20E0C304203CFBC1B8A91BEDAC536E2D8F6051003D9951'),
  (id: HASH_CRC32C_ID;    value: '336FF4C9'),
  (id: HASH_CRC8_ID;      value: '89'),
  (id: HASH_ELF_ID;       value: '0EE9780A'),
  (id: HASH_PJW_ID;       value: '0EE9780A'),
  (id: HASH_DJB_ID;       value: '1BA692DC'),
  (id: HASH_LARSON_ID;    value: '4C976E6F'),
  (id: HASH_SUM8_ID;      value: 'B7')
 );
 
 { world192.txt }
 File03HashResult: THashResultArray = 
 (
  (id: HASH_CRC32_ID;     value: '933325F6'),
  (id: HASH_ADLER32_ID;   value: '8D04C1A0'),
  (id: HASH_CRC16_ID;     value: 'E228'),
  (id: HASH_CRC_ID;       value: 'FBE6'),
  (id: HASH_FLETCHER16_ID;value: '0296'),
  (id: HASH_MD5_ID;       value: '30500A27CB7A15E6F2FA0032B06E06C3'),
  (id: HASH_SHA1_ID;      value: 'FE5B97B714B2ABE91A5E64F4E9B4589F61A6A45E'),
  (id: HASH_SHA256_ID;    value: '1AEBDC97D29904B25791DA9AA32BE90B69D7DA6DC0AC9B95512ED27ED40D2112'),
  (id: HASH_CRC32C_ID;    value: 'C6928DB0'),
  (id: HASH_CRC8_ID;      value: 'B7'),
  (id: HASH_ELF_ID;       value: '0685271A'),
  (id: HASH_PJW_ID;       value: '0685271A'),
  (id: HASH_DJB_ID;       value: '4A92D842'),
  (id: HASH_LARSON_ID;    value: '1BEA1E51'),
  (id: HASH_SUM8_ID;      value: '9D')
 );
 

Type
  PByte = ^Byte;

 procedure TestTiny;
 var
  HashInfo: PHashInfo;
  HashHandle: THashHandle;
  Data: PByte;
  s: string;
  i,j: integer;
  count: integer;
  PtrByte: PByte;
  w: word;
  lw: longword;
 Begin
  count:=GetHashCount;
  for i:=1 to count do
   Begin
    HashInfo:=GetHashInfo(i);
    WriteLn('Testing Hash : ',HashInfo^.name);
    GetMem(Data,HashInfo^.bits div 8);
    HashInfo^.init(HashHandle);
    HashInfo^.update(HashHandle, VALUE_TINY, sizeof(VALUE_TINY));
    HashInfo^.final(HashHandle,Data^);
    { We are comparing string values for hash results } 
    s:='';
    PtrByte:=PByte(Data);
    case HashInfo^.bits of
    16:
     Begin
       Move(Data^, w, sizeof(w));
       s:=IntToHex(w,4);
     end;
    32:
     Begin
       Move(Data^, lw, sizeof(lw));
       s:=IntToHex(lw,8);
     end;
    else
     Begin
      for j:=1 to HashInfo^.bits div 8 do
      Begin
        s:=s+IntToHex(PtrByte^,2);     
         Inc(PtrByte);
      end;
      end
    end;
    
    { Now find the correct hash value }
    for j:=Low(TinyTestHashResult) to High(TinyTestHashResult) do
     Begin
       if TinyTestHashResult[j].id = HashInfo^.id then
        Begin
          WriteLn('Calculated : ',s);
          WriteLn('Expected   : ',TinyTestHashResult[j].value);
          Assert(s = TinyTestHashResult[j].value);
        end;
     end;
    Freemem(Data,HashInfo^.bits div 8);
   end;
 end;
 
 
const
 BLOCK_SIZE = 512;
 
 procedure TestFile(FName: String; const Results: THashResultArray);
 var
  HashInfo: PHashInfo;
  HashHandle: THashHandle;
  DataBuffer: ^Byte;
  Data: PByte;
  s: string;
  i,j: integer;
  count: integer;
  PtrByte: PByte;
  w: word;
  lw: longword;
  DataSize: longword;
  F: File;
 Begin
  count:=GetHashCount;
  Assign(F,FName);
  GetMem(DataBuffer,BLOCK_SIZE);
  for i:=1 to count do
   Begin
    HashInfo:=GetHashInfo(i);
    Reset(F,1);
    DataSize:=FileSize(F);
    WriteLn('Testing Hash : ',HashInfo^.name);
    GetMem(Data,HashInfo^.bits div 8);
    HashInfo^.init(HashHandle);
    While DataSize > BLOCK_SIZE do
     Begin
       BlockRead(F,DataBuffer^,BLOCK_SIZE);
       HashInfo^.update(HashHandle, DataBuffer^, BLOCK_SIZE);
       Dec(DataSize,BLOCK_SIZE);
     end;
    if DataSize > 0 then
     Begin
       BlockRead(F,DataBuffer^,DataSize);
       HashInfo^.update(HashHandle, DataBuffer^, DataSize);
     end;
    HashInfo^.final(HashHandle,Data^);
    Close(F);
    
    { We are comparing string values for hash results } 
    s:='';
    PtrByte:=Data;
    case HashInfo^.bits of
    16:
     Begin
       Move(Data^, w, sizeof(w));
       s:=IntToHex(w,4);
     end;
    32:
     Begin
       Move(Data^, lw, sizeof(lw));
       s:=IntToHex(lw,8);
     end;
    else
     Begin
      for j:=1 to HashInfo^.bits div 8 do
      Begin
        s:=s+IntToHex(PtrByte^,2);     
         Inc(PtrByte);
      end;
      end
    end;
    
    { Now find the correct hash value }
    for j:=Low(Results) to High(Results) do
     Begin
       if Results[j].id = HashInfo^.id then
        Begin
          WriteLn('Calculated : ',s);
          WriteLn('Expected   : ',Results[j].value);
          Assert(s = Results[j].value);
        end;
     end;
    Freemem(Data,HashInfo^.bits div 8);
   end;
   FreeMem(DataBuffer,BLOCK_SIZE);
 end;

const
  DIR_TEST = 'TEST';
  DIR_SRC  = 'SRC';
  DIR_BIN  = 'BIN';

{ Get the relative directory information }
Function GetRelativeDir: string;
var
 s: string;
 s1: string;
 i: integer;
Begin
 GetDir(0,s);
 s1:='';
 for i:=Length(s) downto 1 do
  Begin
    if s[i] in ['/','\'] then
      break;
    s1:=s[i]+s1;
  end;
 for i:=1 to Length(s1) do
   s1[i]:=UpCase(s1[i]);
 if s1 = 'BIN' then
   GetRelativeDir := '..'
else
   GetRelativeDir := '.';
end;


procedure testit;
var
 s: string;
Begin
 testtiny;
 s:=GetRelativeDir;
 testfile(s+'\test\data\a.txt',File01HashResult);
 testfile(s+'\test\data\book1',File02HashResult);
 testfile(s+'\test\data\world192.txt',File03HashResult);
end;

end.
