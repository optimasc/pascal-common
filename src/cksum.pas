{
    $Id: crc.pas,v 1.10 2012-02-16 05:40:10 carl Exp $
    Copyright (c) 2004-2014 by Carl Eric Codere

    CRC and Chekcsum routines    
    
    See License.txt for more information on the licensing terms
    for this source code.
    
 **********************************************************************}
{** @author(Carl Eric Codere) 
    @abstract(CRC and checksum generation unit)

    CRC and checksum generation routines, 
    compatible with ISO 3309 and ITU-T-V42 among others.
    
    Also substantianl code from David Barton's DCPCrypt modules
    related to cryptographic hashes. Copyright notice is reproduced
    below.
}
{* Copyright (c) 1999-2002 David Barton                                       *}
{* Permission is hereby granted, free of charge, to any person obtaining a    *}
{* copy of this software and associated documentation files (the "Software"), *}
{* to deal in the Software without restriction, including without limitation  *}
{* the rights to use, copy, modify, merge, publish, distribute, sublicense,   *}
{* and/or sell copies of the Software, and to permit persons to whom the      *}
{* Software is furnished to do so, subject to the following conditions:       *}
{*                                                                            *}
{* The above copyright notice and this permission notice shall be included in *}
{* all copies or substantial portions of the Software.                        *}
{*                                                                            *}
{* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR *}
{* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,   *}
{* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL    *}
{* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER *}
{* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING    *}
{* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER        *}
{* DEALINGS IN THE SOFTWARE.                                                  *}
{******************************************************************************}

Unit cksum;

Interface



{ Some information:
   Name: The name of the algorithm
   Init: The initial value to use
   XorOut: The final result should be xored
           with this value. 0 indicates no xor
           necessary.
   Check: The resulting value against the
          ASCII string 1234565789

   Name   : "CCITT CRC-32"
   Origin : ITU-T,pkzip,ISO 3309
   Width  : 32 bit
   Init   : FFFFFFFF
   XorOut : FFFFFFFF
   Check  : CBF43926

   Name   : "Adler32"
   Origin : IETF RFC 1950,gzip
   Width  : 32 bit
   Init   : 1
   XorOut : 00000000
   Check  : 091E01DE

   Name   : "CCITT CRC-16"
   Origin : ITU,X.25
   Width  : 16 bit
   Init   : FFFF
   XorOut : 0000
   Check  : 29B1 (unsure, since a particular
     web site this indicates this is wrong,
     but this concords with all other
     implementation).

   Name   : "Fletcher 8-bit"
   Origin : IETF RFC 1146
   Width  : 16 bit
   Init   : 0000
   XorOut : 0000
   Check  : DD15 (to be confirmed against
     another implementation).

   Name   : "CRC-16" (used by ARC)
   Origin : Rocksoft Model CRC Algorithm,ARC,
            'IEEE Micro' Aug 88 - A Tutorial on CRC Computations
   Width  : 16 bit
   Init   : 0000
   XorOut : 0000
   Check  : BB3D
}

const
   INIT_CRC32      = $FFFFFFFF;
   INIT_ADLER32    = $00000001; 
   INIT_CRC16      = $FFFF; 
   INIT_FLETCHER16 = $0000;
   INIT_CRC        = $0000; 

Type
  THashHandle = record
    hashValue: longword;
    Data: Pointer;
  end;
  
  



{** @abstrac(Initializes a CRC-32 CCITT hash calculator)

    Initializes a hash calculator that is compatible with 
    ISO 3309, as well as being used in the zip archive format.

   @param(Handle The initialized hash handle)
}
Procedure Crc32Init(var Handle: THashHandle);

{** @abstract(Calculates a CRC-32 CCITT hash)

    @param(Handle The initialized hash handle)
    @param(Buffer The data  to get the CRC-32 of)
    @param(size The length of the data in bytes)
}    
Procedure Crc32Update(var Handle: THashHandle; const Buffer; size: Integer);
{** @abstracf(Returns the results of the CRC-32 CCITT calculation)

    @param(Handle The initialized hash handle)
    @param(HashValue the actual hash value result on 32 bits)
}
Procedure Crc32Final(var Handle: THashHandle; var HashValue);

{** @abstrac(Initializes a CRC-16 CCITT hash calculator)

   Initializes a hash calculator that is compatible with X.25.

   @param(Handle The initialized hash handle)
}
Procedure Crc16Init(var Handle: THashHandle);
{** @abstract(Calculates a CRC-16 CCITT hash)

    @param(Handle The initialized hash handle)
    @param(Buffer The data  to get the CRC-16 of)
    @param(size The length of the data in bytes)
}    
Procedure Crc16Update(var Handle: THashHandle; const Buffer; size: Integer);
{** @abstracf(Returns the results of the CRC-16 CCITT calculation)

    @param(Handle The initialized hash handle)
    @param(HashValue the actual hash value result on 16 bits)
}
Procedure Crc16Final(var Handle: THashHandle; var HashValue);

{** @abstrac(Initializes a Adler-32 hash calculator)

    Initializes a hash calculator that is compatible with 
    IETF RFC 1950, as well as being used in the gzip archive format.

   @param(Handle The initialized hash handle)
}
Procedure Adler32Init(var Handle: THashHandle);
{** @abstract(Calculates an Adler-32 hash)

    @param(Handle The initialized hash handle)
    @param(Buffer The data  to get the Adler-32 of)
    @param(size The length of the data in bytes)
}    
Procedure Adler32Update(var Handle: THashHandle; const Buffer; size: Integer);
{** @abstracf(Returns the results of the Adler-32 calculation)

    @param(Handle The initialized hash handle)
    @param(HashValue the actual hash value result on 32 bits)
}
Procedure Adler32Final(var Handle: THashHandle; var HashValue);


{** @abstrac(Initializes a Fletcher 8-bit hash calculator)

    Initializes a hash calculator that is compatible with 
    IETF RFC 1146.

   @param(Handle The initialized hash handle)
}
Procedure Fletcher16Init(var Handle: THashHandle);
{** @abstract(Calculates a Fletcher-16 hash)

    @param(Handle The initialized hash handle)
    @param(Buffer The data  to get the Fletcher-16 of)
    @param(size The length of the data in bytes)
}    
Procedure Fletcher16Update(var Handle: THashHandle; const Buffer; size: Integer);
{** @abstracf(Returns the results of the Fletcher-16 calculation)

    @param(Handle The initialized hash handle)
    @param(HashValue the actual hash value result on 16 bits)
}
Procedure Fletcher16Final(var Handle: THashHandle; var HashValue);

{** @abstrac(Initializes a CRC-16 hash calculator)

    Initializes a hash calculator that is compatible with 
    Rocksoft Model CRC Algorithm,ARC and 'IEEE Micro' Aug 88 
    - A Tutorial on CRC Computations

   @param(Handle The initialized hash handle)
}
Procedure CrcInit(var Handle: THashHandle);
{** @abstract(Calculates a CRC-16 hash)

    @param(Handle The initialized hash handle)
    @param(Buffer The data  to get the CRC-16  of)
    @param(size The length of the data in bytes)
}    
Procedure CrcUpdate(var Handle: THashHandle; const Buffer; size: Integer);
{** @abstracf(Returns the results of the CRC-16 calculation)

    @param(Handle The initialized hash handle)
    @param(HashValue the actual hash value result on 16 bits)
}
Procedure CrcFinal(var Handle: THashHandle; var HashValue);




{** @abstrac(Initializes a MD5 hash calculator)

    Initializes a hash calculator that is compatible with 
    the MD5 algorithm.

   @param(Handle The initialized hash handle)
}
Procedure MD5Init(var Handle: THashHandle);
{** @abstract(Calculates a MD5 hash)

    @param(Handle The initialized hash handle)
    @param(Buffer The data  to get the hash  of)
    @param(size The length of the data in bytes)
}    
Procedure MD5Update(var Handle: THashHandle; const Buffer; size: Integer);
{** @abstracf(Returns the results of the MD5 calculation)

    @param(Handle The initialized hash handle)
    @param(HashValue the actual hash value result on 16 bits)
}
Procedure MD5Final(var Handle: THashHandle; var HashValue);


{** @abstrac(Initializes a SHA-1 hash calculator)

    Initializes a hash calculator that is compatible with 
    the SHA-1 algorithm.

   @param(Handle The initialized hash handle)
}
Procedure SHA1Init(var Handle: THashHandle);
{** @abstract(Calculates a SHA-1 hash)

    @param(Handle The initialized hash handle)
    @param(Buffer The data  to get the hash  of)
    @param(size The length of the data in bytes)
}    
Procedure SHA1Update(var Handle: THashHandle; const Buffer; size: Integer);
{** @abstracf(Returns the results of the SHA-1 calculation)

    @param(Handle The initialized hash handle)
    @param(HashValue the actual hash value result on 16 bits)
}
Procedure SHA1Final(var Handle: THashHandle; var HashValue);

  
{** @abstrac(Initializes a SHA-256 hash calculator)

    Initializes a hash calculator that is compatible with 
    the SHA-256 algorithm.

   @param(Handle The initialized hash handle)
}
Procedure SHA256Init(var Handle: THashHandle);
{** @abstract(Calculates a SHA-256 hash)

    @param(Handle The initialized hash handle)
    @param(Buffer The data  to get the hash  of)
    @param(size The length of the data in bytes)
}    
Procedure SHA256Update(var Handle: THashHandle; const Buffer; size: Integer);
{** @abstracf(Returns the results of the SHA-1 calculation)

    @param(Handle The initialized hash handle)
    @param(HashValue the actual hash value result on 16 bits)
}
Procedure SHA256Final(var Handle: THashHandle; var HashValue);


{** @exclude }
const crctable32:array[0..255] of longword = (
  $00000000, $77073096, $ee0e612c, $990951ba,
  $076dc419, $706af48f, $e963a535, $9e6495a3,
  $0edb8832, $79dcb8a4, $e0d5e91e, $97d2d988,
  $09b64c2b, $7eb17cbd, $e7b82d07, $90bf1d91,
  $1db71064, $6ab020f2, $f3b97148, $84be41de,
  $1adad47d, $6ddde4eb, $f4d4b551, $83d385c7,
  $136c9856, $646ba8c0, $fd62f97a, $8a65c9ec,
  $14015c4f, $63066cd9, $fa0f3d63, $8d080df5,
  $3b6e20c8, $4c69105e, $d56041e4, $a2677172,
  $3c03e4d1, $4b04d447, $d20d85fd, $a50ab56b,
  $35b5a8fa, $42b2986c, $dbbbc9d6, $acbcf940,
  $32d86ce3, $45df5c75, $dcd60dcf, $abd13d59,
  $26d930ac, $51de003a, $c8d75180, $bfd06116,
  $21b4f4b5, $56b3c423, $cfba9599, $b8bda50f,
  $2802b89e, $5f058808, $c60cd9b2, $b10be924,
  $2f6f7c87, $58684c11, $c1611dab, $b6662d3d,
  $76dc4190, $01db7106, $98d220bc, $efd5102a,
  $71b18589, $06b6b51f, $9fbfe4a5, $e8b8d433,
  $7807c9a2, $0f00f934, $9609a88e, $e10e9818,
  $7f6a0dbb, $086d3d2d, $91646c97, $e6635c01,
  $6b6b51f4, $1c6c6162, $856530d8, $f262004e,
  $6c0695ed, $1b01a57b, $8208f4c1, $f50fc457,
  $65b0d9c6, $12b7e950, $8bbeb8ea, $fcb9887c,
  $62dd1ddf, $15da2d49, $8cd37cf3, $fbd44c65,
  $4db26158, $3ab551ce, $a3bc0074, $d4bb30e2,
  $4adfa541, $3dd895d7, $a4d1c46d, $d3d6f4fb,
  $4369e96a, $346ed9fc, $ad678846, $da60b8d0,
  $44042d73, $33031de5, $aa0a4c5f, $dd0d7cc9,
  $5005713c, $270241aa, $be0b1010, $c90c2086,
  $5768b525, $206f85b3, $b966d409, $ce61e49f,
  $5edef90e, $29d9c998, $b0d09822, $c7d7a8b4,
  $59b33d17, $2eb40d81, $b7bd5c3b, $c0ba6cad,
  $edb88320, $9abfb3b6, $03b6e20c, $74b1d29a,
  $ead54739, $9dd277af, $04db2615, $73dc1683,
  $e3630b12, $94643b84, $0d6d6a3e, $7a6a5aa8,
  $e40ecf0b, $9309ff9d, $0a00ae27, $7d079eb1,
  $f00f9344, $8708a3d2, $1e01f268, $6906c2fe,
  $f762575d, $806567cb, $196c3671, $6e6b06e7,
  $fed41b76, $89d32be0, $10da7a5a, $67dd4acc,
  $f9b9df6f, $8ebeeff9, $17b7be43, $60b08ed5,
  $d6d6a3e8, $a1d1937e, $38d8c2c4, $4fdff252,
  $d1bb67f1, $a6bc5767, $3fb506dd, $48b2364b,
  $d80d2bda, $af0a1b4c, $36034af6, $41047a60,
  $df60efc3, $a867df55, $316e8eef, $4669be79,
  $cb61b38c, $bc66831a, $256fd2a0, $5268e236,
  $cc0c7795, $bb0b4703, $220216b9, $5505262f,
  $c5ba3bbe, $b2bd0b28, $2bb45a92, $5cb36a04,
  $c2d7ffa7, $b5d0cf31, $2cd99e8b, $5bdeae1d,
  $9b64c2b0, $ec63f226, $756aa39c, $026d930a,
  $9c0906a9, $eb0e363f, $72076785, $05005713,
  $95bf4a82, $e2b87a14, $7bb12bae, $0cb61b38,
  $92d28e9b, $e5d5be0d, $7cdcefb7, $0bdbdf21,
  $86d3d2d4, $f1d4e242, $68ddb3f8, $1fda836e,
  $81be16cd, $f6b9265b, $6fb077e1, $18b74777,
  $88085ae6, $ff0f6a70, $66063bca, $11010b5c,
  $8f659eff, $f862ae69, $616bffd3, $166ccf45,
  $a00ae278, $d70dd2ee, $4e048354, $3903b3c2,
  $a7672661, $d06016f7, $4969474d, $3e6e77db,
  $aed16a4a, $d9d65adc, $40df0b66, $37d83bf0,
  $a9bcae53, $debb9ec5, $47b2cf7f, $30b5ffe9,
  $bdbdf21c, $cabac28a, $53b39330, $24b4a3a6,
  $bad03605, $cdd70693, $54de5729, $23d967bf,
  $b3667a2e, $c4614ab8, $5d681b02, $2a6f2b94,
  $b40bbe37, $c30c8ea1, $5a05df1b, $2d02ef8d
);

(* crctab calculated by Mark G. Mendel, Network Systems Corporation *)
{** @exclude }
CONST crctable16ccitt: ARRAY[0..255] OF WORD = 
(
    $0000,  $1021,  $2042,  $3063,  $4084,  $50a5,  $60c6,  $70e7,
    $8108,  $9129,  $a14a,  $b16b,  $c18c,  $d1ad,  $e1ce,  $f1ef,
    $1231,  $0210,  $3273,  $2252,  $52b5,  $4294,  $72f7,  $62d6,
    $9339,  $8318,  $b37b,  $a35a,  $d3bd,  $c39c,  $f3ff,  $e3de,
    $2462,  $3443,  $0420,  $1401,  $64e6,  $74c7,  $44a4,  $5485,
    $a56a,  $b54b,  $8528,  $9509,  $e5ee,  $f5cf,  $c5ac,  $d58d,
    $3653,  $2672,  $1611,  $0630,  $76d7,  $66f6,  $5695,  $46b4,
    $b75b,  $a77a,  $9719,  $8738,  $f7df,  $e7fe,  $d79d,  $c7bc,
    $48c4,  $58e5,  $6886,  $78a7,  $0840,  $1861,  $2802,  $3823,
    $c9cc,  $d9ed,  $e98e,  $f9af,  $8948,  $9969,  $a90a,  $b92b,
    $5af5,  $4ad4,  $7ab7,  $6a96,  $1a71,  $0a50,  $3a33,  $2a12,
    $dbfd,  $cbdc,  $fbbf,  $eb9e,  $9b79,  $8b58,  $bb3b,  $ab1a,
    $6ca6,  $7c87,  $4ce4,  $5cc5,  $2c22,  $3c03,  $0c60,  $1c41,
    $edae,  $fd8f,  $cdec,  $ddcd,  $ad2a,  $bd0b,  $8d68,  $9d49,
    $7e97,  $6eb6,  $5ed5,  $4ef4,  $3e13,  $2e32,  $1e51,  $0e70,
    $ff9f,  $efbe,  $dfdd,  $cffc,  $bf1b,  $af3a,  $9f59,  $8f78,
    $9188,  $81a9,  $b1ca,  $a1eb,  $d10c,  $c12d,  $f14e,  $e16f,
    $1080,  $00a1,  $30c2,  $20e3,  $5004,  $4025,  $7046,  $6067,
    $83b9,  $9398,  $a3fb,  $b3da,  $c33d,  $d31c,  $e37f,  $f35e,
    $02b1,  $1290,  $22f3,  $32d2,  $4235,  $5214,  $6277,  $7256,
    $b5ea,  $a5cb,  $95a8,  $8589,  $f56e,  $e54f,  $d52c,  $c50d,
    $34e2,  $24c3,  $14a0,  $0481,  $7466,  $6447,  $5424,  $4405,
    $a7db,  $b7fa,  $8799,  $97b8,  $e75f,  $f77e,  $c71d,  $d73c,
    $26d3,  $36f2,  $0691,  $16b0,  $6657,  $7676,  $4615,  $5634,
    $d94c,  $c96d,  $f90e,  $e92f,  $99c8,  $89e9,  $b98a,  $a9ab,
    $5844,  $4865,  $7806,  $6827,  $18c0,  $08e1,  $3882,  $28a3,
    $cb7d,  $db5c,  $eb3f,  $fb1e,  $8bf9,  $9bd8,  $abbb,  $bb9a,
    $4a75,  $5a54,  $6a37,  $7a16,  $0af1,  $1ad0,  $2ab3,  $3a92,
    $fd2e,  $ed0f,  $dd6c,  $cd4d,  $bdaa,  $ad8b,  $9de8,  $8dc9,
    $7c26,  $6c07,  $5c64,  $4c45,  $3ca2,  $2c83,  $1ce0,  $0cc1,
    $ef1f,  $ff3e,  $cf5d,  $df7c,  $af9b,  $bfba,  $8fd9,  $9ff8,
    $6e17,  $7e36,  $4e55,  $5e74,  $2e93,  $3eb2,  $0ed1,  $1ef0
);

{** @exclude }
CONST crctable16: ARRAY[0..255] OF WORD = 
(
    $00000,$0C0C1,$0C181,$00140,$0C301,$003C0,$00280,$0C241,
    $0C601,$006C0,$00780,$0C741,$00500,$0C5C1,$0C481,$00440,
    $0CC01,$00CC0,$00D80,$0CD41,$00F00,$0CFC1,$0CE81,$00E40,
    $00A00,$0CAC1,$0CB81,$00B40,$0C901,$009C0,$00880,$0C841,
    $0D801,$018C0,$01980,$0D941,$01B00,$0DBC1,$0DA81,$01A40,
    $01E00,$0DEC1,$0DF81,$01F40,$0DD01,$01DC0,$01C80,$0DC41,
    $01400,$0D4C1,$0D581,$01540,$0D701,$017C0,$01680,$0D641,
    $0D201,$012C0,$01380,$0D341,$01100,$0D1C1,$0D081,$01040,
    $0F001,$030C0,$03180,$0F141,$03300,$0F3C1,$0F281,$03240,
    $03600,$0F6C1,$0F781,$03740,$0F501,$035C0,$03480,$0F441,
    $03C00,$0FCC1,$0FD81,$03D40,$0FF01,$03FC0,$03E80,$0FE41,
    $0FA01,$03AC0,$03B80,$0FB41,$03900,$0F9C1,$0F881,$03840,
    $02800,$0E8C1,$0E981,$02940,$0EB01,$02BC0,$02A80,$0EA41,
    $0EE01,$02EC0,$02F80,$0EF41,$02D00,$0EDC1,$0EC81,$02C40,
    $0E401,$024C0,$02580,$0E541,$02700,$0E7C1,$0E681,$02640,
    $02200,$0E2C1,$0E381,$02340,$0E101,$021C0,$02080,$0E041,
    $0A001,$060C0,$06180,$0A141,$06300,$0A3C1,$0A281,$06240,
    $06600,$0A6C1,$0A781,$06740,$0A501,$065C0,$06480,$0A441,
    $06C00,$0ACC1,$0AD81,$06D40,$0AF01,$06FC0,$06E80,$0AE41,
    $0AA01,$06AC0,$06B80,$0AB41,$06900,$0A9C1,$0A881,$06840,
    $07800,$0B8C1,$0B981,$07940,$0BB01,$07BC0,$07A80,$0BA41,
    $0BE01,$07EC0,$07F80,$0BF41,$07D00,$0BDC1,$0BC81,$07C40,
    $0B401,$074C0,$07580,$0B541,$07700,$0B7C1,$0B681,$07640,
    $07200,$0B2C1,$0B381,$07340,$0B101,$071C0,$07080,$0B041,
    $05000,$090C1,$09181,$05140,$09301,$053C0,$05280,$09241,
    $09601,$056C0,$05780,$09741,$05500,$095C1,$09481,$05440,
    $09C01,$05CC0,$05D80,$09D41,$05F00,$09FC1,$09E81,$05E40,
    $05A00,$09AC1,$09B81,$05B40,$09901,$059C0,$05880,$09841,
    $08801,$048C0,$04980,$08941,$04B00,$08BC1,$08A81,$04A40,
    $04E00,$08EC1,$08F81,$04F40,$08D01,$04DC0,$04C80,$08C41,
    $04400,$084C1,$08581,$04540,$08701,$047C0,$04680,$08641,
    $08201,$042C0,$04380,$08341,$04100,$081C1,$08081,$04040
);



Implementation




Procedure Crc32Init(var Handle: THashHandle);
Begin
  Handle.hashValue := INIT_CRC32;
end;

{$ifopt R+}
{$define Range_Check_On}
{$R-}
{$endif}

Procedure Crc32Update(var Handle: THashHandle; const Buffer; size: Integer);
var
 i: longword;
 crc: longword;
 Ptr: PByte;
Begin
  crc:=Handle.hashValue;
  Ptr:=PByte(Buffer);
  Dec(size);
  for i:=0 to size do
    begin
     CRC := longword(CRC shr 8) xor longword(crctable32[byte(CRC) xor (Ptr^)]);
     Inc(Ptr);
    end;
  Handle.hashValue:=CRC;
end;
{$ifdef Range_check_on}
{$R+}
{$undef Range_check_on}
{$endif Range_check_on}


Procedure Crc32Final(var Handle: THashHandle; var HashValue);
var
 lw: longword;
Begin
  lw:=Handle.hashValue XOR INIT_CRC32;
  Move(lw, hashValue, sizeof(lw));
end;


Procedure Crc16Init(var Handle: THashHandle);
Begin
  Handle.hashValue := INIT_CRC16;
end;



Procedure Crc16Update(var Handle: THashHandle; const Buffer; size: Integer);
var
 i: longword;
 crc: word;
 Ptr: PByte;
begin
   crc:=Handle.hashValue;
   Ptr:=PByte(Buffer);
   Dec(size);
   for i:=0 to size do
     begin
       crc := crctable16ccitt[(((Crc SHR 8) XOR Ptr^) AND 255)]  XOR (Crc SHL 8);
       Inc(Ptr);
     end;
   Handle.hashValue := crc;  
end;

Procedure Crc16Final(var Handle: THashHandle; var HashValue);
var
 w: word;
Begin
  w:=Handle.hashValue;
  Move(w, hashValue, sizeof(w));
end;


Procedure Adler32Init(var Handle: THashHandle);
Begin
  Handle.hashValue := INIT_ADLER32;
end;


{$ifopt R+}
{$define Range_Check_On}
{$R-}
{$endif}
const
  BASE = 65521;
  
Procedure Adler32Update(var Handle: THashHandle; const Buffer; size: Integer);
var
 i: longword;
 s1,s2: longword;
 Ptr: PByte;
 w: word;
begin
  w := Handle.hashValue;
  Dec(size);
  Ptr := PByte(Buffer);
  for i:=0 to size do
    Begin
      s1:=w and $ffff;
      s2:= (w shr 16) and $ffff;
      s1:= (s1 + Ptr^) mod BASE;
      s2:= (s2 + s1) mod BASE;
      Inc(Ptr);
      w:=(s2 shl 16) +s1;
   end;
 Handle.hashValue:=w;
end;
{$ifdef Range_check_on}
{$R+}
{$undef Range_check_on}
{$endif Range_check_on}

Procedure Adler32Final(var Handle: THashHandle; var HashValue);
var
 lw: longword;
Begin
  lw:=Handle.hashValue;
  Move(lw, hashValue, sizeof(lw));
end;


Procedure Fletcher16Init(var Handle: THashHandle);
Begin
  Handle.hashValue := INIT_FLETCHER16;
end;


Procedure Fletcher16Update(var Handle: THashHandle; const Buffer; size: Integer);
var
 i: longword;
 a,c: byte;
 Ptr: PByte;
 w: word;
begin
  w := Handle.hashValue;
  Dec(size);
  Ptr := PByte(Buffer);
  for i:=0 to size do
    begin
     { 1st byte of data in memory }
     a:=(w shr 8) and $ff;
     c:=w and $ff;
     a:=(a + Ptr^) and $ff;
     c:=(c + a) and $ff;
     Inc(Ptr);
     w:=(a shl 8) or c;
   end;
  Handle.HashValue := w;
end;

Procedure Fletcher16Final(var Handle: THashHandle; var HashValue);
var
 w: word;
Begin
  w:=Handle.hashValue;
  Move(w, hashValue, sizeof(w));
end;


Procedure CrcInit(var Handle: THashHandle);
Begin
  Handle.hashValue := INIT_CRC;
end;


Procedure CrcUpdate(var Handle: THashHandle; const Buffer; size: Integer);
var
 i: longword;
 crc: word;
 idx: integer;
 Ptr: PByte;
begin
  crc:=handle.hashValue;
  Ptr:=PByte(Buffer);
  Dec(size);
  for i:=0 to size do
    begin
     idx:=(crc and $ff) xor Ptr^;
     crc:=crc shr 8;
     crc:= (crc xor crctable16[idx]) and $ffff;
     Inc(Ptr);
    end;
  handle.hashValue:=crc;
end;

Procedure CrcFinal(var Handle: THashHandle; var HashValue);
var
 w: word;
Begin
  w:=Handle.hashValue;
  Move(w, hashValue, sizeof(w));
end;


{------------------------------ Utilities  ------------------------------}

function LRot16(X: Word; c: longint): Word;
begin
  LRot16:= (X shl c) or (X shr (16 - c));
end;

function RRot16(X: Word; c: longint): Word;
begin
  RRot16:= (X shr c) or (X shl (16 - c));
end;

function LRot32(X: DWord; c: longint): DWord;
begin
  LRot32:= (X shl c) or (X shr (32 - c));
end;

function RRot32(X: DWord; c: longint): DWord;
begin
  RRot32:= (X shr c) or (X shl (32 - c));
end;

function SwapDWord(X: DWord): DWord;
begin
  SwapDword:= (X shr 24) or ((X shr 8) and $FF00) or ((X shl 8) and $FF0000) or (X shl 24);
end;


{procedure XorBlock(I1, I2, O1: PByteArray; Len: longint);
var
  i: longint;
begin
  for i:= 0 to Len-1 do
    Begin
    O1^[i]:= I1^[i] xor I2^[i];
    end;
end;
}

{------------------------------ SHA-1  ------------------------------}



type
  PSHA1Data = ^TSHA1Data;
  TSHA1Data= record
    LenHi, LenLo: DWord;
    Index: DWord;
    CurrentHash: array[0..4] of DWord;
    HashBuffer: array[0..63] of byte;
  end;
  
  
  
procedure SHA1Burn(var Data: TSHA1Data);
begin
  with Data do begin
  LenHi:= 0; LenLo:= 0;
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  FillChar(CurrentHash,Sizeof(CurrentHash),0);
 end;
end;
  


procedure SHA1Compress(var Data: TSHA1Data);
var
  A, B, C, D, E, T: DWord;
  W: array[0..79] of DWord;
  i: longint;
begin
  with Data do begin
  Index:= 0;
  Move(HashBuffer,W,Sizeof(HashBuffer));
  for i:= 0 to 15 do
    W[i]:= (W[i] shr 24) or ((W[i] shr 8) and $FF00) or ((W[i] shl 8) and $FF0000) or (W[i] shl 24);
  for i:= 16 to 79 do
    W[i]:= LRot32(W[i-3] xor W[i-8] xor W[i-14] xor W[i-16],1);
  A:= CurrentHash[0]; B:= CurrentHash[1]; C:= CurrentHash[2]; D:= CurrentHash[3]; E:= CurrentHash[4];
  for i:= 0 to 19 do
  begin
    T:= LRot32(A,5) + (D xor (B and (C xor D))) + E + W[i] + $5A827999;
    E:= D; D:= C; C:= LRot32(B,30); B:= A; A:= T;
  end;
  for i:= 20 to 39 do
  begin
    T:= LRot32(A,5) + (B xor C xor D) + E + W[i] + $6ED9EBA1;
    E:= D; D:= C; C:= LRot32(B,30); B:= A; A:= T;
  end;
  for i:= 40 to 59 do
  begin
    T:= LRot32(A,5) + ((B and C) or (D and (B or C))) + E + W[i] + $8F1BBCDC;
    E:= D; D:= C; C:= LRot32(B,30); B:= A; A:= T;
  end;
  for i:= 60 to 79 do
  begin
    T:= LRot32(A,5) + (B xor C xor D) + E + W[i] + $CA62C1D6;
    E:= D; D:= C; C:= LRot32(B,30); B:= A; A:= T;
  end;
  CurrentHash[0]:= CurrentHash[0] + A;
  CurrentHash[1]:= CurrentHash[1] + B;
  CurrentHash[2]:= CurrentHash[2] + C;
  CurrentHash[3]:= CurrentHash[3] + D;
  CurrentHash[4]:= CurrentHash[4] + E;
  FillChar(W,Sizeof(W),0);
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  end;
end;

procedure SHA1UpdateLen(var Data: TSHA1Data; Len: DWord);
Begin
  with Data do begin
  Inc(LenLo,(Len shl 3));
  if LenLo< (Len shl 3) then
    Inc(LenHi);
  Inc(LenHi,Len shr 29);
  end;
end;


Procedure SHA1Init(var Handle: THashHandle);
var
 Data: PSHA1Data;
begin
  New(Data);
  SHA1Burn(Data^);
  with Data^ do begin
  CurrentHash[0]:= $67452301;
  CurrentHash[1]:= $EFCDAB89;
  CurrentHash[2]:= $98BADCFE;
  CurrentHash[3]:= $10325476;
  CurrentHash[4]:= $C3D2E1F0;
  end;
  Handle.Data := Data;
end;



Procedure SHA1Update(var Handle: THashHandle; const Buffer; size: Integer);
var
  PBuf: ^byte;
  Data: PSHA1Data;
begin
  Data:=PSHA1Data(Handle.Data);
  with Data^ do begin
  SHA1UpdateLen(Data^,Size);
  PBuf:= @Buffer;
  while Size> 0 do
  begin
    if (Sizeof(HashBuffer)-Index)<= DWord(Size) then
    begin
      Move(PBuf^,HashBuffer[Index],Sizeof(HashBuffer)-Index);
      Dec(Size,Sizeof(HashBuffer)-Index);
      Inc(PBuf,Sizeof(HashBuffer)-Index);
      SHA1Compress(Data^);
    end
    else
    begin
      Move(PBuf^,HashBuffer[Index],Size);
      Inc(Index,Size);
      Size:= 0;
    end;
  end;
  end;
end;

Procedure SHA1Final(var Handle: THashHandle; var HashValue);
var
 Data: PSHA1Data;
begin
  Data:=PSHA1Data(Handle.Data);
  with Data^ do begin
  HashBuffer[Index]:= $80;
  if Index>= 56 then
    SHA1Compress(Data^);
  PDWord(@HashBuffer[56])^:= (LenHi shr 24) or ((LenHi shr 8) and $FF00) or ((LenHi shl 8) and $FF0000) or (LenHi shl 24);
  PDWord(@HashBuffer[60])^:= (LenLo shr 24) or ((LenLo shr 8) and $FF00) or ((LenLo shl 8) and $FF0000) or (LenLo shl 24);
  SHA1Compress(Data^);
  CurrentHash[0]:= (CurrentHash[0] shr 24) or ((CurrentHash[0] shr 8) and $FF00)
    or ((CurrentHash[0] shl 8) and $FF0000) or (CurrentHash[0] shl 24);
  CurrentHash[1]:= (CurrentHash[1] shr 24) or ((CurrentHash[1] shr 8) and $FF00)
    or ((CurrentHash[1] shl 8) and $FF0000) or (CurrentHash[1] shl 24);
  CurrentHash[2]:= (CurrentHash[2] shr 24) or ((CurrentHash[2] shr 8) and $FF00)
    or ((CurrentHash[2] shl 8) and $FF0000) or (CurrentHash[2] shl 24);
  CurrentHash[3]:= (CurrentHash[3] shr 24) or ((CurrentHash[3] shr 8) and $FF00)
    or ((CurrentHash[3] shl 8) and $FF0000) or (CurrentHash[3] shl 24);
  CurrentHash[4]:= (CurrentHash[4] shr 24) or ((CurrentHash[4] shr 8) and $FF00)
    or ((CurrentHash[4] shl 8) and $FF0000) or (CurrentHash[4] shl 24);
  Move(CurrentHash,HashValue,Sizeof(CurrentHash));
  SHA1Burn(Data^); end;
  Dispose(Data);
end;


{------------------------------ SHA-256 ------------------------------}


Type
 PSHA256Data = ^TSHA256Data;
 TSHA256Data = record    
    LenHi, LenLo: longword;
    Index: longword;
    CurrentHash: array[0..7] of longword;
    HashBuffer: array[0..63] of byte;
 end;


Procedure SHA256Burn(var Data: TSHA256Data);
Begin
  with Data Do
   Begin
  LenHi:= 0; LenLo:= 0;
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  FillChar(CurrentHash,Sizeof(CurrentHash),0);
    end;
end;


Procedure SHA256Compress(var Data: TSHA256Data);
var
  a, b, c, d, e, f, g, h, t1, t2: DWord;
  W: array[0..63] of DWord;
  i: longword;
begin
  with Data do
   Begin
  Index:= 0;
  FillChar(W, SizeOf(W), 0);
  a:= CurrentHash[0]; b:= CurrentHash[1]; c:= CurrentHash[2]; d:= CurrentHash[3];
  e:= CurrentHash[4]; f:= CurrentHash[5]; g:= CurrentHash[6]; h:= CurrentHash[7];
  Move(HashBuffer,W,Sizeof(HashBuffer));
  for i:= 0 to 15 do
    W[i]:= SwapDWord(W[i]);
  for i:= 16 to 63 do
    W[i]:= (((W[i-2] shr 17) or (W[i-2] shl 15)) xor ((W[i-2] shr 19) or (W[i-2] shl 13)) xor
      (W[i-2] shr 10)) + W[i-7] + (((W[i-15] shr 7) or (W[i-15] shl 25)) xor
      ((W[i-15] shr 18) or (W[i-15] shl 14)) xor (W[i-15] shr 3)) + W[i-16];
{
Non-optimised version
  for i:= 0 to 63 do
  begin
    t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) +
      ((e and f) xor (not e and g)) + K[i] + W[i];
    t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) +
      ((a and b) xor (a and c) xor (b and c));
    h:= g; g:= f; f:= e; e:= d + t1; d:= c; c:= b; b:= a; a:= t1 + t2;
  end;
}

  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $428a2f98 + W[0]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $71374491 + W[1]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $b5c0fbcf + W[2]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $e9b5dba5 + W[3]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $3956c25b + W[4]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $59f111f1 + W[5]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $923f82a4 + W[6]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $ab1c5ed5 + W[7]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $d807aa98 + W[8]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $12835b01 + W[9]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $243185be + W[10]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $550c7dc3 + W[11]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $72be5d74 + W[12]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $80deb1fe + W[13]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $9bdc06a7 + W[14]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $c19bf174 + W[15]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $e49b69c1 + W[16]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $efbe4786 + W[17]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $0fc19dc6 + W[18]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $240ca1cc + W[19]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $2de92c6f + W[20]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $4a7484aa + W[21]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $5cb0a9dc + W[22]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $76f988da + W[23]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $983e5152 + W[24]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $a831c66d + W[25]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $b00327c8 + W[26]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $bf597fc7 + W[27]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $c6e00bf3 + W[28]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $d5a79147 + W[29]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $06ca6351 + W[30]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $14292967 + W[31]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $27b70a85 + W[32]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $2e1b2138 + W[33]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $4d2c6dfc + W[34]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $53380d13 + W[35]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $650a7354 + W[36]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $766a0abb + W[37]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $81c2c92e + W[38]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $92722c85 + W[39]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $a2bfe8a1 + W[40]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $a81a664b + W[41]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $c24b8b70 + W[42]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $c76c51a3 + W[43]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $d192e819 + W[44]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $d6990624 + W[45]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $f40e3585 + W[46]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $106aa070 + W[47]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $19a4c116 + W[48]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $1e376c08 + W[49]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $2748774c + W[50]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $34b0bcb5 + W[51]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $391c0cb3 + W[52]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $4ed8aa4a + W[53]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $5b9cca4f + W[54]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $682e6ff3 + W[55]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;
  t1:= h + (((e shr 6) or (e shl 26)) xor ((e shr 11) or (e shl 21)) xor ((e shr 25) or (e shl 7))) + ((e and f) xor (not e and g)) + $748f82ee + W[56]; t2:= (((a shr 2) or (a shl 30)) xor ((a shr 13) or (a shl 19)) xor ((a shr 22) xor (a shl 10))) + ((a and b) xor (a and c) xor (b and c)); h:= t1 + t2; d:= d + t1;
  t1:= g + (((d shr 6) or (d shl 26)) xor ((d shr 11) or (d shl 21)) xor ((d shr 25) or (d shl 7))) + ((d and e) xor (not d and f)) + $78a5636f + W[57]; t2:= (((h shr 2) or (h shl 30)) xor ((h shr 13) or (h shl 19)) xor ((h shr 22) xor (h shl 10))) + ((h and a) xor (h and b) xor (a and b)); g:= t1 + t2; c:= c + t1;
  t1:= f + (((c shr 6) or (c shl 26)) xor ((c shr 11) or (c shl 21)) xor ((c shr 25) or (c shl 7))) + ((c and d) xor (not c and e)) + $84c87814 + W[58]; t2:= (((g shr 2) or (g shl 30)) xor ((g shr 13) or (g shl 19)) xor ((g shr 22) xor (g shl 10))) + ((g and h) xor (g and a) xor (h and a)); f:= t1 + t2; b:= b + t1;
  t1:= e + (((b shr 6) or (b shl 26)) xor ((b shr 11) or (b shl 21)) xor ((b shr 25) or (b shl 7))) + ((b and c) xor (not b and d)) + $8cc70208 + W[59]; t2:= (((f shr 2) or (f shl 30)) xor ((f shr 13) or (f shl 19)) xor ((f shr 22) xor (f shl 10))) + ((f and g) xor (f and h) xor (g and h)); e:= t1 + t2; a:= a + t1;
  t1:= d + (((a shr 6) or (a shl 26)) xor ((a shr 11) or (a shl 21)) xor ((a shr 25) or (a shl 7))) + ((a and b) xor (not a and c)) + $90befffa + W[60]; t2:= (((e shr 2) or (e shl 30)) xor ((e shr 13) or (e shl 19)) xor ((e shr 22) xor (e shl 10))) + ((e and f) xor (e and g) xor (f and g)); d:= t1 + t2; h:= h + t1;
  t1:= c + (((h shr 6) or (h shl 26)) xor ((h shr 11) or (h shl 21)) xor ((h shr 25) or (h shl 7))) + ((h and a) xor (not h and b)) + $a4506ceb + W[61]; t2:= (((d shr 2) or (d shl 30)) xor ((d shr 13) or (d shl 19)) xor ((d shr 22) xor (d shl 10))) + ((d and e) xor (d and f) xor (e and f)); c:= t1 + t2; g:= g + t1;
  t1:= b + (((g shr 6) or (g shl 26)) xor ((g shr 11) or (g shl 21)) xor ((g shr 25) or (g shl 7))) + ((g and h) xor (not g and a)) + $bef9a3f7 + W[62]; t2:= (((c shr 2) or (c shl 30)) xor ((c shr 13) or (c shl 19)) xor ((c shr 22) xor (c shl 10))) + ((c and d) xor (c and e) xor (d and e)); b:= t1 + t2; f:= f + t1;
  t1:= a + (((f shr 6) or (f shl 26)) xor ((f shr 11) or (f shl 21)) xor ((f shr 25) or (f shl 7))) + ((f and g) xor (not f and h)) + $c67178f2 + W[63]; t2:= (((b shr 2) or (b shl 30)) xor ((b shr 13) or (b shl 19)) xor ((b shr 22) xor (b shl 10))) + ((b and c) xor (b and d) xor (c and d)); a:= t1 + t2; e:= e + t1;

  CurrentHash[0]:= CurrentHash[0] + a;
  CurrentHash[1]:= CurrentHash[1] + b;
  CurrentHash[2]:= CurrentHash[2] + c;
  CurrentHash[3]:= CurrentHash[3] + d;
  CurrentHash[4]:= CurrentHash[4] + e;
  CurrentHash[5]:= CurrentHash[5] + f;
  CurrentHash[6]:= CurrentHash[6] + g;
  CurrentHash[7]:= CurrentHash[7] + h;
  FillChar(W,Sizeof(W),0);
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  end;
end;


Procedure SHA256Init(var Handle: THashHandle);
var
 Data: PSHA256Data;
Begin
  New(Data);
  Handle.Data := Data;
  SHA256Burn(Data^);
  with Data^ Do
  Begin
  CurrentHash[0]:= $6a09e667;
  CurrentHash[1]:= $bb67ae85;
  CurrentHash[2]:= $3c6ef372;
  CurrentHash[3]:= $a54ff53a;
  CurrentHash[4]:= $510e527f;
  CurrentHash[5]:= $9b05688c;
  CurrentHash[6]:= $1f83d9ab;
  CurrentHash[7]:= $5be0cd19;
  end;
end;


Procedure SHA256Update(var Handle: THashHandle; const Buffer; size: Integer);
var
 Data: PSHA256Data;
  PBuf: ^byte;
Begin
  Data := PSHA256Data(Handle.Data);
  with Data^ do
  Begin 
  Inc(LenHi,Size shr 29);
  Inc(LenLo,Size*8);
  if LenLo< (Size*8) then
    Inc(LenHi);

  PBuf:= @Buffer;
  while Size> 0 do
  begin
    if (Sizeof(HashBuffer)-Index)<= DWord(Size) then
    begin
      Move(PBuf^,HashBuffer[Index],Sizeof(HashBuffer)-Index);
      Dec(Size,Sizeof(HashBuffer)-Index);
      Inc(PBuf,Sizeof(HashBuffer)-Index);
      SHA256Compress(Data^);
    end
    else
    begin
      Move(PBuf^,HashBuffer[Index],Size);
      Inc(Index,Size);
      Size:= 0;
    end;
  end;
  end;
end;


Procedure SHA256Final(var Handle: THashHandle; var HashValue);
var
 Data :PSHA256Data;
Begin
  Data:=PSHA256Data(Handle.Data);
  with Data^ do
  Begin
  HashBuffer[Index]:= $80;
  if Index>= 56 then
    SHA256Compress(Data^);
  PDWord(@HashBuffer[56])^:= SwapDWord(LenHi);
  PDWord(@HashBuffer[60])^:= SwapDWord(LenLo);
  SHA256Compress(Data^);
  CurrentHash[0]:= SwapDWord(CurrentHash[0]);
  CurrentHash[1]:= SwapDWord(CurrentHash[1]);
  CurrentHash[2]:= SwapDWord(CurrentHash[2]);
  CurrentHash[3]:= SwapDWord(CurrentHash[3]);
  CurrentHash[4]:= SwapDWord(CurrentHash[4]);
  CurrentHash[5]:= SwapDWord(CurrentHash[5]);
  CurrentHash[6]:= SwapDWord(CurrentHash[6]);
  CurrentHash[7]:= SwapDWord(CurrentHash[7]);
  Move(CurrentHash,HashValue,Sizeof(CurrentHash));
  SHA256Burn(Data^);
  end;
  Dispose(Data);
end;


{------------------------------ MD5 ------------------------------}

Type
 PMD5Data = ^TMD5Data;
 TMD5Data = record
    LenHi, LenLo: longword;
    Index: DWord;
    CurrentHash: array[0..3] of DWord;
    HashBuffer: array[0..63] of byte;
 end;



procedure MD5Compress(var HData: TMD5Data);
var
  Data: array[0..15] of dword;
  A, B, C, D: dword;
begin

  With HData do
  Begin
  FillChar(Data, SizeOf(Data), 0);
  Move(HashBuffer,Data,Sizeof(Data));
  A:= CurrentHash[0];
  B:= CurrentHash[1];
  C:= CurrentHash[2];
  D:= CurrentHash[3];

  A:= B + LRot32(A + (D xor (B and (C xor D))) + Data[ 0] + $d76aa478,7);
  D:= A + LRot32(D + (C xor (A and (B xor C))) + Data[ 1] + $e8c7b756,12);
  C:= D + LRot32(C + (B xor (D and (A xor B))) + Data[ 2] + $242070db,17);
  B:= C + LRot32(B + (A xor (C and (D xor A))) + Data[ 3] + $c1bdceee,22);
  A:= B + LRot32(A + (D xor (B and (C xor D))) + Data[ 4] + $f57c0faf,7);
  D:= A + LRot32(D + (C xor (A and (B xor C))) + Data[ 5] + $4787c62a,12);
  C:= D + LRot32(C + (B xor (D and (A xor B))) + Data[ 6] + $a8304613,17);
  B:= C + LRot32(B + (A xor (C and (D xor A))) + Data[ 7] + $fd469501,22);
  A:= B + LRot32(A + (D xor (B and (C xor D))) + Data[ 8] + $698098d8,7);
  D:= A + LRot32(D + (C xor (A and (B xor C))) + Data[ 9] + $8b44f7af,12);
  C:= D + LRot32(C + (B xor (D and (A xor B))) + Data[10] + $ffff5bb1,17);
  B:= C + LRot32(B + (A xor (C and (D xor A))) + Data[11] + $895cd7be,22);
  A:= B + LRot32(A + (D xor (B and (C xor D))) + Data[12] + $6b901122,7);
  D:= A + LRot32(D + (C xor (A and (B xor C))) + Data[13] + $fd987193,12);
  C:= D + LRot32(C + (B xor (D and (A xor B))) + Data[14] + $a679438e,17);
  B:= C + LRot32(B + (A xor (C and (D xor A))) + Data[15] + $49b40821,22);

  A:= B + LRot32(A + (C xor (D and (B xor C))) + Data[ 1] + $f61e2562,5);
  D:= A + LRot32(D + (B xor (C and (A xor B))) + Data[ 6] + $c040b340,9);
  C:= D + LRot32(C + (A xor (B and (D xor A))) + Data[11] + $265e5a51,14);
  B:= C + LRot32(B + (D xor (A and (C xor D))) + Data[ 0] + $e9b6c7aa,20);
  A:= B + LRot32(A + (C xor (D and (B xor C))) + Data[ 5] + $d62f105d,5);
  D:= A + LRot32(D + (B xor (C and (A xor B))) + Data[10] + $02441453,9);
  C:= D + LRot32(C + (A xor (B and (D xor A))) + Data[15] + $d8a1e681,14);
  B:= C + LRot32(B + (D xor (A and (C xor D))) + Data[ 4] + $e7d3fbc8,20);
  A:= B + LRot32(A + (C xor (D and (B xor C))) + Data[ 9] + $21e1cde6,5);
  D:= A + LRot32(D + (B xor (C and (A xor B))) + Data[14] + $c33707d6,9);
  C:= D + LRot32(C + (A xor (B and (D xor A))) + Data[ 3] + $f4d50d87,14);
  B:= C + LRot32(B + (D xor (A and (C xor D))) + Data[ 8] + $455a14ed,20);
  A:= B + LRot32(A + (C xor (D and (B xor C))) + Data[13] + $a9e3e905,5);
  D:= A + LRot32(D + (B xor (C and (A xor B))) + Data[ 2] + $fcefa3f8,9);
  C:= D + LRot32(C + (A xor (B and (D xor A))) + Data[ 7] + $676f02d9,14);
  B:= C + LRot32(B + (D xor (A and (C xor D))) + Data[12] + $8d2a4c8a,20);

  A:= B + LRot32(A + (B xor C xor D) + Data[ 5] + $fffa3942,4);
  D:= A + LRot32(D + (A xor B xor C) + Data[ 8] + $8771f681,11);
  C:= D + LRot32(C + (D xor A xor B) + Data[11] + $6d9d6122,16);
  B:= C + LRot32(B + (C xor D xor A) + Data[14] + $fde5380c,23);
  A:= B + LRot32(A + (B xor C xor D) + Data[ 1] + $a4beea44,4);
  D:= A + LRot32(D + (A xor B xor C) + Data[ 4] + $4bdecfa9,11);
  C:= D + LRot32(C + (D xor A xor B) + Data[ 7] + $f6bb4b60,16);
  B:= C + LRot32(B + (C xor D xor A) + Data[10] + $bebfbc70,23);
  A:= B + LRot32(A + (B xor C xor D) + Data[13] + $289b7ec6,4);
  D:= A + LRot32(D + (A xor B xor C) + Data[ 0] + $eaa127fa,11);
  C:= D + LRot32(C + (D xor A xor B) + Data[ 3] + $d4ef3085,16);
  B:= C + LRot32(B + (C xor D xor A) + Data[ 6] + $04881d05,23);
  A:= B + LRot32(A + (B xor C xor D) + Data[ 9] + $d9d4d039,4);
  D:= A + LRot32(D + (A xor B xor C) + Data[12] + $e6db99e5,11);
  C:= D + LRot32(C + (D xor A xor B) + Data[15] + $1fa27cf8,16);
  B:= C + LRot32(B + (C xor D xor A) + Data[ 2] + $c4ac5665,23);

  A:= B + LRot32(A + (C xor (B or (not D))) + Data[ 0] + $f4292244,6);
  D:= A + LRot32(D + (B xor (A or (not C))) + Data[ 7] + $432aff97,10);
  C:= D + LRot32(C + (A xor (D or (not B))) + Data[14] + $ab9423a7,15);
  B:= C + LRot32(B + (D xor (C or (not A))) + Data[ 5] + $fc93a039,21);
  A:= B + LRot32(A + (C xor (B or (not D))) + Data[12] + $655b59c3,6);
  D:= A + LRot32(D + (B xor (A or (not C))) + Data[ 3] + $8f0ccc92,10);
  C:= D + LRot32(C + (A xor (D or (not B))) + Data[10] + $ffeff47d,15);
  B:= C + LRot32(B + (D xor (C or (not A))) + Data[ 1] + $85845dd1,21);
  A:= B + LRot32(A + (C xor (B or (not D))) + Data[ 8] + $6fa87e4f,6);
  D:= A + LRot32(D + (B xor (A or (not C))) + Data[15] + $fe2ce6e0,10);
  C:= D + LRot32(C + (A xor (D or (not B))) + Data[ 6] + $a3014314,15);
  B:= C + LRot32(B + (D xor (C or (not A))) + Data[13] + $4e0811a1,21);
  A:= B + LRot32(A + (C xor (B or (not D))) + Data[ 4] + $f7537e82,6);
  D:= A + LRot32(D + (B xor (A or (not C))) + Data[11] + $bd3af235,10);
  C:= D + LRot32(C + (A xor (D or (not B))) + Data[ 2] + $2ad7d2bb,15);
  B:= C + LRot32(B + (D xor (C or (not A))) + Data[ 9] + $eb86d391,21);

  Inc(CurrentHash[0],A);
  Inc(CurrentHash[1],B);
  Inc(CurrentHash[2],C);
  Inc(CurrentHash[3],D);
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  end;
end;


Procedure MD5Burn(var Data: TMD5Data);
Begin
  with Data Do
  Begin
  LenHi:= 0; LenLo:= 0;
  Index:= 0;
  FillChar(HashBuffer,Sizeof(HashBuffer),0);
  FillChar(CurrentHash,Sizeof(CurrentHash),0);
  end;
end;

Procedure MD5Init(var Handle: THashHandle);
var
 Data: PMD5Data;
Begin
  New(Data);
  MD5Burn(Data^);
  With Data^ do
  Begin
  CurrentHash[0]:= $67452301;
  CurrentHash[1]:= $efcdab89;
  CurrentHash[2]:= $98badcfe;
  CurrentHash[3]:= $10325476;
  end;
  Handle.Data:=Data;
end;


Procedure MD5Update(var Handle: THashHandle; const Buffer; size: Integer);
var
 Data: PMD5Data;
 PBuf: ^Byte;
Begin

  Data:=PMD5Data(Handle.Data);
  With Data^ do
  Begin
  Inc(LenHi,Size shr 29);
  Inc(LenLo,Size*8);
  if LenLo< (Size*8) then
    Inc(LenHi);

  PBuf:= @Buffer;
  while Size> 0 do
  begin
    if (Sizeof(HashBuffer)-Index)<= DWord(Size) then
    begin
      Move(PBuf^,HashBuffer[Index],Sizeof(HashBuffer)-Index);
      Dec(Size,Sizeof(HashBuffer)-Index);
      Inc(PBuf,Sizeof(HashBuffer)-Index);
      MD5Compress(Data^);
    end
    else
    begin
      Move(PBuf^,HashBuffer[Index],Size);
      Inc(Index,Size);
      Size:= 0;
    end;
  end;
  end;
end;

Procedure MD5Final(var Handle: THashHandle; var HashValue);
var
 Data: PMD5Data;
Begin
  Data:=PMD5Data(Handle.Data);
  With Data^ do 
  Begin
  HashBuffer[Index]:= $80;
  if Index>= 56 then
    MD5Compress(Data^);
  PDWord(@HashBuffer[56])^:= LenLo;
  PDWord(@HashBuffer[60])^:= LenHi;
  MD5Compress(Data^);
  Move(CurrentHash,HashValue,Sizeof(CurrentHash));
  MD5Burn(Data^);
  end;
  Dispose(Data);
end;


end.

{
  $Log: not supported by cvs2svn $
  Revision 1.9  2011/11/24 00:27:38  carl
  + update to new architecture of dates and times, as well as removal of some duplicate files.

  Revision 1.8  2011/11/23 23:10:47  carl
  Rename crc to sums to avoid compatibility problems with lazarus

  Revision 1.7  2011/04/12 00:36:41  carl
  + Added support for passing open array parameters to gain performance
     when validating a complete buffer.

  Revision 1.6  2006/08/31 03:07:36  carl
  + Better documentation

  Revision 1.5  2005/07/20 03:14:11  carl
   * Make the CRC tables public

  Revision 1.4  2004/11/19 01:37:27  carl
    + more documentation

  Revision 1.3  2004/08/27 02:10:32  carl
    + support for more checksum algorithms

  Revision 1.2  2004/06/20 18:49:37  carl
    + added  GPC support

  Revision 1.1  2004/05/05 16:28:18  carl
    Release 0.95 updates


}
