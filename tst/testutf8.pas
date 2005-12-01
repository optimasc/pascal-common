uses unicode;
var
 s:string;
 ucs4str: ucs4string;
 utf8str: string;
 p: pchar;
 pu: pucs4char;
Begin
 utf8str:='This éisতﻜ character';
 p:='This éisতﻜ character';
 s:=utf8strpastoascii('Carl Eric Codere');
 s:=utf8strpastoascii('Carl éric');
 s:=utf8strpastoascii('This éisতﻜ character' );
 pu:=ucs4strnew(p,'UTF-8');
 p:=UTF8Strnew(pu);
 WriteLn(s);
end.