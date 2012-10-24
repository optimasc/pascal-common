
const
 {** Minimal filesystem year for dates for this operating system **}
 MIN_FILE_YEAR   =  1970;
 
type
  {** @abstract(Returned by @link(FindFirstEx) and @link(FindNextEx)) }
  TSearchRecExt = record
    {** File statistics }
    Stats: TFileStats;
    {** Operating system specific data }
    IncludeAttr : longint;
    SearchAttr: TResourceAttributes;
    SearchSpec: utf8string;
    SearchDir: utf8string;
    DirPtr: pdir;
  end;


{
   $Log: not supported by cvs2svn $
   Revision 1.1  2006/10/16 22:26:03  carl
     + Generic POSIX templates for extdos

}