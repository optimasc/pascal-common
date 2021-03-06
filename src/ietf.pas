{
 ****************************************************************************
    $Id: ietf.pas,v 1.14 2012-10-24 15:17:59 Carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    Unicode related routines
    Partially converted from: 
    http://www.unicode.org/Public/PROGRAMS/CVTUTF/

    See License.txt for more information on the licensing terms
    for this source code.
    
 ****************************************************************************
}
{** @author(Carl Eric Codere)
    @abstract(ietf/web related support unit)

    This unit contains routines to validate strings, and characters 
    according to different IETF standards 
    (such as URL's, URI's and MIME types).
    
}

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
unit ietf;


interface

{----------------- MIME related routines ----------------}

{** abstract(Validates the syntax of a MIME type) 
    
    This routine is used to validate if MIME content type
    signature consists of a constructed valid syntax. It
    does not validate if the MIME type is assigned or if
    it actually exists or not.
    
    @param(s MIME type signature to verify)
    @return(TRUE if the signature has valid syntax)
}
function mime_isvalidcontenttype(const s: string): boolean;


(*
{**abstract(Validates and splits the syntax of a MIME Type tag into its components)

   The validation is according to IETF RFC 2045 allowed syntax.
   
   @param(s MIME content type value to validate)
   @param(typ The major MIME category type)
   @param(subtype The subtype in this category)
   @param(parameters The list of parameters for this content type)

}
function mime_split(s: shortstring var typ,subtype,parameter:shortstring): boolean;
*)

{------- RFC 3066 (language tags) related routines --------}

{**abstract(Validates the syntax of a language tag)

   The validation is according to IETF RFC 3066 with restrictions,
   since the original IETF recommendation. All private tags starting
   with i- x- must have at maximum 8 characters after the special
   characters.

   Also supports the extensions and syntax of IETF RFC 5646,
   even though only the region and primary language tag are validated.

}
function langtag_isvalid(const s: string): boolean;

{**abstract(Validates and splits the syntax of a language tag into its components)

   The validation is according to IETF RFC 3066 with restrictions,
   since the original IETF recommendation was not clear. 
   
   Only validates the primary language tag as well as the 
   region tag, even though the extended IETF RFC 5646 sytnax
   shall be accepted and will not cause errors.

   @param(s The language tag to split and validate)
   @param(primary The primary language tag, or empty if not valid)
   @param(region The associated region or empty if not valid or not present)

}
function langtag_split(const s: string; var primary,region: string): boolean;

{----------------- URI related routines ----------------}
const
  {** @exclude Suggested start delimiter character for an URI, c.f. RFC  2396 }
  URI_START_DELIMITER_CHAR = '<';
  {** @exclude Suggested end delimiter character for an URI, c.f. RFC  2396 }
  URI_END_DELIMITER_CHAR = '>';
  {** @exclude }
  URI_SCHEME_NAME_EMAIL = 'mailto';
  {** @exclude }
  URI_SCHEME_SEPARATOR = ':';
  

{** abstract(Validates and splits the syntax of an URI tag into its components)

   Given an URI complete absolute specification string, extract and return 
   the scheme, authority, path and query components of the URI. The exact 
   definition of these terms is specified in IETF RFC 2396.
     
   @param(url URI to check)
   @returns(FALSE if the URI is not valid, otherwise returns TRUE)
 }
function uri_split(uri: string; var scheme, authority,path, query: string): boolean;



{----------------- URN related routines ----------------}


{** @abstract(Verifies the validity of a complete URN string)

    This checks the conformance of the URN address. It
    is based on IETF RFC 2141.

    @returns(TRUE if this is a valid URN string)
}
function urn_isvalid(s: string): boolean;

{function urn_split(var sig, nid, nss: string): boolean;}


{** This routine checks that the specified NID (namespace) is
    either registered to IANA, or that it is an experimental
    NID, as described in IETF RFC 2611. More assignment
    information can be obtained from:
    http://www.iana.org/assignments/urn-namespaces

    @returns(TRUE if this is a registered or experimental NID string)
}
function urn_isvalidnid(nid: string): boolean;

{** @abstract(Splits an URN string in its separate components)

    It is based on IETF RFC 2141.

    @param(urn Complete URN string to separate)
    @param(urnidstr Signature URN:)
    @param(nidstr Namespace identifier NID)
    @param(nssstr Namespace specific string NSS)
    @returns(TRUE if the operation was successfull, or
      FALSE if the URN is malformed)
}
function urn_split(urn:string; var urnidstr,nidstr,nssstr: string): boolean;

{** @abstract(Creates an URN string from its namespace identifier and value)

    The routine validates that the namespace is actually valid and
    registered or is a private namespace.

    @param(nidstr The actual namespace identifier)
    @param(nss The namespace specific string)
    @param(urn The URN string including the urn prefix, always constructed
       even if the namespace identifier is invalid)
    @returns(true if there was success in creating the string)
}     
function urn_create(const nidstr, nss: string; var urn: string): boolean;

{** Splits a path string returned by uri_split into its
    individual components for URN. }
function urn_pathsplit(path: string; var namespace, nss: string): boolean;


{** Splits a path string returned by uri_split into its
    individual components for the http URI. }
 function http_pathsplit(path: string; var directory, name: string): boolean;
{** Splits a path string returned by uri_split into its
    individual components for the file URI. }
 function file_pathsplit(path: string; var directory, name: string): boolean;



implementation

uses sysutils,cmnutils;

const
 alphaupper = ['A'..'Z'];
 alphalower = ['a'..'z'];
 numeric    = ['0'..'9'];
 hex        = ['A'..'F','a'..'f'] + numeric;
 alphanumeric = alphaupper + alphalower + numeric;
 control    = [#00..#$1F,#$7F];

const

 URN_MAGIC = 'URN:';

 NID_MAX_REG = 52;
 NID_IANA: array[1..NID_MAX_REG] of string[16] =
 (
  'IETF',
  'PIN',
  'ISSN',
  'OID',
  'NEWSML',
  'OASIS',
  'XMLORG',
  'PUBLICID',
  'ISBN',
  'NBN',
  'WEB3D',
  'MPEG',
  'MACE',
  'FIPA',
  'SWIFT',
  'LIBERTY',
  'IPTC',
  'UUID',
  'UCI',
  'CLEI',
  'TVA',
  'FDC',
  'ISAN',
  'NZL',
  'OMA',
  'IVIS',
  'S1000D',
  'NFC',
  'ISO',
  'XMPP',
  'GEANT',
  'SERVICE',
  'SMPTE',
  'EPC',
  'EPCGLOBAL',
  'CGI',
  'OGC',
  'EBU',
  '3GPP',
  'DVB',
  'NENA',
  'CABLELABS',
  'DGIWG',
  'SCHAC',
  'OGF',
  'UCODE',
  'URN-1',
  'URN-2',
  'URN-3',
  'URN-4',
  'URN-5',
  'URN-6'
 );


const
 URI_PATH_SEPARATOR = '/';
 URI_QUERY_SEPARATOR = '?';
 URI_MAX_SCHEMES = 50;

 uri_schemes: array[1..URI_MAX_SCHEMES] of string[16] =
 (
  'ftp',
  'http',
  'gopher',
  URI_SCHEME_NAME_EMAIL,
  'news',
  'nntp',
  'telnet',
  'wais',
  'file',
  'prospero',
  'z39.50s',
  'z39.50r',
  'cid',
  'mid',
  'vemmi',
  'service',
  'imap',
  'nfs',
  'acap',
  'rtsp',
  'tip',
  'pop',
  'data',
  'dav',
  'opaquelocktoken',
  'sip',
  'sips',
  'tel',
  'fax',
  'modem',
  'ldap',
  'https',
  'soap.beep',
  'soap.beeps',
  'xmlrpc.beep',
  'xmlrpc.beeps',
  'urn',
  'go',
  'h323',
  'ipp',
  'tftp',
  'mupdate',
  'pres',
  'im',
  'mtqp',
  'iris.beep',
  'dict',
  'afs',
  'tn3270',
  'mailserver'
 );


 uri_scheme_chars = ['a'..'z','0'..'9','+','-','.'];
 uri_scheme_start_chars = alphalower;
 langcode_chars = alphalower;
 
 uri_host_chars = ['a'..'z','0'..'9','.','-'];

function mime_isvalidcontenttype(const s: string): boolean;
var
 idx: integer;
 typestr: string;
 subtypestr: string;
 i: integer;
begin
 mime_isvalidcontenttype:=false;
 idx:=pos('/',s);
 if idx = 0 then
   exit;
 typestr:=copy(s,1,idx-1);
 subtypestr:=copy(s,idx+1,length(s));
 for i:=1 to length(typestr) do
   begin
     if typestr[i] in 
       (control+[' ','(','/',')','<','>','@',';',':','\', '"','[',']','?','='])
     then
       exit;
   end;
 for i:=1 to length(subtypestr) do
   begin
     if subtypestr[i] in 
       (control+[' ','(','/',')','<','>','@',';',':','\', '"','[',']','?','='])
     then
       exit;
   end;
 mime_isvalidcontenttype:=true;
end;


{***********************************************************************
                            URM
***********************************************************************}

{ NID's can either start with X- for experimental
  versions, or are registered with the IANA.
}
function urn_isvalidnid(nid: string): boolean;
var
 i: integer;
begin
  urn_isvalidnid := false;
  nid:=UpperCase(nid);
  for i:=1 to NID_MAX_REG do
    begin
      if nid = NID_IANA[i] then
        begin
          urn_isvalidnid := true;
          exit;
        end;
    end;
  if pos('X-',nid) = 1 then
     begin
       for i:=3 to length(nid) do
          begin
            if not ((nid[i] in alphanumeric) or (nid[i] = '-')) then
               exit;
          end;
        urn_isvalidnid := true;
        exit;
     end;
end;


function urn_isvalid(s: string): boolean;
var
 urnid: string;
 nidstr: string;
 idx: integer;
 i: integer;
begin
 urn_isvalid := false;
 { verify the identifier }
 if length(s) < length(URN_MAGIC) then
   exit;
 urnid:=copy(s,1,4);
 delete(s,1,4);
 if UpperCase(urnid) <> URN_MAGIC then
   exit;
 { verify the NID }
 idx:=pos(':',s);
 if idx = 0 then
   exit;
 nidstr:=copy(s,1,idx-1);
 delete(s,1,idx);
 if length(nidstr) = 0 then
   exit;
 if not (nidstr[1] in alphanumeric) then
   exit;
 if (length(nidstr) > 31) or (length(nidstr) < 1) then
   exit;
 for i:=2 to length(nidstr) do
  begin
    if not ((nidstr[i] in alphanumeric) or (nidstr[i] = '-')) then
       exit;
  end;
 { verify the NSS }
 if length(s) = 0 then exit;
 for i:=1 to length(s) do
   begin
     if (s[i] in (alphanumeric+['(',')','+',',','-','.',':','=','@',';','$',
                   '_','!','*',''''])) then
       continue
     else
     { escape character }
     if s[i] = '%' then
       begin
         { check if not going beyond the bounds of the values }
         if (i+2) > length(s) then
           exit;
         if not (s[i+1] in hex) then
           exit;
         if not (s[i+2] in hex) then
           exit;
       end
     else
       exit;
   end;
   urn_isvalid:=true;
end;

 function urn_pathsplit(path: string; var namespace, nss: string): boolean;
 var
  idx: integer;
 begin
   { verify the NID }
   idx:=pos(':',path);
   namespace:=LowerCase(copy(path,1,idx-1));
   delete(path,1,idx);
   nss:=path;
   urn_pathsplit:=true;
 end;

function urn_create(const nidstr, nss: string; var urn: string): boolean;
 var
   b: boolean;
 Begin
   urn_create := False;
   urn:=URN_MAGIC;
   b:=urn_isvalidnid(nidstr);
   urn := urn + nidstr + ':' + nss;
   if b then
     b := urn_isvalid(urn);
   urn_create := b;  
 end;


function urn_split(urn:string; var urnidstr,nidstr,nssstr: string): boolean;
var
 idx: integer;
begin
  if not urn_isvalid(urn) then
    begin
      urn_split := false;
      exit;
    end;
 urnidstr:=UpperCase(copy(urn,1,4));
 delete(urn,1,4);
 { verify the NID }
 idx:=pos(':',urn);
 nidstr:=UpperCase(copy(urn,1,idx-1));
 delete(urn,1,idx);
 nssstr:=urn;
 urn_split:=true;
end;



function IsValidLangCode(const s: string): boolean;
 var
  i: integer;
 Begin
   isValidLangCode:=False;
   { ISO 638 only allows 2 or characters language tags }
   if not ((length(s)=2) or (length(s)=3)) then
     exit;
   for i:=1 to length(s) do
     begin
       if not (s[i] in langcode_chars) then
          exit;
     end;
   IsValidLangCode:=True;
 end;


function langtag_split(const s: string; var primary,region: string): boolean;
const
  PRIMARY_TAG_PRIVATE = 'x-';
  PRIMARY_TAG_RESERVED= 'i-';
var
 tmpStr: string;
 isInternal: string;
 res: string;
 i: integer;
begin
  primary:='';
  region:='';
  langtag_split:=false;
     
  { Private/Reserved tag? }
  isInternal:='';
  tmpStr:=s;
  if (pos(PRIMARY_TAG_PRIVATE,tmpStr)=1) or (pos(PRIMARY_TAG_RESERVED,tmpStr)=1) then
    Begin
      isInternal:=Copy(tmpStr,1,length(PRIMARY_TAG_PRIVATE));
      delete(tmpStr,1,length(PRIMARY_TAG_PRIVATE));
    end;
  { Now get the primary tag value }
  res:=StrToken(TmpStr,'-',False);
  { If the primary tag value more than 8 characters, then it is surely invalid }
  if (length(res) > 8) then
    Begin
      exit;
    end;
  res:=LowerCase(res);
  if isInternal='' then
    Begin
      if not IsValidLangCode(res) then
        Begin
          exit;
        end;
    end
  else
    Begin
      res:=isInternal+res;
    end;
  { Nothing else! }
  primary:=res;
  {** We only have a primary language value }
  if length(TmpStr) = 0 then
    Begin
      langtag_split:=True;
      exit;
    end;
  {** Try to find the region }
  while (length(TmpStr) > 0) do
   Begin
     {** Verify if we have a subtag, but verify if it is a private tag }
     isInternal:='';
      if (pos(PRIMARY_TAG_PRIVATE,tmpStr)=1) or (pos(PRIMARY_TAG_RESERVED,tmpStr)=1) then
        Begin
          isInternal:=Copy(tmpStr,1,length(PRIMARY_TAG_PRIVATE));
          delete(tmpStr,1,length(PRIMARY_TAG_PRIVATE));
        end;
      res:=StrToken(TmpStr,'-',False);
      res:=trim(res);
      { If we just an empty string, there is a problem! }
       if (length(res) = 0) or (length(res) > 8) then
         exit;
      { 3 digihts, probably a region code }
       if (length(res) = 3) then
         begin
            if  (res[1] in ['0'..'9']) and
                (res[2] in ['0'..'9']) and
                (res[3] in ['0'..'9']) then
                  Begin
                    region:=res;
                    break;
                  end;
         end;

       { If there are 2 characters, then this is the region code! }
       if (length(res) = 2) then
        Begin
          { Verify if the values are valid }
          { If 2 characters, only composed to alphabetic characters }
             for i:=1 to length(res) do
               Begin
                if not (res[i] in ['A'..'Z','a'..'z']) then
                   exit;
               end;
          region:=res;
          break;
        end;
   end;
  langtag_split:=True;         
end;


function langtag_isvalid(const s: string): boolean;
var
 primary,sub: string;
begin
 langtag_isvalid:=langtag_split(s,primary,sub);
end;

{***********************************************************************
                            URI
***********************************************************************}

 {** Checks if the URI is conformant to the specification defined in IETFC 
     IETF RFC 3986.
     @param(scheme The scheme to check)
     @returns(True if the scheme is valid, or false if the scheme has 
       an invalid syntax).
 }
 function uri_isvalidscheme(scheme: string): boolean;
 var
  i: integer;
 begin
   uri_isvalidscheme:=false;
   scheme:=LowerCase(scheme);
   if length(scheme) < 1 then
     exit;
   { Check the first character }
   if not (scheme[1] in uri_scheme_start_chars) then
      exit;
   if length(scheme) = 1 then
      begin
        uri_isvalidscheme:=True;
        exit;
      end;
   for i:=2 to length(scheme) do
     begin
       if not (scheme[i] in uri_scheme_chars) then
          exit;
     end;
   uri_isvalidscheme:=true;
 end;

 function uri_isvalidhost(host: string): boolean;
 var
  i: integer;
 begin
   host:=LowerCase(host);
   uri_isvalidhost:=false;
   for i:=1 to length(host) do
     begin
       if not (host[i] in uri_host_chars) then
          exit;
     end;
   uri_isvalidhost:=true;
 end;


 function uri_split(uri: string; var scheme,
   authority,path, query: string): boolean;
 var
  idx: integer;
  i: integer;
  present_path: boolean;
  present_authority: boolean;
 begin
   path:='';
   scheme:='';
   path:='';
   authority:='';
   query:='';
   uri_split:=false;
   present_path:=false;
   present_authority:=false;
   { Verify if there is a scheme present }
   idx:=pos(':',uri);
   { There is a scheme - extract it and check its validity }
   if idx > 1 then
     begin
       scheme:=copy(uri,1,idx-1);
       delete(uri,1,idx);
       { Determine the scheme type }
       scheme:=LowerCase(scheme);
       uri_split:=uri_isvalidscheme(scheme);
       {********* Check presence of the authority **********}
       if pos('//',uri) = 1 then
       begin
         { This seems to be valid! }
         delete(uri,1,2);
         {** Extract the authority information }
         for i:=1 to length(uri) do
           begin
             { The authority component is terminated
               by one of these characters }
             if uri[i] in ['?','/'] then
                break;
             authority:=authority+uri[i];
           end;
         { delete the authority part of the URI }
         delete(uri,1,i-1);
         present_authority:=true;
       end;
       {********* Check presence path **********}
       idx:=pos(URI_PATH_SEPARATOR,uri);
       if (idx = 1) then
       begin
            path:=uri[1];
            {** Extract the path information }
            for i:=2 to length(uri) do
             begin
               { The path component is terminated
                 by a query separator or end of string }
               if uri[i] in ['?'] then
                  break;
               path:=path+uri[i];
           end;
           delete(uri,1,i-1);
           path:=trim(path);
           present_path:=true;
       end;
       {********* Check presence of query **********}
       { Query is only available if there is an     }
       { authority, or abs_path                     }
       idx:=pos(URI_QUERY_SEPARATOR,uri);
       if (idx = 1) and (present_path or present_authority) then
         begin
           { Do not keep the query separator }
           query:=copy(uri,idx+1,length(uri));
           delete(uri,idx,length(uri));
           { Copy the actual name of the resource to
             access from the directories }
           query:=trim(query);
         end;
       {********* This is an opaque string **********}
       { If authority and path not present           }
       if (present_path=false) and (present_authority=false) then
         begin
           { Keep the path separator }
           path:=copy(uri,idx,length(uri));
           delete(uri,idx,length(uri));
           { Copy the actual name of the resource to
             access from the directories }
           path:=trim(path);
         end;
   end;
 end;

 function http_pathsplit(path: string; var directory, name: string): boolean;
 var
  i: integer;
 begin
   http_pathsplit:=true;
   directory:=trim(path);
   name:='';
   { If the path is empty, do nothing - simply exit }
   if length(directory) = 0 then
     exit;
   { This is probably a filename }
   if directory[length(directory)] <> URI_PATH_SEPARATOR then
     begin
       for i:=length(directory) downto 1 do
         begin
          if directory[i] = URI_PATH_SEPARATOR then
            break;
          name:=directory[i] + name;
         end;
       delete(directory,i,length(directory));
     end;
 end;

 function file_pathsplit(path: string; var directory, name: string): boolean;
 begin
    file_pathsplit:=http_pathsplit(path,directory,name);
 end;







end.

{
  $Log: not supported by cvs2svn $
  Revision 1.13  2012/02/16 05:40:08  carl
  + Added standard compiler switches to all units
  - Replace strings by sysutils
  + Added Latin <-> UTF-8 conversion routines
  + Updated IETF Locale parsing routines with new standard.
  + Updated country codes

  Revision 1.12  2011/11/24 00:27:37  carl
  + update to new architecture of dates and times, as well as removal of some duplicate files.

  Revision 1.11  2010/01/21 11:56:56  carl
   * Bugfix with uri_pathsplit when the path is empty, avoids runtime error.

  Revision 1.10  2006/08/31 03:06:56  carl
  + Better documentation
  + Updated URN Namespace identifiers to list of 2006-08-28.

  Revision 1.9  2006/02/11 16:54:50  carl
    * Bugfix with URI validation

  Revision 1.8  2005/01/08 21:37:45  carl
    + better comments

  Revision 1.7  2005/01/06 03:25:51  carl
    + uri validation and splitting routines, compatible with URL parsing

  Revision 1.6  2004/12/26 23:41:22  carl
    + added some separator constants

  Revision 1.5  2004/11/21 19:52:57  carl
    + some const parameters for strings
    - remove some warnings

  Revision 1.4  2004/11/09 03:53:27  carl
   + IETF RFC 1766 language code parsing routines

  Revision 1.3  2004/06/20 18:49:38  carl
    + added  GPC support

  Revision 1.2  2004/06/17 11:45:48  carl
    + added documentation

}