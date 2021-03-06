unit tiso639;

interface

procedure test_unit;


implementation

uses
  sysutils,
  cmntyp,
  iso639;


  procedure testiso639;
  var
   b: boolean;
   s: string;
  begin
    b:=isvalidlangcode('');
    if b = TRUE then
       RunError(255);
    b:=isvalidlangcode('fr');
    if not b then
       RunError(255);
    b:=isvalidlangcode('xal');
    if not b then
       RunError(255);
    b:=isvalidlangcode('francais');
    if b then
       RunError(255);
    { Verify French decoding }
    s:=getlangname_fr('');
    if s <> '' then
        RunError(255);
    s:=getlangname_fr('en');
    if UpperCase(s) <> 'ANGLAIS' then
        RunError(255);
    s:=getlangname_fr('english');
    if UpperCase(s) <> '' then
        RunError(255);
    s:=getlangname_fr('xal');
    if UpperCase(s) <> 'KALMOUK' then
        RunError(255);
    { Verify english decoding }
    s:=getlangname_en('');
    if s <> '' then
        RunError(255);
    s:=getlangname_en('fr');
    if UpperCase(s) <> 'FRENCH' then
        RunError(255);
    s:=getlangname_en('xal');
    if UpperCase(s) <> 'KALMYK' then
        RunError(255);
    s:=getlangname_en('english');
    if UpperCase(s) <> '' then
        RunError(255);
    s:=getlangname_en('zun');
    if UpperCase(s)<>'ZUNI' then
      RunError(255);
  end;

  procedure test_getlangcode;
  var
   s: string;
  begin
    s:=getlangcode_en('Old Bulgarian');
    if s<>'cu' then
      RunError(255);
    s:=getlangcode_en('FRENCH');
    if s<>'fr' then
      RunError(255);
    s:=getlangcode_en('spanish');
    if s<>'es' then
      RunError(255);
    s:=getlangcode_fr('EsPagNol');
    if s<>'es' then
      RunError(255);
    s:=getlangcode_fr('breton');
    if s<>'br' then
      RunError(255);
    s:=getlangcode_fr('CORNIQUE');
    if s<>'kw' then
      RunError(255);
  end;

procedure test_unit;
begin
  testiso639;
  test_getlangcode;
end;

end.