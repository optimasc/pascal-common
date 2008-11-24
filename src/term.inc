{ Unicode Terminals character property type
  Generated on 2006-11-09
  Encoded in the ISO-8859-1 character set
}
const
  {** @exclude }
  MAX_TERMINALS =30;
  {** @exclude }
  MAX_UCS2_TERMINALS =30;
  {** @exclude }
  MAX_ANSI_TERMINALS =3;
  {** @exclude }
  MAX_ASCII_TERMINALS =3;
type
  {** @exclude }
  TTerminalsInfo = record
    lower: ucs2char;
    upper: ucs2char;
  end;


const
  {** @exclude }
  Terminals: array[1..MAX_TERMINALS] of TTerminalsInfo = (
   (lower: $0021; upper: $0021),
   (lower: $002E; upper: $002E),
   (lower: $003F; upper: $003F),
   (lower: $055C; upper: $055C),
   (lower: $055E; upper: $055E),
   (lower: $0589; upper: $0589),
   (lower: $061F; upper: $061F),
   (lower: $06D4; upper: $06D4),
   (lower: $0700; upper: $0702),
   (lower: $07F9; upper: $07F9),
   (lower: $0964; upper: $0965),
   (lower: $104A; upper: $104B),
   (lower: $1362; upper: $1362),
   (lower: $1367; upper: $1368),
   (lower: $166E; upper: $166E),
   (lower: $1803; upper: $1803),
   (lower: $1809; upper: $1809),
   (lower: $1944; upper: $1945),
   (lower: $1B5A; upper: $1B5B),
   (lower: $1B5E; upper: $1B5F),
   (lower: $203C; upper: $203D),
   (lower: $2047; upper: $2049),
   (lower: $3002; upper: $3002),
   (lower: $A876; upper: $A877),
   (lower: $FE52; upper: $FE52),
   (lower: $FE56; upper: $FE57),
   (lower: $FF01; upper: $FF01),
   (lower: $FF0E; upper: $FF0E),
   (lower: $FF1F; upper: $FF1F),
   (lower: $FF61; upper: $FF61)
);
