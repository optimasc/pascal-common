type
charencoderecord = record
  name: string[CHARSET_LENGTH_NAME];
  encoding: smallint;
end;

const
charencoding: array[1..CHARSET_RECORDS] of charencoderecord= (
(
  name: 'ADOBE-STANDARD-ENCODING';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ADOBE-SYMBOL-ENCODING';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'AMIGA-1251';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ANSI_X3.110-1983';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ASMO_449';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'BIG5';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'BIG5-HKSCS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'BOCU-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'BS_4730';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'BS_VIEWDATA';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'CESU-8';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'CSA_Z243.4-1985-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'CSA_Z243.4-1985-2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'CSA_Z243.4-1985-GR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'CSN_369103';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'DEC-MCS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'DIN_66003';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'DS_2089';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-AT-DE';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-AT-DE-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-CA-FR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-DK-NO';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-DK-NO-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-ES';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-ES-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-ES-S';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-FI-SE';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-FI-SE-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-FR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-IT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-PT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-UK';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EBCDIC-US';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ECMA-CYRILLIC';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ES';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ES2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EUC-JP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EUC-KR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'EXTENDED_UNIX_CODE_FIXE';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GB18030';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GB2312';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GBK';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GB_1988-80';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GB_2312-80';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GOST_19768-74';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GREEK-CCITT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GREEK7';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'GREEK7-OLD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'HP-DESKTOP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'HP-LEGAL';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'HP-MATH8';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'HP-PI-FONT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'HP-ROMAN8';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'HZ-GB-2312';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM-SYMBOLS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM-THAI';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM00858';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM00924';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01140';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01141';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01142';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01143';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01144';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01145';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01146';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01147';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01148';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM01149';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM037';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM038';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM1026';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM1047';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM273';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM274';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM275';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM277';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM278';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM280';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM281';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM284';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM285';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM290';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM297';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM420';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM423';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM424';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM437';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM500';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM775';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM850';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'IBM851';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM852';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM855';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM857';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM860';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM861';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM862';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM863';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM864';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM865';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM866';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM868';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM869';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM870';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM871';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM880';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM891';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM903';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM904';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM905';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IBM918';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IEC_P27-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'INIS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'INIS-8';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'INIS-CYRILLIC';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'INVARIANT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-10646-J-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-10646-UCS-4';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-10646-UCS-BASIC';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-10646-UNICODE-LATIN1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-10646-UTF-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-2022-CN';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-2022-JP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-2022-JP-2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-2022-KR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-8859-1';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-1-WINDOWS-3.0-';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-8859-1-WINDOWS-3.1-';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-8859-10';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-13';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-14';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-15';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-16';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-2';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-2-WINDOWS-LATI';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-8859-3';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-4';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-5';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-6';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-6-E';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-8859-6-I';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-8859-7';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-8';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-8-E';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-8859-8-I';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-8859-9';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'ISO-8859-9-WINDOWS-LATI';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-IR-90';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-UNICODE-IBM-1264';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-UNICODE-IBM-1265';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-UNICODE-IBM-1268';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO-UNICODE-IBM-1276';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_10367-BOX';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_2033-1983';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_5427';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_5427:1981';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_5428:1980';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_646.BASIC:1983';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_6937-2-25';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_6937-2-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'ISO_8859-SUPP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'IT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6220-1969-RO';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6226-1978';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6226-1983';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6229-1984-A';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6229-1984-B';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6229-1984-B-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6229-1984-HAND';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6229-1984-HAND-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_C6229-1984-KANA';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_ENCODING';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JIS_X0212-1990';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JUS_I.B1.002';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JUS_I.B1.003-MAC';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'JUS_I.B1.003-SERB';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'KOI7-SWITCHED';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'KOI8-R';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'KOI8-U';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'KSC5636';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'KS_C_5601-1987';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'LATIN-GREEK';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'LATIN-GREEK-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'LATIN-LAP';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'MACINTOSH';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'MICROSOFT-PUBLISHING';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'MNEM';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'MSZ_7795.3';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NATS-DANO';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NATS-DANO-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NATS-SEFI';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NATS-SEFI-ADD';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NC_NC00-10:81';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NF_Z_62-010';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NF_Z_62-010_(1973)';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NS_4551-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'NS_4551-2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'OSD_EBCDIC_DF03_IRV';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'OSD_EBCDIC_DF04_1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'OSD_EBCDIC_DF04_15';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'PC8-DANISH-NORWEGIAN';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'PC8-TURKISH';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'PT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'PT2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'PTCP154';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'SCSU';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'SEN_850200_B';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'SEN_850200_C';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'SHIFT_JIS';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'T.101-G2';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'T.61-7BIT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'T.61-8BIT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'TIS-620';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'UNICODE-1-1';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'UNICODE-1-1-UTF-7';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'UNKNOWN-8BIT';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'US-ASCII';
  encoding: CHAR_ENCODING_BYTE
),
(
  name: 'US-DK';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'UTF-16';
  encoding: CHAR_ENCODING_UTF16
),
(
  name: 'UTF-16BE';
  encoding: CHAR_ENCODING_UTF16BE
),
(
  name: 'UTF-16LE';
  encoding: CHAR_ENCODING_UTF16LE
),
(
  name: 'UTF-32';
  encoding: CHAR_ENCODING_UTF32
),
(
  name: 'UTF-32BE';
  encoding: CHAR_ENCODING_UTF32BE
),
(
  name: 'UTF-32LE';
  encoding: CHAR_ENCODING_UTF32LE
),
(
  name: 'UTF-7';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'UTF-8';
  encoding: CHAR_ENCODING_UTF8
),
(
  name: 'VENTURA-INTERNATIONAL';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'VENTURA-MATH';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'VENTURA-US';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'VIDEOTEX-SUPPL';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'VIQR';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'VISCII';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1250';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1251';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1252';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1253';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1254';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1255';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1256';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1257';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-1258';
  encoding: CHAR_ENCODING_UNKNOWN
),
(
  name: 'WINDOWS-31J';
  encoding: CHAR_ENCODING_UNKNOWN
)
);
