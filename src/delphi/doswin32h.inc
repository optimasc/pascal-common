type
  Searchrec = Packed Record
    FindHandle  : THandle;
    W32FindData : TWin32FindData;
    ExcludeAttr : longint;
    time : longint;
    size : longint;
    attr : longint;
    name : string;
  end;

{
   $Log: not supported by cvs2svn $
}