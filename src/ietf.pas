{
 ****************************************************************************
    $Id: ietf.pas,v 1.8 2005-01-08 21:37:45 carl Exp $
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

    This unit contains routines to validate
    strings, and characters according to different
    IETF standards (such as URL's, URI's and MIME types).
    
}
unit ietf;

interface

uses
 tpautils,
 vpautils,
 dpautils,
 fpautils,
 gpautils
 ;

{----------------- MIME related routines ----------------}


function mime_isvalidcontenttype(const s: shortstring): boolean;

{------- RFC 1766 (language tags) related routines --------}

function langtag_isvalid(const s: string): boolean;

function langtag_split(const s: string; var primary,sub: string): boolean;

{----------------- URI related routines ----------------}
const
  {** Suggested start delimiter character for an URI, c.f. RFC  2396 }
  URI_START_DELIMITER_CHAR = '<';
  {** Suggested end delimiter character for an URI, c.f. RFC  2396 }
  URI_END_DELIMITER_CHAR = '>';
  URI_SCHEME_NAME_EMAIL = 'mailto';
  URI_SCHEME_SEPARATOR = ':';
  

 {** @abstract(Extract information from an URI string)
 

     Given an URI complete specification string, extract
     and return the scheme, authority, path and query
     components of the URI. The exact definition of
     these terms is specified in IETF RFC 2396.
     
     @param(url URI to check)
     @returns(FALSE if the URI is not valid, otherwise
       returns TRUE)
 }
 function uri_split(url: string; var scheme, authority,path, query: string): boolean;



{----------------- URN related routines ----------------}


{** @abstract(Verifies the validity of a complete URN string)

    This checks the conformance of the URN address. It
    is based on IETF RFC 2141.

    @returns(TRUE if this is a valid URN string)
}
function urn_isvalid(s: shortstring): boolean;

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
    @param(nidstr Namespace identifier NID
    @param(nssstr Namespace specific string NSS)
    @returns(TRUE if the operation was successfull, or
      FALSE if the URN is malformed)
}
function urn_split(urn:string; var urnidstr,nidstr,nssstr: string): boolean;

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

uses utils,iso639;

const
 alphaupper = ['A'..'Z'];
 alphalower = ['a'..'z'];
 numeric    = ['0'..'9'];
 hex        = ['A'..'F','a'..'f'] + numeric;
 alphanumeric = alphaupper + alphalower + numeric;
 control    = [#00..#$1F,#$7F];

const
 NID_MAX_REG = 21;
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
  'URN-1',
  'URN-2',
  'URN-3',
  'URN-4',
  'URN-5'
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
 uri_host_chars = ['a'..'z','0'..'9','.','-'];

function mime_isvalidcontenttype(const s: shortstring): boolean;
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
  nid:=upstring(nid);
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


function urn_isvalid(s: shortstring): boolean;
const
 URN_MAGIC = 'URN:';
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
 if upstring(urnid) <> URN_MAGIC then
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
   namespace:=lowstring(copy(path,1,idx-1));
   delete(path,1,idx);
   nss:=path;
   urn_pathsplit:=true;
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
 urnidstr:=upstring(copy(urn,1,4));
 delete(urn,1,4);
 { verify the NID }
 idx:=pos(':',urn);
 nidstr:=upstring(copy(urn,1,idx-1));
 delete(urn,1,idx);
 nssstr:=urn;
 urn_split:=true;
end;


function langtag_split(const s: string; var primary,sub: string): boolean;
const
  LANGTAG_MAX_LENGTH = 17; { 8 Alpha + 8 aLPHA + SEPARATOR }
  PRIMARY_TAG_PRIVATE = 'x';
  PRIMARY_TAG_RESERVED= 'i';
var
 index: integer;
 i: integer;
begin
  primary:='';
  sub:='';
  langtag_split:=false;
  if length(s) > LANGTAG_MAX_LENGTH then
    exit;
  { ISO 639 code, i, or x }
  if (length(s) = 2) or (length(s) = 1) then
    begin
     primary:=lowstring(copy(s,1,length(s)));
     if (primary = PRIMARY_TAG_PRIVATE) or
         (primary = PRIMARY_TAG_RESERVED) or IsValidLangCode(primary) then
         begin
           langtag_split:=true;
           exit;
         end;

    end
  else
    begin
      { Is there a subtype separator ? }
      index:=pos('-',s);
      if index = 0 then
         exit;
      primary:=lowstring(copy(s,1,index-1));
      sub:=copy(s,index+1,length(s));
      if (primary = PRIMARY_TAG_PRIVATE) or
         (primary = PRIMARY_TAG_RESERVED) or IsValidLangCode(primary) then
        begin
          { Seems to be valid - now check the subtag,
            simply check if there is whitespace }
          for i:=1 to length(sub) do
            begin
              if sub[i] in whitespace then
                exit;
            end;
          langtag_split:=true;
          exit;
        end;
    end;
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

 {** Checks if the URL is conformant to the specification
     defined in IETFC RFC 1738.
     @param(scheme The scheme to check)
     @returns(TRUE if the scheme is valid, or false if
         the scheme has an invalid syntax).
 }
 function uri_isvalidscheme(scheme: string): boolean;
 var
  i: integer;
 begin
   scheme:=lowstring(scheme);
   uri_isvalidscheme:=false;
   for i:=1 to length(scheme) do
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
   host:=lowstring(host);
   uri_isvalidhost:=false;
   for i:=1 to length(host) do
     begin
       if not (host[i] in uri_host_chars) then
          exit;
     end;
   uri_isvalidhost:=true;
 end;


 function uri_split(url: string; var scheme,
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
   uri_split:=true;
   present_path:=false;
   present_authority:=false;
   { Verify if there is a scheme present }
   idx:=pos(':',url);
   { There is a scheme - extract it and check its validity }
   if idx > 1 then
     begin
       scheme:=copy(url,1,idx-1);
       delete(url,1,idx);
       { Determine the scheme type }
       scheme:=lowstring(scheme);
       uri_split:=uri_isvalidscheme(scheme);
       {********* Check presence of the authority **********}
       if pos('//',url) = 1 then
       begin
         { This seems to be valid! }
         delete(url,1,2);
         {** Extract the authority information }
         for i:=1 to length(url) do
           begin
             { The authority component is terminated
               by one of these characters }
             if url[i] in ['?','/'] then
                break;
             authority:=authority+url[i];
           end;
         { delete the authority part of the URI }
         delete(url,1,i-1);
         present_authority:=true;
       end;
       {********* Check presence path **********}
       idx:=pos(URI_PATH_SEPARATOR,url);
       if (idx = 1) then
       begin
            path:=url[1];
            {** Extract the path information }
            for i:=2 to length(url) do
             begin
               { The path component is terminated
                 by a query separator or end of string }
               if url[i] in ['?'] then
                  break;
               path:=path+url[i];
           end;
           delete(url,1,i-1);
           path:=trim(path);
           present_path:=true;
       end;
       {********* Check presence of query **********}
       { Query is only available if there is an     }
       { authority, or abs_path                     }
       idx:=pos(URI_QUERY_SEPARATOR,url);
       if (idx = 1) and (present_path or present_authority) then
         begin
           { Do not keep the query separator }
           query:=copy(url,idx+1,length(url));
           delete(url,idx,length(url));
           { Copy the actual name of the resource to
             access from the directories }
           query:=trim(query);
         end;
       {********* This is an opaque string **********}
       { If authority and path not present           }
       if (present_path=false) and (present_authority=false) then
         begin
           { Keep the path separator }
           path:=copy(url,idx,length(url));
           delete(url,idx,length(url));
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