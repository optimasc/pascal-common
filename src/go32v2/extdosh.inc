
const
 {** Minimal filesystem year for dates for this operating system **}
 MIN_FILE_YEAR   =  1980;
 


type
  TSearchRecExt = record
    Stats: TFileStats;
    {** Operating system specific data *}
    FindHandle  : THandle;
    IncludeAttr : longint;
    SearchAttr: TResourceAttributes;
  end;
