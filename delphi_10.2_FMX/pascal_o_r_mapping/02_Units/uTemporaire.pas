unit uTemporaire;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uClean,

  {$IFDEF MSWINDOWS}
  Windows,
  {$ENDIF}
  SysUtils, Classes;

type
 TTemporaire
 =
  class
  //Répertoire temporaire de Windows
  private
    function RepertoireTemp: String;
  //création d'un fichier temporaire
  public
    function Nouveau_Fichier( Prefixe: String): String;
  //création d'un répertoire temporaire
  public
    function Nouveau_Repertoire( Prefixe: String): String;
  end;

var
   Temporaire: TTemporaire;

implementation


{ TTemporaire }

function TTemporaire.RepertoireTemp: String;
var
   buffer: array[0..MAX_PATH] of WideChar;
begin
     GetTempPath( length( buffer), buffer);
     Result:= StrPas( buffer);
end;

function TTemporaire.Nouveau_Fichier( Prefixe: String): String;
var
   TempFileName: array[0..MAX_PATH] of WideChar;
begin
     GetTempFileName(  PWideChar( RepertoireTemp),
                       PWideChar( Prefixe       ), 0, TempFileName);
     Result:= StrPas( TempFileName);
end;

function TTemporaire.Nouveau_Repertoire( Prefixe: String): String;
begin
     Result:= Nouveau_Fichier( Prefixe);
     Result:= ChangeFileExt( Result, 'DIR');
     CreateDir( Result);
end;

initialization
              Temporaire:= TTemporaire.Create;
finalization
              Free_nil( Temporaire);
end.
