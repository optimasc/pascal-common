{==== Compiler directives ===========================================}
{$B-} { Full boolean evaluation          }
{$I-} { IO Checking                      }
{$F+} { FAR routine calls                }
{$P-} { Implicit open strings            }
{$T-} { Typed pointers                   }
{$V+} { Strict VAR strings checking      }
{$X-} { Extended syntax                  }
{$IFNDEF TP}
 {$H+} { Memory allocated strings        }
 {$DEFINE ANSISTRINGS}
 {$J+} { Writeable constants             }
 {$METHODINFO OFF} 
{$ENDIF}
{====================================================================}
unit testietf;

interface

procedure test_unit;

implementation

uses ietf;


procedure testLangTag;
var
 b: boolean;
 primary,sub: string;
begin
  {-- Valid cases --}
  b:=langtag_split('x-default',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'x-default') or (sub <> '') then
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
  b:=langtag_split('i-enochian',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'i-enochian') or (sub <> '') then
    RunError(255);    
  b:=langtag_split('x-ccode',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'x-ccode') or (sub <> '') then
    RunError(255);
  b:=langtag_split('US',primary,sub);
  if not b then
    RunError(255);
    
  b:=langtag_split('zh-Hant',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'zh') or (sub <> '') then
    RunError(255);
    
  b:=langtag_split('zh-cmn-Hans-CN',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'zh') or (sub <> 'CN') then
    RunError(255);
    
  b:=langtag_split('zh-Hans-CN',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'zh') or (sub <> 'CN') then
    RunError(255);
    
  b:=langtag_split('sl-rozaj',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'sl') or (sub <> '') then
    RunError(255);
    
  b:=langtag_split('sl-rozaj-biske',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'sl') or (sub <> '') then
    RunError(255);
    
  b:=langtag_split('de-CH-1901',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'de') or (sub <> 'CH') then
    RunError(255);
    
  b:=langtag_split('es-419',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'es') or (sub <> '419') then
    RunError(255);
    
  b:=langtag_split('de-CH-x-phonebk',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'de') or (sub <> 'CH') then
    RunError(255);
    
  b:=langtag_split('x-whatever',primary,sub);
  if not b then
    RunError(255);
  if (primary <> 'x-whatever') or (sub <> '') then
    RunError(255);
    
  {-- Error cases ---}     
  b:=langtag_split('a-DE',primary,sub);
  if b then
    RunError(255);
  
  b:=langtag_split('  en-US',primary,sub);
  if b then
    RunError(255);
  b:=langtag_split('en-Carl Eric',primary,sub);
  if b then
    RunError(255);
end;

procedure TestURI;
var
 b: boolean;
 primary,sub: string;
 schema, authority, path, query: string;
Begin
 b:=uri_split('FTP://ftp.is.co.za/rfc/rfc1808.txt',schema,authority,path,query);
 if not b then
   RunError(255);
 if (schema <> 'ftp') then
   RunError(255);
 if (authority <> 'ftp.is.co.za') then
   RunError(255);
 if (path <> '/rfc/rfc1808.txt') then
   RunError(255);
 if (query <> '') then
   RunError(255);
   
 b:=uri_split('http://www.ietf.org/rfc/rfc2396.txt',schema,authority,path,query);
 if not b then
   RunError(255);
 if (schema <> 'http') then
   RunError(255);
 if (authority <> 'www.ietf.org') then
   RunError(255);
 if (path <> '/rfc/rfc2396.txt') then
   RunError(255);
 if (query <> '') then
   RunError(255);
   
 b:=uri_split('ldap://[2001:db8::7]/c=GB?objectClass?one',schema,authority,path,query);
 if not b then
   RunError(255);
 if (schema <> 'ldap') then
   RunError(255);
 if (authority <> '[2001:db8::7]') then
   RunError(255);
 if (path <> '/c=GB') then
   RunError(255);
 WriteLn(Query);
 if (query <> 'objectClass?one') then
   RunError(255);
   
   
 b:=uri_split('mailto:John.Doe@example.com',schema,authority,path,query);
 if not b then
   RunError(255);
 if (schema <> 'mailto') then
   RunError(255);
 if (authority <> '') then
   RunError(255);
 if (path <> 'John.Doe@example.com') then
   RunError(255);
 WriteLn(Query);
 if (query <> '') then
   RunError(255);
   
   
 b:=uri_split('news:comp.infosystems.www.servers.unix',schema,authority,path,query);
 if not b then
   RunError(255);
 if (schema <> 'news') then
   RunError(255);
 if (authority <> '') then
   RunError(255);
 if (path <> 'comp.infosystems.www.servers.unix') then
   RunError(255);
 WriteLn(Query);
 if (query <> '') then
   RunError(255);
   
   
 b:=uri_split('tel:+1-816-555-1212',schema,authority,path,query);
 if not b then
   RunError(255);
 if (schema <> 'tel') then
   RunError(255);
 if (authority <> '') then
   RunError(255);
 if (path <> '+1-816-555-1212') then
   RunError(255);
 WriteLn(Query);
 if (query <> '') then
   RunError(255);
   
   
 b:=uri_split('telnet://192.0.2.16:80/',schema,authority,path,query);
 if not b then
   RunError(255);
 if (schema <> 'telnet') then
   RunError(255);
 if (authority <> '192.0.2.16:80') then
   RunError(255);
 if (path <> '/') then
   RunError(255);
 WriteLn(Query);
 if (query <> '') then
   RunError(255);
   
   
 b:=uri_split('urn:oasis:names:specification:docbook:dtd:xml:4.1.2',schema,authority,path,query);
 if not b then
   RunError(255);
 if (schema <> 'urn') then
   RunError(255);
 if (authority <> '') then
   RunError(255);
 if (path <> 'oasis:names:specification:docbook:dtd:xml:4.1.2') then
   RunError(255);
 WriteLn(Query);
 if (query <> '') then
   RunError(255);
   
end;

procedure test_unit;
begin
  Write('Testing IETF unit...');
  testLangTag;
  testURI;
  WriteLn('done.');
end;


Begin
end.
