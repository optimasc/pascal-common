You can get the latest version here: 
http://www.optimasc.com/products/utilities/index.html

1. Overview

This package consists of useful pascal units, as well as compatibility units 
so that code can be compiled with the following compilers:

- Borland Pascal 7.0 (bp)
- Borland Delphi 6 or higher (delphi)
- Freepascal 1.0.6 or higher (fpc)
- Kylix 1 and higher (kylix)
- Turbo Pascal 7.0 (tp)
- Virtual pascal 2.1 or higher (Win32 and OS/2 targets only)  (vp)
- GNU Pascal (only partial support)

The units are entirely portable and should work on most processors 
and operating systems.

2. Licence

See license.txt for the exact licensing terms. They are broad and 
this package can essentially be considered as freeware.

Some of the source code (especially the Delphi units) were taken from 
the Freepascal compiler, and the Freepascal license applies to them 
(see copying.fpc for more information).

3. Standard types

Standard type definitions are a real mess between compiler versions, 
so these different units try to clean up the entire type mess and 
defines (or redefines some standard types), so that they are common 
across compilers. The following portable types are defined:

Integer: The integer type is the base signed type that is optimized 
for the underlying machine architecture. So if the base machine 
architecture is 16-bit this value will be a signed 16-bit value. 
This is the type that should be used for counters, and internal variables.

Cardinal: The cardinal type is the base unsigned type that is optimized 
for the underlying machine architecture. So if the base machine 
architecture is 16-bit this value will be an unsigned 16-bit value.

Shortstring: This represents a string type composed of bytes 
followed preceded by a length byte. This is equivalent to the 
old string[255] or string type of Turbo Pascal.

big_integer_t: The biggest integer size available for the 
compiler (usually equal to longint or int64)

ptrint: This is an integer that has the same size as a 
pointer and used to typecast a pointer to  and from 
an integer value.

The following defines the pre-defined types that have specific 
sizes and which are available on all supported compilers 
(some are defined by the compiler, others are defined by one 
of the units herein):

byte (0..255)
shortint (-128..127)
word (0..65535)
smallint (-32768..32767)
longword (0..4294967295) [not supported on all compilers, emulated by longint]
longint (-2147483648..2147483647)

4. Standard constants

These constants are used to represent information related to the operating 
system. They should be used instead of hard coding file system information. 
This will make the code more portable.

LineEnding: String indicating the characters ending a text line in a 
text file. 

DirectorySeparator: This is the character or characters that separate 
the directories in a complete path specification.

DriveSeparator : This is the character or characters that separate 
the directories from the drive specification in a complete path specification.

PathSeparator: This is the character or characters that separate 
the directories from the drive specification in a complete path specification.

FileNameCaseSensitive: This indicates if the filenames are case senstivie 
or not (this is a boolean value)

5. Compiling

a) The following defines should be defined, as
required by the compiler :

ENDIAN_LITTLE if the target is a little endian
  machine.
ENDIAN_BIG if the target is a big endian
  machine
i386 if the target is a 80x86 cpu and the compiler
  is fpc
TP if the compiler is bp or tp.

CPU32 if the target is a 32-bit compiler; this is true for 
Turbo Pascal, Virtual Pascal, Kylix, Delphi and most 
versions of Freepascal. Otherwise define CPU64.

4. Credits

Some of the source code in this package is derived from the Free Pascal 
compiler runtime library.  Visit http://www.freepascal.org to get your 
hands on a great Open source pascal compiler.

You can report bugs for this library on the following site:
http://www.optimasc.com/bugs/

Enjoy!
Carl Eric Codere
cecodere@yahoo.ca

