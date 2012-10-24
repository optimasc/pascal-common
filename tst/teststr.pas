{ Tests the String utilities }
Unit TestStr;

interface

uses cmnutils;

procedure test_unit;


implementation

procedure test_StrToken;
var
 s: string;
 Text: string;
 res: string;
Begin
 s:='This is my little sheep';
 Text:=s;
 { Separate into different tokens }
 res:=StrToken(Text,' ',False);
 if res<>'This' then
   RunError(255);
 res:=StrToken(Text,' ',False);
 if res<>'is' then
   RunError(255);
 res:=StrToken(Text,' ',False);
 if res<>'my' then
   RunError(255);
 res:=StrToken(Text,' ',False);
 if res<>'little' then
   RunError(255);
 res:=StrToken(Text,' ',False);
 if res<>'sheep' then
   RunError(255);
 res:=StrToken(Text,' ',False);
 if res<>'' then
   RunError(255);
 if length(Text) <> 0 then
   RunError(255);
 s:='This,is,my,little,sheep,,';
 { Separate into different tokens }
 Text:=s;
 res:=StrToken(Text,',',False);
 if res<>'This' then
   RunError(255);
 res:=StrToken(Text,',',False);
 if res<>'is' then
   RunError(255);
 res:=StrToken(Text,',',False);
 if res<>'my' then
   RunError(255);
 res:=StrToken(Text,',',False);
 if res<>'little' then
   RunError(255);
 res:=StrToken(Text,',',False);
 if res<>'sheep' then
   RunError(255);
 res:=StrToken(Text,',',False);
 if res<>'' then
   RunError(255);
 if length(Text) <> 0 then
   RunError(255);
 s:='This is my little sheep';
 Text:=s;
 res:=StrToken(Text,',',False);
 if res<>'This is my little sheep' then
   RunError(255);
 if length(Text) <> 0 then
   RunError(255);
 { Separate into different tokens, while delimiter is > 1 character in length }
  s:='This; is; my; little; sheep; ;';
  { Separate into different tokens }
  Text:=s;
  res:=StrToken(Text,'; ',False);
  if res<>'This' then
    RunError(255);
  res:=StrToken(Text,'; ',False);
  if res<>'is' then
    RunError(255);
  res:=StrToken(Text,'; ',False);
  if res<>'my' then
    RunError(255);
  res:=StrToken(Text,'; ',False);
  if res<>'little' then
    RunError(255);
  res:=StrToken(Text,'; ',False);
  if res<>'sheep' then
    RunError(255);
  res:=StrToken(Text,'; ',False);
  if res<>'' then
    RunError(255);
  if length(Text) <> 0 then
    RunError(255);
  s:='This is my little sheep';
  Text:=s;
  res:=StrToken(Text,'; ',False);
  if res<>'This is my little sheep' then
    RunError(255);
  if length(Text) <> 0 then
    RunError(255);

 
   
   
end;

procedure test_unit;
Begin
  test_strtoken;
end;

Begin
end.