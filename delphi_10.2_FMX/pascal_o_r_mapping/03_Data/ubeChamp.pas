unit ubeChamp;
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
    ufAccueil_Erreur,
    uBatpro_StringList,
    u_sys_,
    u_loc_,
    uChamp,
    uDataUtils,
    uuStrings,
    uDrawInfo,
    uBatpro_Element,
    uContextes,
    uVide,
    Windows, SysUtils, Classes, FMX.Graphics, FMX.Controls;

type
 TbeChamp
 =
  class( TBatpro_Element)
  public
    C: TChamp;
    constructor Create( _sl: TBatpro_StringList; _C: TChamp);
    function GetCell(Contexte: Integer): String; override;
    function Contenu( Contexte: Integer; Col, Row: Integer): String; override;
  end;

function beChamp_from_sl( sl: TBatpro_StringList; Index: Integer): TbeChamp;

implementation

function beChamp_from_sl( sl: TBatpro_StringList; Index: Integer): TbeChamp;
begin
     _Classe_from_sl( Result, TbeChamp, sl, Index);
end;

{ TbeChamp }

constructor TbeChamp.Create( _sl: TBatpro_StringList; _C: TChamp);
var
   CP: IblG_BECP;
begin
     C:= _C;
     if C = nil
     then
         fAccueil_Erreur( 'Erreur à signaler au développeur: '+
                          'TbeChamp.Create: la champ fourni est à nil');

     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Titre:= 'Référence à un champ';
         CP.Font.Family:= sys_SmallFonts;
         CP.Font.Size:= 6;
         end;

     inherited Create( _sl);
end;

function TbeChamp.Contenu( Contexte: Integer; Col, Row: Integer): String;
begin
     Result:= '';
     if C = nil then exit;

     Result:= C.Definition.Libelle+': '+C.Chaine;
end;

function TbeChamp.GetCell( Contexte: Integer): String;
begin
     Result:= C.Chaine;
end;

end.
