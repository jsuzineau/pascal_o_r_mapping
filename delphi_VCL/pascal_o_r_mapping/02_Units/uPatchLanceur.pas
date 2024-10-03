unit uPatchLanceur;
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
    SysUtils,
    u_sys_;

//Patch pour le changement de Batpro_Planning.exe en Batpro_Planning_Application.exe
//                            Batpro_Editions.exe en Batpro_Editions_Application.exe
// 2008 10 22: on réutilise ce code pour déplacer l'ini vers le répertoire etc
// Renomme un fichier l'ancien nom vers le nouveau nom
// Retourne le nouveau nom par commodité
function uPatchLanceur_Execute( Extension: String): String;

implementation

function uPatchLanceur_Execute( Extension: String): String;
var
   Repertoire,
   Ancien: String;
begin
     Repertoire:= ExtractFilePath( ParamStr(0)) + 'etc'+PathDelim;
     Result    := Repertoire + ChangeFileExt(ExtractFileName(ParamStr(0)),Extension);

     if FileExists( Result) then exit;
     ForceDirectories( Repertoire);
     Ancien:= ChangeFileExt( ParamStr(0), Extension);

     RenameFile( Ancien, Result);
end;

end.
