{ Unit to test some routines of sgml }
unit testsgml;

interface

procedure test_unit;

implementation

uses
{$IFDEF VPASCAL}
 use32,
{$ENDIF}
 sgml;

const
 S1_VALID_ENTITY = 'This is a simple; test';
 S2_VALID_ENTITY = ';;Simple test ;';
 S2_INVALID_ENTITY = 'Another test &; with invalid entity';

procedure test_entities;
var
 s: string;
 s1: string;
begin
 s:=SGMLEntitiesToISO8859_1(S1_VALID_ENTITY);
 if s <> S1_VALID_ENTITY then
   RunError(255);
 s:=SGMLEntitiesToISO8859_1(S2_VALID_ENTITY);
 if s <> S2_VALID_ENTITY then
   RunError(255);
 s:=SGMLEntitiesToISO8859_1(S2_INVALID_ENTITY);
 if s <> 'Another test  with invalid entity' then
   RunError(255);
 s:=SGMLEntitiesToISO8859_1('Ceci est test repr&eacute;sentatif');
 if s <> 'Ceci est test repr'#233'sentatif' then
   RunError(255);
 s:=SGMLEntitiesToISO8859_1('Ceci est test repr&eacute;sentatif &amp; un petit tour!');
 if s <> 'Ceci est test repr'#233'sentatif & un petit tour!' then
   RunError(255);
 { Hexadecimal representation }
 s:=SGMLEntitiesToISO8859_1('Ceci est test repr&#xe9;sentatif &#x26; un petit tour!');
 if s <> 'Ceci est test repr'#233'sentatif & un petit tour!' then
   RunError(255);
 { Decimal representation }
 s:=SGMLEntitiesToISO8859_1('Ceci est test repr&#233;sentatif &#38; un petit tour!');
 if s <> 'Ceci est test repr'#233'sentatif & un petit tour!' then
   RunError(255);
 { Out of bound to ISO-8859-1 }
 s:=SGMLEntitiesToISO8859_1('Ceci est test repr&b.Omega;sentatif un petit tour!');
 if s <> 'Ceci est test repr\u03A9sentatif & un petit tour!' then
   
end;



procedure test_unit;
begin
  test_entities;
end;

end.

{
  $Log: not supported by cvs2svn $
  Revision 1.1  2004/10/13 23:40:54  carl
    + added sgml unit testing

  Revision 1.1  2004/09/29 00:56:53  carl
    + update to include dateutil testing

}
