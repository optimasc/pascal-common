
type
  SearchRec = packed Record
  {Fill : array[1..21] of byte;  Fill replaced with below}
    DirPtr     : Pointer;     {directory pointer for reading directory}
    SearchAttr : Byte;        {attribute we are searching for}
    Fill       : Array[1..16] of Byte; {future use}
  {End of fill}
    Attr       : Byte;        {attribute of found file}
    Time       : LongInt;     {last modify date of found file}
    Size       : LongInt;     {file size of found file}
    Reserved   : Word;        {future use}
    Name       : String; {name of found file}
    SearchSpec : String; {search pattern}
    SearchDir  : String; { path we are searching in }
  End;
