{ This unit is used to test the sysutils implementation
  and verify its conformance to Freepascal and Delphi.  }
  
Program TestSysU;

procedure test_StrAlloc;
Begin
 
end;

procedure test_StrBufSize;
Begin
end;

procedure test_StrCat;
var 
 Dst: array[0..9] of char;
 Src: array[0..4] of char;
 P : pchar;
Begin
 Dst := 'Hi!
 Src := 'Bye!';
 p:=StrCat(nil,Src);
 p:=StrCat(Dst,nil);
 p:=StrCat(Dst,Src);
end;

procedure test_StrComp;
Begin
end;

procedure test_StrCopy;
Begin
end;

procedure test_StrDispose;
Begin
end;

procedure test_StrECopy;
Begin
end;

procedure test_StrEnd;
Begin
end;

procedure test_StrLCat;
Begin
end;

procedure test_StrIComp;
Begin
end;

procedure test_StrLCopy;
Begin
end;

procedure test_StrLen;
Begin
end;

procedure test_StrLIComp;
Begin
end;

procedure test_StrLower;
Begin
end;

procedure test_StrMove;
Begin
end;

procedure test_StrNew;
Begin
end;

procedure test_StrPas;
Begin
end;

procedure test_StrPCopy;
Begin
end;


procedure test_StrPLCopy;
Begin
end;

procedure test_StrPos;
Begin
end;

procedure test_StrScan;
Begin
end;

procedure test_StrRScan;
Begin
end;


procedure test_StrUpper;
Begin
end;

Begin
  test_StrCat;   
end.