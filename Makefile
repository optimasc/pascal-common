ifndef VERSION
VERSION=0.0
endif

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
# OUTDIR : Base directory where libs, units, objects files will go
# FILESTODOCUMENT: Files to document
# DATE : Utility name to get the ISO Date

PACKAGENAME:=common
DOCTITLE:=Common pascal units documentation
UNITDIRS := ./lib ./src
FILE:=./src/allunits.pas
#BINFILES:=
DOCFILES:=./docs/license.txt ./docs/changes.txt ./docs/copying ./docs/copying.fpc ./docs/readme.txt ./docs/$(PACKAGENAME).pdf ./docs/html
#LIBFILES
SRCFILES:=./src/* ./src/delphi/*
#INCFILES:=
FILESTODOCUMENT:=./src/crc.pas ./src/dpautils.pas ./src/fpautils.pas ./src/locale.pas \
	./src/tpautils.pas ./src/unicode.pas ./src/utils.pas ./src/vpautils.pas



PATHSEP:=\\
BINDIR := ./bin
OUTDIR := ./lib
DATE := getdate.exe

include ../makefile.cmn

