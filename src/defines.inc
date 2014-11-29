(* This define is used to determine the compiler versions 
   as well compiler type being used to make compilation
   easier and more portable. The following defines will
   be created:
   
     TP = Turbo Pascal / Borland Pascal compiler versions
     Delphi1 = Delphi 2
     FPC1    = Freepascal
     
   Platform directives:
      LINUX
      WIN32
      WIN32
      MSWINDOWS
      MSDOS
      
   CPU Directives:
      CPU386
      CPU86
      
      
   Compiler information support:
   
   ASSEMBLER = Assembler syntax is supported (Defined in Delphi)
   UNICODE   = Unicode is the default string type (Defined in certain versions of Delphi)
   
   SUPPORT_INT64          = Support for the int64 datatype.
   SUPPORT_WIDESTRING     = Support for the Widestring datatype.
   SUPPORT_ANSISTRING     = Support for the AnsiString datatype
   SUPPORT_LARGE_STREAMS  = Support for streams (64-bit)
   SUPPORT_CLASSES        = Support for class type objects, otherwise only old format objects are supported.
*)



(* Turbo Pascal management *)

(* Turbo Pascal for Windows 1.0 *)
{$IFDEF VER10}
{$DEFINE TP}
{$ENDIF}

(* Turbo Pascal for Windows 1.5 *)
{$IFDEF VER10}
{$DEFINE TP}
{$ENDIF}


(* Turbo Pascal 4.0 *)
{$IFDEF VER40}
{$DEFINE TP}
{$DEFINE ASSEMBLER}
{$ENDIF}
(* Turbo Pascal 5.0 *)
{$IFDEF VER50}
{$DEFINE TP}
{$DEFINE ASSEMBLER}
{$ENDIF}
(* Turbo Pascal 6.0 *)
{$IFDEF VER60}
{$DEFINE TP}
{$DEFINE ASSEMBLER}
{$ENDIF}
(* Turbo Pascal 7.0 *)
{$IFDEF VER70}
{$DEFINE TP}
{$DEFINE ASSEMBLER}
{$ENDIF}

(* Delphi 1 *)
{$IFDEF VER80}
{$DEFINE TP}
{$DEFINE ASSEMBLER}
{$ENDIF}


(* Delphi management *)


(* Delphi 2 *)
{$IFDEF VER90}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$ENDIF}

(* Delphi 3 *)
{$IFDEF VER100}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$DEFINE SUPPORT_ANSISTRING}
{$DEFINE SUPPORT_WIDESTRING}
{$ENDIF}

(* Delphi 4 *)
{$IFDEF VER120}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$DEFINE SUPPORT_ANSISTRING}
{$DEFINE SUPPORT_WIDESTRING}
{$ENDIF}

(* Delphi 5 *)
{$IFDEF VER130}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$DEFINE SUPPORT_INT64}
{$DEFINE SUPPORT_WIDESTRING}
{$DEFINE SUPPORT_ANSISTRING}
{$ENDIF}

(* Delphi 6 *)
{$IFDEF VER140}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$DEFINE SUPPORT_INT64}
{$DEFINE SUPPORT_WIDESTRING}
{$DEFINE SUPPORT_LARGE_STREAMS}
{$DEFINE SUPPORT_ANSISTRING}
{$ENDIF}

(* Delphi 7 *)
{$IFDEF VER150}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$DEFINE SUPPORT_INT64}
{$DEFINE SUPPORT_WIDESTRING}
{$DEFINE SUPPORT_LARGE_STREAMS}
{$DEFINE SUPPORT_ANSISTRING}
{$ENDIF}

(* Delphi 2005 *)
{$IFDEF VER170}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$DEFINE SUPPORT_INT64}
{$DEFINE SUPPORT_WIDESTRING}
{$DEFINE SUPPORT_LARGE_STREAMS}
{$DEFINE SUPPORT_ANSISTRING}
{$ENDIF}

(* Delphi 2006 *)
{$IFDEF VER180}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$DEFINE SUPPORT_INT64}
{$DEFINE SUPPORT_WIDESTRING}
{$DEFINE SUPPORT_LARGE_STREAMS}
{$DEFINE SUPPORT_ANSISTRING}
{$ENDIF}

(* Delphi 2007 *)
{$IFDEF VER185}
{$DEFINE DELPHI}
{$DEFINE ASSEMBLER}
{$DEFINE SUPPORT_INT64}
{$DEFINE SUPPORT_WIDESTRING}
{$DEFINE SUPPORT_LARGE_STREAMS}
{$DEFINE SUPPORT_ANSISTRING}
{$ENDIF}

(* Free pascal version 1.x management *)
{$IFDEF FPC}

{$IFDEF VER1}
{$DEFINE SUPPORT_ANSISTRING}
{$ELSE}
{$DEFINE SUPPORT_ANSISTRING}
{$DEFINE SUPPORT_INT64}
{$DEFINE SUPPORT_WIDESTRING}
{$ENDIF}



{$ENDIF}
