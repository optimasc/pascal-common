unit allunits;

interface

uses
  dos,
  collects,
  crc,
  ctypes,
  dateutil,
  dpautils,
  fpautils,
  gpautils,
  fs,
  vpautils,
  tpautils,
  locale,
  unicode,
  iso639,
  iso3166,
  strsrch,
  ietf,
  sgml,
  fileio,
{$IFDEF LINUX}
{$IFDEF CPU86}
  posix,
{$ENDIF}  
{$ENDIF}
{$IFDEF WIN32}
  extdos,
{$ENDIF}
{$IFDEF LINUX}
{$IFDEF CPU86}
  extdos,
{$ENDIF}  
{$ENDIF}
  utils;
  
implementation  
  

begin
end.