{ Program to test the filesystem unit }
Program TestFS;
{$IFNDEF TP}
{$C+}
{$ENDIF}

uses unicode,utils,fs;

const
  DOS_FILENAME = '12345678.901';
  DOS_FILENAME1 = '123.456';
  DOS_FILENAME2 = '123';

  POSIX_FILENAME1 = '12345678901234';
  POSIX_FILENAME2 = '123.12346._15';
  POSIX_FILENAME3 = '1234567890.123';

  OS2_FILENAME1 = '+HELLO+THIS_IS_A_FILESYSTEM.CARL';
  OS2_FILENAME2 = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'+
                  'abcdefghijklmnopqrstuvwxyz'+
                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ'+
                  'abcdefghijklmnopqrstuvwxyz'+
                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ'+
                  'abcdefghijklmnopqrstuvwxyz'+
                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ'+
                  'abcdefghijklmnopqrstuvwxyz.dat';
   OS2_FILENAME3 = 'THIS_IS_A_SAMPLE_FILE_THAT_IS_VERY_LONG_IT_IS_GREATER_THAN_31.CAR';

   AMIGA_FILENAME1 = 'Carl Eric Cod'#232're.document';
   AMIGA_FILENAME2 = 'SampleFile[doc]?.doc';
   AMIGA_FILENAME3 = 'SAMPLES_%PERCENT%.DOCUMENT';

var
 DOSFileSystem: TDOsFileSystem;
 POSIXFileSystem: TPOSIXFileSystem;
 OS2FileSystem: TOS2FileSystem;
 AmigaFileSystem: TAmigaFFSFilesystem;
 ISO9660Level1FileSystem: TISO9660Level1FileSystem;
 ISO9660Level2FileSystem: TISO9660Level2FileSystem;
 UDFFileSystem: TUDFFilesystem ;
 JolietFileSystem: TJolietFileSystem;
 HFSPlusFileSystem: THFSPlusFileSystem;
 dest: ucs4string;
Begin
  { DOS_FILENAME }
  ConvertToUCS4(DOS_FILENAME,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest));
  assert(POSIXFileSystem.isValidFileName(dest));
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest));
  assert(ISO9660Level2FileSystem.isValidFileName(dest));
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));
  { DOS_FILENAME1 }
  ConvertToUCS4(DOS_FILENAME1,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest));
  assert(POSIXFileSystem.isValidFileName(dest));
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest));
  assert(ISO9660Level2FileSystem.isValidFileName(dest));
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));
  { DOS_FILENAME2 }
  ConvertToUCS4(DOS_FILENAME2,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest));
  assert(POSIXFileSystem.isValidFileName(dest));
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest));
  assert(ISO9660Level2FileSystem.isValidFileName(dest));
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));
  {************************ POSIX FILENAMES ***********************}
  { *************** }
  ConvertToUCS4(POSIX_FILENAME1,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest));
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest));
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));
  { ************* }
  ConvertToUCS4(POSIX_FILENAME2,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest));
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest)=false);
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));
  { ************* }
  ConvertToUCS4(POSIX_FILENAME3,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest));
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest));
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));
  {************************ OS2 FILENAMES ***********************}
  { *************** }
  ConvertToUCS4(OS2_FILENAME1,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest)=false);
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest)=false);
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));
  { ************* }
  ConvertToUCS4(OS2_FILENAME2,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest)=false);
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest)=false);
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest)=false);
  assert(HFSPlusFileSystem.isValidFileName(dest));
  { ************* }
  ConvertToUCS4(OS2_FILENAME3,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest)=false);
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest)=false);
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest)=false);
  assert(HFSPlusFileSystem.isValidFileName(dest));
  {************************ AMIGA FILENAMES ***********************}
  { *************** }
  ConvertToUCS4(AMIGA_FILENAME1,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest)=false);
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest)=false);
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));
  { ************* }
  ConvertToUCS4(AMIGA_FILENAME2,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest)=false);
  assert(OS2FileSystem.isValidFileName(dest)=false);
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest)=false);
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest)=false);
  assert(HFSPlusFileSystem.isValidFileName(dest));
  { ************* }
  ConvertToUCS4(AMIGA_FILENAME3,dest,'ISO-8859-1');
  assert(DOSFileSystem.isValidFileName(dest)=false);
  assert(POSIXFileSystem.isValidFileName(dest)=false);
  assert(OS2FileSystem.isValidFileName(dest));
  assert(AmigaFileSystem.isValidFileName(dest));
  assert(ISO9660Level1FileSystem.isValidFileName(dest)=false);
  assert(ISO9660Level2FileSystem.isValidFileName(dest)=false);
  assert(UDFFileSystem.isValidFileName(dest));
  assert(JolietFileSystem.isValidFileName(dest));
  assert(HFSPlusFileSystem.isValidFileName(dest));

end.