{
    $Id: fexpand.inc,v 1.1 2004-05-05 17:22:29 carl Exp $
    This file is part of the Free Pascal run time library.
    Copyright (c) 1997-2000 by the Free Pascal development team

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

 **********************************************************************}

{****************************************************************************
                A platform independent FExpand implementation
****************************************************************************}


procedure GetDirIO (DriveNr: byte; var Dir: OpenString);

(* GetDirIO is supposed to return the root of the given drive   *)
(* in case of an error for compatibility of FExpand with TP/BP. *)

var
  OldInOutRes: word;
begin
  OldInOutRes := IOResult;
  GetDir (DriveNr, Dir);
end;



function FExpand (const Path: PathStr): PathStr;

(* LFNSupport boolean constant, variable or function must be declared for all
   the platforms, at least locally in the Dos unit implementation part.
   In addition, FPC_FEXPAND_UNC, FPC_FEXPAND_DRIVES, FPC_FEXPAND_GETENV_PCHAR,
   , ,
   conditionals might
   be defined to specify FExpand behaviour.
*)

{$IFDEF FPC_FEXPAND_DRIVES}
var
    PathStart: longint;
{$ELSE FPC_FEXPAND_DRIVES}
const
    PathStart = 1;
{$ENDIF FPC_FEXPAND_DRIVES}
{$IFDEF FPC_FEXPAND_UNC}
var
    RootNotNeeded: boolean;
{$ELSE FPC_FEXPAND_UNC}
const
    RootNotNeeded = false;
{$ENDIF FPC_FEXPAND_UNC}

var S, Pa, Dirs: PathStr;
    I, J: longint;

begin
{$IFDEF FPC_FEXPAND_UNC}
    RootNotNeeded := false;
{$ENDIF FPC_FEXPAND_UNC}

(* First convert the path to uppercase if appropriate for current platform. *)
    if FileNameCaseSensitive then
        Pa := Path
    else
    begin
        for i:=1 to length(Path) do
          Pa[i] := UpCase (Path[i]);
    end;    

(* Allow both '/' and '\' as directory separators *)
(* by converting all to the native one.           *)
    if DirectorySeparator = '\' then
    {Allow slash as backslash}
        begin
            for I := 1 to Length (Pa) do
                if Pa [I] = '/' then
                    Pa [I] := DirectorySeparator
        end
    else
    {Allow backslash as slash}
        begin
            for I := 1 to Length (Pa) do
                if Pa [I] = '\' then
                    Pa [I] := DirectorySeparator;
        end;

(* PathStart is amount of characters to strip to get beginning *)
(* of path without volume/drive specification.                 *)
{$IFDEF FPC_FEXPAND_DRIVES}
    PathStart := 3;
{$ENDIF FPC_FEXPAND_DRIVES}

(* Expand tilde to home directory if appropriate. *)

(* Do we have a drive/volume specification? *)
    if (Length (Pa) > 1) and (Pa [1] in ['A'..'Z', 'a'..'z']) and
                                                 (Pa [2] = DriveSeparator) then
        begin

(* We need to know current directory on given *)
(* volume/drive _if_ such a thing is defined. *)
{$IFDEF FPC_FEXPAND_DRIVES}
 {$IFNDEF FPC_FEXPAND_NO_DEFAULT_PATHS}
            { Always uppercase driveletter }
            if (Pa [1] in ['a'..'z']) then
                Pa [1] := Chr (Ord (Pa [1]) and not ($20));
            GetDirIO (Ord (Pa [1]) - Ord ('A') + 1, S);

(* Do we have more than just drive/volume specification? *)
            if Length (Pa) = Pred (PathStart) then

(* If not, just use the current directory for that drive/volume. *)
                Pa := S
            else

(* If yes, find out whether the following path is relative or absolute. *)
                if Pa [PathStart] <> DirectorySeparator then
                    if Pa [1] = S [1] then
                        begin
                            { remove ending slash if it already exists }
                            if S [Length (S)] = DirectorySeparator then
                                Dec (S [0]);
                            Pa := S + DirectorySeparator +
                              Copy (Pa, PathStart, Length (Pa) - PathStart + 1)
                        end
                    else
                        Pa := Pa [1] + DriveSeparator + DirectorySeparator +
                              Copy (Pa, PathStart, Length (Pa) - PathStart + 1)
 {$ENDIF FPC_FEXPAND_NO_DEFAULT_PATHS}
        end
    else
{$ELSE FPC_FEXPAND_DRIVES}

(* If drives are not supported, but a drive *)
(* was supplied anyway, ignore (remove) it. *)
            Delete (Pa, 1, 2);
        end;
    {Check whether we don't have an absolute path already}
    if (Length (Pa) >= PathStart) and (Pa [PathStart] <> DirectorySeparator) or
                                                 (Length (Pa) < PathStart) then
{$ENDIF FPC_FEXPAND_DRIVES}
        begin

(* Get current directory on selected drive/volume. *)
            GetDirIO (0, S);

(* Do we have an absolute path? *)
{$IFDEF FPC_FEXPAND_DRIVES}
            if (Length (Pa) > 0)
                                 and (Pa [1] = DirectorySeparator)
                                                                   then
                begin
 {$IFDEF FPC_FEXPAND_UNC}
                    {Do not touch network drive names}
                    if (Length (Pa) > 1) and (Pa [2] = DirectorySeparator)
                                                            and LFNSupport then
                        begin
                            PathStart := 3;
                            {Find the start of the string of directories}
                            while (PathStart <= Length (Pa)) and
                                      (Pa [PathStart] <> DirectorySeparator) do
                                Inc (PathStart);
                            if PathStart > Length (Pa) then
                            {We have just a machine name...}
                                if Length (Pa) = 2 then
                                {...or not even that one}
                                    PathStart := 2
                                else
                                    Pa := Pa + DirectorySeparator                            else
                                if PathStart < Length (Pa) then
                                {We have a resource name as well}
                                    begin
                                        RootNotNeeded := true;
                                        {Let's continue in searching}
                                        repeat
                                            Inc (PathStart);
                                        until (PathStart > Length (Pa)) or
                                         (Pa [PathStart] = DirectorySeparator);
                                    end;
                        end
                    else
 {$ENDIF FPC_FEXPAND_UNC}
                        Pa := S [1] + DriveSeparator + Pa;
                end
            else
{$ENDIF FPC_FEXPAND_DRIVES}

                (* We already have a slash if root is the curent directory. *)
                if Length (S) = PathStart then
                    Pa := S + Pa
                else

                    (* We need an ending slash if FExpand was called  *)
                    (* with an empty string for compatibility, except *)
                    (* for platforms where this is invalid.           *)
                    if Length (Pa) = 0 then
                        Pa := S + DirectorySeparator
                    else
                        Pa := S + DirectorySeparator + Pa;
        end;

    {Get string of directories to only process relative references on this one}
    Dirs := Copy (Pa, Succ (PathStart), Length (Pa) - PathStart);

    {First remove all references to '\.\'}
    I := Pos (DirectorySeparator + '.' + DirectorySeparator, Dirs);
    while I <> 0 do
        begin
            Delete (Dirs, I, 2);
            I := Pos (DirectorySeparator + '.' + DirectorySeparator, Dirs);
        end;

    {Now remove also all references to '\..\' + of course previous dirs..}
    I := Pos (DirectorySeparator + '..' + DirectorySeparator, Dirs);
    while I <> 0 do
        begin
            J := Pred (I);
            while (J > 0) and (Dirs [J] <> DirectorySeparator) do
                Dec (J);
            Delete (Dirs, Succ (J), I - J + 3);
            I := Pos (DirectorySeparator + '..' + DirectorySeparator, Dirs);
        end;


    {Then remove also a reference to '\..' at the end of line
    + the previous directory, of course,...}
    I := Pos (DirectorySeparator + '..', Dirs);
    if (I <> 0) and (I = Length (Dirs) - 2) then
        begin
            J := Pred (I);
            while (J > 0) and (Dirs [J] <> DirectorySeparator) do
                Dec (J);
            if (J = 0) then
                Dirs := ''
            else
                Delete (Dirs, Succ (J), I - J + 2);
        end;


    {...and also a possible reference to '\.'}
    if (Length (Dirs) = 1) then
        begin
            if (Dirs [1] = '.') then
            {A special case}
                Dirs := ''
        end
    else
        if (Length (Dirs) <> 0) and (Dirs [Length (Dirs)] = '.') and
                        (Dirs [Pred (Length (Dirs))] = DirectorySeparator) then
            Dec (Dirs [0], 2);

    {Finally remove '.\' at the beginning of the string of directories...}
    while (Length (Dirs) >= 2) and (Dirs [1] = '.')
                                         and (Dirs [2] = DirectorySeparator) do
        Delete (Dirs, 1, 2);


    {...and possible (invalid) references to '..\' as well}
    while (Length (Dirs) >= 3) and (Dirs [1] = '.') and (Dirs [2] = '.') and
                                             (Dirs [3] = DirectorySeparator) do
        Delete (Dirs, 1, 3);

    {Two special cases - '.' and '..' alone}
    if (Length (Dirs) = 1) and (Dirs [1] = '.') then
        Dirs := '';
    if (Length (Dirs) = 2) and (Dirs [1] = '.') and (Dirs [2] = '.') then
        Dirs := '';

    {Join the parts back to create the complete path}
    if Length (Dirs) = 0 then
        begin
            Pa := Copy (Pa, 1, PathStart);
            if Pa [PathStart] <> DirectorySeparator then
                Pa := Pa + DirectorySeparator;
        end
    else
        Pa := Copy (Pa, 1, PathStart) + Dirs;

    {Remove ending \ if not supplied originally, the original string
    wasn't empty (to stay compatible) and if not really needed}
    if (Pa [Length (Pa)] = DirectorySeparator)
         and ((Length (Pa) > PathStart) or
            (RootNotNeeded and (Length (Pa) = PathStart))) and
                     (Length (Path) <> 0)
                          and (Path [Length (Path)] <> DirectorySeparator) then
        Dec (Pa [0]);

    FExpand := Pa;
end;

{
  $Log: not supported by cvs2svn $

}
