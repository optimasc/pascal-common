{
 ****************************************************************************
    $Id: unicode.pas,v 1.14 2004-09-06 19:41:42 carl Exp $
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

    All UNICODE/ISO 10646 pascal styled strings are limited to
    255 characters. Null terminated unicode strings are
    limited by the compiler and integer type size.

    Since all these encoding are variable length,
    except the UCS-4 (which is equivalent to UTF-32 according to 
    ISO 10646:2003) and UCS-2 encoding, to parse through characters, 
    every string should be converted to UCS-4 or UCS-2 before being used.
    
    The principal encoding scheme for this unit is UCS-4.
 
}
{$T-}
{$X+}
{$Q-}
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
  utf8char = char;
  putf8char = pchar;
  {** UTF-16 base data type }
  utf16char = word;
  {** UCS-4 base data type }
  ucs4char = longword;
  {** UCS-4 null terminated string }
  pucs4char = ^ucs4char;
  {** UCS-2 base data type }
  ucs2char = word;
  pucs2char = ^ucs2char;
  
  {** UCS-2 string declaration. Index 0 contains the active length
      of the string in characters.
  }
  ucs2string = array[0..255] of ucs2char;
  {** UCS-4 string declaration. Index 0 contains the active length
      of the string in characters.
  }
  ucs4string = array[0..255] of ucs4char;

  {** UTF-8 string declaration. Index 0 contains the active length
      of the string in BYTES
  }
  utf8string = string;
  {** UTF-16 string declaration. Index 0 contains the active length
      of the string in BYTES
  }
  utf16string = array[0..255] of utf16char;

const
   {** Maximum size of a null-terminated UCS-4 character string }
   MAX_UCS4_CHARS = high(smallint) div (sizeof(ucs4char));
   {** Maximum size of a null-terminated UCS-4 character string }
   MAX_UCS2_CHARS = high(smallint) div (sizeof(ucs2char))-1;

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
  {** Byte order mark: UCS-4 big endian encoding signature }
  BOM_UTF32_BE = #00#00#$FE#$FF;
  {** Byte order mark: UCS-4 little endian encoding signature }
  BOM_UTF32_LE = #$FF#$FE#00#00;
  
  BOM_UTF16_BE = #$FE#$FF;
  BOM_UTF16_LE = #$FF#$FE;

type
  ucs4strarray = array[0..MAX_UCS4_CHARS] of ucs4char;
  pucs4strarray = ^ucs4strarray;
    
  ucs2strarray = array[0..MAX_UCS2_CHARS] of ucs2char;
  pucs2strarray = ^ucs2strarray;


{---------------------------------------------------------------------------
                          UCS-4 string handling
-----------------------------------------------------------------------------}

  {** @abstract(Returns the current length of an UCS-4 string) }
  function ucs4_length(s: array of ucs4char): integer;

  {** @abstract(Set the new dynamic length of an UCS-4 string) }
  procedure ucs4_setlength(var s: array of ucs4char; l: integer);

  {** @abstract(Determines if the specified character is a whitespace character) }
  function ucs4_iswhitespace(c: ucs4char): boolean;
  
  {** @abstract(Converts a character to an uppercase character) 
  
      This routine only supports the simple form case folding
      algorithm (e.g full form is not supported).
  }
  function ucs4_upcase(c: ucs4char): ucs4char;

  {** @abstract(Converts a character to a lowercase character)

      This routine only supports the simple form case folding
      algorithm (e.g full form is not supported).

  }
  function ucs4_lowcase(c: ucs4char): ucs4char;

  {** @abstract(Trims leading spaces and control characters from an UCS-4 string.) }
  procedure ucs4_trimleft(var s: ucs4string);
  
  {** @abstract(Trims trailing spaces and control characters from an UCS-4 string.) }
  procedure ucs4_trimright(var s: ucs4string);

  {** @abstract(Returns an UCS-4 substring of an UCS-4 string) }
  procedure ucs4_copy(var resultstr: ucs4string; s: array of ucs4char; index: integer; count: integer);

  {** @abstract(Deletes a substring from a string) }
  procedure ucs4_delete(var s: ucs4string; index: integer; count: integer);

  {** @abstract(Concatenates two UCS-4 strings, and gives a resulting UCS-4 string) }
  procedure ucs4_concat(var resultstr: ucs4string;s1: ucs4string; s2: array of ucs4char);

  {** @abstract(Concatenates an UCS-4 string with an ASCII string, and gives
      a resulting UCS-4 string)
  }    
  procedure ucs4_concatascii(var resultstr: ucs4string;s1: ucs4string; s2: string);

  {** @abstract(Searches for an ASCII substring in an UCS-4 string) }
  function ucs4_posascii(substr: string; s: ucs4string): integer;

  {** @abstract(Checks if an ASCII string is equal to an UCS-4 string ) }
  function ucs4_equalascii(s1 : array of ucs4char; s2: string): boolean;

  {** @abstract(Searches for an UCS-4 substring in an UCS-4 string) }
  function ucs4_pos(substr: ucs4string;s : ucs4string): integer;

  {** @abstract(Checks if both UCS-4 strings are equal) }
  function ucs4_equal(const s1,s2: ucs4string): boolean;

  {** @abstract(Checks if the UCS-4 character is valid)

      This routine verifies if the UCS-4 character is
      within the valid ranges of UCS-4 characters, as
      specified in the Unicode standard 4.0. BOM characters
      are NOT valid with this routine.
  }
  function ucs4_isvalid(c: ucs4char): boolean;

  {** @abstract(Checks if conversion from/to this character set format to/from UCS-4
      is supported)

      @param(s This is an alias for a character set, as defined by IANA)
      @returns(true if conversion to/from UCS-4 is supported with this
        character set, otherwise FALSE)
  }
  function ucs4_issupported(s: string): boolean;

{---------------------------------------------------------------------------
                  UCS-4 null terminated string handling
-----------------------------------------------------------------------------}



  {** @abstract(Returns the number of characters in the null terminated UCS-4 string)

      @param(str The UCS-4 null terminated string to check)
      @returns(The number of characters in str, not counting the null
        character)
  }
  function ucs4strlen(str: pucs4char): integer;

  {** @abstract(Converts a null-terminated UCS-4 string to a Pascal-style UCS-4 string.)
  }
 procedure ucs4strpas(str: pucs4char; var res:ucs4string);
 
  {** @abstract(Converts a null-terminated UCS-4 string to a Pascal-style 
       ISO 8859-1 encoded string.)
       
      Characters that cannot be converted are converted to 
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
  }
 function ucs4strpastoISO8859_1(str: pucs4char): string;
 
  {** @abstract(Converts a null-terminated UCS-4 string to a Pascal-style 
       ASCII encoded string.)

      Characters that cannot be converted are converted to
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
  }
 function ucs4strpastoASCII(str: pucs4char): string;
 
 

  {** @abstract(Copies a Pascal-style UCS-4 string to a null-terminated UCS-4 string.)

      This routine does not perform any length checking.
      If the source string contains some null characters,
      those nulls are removed from the resulting string.

      The destination buffer must have room for at least Length(Source)+1 characters.
  }
 function ucs4strpcopy(dest: pucs4char; source: ucs4string):pucs4char;


  {** @abstract(Converts a pascal string to an UCS-4 null
   terminated string)

   The memory for the buffer is allocated. Use @link(ucs4strdispose) to dispose
   of the allocated string. The string is null terminated. If the original
   string contains some null characters, those nulls are removed from
   the resulting string.

   @param(str The string to convert, single character coded)
   @param(srctype The encoding of the string, UTF-8 is also valid)
  }
 function ucs4strnewstr(str: string; srctype: string): pucs4char;

  {** @abstract(Converts a null terminated string to an UCS-4 null
   terminated string) 
   
   The memory for the buffer is allocated. Use @link(ucs4strdispose) to dispose 
   of the allocated string. The string is null terminated.
   
   @param(str The string to convert, single character coded, or UTF-8 coded)
   @param(srctype The encoding of the string, UTF-8 is also valid)
  }
 function ucs4strnew(str: pchar; srctype: string): pucs4char;
 
  {** @abstract(Disposes of an UCS-4 null terminated string on the heap) 
  
      Disposes of a string that was previously allocated with
      @code(ucs4strnew), and sets the pointer to nil. 
   
  }
 function ucs4strdispose(str: pucs4char): pucs4char;

{---------------------------------------------------------------------------
                           UCS-2 string handling
-----------------------------------------------------------------------------}

  {** @abstract(Returns the current length of an UCS-2 string) }
  function ucs2_length(s: array of ucs2char): integer;
  
  {** @abstract(Set the new dynamic length of an ucs-2 string) }
  procedure ucs2_setlength(var s: array of ucs2char; l: integer);
  
  {** @abstract(Checks if the UCS-2 character is valid)

      This routine verifies if the UCS-2 character is
      within the valid ranges of UCS-2 characters, as
      specified in the Unicode standard 4.0. BOM characters
      are NOT valid with this routine.
  }
  function ucs2_isvalid(ch: ucs2char): boolean;
  
{---------------------------------------------------------------------------
                   UCS-2 null terminated string handling
-----------------------------------------------------------------------------}
  
  {** @abstract(Convert an UCS-2 null terminated string to an UCS-4 null terminated string)

      This routine converts an UCS-2 encoded null terminared string to an UCS-4 
      null terminated string that is stored in native byte order, up to
      length conversion.

      @returns(nil if there was no error in the conversion)
  }
  function ucs2strlcopyucs4(src: pucs2char; dst: pucs4char; maxlen: integer): pucs4char;
  
  
  {** @abstract(Returns the number of characters in the null terminated UCS-2 string)

      @param(str The UCS-2 null terminated string to check)
      @returns(The number of characters in str, not counting the null
        character)
  }
  function ucs2strlen(str: pucs2char): integer;
  
  
  
  {** @abstract(Converts an UCS-4 null terminated string to an UCS-2 null
   terminated string) 
   
   The memory for the buffer is allocated. Use @link(ucs2strdispose) to dispose 
   of the allocated string. The string is null terminated.
   
   @returns(nil if the conversion cannot be represented in UCS-2 encoding,
      or nil if there was an error)
  }
  function ucs2strnew(src: pucs4char): pucs2char;

  {** @abstract(Disposes of an UCS-2 null terminated string on the heap) 
  
      Disposes of a string that was previously allocated with
      @code(ucs2strnew), and sets the pointer to nil. 
   
  }
  function ucs2strdispose(str: pucs2char): pucs2char;
  
{---------------------------------------------------------------------------
                  UTF-8 null terminated string handling
-----------------------------------------------------------------------------}

  {** @abstract(Converts an UCS-4 null terminated string to an UTF-8 null
   terminated string) 
   
   The memory for the buffer is allocated. Use @link(utf8strdispose) to dispose 
   of the allocated string. The string is null terminated.
  }
  function utf8strnew(src: pucs4char): pchar;
  
  {** @abstract(Allocates and copies an UTF-8 null terminated string) 
   
   The memory for the buffer is allocated. Use @link(utf8strdispose) to dispose 
   of the allocated string. The string is copied from src and is null terminated.
  }
  function utf8strnewutf8(src: pchar): pchar;
  

  {** @abstract(Disposes of an UTF-8 null terminated string on the heap) 
  
      Disposes of a string that was previously allocated with
      @code(utf8strnew), and sets the pointer to nil. 
   
  }
  function utf8strdispose(str: pchar): pchar;
  
  
  {** @abstract(Convert an UTF-8 null terminated string to an UCS-4 null terminated string)

      This routine converts an UTF-8 null terminared string to an UCS-4 
      null terminated string that is stored in native byte order, up to
      length conversion.

      @returns(nil if there was no error in the conversion)
  }
  function utf8strlcopyucs4(src: pchar; dst: pucs4char; maxlen: integer): pucs4char;
  
  {** @abstract(Converts a null-terminated UTF-8 string to a Pascal-style 
       ISO 8859-1 encoded string.)
       
      Characters that cannot be converted are converted to 
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
  }
 function utf8strpastoISO8859_1(src: pchar): string;
  
  {** @abstract(Converts a null-terminated UTF-8 string to a Pascal-style 
       ASCII encoded string.)
       
      Characters that cannot be converted are converted to 
      escape sequences of the form : \uxxxxxxxx where xxxxxxxx is
      the hex representation of the character.
  }
 function utf8strpastoASCII(src: pchar): string;
  
  

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
  function utf16_sizeencoding(c: utf16char): integer;

  {** @abstract(Returns the number of characters that are used to encode this
      character).
      
  }      
  function utf8_sizeencoding(c: utf8char): integer;
  
  {** @abstract(Returns the current length of an UTF-16 string) }
  function utf16_length(s: array of utf16char): integer;

  {** @abstract(Returns the current length of an UTF-8 string) }
  function utf8_length(s: utf8string): integer;
  
  {** @abstract(Returns if the specified UTF-8 string is legal or not) }
  function utf8_islegal(s: utf8string): boolean;
  
  {** @abstract(Set the length of an UTF-8 string) }
  procedure utf8_setlength(var s: utf8string; l: integer);

  {** @abstract(Set the length of an UTF-16 string) }
  procedure utf16_setlength(var s: array of utf16char; l: integer);


{---------------------------------------------------------------------------
                      Unicode Conversion routines
-----------------------------------------------------------------------------}
  

  {** @abstract(Convert an UCS-4 string to an UTF-8 string) 

      Converts an UCS-4 string or character
      in native endian to an UTF-8 string. 
      
      @param(s Either a single UCS-4 character or a complete UCS-4 string)
      @param(outstr Resulting UTF-8 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function convertUCS4toUTF8(s: array of ucs4char; var outstr: utf8string): integer;
  
  {** @abstract(Convert an UCS-4 string to a single byte encoded string)

     This routine converts an UCS-4 string stored in native byte order
     (native endian) to a single-byte encoded string.

     The string is limited to 255 characters, and if the conversion cannot
     be successfully be completed, it gives out an error. The following
     @code(desttype) can be specified: ISO-8859-1, windows-1252,
     ISO-8859-2, ISO-8859-5, ISO-8859-16, macintosh, atari, cp437, cp850, ASCII.
  
      @param(desttype Indicates the single byte encoding scheme)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }  
  function ConvertFromUCS4(source: ucs4string; var dest: string; desttype: string): integer;

  {** @abstract(Convert a byte encoded string to an UCS-4 string)
  
     This routine converts a single byte encoded string to an UCS-4
     string stored in native byte order
     
     Characters that cannot be converted are converted to escape 
     sequences of the form : \uxxxxxxxx where xxxxxxxx is the hex 
     representation of the character, an error code will also be 
     returned by the function

     The string is limited to 255 characters, and if the conversion cannot
     be successfully be completed, it gives out an error. The following
     @code(srctype) can be specified: ISO-8859-1, windows-1252,
     ISO-8859-2, ISO-8859-5, ISO-8859-16, macintosh, atari, cp437, cp850, ASCII.

      @param(srctype Indicates the single byte encoding scheme)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertToUCS4(source: string; var dest: ucs4string; srctype: string): integer;
  
  {** @abstract(Convert an UTF-16 string to an UCS-4 string)

      This routine converts an UTF-16 string to an UCS-4 string.
      Both strings must be stored in native byte order (native endian).

      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF16ToUCS4(src: utf16string; var dst: ucs4string): integer;

  {** @abstract(Convert an UCS-4 string to an UTF-16 string)
  
      This routine converts an UCS-4 string to an UTF-16 string.
      Both strings must be stored in native byte order (native endian).

      @param(src Either a single UCS-4 character or a complete UCS-4 string)
      @param(dest Resulting UTF-16 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUCS4toUTF16(src: array of ucs4char; var dest: utf16string): integer;
  
  {** @abstract(Convert an UTF-8 string to an UCS-4 string)

      This routine converts an UTF-8 string to an UCS-4 string that
      is stored in native byte order.

      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  }
  function ConvertUTF8ToUCS4(src: utf8string; var dst: ucs4string): integer;

  {** @abstract(Convert an UCS-4 string to an UCS-2 string)
  
      This routine converts an UCS-4 string to an UCS-2 string that
      is stored in native byte order. If some characters
      could not be converted an error will be reported.
      
      @param(src Either a single UCS-4 character or a complete UCS-4 string)
      @param(dest Resulting UCS-2 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)
  
  }
  function ConvertUCS4ToUCS2(src: array of ucs4char; var dst: ucs2string): integer;


  {** @abstract(Convert an UCS-2 string to an UCS-4 string)

      This routine converts an UCS-2 string to an UCS-4 string that
      is stored in native byte order (big-endian). If some characters
      could not be converted an error will be reported.

      @param(src Either a single ucs-2 character or a complete ucs-2 string)
      @param(dest Resulting UCS-4 coded string)
      @returns(@link(UNICODE_ERR_OK) if there was no error in the conversion)

  }
  function ConvertUCS2ToUCS4(src: array of ucs2char; var dst: ucs4string): integer;


implementation

uses strings;


type
  pchararray = ^tchararray;
  tchararray = array[#0..#255] of longint;
  taliasinfo = record
    aliasname: string[32];
    table: pchararray;
  end;   


{ Case conversion table }
{$i case.inc}

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
  asciitoutf32: tchararray =
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
    
    offsetsFromUTF8: array[0..5] of ucs4char = ( 
           $00000000, $00003080, $000E2080,
           $03C82080, $FA082080, $82082080
           );
    


{*
 * Once the bits are split out into bytes of UTF-8, this is a mask OR-ed
 * into the first byte, depending on how many bytes follow.  There are
 * as many entries in this table as there are UTF-8 sequence types.
 * (I.e., one byte sequence, two byte... six byte sequence.)
 *}
 const firstByteMark: array[0..6] of utf8char = 
 (
   #$00, #$00, #$C0, #$E0, #$F0, #$F8, #$FC
 );
 
  const
    byteMask: ucs4char = $BF;
    byteMark: ucs4char = $80;
    
    
  function convertUCS4toUTF8(s: array of ucs4char; var outstr: utf8string): integer;
  var
   i: integer;
   ch: ucs4char;
   bytesToWrite: integer;
   OutStringLength : byte;
   OutIndex : integer;
   Currentindex: integer;
   StartIndex: integer;
   EndIndex: integer;
  begin
    ConvertUCS4ToUTF8:=UNICODE_ERR_OK;
    OutIndex := 1;
    bytestoWrite:=0; 
    OutStringLength := 0;
    utf8_setlength(outstr,0);
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
        EndIndex:=UCS4_Length(s);
      end;
      
    for i:=StartIndex to EndIndex do
     begin
       ch:=s[i];    

       if (ch > UNI_MAX_UTF16) then
       begin
         convertUCS4ToUTF8:= UNICODE_ERR_SOURCEILLEGAL;
         exit;
       end;
     
     
       if ((ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END)) then
       begin
         convertUCS4ToUTF8:= UNICODE_ERR_SOURCEILLEGAL;
         exit;
       end;
    
      if (ch < ucs4char($80)) then
        bytesToWrite:=1
      else
      if (ch < ucs4char($800)) then
        bytesToWrite:=2
      else
      if (ch < ucs4char($10000)) then
        bytesToWrite:=3
      else
      if (ch < ucs4char($200000)) then
        bytesToWrite:=4
      else
        begin
          ch:=UNI_REPLACEMENT_CHAR;
          bytesToWrite:=2;
        end;
      Inc(outindex,BytesToWrite);  
{      if Outindex > High(utf8string) then
        begin
          convertUCS4ToUTF8:=UNICODE_ERR_LENGTH_EXCEED;
          exit;
        end;}
        
        CurrentIndex := BytesToWrite;
        if CurrentIndex = 4 then
        begin
          dec(OutIndex);
          outstr[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          dec(OutIndex);
          outstr[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          dec(OutIndex);
          outstr[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          dec(OutIndex);
          outstr[outindex] := utf8char((byte(ch) or byte(FirstbyteMark[BytesToWrite])));
        end;  
        inc(OutStringLength);
        Inc(OutIndex,BytesToWrite);
      end;      
      utf8_setlength(outstr,OutStringLength);
  end;
  
  function utf16_length(s: array of utf16char): integer;
  begin
   utf16_length:=integer(s[0]);
  end;

  function utf8_length(s: utf8string): integer;
  begin
   utf8_length:=length(s);
  end;
  

  

  procedure utf8_setlength(var s: utf8string; l: integer);
  begin
    setlength(s,l);
  end;

  procedure utf16_setlength(var s: array of utf16char; l: integer);
  begin
   s[0]:=utf16char(l);
  end;
  
  

  function utf8_islegal(s: utf8string): boolean;
  var morebytes: integer;
      i,j: integer;
  begin
    utf8_islegal:=false;
    i:=1;
    while i <= utf8_length(s) do
    begin
        morebytes:=trailingBytesForUTF8[ord(s[i])];
        inc(i);
        if morebytes <> 0 then
        begin
           for j:=i to (i+morebytes-1) do
             begin
              if j > length(s) then exit;
              if ((ord(s[j]) and $C0) <> $80) then
                 exit;
             end;
        end;
        inc(i,morebytes);
    end;
    utf8_islegal:=true;
  end;
    
  

  
  function ConvertFromUCS4(source: ucs4string; var dest: string; desttype: string): integer;
  var
   i: integer;
   j: char;
   p: pchararray;
   found: boolean;
  begin
    dest:='';
    ConvertFromUCS4:=UNICODE_ERR_OK;  
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
        ConvertFromUCS4:=UNICODE_ERR_NOTFOUND;  
        exit;
      end;
    { for each character in the UCS-4 string ... }  
    for i:=1 to ucs4_length(source) do
      begin
        found:=false;
        { search the table by reverse lookup }
        for j:=#0 to high(char) do 
          begin     
            if ucs4char(source[i]) = ucs4char(p^[j]) then
              begin
                dest:=dest+j;
                found:=true;
                break;
              end;
          end;
        if not found then
          begin
            dest:=dest+'\u'+hexstr(source[i],8);
            ConvertFromUCS4:=UNICODE_ERR_INCOMPLETE_CONVERSION;
          end;
      end;
  end;
  
  function ConvertToUCS4(source: string; var dest: ucs4string; srctype: string): integer;
  var
   i: integer;
   l: longint;
   p: pchararray;
  begin
    ConvertToUCS4:=UNICODE_ERR_OK;
    source:=removenulls(source);
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
        ConvertToUCS4:=UNICODE_ERR_NOTFOUND;  
        exit;
      end;
    for i:=1 to length(source) do
      begin
        l:=p^[source[i]];
        if l = -1 then
          begin
            ConvertToUCS4:=UNICODE_ERR_INCOMPLETE_CONVERSION;
            continue;
          end;
        dest[i]:=ucs4char(l);  
      end;
    UCS4_setlength(dest,length(source));
  end;


  function ConvertUTF16ToUCS4(src: utf16string; var dst: ucs4string): integer;
   var
     ch,ch2: ucs4char;
     i: integer;
     Outindex: integer;
  begin
    i:=1;
    Outindex := 1;
    ConvertUTF16ToUCS4:=UNICODE_ERR_OK;
    while i <= utf16_length(src) do
      begin
        ch:=ucs4char(src[i]);
        inc(i);
        if (ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_HIGH_END) and (i < utf16_length(src)) then
          begin
              ch2:=src[i];
              if (ch2 >= UNI_SUR_LOW_START) and (ch2 <= UNI_SUR_LOW_END) then
                begin
                  ch := ((ch - UNI_SUR_HIGH_START) shl halfShift)
                          + (ch2 - UNI_SUR_LOW_START) + halfBase;
                end
             else
                begin
                  ConvertUTF16ToUCS4 := UNICODE_ERR_SOURCEILLEGAL;
                  exit;
                end;
          end
        else
        if (ch >= UNI_SUR_LOW_START) and (ch <= UNI_SUR_LOW_END) then
          begin
            ConvertUTF16ToUCS4 := UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end;
        dst[OutIndex] := ch;
        Inc(OutIndex);
     end;     
  ucs4_setlength(dst,OutIndex-1);
end;

function ConvertUTF8ToUCS4(src: utf8string; var dst: ucs4string): integer;
  var
   ch: ucs4char;
   i: integer;
   StringLength: integer;
   Outindex: integer;
   ExtraBytesToRead: integer;
   CurrentIndex: integer;
  begin
    i:=1;
    stringlength := 0;
    OutIndex := 1;
    ConvertUTF8ToUCS4:=UNICODE_ERR_OK;
    while i <= utf8_length(src) do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            ConvertUTF8ToUCS4:=UNICODE_ERR_LENGTH_EXCEED;
            exit;
          end;
{        if not isLegalUTF8(src, extraBytesToRead+1) then
          begin
            ConvertUTF8ToUCS4:=UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end;}
        CurrentIndex := ExtraBytesToRead;
        if CurrentIndex = 5 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 4 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 0 then
        begin
          ch:=ch + ucs4char(src[i]);
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
     ucs4_setlength(dst, outindex-1);
  end;
  

function ConvertUCS4toUTF16(src: array of ucs4char; var dest: utf16string): integer;
var
 ch: ucs4char;
   i: integer;
   Outindex: integer;
   StartIndex, EndIndex: integer;
begin
    OutIndex := 1;
    ConvertUCS4ToUTF16:=UNICODE_ERR_OK;
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
        EndIndex:=UCS4_Length(src);
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
                ConvertUCS4ToUTF16:=UNICODE_ERR_SOURCEILLEGAL;
                exit;
              end
            else
              begin
                dest[OutIndex] := utf16char(ch);
                inc(OutIndex);
              end;
          end
        else 
        if (ch > UNI_MAX_UTF16) then
          begin
            ConvertUCS4ToUTF16:=UNICODE_ERR_SOURCEILLEGAL;
            exit;
          end
        else
          begin
            if OutIndex + 1> High(utf16string) then
              begin
                ConvertUCS4ToUTF16:=UNICODE_ERR_LENGTH_EXCEED;
                exit;
              end;
            ch := ch - Halfbase;
            dest[OutIndex] := (ch shr halfShift) + UNI_SUR_HIGH_START;
            inc(OutIndex);
            dest[OutIndex] := (ch and halfMask) + UNI_SUR_LOW_START;
            inc(OutIndex);
          end;
      end;
    utf16_setlength(dest, OutIndex);  
end;


  function ConvertUCS4ToUCS2(src: array of ucs4char; var dst: ucs2string): integer;
  var
   ch: ucs4char;
   i: integer;
   StartIndex, EndIndex: integer;
  begin
    ConvertUCS4ToUCS2:=UNICODE_ERR_OK;
  
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
        EndIndex:=UCS4_Length(src);
        dst[0]:=ucs2char(ucs4_length(src));
      end;
  
    for i:=StartIndex to EndIndex do
      begin
        ch:=src[i];
        if ch > UNI_MAX_BMP then
          begin 
            ConvertUCS4ToUCS2:=UNICODE_ERR_INCOMPLETE_CONVERSION;
            continue;
          end;
        dst[i]:=ucs2char(ch and UNI_MAX_BMP);
      end;
  end;
  
  
  function ConvertUCS2ToUCS4(src: array of ucs2char; var dst: ucs4string): integer;
  var
   ch: ucs4char;
   i: integer;
   StartIndex, EndIndex: integer;
  begin
    ConvertUCS2ToUCS4:=UNICODE_ERR_OK;
  
    { Check if only one character is passed as src, in that case
      this is not an UCS string, but a simple character (in other
      words, there is not a length byte.
    }
    if High(src) = 0 then
      begin
        StartIndex:=0;
        EndIndex:=0;
        dst[0]:=ucs4char(1);
      end
    else
      begin
        StartIndex:=1;
        EndIndex:=UCS2_Length(src);
       ucs4_setlength(dst,ucs2_length(src));
      end;
    for i:=StartIndex to EndIndex do
      begin
        ch:=src[i];
        if not ucs2_isvalid(ch and $ffff) then
          begin 
            ConvertUCS2ToUCS4:=UNICODE_ERR_SOURCEILLEGAL;
            continue;
          end;
        dst[i]:=ucs4char(ch);
      end;
  end;


{---------------------------------------------------------------------------
                          UCS-4 string handling
-----------------------------------------------------------------------------}

  function ucs4_upcase(c: ucs4char): ucs4char;
  var
   i: integer;
  begin
    { Assume there is no uppercase for this character }
    ucs4_upcase:=c;
    for i:=1 to MAX_CASETABLE_ENTRIES do
      begin
        if (c = UCS4CaseTable[i].lower) then
          begin
           ucs4_upcase:=UCS4CaseTable[i].upper;
           exit;
          end; 
      end;
  end;
  
  function ucs4_lowcase(c: ucs4char): ucs4char;
  var
   i: integer;
  begin
    { Assume there is no uppercase for this character }
    ucs4_lowcase:=c;
    for i:=1 to MAX_CASETABLE_ENTRIES do
      begin
        if (c = UCS4CaseTable[i].upper) then
          begin
           ucs4_lowcase:=UCS4CaseTable[i].lower;
           exit;
          end; 
      end;
  end;

  function ucs4_iswhitespace(c: ucs4char): boolean;
    const
      MAX_WHITESPACE = 25;
      whitespace: array[1..MAX_WHITESPACE] of ucs4char =
      (
       $0009,  { control: TAB }
       $000A,  { control: Linefeed }
       $000B,  { control: Vertical TAB }
       $000C,  { control: Formfeed }
       $000D,  { control: Carriage return }
       $0020,  { SPACE }
       $0085,  { control:  }       
       $1680,  { OGHAM SPACE MARK }
       $180E,  { MONGOLIAN VOWEL SEPARATOR }
       $2000,  { EN QUAD..HAIR SPACE }
       $2001,
       $2002,
       $2003,
       $2004,
       $2005,
       $2006,
       $2007,
       $2008,
       $2009,
       $200A,
       $2028,  { LINE SEPARATOR }
       $2029,  { PARAGRAPH SEPARATOR }
       $202F,  { NARROW NO-BREAK SPACE }
       $205F,  { MEDIUM MATHEMATICAL SPACE }
       $3000   { IDEOGRAPHIC SPACE }
      );
   var
    i : integer;
  begin
   ucs4_iswhitespace:=false;
   for i:=1 to MAX_WHITESPACE do
     begin
       if (c = whitespace[i]) then
          ucs4_iswhitespace := true;
     end;
  end;
  
  procedure ucs4_copy(var resultstr: ucs4string; s: array of ucs4char; index: integer; count: integer);
  var
   slen: integer;
   i: integer;
  begin
    ucs4_setlength(resultstr,0);
    if count = 0 then
      exit;
    slen:=ucs4_length(s);
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
    resultstr[0]:=ucs4char(count);
  end;
  
  procedure ucs4_delete(var s: ucs4string; index: integer; count: integer);
  begin
    if index<=0 then
      exit;
    if (Index<=UCS4_Length(s)) and (Count>0) then
     begin
       if Count>UCS4_length(s)-Index then
        Count:=UCS4_length(s)-Index+1;
       s[0]:=(UCS4_length(s)-Count);
       if Index<=ucs4_Length(s) then
        Move(s[Index+Count],s[Index],(UCS4_Length(s)-Index+1)*sizeof(ucs4char));
     end;
  end;
  

  procedure ucs4_concat(var resultstr: ucs4string;s1: ucs4string; s2: array of ucs4char);
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
        s2l:=ucs4_length(s2);
        idx:=1;
      end;
    s1l:=ucs4_length(s1);
    if (s2l+s1l)>255 then
      s2l:=255-s1l;
    if s2l <> 0 then
      move(s2[idx],s1[ucs4_length(s1)+1],s2l*sizeof(ucs4char));
    move(s1[1],resultstr[1],(s2l+s1l)*sizeof(ucs4char));
    ucs4_setlength(resultstr, s2l+s1l);
  end;
  
  function ucs4_pos(substr: ucs4string; s: ucs4string): integer;
  var
    i,j : integer;
    e   : boolean;
    Substr2: ucs4string;
  begin
    i := 0;
    j := 0;
    e:=(ucs4_length(SubStr)>0);
    while e and (i<=ucs4_Length(s)-ucs4_Length(SubStr)) do
     begin
       inc(i);
       ucs4_Copy(Substr2,s,i,ucs4_Length(Substr));
       if (SubStr[1]=s[i]) and (ucs4_equal(Substr,Substr2)) then
        begin
          j:=i;
          e:=false;
        end;
     end;
    ucs4_Pos:=j;
  end;
  
  function ucs4_equal(const s1,s2: ucs4string): boolean;
    var
     i: integer;
  begin
    ucs4_equal:=false;
    if ucs4_length(s1) <> ucs4_length(s2) then
      exit;
    for i:=1 to ucs4_length(s1) do
      begin
        if s1[i] <> s2[i] then
          exit;
      end;
    ucs4_equal:=true;
  end;
  

  function ucs4_length(s: array of ucs4char): integer;
  begin
   ucs4_length:=integer(s[0]);
  end;
  
  procedure ucs4_setlength(var s: array of ucs4char; l: integer);
  begin
   if l > 255 then
     l:=255;
   s[0]:=ucs4char(l);
  end;

  procedure ucs4_concatascii(var resultstr: ucs4string;s1: ucs4string; s2: string);
  var
   utfstr: ucs4string;
  begin
    if ConvertToUCS4(s2,utfstr,'ASCII')  = UNICODE_ERR_OK then
       ucs4_concat(resultstr,s1,utfstr);
  end;

  function ucs4_posascii(substr: string; s: ucs4string): integer;
  var
   utfstr: ucs4string;
  begin
    ucs4_posascii:=0;
    if ConvertToUCS4(substr,utfstr,'ASCII')  = UNICODE_ERR_OK then
     ucs4_posascii:=ucs4_pos(utfstr,s);
  end;

  function ucs4_equalascii(s1 : array of ucs4char; s2: string): boolean;
  var
   utfstr: ucs4string;
   s3: ucs4string;
   i: integer;
  begin
    ucs4_equalascii:=false;
    for i:=1 to ucs4_length(s1) do
      begin
        s3[i] := s1[i];
      end;
    ucs4_setlength(s3,ucs4_length(s1));
    if ConvertToUCS4(s2,utfstr,'ASCII')  = UNICODE_ERR_OK then
     ucs4_equalascii:=ucs4_equal(utfstr,s3);
  end;

  function ucs4_issupported(s: string): boolean;
  var
   i: integer;
  begin
    s:=upstring(s);
    ucs4_issupported := true;
    if (s = 'UTF-16') or (s = 'UTF-16BE') or (s = 'UTF-16LE') or
       (s = 'UCS-4') or (s = 'UCS-4BE') or (s = 'UCS-4LE') or
       (s = 'UTF-8') then
     begin
        ucs4_issupported := true;
        exit;
     end;
    for i:=1 to MAX_ALIAS do
    begin
      if upstring(aliaslist[i].aliasname) = s then
      begin
         ucs4_issupported := true;
         exit;
      end;
    end;
  end;
  
  function ucs4_isvalid(c: ucs4char): boolean;
  begin
    ucs4_isvalid := false;
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
    ucs4_isvalid := true;
  end;



  procedure UCS4_TrimLeft(var S: ucs4string);
  var i,l:integer;
      outstr: ucs4string;
  begin
    ucs4_setlength(outstr,0);
    l := ucs4_length(s);
    i := 1;
    while (i<=l) and (ucs4_iswhitespace(s[i])) do
     inc(i);
    ucs4_copy(outstr,s, i, l);
    move(outstr,s,sizeof(ucs4string));
  end ;


  procedure UCS4_TrimRight(var S: ucs4string);
  var l:integer;
      outstr: ucs4string;
  begin
    ucs4_setlength(outstr,0);
    l := ucs4_length(s);
    while (l>0) and (ucs4_iswhitespace(s[l])) do
     dec(l);
    ucs4_copy(outstr,s,1,l);
    move(outstr,s,sizeof(ucs4string));
  end ;


  function utf16_sizeencoding(c: utf16char): integer;
  begin
    utf16_sizeencoding:=2;
    if (c >= UNI_SUR_HIGH_START) and (c <= UNI_SUR_HIGH_END) then
      utf16_sizeencoding:=4;
  end;
  
  function utf8_sizeencoding(c: utf8char): integer;
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

  function ucs4strlen(str: pucs4char): integer;
  var
   counter : Longint;
   stringarray: pucs4strarray;
 Begin
   ucs4strlen:=0;
   if not assigned(str) then
     exit;
   stringarray := pucs4strarray(str);
   counter := 0;
   while stringarray^[counter] <> 0 do
     Inc(counter);
   ucs4strlen := counter;
 end;

 function ucs4strpasToISO8859_1(Str: pucs4char): string;
  var
   i: integer;
   lstr: string;
   stringarray: pucs4strarray;
 Begin
   ucs4strpasToISO8859_1:='';
   if not assigned(str) then exit;
   stringarray := pointer(str);
   setlength(lstr,0);
   for i:=1 to ucs4strlen(str) do
     begin
       if i >= high(ucs4string) then break;
       if Stringarray^[i-1] <= 255 then
          lstr := lstr + chr(Stringarray^[i-1])
       else
          lstr := lstr + '\u'+hexstr(Stringarray^[i-1],8);
     end;
   ucs4strpasToISO8859_1:= lstr;
 end;

 function ucs4strpasToASCII(Str: pucs4char): string;
  var
   counter : byte;
   lstr: string;
   stringarray: pucs4strarray;
 Begin
   counter := 0;
   ucs4strpasToASCII:='';
   if not assigned(str) then exit;
   stringarray := pointer(str);
   setlength(lstr,0);
   while ((stringarray^[counter]) <> 0) and (counter < high(ucs4string)) do
   begin
     Inc(counter);
     if Stringarray^[counter-1] <= 127 then
        lstr := lstr + chr(Stringarray^[counter-1])
     else
        lstr := lstr + '\u'+hexstr(Stringarray^[counter-1],8);
   end;
   ucs4strpasToASCII:= lstr;
 end;
 
 

 procedure ucs4strpas(Str: pucs4char; var res:ucs4string);
  var
   counter : byte;
   lstr: ucs4string;
   stringarray: pucs4strarray;
 Begin
   counter := 0;
   stringarray := pointer(str);
   ucs4_setlength(res,0);
   ucs4_setlength(lstr,0);
   if not assigned(str) then exit;
   while ((stringarray^[counter]) <> 0) and (counter < high(ucs4string)) do
   begin
     Inc(counter);
     ucs4_concat(lstr, lstr, Stringarray^[counter-1]);
   end;
   UCS4_SetLength(lstr,counter);
   res := lstr;
 end;
 
 
 function ucs4strnewstr(str: string; srctype: string): pucs4char;
  var
   i: integer;
   dest: pucs4strarray;
   destpchar: pucs4char;
   count: integer;
   Currentindex: integer;
   Outindex,totalsize: integer;
   ch: ucs4char;
   ExtraBytesToRead: integer;
   p:pchararray;
  begin
    str:=removenulls(str);
    ucs4strnewstr:=nil;
    dest:=nil;
    p:=nil;
    { Special case: UTF-8 encoding }
    if srctype = 'UTF-8' then
      begin
        { Calculate the length to store the decoded length }
        i:=1;
        totalsize:=0;
        while (i <> length(str)) do
          begin
            count:=utf8_sizeencoding(str[i]);
            { increment the pointer accordingly }
            inc(i,count);
            inc(totalsize);
          end;  
        Getmem(destpchar,totalsize*sizeof(ucs4char)+sizeof(ucs4char));
        dest:=pucs4strarray(destpchar);
        i:=1;
        OutIndex := 0;
        while (i <> length(str)) do
          begin
            ch := 0;
            extrabytestoread:= trailingBytesForUTF8[ord(str[i])];
{            if not isLegalUTF8(str, extraBytesToRead+1) then
              begin
                exit;
              end;}
            CurrentIndex := ExtraBytesToRead;
            if CurrentIndex = 5 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 4 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 3 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 2 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 1 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 0 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
            end;
            ch := ch - offsetsFromUTF8[extraBytesToRead];
            if (ch <= UNI_MAX_UTF32) then
              begin
                dest^[OutIndex] := ch;
                inc(OutIndex);
              end
            else
              begin
                dest^[OutIndex] := UNI_REPLACEMENT_CHAR;
                inc(OutIndex);
              end;
          end;
        { add null character }
        dest^[outindex]:=0;
      end
    else
      begin
        { The size to allocate is the same to allocate }
        Getmem(destpchar,length(str)*sizeof(ucs4char)+sizeof(ucs4char));
        dest:=pucs4strarray(destpchar);
        { Search the alias type }
        for i:=1 to MAX_ALIAS do
          begin
            if aliaslist[i].aliasname = srctype then
              begin
                p:=aliaslist[i].table;
              end;
          end;
        if not assigned(p) then
            exit;
        for i:=0 to length(str)-1 do
          begin
            ch:=p^[str[i+1]];
            if ch = ucs4char(-1) then
              begin
                continue;
              end;
            dest^[i]:=ucs4char(ch);
          end;
        { add null character }  
        dest^[length(str)]:=0;
        ucs4strnewstr:=pucs4char(dest);
      end;
  end;
 
 
 procedure ucs4removenulls(s: ucs4string; var dest: ucs4string);
 var
  outstr: ucs4string;
  i,j: integer;
 begin
  { Allocate at least enough memory if using ansistrings }
  ucs4_setlength(outstr,ucs4_length(s));
  j:=1;
  for i:=1 to ucs4_length(s) do
    begin
      if s[i] <> 0 then
      begin
        outstr[j]:=s[i];
        inc(j);
      end;
    end;
  ucs4_setlength(outstr,j-1);
  dest:=outstr;
 end;
 
 function ucs4strnew(str: pchar; srctype: string): pucs4char;
  var
   i: integer;
   dest: pucs4strarray;
   count: integer;
   Currentindex: integer;
   Outindex,totalsize: integer;
   ch: ucs4char;
   ExtraBytesToRead: integer;
   p:pchararray;
  begin
    ucs4strnew:=nil;
    dest:=nil;
    p:=nil;
    if not assigned(str) then exit;
    { Special case: UTF-8 encoding }
    if srctype = 'UTF-8' then
      begin
        { Calculate the length to store the decoded length }
        i:=0;
        totalsize:=0;
        while (str[i]<>#0) do
          begin
            count:=utf8_sizeencoding(str[i]);
            { increment the pointer accordingly }
            inc(i,count);
            inc(totalsize);
          end;  
        Getmem(dest,totalsize*sizeof(ucs4char)+sizeof(ucs4char));
        fillchar(dest^,totalsize*sizeof(ucs4char)+sizeof(ucs4char),$55);
        i:=0;
        OutIndex := 0;
        while str[i]<>#0 do
          begin
            ch := 0;
            extrabytestoread:= trailingBytesForUTF8[ord(str[i])];
{            if not isLegalUTF8(str, extraBytesToRead+1) then
              begin
                exit;
              end;}
            CurrentIndex := ExtraBytesToRead;
            if CurrentIndex = 5 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 4 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 3 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 2 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 1 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
              ch:=ch shl 6;
              dec(CurrentIndex);
            end;
            if CurrentIndex = 0 then
            begin
              ch:=ch + ucs4char(str[i]);
              inc(i);
            end;
            ch := ch - offsetsFromUTF8[extraBytesToRead];
            if (ch <= UNI_MAX_UTF32) then
              begin
                dest^[OutIndex] := ch;
                inc(OutIndex);
              end
            else
              begin
                dest^[OutIndex] := UNI_REPLACEMENT_CHAR;
                inc(OutIndex);
              end;
          end;
        { add null character }
        dest^[outindex]:=0;
      end
    else
      begin
        { The size to allocate is the same to allocate }
        Getmem(dest,strlen(str)*sizeof(ucs4char)+sizeof(ucs4char));        
        { Search the alias type }
        for i:=1 to MAX_ALIAS do
          begin
            if aliaslist[i].aliasname = srctype then
              begin
                p:=aliaslist[i].table;
              end;
          end;
        if not assigned(p) then
            exit;
        for i:=0 to strlen(str)-1 do
          begin
            ch:=p^[str[i]];
            if ch = ucs4char(-1) then
              begin
                continue;
              end;
            dest^[i]:=ucs4char(ch);
          end;
        { add null character }  
        dest^[strlen(str)]:=0;
        ucs4strnew:=pucs4char(dest);
      end;
  end;
 
 function ucs4strdispose(str: pucs4char): pucs4char;
 begin
    ucs4strdispose := nil;
    if not assigned(str) then 
      exit;
    { don't forget to free the null character }
    Freemem(str,ucs4strlen(str)*sizeof(ucs4char)+sizeof(ucs4char));
    str:=nil;
 end;
 

 Function UCS4StrPCopy(Dest: Pucs4char; Source: UCS4String):PUCS4Char;
   var
    counter : byte;
    stringarray: pucs4strarray;

  Begin
   { remove any null characters from the string }
   ucs4removenulls(source,source);
   stringarray:=pointer(Dest);
   UCS4StrPCopy := nil;
   if not assigned(Dest) then
     exit;
   { if empty pascal string  }
   { then setup and exit now }
   if ucs4_length(Source) = 0 then
   Begin
     stringarray^[0] := 0;
     UCS4StrPCopy := pointer(StringArray);
     exit;
   end;
   for counter:=1 to ucs4_length(Source) do
   begin
     StringArray^[counter-1] := Source[counter];
   end;
   { terminate the string }
   StringArray^[ucs4_length(Source)] := 0;
   UCS4StrPCopy:=Dest;
 end;


  function utf8strdispose(str: pchar): pchar;
  begin
    utf8strdispose := nil;
    if not assigned(str) then 
      exit;
    Freemem(str,strlen(str)+1);
    str:=nil;
  end;
  
  function utf8strnewutf8(src: pchar): pchar;
  var
   lengthtoalloc: integer;
   dst: pchar;
  begin
    lengthtoalloc:=strlen(src)+sizeof(utf8char);
    { also copy the null character }
    Getmem(dst,lengthtoalloc);
    move(src^,dst^,lengthtoalloc);
    utf8strnewutf8:=dst;
  end;
  

  function UTF8StrNew(src: pucs4char): pchar;
  var
   ucs4stringlen: integer;
   p: pchar;
   ch: ucs4char;
   OutIndex,BytesToWrite,OutStringLength,StartIndex: integer;
   CurrentIndex, EndIndex: integer;
   i: integer;
   ResultPtr: putf8char;
   instr: pucs4strarray;
   sizetoalloc: integer;
  begin
    ucs4stringlen:=ucs4strlen(src);
    { Let us not forget the terminating null character }
    sizetoalloc:=ucs4stringlen*sizeof(ucs4char)+sizeof(ucs4char);
    instr:=pointer(src);
    { allocate at least the space taken up by the
      strlen*4 - because each character can take up to 4 bytes.
    }  
    GetMem(p,sizetoalloc);
    fillchar(p^,sizetoalloc,0);
    OutIndex := 0;
    bytestoWrite:=0; 
    OutStringLength := 0;
    StartIndex:=0;
    EndIndex:=ucs4stringlen-1;
      
    for i:=StartIndex to EndIndex do
     begin
       ch:=instr^[i];    

       if (ch > UNI_MAX_UTF16) then
       begin
         UTF8StrNew := nil;
         FreeMem(p,sizetoalloc);
         exit;
       end;
     
     
       if ((ch >= UNI_SUR_HIGH_START) and (ch <= UNI_SUR_LOW_END)) then
       begin
         UTF8StrNew := nil;
         FreeMem(p,sizetoalloc);
         exit;
       end;
    
      if (ch < ucs4char($80)) then
        bytesToWrite:=1
      else
      if (ch < ucs4char($800)) then
        bytesToWrite:=2
      else
      if (ch < ucs4char($10000)) then
        bytesToWrite:=3
      else
      if (ch < ucs4char($200000)) then
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
          p[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          dec(OutIndex);
          p[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          dec(OutIndex);
          p[outindex] := utf8char((ch or byteMark) and ByteMask);
          ch:=ch shr 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          dec(OutIndex);
          p[outindex] := utf8char((byte(ch) or byte(FirstbyteMark[BytesToWrite])));
        end;  
        inc(OutStringLength);
        Inc(OutIndex,BytesToWrite);
      end;    
      { Copy the values, and free the old buffer }
      Getmem(ResultPtr,Outindex+1);
      move(p^,ResultPtr^,Outindex);
      FreeMem(pointer(p),sizetoalloc);
      ResultPtr[OutIndex] := #0;
      UTF8StrNew:=ResultPtr;
  end;
  

  function utf8strlcopyucs4(src: pchar; dst: pucs4char; maxlen: integer): pucs4char;
  var
   ch: ucs4char;
   i: integer;
   StringLength: integer;
   Outindex: integer;
   ExtraBytesToRead: integer;
   CurrentIndex: integer;
   stringarray: pucs4strarray;
  
  begin
    utf8strlcopyucs4:=nil;
    if not assigned(src) then
      exit;
    if not assigned(dst) then
      exit;
    i:=0;
    stringarray:=pointer(dst);
    stringlength := 0;
    OutIndex := 1;
    while (src[i] <> #0) and (i < maxlen) do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            exit;
          end;
{        if not isLegalUTF8(src, extraBytesToRead+1) then
          begin
            exit;
          end;}
        CurrentIndex := ExtraBytesToRead;
        if CurrentIndex = 5 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 4 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 0 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
        end;
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        if (ch <= UNI_MAX_UTF32) then
          begin
            stringarray^[OutIndex] := ch;
            inc(OutIndex);
          end
        else
          begin
            stringarray^[OutIndex] := UNI_REPLACEMENT_CHAR;
            inc(OutIndex);
          end;
      end;
      stringarray^[outindex] := 0;
      utf8strlcopyucs4:=dst;
  end;
  
  
  function utf8strpastoISO8859_1(src: pchar): string;
  var
   ch: ucs4char;
   s: string;
   i: integer;
   StringLength: integer;
   Outindex: integer;
   ExtraBytesToRead: integer;
   CurrentIndex: integer;
  begin
    i:=0;
    setlength(s,0);
    utf8strpastoISO8859_1:='';
    if not assigned(src) then
       exit;
    stringlength := 0;
    OutIndex := 1;
    while i < strlen(src) do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            exit;
          end;
        CurrentIndex := ExtraBytesToRead;
        if CurrentIndex = 5 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 4 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 0 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
        end;
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        if (ch <= UNI_MAX_UTF32) then
          begin
            if ch > 255 then
              begin
                s:= s + '\u' + hexstr(ch,8);
              end
            else
               s:=s+chr(ch and $ff);
            inc(OutIndex);
          end
        else
          begin
            if ch > 255 then
              begin
                s:= s + '\u' + hexstr(ch,8);
              end
            else
               s:=s+chr(ch and $ff);
            inc(OutIndex);
          end;
      end;
     utf8strpastoISO8859_1:=s;      
  end;
  

  function utf8strpastoascii(src: pchar): string;
  var
   ch: ucs4char;
   s: string;
   i: integer;
   StringLength: integer;
   Outindex: integer;
   ExtraBytesToRead: integer;
   CurrentIndex: integer;
  begin
    i:=0;
    setlength(s,0);
    utf8strpastoASCII:='';
    if not assigned(src) then
       exit;
    stringlength := 0;
    OutIndex := 1;
    while i < strlen(src) do
      begin
        ch := 0;
        extrabytestoread:= trailingBytesForUTF8[ord(src[i])];
        if (stringlength + extraBytesToRead) >= high(ucs4string) then
          begin
            exit;
          end;
        CurrentIndex := ExtraBytesToRead;
        if CurrentIndex = 5 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 4 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 3 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 2 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 1 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
          ch:=ch shl 6;
          dec(CurrentIndex);
        end;
        if CurrentIndex = 0 then
        begin
          ch:=ch + ucs4char(src[i]);
          inc(i);
        end;
        ch := ch - offsetsFromUTF8[extraBytesToRead];
        if (ch <= UNI_MAX_UTF32) then
          begin
            if ch > 127 then
              begin
                s:= s + '\u' + hexstr(ch,8);
              end
            else
               s:=s+chr(ch and $7f);
            inc(OutIndex);
          end
        else
          begin
            if ch > 127 then
              begin
                s:= s + '\u' + hexstr(ch,8);
              end
            else
               s:=s+chr(ch and $7f);
            inc(OutIndex);
          end;
      end;
     utf8strpastoASCII:=s;      
  end;
  
  
  function ucs2_isvalid(ch: ucs2char): boolean;
  begin
    ucs2_isvalid := true;
    if ((ch >=  UNI_SUR_HIGH_START) and (ch <= UNI_SUR_HIGH_END)) or
           ((ch >=  UNI_SUR_LOW_START) and (ch <= UNI_SUR_LOW_END)) then
    begin 
      ucs2_isvalid := false;
    end;
  end;
  
  
{---------------------------------------------------------------------------
                   UCS-2 null terminated string handling
-----------------------------------------------------------------------------}
  
  function ucs2strlcopyucs4(src: pucs2char; dst: pucs4char; maxlen: integer): pucs4char;
  var
   i: integer;
   Outindex: integer;
   stringarray: pucs4strarray;
   srcarray: pucs2strarray;  
  begin
    ucs2strlcopyucs4:=nil;
    if not assigned(src) then
      exit;
    if not assigned(dst) then
      exit;
    i:=0;
    stringarray:=pointer(dst);
    srcarray:=pointer(src);
    OutIndex := 0;
    while (srcarray^[i] <> 0) and (i < maxlen) do
      begin
        stringarray^[outindex]:=srcarray^[i];
        inc(outindex);
        inc(i);
      end;
      stringarray^[outindex] := 0;
      ucs2strlcopyucs4:=dst;
  end;
  
  
  function ucs2strnew(src: pucs4char): pucs2char;
  var
   ch: ucs4char;
   i: integer;
   StartIndex, EndIndex: integer;
   srcarray: pucs4strarray;
   sizetoalloc: integer;
   buffer: pucs2char;
   dst: pucs2strarray;
  begin
    ucs2strnew := nil;
    srcarray:=pointer(src);
    sizetoalloc := ucs4strlen(src)+sizeof(ucs2char);
    { Check if only one character is passed as src, in that case
      this is not an UTF string, but a simple character (in other
      words, there is not a length byte.
    }
    StartIndex:=0;
    EndIndex:=0;
    Getmem(buffer,sizetoalloc);
    fillchar(buffer^,sizetoalloc,#0);
    dst:=pucs2strarray(buffer);
    
  
    for i:=StartIndex to EndIndex do
      begin
        ch:=srcarray^[i];
        { this character encoding cannot be represented }
        if ch > UNI_MAX_BMP then
          begin 
            Freemem(buffer, sizetoalloc);
            exit;
          end;
        dst^[i]:=ucs2char(ch and UNI_MAX_BMP);
      end;
      dst^[EndIndex]:=0;
      ucs2strnew:=pucs2char(buffer);
  end;

  function ucs2strdispose(str: pucs2char): pucs2char;
  begin
    ucs2strdispose := nil;
    if not assigned(str) then 
      exit;
    Freemem(str,ucs2strlen(str)+sizeof(ucs2char));
    str:=nil;
  end;
  
  
  function ucs2strlen(str: pucs2char): integer;
  var
   counter : Longint;
   stringarray: pucs2strarray;
 Begin
   ucs2strlen:=0;
   if not assigned(str) then
     exit;
   stringarray := pointer(str);
   counter := 0;
   while stringarray^[counter] <> 0 do
     Inc(counter);
   ucs2strlen := counter;
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
  Revision 1.13  2004/08/22 20:42:16  carl
    * range check error fix (memory read past end of buffer)

  Revision 1.12  2004/08/19 01:07:38  carl
    * other bugfix with memory corruption when copying the data

  Revision 1.11  2004/08/19 00:17:12  carl
    + renamed all basic types to use the UCS-4 type name instead.
    + Unicode case conversion of characters
    * several bugfixes in memory allocation with strings containing null characters

  Revision 1.10  2004/08/01 05:33:02  carl
    + more UTF-8 encoding routines
    * small bugfix in certain occasions with UCS-4 conversion

  Revision 1.9  2004/07/15 01:04:12  carl
    * small bugfixes
    - remove compiler warnings

  Revision 1.8  2004/07/05 02:38:15  carl
    + add collects unit
    + some small changes in cases of identifiers

  Revision 1.7  2004/07/05 02:27:32  carl
    - remove some compiler warnings
    + UCS-4 null character string handling routines
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
     + add support for ISO8859, ASCII, CP850, CP1252 to UCS-4 conversion
       (and vice-versa)
     + add support for UCS-4 to UCS-2 conversion
     * bugfixes in conversion routines for UCS-4
     + updated documentation

  Revision 1.1  2004/05/05 16:28:22  carl
    Release 0.95 updates


}
  


