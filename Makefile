ifndef VERSION
VERSION=0.0
endif
## Target compilers
USETPC=1
USEFPC2=1
USEVPC=1
USEFPC=1
#USEGPC=1
USEDELPHI=1


#######################################################################
# USER CONFIGURATION : These should be configured manually 
#######################################################################
# PACKAGENAME : The name of the package / file name
# VERSION : The version of the package
# DOCTITLE : The title of the final documentation
# PATHSEP : Operating system path separator
# UNITDIRS : Location of units source code and units
# FILE : Base file to compile
# BINDIR : Base directory where binaries will go
# The following is for creating the final package, comment out
# if that particular section is not used.
# BINFILES: Files that will go into the resulting bin directory
# SRCFILES: Files that will go into the resulting src directory
# DOCFILES: Files that will go into the resulting docs directory
# LIBFILES: Files that will go into the resulting lib directory
# INCFILES: Files that will go into the resulting include directory
# TSTFILES: Files that will go into the tst directory
# OUTDIR : Base directory where libs, units, objects files will go
# DATAFILES : Files to copy for the tests
# FILESTODOCUMENT: Files to document
# DATE : Utility name to get the ISO Date

PACKAGENAME:=common
DOCTITLE:=Common pascal units documentation
UNITDIRS := ./src ./tst
FILE:=./src/allunits.pas
#BINFILES:=
DOCFILES:=./docs/license.txt ./docs/changes.txt ./docs/copying ./docs/copying.fpc ./docs/readme.txt ./docs/$(PACKAGENAME).pdf ./docs/html
#LIBFILES
SRCFILES:=./src/*
DATAFILES:=./tst/*.txt
FILESTODOCUMENT:=./src/crc.pas ./src/locale.pas ./src/unicode.pas ./src/utils.pas ./src/ietf.pas \
	./src/collects.pas ./src/iso639.pas ./src/iso3166.pas ./src/dateutil.pas ./src/fileio.pas
TSTFILES:=./tst/*


PATHSEP:=\\
BINDIR := ./bin
OUTDIR := ./lib
DATE := getdate.exe

include ../makefile.cmn

# This is called when a makexxxx is done. 
# It is called for each target, and should do any pre-processing
# as required.
preprocess:
