{ This program converts 
  an ISO 3166 semi-colon separated
  value, and creates a table.
 

  This requires both the french and
  English versions of the list.

  The output is written to iso3166.inc
}
{$X+}
program convert;

uses
  fpautils,
  tpautils,
  unicode,
  utils;



const
  MAX_LINES = 255;
  
type
  TCountryRecord = record
    name_fr: pshortstring;
    name_en: pshortstring;
    code: string[2];
  end;


var
 Entries: array[1..MAX_LINES] of TCountryRecord;



var
 EnFile: Text;
 FrFile: Text;
 i: integer;
 s: string;
 countryname: shortstring;
 countrycode: string;
 idxpos: integer;
 T: Text;
 maxentries: integer;
Begin
 Fillchar(Entries,sizeof(entries),#0);
 { Start reading the english text file }
 Assign(EnFile,'list-e~1.txt');
 Reset(EnFile);
 i:=1;
 Repeat
   Readln(EnFile,s);
   if pos(';',s) <> 0 then
     begin
       idxpos := pos(';',s);
       countryname:=copy(s,1,idxpos-1);
       countrycode:=copy(s,idxpos+1,length(s));
       Entries[i].name_en:=stringdup(countryname);
       Entries[i].code:=countrycode;
       inc(i);
     end;
 Until Eof(EnFile);
 maxentries:=i-1;
 Close(Enfile);
 Assign(FrFile,'list-f~1.txt');
 Reset(FrFile);
 Repeat
   Readln(FrFile,s);
   if pos(';',s) <> 0 then
     begin
       idxpos := pos(';',s);
       countryname:=copy(s,1,idxpos-1);
       countrycode:=copy(s,idxpos+1,length(s));
       { Search for our entry }
       for i:=1 to MAX_LINES do
         begin
           if Entries[i].code = countrycode then
             begin
                Entries[i].name_fr:=stringdup(countryname);
                break;
             end;
         end;
     end;
 Until Eof(FrFile);
 Close(FrFile);
 { Now write the file }
 Assign(T,'iso3166.inc');
 Rewrite(T);
 WriteLn(T,'const');
 WriteLn(T,'  MAX_ENTRIES =',maxentries,';');
 WriteLn(T,'type');
 WriteLn(T,'  TCountryInfo = record');
 WriteLn(T,'    name_fr: string[44];');
 WriteLn(T,'    name_en: string[44];');
 WriteLn(T,'    code: string[2];');
 WriteLn(T,'    active: boolean;');
 WriteLn(T,'  end;');
 WriteLn(T);
 WriteLn(T);
 WriteLn(T,'const');
 WriteLn(T,'  CountryInfo: array[1..MAX_ENTRIES] of TCountryInfo = (');
 for i:=1 to maxentries do
   begin
     WriteLn(T,'  (');
     Write(T,'   name_fr: ''');
     for idxpos:=1 to length(Entries[i].Name_fr^) do
        begin
          if Entries[i].Name_fr^[idxpos] = '''' then
            begin
               Write(T,'''');
               Write(T,'''');
               Write(T,'''');
            end;
            Write(T,Entries[i].Name_fr^[idxpos]);
        end;
     WriteLn(T,''';');   
     Write(T,'   name_en: ''');
     for idxpos:=1 to length(Entries[i].Name_en^) do
        begin
          if Entries[i].Name_en^[idxpos] = '''' then
            begin
               Write(T,'''');
               Write(T,'''');
               Write(T,'''');
            end;
            Write(T,Entries[i].Name_en^[idxpos]);
        end;
     WriteLn(T,''';');   
     WriteLn(T,'   code: ''',Entries[i].code,''';');
     WriteLn(T,'   active: true');
     if i <> maxentries then
       WriteLn(T,'  ),')
     else
       WriteLn(T,'  )')
   end;
 WriteLn(T,');');
 Close(T);
end.