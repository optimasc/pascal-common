
const
  {** File attribute: The filesystem has encrypted this file. }
  FILE_ATTR_ENCRYPTED =
  {** File attribute: This file is indicated as being a system file }
  FILE_ATTR_SYSTEM  =
  FILE_ATTR_DIRECTORY =
  {** File attribute: This file is indicated as being a temporary file
      that can be deleted at any time. }
  FILE_ATTR_TEMPORARY =
  {** File attribute: The filesystem as compressed this file }
  FILE_ATTR_COMPRESSED =
  {** File attribute: The file is actually a device }
  FILE_ATTR_DEVICE =
  {** File attribute: The file has been indexed }
  FILE_ATTR_INDEXED =
  

type
  stat_t = record
    {** Number of links that point to this file }
    links: integer;
    {** Time of last modification, -1 if unknown }
    st_mtime: tdatetime; 
    {** Time of last access. -1 if unknown }
    st_atime: tdatetime;
    {** Time of creation of resource, -1 if unknown }
    st_ctime: tdatetime;
    {** Size of the file in byte. -1 if unknown, or too big }
    st_size: big_integer_t;
    {** Attributes for this file }
    attributes: longword;
  end;
  
  


function getfileatime(fname: putf8char): tdatetime;

function getfilectime(fname: putf8char): tdatetime;

function getfilemtime(fname: putf8char): tdatetime;

function getfilesize(fname: putf8char): big_integer_t;

function getfileowner(fname: putf8char): string;

function getfileattributes(fname: put8char): string;

function setfileatime(fname: putf8char; newatime: tdatetime): integer;

function setfilemtime(fname: putf8char; newmtime: tdatetime): integer;

function getlinkcount(fname: putf8char): integer;

function getfileaccesses(fname: putf8char): integer;

function getfilestreamcount(fname: putf8char): integer;

