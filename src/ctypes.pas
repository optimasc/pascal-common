{
 ****************************************************************************
    $Id: ctypes.pas,v 1.2 2004-08-19 00:19:34 carl Exp $
    Copyright (c) 2004 by Carl Eric Codere

    C99 Type definitions

    See License.txt for more information on the licensing terms
    for this source code.

 ****************************************************************************
}


{** @author(Carl Eric Codere)
    @abstract(C99 type definitions)
    This unit contains some pre-defined types, using the same names
    as in C99. This facilitates conversion from C to Pascal of files
    using the Freepascal h2pas tool.
}
unit ctypes;

interface
uses
 tpautils,
 vpautils,
 fpautils,
 dpautils,
 gpautils,
 unicode;

type
 uint8_t = byte;
 int8_t  = shortint;
 uint16_t = word;
 int16_t  = smallint;
 uint32_t = longword;
 int32_t  = longint;
 bool = boolean;
 float = double;
 size_t = longword;
 wchar_t = pucs4char;
 wint_t = ucs4char;


implementation


end.

{
  $Log: not supported by cvs2svn $
  Revision 1.1  2004/08/01 05:33:23  carl
    + C99 compatiibility unit

}