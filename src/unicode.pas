{
 ****************************************************************************
    $Id: unicode.pas,v 1.8 2004-07-05 02:38:15 carl Exp $
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

    All UNICODE/ISO 10646 strings are limited to
    255 characters.

    Since all these encoding are variable length,
    except the UTF-32 (which is equivalent to UCS-4 according to 
    ISO 10646:2003) and UCS-2 encoding, to parse through characters, 
    every string should be converted to UTF-32 or UCS-2 before being used.
 
}
{$T-}
{$X+}
unit unicode;

interface

uses 
  tpautils,
  vpautils,
  dpautils,
  gpautils,
  fpautils,
  utils;


type
  {** UTF-8 base data type }
  utf8 = char;
  {** UTF-16 base data type }
  utf16 = word;
  {** UTF-32 base data type }
  utf32 = longword;
  {** UTF-32 string null terminated string }
  putf32char = ^utf32;
  {** UCS-2 base data type }
  ucs2char = word;
  
  {** UCS-2 string declaration. Index 0 contains the active length
      of the string in characters.
  }
  ucs2string = array[0..255] of ucs2char;
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
   {** Maximum size of a null-terminated UTF-32 character string }
   MAX_UTF32_CHARS = high(smallint) div (sizeof(utf32));

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

  {** Byte order mark: UTF-8 encoding signature }
  BOM_UTF8     = #$EF#$BB#$BF;
  {** Byte order mark: UTF-32 big endian encoding signature }
  BOM_UTF32_BE = #00#00#$FE#$FF;
  {** Byte order mark: UTF-32 little endian encoding signature }
  BOM_UTF32_LE = #$FF#$FE#00#00;
  
  BOM_UTF16_BE = #$FE#$FF;
  BOM_UTF16_LE = #$FF#$FE;
  
    


{---------------------------------------------------------------------------
                          UTF-32 string handling
-----------------------------------------------------------------------------}

  {** @abstract(Returns the current length of an UTF-32 string) }
  function utf32_length(s: array of utf32): integer;

  {** @abstract(Set the new dynamic length of an utf-32 string) }
  procedure utf32_setlength(var s: array of utf32; l: integer);

  {** @abstract(Determines if the specified character is a whitespace character) }
  function utf32_iswhitespace(c: utf32): boolean;

  {** @abstract(Trims leading spaces and control characters from an UTF-32 string.) }
  procedure utf32_trimleft(var s: utf32string);
  
  {** @abstract(Trims trailing spaces and control characters from an UTF-32 string.) }
  procedure utf32_trimright(var s: utf32string);

  {** @abstract(Returns an utf-32 substring of an utf-32 string) }
  procedure utf32_copy(var resultstr: utf32string; s: array of utf32; index: integer; count: integer);

  {** @abstract(Deletes a substring from a string) }
  procedure utf32_delete(var s: utf32string; index: integer; count: integer);

  {** @abstract(Concatenates two UTF-32 strings, and gives a resulting UTF-32 string) }
  procedure utf32_concat(var resultstr: utf32string;s1: utf32string; s2: array of utf32);

  {** @abstract(Concatenates an UTF-32 string with an ASCII string, and gives
      a resulting UTF-32 string)
  }    
  procedure utf32_concatascii(var resultstr: utf32string;s1: utf32string; s2: shortstring);

  {** @abstract(Searches for an ASCII substring in an UTF-32 string) }
  function utf32_posascii(substr: shortstring; s: utf32string): integer;

  {** @abstract(Checks if an ASCII string is equal to an UTF-32 string ) }
  function utf32_equalascii(s1 : array of utf32; s2: shortstring): boolean;

  {** @abstract(Searches for an UTF-32 substring in an UTF-32 string) }
  function utf32_pos(substr: utf32string;s : utf32string): integer;

  {** @abstract(Checks if both UTF-32 strings are equal) }
  function utf32_equal(const s1,s2: utf32string): boolean;

  {** @abstract(Checks if the UTF-32 character is valid)

      This routine verifies if the UTF-32 character is
      within the valid ranges of UTF-32 characters, as
      specified in the Unicode standard 4.0. BOM characters
      are NOT valid with this routine.
  }
  function utf32_isvalid(c: utf32): boolean;

  {** @abstract(Checks if conversion from/to this character set format to/from UTF-32
      is supported)

      @param(s This is an alias for a character set, as defined by IANA)
      @returns(true if conversion to/from UTF-32 is supported with this
        character set, otherwise FALSE)
  }
  function utf32_issupported(s: string): boolean;

{---------------------------------------------------------------------------
                  UTF-32 null terminated string handling
-----------------------------------------------------------------------------}



  {** @abstract(Returns the number of characters in the null terminated UTF-32 string)

      @param(str The UTF-32 null terminated string to check)
      @returns(The number of characters in str, not counting the null
        character)
  }
  function utf32strlen(str: putf32char): integer;

  {** @abstract(Converts a null-terminated UTF-32 string to a Pascal-style UTF-32 string.)
  }
 procedure utf32strpas(Str: putf32char; var res:utf32string);
 
  {** @abstract(Converts a null-terminated UTF-32 string to a Pascal-style 
       ISO 8859-1 encoded string.)
  }
 function utf32strpasToISO8859_1(Str: putf32char): string;
 

  {** @abstract(Copies a Pascal-style UTF-32 string to a null-terminated UTF-32 string.)

      UTF32StrPCopy does not perform any length checking.

      The destination buffer must have room for at least Length(Source)+1 characters.
  }
 Function utf32strpcopy(Dest: Putf32char; Source: UTF32String):PUTF32Char;

  {** @abstract(Copies a Pascal-style string to a null-terminated UTF-32 string.)

      UTF32StrPCopyASCII does not perform any length checking.

      The destination buffer must have room for at least Length(Source)+1 characters.
  }
 Function utf32strpcopyascii(Dest: Putf32char; Source: string):PUTF32Char;

{---------------------------------------------------------------------------
                           UCS-2 string handling
-----------------------------------------------------------------------------}

  {** @abstract(Returns the current length of an UCS-2 string) }
  function ucs2_length(s: array of ucs2char): integer;
  
  {** @abstract(Set the new dynamic length of an ucs-2 string) }
  procedure ucs2_setlength(var s: array of ucs2char; l: integer);
  
{---------------------------------------------------------------------------
                  UTF-8 null terminated string handling
-----------------------------------------------------------------------------}

  {** @abstract(Converts an UTF-32 null terminated string to an UTF-8 null 
   terminated string) 
   
   The memory for the buffer is allocated. Use strlen to dispose of the
   allocated string. The string is null terminated.
  }
  function utf8strnew(src: putf32char): pchar;
  
  
  
  

{---------------------------------------------------------------------------
                          Other  string handling
-----------------------------------------------------------------------------}
  {** @abstract(Returns the number of characters that are used to encode this
      character).

      Actually checks if this is a high-surrogate value, if not returns 1,
      indicating that the character is encoded a single @code(utf16) character,
      otherwise returns 2, indicating that 1 one other @code(utf16) character
      is required to encode this data.
  }
  function utf16_sizeencoding(c: utf16): integer;

  {** @abstract(Returns the number of characters that are used to encode this
      character).
      
  }      
  function utf8_sizeencoding(c: utf8): integer;
  
  {** @abstract(Returns the current length of an UTF-16 string) }
  function lengthUTF16(s: array of utf16): integer;

  {** @abstract(Returns the current length of an UTF-8 string) }
  function lengthutf8(s: array of utf8): integer;

  
  {** @abstract(Set the length of an UTF-8 string) }
  procedure setlengthUTF8(var s: array of utf8; l: integer);

  {** @abstract(Set the length of an UTF-16 string) }
  procedure setlengthUTF16(var s: array of utf16; l: integer);


{---------------------------------------------------------------------------
                      Unicode Conversion routines
-----------------------------------------------------------------------------}
  

  {** @abstract(Convert an UTF-32 string to an UTF-8 string) 
  
      Converts an UTF-32 string or character
      in native endian to an UTF-8 string. 
      
      @param(s Either a single utf-32 character or a complete utf-32 string)
      @param(outstr Resulting UTF-8 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
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
  function ConvertUTF16ToUTF32(src: utf16string; var dst: utf32string): integer;

  {** @abstract(Convert an UTF-32 string to an UTF-16 string)
  
      This routine converts an UTF-32 string to an UTF-16 string.
      Both strings must be stored in native byte order (native endian).

      @param(src Either a single utf-32 character or a complete utf-32 string)
      @param(dest Resulting UTF-16 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF32toUTF16(src: array of utf32; var dest: utf16string): integer;
  
  {** @abstract(Convert an UTF-8 string to an UTF-32 string)

      This routine converts an UTF-8 string to an UTF-32 string that
      is stored in native byte order.

      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF8ToUTF32(src: utf8string; var dst: utf32string): integer;

  {** @abstract(Convert an UTF-32 string to an UCS-2 string)
  
      This routine converts an UTF-32 string to an UCS-2 string that
      is stored in native byte order. If some characters
      could not be converted an error will be reported.
      
      @param(src Either a single utf-32 character or a complete utf-32 string)
      @param(dest Resulting UCS-2 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  
  }
  function ConvertUTF32ToUCS2(src: array of utf32; var dst: ucs2string): integer;


  {** @abstract(Convert an UCS-2 string to an UTF-32 string)

      This routine converts an UCS-2 string to an UTF-32 string that
      is stored in native byte order (big-endian). If some characters
      could not be converted an error will be reported.

      @param(src Either a single ucs-2 character or a complete ucs-2 string)
      @param(dest Resulting UTF-32 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)

  }
  function ConvertUCS2ToUTF32(src: array of ucs2char; var dst: utf32string): integer;


implementation


type
  utf32strarray = array[0..MAX_UTF32_CHARS] of utf32;
  pstrarray = ^utf32strarray;

  pchararray = ^tchararray;
  tchararray = array[#0..#255] of longint;
  taliasinfo = record
    aliasname: string[32];
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

const
  aliaslist: array[1..MAX_ALIAS] of taliasinfo =
  (
    (aliasname: 'ISO-8859-1';table: @i8859_1toUTF32),
    (aliasname: 'ISO_8859-1';table: @i8859_1toUTF32),
    (aliasname: 'latin1';    table: @i8859_1toUTF32),
    (aliasname: 'CP819';     table: @i8859_1toUTF32),
    (aliasname: 'IBM819';    table: @i8859_1toUTF32),
    (aliasname: 'ISO-8859-2';table: @i8859_2toUTF32),
    (aliasname: 'ISO_8859-2';table: @i8859_2toUTF32),
    (aliasname: 'latin2';    table: @i8859_2toUTF32),
    (aliasname: 'ISO-8859-5';table: @i8859_5toUTF32),
    (aliasname: 'ISO_8859-5';table: @i8859_5toUTF32),
    (aliasname: 'ISO-8859-16';table: @i8859_16toUTF32),
    (aliasname: 'ISO_8859-16';table: @i8859_16toUTF32),
    (aliasname: 'latin10';   table: @i8859_16toUTF32),
    (aliasname: 'windows-1252';table: @cp1252toUTF32),
    (aliasname: 'IBM437';table: @cp437toUTF32),
    (aliasname: 'cp437';table: @cp437toUTF32),
    (aliasname: 'IBM850';table: @cp850toUTF32),
    (aliasname: 'cp850';table: @cp850toUTF32),
    (aliasname: 'macintosh';table: @RomantoUTF32),
    (aliasname: 'MacRoman';table: @RomantoUTF32),
    (aliasname: 'atari';table: @AtariSTtoUTF32),
    (aliasname: 'ASCII';table: @ASCIItoUTF32),
    (aliasname: 'US-ASCII';table: @ASCIItoUTF32),
    (aliasname: 'IBM367';table: @ASCIItoUTF32),
    (aliasname: 'cp367';table: @ASCIItoUTF32),
    (aliasname: 'ISO646-US';table: @ASCIItoUTF32)
  );

const
  {* Some fundamental constants *}
  UNI_REPLACEMENT_CHAR = $0000FFFD;
  UNI_MAX_BMP          = $0000FFFF;
  UNI_MAX_UTF16        = $0010FFFF;
  UNI_MAX_UTF32        = $7FFFFFFF;
  
  { Surrogate marks for UTF-16 encoding }
  UNI_SUR_HIGH_START = $D800;
  UNI_SUR_HIGH_END   = $DBFF;
  UNI_SUR_LOW_START  = $DC00;
  UNI_SUR_LOW_END    = $DFFF;
  

    halfShift  = 10; {* used for shifting by 10 bits *}

    halfBase = $0010000;
    halfMask = $3FF;

    
    

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
 
  const
    byteMask: utf32 = $BF;
    byteMark: utf32 = $80;
 
   

  function convertUTF32toUTF8(s: array of utf32; var outstr: utf8string): integer;
  var
   i: integer;
   ch: utf32;
   bytesToWrite: integer;
   OutStringLength : byte;
   OutIndex : integer;
   Currentindex: integer;
   StartIndex: integer;
   EndIndex: integer;
  begin
    ConvertUTF32ToUTF8:=UNICODE_ERR_OK;
    OutIndex := 1;
    bytestoWrite:=0; 
    OutStringLength := 0;
    SetLengthUTF8(outstr,0);
    { Check if only one character is passed as src, in that case
      this is not an UTF string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(s) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UTF32_Length(s);
      end;
      
    for i:=StartIndex to EndIndex do
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
  

  

  procedure setlengthutf8(var s: array of utf8; l: integer);
  begin
    s[0]:=utf8(l);
  end;

  procedure setlengthutf16(var s: array of utf16; l: integer);
  begin
   s[0]:=utf16(l);
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
        if aliaslist[i].aliasname = desttype then
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
    for i:=1 to utf32_length(source) do
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
    setlength(dest,utf32_length(source));
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
        if aliaslist[i].aliasname = srctype then
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
    Utf32_setlength(dest,length(source));
  end;


  function ConvertUTF16ToUTF32(src: utf16string; var dst: utf32string): integer;
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
  utf32_setlength(dst,OutIndex-1);
end;

function ConvertUTF8ToUTF32(src: utf8string; var dst: utf32string): integer;
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
     utf32_setlength(dst, outindex-1);
  end;
  

function ConvertUTF32toUTF16(src: array of utf32; var dest: utf16string): integer;
var
 ch: utf32;
   i: integer;
   Outindex: integer;
   StartIndex, EndIndex: integer;
begin
    OutIndex := 1;
    ConvertUTF32ToUTF16:=UNICODE_ERR_OK;
    { Check if only one character is passed as src, in that case
      this is not an UTF string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(src) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UTF32_Length(src);
      end;
    
    i:=Startindex;
    while i <= EndIndex do
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
   StartIndex, EndIndex: integer;
  begin
    ConvertUTF32ToUCS2:=UNICODE_ERR_OK;
  
    { Check if only one character is passed as src, in that case
      this is not an UTF string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(src) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
        dst[0]:=ucs2char(1);
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UTF32_Length(src);
        dst[0]:=ucs2char(utf32_length(src));
      end;
  
    for i:=StartIndex to EndIndex do
      begin
        ch:=src[i];
        if ch > UNI_MAX_BMP then
          begin 
            ConvertUTF32ToUCS2:=UNICODE_ERR_INCOMPLETE_CONVERSION;
            continue;
          end;
        dst[i]:=ucs2char(ch and UNI_MAX_BMP);
      end;
  end;
  
  
  function ConvertUCS2ToUTF32(src: array of ucs2char; var dst: utf32string): integer;
  var
   ch: utf32;
   i: integer;
   StartIndex, EndIndex: integer;
  begin
    ConvertUCS2ToUTF32:=UNICODE_ERR_OK;
  
    { Check if only one character is passed as src, in that case
      this is not an UCS string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(src) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
        dst[0]:=utf32(1);
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UCS2_Length(src);
       utf32_setlength(dst,ucs2_length(src));
      end;
    for i:=StartIndex to EndIndex do
      begin
        ch:=src[i];
        if ((ch >=  UNI_SUR_HIGH_START) and (ch <= UNI_SUR_HIGH_END)) or
           ((ch >=  UNI_SUR_LOW_START) and (ch <= UNI_SUR_LOW_END)) then
          begin 
            ConvertUCS2ToUTF32:=UNICODE_ERR_SOURCEILLEGAL;
            continue;
          end;
        dst[i]:=utf32(ch);
      end;
  end;


{---------------------------------------------------------------------------
                          UTF-32 string handling
-----------------------------------------------------------------------------}

  function utf32_iswhitespace(c: utf32): boolean;
  begin
   if (c = $20) or (c = $09) or (c = $10) or (c = $13) or (c = $85) or (c = $2028) 
   then
      utf32_iswhitespace:=true
   else   
      utf32_iswhitespace:=false;
  end;
  
  procedure utf32_copy(var resultstr: utf32string; s: array of utf32; index: integer; count: integer);
  var
   slen: integer;
   i: integer;
  begin
    utf32_setlength(resultstr,0);
    if count = 0 then
      exit;
    slen:=utf32_length(s);
    if index > slen then
      exit;
    if (count+index)>slen then
      count:=slen-index+1;
    { don't forget the length character }
    if count <> 0 then
      begin
        for i:=1 to count do
          begin
            resultstr[i]:=s[i+index-1];
          end;
      end;
    resultstr[0]:=utf32(count);
  end;
  
  procedure utf32_delete(var s: utf32string; index: integer; count: integer);
  begin
    if index<=0 then
      exit;
    if (Index<=Utf32_Length(s)) and (Count>0) then
     begin
       if Count>Utf32_length(s)-Index then
        Count:=Utf32_length(s)-Index+1;
       s[0]:=(Utf32_length(s)-Count);
       if Index<=utf32_Length(s) then
        Move(s[Index+Count],s[Index],(Utf32_Length(s)-Index+1)*sizeof(utf32));
     end;
  end;
  

  procedure utf32_concat(var resultstr: utf32string;s1: utf32string; s2: array of utf32);
  var
    s1l, s2l : integer;
    idx: integer;
  begin
    { if only one character must be moved }
    if high(s2) = 0 then
      begin
        s2l:=1;
        idx:=0;
      end
    else
      begin
        s2l:=utf32_length(s2);
        idx:=1;
      end;
    s1l:=utf32_length(s1);
    if s2l+s1l>255 then
      s2l:=255-s1l;
    move(s2[idx],s1[utf32_length(s1)+1],s2l*sizeof(utf32));
    move(s1[1],resultstr[1],(s2l+s1l)*sizeof(utf32));
    utf32_setlength(resultstr, s2l+s1l);
  end;
  
  function utf32_pos(substr: utf32string; s: utf32string): integer;
  var
    i,j : integer;
    e   : boolean;
    Substr2: utf32string;
  begin
    i := 0;
    j := 0;
    e:=(utf32_length(SubStr)>0);
    while e and (i<=utf32_Length(s)-utf32_Length(SubStr)) do
     begin
       inc(i);
       utf32_Copy(Substr2,s,i,utf32_Length(Substr));
       if (SubStr[1]=s[i]) and (utf32_equal(Substr,Substr2)) then
        begin
          j:=i;
          e:=false;
        end;
     end;
    utf32_Pos:=j;
  end;
  
  function utf32_equal(const s1,s2: utf32string): boolean;
    var
     i: integer;
  begin
    utf32_equal:=false;
    if utf32_length(s1) <> utf32_length(s2) then
      exit;
    for i:=1 to utf32_length(s1) do
      begin
        if s1[i] <> s2[i] then
          exit;
      end;
    utf32_equal:=true;
  end;
  

  function utf32_length(s: array of utf32): integer;
  begin
   utf32_length:=integer(s[0]);
  end;
  
  procedure utf32_setlength(var s: array of utf32; l: integer);
  begin
   if l > 255 then
     l:=255;
   s[0]:=utf32(l);
  end;

  procedure utf32_concatascii(var resultstr: utf32string;s1: utf32string; s2: shortstring);
  var
   utfstr: utf32string;
  begin
    if ConvertToUTF32(s2,utfstr,'ASCII')  = UNICODE_ERR_OK then
       utf32_concat(resultstr,s1,utfstr);
  end;

  function utf32_posascii(substr: shortstring; s: utf32string): integer;
  var
   utfstr: utf32string;
  begin
    utf32_posascii:=0;
    if ConvertToUTF32(substr,utfstr,'ASCII')  = UNICODE_ERR_OK then
     utf32_posascii:=utf32_pos(utfstr,s);
  end;

  function utf32_equalascii(s1 : array of utf32; s2: shortstring): boolean;
  var
   utfstr: utf32string;
   s3: utf32string;
   i: integer;
  begin
    utf32_equalascii:=false;
    for i:=1 to utf32_length(s1) do
      begin
        s3[i] := s1[i];
      end;
    utf32_setlength(s3,utf32_length(s1));
    if ConvertToUTF32(s2,utfstr,'ASCII')  = UNICODE_ERR_OK then
     utf32_equalascii:=utf32_equal(utfstr,s3);
  end;

  function utf32_issupported(s: string): boolean;
  var
   i: integer;
  begin
    s:=upstring(s);
    utf32_issupported := true;
    if (s = 'UTF-16') or (s = 'UTF-16BE') or (s = 'UTF-16LE') or
       (s = 'UTF-32') or (s = 'UTF-32BE') or (s = 'UTF-32LE') or
       (s = 'UTF-8') then
     begin
        utf32_issupported := true;
        exit;
     end;
    for i:=1 to MAX_ALIAS do
    begin
      if upstring(aliaslist[i].aliasname) = s then
      begin
         utf32_issupported := true;
         exit;
      end;
    end;
  end;
  
  function utf32_isvalid(c: utf32): boolean;
  begin
    utf32_isvalid := false;
    { maximum unicode range }
    if (c > UNI_MAX_UTF16) then
       exit;
    { surrogates are not allowed in this encoding }
    if (c >= UNI_SUR_HIGH_START) and (c <= UNI_SUR_HIGH_END) then
      exit;
    if (c >= UNI_SUR_LOW_START) and (c <= UNI_SUR_LOW_END) then
      exit;
    { check for non-characters, which are not allowed in 
      interchange data
    }  
    if (c and $FFFF) = $FFFE then exit;
    if (c and $FFFF) = $FFFF then exit;
    utf32_isvalid := true;
  end;



  procedure UTF32_TrimLeft(var S: utf32string);
  var i,l:integer;
      outstr: utf32string;
  begin
    utf32_setlength(outstr,0);
    l := utf32_length(s);
    i := 1;
    while (i<=l) and (utf32_iswhitespace(s[i])) do
     inc(i);
    utf32_copy(outstr,s, i, l);
    move(outstr,s,sizeof(utf32string));
  end ;


  procedure UTF32_TrimRight(var S: utf32string);
  var l:integer;
      outstr: utf32string;
  begin
    utf32_setlength(outstr,0);
    l := utf32_length(s);
    while (l>0) and (utf32_iswhitespace(s[l])) do
     dec(l);
    utf32_copy(outstr,s,1,l);
    move(outstr,s,sizeof(utf32string));
  end ;


  function utf16_sizeencoding(c: utf16): integer;
  begin
    utf16_sizeencoding:=2;
    if (c >= UNI_SUR_HIGH_START) and (c <= UNI_SUR_HIGH_END) then
      utf16_sizeencoding:=4;
  end;
  
  function utf8_sizeencoding(c: utf8): integer;
  begin
    utf8_sizeencoding:= trailingBytesForUTF8[ord(c)]+1;
  end;
  
  
  function ucs2_length(s: array of ucs2char): integer;
  begin
   ucs2_length:=integer(s[0]);
  end;
  
  procedure ucs2_setlength(var s: array of ucs2char; l: integer);
  begin
   if l > 255 then
     l:=255;
   s[0]:=ucs2char(l);
  end;

  function utf32strlen(str: putf32char): integer;
  var
   counter : Longint;
   stringarray: pstrarray;
 Begin
   utf32strlen:=0;
   if not assigned(str) then
     exit;
   stringarray := pointer(str);
   counter := 0;
   while stringarray^[counter] <> 0 do
     Inc(counter);
   utf32strlen := counter;
 end;
 
 function utf32strpasToISO8859_1(Str: putf32char): string;
  var
   counter : byte;
   lstr: string;
   stringarray: pstrarray;
 Begin
   counter := 0;
   utf32strpasToISO8859_1:='';
   if not assigned(str) then exit;
   stringarray := pointer(str);
   setlength(lstr,0);
   while ((stringarray^[counter]) <> 0) and (counter < high(utf32string)) do
   begin
     Inc(counter);
     lstr := lstr + chr(Stringarray^[counter-1]);
   end;
   SetLength(lstr,counter);
   utf32strpasToISO8859_1:= lstr;
 end;
 

 procedure utf32strpas(Str: putf32char; var res:utf32string);
  var
   counter : byte;
   lstr: utf32string;
   stringarray: pstrarray;
 Begin
   counter := 0;
   stringarray := pointer(str);
   utf32_setlength(res,0);
   utf32_setlength(lstr,0);
   if not assigned(str) then exit;
   while ((stringarray^[counter]) <> 0) and (counter < high(utf32string)) do
   begin
     Inc(counter);
     utf32_concat(lstr, lstr, Stringarray^[counter-1]);
   end;
   UTF32_SetLength(lstr,counter);
   res := lstr;
 end;

 Function UTF32StrPCopy(Dest: Putf32char; Source: UTF32String):PUTF32Char;
   var
    counter : byte;
    stringarray: pstrarray;
  Begin
   stringarray:=pointer(Dest);
   UTF32StrPCopy := nil;
   if not assigned(Dest) then
     exit;
   { if empty pascal string  }
   { then setup and exit now }
   if utf32_length(Source) = 0 then
   Begin
     stringarray^[0] := 0;
     UTF32StrPCopy := pointer(StringArray);
     exit;
   end;
   for counter:=1 to utf32_length(Source) do
   begin
     StringArray^[counter-1] := Source[counter];
   end;
   { terminate the string }
   StringArray^[utf32_length(Source)] := 0;
   UTF32StrPCopy:=Dest;
 end;

 Function UTF32StrPCopyASCII(Dest: Putf32char; Source: string):PUTF32Char;
   var
    counter : byte;
    stringarray: pstrarray;
  Begin
   stringarray:=pointer(Dest);
   UTF32StrPCopyASCII := nil;
   if not assigned(Dest) then
     exit;
   { if empty pascal string  }
   { then setup and exit now }
   if length(Source) = 0 then
   Begin
     stringarray^[0] := 0;
     UTF32StrPCopyAscii := pointer(StringArray);
     exit;
   end;
   for counter:=1 to length(Source) do
   begin
     StringArray^[counter-1] := ord(Source[counter]);
   end;
   { terminate the string }
   StringArray^[length(Source)] := 0;
   UTF32StrPCopyASCII:=Dest;
 end;


  function UTF8StrNew(src: putf32char): pchar;
  var
   utf32stringlen: integer;
   p: pchar;
   ch: utf32;
   OutIndex,BytesToWrite,OutStringLength,StartIndex: integer;
   CurrentIndex, EndIndex: integer;
   i: integer;
   instr: pstrarray;
  begin
    utf32stringlen:=utf32strlen(src);
    instr:=pointer(src);
    { allocate at least the space taken up by the
      strlen*4 - because each character can take up to 4 bytes.
    }  
    GetMem(p,utf32stringlen*sizeof(utf32));
    fillchar(p^,utf32stringlen*sizeof(utf32),#0);
    OutIndex := 0;
    bytestoWrite:=0; 
    OutStringLength := 0;
    StartIndex:=0;
    EndIndex:=utf32stringlen-1;
      
    for i:=StartIndex to EndIndex do
     begin
       ch:=instr^[i];    

       if (ch > UNI_MAX_UTF16) then
       begin
         UTF8StrNew := nil;
         FreeMem(p,utf32stringlen*sizeof(utf32));
         exit;
       end;
     
     
       if ((ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END)) then
       begin
         UTF8StrNew := nil;
         FreeMem(p,utf32stringlen*sizeof(utf32));
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
        
        CurrentIndex := BytesToWrite;
        if CurrentIndex = 4 then
        begin
          dec(OutIndex);
          p[outindex] := utf8((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          dec(OutIndex);
          p[outindex] := utf8((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          dec(OutIndex);
          p[outindex] := utf8((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          dec(OutIndex);
          p[outindex] := utf8((byte(ch) or byte(FirstbyteMark[BytesToWrite])));
        end;  
        inc(OutStringLength);
        Inc(OutIndex,BytesToWrite);
      end;      
      ReallocMem(pointer(p),OutStringLength+1);
      p[OutStringLength] := #0;
      UTF8StrNew:=p;
  end;
  
  
  
  

begin

(*
    aliaslist[1].aliasname:= 'ISO-8859-1';
    aliaslist[1].table:= i8859_1toUTF32;
    aliaslist[2].aliasname:= 'latin1';
    aliaslist[2].table:= i8859_1toUTF32;
    aliaslist[3].aliasname:= 'CP819';
    aliaslist[3].table:= i8859_1toUTF32;
    aliaslist[4].aliasname:= 'IBM819';
    aliaslist[4].table:= i8859_1toUTF32;
    aliaslist[5].aliasname:= 'ISO_8859-1';
    aliaslist[5].table:= i8859_1toUTF32;

    aliaslist[6].aliasname:= 'ISO-8859-2';
    aliaslist[6].table:= i8859_2toUTF32;
    aliaslist[7].aliasname:= 'ISO_8859-2';
    aliaslist[7].table:= i8859_2toUTF32;
    aliaslist[9].aliasname:= 'ISO-8859-1';
    aliaslist[9].table:= i8859_1toUTF32;
    aliaslist[10].aliasname:= 'ISO-8859-1';
    aliaslist[10].table:= i8859_1toUTF32;
    aliaslist[11].aliasname:= 'ISO-8859-1';
    aliaslist[11].table:= i8859_1toUTF32;
    

    (aliasname: 'ISO-8859-2';table: @i8859_2toUTF32),
    (aliasname: 'ISO_8859-2';table: @i8859_2toUTF32),
    (aliasname: 'latin2';    table: @i8859_2toUTF32),

    (aliasname: 'ISO-8859-5';table: @i8859_5toUTF32),
    (aliasname: 'ISO_8859-5';table: @i8859_5toUTF32),

    (aliasname: 'ISO-8859-16';table: @i8859_16toUTF32),
    (aliasname: 'ISO_8859-16';table: @i8859_16toUTF32),
    (aliasname: 'latin10';   table: @i8859_16toUTF32),

    (aliasname: 'windows-1252';table: @cp1252toUTF32),

    (aliasname: 'IBM437';table: @cp437toUTF32),
    (aliasname: 'cp437';table: @cp437toUTF32),

    (aliasname: 'IBM850';table: @cp850toUTF32),
    (aliasname: 'cp850';table: @cp850toUTF32),

    (aliasname: 'macintosh';table: @RomantoUTF32),
    (aliasname: 'MacRoman';table: @RomantoUTF32),

    (aliasname: 'atari';table: @AtariSTtoUTF32),

    (aliasname: 'ASCII';table: @ASCIItoUTF32),
    (aliasname: 'US-ASCII';table: @ASCIItoUTF32),
    (aliasname: 'IBM367';table: @ASCIItoUTF32),
    (aliasname: 'cp367';table: @ASCIItoUTF32),
    (aliasname: 'ISO646-US';table: @ASCIItoUTF32)
{$endif}*)
end.

{
  $Log: not supported by cvs2svn $
  Revision 1.7  2004/07/05 02:27:32  carl
    - remove some compiler warnings
    + UTF-32 null character string handling routines
    + UTF-8 null character string handling routines

  Revision 1.6  2004/07/01 22:27:15  carl
    * Added support for Null terminated utf32 character string
    + renamed utf32 to utf32char

  Revision 1.5  2004/06/20 18:49:39  carl
    + added  GPC support

  Revision 1.4  2004/06/17 11:48:13  carl
    + UTF32 complete support
    + add UCS2 support

  Revision 1.3  2004/05/06 15:47:27  carl
    - remove some warnings

  Revision 1.2  2004/05/06 15:27:05  carl
     + add support for ISO8859, ASCII, CP850, CP1252 to UTF-32 conversion
       (and vice-versa)
     + add support for UTF-32 to UCS-2 conversion
     * bugfixes in conversion routines for UTF-32
     + updated documentation

  Revision 1.1  2004/05/05 16:28:22  carl
    Release 0.95 updates


}
  


