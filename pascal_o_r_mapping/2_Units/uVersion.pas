unit uVersion;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }
interface

uses
    uLog,
  {$IFDEF WINDOWS}
  Windows,
  {$ENDIF}
  SysUtils;

function GetVersionProgramme: String;

function GetVersionModule( Module: HModule): String;

(*function nGetVersionFichier( Fichier: String): TVSFixedFileInfo;

function nGetVersionProgramme: TVSFixedFileInfo;

function sFormate_Version( Version: TVSFixedFileInfo): String;    *)

implementation

(*
function nGetVersionFichier( Fichier: String): TVSFixedFileInfo;
var
   VersionInfo: Pointer;
   VersionInfoSize: DWORD;
   inutile_mais_requis: DWORD;

   Value: Pointer;
   ValueSize: UINT;
begin
     FillChar( Result, SizeOf( Result), 0);

     VersionInfoSize
     :=
       GetFileVersionInfoSize( PChar(Fichier), inutile_mais_requis);
     if VersionInfoSize = 0 then exit;

     GetMem( VersionInfo, VersionInfoSize);
        if GetFileVersionInfo(PChar(Fichier),0,VersionInfoSize, VersionInfo)
        then
            if VerQueryValue( VersionInfo, '\', Value, ValueSize)
            then
                Move( Value^, Result, ValueSize);
     FreeMem( VersionInfo, VersionInfoSize);
end;
*)
function GetVersionFichier( Fichier: String): String;
(*var
   VersionInfo: Pointer;
   VersionInfoSize: DWORD;
   inutile_mais_requis: DWORD;

   Value: Pointer;
   ValueSize: UINT;

   Version: TVSFixedFileInfo;
   *)
begin
     (*
     VersionInfoSize
     :=
       GetFileVersionInfoSize( PChar(Fichier), inutile_mais_requis);
     if VersionInfoSize = 0
     then
         begin
         Result:= '< non-disponible >';
         //TraiteLastError( 'uVersion.GetVersionFichier: VersionInfoSize = 0, ');
         exit;
         end;

     GetMem( VersionInfo, VersionInfoSize);
        if GetFileVersionInfo(PChar(Fichier),0,VersionInfoSize, VersionInfo)
        then
            if VerQueryValue( VersionInfo, '\', Value, ValueSize)
            then
                begin
                Move( Value^, Version, ValueSize);
                Result
                :=
                  Format( '%d.%d.%d.%d',
                          [
                          HiWord(Version.dwFileVersionMS),
                          LoWord(Version.dwFileVersionMS),
                          HiWord(Version.dwFileVersionLS),
                          LoWord(Version.dwFileVersionLS)
                          ]
                          );
                end
            else
                Result:= '< non-spécifiée >'
        else
            Result:= '< non-spécifiée >';
     FreeMem( VersionInfo, VersionInfoSize);
     *)
end;

function GetVersionModule( Module: HModule): String;
var
   Fichier: String;
   Taille, Lus: Integer;
begin
     Taille:= 1024;
     Lus:= Taille;
(*     while Lus >= Taille-1
     do
       begin
       Inc( Taille, 8);
       SetLength( Fichier, Taille);
       Lus:= GetModuleFileName( Module, PChar(Fichier), Taille);
       end;
     SetLength( Fichier, Lus);
     *)
     Result
     :=
       Format( '%-16s, %s',
               [
               ExtractFileName(Fichier),
               GetVersionFichier( Fichier)
               ]);
end;

function GetVersionProgramme: String;
begin
     Result:= GetVersionFichier( ParamStr(0));
end;

(*
function nGetVersionProgramme: TVSFixedFileInfo;
begin
     Result:= nGetVersionFichier( ParamStr(0));
end;

function sFormate_Version( Version: TVSFixedFileInfo): String;
begin
     Result
     :=
       Format( '%d.%d.%d.%d',
               [
               HiWord(Version.dwFileVersionMS),
               LoWord(Version.dwFileVersionMS),
               HiWord(Version.dwFileVersionLS),
               LoWord(Version.dwFileVersionLS)
               ]
               );
end;
  *)
end.
