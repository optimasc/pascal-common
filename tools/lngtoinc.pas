{ This converts the data of the IANA Registered language
  names to an array of records in pascal format.
}
program lngtoinc;

uses utils,tpautils,dos,objects;


const
  CHARSET_LENGTH_NAME = 24;
  CHARSET_LENGTH_ALIAS = 16;
  CHARSET_MAX_ALIASES = 10;
  CHARSET_MAX_RECORDS = 255;

type
  pcharrecord = ^charrecord;
  charrecord = record
    mimename:string[CHARSET_LENGTH_NAME];
    name:string[CHARSET_LENGTH_NAME];
    value: word;
    aliases: array[1..CHARSET_MAX_ALIASES] of string[CHARSET_LENGTH_ALIAS];
  end;

  trecs = array[1..CHARSET_MAX_RECORDS] of ^charrecord;

  TRecCollection = object(TSortedCollection)
    procedure FreeItem(Item: pointer); virtual;
    FUNCTION Compare (Key1, Key2: Pointer): integer;virtual;
  end;

const
 NAME_STRING = 'Name: ';
 MIME_STRING = '(preferred MIME name)';
 MIB_STRING  = 'MIBenum: ';
 SOURCE_STRING = 'Source: ';
 ALIAS_STRING = 'Alias: ';

  procedure TRecCollection.FreeItem(Item: pointer);
  begin
    if assigned(Item) then Dispose(pcharrecord(Item));
  end;
  
  FUNCTION TRecCollection.Compare (Key1, Key2: Pointer): integer;
  VAR I, J: integer; P1, P2: PString;
  BEGIN
     P1 := @PCharRecord(Key1)^.name;                               { String 1 pointer }
     P2 := @PCharRecord(Key2)^.name;                               { String 2 pointer }
     If (Length(P1^)<Length(P2^)) Then J := Length(P1^)
       Else J := Length(P2^);                           { Shortest length }
     I := 1;                                            { First character }
     While (I<J) AND (P1^[I]=P2^[I]) Do Inc(I);         { Scan till fail }
     If (I=J) Then Begin                                { Possible match }
     { * REMARK * - Bug fix   21 August 1997 }
       If (P1^[I]<P2^[I]) Then Compare := -1 Else       { String1 < String2 }
         If (P1^[I]>P2^[I]) Then Compare := 1 Else      { String1 > String2 }
         If (Length(P1^)>Length(P2^)) Then Compare := 1 { String1 > String2 }
           Else If (Length(P1^)<Length(P2^)) Then       { String1 < String2 }
             Compare := -1 Else Compare := 0;           { String1 = String2 }
     { * REMARK END * - Leon de Boer }
     End Else If (P1^[I]<P2^[I]) Then Compare := -1     { String1 < String2 }
       Else Compare := 1;                               { String1 > String2 }
  END;
  



  procedure addmimename(mimename: string; var rec: charrecord);
  begin
   mimename:=trimleft(mimename);
   mimename:=trimright(mimename);
   if length(mimename) > CHARSET_LENGTH_NAME then
     Assert(False);
   rec.mimename:=upstring(mimename);
  end;

  procedure addname(name: string; var rec: charrecord);
  begin
   name:=trimleft(name);
   name:=trimright(name);
   if length(name) > CHARSET_LENGTH_NAME then
   begin
     WriteLn('WARNING: Truncating value : ',name);
     delete(name,CHARSET_LENGTH_NAME,length(name));
   end;
   rec.name:=upstring(name);
  end;

  procedure initrecord(var rec: charrecord);
  var i: integer;
  begin
    fillchar(rec,sizeof(rec),#0);
    rec.mimename:='';
    rec.name:='';
    rec.value := 0;
    for i:=1 to CHARSET_MAX_ALIASES do
    begin
      rec.aliases[i]:='';
    end;
  end;

  procedure addalias(alias:string; var rec: charrecord; var currentalias: integer);
  begin
    alias:=trimleft(alias);
    alias:=trimright(alias);
    if length(alias) > CHARSET_LENGTH_NAME then
    begin
     WriteLn('WARNING: Truncating value : ',alias);
     delete(alias,CHARSET_LENGTH_ALIAS,length(alias));
    end;
    inc(currentalias);
    if currentalias > CHARSET_MAX_ALIASES then
      Assert(False);
    rec.aliases[currentalias]:=upstring(alias);
  end;


  procedure writecharencodingtable(var recs: TCollection);
  var
   T: text;
   i: integer;
  begin
    Assign(T,'charenc.inc');
    Rewrite(T);
    WriteLn(T,'type');
    WriteLn(T,'charencoderecord = record');
    WriteLn(T,#9'name: string[CHARSET_LENGTH_NAME];');
    WriteLn(T,#9'encoding: smallint;');
    WriteLn(T,'end;');
    WriteLn(T);
    WriteLn(T,'const');
    WriteLn(T,'charencoding: array[1..CHARSET_RECORDS] of charencoderecord= (');
    for i:=0 to recs.count-1 do
      begin
        WriteLn(T,'(');
        WriteLn(T,#9'name: ''',pcharrecord(recs.at(i))^.name,''';');
        WriteLn(T,#9'encoding: CHAR_ENCODING_UNKNOWN');
        if i<>recs.count-1 then
           WriteLn(T,'),')
        else
           WriteLn(T,')');
      end;
    WriteLn(T,');');
    Close(T);
  end;

  procedure reorganize(var recs:charrecord);
  var
   i,j,k: integer;
   s: string;
   found: boolean;
  begin
       if recs.mimename <> '' then
        begin
           s:=recs.name;
           addname(recs.mimename,recs);
           if s <> '' then
            begin
             found:=false;
             for j:=1 to CHARSET_MAX_ALIASES do
             begin
               if recs.aliases[j] = '' then
                begin
                  recs.aliases[j]:=s;
                  found:=true;
                  break;
                end;
            end;
            if not found then
              Assert(False);
          end;
   end;
 end;


var
 s: string;
 T: text;
 Collection: TRecCollection;
 idx,idx1: integer;
 mibstring: string;
 rec: pcharrecord;
 currentalias: integer;
 i,j,k: integer;
 p: pchar;
 Year,Day,Month,DayOfWeek: word;
begin
 Collection.init(16,16);
 Assign(T,'lang.txt');
 Reset(T);
 GetDate(Year,Month,Day,DayOfWeek);
 Repeat
   currentalias:=0;
   ReadLn(T, s);
   if EOF(t) then break;
   new(rec);
   initrecord(rec^);
   { NAME STRING }
   idx:=pos(NAME_STRING,s);
   if idx = 1 then
    begin
      delete(s,1,length(NAME_STRING));
      idx:=pos('[',s);
      if idx <> 0 then
        delete(s,idx,length(s));
      { verify if this is the preferred MIME name }
      idx:=pos(MIME_STRING,s);
      if idx <> 0 then
        begin
          delete(s,idx,length(s));
          addmimename(s,rec^);
        end
      else
        begin
          addname(s,rec^);
        end;
    end;
   { GO TO MIBENUM }
   Repeat
     ReadLn(T,s);
     if EOF(t) then break;
     idx :=pos(MIB_STRING,s);
   Until idx >0;
   delete(s,idx,length(MIB_STRING));
   s:=trimleft(s);
   s:=trimright(s);
   mibstring:=s;
   { GO TO SOURCE STRING }
   Repeat
     ReadLn(T,s);
     if EOF(t) then break;
     idx :=pos(SOURCE_STRING,s);
   Until idx >0;
   { GO TO ALIAS STRING , and for each alias string}
   Repeat
     ReadLn(T,s);
     if EOF(t) then break;
     idx :=pos(ALIAS_STRING,s);
   until (idx > 0);
   delete(s,idx,length(ALIAS_STRING));
   { verify if this is the preferred MIME name }
   idx:=pos(MIME_STRING,s);
   if idx <> 0 then
      begin
         delete(s,idx,length(s));
         addmimename(s,rec^);
      end;
   if s <> 'None' then
     begin
        if idx = 0 then
           addalias(s,rec^,currentalias);
        Repeat
          ReadLn(T,s);
          if EOF(t) then break;
          idx :=pos(ALIAS_STRING,s);
          if idx <> 0 then
            begin
              delete(s,idx,length(ALIAS_STRING));
              { verify if this is the preferred MIME name }
              idx1:=pos(MIME_STRING,s);
              if idx1 <> 0 then
                begin
                  delete(s,idx1,length(s));
                  addmimename(s,rec^);
                end
              else
                addalias(s,rec^,currentalias);
            end;
        Until idx=0;
     end
   else
     begin
       Readln(T,s);
       if s <> '' then RunError(255);
     end;
  { Reorganize :
    IF there is a MIME name, it is set to
    name, and name is set to an ALIAS.
  }
   Reorganize(rec^);
   Collection.insert(rec);
 Until Eof(T);
 Close(T);

 { Now write the data }
 { First Turbo pascal assembler file }
 Assign(T, 'charset.asm');
 Rewrite(T);
 WriteLn(T,'.MODEL LARGE, PASCAL');
 WriteLn(T,'.CODE');
 WriteLn(T,'charsetsproc PROC FAR');
 WriteLn(T,#9'PUBLIC charsetsproc');
 for i:=0 to Collection.count-1 do
 begin
   WriteLn(T,';-------------------------------------------------------');
   WriteLN(T,'; rec[',decstr(i,2)+'].name:string[CHARSET_LENGTH_NAME] ');
   for j:=0 to (CHARSET_LENGTH_NAME) do
     begin
       if ((j mod 16) = 0) then
       begin
         WriteLn(T);
         Write(T,' DB ');
       end;
       if ((j mod 16) <> 0) then
         Write(T,',');
       Write(T,hexstr(ord(pcharrecord(Collection.at(i))^.name[j]),3),'h');
     end;
     WriteLn(T);
   p:=@pcharrecord(Collection.at(i))^.value;
   WriteLN(T,'; rec[',decstr(i,2)+'].value:word ');
   Write(T,' DB ');
   Write(T,hexstr(ord(p[0]),3),'h,');
   Write(T,hexstr(ord(p[1]),3),'h');
   WriteLn(T);

  for k:=1 to CHARSET_MAX_ALIASES do
    begin
      WriteLN(T,'; rec[',decstr(i,2)+'].aliases['+decstr(k,2)+']:string[CHARSET_LENGTH_ALIAS] ');
      for j:=0 to (CHARSET_LENGTH_ALIAS) do
        begin
          if ((j mod 16) = 0) then
           begin
             WriteLn(T);
             Write(T,' DB ');
          end;
          if ((j mod 16) <> 0) then
             Write(T,',');
          Write(T,hexstr(ord(pcharrecord(collection.at(i))^.aliases[k][j]),3),'h');
         end;
         WriteLn(T);
    end;
 end;
 WriteLn(T,'charsetsproc ENDP');
 WriteLn(T,'END');
 Close(T);
 { Now the actual pascal include file }
 Assign(T, 'charset.inc');
 Rewrite(T);
 WriteLn(T,'{  IANA Registered character sets }');
 WriteLn(T,'{  Generated : ',{GetISODateString(Year,Month,Day),}' }');
 WriteLn(T,'const');
 WriteLn(T,#9'CHARSET_LENGTH_NAME = ',CHARSET_LENGTH_NAME,';');
 WriteLn(T,#9'CHARSET_LENGTH_ALIAS = ',CHARSET_LENGTH_ALIAS,';');
 WriteLn(T,#9'CHARSET_MAX_ALIASES = ',CHARSET_MAX_ALIASES,';');
 WriteLn(T,#9'CHARSET_RECORDS = ',Collection.Count,';');
 WriteLn(T);
 WriteLn(T,'type');
 WriteLn(T,' charsetrecord = record');
 WriteLn(T,#9'name: string[CHARSET_LENGTH_NAME];');
 WriteLn(T,#9'value: word;');
 WriteLn(T,#9'aliases: array[1..CHARSET_MAX_ALIASES] of string[CHARSET_LENGTH_ALIAS];');
 WriteLn(T,' end;');
 WriteLn(T);
 WriteLN(T,'{$ifndef tp}');
 WriteLn(T);
 WriteLn(T,'const');
 WriteLN(T,'charsets: array[1..CHARSET_RECORDS] of charsetrecord = (');
 for i:=0 to Collection.count-1 do
 begin
    WriteLn(T,'(');
    WriteLn(T,#9#9'name: ''',pcharrecord(Collection.at(i))^.name,''';');
    WriteLn(T,#9#9'value : ',pcharrecord(Collection.at(i))^.value,';');
    WriteLn(T,#9#9'aliases : ');
    WriteLn(T,#9#9#9'(');
    for j:=1 to CHARSET_MAX_ALIASES do
      begin
        Write(T,#9#9#9'''',pcharrecord(Collection.at(i))^.aliases[j],'''');
        if j <> CHARSET_MAX_ALIASES then
          WriteLn(T,',')
        else
          WriteLn(T);
      end;
    WriteLn(T,#9#9#9')');
    if i <> Collection.count-1 then
      WriteLn(T,'),')
    else
      WriteLn(T,'));')
 end;
 WriteLN(T);
 WriteLn(T,'{$else}');
 WriteLn(T,'procedure charsetsproc;external; {$L charset.obj}');
 WriteLn(T,'{$endif}');
 Close(T);
 { Write character encoding table }
{ WriteCharEncodingTable(Collection);}
 Collection.done;
end.

{
  $Log: not supported by cvs2svn $
}