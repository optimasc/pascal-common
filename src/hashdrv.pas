{
    $Id$
    Copyright (c) 2014 by Carl Eric Codere

    CRC and Chekcsum generic driver routines.   
    
    See License.txt for more information on the licensing terms
    for this source code.
    
 **********************************************************************}
{** @author(Carl Eric Codere) 
    @abstract(Generic hash routine driver)

    Interface to have a simple way to use different hash algorithms
    and get information on each of those algorithms.
}

unit hashdrv;

{$i defines.inc}

interface

uses cksum;

const
 HASH_COUNT = 15;

Type


   THashUpdate = Procedure (var Handle: THashHandle; const Buffer; size: Integer);
   THashFinal = Procedure (var Handle: THashHandle; var HashValue);
   THashInit = Procedure (var Handle: THashHandle);


  PHashInfo = ^THashInfo;
  THashInfo = record
    {** Function to call to initialize this hash }
    init:  THashInit;
    {** Function to call to calculate the hash on the data }
    update: THashUpdate;
    {** Function to call to retrieve the hash value. The buffer size
        should be of at least bits size! }
    final: THashFinal;
    {** Number of bits of the returned hash }
    bits: integer; 
    {** Name of this hash algorithm }
    name: string;
    {** Unique identifier of this hash algorithm }
    id: integer;
  end;

{** @abstract(Returns the hash information structure at the specified index)
    
   @param(index The index of the driver to retrieve information on, starting
     with index 1)
   @returns(nil if out of bounds, otherwise a structure containing the
    information on the hash algorithm and callbacks.)
   
}
function GetHashInfo(index: integer): PHashInfo;


{** @abstract(Returns the number of hash algorithms implemented in this
     driver)
}
function GetHashCount: Integer;


{** @abstract(Returns the hash information structure associated with
    the specified hash identifier)
}
function GetHashById(id: Integer): PHashInfo;


const
  HASH_CRC32_ID   =   1;
  HASH_ADLER32_ID =   2;
  HASH_CRC16_ID   =   3;
  HASH_CRC_ID     =   4;
  HASH_FLETCHER16_ID = 5;
  HASH_MD5_ID     =   6;
  HASH_SHA1_ID    =   7;
  HASH_SHA256_ID  =   8;
  HASH_CRC32C_ID   =   9;
  HASH_CRC8_ID   =   10;
  HASH_ELF_ID    =   11;
  HASH_PJW_ID    =   12;
  HASH_DJB_ID    =   13;
  HASH_SUM8_ID   =   14;
  HASH_LARSON_ID   =   15;
  

implementation


const
  MIN_INDEX = 1;
  MAX_INDEX = HASH_COUNT; 
  Drivers: Array[MIN_INDEX..MAX_INDEX] of THashInfo = 
  (
    (init: {$ifdef fpc}@{$endif}crc32Init;
     update: {$ifdef fpc}@{$endif}crc32Update;
     final: {$ifdef fpc}@{$endif}crc32Final;
     bits: 32;
     name: 'CRC-32 CCITT';
     id: HASH_CRC32_ID
    ),
    (init: {$ifdef fpc}@{$endif}adler32Init;
     update: {$ifdef fpc}@{$endif}adler32Update;
     final: {$ifdef fpc}@{$endif}adler32Final;
     bits: 32;
     name: 'Adler-32';
     id: HASH_ADLER32_ID
    ),
    (init: {$ifdef fpc}@{$endif}crc16Init;
     update: {$ifdef fpc}@{$endif}crc16Update;
     final: {$ifdef fpc}@{$endif}crc16Final;
     bits: 16;
     name: 'CRC-16 CCITT';
     id: HASH_CRC16_ID
    ),
    (init: {$ifdef fpc}@{$endif}crcInit;
     update: {$ifdef fpc}@{$endif}crcUpdate;
     final: {$ifdef fpc}@{$endif}crcFinal;
     bits: 16;
     name: 'CRC-16';
     id: HASH_CRC_ID
    ),
    (init: {$ifdef fpc}@{$endif}fletcher16Init;
     update: {$ifdef fpc}@{$endif}fletcher16Update;
     final: {$ifdef fpc}@{$endif}fletcher16Final;
     bits: 16;
     name: 'Fletcher-16';
     id: HASH_FLETCHER16_ID
    ),
    (init: {$ifdef fpc}@{$endif}md5Init;
     update: {$ifdef fpc}@{$endif}md5Update;
     final: {$ifdef fpc}@{$endif}md5Final;
     bits: 128;
     name: 'MD5';
     id: HASH_MD5_ID
    ),
    (init: {$ifdef fpc}@{$endif}sha1Init;
     update: {$ifdef fpc}@{$endif}sha1Update;
     final: {$ifdef fpc}@{$endif}sha1Final;
     bits: 160;
     name: 'SHA-1';
     id: HASH_SHA1_ID
    ),
    (init: {$ifdef fpc}@{$endif}sha256Init;
     update: {$ifdef fpc}@{$endif}sha256Update;
     final: {$ifdef fpc}@{$endif}sha256Final;
     bits: 256;
     name: 'SHA-256';
     id: HASH_SHA256_ID
    ),
    (init: {$ifdef fpc}@{$endif}crc32CInit;
     update: {$ifdef fpc}@{$endif}crc32CUpdate;
     final: {$ifdef fpc}@{$endif}crc32CFinal;
     bits: 32;
     name: 'CRC32C';
     id: HASH_CRC32C_ID
    ),
    (init: {$ifdef fpc}@{$endif}crc8Init;
     update: {$ifdef fpc}@{$endif}crc8Update;
     final: {$ifdef fpc}@{$endif}crc8Final;
     bits: 8;
     name: 'CRC-8';
     id: HASH_CRC8_ID
    ),
    (init: {$ifdef fpc}@{$endif}ElfInit;
     update: {$ifdef fpc}@{$endif}ElfUpdate;
     final: {$ifdef fpc}@{$endif}ElfFinal;
     bits: 32;
     name: 'ELF';
     id: HASH_ELF_ID
    ),
    (init: {$ifdef fpc}@{$endif}PJWInit;
     update: {$ifdef fpc}@{$endif}PJWUpdate;
     final: {$ifdef fpc}@{$endif}PJWFinal;
     bits: 32;
     name: 'PJW (book)';
     id: HASH_PJW_ID
    ),
    (init: {$ifdef fpc}@{$endif}DJBInit;
     update: {$ifdef fpc}@{$endif}DJBUpdate;
     final: {$ifdef fpc}@{$endif}DJBFinal;
     bits: 32;
     name: 'DJB';
     id: HASH_DJB_ID
    ),
    (init: {$ifdef fpc}@{$endif}Sum8Init;
     update: {$ifdef fpc}@{$endif}Sum8Update;
     final: {$ifdef fpc}@{$endif}Sum8Final;
     bits: 8;
     name: 'Sum8';
     id: HASH_SUM8_ID
    ),
    (init: {$ifdef fpc}@{$endif}LarsonInit;
     update: {$ifdef fpc}@{$endif}LarsonUpdate;
     final: {$ifdef fpc}@{$endif}LarsonFinal;
     bits: 32;
     name: 'larson';
     id: HASH_LARSON_ID
    )    
  );
  
  
  function GetHashCount: Integer;
  Begin
    GetHashCount := MAX_INDEX;
  end;
  
  function GetHashInfo(index: integer): PHashInfo;
  Begin
    GetHashInfo:=nil;
    if (index < MIN_INDEX) or (index > MAX_INDEX) then
      exit;
    GetHashInfo:=@Drivers[index];  
  end;

function GetHashById(id: Integer): PHashInfo;
 var
  i: integer;
  DriverInfo: PHashInfo;
 Begin
   GetHasHbyId := nil;
   for i:=Low(Drivers) to High(Drivers) do
    Begin
      DriverInfo:=@Drivers[i];
      if DriverInfo^.Id = id then
        Begin
          GetHashById := DriverInfo;
          exit;
        end;
    end;
 end;
  
  
end.