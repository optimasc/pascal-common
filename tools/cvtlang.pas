{ This program converts 
  an ISO 639 pipe separated
  value, and creates a table.
 


  The output is written to iso639.inc
}
{$X+}
program cvtlang;

uses cmntyp,unicode,
  utils,
  dos,locale;



const
  MAX_LINES = 1024;
  
type
  TLangRecord = record
    name_fr: string;
    name_en: string;
    biblio_code: string[3];
    terminology_code: string[3];
    code: string[2];
  end;


var
 Entries: array[1..MAX_LINES] of TLangRecord;
 
 
{** Converts any character after 127 to a character literal representation }
function ToByte(c: char): string;
 var
  b: byte;
 Begin
   if ord(c) > 127 then
     Begin
       b:=ord(c);
       ToByte:=''''+'#'+decStr(b,0)+'''';
     end
   else
     Begin
       ToByte:=c;
     end
 end;


var
 Year,Month,Day,DayOfWeek:word;
 EnFile: Text;
 i,j: integer;
 s: string;
 biblio_code,terminology_code,code: string;
 name_en,name_fr: string;
 idxpos: integer;
 T: Text;
 k: integer;
 maxentries: integer;
 duplicate: boolean;
 maxCurLength: integer;
Begin
 GetDate(Year,Month,Day,DayOfWeek);
 Fillchar(Entries,sizeof(entries),#0);
 { Start reading the english text file }
 Assign(EnFile,'iso-63~1.txt');
 Reset(EnFile);
 maxCurLength:=0;
 i:=1;
 Repeat
   Readln(EnFile,s);
   if pos('|',s) <> 0 then
     begin
       idxpos := pos('|',s);
       biblio_code:=copy(s,1,idxpos-1);
       delete(s,1,idxpos);
       idxpos := pos('|',s);
       terminology_code:=copy(s,1,idxpos-1);
       delete(s,1,idxpos);
       idxpos := pos('|',s);
       code:=copy(s,1,idxpos-1);
       delete(s,1,idxpos);
       idxpos := pos('|',s);
       name_en:=copy(s,1,idxpos-1);
       if length(name_en) > maxCurLength then
         Begin
           maxCurLength:=length(name_en);
         end;
       delete(s,1,idxpos);
       name_fr:=s;
       if length(name_fr) > maxCurLength then
         Begin
           maxCurLength:=length(name_fr);
         end;

       { Check if there are already entries with this code,
         if so don't add them
       }
       duplicate:=false;
       for j:=1 to i do
         begin
           if (length(Entries[j].code) > 0) and (Entries[j].code = code) then
             begin
                duplicate:=true;
             end;
         end;
       if not duplicate then
          begin
            Entries[i].name_en:=name_en;
            Entries[i].name_fr:=name_fr;
            Entries[i].code:=code;
            Entries[i].biblio_code:=biblio_code;
            Entries[i].terminology_code:=terminology_code;
            inc(i);
         end;
     end;
 Until Eof(EnFile);
 maxentries:=i-1;
 Close(Enfile);
 { Now write the PASCAL file }
 Assign(T,'iso639d.pas');
 Rewrite(T);
 S:=GetISODateString(Year, Month, Day);
 WriteLn(T,'{ File Generated on ',S,' automatically }');
 WriteLN(T,'{ and encoded in the ISO-8859-1 character set}');
 WriteLn(T,'unit iso639d;');
 WriteLn(T);
 WriteLn(T,'interface');
 WriteLn(T);
 WriteLn(T,'const');
 WriteLn(T,'  MAX_ENTRIES =',maxentries,';');
 WriteLn(T,'type');
 WriteLn(T,'  TLangInfo = record');
 WriteLn(T,'    code: string[2];');
 WriteLn(T,'    biblio_code: string[3];');
 WriteLn(T,'    name_fr: pchar;');
 WriteLn(T,'    name_en: pchar');
 WriteLn(T,'  end;');
 WriteLn(T);
 WriteLn(T);
 WriteLn(T,'{$ifndef tp}');
 WriteLn(T,'const');
 WriteLn(T,'  LangInfo: array[1..MAX_ENTRIES] of TLangInfo = (');
 for i:=1 to maxentries do
   begin
     WriteLn(T,'  (');
     WriteLn(T,'   code: ''',Entries[i].code,''';');
     WriteLn(T,'   biblio_code: ''',Entries[i].biblio_code,''';');
     Write(T,'   name_fr: ''');
     for idxpos:=1 to length(Entries[i].Name_fr) do
        begin
          if Entries[i].Name_fr[idxpos] = '''' then
            begin
               Write(T,'''');
               Write(T,'''');
               Write(T,'''');
            end;
            Write(T,ToByte(Entries[i].Name_fr[idxpos]));
        end;
     WriteLn(T,''';');   
     Write(T,'   name_en: ''');
     for idxpos:=1 to length(Entries[i].Name_en) do
        begin
          if Entries[i].Name_en[idxpos] = '''' then
            begin
               Write(T,'''');
               Write(T,'''');
               Write(T,'''');
            end;
            Write(T,ToByte(Entries[i].Name_en[idxpos]));
        end;
     WriteLn(T,''';');   
     if i <> maxentries then
       WriteLn(T,'  ),')
     else
       WriteLn(T,'  )')
   end;
 WriteLn(T,');');
 WriteLn(T,'{$else}');
 WriteLn(T,'procedure langcodesproc; ');
 WriteLn(T,'{$endif}');
 WriteLn(T);
 WriteLn(T,'implementation');
 WriteLn(T);
 WriteLN(T,'{$ifdef TP}');
 WriteLn(T,'procedure langcodesproc; external; {$L iso639.obj}');
 WriteLN(T,'{$endif}');
 WriteLn(T);
 WriteLn(T,'end.');
 Close(T);
 { Now write the Assembler file }
 Assign(T,'iso639.asm');
 Rewrite(T);
 S:=GetISODateString(Year, Month, Day);
 WriteLn(T,'; File Generated on ',S,' automatically ');
 WriteLN(T,'; and encoded in the ISO-8859-1 character set}');
 
 WriteLn(T);
 WriteLn(T,'.MODEL LARGE, PASCAL');
 WriteLn(T,'.CODE');

 WriteLn(T,'langcodesdata PROC FAR');
 WriteLn(T,'PUBLIC langcodesdata');
 
 for i:=1 to maxentries do
   begin
     WriteLn(T,';-------------------------------------------------------');
     
     WriteLn(T,'; rec[',i,'].name_fr');
     WriteLn(T,'langNameFr',i,':');
     k:=0;
     for j:=1 to length(Entries[i].Name_fr) do
     begin
       if ((k mod 16) = 0) then
       begin
         WriteLn(T);
         Write(T,' DB ');
       end;
       if ((k mod 16) <> 0) then
         Write(T,',');
       Write(T,hexstr(ord(Entries[i].Name_fr[j]),3),'h');
       inc(k);
     end;
     Write(T,',00h');
     WriteLn(T);
     
     
     WriteLn(T,'; rec[',i,'].name_en');
     WriteLn(T,'langNameEn',i,':');
     
     k:=0;
     for j:=1 to length(Entries[i].Name_En) do
     begin
       if ((k mod 16) = 0) then
       begin
         WriteLn(T);
         Write(T,' DB ');
       end;
       if ((k mod 16) <> 0) then
         Write(T,',');
       Write(T,hexstr(ord(Entries[i].Name_En[j]),3),'h');
       inc(k);
     end;
     Write(T,',00h');
     WriteLn(T);
   end;
 WriteLn(T);
 WriteLn(T,'langcodesdata ENDP');
 
 
 WriteLn(T,'langcodesproc PROC FAR');
 WriteLn(T,'PUBLIC langcodesproc');
 
 for i:=1 to maxentries do
   begin
     WriteLn(T,';-------------------------------------------------------');
     
     WriteLn(T);
     WriteLn(T,'; rec[',i,'].code[2]');
     
     for j:=0 to (sizeof(Entries[i].code)-1) do
     begin
       if ((j mod 16) = 0) then
       begin
         WriteLn(T);
         Write(T,' DB ');
       end;
       if ((j mod 16) <> 0) then
         Write(T,',');
       Write(T,hexstr(ord(Entries[i].code[j]),3),'h');
     end;
     WriteLn(T);
     
     WriteLn(T);
     WriteLn(T,'; rec[',i,'].biblio_code[3]');
     
     for j:=0 to (sizeof(Entries[i].biblio_code)-1) do
     begin
       if ((j mod 16) = 0) then
       begin
         WriteLn(T);
         Write(T,' DB ');
       end;
       if ((j mod 16) <> 0) then
         Write(T,',');
       Write(T,hexstr(ord(Entries[i].biblio_code[j]),3),'h');
     end;
     WriteLn(T);
     
     
     WriteLn(T,'; rec[',i,'].name_fr');
     
     WriteLn(T,' DD ','langNameFr',i);

     WriteLn(T,'; rec[',i,'].name_en');
     
     WriteLn(T,' DD ','langNameEn',i);
     WriteLn(T);
   end;
 WriteLn(T);
 WriteLn(T,'langcodesproc ENDP');
 WriteLn(T,'END');
 
 
 Close(T);
end.
