{  IANA Registered character sets }
{  Generated :  }
const
  CHARSET_LENGTH_NAME = 24;
  CHARSET_LENGTH_ALIAS = 16;
  CHARSET_MAX_ALIASES = 10;
  CHARSET_RECORDS = 242;

type
 charsetrecord = record
  setname:string[CHARSET_LENGTH_NAME];
  value: word;
  aliases: array[1..CHARSET_MAX_ALIASES] of string[CHARSET_LENGTH_ALIAS];
 end;

{$ifndef tp}

const
charsets: array[1..CHARSET_RECORDS] of charsetrecord = (
(
    setname:'ADOBE-STANDARD-ENCODING';
    value : 0;
    aliases : 
      (
      'CSADOBESTANDARDE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ADOBE-SYMBOL-ENCODING';
    value : 0;
    aliases : 
      (
      'CSHPPSMATH',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'AMIGA-1251';
    value : 0;
    aliases : 
      (
      'AMI1251',
      'AMIGA1251',
      'AMI-1251',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ANSI_X3.110-1983';
    value : 0;
    aliases : 
      (
      'ISO-IR-99',
      'CSA_T500-1983',
      'NAPLPS',
      'CSISO99NAPLPS',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ASMO_449';
    value : 0;
    aliases : 
      (
      'ISO_9036',
      'ARABIC7',
      'ISO-IR-89',
      'CSISO89ASMO449',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'BIG5';
    value : 0;
    aliases : 
      (
      'CSBIG5',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'BIG5-HKSCS';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'BOCU-1';
    value : 0;
    aliases : 
      (
      'CSBOCU-1',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'BS_4730';
    value : 0;
    aliases : 
      (
      'ISO-IR-4',
      'ISO646-GB',
      'GB',
      'UK',
      'CSISO4UNITEDKING',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'BS_VIEWDATA';
    value : 0;
    aliases : 
      (
      'ISO-IR-47',
      'CSISO47BSVIEWDAT',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'CESU-8';
    value : 0;
    aliases : 
      (
      'CSCESU-8',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'CSA_Z243.4-1985-1';
    value : 0;
    aliases : 
      (
      'ISO-IR-121',
      'ISO646-CA',
      'CSA7-1',
      'CA',
      'CSISO121CANADIAN',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'CSA_Z243.4-1985-2';
    value : 0;
    aliases : 
      (
      'ISO-IR-122',
      'ISO646-CA2',
      'CSA7-2',
      'CSISO122CANADIAN',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'CSA_Z243.4-1985-GR';
    value : 0;
    aliases : 
      (
      'ISO-IR-123',
      'CSISO123CSAZ2434',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'CSN_369103';
    value : 0;
    aliases : 
      (
      'ISO-IR-139',
      'CSISO139CSN36910',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'DEC-MCS';
    value : 0;
    aliases : 
      (
      'DEC',
      'CSDECMCS',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'DIN_66003';
    value : 0;
    aliases : 
      (
      'ISO-IR-21',
      'DE',
      'ISO646-DE',
      'CSISO21GERMAN',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'DS_2089';
    value : 0;
    aliases : 
      (
      'DS2089',
      'ISO646-DK',
      'DK',
      'CSISO646DANISH',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-AT-DE';
    value : 0;
    aliases : 
      (
      'CSIBMEBCDICATDE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-AT-DE-A';
    value : 0;
    aliases : 
      (
      'CSEBCDICATDEA',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-CA-FR';
    value : 0;
    aliases : 
      (
      'CSEBCDICCAFR',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-DK-NO';
    value : 0;
    aliases : 
      (
      'CSEBCDICDKNO',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-DK-NO-A';
    value : 0;
    aliases : 
      (
      'CSEBCDICDKNOA',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-ES';
    value : 0;
    aliases : 
      (
      'CSEBCDICES',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-ES-A';
    value : 0;
    aliases : 
      (
      'CSEBCDICESA',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-ES-S';
    value : 0;
    aliases : 
      (
      'CSEBCDICESS',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-FI-SE';
    value : 0;
    aliases : 
      (
      'CSEBCDICFISE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-FI-SE-A';
    value : 0;
    aliases : 
      (
      'CSEBCDICFISEA',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-FR';
    value : 0;
    aliases : 
      (
      'CSEBCDICFR',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-IT';
    value : 0;
    aliases : 
      (
      'CSEBCDICIT',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-PT';
    value : 0;
    aliases : 
      (
      'CSEBCDICPT',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-UK';
    value : 0;
    aliases : 
      (
      'CSEBCDICUK',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EBCDIC-US';
    value : 0;
    aliases : 
      (
      'CSEBCDICUS',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ECMA-CYRILLIC';
    value : 0;
    aliases : 
      (
      'ISO-IR-111',
      'KOI8-E',
      'CSISO111ECMACYRI',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ES';
    value : 0;
    aliases : 
      (
      'ISO-IR-17',
      'ISO646-ES',
      'CSISO17SPANISH',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ES2';
    value : 0;
    aliases : 
      (
      'ISO-IR-85',
      'ISO646-ES2',
      'CSISO85SPANISH2',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EUC-JP';
    value : 0;
    aliases : 
      (
      'CSEUCPKDFMTJAPAN',
      'EXTENDED_UNIX_CO',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EUC-KR';
    value : 0;
    aliases : 
      (
      'CSEUCKR',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'EXTENDED_UNIX_CODE_FIXE';
    value : 0;
    aliases : 
      (
      'CSEUCFIXWIDJAPAN',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GB18030';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GB2312';
    value : 0;
    aliases : 
      (
      'CSGB2312',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GBK';
    value : 0;
    aliases : 
      (
      'CP936',
      'MS936',
      'WINDOWS-936',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GB_1988-80';
    value : 0;
    aliases : 
      (
      'ISO-IR-57',
      'CN',
      'ISO646-CN',
      'CSISO57GB1988',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GB_2312-80';
    value : 0;
    aliases : 
      (
      'ISO-IR-58',
      'CHINESE',
      'CSISO58GB231280',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GOST_19768-74';
    value : 0;
    aliases : 
      (
      'ST_SEV_358-88',
      'ISO-IR-153',
      'CSISO153GOST1976',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GREEK-CCITT';
    value : 0;
    aliases : 
      (
      'ISO-IR-150',
      'CSISO150',
      'CSISO150GREEKCCI',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GREEK7';
    value : 0;
    aliases : 
      (
      'ISO-IR-88',
      'CSISO88GREEK7',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'GREEK7-OLD';
    value : 0;
    aliases : 
      (
      'ISO-IR-18',
      'CSISO18GREEK7OLD',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'HP-DESKTOP';
    value : 0;
    aliases : 
      (
      'CSHPDESKTOP',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'HP-LEGAL';
    value : 0;
    aliases : 
      (
      'CSHPLEGAL',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'HP-MATH8';
    value : 0;
    aliases : 
      (
      'CSHPMATH8',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'HP-PI-FONT';
    value : 0;
    aliases : 
      (
      'CSHPPIFONT',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'HP-ROMAN8';
    value : 0;
    aliases : 
      (
      'ROMAN8',
      'R8',
      'CSHPROMAN8',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'HZ-GB-2312';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM-SYMBOLS';
    value : 0;
    aliases : 
      (
      'CSIBMSYMBOLS',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM-THAI';
    value : 0;
    aliases : 
      (
      'CSIBMTHAI',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM00858';
    value : 0;
    aliases : 
      (
      'CCSID00858',
      'CP00858',
      'PC-MULTILINGUAL-',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM00924';
    value : 0;
    aliases : 
      (
      'CCSID00924',
      'CP00924',
      'EBCDIC-LATIN9--E',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01140';
    value : 0;
    aliases : 
      (
      'CCSID01140',
      'CP01140',
      'EBCDIC-US-37+EUR',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01141';
    value : 0;
    aliases : 
      (
      'CCSID01141',
      'CP01141',
      'EBCDIC-DE-273+EU',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01142';
    value : 0;
    aliases : 
      (
      'CCSID01142',
      'CP01142',
      'EBCDIC-DK-277+EU',
      'EBCDIC-NO-277+EU',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01143';
    value : 0;
    aliases : 
      (
      'CCSID01143',
      'CP01143',
      'EBCDIC-FI-278+EU',
      'EBCDIC-SE-278+EU',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01144';
    value : 0;
    aliases : 
      (
      'CCSID01144',
      'CP01144',
      'EBCDIC-IT-280+EU',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01145';
    value : 0;
    aliases : 
      (
      'CCSID01145',
      'CP01145',
      'EBCDIC-ES-284+EU',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01146';
    value : 0;
    aliases : 
      (
      'CCSID01146',
      'CP01146',
      'EBCDIC-GB-285+EU',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01147';
    value : 0;
    aliases : 
      (
      'CCSID01147',
      'CP01147',
      'EBCDIC-FR-297+EU',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01148';
    value : 0;
    aliases : 
      (
      'CCSID01148',
      'CP01148',
      'EBCDIC-INTERNAT',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM01149';
    value : 0;
    aliases : 
      (
      'CCSID01149',
      'CP01149',
      'EBCDIC-IS-871+EU',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM037';
    value : 0;
    aliases : 
      (
      'CP037',
      'EBCDIC-CP-US',
      'EBCDIC-CP-CA',
      'EBCDIC-CP-WT',
      'EBCDIC-CP-NL',
      'CSIBM037',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM038';
    value : 0;
    aliases : 
      (
      'EBCDIC-INT',
      'CP038',
      'CSIBM038',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM1026';
    value : 0;
    aliases : 
      (
      'CP1026',
      'CSIBM1026',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM1047';
    value : 0;
    aliases : 
      (
      'IBM-1047',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM273';
    value : 0;
    aliases : 
      (
      'CP273',
      'CSIBM273',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM274';
    value : 0;
    aliases : 
      (
      'EBCDIC-BE',
      'CP274',
      'CSIBM274',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM275';
    value : 0;
    aliases : 
      (
      'EBCDIC-BR',
      'CP275',
      'CSIBM275',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM277';
    value : 0;
    aliases : 
      (
      'EBCDIC-CP-DK',
      'EBCDIC-CP-NO',
      'CSIBM277',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM278';
    value : 0;
    aliases : 
      (
      'CP278',
      'EBCDIC-CP-FI',
      'EBCDIC-CP-SE',
      'CSIBM278',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM280';
    value : 0;
    aliases : 
      (
      'CP280',
      'EBCDIC-CP-IT',
      'CSIBM280',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM281';
    value : 0;
    aliases : 
      (
      'EBCDIC-JP-E',
      'CP281',
      'CSIBM281',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM284';
    value : 0;
    aliases : 
      (
      'CP284',
      'EBCDIC-CP-ES',
      'CSIBM284',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM285';
    value : 0;
    aliases : 
      (
      'CP285',
      'EBCDIC-CP-GB',
      'CSIBM285',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM290';
    value : 0;
    aliases : 
      (
      'CP290',
      'EBCDIC-JP-KANA',
      'CSIBM290',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM297';
    value : 0;
    aliases : 
      (
      'CP297',
      'EBCDIC-CP-FR',
      'CSIBM297',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM420';
    value : 0;
    aliases : 
      (
      'CP420',
      'EBCDIC-CP-AR1',
      'CSIBM420',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM423';
    value : 0;
    aliases : 
      (
      'CP423',
      'EBCDIC-CP-GR',
      'CSIBM423',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM424';
    value : 0;
    aliases : 
      (
      'CP424',
      'EBCDIC-CP-HE',
      'CSIBM424',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM437';
    value : 0;
    aliases : 
      (
      'CP437',
      '437',
      'CSPC8CODEPAGE437',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM500';
    value : 0;
    aliases : 
      (
      'CP500',
      'EBCDIC-CP-BE',
      'EBCDIC-CP-CH',
      'CSIBM500',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM775';
    value : 0;
    aliases : 
      (
      'CP775',
      'CSPC775BALTIC',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM850';
    value : 0;
    aliases : 
      (
      'CP850',
      '850',
      'CSPC850MULTILING',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM851';
    value : 0;
    aliases : 
      (
      'CP851',
      '851',
      'CSIBM851',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM852';
    value : 0;
    aliases : 
      (
      'CP852',
      '852',
      'CSPCP852',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM855';
    value : 0;
    aliases : 
      (
      'CP855',
      '855',
      'CSIBM855',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM857';
    value : 0;
    aliases : 
      (
      'CP857',
      '857',
      'CSIBM857',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM860';
    value : 0;
    aliases : 
      (
      'CP860',
      '860',
      'CSIBM860',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM861';
    value : 0;
    aliases : 
      (
      'CP861',
      '861',
      'CP-IS',
      'CSIBM861',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM862';
    value : 0;
    aliases : 
      (
      'CP862',
      '862',
      'CSPC862LATINHEBR',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM863';
    value : 0;
    aliases : 
      (
      'CP863',
      '863',
      'CSIBM863',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM864';
    value : 0;
    aliases : 
      (
      'CP864',
      'CSIBM864',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM865';
    value : 0;
    aliases : 
      (
      'CP865',
      '865',
      'CSIBM865',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM866';
    value : 0;
    aliases : 
      (
      'CP866',
      '866',
      'CSIBM866',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM868';
    value : 0;
    aliases : 
      (
      'CP868',
      'CP-AR',
      'CSIBM868',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM869';
    value : 0;
    aliases : 
      (
      'CP869',
      '869',
      'CP-GR',
      'CSIBM869',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM870';
    value : 0;
    aliases : 
      (
      'CP870',
      'EBCDIC-CP-ROECE',
      'EBCDIC-CP-YU',
      'CSIBM870',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM871';
    value : 0;
    aliases : 
      (
      'CP871',
      'EBCDIC-CP-IS',
      'CSIBM871',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM880';
    value : 0;
    aliases : 
      (
      'CP880',
      'EBCDIC-CYRILLIC',
      'CSIBM880',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM891';
    value : 0;
    aliases : 
      (
      'CP891',
      'CSIBM891',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM903';
    value : 0;
    aliases : 
      (
      'CP903',
      'CSIBM903',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM904';
    value : 0;
    aliases : 
      (
      'CP904',
      '904',
      'CSIBBM904',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM905';
    value : 0;
    aliases : 
      (
      'CP905',
      'EBCDIC-CP-TR',
      'CSIBM905',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IBM918';
    value : 0;
    aliases : 
      (
      'CP918',
      'EBCDIC-CP-AR2',
      'CSIBM918',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IEC_P27-1';
    value : 0;
    aliases : 
      (
      'ISO-IR-143',
      'CSISO143IECP271',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'INIS';
    value : 0;
    aliases : 
      (
      'ISO-IR-49',
      'CSISO49INIS',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'INIS-8';
    value : 0;
    aliases : 
      (
      'ISO-IR-50',
      'CSISO50INIS8',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'INIS-CYRILLIC';
    value : 0;
    aliases : 
      (
      'ISO-IR-51',
      'CSISO51INISCYRIL',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'INVARIANT';
    value : 0;
    aliases : 
      (
      'ISO-IR-2',
      'IRV',
      'CSISO2INTLREFVER',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-10646-J-1';
    value : 0;
    aliases : 
      (
      'CSUNICODEIBM1261',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-10646-UCS-4';
    value : 0;
    aliases : 
      (
      'CSUCS4',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-10646-UCS-BASIC';
    value : 0;
    aliases : 
      (
      'CSUNICODEASCII',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-10646-UNICODE-LATIN1';
    value : 0;
    aliases : 
      (
      'CSUNICODELATIN1',
      'ISO-10646',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-10646-UTF-1';
    value : 0;
    aliases : 
      (
      'CSISO10646UTF1',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-2022-CN';
    value : 0;
    aliases : 
      (
      'JIS_C6220-1969',
      'ISO-IR-13',
      'KATAKANA',
      'X0201-7',
      'CSISO13JISC6220J',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-2022-JP';
    value : 0;
    aliases : 
      (
      'CSISO2022JP',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-2022-JP-2';
    value : 0;
    aliases : 
      (
      'CSISO2022JP2',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-2022-KR';
    value : 0;
    aliases : 
      (
      'CSISO2022KR',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-1';
    value : 0;
    aliases : 
      (
      'ISO-IR-100',
      'ISO_8859-1',
      'LATIN1',
      'L1',
      'IBM819',
      'CP819',
      'CSISOLATIN1',
      'ISO_8859-1:1987',
      '',
      ''
      )
),
(
    setname:'ISO-8859-1-WINDOWS-3.0-';
    value : 0;
    aliases : 
      (
      'CSWINDOWS30LATIN',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-1-WINDOWS-3.1-';
    value : 0;
    aliases : 
      (
      'CSWINDOWS31LATIN',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-10';
    value : 0;
    aliases : 
      (
      'ISO-IR-157',
      'L6',
      'ISO_8859-10:1992',
      'CSISOLATIN6',
      'LATIN6',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-13';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-14';
    value : 0;
    aliases : 
      (
      'ISO-IR-199',
      'ISO_8859-14:1998',
      'ISO_8859-14',
      'LATIN8',
      'ISO-CELTIC',
      'L8',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-15';
    value : 0;
    aliases : 
      (
      'ISO_8859-15',
      'LATIN-9',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-16';
    value : 0;
    aliases : 
      (
      'ISO-IR-226',
      'ISO_8859-16:2001',
      'ISO_8859-16',
      'LATIN10',
      'L10',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-2';
    value : 0;
    aliases : 
      (
      'ISO-IR-101',
      'ISO_8859-2',
      'LATIN2',
      'L2',
      'CSISOLATIN2',
      'ISO_8859-2:1987',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-2-WINDOWS-LATI';
    value : 0;
    aliases : 
      (
      'CSWINDOWS31LATIN',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-3';
    value : 0;
    aliases : 
      (
      'ISO-IR-109',
      'ISO_8859-3',
      'LATIN3',
      'L3',
      'CSISOLATIN3',
      'ISO_8859-3:1988',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-4';
    value : 0;
    aliases : 
      (
      'ISO-IR-110',
      'ISO_8859-4',
      'LATIN4',
      'L4',
      'CSISOLATIN4',
      'ISO_8859-4:1988',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-5';
    value : 0;
    aliases : 
      (
      'ISO-IR-144',
      'ISO_8859-5',
      'CYRILLIC',
      'CSISOLATINCYRILL',
      'ISO_8859-5:1988',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-6';
    value : 0;
    aliases : 
      (
      'ISO-IR-127',
      'ISO_8859-6',
      'ECMA-114',
      'ASMO-708',
      'ARABIC',
      'CSISOLATINARABIC',
      'ISO_8859-6:1987',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-6-E';
    value : 0;
    aliases : 
      (
      'CSISO88596E',
      'ISO_8859-6-E',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-6-I';
    value : 0;
    aliases : 
      (
      'CSISO88596I',
      'ISO_8859-6-I',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-7';
    value : 0;
    aliases : 
      (
      'ISO-IR-126',
      'ISO_8859-7',
      'ELOT_928',
      'ECMA-118',
      'GREEK',
      'GREEK8',
      'CSISOLATINGREEK',
      'ISO_8859-7:1987',
      '',
      ''
      )
),
(
    setname:'ISO-8859-8';
    value : 0;
    aliases : 
      (
      'ISO-IR-138',
      'ISO_8859-8',
      'HEBREW',
      'CSISOLATINHEBREW',
      'ISO_8859-8:1988',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-8-E';
    value : 0;
    aliases : 
      (
      'CSISO88598E',
      'ISO_8859-8-E',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-8-I';
    value : 0;
    aliases : 
      (
      'CSISO88598I',
      'ISO_8859-8-I',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-9';
    value : 0;
    aliases : 
      (
      'ISO-IR-148',
      'ISO_8859-9',
      'LATIN5',
      'L5',
      'CSISOLATIN5',
      'ISO_8859-9:1989',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-8859-9-WINDOWS-LATI';
    value : 0;
    aliases : 
      (
      'CSWINDOWS31LATIN',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-IR-90';
    value : 0;
    aliases : 
      (
      'CSISO90',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-UNICODE-IBM-1264';
    value : 0;
    aliases : 
      (
      'CSUNICODEIBM1264',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-UNICODE-IBM-1265';
    value : 0;
    aliases : 
      (
      'CSUNICODEIBM1265',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-UNICODE-IBM-1268';
    value : 0;
    aliases : 
      (
      'CSUNICODEIBM1268',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO-UNICODE-IBM-1276';
    value : 0;
    aliases : 
      (
      'CSUNICODEIBM1276',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_10367-BOX';
    value : 0;
    aliases : 
      (
      'ISO-IR-155',
      'CSISO10367BOX',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_2033-1983';
    value : 0;
    aliases : 
      (
      'ISO-IR-98',
      'E13B',
      'CSISO2033',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_5427';
    value : 0;
    aliases : 
      (
      'ISO-IR-37',
      'CSISO5427CYRILLI',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_5427:1981';
    value : 0;
    aliases : 
      (
      'ISO-IR-54',
      'ISO5427CYRILLIC1',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_5428:1980';
    value : 0;
    aliases : 
      (
      'ISO-IR-55',
      'CSISO5428GREEK',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_646.BASIC:1983';
    value : 0;
    aliases : 
      (
      'REF',
      'CSISO646BASIC198',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_6937-2-25';
    value : 0;
    aliases : 
      (
      'ISO-IR-152',
      'CSISO6937ADD',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_6937-2-ADD';
    value : 0;
    aliases : 
      (
      'ISO-IR-142',
      'CSISOTEXTCOMM',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'ISO_8859-SUPP';
    value : 0;
    aliases : 
      (
      'ISO-IR-154',
      'LATIN1-2-5',
      'CSISO8859SUPP',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'IT';
    value : 0;
    aliases : 
      (
      'ISO-IR-15',
      'ISO646-IT',
      'CSISO15ITALIAN',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6220-1969-RO';
    value : 0;
    aliases : 
      (
      'ISO-IR-14',
      'JP',
      'ISO646-JP',
      'CSISO14JISC6220R',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6226-1978';
    value : 0;
    aliases : 
      (
      'ISO-IR-42',
      'CSISO42JISC62261',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6226-1983';
    value : 0;
    aliases : 
      (
      'ISO-IR-87',
      'X0208',
      'JIS_X0208-1983',
      'CSISO87JISX0208',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6229-1984-A';
    value : 0;
    aliases : 
      (
      'ISO-IR-91',
      'JP-OCR-A',
      'CSISO91JISC62291',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6229-1984-B';
    value : 0;
    aliases : 
      (
      'ISO-IR-92',
      'ISO646-JP-OCR-B',
      'JP-OCR-B',
      'CSISO92JISC62991',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6229-1984-B-ADD';
    value : 0;
    aliases : 
      (
      'ISO-IR-93',
      'JP-OCR-B-ADD',
      'CSISO93JIS622919',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6229-1984-HAND';
    value : 0;
    aliases : 
      (
      'ISO-IR-94',
      'JP-OCR-HAND',
      'CSISO94JIS622919',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6229-1984-HAND-ADD';
    value : 0;
    aliases : 
      (
      'ISO-IR-95',
      'JP-OCR-HAND-ADD',
      'CSISO95JIS62291',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_C6229-1984-KANA';
    value : 0;
    aliases : 
      (
      'ISO-IR-96',
      'CSISO96JISC62291',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_ENCODING';
    value : 0;
    aliases : 
      (
      'CSJISENCODING',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JIS_X0212-1990';
    value : 0;
    aliases : 
      (
      'X0212',
      'ISO-IR-159',
      'CSISO159JISX0212',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JUS_I.B1.002';
    value : 0;
    aliases : 
      (
      'ISO-IR-141',
      'ISO646-YU',
      'JS',
      'YU',
      'CSISO141JUSIB100',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JUS_I.B1.003-MAC';
    value : 0;
    aliases : 
      (
      'MACEDONIAN',
      'ISO-IR-147',
      'CSISO147MACEDONI',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'JUS_I.B1.003-SERB';
    value : 0;
    aliases : 
      (
      'ISO-IR-146',
      'SERBIAN',
      'CSISO146SERBIAN',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'KOI7-SWITCHED';
    value : 0;
    aliases : 
      (
      'NONE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'KOI8-R';
    value : 0;
    aliases : 
      (
      'CSKOI8R',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'KOI8-U';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'KSC5636';
    value : 0;
    aliases : 
      (
      'CSUNICODE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'KS_C_5601-1987';
    value : 0;
    aliases : 
      (
      'ISO-IR-149',
      'KS_C_5601-1989',
      'KSC_5601',
      'KOREAN',
      'CSKSC56011987',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'LATIN-GREEK';
    value : 0;
    aliases : 
      (
      'ISO-IR-19',
      'CSISO19LATINGREE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'LATIN-GREEK-1';
    value : 0;
    aliases : 
      (
      'ISO-IR-27',
      'CSISO27LATINGREE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'LATIN-LAP';
    value : 0;
    aliases : 
      (
      'LAP',
      'ISO-IR-158',
      'CSISO158LAP',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'MACINTOSH';
    value : 0;
    aliases : 
      (
      'MAC',
      'CSMACINTOSH',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'MICROSOFT-PUBLISHING';
    value : 0;
    aliases : 
      (
      'CSMICROSOFTPUBLI',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'MNEM';
    value : 0;
    aliases : 
      (
      'CSMNEM',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'MSZ_7795.3';
    value : 0;
    aliases : 
      (
      'ISO-IR-86',
      'ISO646-HU',
      'HU',
      'CSISO86HUNGARIAN',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NATS-DANO';
    value : 0;
    aliases : 
      (
      'ISO-IR-9-1',
      'CSNATSDANO',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NATS-DANO-ADD';
    value : 0;
    aliases : 
      (
      'ISO-IR-9-2',
      'CSNATSDANOADD',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NATS-SEFI';
    value : 0;
    aliases : 
      (
      'ISO-IR-8-1',
      'CSNATSSEFI',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NATS-SEFI-ADD';
    value : 0;
    aliases : 
      (
      'ISO-IR-8-2',
      'CSNATSSEFIADD',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NC_NC00-10:81';
    value : 0;
    aliases : 
      (
      'CUBA',
      'ISO-IR-151',
      'ISO646-CU',
      'CSISO151CUBA',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NF_Z_62-010';
    value : 0;
    aliases : 
      (
      'ISO-IR-69',
      'ISO646-FR',
      'FR',
      'CSISO69FRENCH',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NF_Z_62-010_(1973)';
    value : 0;
    aliases : 
      (
      'ISO-IR-25',
      'ISO646-FR1',
      'CSISO25FRENCH',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NS_4551-1';
    value : 0;
    aliases : 
      (
      'ISO-IR-60',
      'ISO646-NO',
      'NO',
      'CSISO60DANISHNOR',
      'CSISO60NORWEGIAN',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'NS_4551-2';
    value : 0;
    aliases : 
      (
      'ISO646-NO2',
      'ISO-IR-61',
      'NO2',
      'CSISO61NORWEGIAN',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'OSD_EBCDIC_DF03_IRV';
    value : 0;
    aliases : 
      (
      'NONE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'OSD_EBCDIC_DF04_1';
    value : 0;
    aliases : 
      (
      'NONE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'OSD_EBCDIC_DF04_15';
    value : 0;
    aliases : 
      (
      'NONE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'PC8-DANISH-NORWEGIAN';
    value : 0;
    aliases : 
      (
      'CSPC8DANISHNORWE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'PC8-TURKISH';
    value : 0;
    aliases : 
      (
      'CSPC8TURKISH',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'PT';
    value : 0;
    aliases : 
      (
      'ISO-IR-16',
      'ISO646-PT',
      'CSISO16PORTUGUES',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'PT2';
    value : 0;
    aliases : 
      (
      'ISO-IR-84',
      'ISO646-PT2',
      'CSISO84PORTUGUES',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'PTCP154';
    value : 0;
    aliases : 
      (
      'CSPTCP154',
      'PT154',
      'CP154',
      'CYRILLIC-ASIAN',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'SCSU';
    value : 0;
    aliases : 
      (
      'NONE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'SEN_850200_B';
    value : 0;
    aliases : 
      (
      'ISO-IR-10',
      'FI',
      'ISO646-FI',
      'ISO646-SE',
      'SE',
      'CSISO10SWEDISH',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'SEN_850200_C';
    value : 0;
    aliases : 
      (
      'ISO-IR-11',
      'ISO646-SE2',
      'SE2',
      'CSISO11SWEDISHFO',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'SHIFT_JIS';
    value : 0;
    aliases : 
      (
      'MS_KANJI',
      'CSSHIFTJIS',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'T.101-G2';
    value : 0;
    aliases : 
      (
      'ISO-IR-128',
      'CSISO128T101G2',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'T.61-7BIT';
    value : 0;
    aliases : 
      (
      'ISO-IR-102',
      'CSISO102T617BIT',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'T.61-8BIT';
    value : 0;
    aliases : 
      (
      'ISO-IR-103',
      'CSISO103T618BIT',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'TIS-620';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UNICODE-1-1';
    value : 0;
    aliases : 
      (
      'CSUNICODE11',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UNICODE-1-1-UTF-7';
    value : 0;
    aliases : 
      (
      'CSUNICODE11UTF7',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UNKNOWN-8BIT';
    value : 0;
    aliases : 
      (
      'CSMNEMONIC',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'US-ASCII';
    value : 0;
    aliases : 
      (
      'ISO-IR-6',
      'ANSI_X3.4-1986',
      'ISO_646.IRV:1991',
      'ASCII',
      'ISO646-US',
      'US',
      'IBM367',
      'CP367',
      'CSASCII',
      'ANSI_X3.4-1968'
      )
),
(
    setname:'US-DK';
    value : 0;
    aliases : 
      (
      'X0201',
      'CSHALFWIDTHKATAK',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UTF-16';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UTF-16BE';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UTF-16LE';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UTF-32';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UTF-32BE';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UTF-32LE';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UTF-7';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'UTF-8';
    value : 0;
    aliases : 
      (
      'NONE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'VENTURA-INTERNATIONAL';
    value : 0;
    aliases : 
      (
      'CSVENTURAINTERNA',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'VENTURA-MATH';
    value : 0;
    aliases : 
      (
      'CSVENTURAMATH',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'VENTURA-US';
    value : 0;
    aliases : 
      (
      'CSVENTURAUS',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'VIDEOTEX-SUPPL';
    value : 0;
    aliases : 
      (
      'ISO-IR-70',
      'CSISO70VIDEOTEXS',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'VIQR';
    value : 0;
    aliases : 
      (
      'CSVIQR',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'VISCII';
    value : 0;
    aliases : 
      (
      'CSVISCII',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1250';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1251';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1252';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1253';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1254';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1255';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1256';
    value : 0;
    aliases : 
      (
      'NONE',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1257';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-1258';
    value : 0;
    aliases : 
      (
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
),
(
    setname:'WINDOWS-31J';
    value : 0;
    aliases : 
      (
      'CSWINDOWS31J',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      ''
      )
));

{$else}
procedure charsetsproc;external; {$L charset.obj}
{$endif}
