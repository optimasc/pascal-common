unit testietf;

interface

procedure test_unit;

implementation

uses ietf;

procedure test_unit;
var
 b: boolean;
 primary,sub: string;
begin
  b:=langtag_split('x-default',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'x') or (sub <> 'default') then
    RunError(255);
  b:=langtag_split('fr-FR',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'fr') or (sub <> 'FR') then
    RunError(255);
  b:=langtag_split('FR-CA',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'fr') or (sub <> 'CA') then
    RunError(255);
  b:=langtag_split('US',primary,sub);
  if b then
    RunError(255);
  b:=langtag_split('  en-US',primary,sub);
  if b then
    RunError(255);
  b:=langtag_split('en-Carl Eric',primary,sub);
  if b then
    RunError(255);
end;


Begin
end.
