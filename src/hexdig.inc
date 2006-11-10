{ Unicode HexDigits character property type
  Generated on 2006-11-09
  Encoded in the ISO-8859-1 character set
}
const
  MAX_HEXDIGITS =6;
  MAX_UCS2_HEXDIGITS =6;
  MAX_ANSI_HEXDIGITS =3;
  MAX_ASCII_HEXDIGITS =3;
type
  THexDigitsInfo = record
    lower: ucs2char;
    upper: ucs2char;
  end;


const
  HexDigits: array[1..MAX_HEXDIGITS] of THexDigitsInfo = (
   (lower: $0030; upper: $0039),
   (lower: $0041; upper: $0046),
   (lower: $0061; upper: $0066),
   (lower: $FF10; upper: $FF19),
   (lower: $FF21; upper: $FF26),
   (lower: $FF41; upper: $FF46)
);
