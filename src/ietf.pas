{
 ****************************************************************************
    $Id: ietf.pas,v 1.3 2004-06-20 18:49:38 carl Exp $
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

function mime_isvalidcontenttype(s: shortstring): boolean;

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




implementation

uses utils;

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


function mime_isvalidcontenttype(s: shortstring): boolean;
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


end.

{
  $Log: not supported by cvs2svn $
  Revision 1.2  2004/06/17 11:45:48  carl
    + added documentation

}