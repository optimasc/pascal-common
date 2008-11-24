{ Unicode WhiteSpace character property type
  Generated on 2006-11-09
  Encoded in the ISO-8859-1 character set
}
const
  {** @exclude }
  MAX_WHITESPACE =12;
  {** @exclude }
  MAX_UCS2_WHITESPACE =12;
  {** @exclude }
  MAX_ANSI_WHITESPACE =4;
  {** @exclude }
  MAX_ASCII_WHITESPACE =2;
type
  {** @exclude }
  TWhiteSpaceInfo = record
    lower: ucs2char;
    upper: ucs2char;
  end;


const
  {** @exclude }
  WhiteSpace: array[1..MAX_WHITESPACE] of TWhiteSpaceInfo = (
   (lower: $0009; upper: $000D),
   (lower: $0020; upper: $0020),
   (lower: $0085; upper: $0085),
   (lower: $00A0; upper: $00A0),
   (lower: $1680; upper: $1680),
   (lower: $180E; upper: $180E),
   (lower: $2000; upper: $200A),
   (lower: $2028; upper: $2028),
   (lower: $2029; upper: $2029),
   (lower: $202F; upper: $202F),
   (lower: $205F; upper: $205F),
   (lower: $3000; upper: $3000)
);
