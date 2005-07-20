{
 ****************************************************************************
    $Id: locale.pas,v 1.12 2005-07-20 03:13:00 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Localization and date/time unit

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}

{** 
    @author(Carl Eric Codere)
    @abstract(Localisation unit)
    This unit is used to convert different 
    locale information. ISO Standards are
    used where appropriate.

    The exact representations that are supported
    are the following:
      Calendar Date: Complete Representation - basic
      Caldedar Date: Complete Representation - extended
      Calendar Date: Representations with reduced precision
      Time of the day: Local time of the day: Complete representation - basic
      Time of the day: Local time of the day: Complete representation - extended
      Time of the day: UTC Time : Complete representation - basic
      Time of the day: UTC Time: Complete representation - extended
      Time of the day: Local and UTC Time: extended format
    
    Credits where credits are due, information
    on the ISO and date formats where taken from
    http://www.cl.cam.ac.uk/~mgk25/iso-time.html
}
unit locale;


interface

uses
  dpautils,
  vpautils,
  fpautils,
  gpautils,
  tpautils;

{** Returns the extended format representation of a date as recommended
    by ISO 8601 (Gregorian Calendar).

    Returns an empty string if there is an error. The extended
    representation separates each member (year,month,day) with a dash
    character (-).

    @param(year Year of the date - valid values are from 0000 to 9999)
    @param(month Month of the date - valid values are from 0 to 12)
    @param(day Day of the month - valid values are from 1 to 31)
}
function GetISODateString(Year, Month, Day: Word): shortstring;

{** Returns the basic format representation of a date as recommended
    by ISO 8601 (Gregorian Calendar).

    Returns an empty string if there is an error.

    @param(year Year of the date - valid values are from 0000 to 9999)
    @param(month Month of the date - valid values are from 0 to 12)
    @param(day Day of the month - valid values are from 1 to 31)
}
function GetISODateStringBasic(Year, Month, Day: Word): shortstring;


{** @abstract(Verifies if the date is in a valid ISO 8601 format)

    @param(datestr Date string in valid ISO 8601 format)
    @param(strict If set, the format must exactly be
      YYYYMMDD or YYYY-MM-DD. If not set, less precision
      is allowed)
    @returns(TRUE if the date string is valid otherwise false)
}
function IsValidISODateString(datestr: shortstring; strict: boolean): boolean;

{** @abstract(Verifies if the time is in a valid ISO 8601 format)

    Currently does not support the fractional second parameters,
    and only the extemded time format recommended by W3C when used
    with the time zone designator.

    @param(timestr Time string in valid ISO 8601 format)
    @param(strict The value must contain all the required
      parameters with UTC, either in basic or extended format
      to be valid)
    @returns(TRUE if the time string is valid otherwise false)
}
function IsValidISOTimeString(timestr: shortstring; strict: boolean): boolean;

{** @abstract(Verifies if the date and time is in a valid ISO 8601 format)

    Currently does not support the fractional second parameters,
    and only the format recommended by W3C when used with the
    time zone designator. Also validates an entry if it only
    contains the date component (it is automatically detected).

    @param(str Date-Time string in valid ISO 8601 format)
    @param(strict If set to TRUE then the complete representation must
      be present, either in basic or extended format to consider
      the date and time valid)
    @returns(TRUE if the date-time string is valid otherwise false)
}
function IsValidISODateTimeString(str: shortstring; strict: boolean): boolean;

{** Returns the extended format representation of a time as recommended
    by ISO 8601 (Gregorian Calendar).

    Returns an empty string if there is an error. The extended
    representation separates each member (hour,minute,second) with a colon
    (:).
}
function GetISOTimeString(Hour, Minute, Second: Word; UTC: Boolean):
  shortstring;

{** Returns the basic format representation of a time as recommended
    by ISO 8601 (Gregorian Calendar).

    Returns an empty string if there is an error. The extended
    representation separates each member (hour,minute,second) with a colon
    (:).
}
function GetISOTimeStringBasic(Hour, Minute, Second: Word; UTC: Boolean):
  shortstring;


function GetISODateTimeString(Year, Month, Day, Hour, Minute, Second: Word; UTC:
  Boolean): shortstring;

{** Converts a UNIX styled time (the number of seconds since 1970)
    to a standard date and time representation.
}
procedure UNIXToDateTime(epoch: big_integer_t; var year, month, day, hour, minute, second:
  Word);

{** Using a registered ALIAS name for a specific character encoding,
    return the common or MIME name associated with this character set, 
    and indicate the type of stream format used. The type of stream 
    format used can be one of the @code(CHAR_ENCODING_XXXX) constants.
}
function GetCharEncoding(alias: string; var _name: string): integer;

{** Using a code page identifier (as defined by Microsoft and OS/2)
    return the resulting IANA encoding alias string }    
function MicrosoftCodePageToMIMECharset(cp: word): string;

{** Using a code page identifier (as defined by Microsoft and OS/2)
    return the resulting IANA encoding alias string }    
function MicrosoftLangageCodeToISOCode(langcode: integer): string;


const
  {** @abstract(Character encoding value: UTF-8 storage format)}
  CHAR_ENCODING_UTF8 = 0;
  {** @abstract(Character encoding value: unknown format)}
  CHAR_ENCODING_UNKNOWN = -1;
  {** @abstract(Character encoding value: UTF-32 Big endian)}
  CHAR_ENCODING_UTF32BE = 1;
  {** @abstract(Character encoding value: UTF-32 Little endian)}
  CHAR_ENCODING_UTF32LE = 2;
  {** @abstract(Character encoding value: UTF-16 Little endian)}
  CHAR_ENCODING_UTF16LE = 3;
  {** @abstract(Character encoding value: UTF-16 Big endian)}
  CHAR_ENCODING_UTF16BE = 4;
  {** @abstract(Character encoding value: One byte per character storage format)}
  CHAR_ENCODING_BYTE = 5;
  {** @abstract(Character encoding value: UTF-16 unknown endian (determined by BOM))}
  CHAR_ENCODING_UTF16 = 6;
  {** @abstract(Character encoding value: UTF-32 unknown endian (determined by BOM))}
  CHAR_ENCODING_UTF32 = 7;



implementation

uses utils,strings;

{ IANA Registered character set table }
{$i charset.inc}
{ Character encodings }
{$i charenc.inc}

type
{ Code page conversion table }
  tmscodepage = record
    value: word;
    alias: pchar;
  end;
  
{** Structure to convert a Microsoft language code
    to an ISO 639 2-character language identifier }
tmslangcode = record
  code: byte;
  id: string[2];   
end;

  
  
const  
  MAX_CODEPAGES = 151;
  mscodepageinfo: array[1..MAX_CODEPAGES] of tmscodepage =
  (
    (value:     0; alias: 'ISO-8859-1'),
    (value:   037; alias: 'EBCDIC-US'),
    (value:   437; alias: 'IBM437'),
    (value:   500; alias: 'IBM01148'),
    (value:   708; alias: 'ISO-8859-6'),  { Arabic - ASMO 708 }
    (value:   709; alias: 'ASMO_449'),    { 709 Arabic - ASMO 449+, BCON V4  }
    (value:   710; alias: ''),            { 710 Arabic - Transparent Arabic  }
    (value:   720; alias: ''),            { 720 Arabic - Transparent ASMO    }
    (value:   737; alias: ''),            { 737 OEM - Greek (formerly 437G)  }
    (value:   775; alias: 'IBM775'),      { OEM - Baltic                     }
    (value:   850; alias: 'IBM850'),      { 850 OEM - Multilingual Latin I   }
    (value:   852; alias: 'IBM852'),      { OEM - Latin II                   }
    (value:   855; alias: 'IBM855'),      { OEM - Cyrillic (primarily Russian) }
    (value:   857; alias: 'IBM857'),      { OEM - Turkish                    }
    (value:   858; alias: 'IBM00858'),    { OEM - Multlingual Latin I + Euro symbol }
    (value:   860; alias: 'IBM860'),      { OEM - Portuguese                 }  
    (value:   861; alias: 'IBM861'),      { OEM - Icelandic                  }
    (value:   862; alias: 'IBM862'),      { OEM - Hebrew                     }
    (value:   863; alias: 'IBM863'),      { OEM - Canadian-French            }
    (value:   864; alias: 'IBM864'),      { OEM - Arabic                     }
    (value:   865; alias: 'IBM865'),      { OEM - Nordic                     }
    (value:   866; alias: 'IBM866'),      { OEM - Russian                    } 
    (value:   869; alias: 'IBM869'),      { OEM - Modern Greek               }
    (value:   870; alias: 'IBM870'),      { IBM EBCDIC - Multilingual/ROECE (Latin-2)  }
    (value:   874; alias:       ''),      { ANSI/OEM - Thai (same as 2(value:   8605, ISO (value:   8(value:   859-15) }
    (value:   875; alias:       ''),      { IBM EBCDIC - Modern Greek        } 
    (value:   932; alias: 'SHIFT_JIS'),   { ANSI/OEM - Japanese, Shift-JIS   }  
    (value:   936; alias:          ''),   {  ANSI/OEM - Simplified Chinese (PRC, Singapore) } 
    (value:   949; alias:          ''),   {  ANSI/OEM - Korean (Unified Hangeul Code) }
    (value:   950; alias:          ''),   {  ANSI/OEM - Traditional Chinese (Taiwan; Hong Kong SAR, PRC)  }
    (value:  1026; alias:   'IBM1026'),   {  IBM EBCDIC - Turkish (Latin-5)  }
    (value:  1047; alias:   'IBM1047'),   {  IBM EBCDIC - Latin 1/Open System  }
    (value:  1140; alias:  'IBM01140'),   {  IBM EBCDIC - U.S./Canada (037 + Euro symbol) }
    (value:  1141; alias:  'IBM01141'),   {  IBM EBCDIC - Germany (20273 + Euro symbol) }
    (value:  1142; alias:  'IBM01142'),   {  IBM EBCDIC - Denmark/Norway (20277 + Euro symbol) }
    (value:  1143; alias:  'IBM01143'),   {  IBM EBCDIC - Finland/Sweden (20278 + Euro symbol) }
    (value:  1144; alias:  'IBM01144'),   {  IBM EBCDIC - Italy (20280 + Euro symbol) }
    (value:  1145; alias:  'IBM01145'),   {  IBM EBCDIC - Latin America/Spain (20284 + Euro symbol) }
    (value:  1146; alias:  'IBM01146'),   {  IBM EBCDIC - United Kingdom (20285 + Euro symbol) }
    (value:  1147; alias:  'IBM01147'),   {  IBM EBCDIC - France (20297 + Euro symbol) }
    (value:  1148; alias:  'IBM01148'),   {  IBM EBCDIC - International (500 + Euro symbol) }
    (value:  1149; alias:  'IBM01149'),   {  IBM EBCDIC - Icelandic (20871 + Euro symbol) }
    (value:  1200; alias: 'UTF-16LE' ),   {  Unicode UCS-2 Little-Endian (BMP of ISO 10646) }
    (value:  1201; alias: 'UTF-16BE' ),   {  Unicode UCS-2 Big-Endian       }
    (value:  1250; alias:'WINDOWS-1250'), {  ANSI - Central European        }
    (value:  1251; alias:'WINDOWS-1251'), {  ANSI - Cyrillic                }
    (value:  1252; alias:'WINDOWS-1252'), {  ANSI - Latin I                 }
    (value:  1253; alias:'WINDOWS-1253'), {  ANSI - Greek                   }
    (value:  1254; alias:'WINDOWS-1254'), {  ANSI - Turkish                 }
    (value:  1255; alias:'WINDOWS-1255'), {  ANSI - Hebrew                  }
    (value:  1256; alias:'WINDOWS-1256'), {  ANSI - Arabic                  }
    (value:  1257; alias:'WINDOWS-1257'), {  ANSI - Baltic                  }
    (value:  1258; alias:'WINDOWS-1258'), {  ANSI/OEM - Vietnamese          }
    (value:  1361; alias:          ''),   {  Korean (Johab)                 }
    (value: 10000; alias:'MACINTOSH' ),   {  MAC - Roman                    }
    (value: 10001; alias:          ''),   {  MAC - Japanese                 }
    (value: 10002; alias:          ''),   {  MAC - Traditional Chinese (Big5)} 
    (value: 10003; alias:          ''),   {  MAC - Korean                   }
    (value: 10004; alias:          ''),   {  MAC - Arabic                   }
    (value: 10005; alias:          ''),   {  MAC - Hebrew                   }
    (value: 10006; alias:          ''),   {  MAC - Greek I                  }
    (value: 10007; alias:          ''),   {  MAC - Cyrillic                 }
    (value: 10008; alias:          ''),   {  MAC - Simplified Chinese (GB 2312) }
    (value: 10010; alias:          ''),   {  MAC - Romania                  }
    (value: 10017; alias:          ''),   {  MAC - Ukraine                  }
    (value: 10021; alias:          ''),   {  MAC - Thai                     }
    (value: 10029; alias:          ''),   {  MAC - Latin II                 }
    (value: 10079; alias:          ''),   {  MAC - Icelandic                }
    (value: 10081; alias:          ''),   {  MAC - Turkish                  }
    (value: 10082; alias:          ''),   {  MAC - Croatia                  }
    (value: 12000; alias:  'UTF-32LE'),   {  Unicode UCS-4 Little-Endian    }
    (value: 12001; alias:  'UTF-32BE'),   {  Unicode UCS-4 Big-Endian       }
    (value: 20000; alias:          ''),   {  CNS - Taiwan                   }
    (value: 20001; alias:          ''),   {  TCA - Taiwan                   }
    (value: 20002; alias:          ''),   {  Eten - Taiwan                  }
    (value: 20003; alias:          ''),   {  IBM5550 - Taiwan               }
    (value: 20004; alias:          ''),   {  TeleText - Taiwan              }
    (value: 20005; alias:          ''),   {  Wang - Taiwan                  }
    (value: 20105; alias:          ''),   {  IA5 IRV International Alphabet No. 5 (7-bit) }
    (value: 20106; alias:          ''),   {  IA5 German (7-bit)             }
    (value: 20107; alias:          ''),   {  IA5 Swedish (7-bit)            }
    (value: 20108; alias:          ''),   {  IA5 Norwegian (7-bit)          }
    (value: 20127; alias:  'US-ASCII'),   {  US-ASCII (7-bit)               }
    (value: 20261; alias: 'T.61-8BIT'),   {  T.61                           }
    (value: 20269; alias:'ISO_6937-2-25'),{  ISO 6937 Non-Spacing Accent    }
    (value: 20273; alias:          ''),   {  IBM EBCDIC - Germany           }
    (value: 20277; alias:          ''),   {  IBM EBCDIC - Denmark/Norway    }
    (value: 20278; alias:          ''),   {  IBM EBCDIC - Finland/Sweden    }
    (value: 20280; alias:          ''),   {  IBM EBCDIC - Italy             }
    (value: 20284; alias:          ''),   {  IBM EBCDIC - Latin America/Spain }
    (value: 20285; alias:          ''),   {  IBM EBCDIC - United Kingdom    }
    (value: 20290; alias:          ''),   {  IBM EBCDIC - Japanese Katakana Extended }
    (value: 20297; alias:          ''),   {  IBM EBCDIC - France            }
    (value: 20420; alias:          ''),   {  IBM EBCDIC - Arabic            }
    (value: 20423; alias:          ''),   {  IBM EBCDIC - Greek             }
    (value: 20424; alias:          ''),   {  IBM EBCDIC - Hebrew            }
    (value: 20833; alias:          ''),   {  IBM EBCDIC - Korean Extended   }
    (value: 20838; alias:          ''),   {  IBM EBCDIC - Thai              }
    (value: 20866; alias:   'KOI8-R' ),   {  Russian - KOI8-R               }
    (value: 20871; alias:          ''),   {  IBM EBCDIC - Icelandic         }
    (value: 20880; alias:          ''),   {  IBM EBCDIC - Cyrillic (Russian) }
    (value: 20905; alias:          ''),   {  IBM EBCDIC - Turkish           }
    (value: 20924; alias:          ''),   {  IBM EBCDIC - Latin-1/Open System (1047 + Euro symbol) }
    (value: 20932; alias:          ''),   {  JIS X 0208-1990 & 0121-1990    }
    (value: 20936; alias:    'GB2312'),   {  Simplified Chinese (GB2312)    }
    (value: 21025; alias:          ''),   {  IBM EBCDIC - Cyrillic (Serbian, Bulgarian) }
    (value: 21027; alias:          ''),   {  Extended Alpha Lowercase       }
    (value: 21866; alias:    'KOI8-U'),   {  Ukrainian (KOI8-U)             }
    (value: 28591; alias:'ISO-8859-1'),   {  ISO 8859-1 Latin I             }
    (value: 28592; alias:'ISO-8859-2'),   {  ISO 8859-2 Central Europe      }
    (value: 28593; alias:'ISO-8859-3'),   {  ISO 8859-3 Latin 3             }
    (value: 28594; alias:'ISO-8859-4'),   {  ISO 8859-4 Baltic              }
    (value: 28595; alias:'ISO-8859-5'),   {  ISO 8859-5 Cyrillic            }
    (value: 28596; alias:'ISO-8859-6'),   {  ISO 8859-6 Arabic              }
    (value: 28597; alias:'ISO-8859-7'),   {  ISO 8859-7 Greek               }
    (value: 28598; alias:'ISO-8859-8'),   {  ISO 8859-8 Hebrew              }
    (value: 28599; alias:'ISO-8859-1'),   {  ISO 8859-9 Latin 5             }
    (value: 28605; alias:'ISO-8859-15'),  {  ISO 8859-15 Latin 9            }
    (value: 29001; alias:          ''),   {  Europa 3                       }
    (value: 38598; alias:'ISO-8859-8'),   {  ISO 8859-8 Hebrew              }
    (value: 50220; alias:'ISO-2022-JP'),   {  ISO 2022 Japanese with no halfwidth Katakana }
    (value: 50221; alias:          ''),   {  ISO 2022 Japanese with halfwidth Katakana }
    (value: 50222; alias:          ''),   {  ISO 2022 Japanese JIS X 0201-1989 }
    (value: 50225; alias:'ISO-2022-KR'),  {  ISO 2022 Korean        `       }
    (value: 50227; alias:'ISO-2022-CN'),   {  ISO 2022 Simplified Chinese    }
    (value: 50229; alias:          ''),   {  ISO 2022 Traditional Chinese   }
    (value: 50930; alias:          ''),   {  Japanese (Katakana) Extended   }
    (value: 50931; alias:          ''),   {  US/Canada and Japanese         }
    (value: 50933; alias:          ''),   {  Korean Extended and Korean     }
    (value: 50935; alias:          ''),   {  Simplified Chinese Extended and Simplified Chinese }
    (value: 50936; alias:          ''),   {  Simplified Chinese             }
    (value: 50937; alias:          ''),   {  US/Canada and Traditional Chinese }
    (value: 50939; alias:          ''),   {  Japanese (Latin) Extended and Japanese }
    (value: 51932; alias:    'EUC-JP'),   {  EUC - Japanese                 }
    (value: 51936; alias:          ''),   {  EUC - Simplified Chinese       }
    (value: 51949; alias:    'EUC-KR'),   {  EUC - Korean                   }
    (value: 51950; alias:          ''),   {  EUC - Traditional Chinese      }
    (value: 52936; alias:          ''),   {  HZ-GB2312 Simplified Chinese   }
    (value: 54936; alias:   'GB18030'),   {  Windows XP: GB18030 Simplified Chinese (4 Byte)  }
    (value: 57002; alias:          ''),   {  ISCII Devanagari               }
    (value: 57003; alias:          ''),   {  ISCII Bengali                  }
    (value: 57004; alias:          ''),   {  ISCII Tamil                    }
    (value: 57005; alias:          ''),   {  ISCII Telugu                   }
    (value: 57006; alias:          ''),   {  ISCII Assamese                 }
    (value: 57007; alias:          ''),   {  ISCII Oriya                    }
    (value: 57008; alias:          ''),   {  ISCII Kannada                  }
    (value: 57009; alias:          ''),   {  ISCII Malayalam                }
    (value: 57010; alias:          ''),   {  ISCII Gujarati                 }
    (value: 57011; alias:          ''),   {  ISCII Punjabi                  }
    (value: 65000; alias:     'UTF-7'),   {  Unicode UTF-7                  }
    (value: 65001; alias:     'UTF-8')    {  Unicode UTF-8                  }
);

MAX_MSLANGCODES = 77;

mslanguagecodes: array[1..MAX_MSLANGCODES] of tmslangcode =
(
   (code: $00 ;id:  ''), {  LANG_NEUTRAL Neutral }
   (code: $01 ;id:'ar'), {  LANG_ARABIC Arabic   }
   (code: $02 ;id:'bg'), {  LANG_BULGARIAN Bulgarian }
   (code: $03 ;id:'ca'), {  LANG_CATALAN Catalan } 
   (code: $04 ;id:'zh'), {  LANG_CHINESE Chinese }
   (code: $05 ;id:'cs'), {  LANG_CZECH Czech }
   (code: $06 ;id:'da'), {  LANG_DANISH Danish }
   (code: $07 ;id:'de'), {  LANG_GERMAN German }
   (code: $08 ;id:'el'), {  LANG_GREEK Greek }
   (code: $09 ;id:'en'), {  LANG_ENGLISH English } 
   (code: $0a ;id:'es'), {  LANG_SPANISH Spanish } 
   (code: $0b ;id:'fi'), {  LANG_FINNISH Finnish }
   (code: $0c ;id:'fr'), {  LANG_FRENCH French }
   (code: $0d ;id:'he'), {  LANG_HEBREW Hebrew }
   (code: $0e ;id:'hu'), {  LANG_HUNGARIAN Hungarian }
   (code: $0f ;id:'is'), {  LANG_ICELANDIC Icelandic }
   (code: $10 ;id:'it'), {  LANG_ITALIAN Italian }
   (code: $11 ;id:'ja'), {  LANG_JAPANESE Japanese } 
   (code: $12 ;id:'ko'), {  LANG_KOREAN Korean }
   (code: $13 ;id:'nl'), {  LANG_DUTCH Dutch }
   (code: $14 ;id:'nb'), {  LANG_NORWEGIAN Norwegian }
   (code: $15 ;id:'pl'), {  LANG_POLISH Polish }
   (code: $16 ;id:'pt'), {  LANG_PORTUGUESE Portuguese }
   (code: $18 ;id:'ro'), {  LANG_ROMANIAN Romanian }
   (code: $19 ;id:'ru'), {  LANG_RUSSIAN Russian }
   (code: $1a ;id:'hr'), {  LANG_CROATIAN Croatian }
   (code: $1a ;id:'sr'), {  LANG_SERBIAN Serbian }
   (code: $1b ;id:'sk'), {  LANG_SLOVAK Slovak }
   (code: $1c ;id:'sq'), {  LANG_ALBANIAN Albanian }
   (code: $1d ;id:'sv'), {  LANG_SWEDISH Swedish  }
   (code: $1e ;id:'th'), {  LANG_THAI Thai }
   (code: $1f ;id:'tr'), {  LANG_TURKISH Turkish  }
   (code: $20 ;id:'ur'), {  LANG_URDU Urdu }
   (code: $21 ;id:'id'), {  LANG_INDONESIAN Indonesian }
   (code: $22 ;id:'uk'), {  LANG_UKRAINIAN Ukrainian }
   (code: $23 ;id:'be'), {  LANG_BELARUSIAN Belarusian }
   (code: $24 ;id:'sl'), {  LANG_SLOVENIAN Slovenian }
   (code: $25 ;id:'et'), {  LANG_ESTONIAN Estonian }
   (code: $26 ;id:'lv'), {  LANG_LATVIAN Latvian }
   (code: $27 ;id:'lt'), {  LANG_LITHUANIAN Lithuanian }
   (code: $29 ;id:  ''), {  LANG_FARSI Farsi }
   (code: $2a ;id:'vi'), {  LANG_VIETNAMESE Vietnamese }
   (code: $2b ;id:'hy'), {  LANG_ARMENIAN Armenian }
   (code: $2c ;id:  ''), {  LANG_AZERI Azeri }
   (code: $2d ;id:'eu'), {  LANG_BASQUE Basque }
   (code: $2f ;id:'mk'), {  LANG_MACEDONIAN FYRO Macedonian }
   (code: $36 ;id:'af'), {  LANG_AFRIKAANS Afrikaans }
   (code: $37 ;id:'ka'), {  LANG_GEORGIAN Georgian }
   (code: $38 ;id:  ''), {  LANG_FAEROESE Faeroese }
   (code: $39 ;id:'hi'), {  LANG_HINDI Hindi }
   (code: $3e ;id:'ml'), {  LANG_MALAY Malay }
   (code: $3f ;id:'kk'), {  LANG_KAZAK Kazak }
   (code: $40 ;id:  ''), {  LANG_KYRGYZ Kyrgyz }
   (code: $41 ;id:'sw'), {  LANG_SWAHILI Swahili }
   (code: $43 ;id:'uz'), {  LANG_UZBEK Uzbek }
   (code: $44 ;id:'tt'), {  LANG_TATAR Tatar }
   (code: $45 ;id:'bn'), {  LANG_BENGALI Not supported. }
   (code: $46 ;id:'pa'), {  LANG_PUNJABI Punjabi }
   (code: $47 ;id:'gu'), {  LANG_GUJARATI Gujarati }
   (code: $48 ;id:'or'), {  LANG_ORIYA Not supported. }
   (code: $49 ;id:'ta'), {  LANG_TAMIL Tamil }
   (code: $4a ;id:'te'), {  LANG_TELUGU Telugu }
   (code: $4b ;id:'kn'), {  LANG_KANNADA Kannada }
   (code: $4c ;id:'ml'), {  LANG_MALAYALAM Not supported. }
   (code: $4d ;id:'as'), {  LANG_ASSAMESE Not supported. }
   (code: $4e ;id:'mr'), {  LANG_MARATHI Marathi }
   (code: $4f ;id:'sa'), {  LANG_SANSKRIT Sanskrit }
   (code: $50 ;id:'mn'), {  LANG_MONGOLIAN Mongolian }
   (code: $56 ;id:'gl'), {  LANG_GALICIAN Galician }
   (code: $57 ;id:  ''), {  LANG_KONKANI Konkani }
   (code: $58 ;id:  ''), {  LANG_MANIPURI Not supported. }
   (code: $59 ;id:'sd'), {  LANG_SINDHI Not supported. }
   (code: $5a ;id:  ''), {  LANG_SYRIAC Syriac }
   (code: $60 ;id:'ks'), {  LANG_KASHMIRI Not supported. }
   (code: $61 ;id:'ne'), {  LANG_NEPALI Not supported. }
   (code: $65 ;id:'dv'), {  LANG_DIVEHI Divehi }
   (code: $7f ;id:  '')  {  LANG_INVARIANT   }
);

function fillwithzeros(s: shortstring; newlength: Integer): shortstring;
begin
  while length(s) < newlength do s:='0'+s;
  fillwithzeros:=s;
end;


function GetISODateString(Year,Month,Day:Word): shortstring;
var
  yearstr:string[4];
  monthstr: string[2];
  daystr: string[2];
begin
  GetISODateString := '';
  if year > 9999 then exit;
  if Month > 12 then exit;
  if day > 31 then exit;
  str(year,yearstr);
  str(month,monthstr);
  str(day,daystr);
  GetIsoDateString := fillwithzeros(yearstr,4)+'-'+ fillwithzeros(monthstr,2)+
    '-'+ fillwithzeros(daystr,2);
end;

function GetISODateStringBasic(Year,Month,Day:Word): shortstring;
var
  yearstr:string[4];
  monthstr: string[2];
  daystr: string[2];
begin
  GetISODateStringBasic := '';
  if year > 9999 then exit;
  if Month > 12 then exit;
  if day > 31 then exit;
  str(year,yearstr);
  str(month,monthstr);
  str(day,daystr);
  GetIsoDateStringBasic := fillwithzeros(yearstr,4)+ fillwithzeros(monthstr,2)
    + fillwithzeros(daystr,2);
end;

function GetISOTimeString(Hour,Minute,Second: Word; UTC: Boolean):
  shortstring;
var
  hourstr: string[2];
  minutestr: string[2];
  secstr: string[2];
  s: shortstring;
begin
  GetISOTimeString := '';
  if Hour > 23 then exit;
  if Minute > 59 then exit;
  { Don't  forget leap seconds! }
  if Second > 60 then exit;
  str(hour,hourstr);
  str(minute,minutestr);
  str(second,secstr);
  s := fillwithzeros(HourStr,2)+':'+ fillwithzeros(MinuteStr,2)+':'+
    fillwithzeros(SecStr,2);
  if UTC then s:=s+'Z';
  GetISOTimeString := s;
end;

function GetISOTimeStringBasic(Hour,Minute,Second: Word; UTC: Boolean):
  shortstring;
var
  hourstr: string[2];
  minutestr: string[2];
  secstr: string[2];
  s: shortstring;
begin
  GetISOTimeStringBasic := '';
  if Hour > 23 then exit;
  if Minute > 59 then exit;
  { Don't  forget leap seconds! }
  if Second > 60 then exit;
  str(hour,hourstr);
  str(minute,minutestr);
  str(second,secstr);
  s := fillwithzeros(HourStr,2)+ fillwithzeros(MinuteStr,2)+
    fillwithzeros(SecStr,2);
  if UTC then s:=s+'Z';
  GetISOTimeStringBasic := s;
end;


function GetISODateTimeString(Year,Month,Day,Hour,Minute,Second: Word; UTC:
  Boolean): shortstring;
var
  s1,s2: shortstring;
begin
  GetISODateTimeString:='';
  s1:=GetISODateString(year,month,day);
  if s1 = '' then exit;
  s2:=GetISOTimeString(Hour,Minute,Second,UTC);
  if s2 = '' then exit;
  GetISODatetimeString := s1 + 'T' + s2;
end;


const
{Date Calculation}
  C1970 = 2440588;
  D0 = 1461;
  D1 = 146097;
  D2 = 1721119;


procedure JulianToGregorian(JulianDN:big_integer_t;var Year,Month,Day:Word);
var
  YYear,XYear,Temp,TempMonth : longint;
begin
  Temp:=((JulianDN-D2) shl 2)-1;
  JulianDN:=Temp div D1;
  XYear:=(Temp mod D1) or 3;
  YYear:=(XYear div D0);
  Temp:=((((XYear mod D0)+4) shr 2)*5)-3;
  Day:=((Temp mod 153)+5) div 5;
  TempMonth:=Temp div 153;
  if TempMonth>=10 then
  begin
    inc(YYear);
    dec(TempMonth,12);
  end;
  inc(TempMonth,3);
  Month := TempMonth;
  Year:=YYear+(JulianDN*100);
end;



procedure UNIXToDateTime(epoch:big_integer_t;var year,month,day,hour,minute,second:
  Word);
{
  Transforms Epoch time into local time (hour, minute,seconds)
}
var
  DateNum: big_integer_t;
begin
  Datenum:=(Epoch div 86400) + c1970;
  JulianToGregorian(DateNum,Year,Month,day);
  Epoch:=longword(Abs(Epoch mod 86400));
  Hour:=Epoch div 3600;
  Epoch:=Epoch mod 3600;
  Minute:=Epoch div 60;
  Second:=Epoch mod 60;
end;


function isdigits(s: string):boolean;
var
 i: integer;
begin
 isdigits:=false;
 for I:=1 to length(s) do
   begin
     if not (s[i] in ['0'..'9']) then
        exit;
   end;
 isdigits:=true;
end;

function IsValidISODateString(datestr: shortstring; strict: boolean): boolean;
const
 DATE_SEPARATOR = '-';
var
 monthstr: string[2];
 yearstr: string[4];
 daystr: string[2];
 yearval: integer;
 monthval: integer;
 dayval: integer;
 code: integer;
begin
  IsValidIsoDateString:=false;
  monthstr:='';
  yearstr:='';
  daystr:='';
  { search the possible cases }
  case length(datestr) of
  { preferred format: YYYY-MM-DD }
  10:
      begin
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,6,2);
        daystr:=copy(datestr,9,2);
        if datestr[5] <> DATE_SEPARATOR then
           exit;
        if datestr[8] <> DATE_SEPARATOR then
           exit;
      end;
  { compact format: YYYYMMDD     }
   8:
      begin
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,5,2);
        daystr:=copy(datestr,7,2);
      end;
  { month format: YYYY-MM }
   7:
      begin
        if strict then exit;
        yearstr:=copy(datestr,1,4);
        monthstr:=copy(datestr,6,2);
        if datestr[5] <> DATE_SEPARATOR then
           exit;
      end;
  { year format : YYYY }
   4:
      begin
        if strict then exit;
        yearstr:=copy(datestr,1,4);
      end;
  else
     begin
        exit;
     end;
  end;
  if yearstr = '' then
    exit;
  { verify the validity of the year }
  if yearstr <> '' then
    begin
      if not isdigits(yearstr) then
         exit;
      val(yearstr,yearval,code);
      if code <> 0 then 
        exit;
    end;  
  { verify the validity of the year }
  if monthstr <> '' then
    begin
      if not isdigits(monthstr) then
         exit;
      val(monthstr,monthval,code);
      if code <> 0 then 
        exit;
      if (monthval < 1) or (monthval > 12) then
        exit;
    end;  
  { verify the validity of the year }
  if daystr <> '' then
    begin
      if not isdigits(daystr) then
         exit;
      val(daystr,dayval,code);
      if code <> 0 then 
        exit;
      if (dayval < 1) or (dayval > 31) then
        exit;
    end;  
    
  IsValidIsoDateString:=true;
end;    


function IsValidISOTimeString(timestr: shortstring; strict: boolean): boolean;
const
 TIME_SEPARATOR = ':';
var
 hourstr: string[2];
 secstr: string[2];
 minstr: string[2];
 offsetminstr: string[2];
 offsethourstr: string[2];
 offsetminval: integer;
 offsethourval: integer;
 minval: integer;
 secval: integer;
 hourval: integer;
 code: integer;
begin
  IsValidIsoTimeString:=false;
  minstr:='';
  secstr:='';
  hourstr:='';
  offsethourstr:='';
  offsetminstr:='';
  { search the possible cases }
  case length(timestr) of  
  { preferred format: hh:mm:ss }
  8,9,11,14:
      begin
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,4,2);
        secstr:=copy(timestr,7,2);
        if timestr[3] <> TIME_SEPARATOR then
           exit;
        if timestr[6] <> TIME_SEPARATOR then
           exit;
        { With Z TZD }
        if length(timestr) = 9 then
          begin
            if timestr[length(timestr)] <> 'Z' then
              exit;
          end
        else
        if length(timestr) = 14 then
          begin
            if (timestr[9] in ['+','-']) and (timestr[12] = ':') then
              begin
                offsethourstr:=copy(timestr,10,2);
                offsetminstr:=copy(timestr,13,2);
              end
            else
              exit;
          end;
        if length(timestr) = 11 then
          begin
            if (timestr[9] in ['+','-']) then
              begin
                if strict then exit;
                offsethourstr:=copy(timestr,10,2);
                offsetminstr:='00';
              end
            else
              exit;
          end;

      end;
  { compact format: hhmmss     }
   6,7:
      begin
        { In strict format this is invalid }
        if strict then exit;
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,3,2);
        secstr:=copy(timestr,5,2);
        { With Z TZD }   
        if length(timestr) = 7 then
          begin
            if timestr[length(timestr)] <> 'Z' then
              exit;
          end
      end;
  { hour/min format: hh:mm }
   5: 
      begin
        { In strict format this is invalid }
        if strict then exit;
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,4,2);
        if timestr[3] <> TIME_SEPARATOR then
           exit;
      end;
  { compact hour:min format hhmm }
   4:
      begin
        { In strict format this is invalid }
        if strict then exit;
        hourstr:=copy(timestr,1,2);
        minstr:=copy(timestr,3,2);
      end;
  else
     begin
        exit;
     end;
  end;   
  if hourstr = '' then
    exit;
  { verify the validity of the time }
  if minstr <> '' then
    begin
      if not isdigits(minstr) then
         exit;
      val(minstr,minval,code);
      if code <> 0 then 
        exit;
      if (minval < 0) or (minval > 59) then
        exit;
    end;  
  { verify the validity of the year }
  if offsetminstr <> '' then
    begin
      if not isdigits(offsetminstr) then
         exit;
      val(offsetminstr,offsetminval,code);
      if code <> 0 then 
        exit;
      if (offsetminval < 0) or (offsetminval > 59) then
        exit;
    end;  
  if offsethourstr <> '' then
    begin
      if not isdigits(offsethourstr) then
         exit;
      val(offsethourstr,offsethourval,code);
      if code <> 0 then 
        exit;
      if (offsethourval < 0) or (offsethourval > 23) then
        exit;
    end;  
    
  { verify the validity of the year }
  if secstr <> '' then
    begin
      if not isdigits(secstr) then
         exit;
      val(secstr,secval,code);
      if code <> 0 then
        exit;
      { 60 because of possible leap seconds }  
      if (secval < 0) or (secval > 60) then
        exit;
    end;
  if hourstr <> '' then
    begin
      if not isdigits(hourstr) then
         exit;
      val(hourstr,hourval,code);
      if code <> 0 then
        exit;
      if (hourval < 0) or (hourval > 23) then
        exit;
    end;

  IsValidIsoTimeString:=true;
end;

function IsValidISODateTimeString(str: shortstring; strict: boolean): boolean;
var
 idx:integer;
begin
  IsValidISODateTimeString:=false;
  idx:=pos('T',str);
  if idx <> 0 then
    begin
      if IsValidISODateString(copy(str,1,idx-1),strict) then
         if IsValidISOTimeString(copy(str,idx+1,length(str)),strict) then
           IsValidISODateTimeString:=true;
    end
  else
    begin
      if IsValidISODateString(str,strict) then
         IsValidISODateTimeString:=true;
    end;
end;



function CompareString(s1,s2: shortstring): integer;
VAR I, J: integer; P1, P2: ^shortString;
  BEGIN
    P1 := @s1;                               { String 1 pointer }
    P2 := @s2;                               { String 2 pointer }
    If (Length(P1^)<Length(P2^)) Then 
      J := Length(P1^)
    Else 
      J := Length(P2^);                           { Shortest length }
    I := 1;                                            { First character }
    While (I<J) AND (P1^[I]=P2^[I]) Do 
      Inc(I);         { Scan till fail }
    If (I=J) Then 
      Begin                                { Possible match }
       If (P1^[I]<P2^[I]) Then 
        CompareString := -1 
       Else       { String1 < String2 }
       If (P1^[I]>P2^[I]) Then 
        CompareString := 1 
       Else      { String1 > String2 }
       If (Length(P1^)>Length(P2^)) Then 
        CompareString := 1 { String1 > String2 }
       Else 
       If (Length(P1^)<Length(P2^)) Then       { String1 < String2 }
        CompareString := -1 
       Else 
          CompareString := 0;           { String1 = String2 }
      End 
     Else 
     If (P1^[I]<P2^[I]) Then 
      CompareString := -1     { String1 < String2 }
     Else CompareString := 1;                               { String1 > String2 }
  END;

function GetCharEncoding(alias: string; var _name: string): integer;
  type
    tcharsets =  array[1..CHARSET_RECORDS] of charsetrecord;
    pcharsets = ^tcharsets;
  var
    L,H,C,I,j: integer;
    Search: boolean;
    Index: integer;
    char_sets: pcharsets;
{$ifdef tp}    
    p: pchar;
{$endif}    
  begin
    _name:='';
    alias:=upstring(alias);
    { Search for the appropriate name }
    GetCharEncoding:=CHAR_ENCODING_UNKNOWN;
    if alias = '' then exit;
    new(char_sets);
{$ifdef tp}
    p:=@charsetsproc;
    move(p^,char_sets^,sizeof(tcharsets));
{$else}    
    move(charsets,char_sets^,sizeof(tcharsets));
{$endif}
    Search:=false;
    { Search for the name }
    L := 1;                                            { Start count }
    H := CHARSET_RECORDS;                              { End count }
    While (L <= H) Do
      Begin
        I := (L + H) SHR 1;                            { Mid point }
        C := CompareString(char_sets^[I].setname, alias);   { Compare with key }
        If (C < 0) Then 
          L := I + 1 
        Else 
        Begin            { Item to left }
          H := I - 1;                                   { Item to right }
          If C = 0 Then 
            Begin                                       { Item match found }
              Search := True;                           { Result true }
            End;
        End;
      End;
    Index := L;                                        { Return result }
    { If the value has been found, then easy, nothing else to do }
    if Search then
      begin
        _name:=char_sets^[index].setname;
        getcharencoding:=charencoding[index].encoding;
        dispose(char_sets);
        exit;
      end;  
    { not found, then search for all aliases }
    for i:=1 to CHARSET_RECORDS do
      begin
        for j:=1 to CHARSET_MAX_ALIASES do
          begin
            if alias = char_sets^[i].aliases[j] then
              begin
                _name:=char_sets^[i].setname;
                getcharencoding:=charencoding[i].encoding;
                dispose(char_sets);
                exit;
              end
            else
            { no more entries, stop the loop }
            if char_sets^[i].aliases[j] = '' then
              break;
          end;
      end;
    dispose(char_sets);
  end;
  

function MicrosoftCodePageToMIMECharset(cp: word): string;
var
 i: integer;
begin
  MicrosoftCodePageToMIMECharset:='';
  for i:=1 to MAX_CODEPAGES do
    begin
     if mscodepageinfo[i].value = cp then
       begin
         MicrosoftCodePageToMIMECharset:=strpas(mscodepageinfo[i].alias);
         exit;
       end;
    end;
end;
  
function MicrosoftLangageCodeToISOCode(langcode: integer): string;
var
 i: integer;
begin
  MicrosoftLangageCodeToISOCode:='';
  for i:=1 to MAX_MSLANGCODES do
    begin
       if mslanguagecodes[i].code = langcode then
        begin
          MicrosoftLangageCodeToISOCode:=mslanguagecodes[i].id;
          exit;
        end;
    end;
end;


end.

{
  $Log: not supported by cvs2svn $
  Revision 1.11  2004/11/29 03:49:16  carl
    + routines to convert Microsoft code pages and languages to MIME/IETF types
    * Validation of ISO date and time strings also support now strict checking.

  Revision 1.10  2004/11/09 03:52:47  carl
    * IsValidISODateTime string would not accept simple dates as input.
    * some decoding with only minimal timezone information was not supported

  Revision 1.9  2004/10/31 19:51:33  carl
    * fix with leap seconds (leap seconds were not accepted)

  Revision 1.8  2004/10/13 23:24:35  carl
    + new routines for returning basic format dates and times

  Revision 1.7  2004/09/29 00:57:46  carl
    + added dateutil unit
    + added more support for parsing different ISO time/date strings

  Revision 1.6  2004/08/19 00:18:52  carl
    - no ansistring support in this unit

  Revision 1.5  2004/07/05 02:26:39  carl
    - remove some compiler warnings

  Revision 1.4  2004/06/20 18:49:39  carl
    + added  GPC support

  Revision 1.3  2004/06/17 11:46:25  carl
    + GetCharEncoding

  Revision 1.2  2004/05/13 23:04:06  carl
    + routines to verify the validity of ISO date/time strings

  Revision 1.1  2004/05/05 16:28:20  carl
    Release 0.95 updates

}





