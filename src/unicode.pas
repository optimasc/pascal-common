{
 ****************************************************************************
    $Id: unicode.pas,v 1.3 2004-05-06 15:47:27 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Unicode related routines
    Partially converted from: 
    http://www.unicode.org/Public/PROGRAMS/CVTUTF/

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}
{** @author(Carl Eric Codere)
    @abstract(unicode support unit)

    This unit contains routines to convert
    between the different unicode encoding
    schemes. 
    
    All unicode strings are limited to
    255 characters. 
    
    Since all these encoding are variable length,
    except the UTF-32 and UCS-2 encoding, to parse through
    characters, every string should be converted to
    UTF-32 or UCS-2 before being used.
    
    UCS-2 is encoded in network byte order (big-endian).
}
unit unicode;

interface

uses 
  tpautils,
  vpautils,
  dpautils,
  fpautils,
  utils;

type
  {** UTF-8 base data type }
  utf8 = char;
  {** UTF-16 base data type }
  utf16 = word;
  {** UTF-32 base data type }
  utf32 = longword;
  {** UCS-2 base data type }
  ucs2 = word;
  
  {** UCS-2 string declaration. Index 0 contains the active length
      of the string in characters.
  }  
  ucs2string = array[0..255] of ucs2;
  {** UTF-32 string declaration. Index 0 contains the active length
      of the string in characters. 
  }
  utf32string = array[0..255] of utf32;

  {** UTF-8 string declaration. Index 0 contains the active length
      of the string in BYTES
  }
  utf8string = array[0..1024] of utf8;
  {** UTF-16 string declaration. Index 0 contains the active length
      of the string in BYTES
  }
  utf16string = array[0..255] of utf16;

const  
  {** Return status: conversion successful }
  UNICODE_ERR_OK =     0;
  {** Return status: source sequence is illegal/malformed }
  UNICODE_ERR_SOURCEILLEGAL = -1;
  {** Return status: Target space excedeed }
  UNICODE_ERR_LENGTH_EXCEED = -2;
  {** Return status: Some charactrer could not be successfully converted to this format }
  UNICODE_ERR_INCOMPLETE_CONVERSION = -3;
  {** Return status: The character set is not found }
  UNICODE_ERR_NOTFOUND = -4;
  
  {** @abstract(Returns the current length of an UTF-16 string) }
  function lengthUTF16(s: array of utf16): integer;

  {** @abstract(Returns the current length of an UTF-8 string) }
  function lengthutf8(s: array of utf8): integer;
  
  {** @abstract(Returns the current length of an UTF-32 string) }
  function lengthutf32(s: array of utf32): integer;
  
  {** @abstract(Set the length of an UTF-8 string) }
  procedure setlengthUTF8(var s: array of utf8; l: integer);

  {** @abstract(Set the length of an UTF-16 string) }
  procedure setlengthUTF16(var s: array of utf16; l: integer);

  procedure setlengthutf32(var s: array of utf32; l: integer);

  {** @abstract(Convert an UTF-32 string to an UTF-8 string) 
  }
  function convertUTF32toUTF8(s: array of utf32; var outstr: utf8string): integer;
  
  {** @abstract(Convert an UTF-32 string to a single byte encoded string) 
  
     This routine converts an UTF-32 string stored in native byte order
     (native endian) to a single-byte encoded string.

     The string is limited to 255 characters, and if the conversion cannot
     be successfully be completed, it gives out an error. The following
     @code(desttype) can be specified: ISO-8859-1, windows-1252,
     ISO-8859-2, ISO-8859-5, ISO-8859-16, macintosh, atari, cp437, cp850, ASCII.
  
      @param(desttype Indicates the single byte encoding scheme)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }  
  function ConvertFromUTF32(source: utf32string; var dest: shortstring; desttype: string): integer;

  {** @abstract(Convert a byte encoded string to an UTF-32 string) 
  
     This routine converts a single byte encoded string to an UTF-32
     string stored in native byte order

     The string is limited to 255 characters, and if the conversion cannot
     be successfully be completed, it gives out an error. The following
     @code(srctype) can be specified: ISO-8859-1, windows-1252,
     ISO-8859-2, ISO-8859-5, ISO-8859-16, macintosh, atari, cp437, cp850, ASCII.
  
      @param(srctype Indicates the single byte encoding scheme)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }  
  function ConvertToUTF32(source: shortstring; var dest: utf32string; srctype: string): integer;
  
  {** @abstract(Convert an UTF-16 string to an UTF-32 string)
  
      This routine converts an UTF-16 string to an UTF-32 string.
      Both strings must be stored in native byte order (native endian).
  
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF16ToUTF32(src: array of utf16; var dst: utf32string): integer;
  
  {** @abstract(Convert an UTF-32 string to an UTF-16 string)
  
      This routine converts an UTF-32 string to an UTF-16 string.
      Both strings must be stored in native byte order (native endian).
  
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF32toUTF16(src: array of utf32; var dest: utf16string): integer;
  
  {** @abstract(Convert an UTF-8 string to an UTF-32 string)
  
      This routine converts an UTF-8 string to an UTF-32 string that
      is stored in native byte order.
  
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF8ToUTF32(src: array of utf8; var dst: utf32string): integer;

  {** @abstract(Convert an UTF-32 string to an UCS-2 string)
  
      This routine converts an UTF-32 string to an UCS-2 string that
      is stored in network byte order (big-endian). If some characters
      could not be converted an error will be reported.
      
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  
  }
  function ConvertUTF32ToUCS2(src: array of utf32; var dst: ucs2string): integer;
  

implementation


type 
  pchararray = ^tchararray;
  tchararray = array[#0..#255] of longint;
  taliasinfo = record
    name: string[32];
    table: pchararray;
  end;   
  
const
{$i i8859_1.inc}
{$i i8859_2.inc}
{$i i8859_5.inc}
{$i i8859_16.inc}
{$i atarist.inc}
{$i cp1252.inc}
{$i cp437.inc}
{$i cp850.inc}
{$i macroman.inc}

  { ASCII conversion table }
  asciitoutf32: array[#0..#255] of longint =
  (
{00} $0000,{ #  NULL                                                           }
{01} $0001,{ #  START OF HEADING                                               }
{02} $0002,{ #  START OF TEXT                                                  }
{03} $0003,{ #  END OF TEXT                                                    }
{04} $0004,{ #  END OF TRANSMISSION                                            }
{05} $0005,{ #  ENQUIRY                                                        }
{06} $0006,{ #  ACKNOWLEDGE                                                    }
{07} $0007,{ #  BELL                                                           }
{08} $0008,{ #  BACKSPACE                                                      }
{09} $0009,{ #  HORIZONTAL TABULATION                                          }
{0A} $000A,{ #  LINE FEED                                                      }
{0B} $000B,{ #  VERTICAL TABULATION                                            }
{0C} $000C,{ #  FORM FEED                                                      }
{0D} $000D,{ #  CARRIAGE RETURN                                                }
{0E} $000E,{ #  SHIFT OUT                                                      }
{0F} $000F,{ #  SHIFT IN                                                       }
{10} $0010,{ #  DATA LINK ESCAPE                                               }
{11} $0011,{ #  DEVICE CONTROL ONE                                             }
{12} $0012,{ #  DEVICE CONTROL TWO                                             }
{13} $0013,{ #  DEVICE CONTROL THREE                                           }
{14} $0014,{ #  DEVICE CONTROL FOUR                                            }
{15} $0015,{ #  NEGATIVE ACKNOWLEDGE                                           }
{16} $0016,{ #  SYNCHRONOUS IDLE                                               }
{17} $0017,{ #  END OF TRANSMISSION BLOCK                                      }
{18} $0018,{ #  CANCEL                                                         }
{19} $0019,{ #  END OF MEDIUM                                                  }
{1A} $001A,{ #  SUBSTITUTE                                                     }
{1B} $001B,{ #  ESCAPE                                                         }
{1C} $001C,{ #  FILE SEPARATOR                                                 }
{1D} $001D,{ #  GROUP SEPARATOR                                                }
{1E} $001E,{ #  RECORD SEPARATOR                                               }
{1F} $001F,{ #  UNIT SEPARATOR                                                 }
{20} $0020,{ #  SPACE                                                          }
{21} $0021,{ #  EXCLAMATION MARK                                               }
{22} $0022,{ #  QUOTATION MARK                                                 }
{23} $0023,{ #  NUMBER SIGN                                                    }
{24} $0024,{ #  DOLLAR SIGN                                                    }
{25} $0025,{ #  PERCENT SIGN                                                   }
{26} $0026,{ #  AMPERSAND                                                      }
{27} $0027,{ #  APOSTROPHE                                                     }
{28} $0028,{ #  LEFT PARENTHESIS                                               }
{29} $0029,{ #  RIGHT PARENTHESIS                                              }
{2A} $002A,{ #  ASTERISK                                                       }
{2B} $002B,{ #  PLUS SIGN                                                      }
{2C} $002C,{ #  COMMA                                                          }
{2D} $002D,{ #  HYPHEN-MINUS                                                   }
{2E} $002E,{ #  FULL STOP                                                      }
{2F} $002F,{ #  SOLIDUS                                                        }
{30} $0030,{ #  DIGIT ZERO                                                     }
{31} $0031,{ #  DIGIT ONE                                                      }
{32} $0032,{ #  DIGIT TWO                                                      }
{33} $0033,{ #  DIGIT THREE                                                    }
{34} $0034,{ #  DIGIT FOUR                                                     }
{35} $0035,{ #  DIGIT FIVE                                                     }
{36} $0036,{ #  DIGIT SIX                                                      }
{37} $0037,{ #  DIGIT SEVEN                                                    }
{38} $0038,{ #  DIGIT EIGHT                                                    }
{39} $0039,{ #  DIGIT NINE                                                     }
{3A} $003A,{ #  COLON                                                          }
{3B} $003B,{ #  SEMICOLON                                                      }
{3C} $003C,{ #  LESS-THAN SIGN                                                 }
{3D} $003D,{ #  EQUALS SIGN                                                    }
{3E} $003E,{ #  GREATER-THAN SIGN                                              }
{3F} $003F,{ #  QUESTION MARK                                                  }
{40} $0040,{ #  COMMERCIAL AT                                                  }
{41} $0041,{ #  LATIN CAPITAL LETTER A                                         }
{42} $0042,{ #  LATIN CAPITAL LETTER B                                         }
{43} $0043,{ #  LATIN CAPITAL LETTER C                                         }
{44} $0044,{ #  LATIN CAPITAL LETTER D                                         }
{45} $0045,{ #  LATIN CAPITAL LETTER E                                         }
{46} $0046,{ #  LATIN CAPITAL LETTER F                                         }
{47} $0047,{ #  LATIN CAPITAL LETTER G                                         }
{48} $0048,{ #  LATIN CAPITAL LETTER H                                         }
{49} $0049,{ #  LATIN CAPITAL LETTER I                                         }
{4A} $004A,{ #  LATIN CAPITAL LETTER J                                         }
{4B} $004B,{ #  LATIN CAPITAL LETTER K                                         }
{4C} $004C,{ #  LATIN CAPITAL LETTER L                                         }
{4D} $004D,{ #  LATIN CAPITAL LETTER M                                         }
{4E} $004E,{ #  LATIN CAPITAL LETTER N                                         }
{4F} $004F,{ #  LATIN CAPITAL LETTER O                                         }
{50} $0050,{ #  LATIN CAPITAL LETTER P                                         }
{51} $0051,{ #  LATIN CAPITAL LETTER Q                                         }
{52} $0052,{ #  LATIN CAPITAL LETTER R                                         }
{53} $0053,{ #  LATIN CAPITAL LETTER S                                         }
{54} $0054,{ #  LATIN CAPITAL LETTER T                                         }
{55} $0055,{ #  LATIN CAPITAL LETTER U                                         }
{56} $0056,{ #  LATIN CAPITAL LETTER V                                         }
{57} $0057,{ #  LATIN CAPITAL LETTER W                                         }
{58} $0058,{ #  LATIN CAPITAL LETTER X                                         }
{59} $0059,{ #  LATIN CAPITAL LETTER Y                                         }
{5A} $005A,{ #  LATIN CAPITAL LETTER Z                                         }
{5B} $005B,{ #  LEFT SQUARE BRACKET                                            }
{5C} $005C,{ #  REVERSE SOLIDUS                                                }
{5D} $005D,{ #  RIGHT SQUARE BRACKET                                           }
{5E} $005E,{ #  CIRCUMFLEX ACCENT                                              }
{5F} $005F,{ #  LOW LINE                                                       }
{60} $0060,{ #  GRAVE ACCENT                                                   }
{61} $0061,{ #  LATIN SMALL LETTER A                                           }
{62} $0062,{ #  LATIN SMALL LETTER B                                           }
{63} $0063,{ #  LATIN SMALL LETTER C                                           }
{64} $0064,{ #  LATIN SMALL LETTER D                                           }
{65} $0065,{ #  LATIN SMALL LETTER E                                           }
{66} $0066,{ #  LATIN SMALL LETTER F                                           }
{67} $0067,{ #  LATIN SMALL LETTER G                                           }
{68} $0068,{ #  LATIN SMALL LETTER H                                           }
{69} $0069,{ #  LATIN SMALL LETTER I                                           }
{6A} $006A,{ #  LATIN SMALL LETTER J                                           }
{6B} $006B,{ #  LATIN SMALL LETTER K                                           }
{6C} $006C,{ #  LATIN SMALL LETTER L                                           }
{6D} $006D,{ #  LATIN SMALL LETTER M                                           }
{6E} $006E,{ #  LATIN SMALL LETTER N                                           }
{6F} $006F,{ #  LATIN SMALL LETTER O                                           }
{70} $0070,{ #  LATIN SMALL LETTER P                                           }
{71} $0071,{ #  LATIN SMALL LETTER Q                                           }
{72} $0072,{ #  LATIN SMALL LETTER R                                           }
{73} $0073,{ #  LATIN SMALL LETTER S                                           }
{74} $0074,{ #  LATIN SMALL LETTER T                                           }
{75} $0075,{ #  LATIN SMALL LETTER U                                           }
{76} $0076,{ #  LATIN SMALL LETTER V                                           }
{77} $0077,{ #  LATIN SMALL LETTER W                                           }
{78} $0078,{ #  LATIN SMALL LETTER X                                           }
{79} $0079,{ #  LATIN SMALL LETTER Y                                           }
{7A} $007A,{ #  LATIN SMALL LETTER Z                                           }
{7B} $007B,{ #  LEFT CURLY BRACKET                                             }
{7C} $007C,{ #  VERTICAL LINE                                                  }
{7D} $007D,{ #  RIGHT CURLY BRACKET                                            }
{7E} $007E,{ #  TILDE                                                          }
{7F} $007F,{ #  DELETE                                                         }
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1,
     -1
  );

const
  MAX_ALIAS = 26;
  aliaslist: array[1..MAX_ALIAS] of taliasinfo = 
  (
    (name: 'ISO-8859-1';table: @i8859_1toUTF32),
    (name: 'ISO_8859-1';table: @i8859_1toUTF32),
    (name: 'latin1';    table: @i8859_1toUTF32),
    (name: 'CP819';     table: @i8859_1toUTF32),
    (name: 'IBM819';    table: @i8859_1toUTF32),
    (name: 'ISO-8859-2';table: @i8859_2toUTF32),
    (name: 'ISO_8859-2';table: @i8859_2toUTF32),
    (name: 'latin2';    table: @i8859_2toUTF32),
    (name: 'ISO-8859-5';table: @i8859_5toUTF32),
    (name: 'ISO_8859-5';table: @i8859_5toUTF32),
    (name: 'ISO-8859-16';table: @i8859_16toUTF32),
    (name: 'ISO_8859-16';table: @i8859_16toUTF32),
    (name: 'latin10';   table: @i8859_16toUTF32),
    (name: 'windows-1252';table: @cp1252toUTF32),
    (name: 'IBM437';table: @cp437toUTF32),
    (name: 'cp437';table: @cp437toUTF32),
    (name: 'IBM850';table: @cp850toUTF32),
    (name: 'cp850';table: @cp850toUTF32),
    (name: 'macintosh';table: @RomantoUTF32),
    (name: 'MacRoman';table: @RomantoUTF32),
    (name: 'atari';table: @AtariSTtoUTF32),
    (name: 'ASCII';table: @ASCIItoUTF32),
    (name: 'US-ASCII';table: @ASCIItoUTF32),
    (name: 'IBM367';table: @ASCIItoUTF32),
    (name: 'cp367';table: @ASCIItoUTF32),
    (name: 'ISO646-US';table: @ASCIItoUTF32)
  );  

const
  {* Some fundamental constants *}
  UNI_REPLACEMENT_CHAR = $0000FFFD;
  UNI_MAX_BMP          = $0000FFFF;
  UNI_MAX_UTF16        = $0010FFFF;
  UNI_MAX_UTF32        = $7FFFFFFF;
  
  

   const 
    halfShift  = 10; {* used for shifting by 10 bits *}

    halfBase = $0010000;
    halfMask = $3FF;

    UNI_SUR_HIGH_START = $D800;
    UNI_SUR_HIGH_END   = $DBFF;
    UNI_SUR_LOW_START  = $DC00;
    UNI_SUR_LOW_END    = $DFFF;
    
    

    trailingBytesForUTF8:array[0..255] of byte = (
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
      1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1, 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,
      2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2, 3,3,3,3,3,3,3,3,4,4,4,4,5,5,5,5
    );
    
    offsetsFromUTF8: array[0..5] of utf32 = ( 
           $00000000, $00003080, $000E2080, 
           $03C82080, $FA082080, $82082080
           );
    


{*
 * Once the bits are split out into bytes of UTF-8, this is a mask OR-ed
 * into the first byte, depending on how many bytes follow.  There are
 * as many entries in this table as there are UTF-8 sequence types.
 * (I.e., one byte sequence, two byte... six byte sequence.)
 *}
 const firstByteMark: array[0..6] of utf8 = 
 (
   #$00, #$00, #$C0, #$E0, #$F0, #$F8, #$FC
 );  
   

  function convertUTF32toUTF8(s: array of utf32; var outstr: utf8string): integer;
  var
   i: integer;
   ch: utf32;
   bytesToWrite: integer;
   OutStringLength : byte;
   OutIndex : integer;
   Currentindex: integer;
  const
    byteMask: utf32 = $BF;
    byteMark: utf32 = $80;
  begin
    ConvertUTF32ToUTF8:=UNICODE_ERR_OK;
    OutIndex := 1;
    bytestoWrite:=0; 
    OutStringLength := 0;
    SetLengthUTF8(outstr,0);
    for i:=1 to lengthUTF32(s) do
     begin
       ch:=s[i];    
       
     if (ch > UNI_MAX_UTF16) then
     begin
       convertUTF32ToUTF8:= UNICODE_ERR_SOURCEILLEGAL;
       exit;
     end;
     
     
     if ((ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END)) then
     begin
       convertUTF32ToUTF8:= UNICODE_ERR_SOURCEILLEGAL;
       exit;
     end;
    
    if (ch < utf32($80)) then
      bytesToWrite:=1
    else
    if (ch < utf32($800)) then
      bytesToWrite:=2
    else
    if (ch < utf32($10000)) then
      bytesToWrite:=3
    else
    if (ch < utf32($200000)) then
      bytesToWrite:=4
    else
      begin
        ch:=UNI_REPLACEMENT_CHAR;
        bytesToWrite:=2;
      end;
    Inc(outindex,BytesToWrite);  
    if Outindex > High(utf8string) then
      begin
        convertUTF32ToUTF8:=UNICODE_ERR_LENGTH_EXCEED;
        exit;
      end;
      
      CurrentIndex := BytesToWrite;
      if CurrentIndex = 4 then
      begin
        dec(OutIndex);
        outstr[outindex] := utf8((ch or byteMark) and ByteMask);
        ch:=ch shr 6;
        dec(CurrentIndex);
      end;
      if CurrentIndex = 3 then
      begin
        dec(OutIndex);
        outstr[outindex] := utf8((ch or byteMark) and ByteMask);
        ch:=ch shr 6;
        dec(CurrentIndex);
      end;
      if CurrentIndex = 2 then
      begin
        dec(OutIndex);
        outstr[outindex] := utf8((ch or byteMark) and ByteMask);
        ch:=ch shr 6;
        dec(CurrentIndex);
      end;
      if CurrentIndex = 1 then
      begin
        dec(OutIndex);
        outstr[outindex] := utf8((byte(ch) or byte(FirstbyteMark[BytesToWrite])));
      end;  
      inc(OutStringLength);
      Inc(OutIndex,BytesToWrite);
    end;      
    setlengthutf8(outstr,OutStringLength);
  end;
  
  function lengthUTF16(s: array of utf16): integer;
  begin
   LengthUTF16:=integer(s[0]);
  end;

  function lengthutf8(s: array of utf8): integer;
  begin
   LengthUTF8:=integer(s[0]);
  end;
  
  function lengthutf32(s: array of utf32): integer;
  begin
   LengthUTF32:=integer(s[0]);
  end;
  
  

  procedure setlengthutf8(var s: array of utf8; l: integer);
  begin
    s[0]:=utf8(l);
  end;

  procedure setlengthutf16(var s: array of utf16; l: integer);
  begin
   s[0]:=utf16(l);
  end;
  
  procedure setlengthutf32(var s: array of utf32; l: integer);
  begin
   s[0]:=utf32(l);
  end;
  

  function isLegalUTF8(src: array of utf8; _length: integer): boolean;
  begin
    isLegalUTF8:=true;
  end;


  
  function ConvertFromUTF32(source: utf32string; var dest: shortstring; desttype: string): integer;
  var
   i: integer;
   j: char;
   p: pchararray;
   found: boolean;
  begin
    dest:='';
    ConvertFromUTF32:=UNICODE_ERR_OK;  
    p:=nil;
    for i:=1 to MAX_ALIAS do
      begin
        if aliaslist[i].name = desttype then
          begin
            p:=aliaslist[i].table;
          end;
      end;
    if not assigned(p) then
      begin
        ConvertFromUTF32:=UNICODE_ERR_NOTFOUND;  
        exit;
      end;
    { for each character in the UTF32 string ... }  
    for i:=1 to lengthutf32(source) do
      begin
        found:=false;
        { search the table by reverse lookup }
        for j:=#0 to high(char) do 
          begin     
            if utf32(source[i]) = utf32(p^[j]) then
              begin
                dest:=dest+j;
                found:=true;
                break;
              end;
          end;
        if not found then
          begin
            ConvertFromUTF32:=UNICODE_ERR_INCOMPLETE_CONVERSION;
          end;
      end;
    setlength(dest,lengthutf32(source));  
  end;
  
  function ConvertToUTF32(source: shortstring; var dest: utf32string; srctype: string): integer;
  var
   i: integer;
   l: longint;
   p: pchararray;
  begin
    ConvertToUTF32:=UNICODE_ERR_OK;  
    p:=nil;
    { Search the alias type }
    for i:=1 to MAX_ALIAS do
      begin
        if aliaslist[i].name = srctype then
          begin
            p:=aliaslist[i].table;
          end;
      end;
    if not assigned(p) then
      begin
        ConvertToUTF32:=UNICODE_ERR_NOTFOUND;  
        exit;
      end;
    for i:=1 to length(source) do
      begin
        l:=p^[source[i]];
        if l = -1 then
          begin
            ConvertToUTF32:=UNICODE_ERR_INCOMPLETE_CONVERSION;
            continue;
          end;
        dest[i]:=utf32(l);  
      end;
    setlengthUtf32(dest,length(source));  
  end;
  

  function ConvertUTF16ToUTF32(src: array of utf16; var dst: utf32string): integer;
   var
     ch,ch2: utf32;
     i: integer;
     Outindex: integer;
  begin
    i:=1;
    Outindex := 1;
    ConvertUTF16ToUTF32:=UNICODE_ERR_OK;
    while i <= lengthutf16(src) do
      begin
        ch:=utf32(src[i]);
        inc(i);
        if (ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_HIGH_END) and (i < lengthutf16(src)) then
          begin
              ch2:=src[i];
              if (ch2 >= UNI_SUR_LOW_START) and (ch2 <= UNI_SUR_LOW_END) then
                begin
                  ch := ((ch - UNI_SUR_HIGH_START) shl halfShift)
                          + (ch2 - UNI_SUR_LOW_START) + halfBase;
                end
             else
                begin
                  ConvertUTF16ToUTF32 := UNICODE_ERR_SOURCEILLEGAL;
                  exit;
                end;
          end
        else
        if (ch >= UNI_SUR_LOW_START) and (ch <= UNI_SUR_LOW_END) then
          begin
            ConvertUTF16ToUTF32 := UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end;
        dst[OutIndex] := ch;
        Inc(OutIndex);
     end;     
  setlengthutf32(dst,OutIndex-1);
end;     

function ConvertUTF8ToUTF32(src: array of utf8; var dst: utf32string): integer;
  var
   ch: utf32;
   i: integer;
   StringLength: integer;
   Outindex: integer;
   ExtraBytesToRead: integer;
   CurrentIndex: integer;
  begin
    i:=1;
    stringlength := 0;
    OutIndex := 1;
    ConvertUTF8ToUTF32:=UNICODE_ERR_OK;
    while i <= lengthutf8(src) do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(utf32string) then
          begin
            ConvertUTF8ToUTF32:=UNICODE_ERR_LENGTH_EXCEED;
            exit;
          end;
        if not isLegalUTF8(src, extraBytesToRead+1) then
          begin
            ConvertUTF8ToUTF32:=UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end;
        CurrentIndex := ExtraBytesToRead;
        if CurrentIndex = 3 then
        begin
          ch:=ch + utf32(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          ch:=ch + utf32(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          ch:=ch + utf32(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 0 then
        begin
          ch:=ch + utf32(src[i]);
          inc(i);
        end;
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        if (ch <= UNI_MAX_UTF32) then
          begin
            dst[OutIndex] := ch;
            inc(OutIndex);
          end
        else
          begin
            dst[OutIndex] := UNI_REPLACEMENT_CHAR;
            inc(OutIndex);
          end;
      end;
     setlengthutf32(dst, outindex-1);
  end;
  

function ConvertUTF32toUTF16(src: array of utf32; var dest: utf16string): integer;
var
 ch: utf32;
   i: integer;
   Outindex: integer;
begin
    i:=1;
    OutIndex := 1;
    ConvertUTF32ToUTF16:=UNICODE_ERR_OK;
    while i <= lengthutf32(src) do
      begin
        ch:=src[i];
        inc(i);
        {* Target is a character <= 0xFFFF *}
        if (ch <= UNI_MAX_BMP) then
          begin
            if (ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END) then
              begin
                ConvertUTF32ToUTF16:=UNICODE_ERR_SOURCEILLEGAL;
                exit;
              end
            else
              begin
                dest[OutIndex] := utf16(ch);
                inc(OutIndex);
              end;
          end
        else 
        if (ch > UNI_MAX_UTF16) then
          begin
            ConvertUTF32ToUTF16:=UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end
        else
          begin
            if OutIndex + 1> High(utf16string) then
              begin
                ConvertUTF32ToUTF16:=UNICODE_ERR_LENGTH_EXCEED;
                exit;
              end;
            ch := ch - Halfbase;
            dest[OutIndex] := (ch shr halfShift) + UNI_SUR_HIGH_START;
            inc(OutIndex);
            dest[OutIndex] := (ch and halfMask) + UNI_SUR_LOW_START;
            inc(OutIndex);
          end;
      end;
    setlengthutf16(dest, OutIndex);  
end;


function ConvertUTF32ToUCS2(src: array of utf32; var dst: ucs2string): integer;
var
 ch: utf32;
 i: integer;
begin
  ConvertUTF32ToUCS2:=UNICODE_ERR_OK;
  for i:=1 to lengthutf32(src) do
    begin
      ch:=src[i];
      if ch > UNI_MAX_BMP then
        begin 
          ConvertUTF32ToUCS2:=UNICODE_ERR_INCOMPLETE_CONVERSION;
          continue;
        end;
      dst[i]:=ucs2(ch and UNI_MAX_BMP);
{$ifdef endian_little}
      { convert to big endian order }
      swapword(dst[i]);
{$endif}
    end;
  dst[0]:=ucs2(lengthutf32(src));  
end;

     
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2004/05/06 15:27:05  carl
     + add support for ISO8859, ASCII, CP850, CP1252 to UTF-32 conversion
       (and vice-versa)
     + add support for UTF-32 to UCS-2 conversion
     * bugfixes in conversion routines for UTF-32
     + updated documentation

  Revision 1.1  2004/05/05 16:28:22  carl
    Release 0.95 updates


}
  
  

