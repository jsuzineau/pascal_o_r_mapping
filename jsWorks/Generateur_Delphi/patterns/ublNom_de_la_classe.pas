unit ublNom_de_la_classe;
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
    uClean,
    u_sys_,
    uuStrings,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type
 TblNom_de_la_classe
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
//pattern_declaration_champs
  //Gestion de la clé
  public
//pattern_sCle_from__Declaration  
    function sCle: String; override;
  end;

function blNom_de_la_classe_from_sl( sl: TBatpro_StringList; Index: Integer): TblNom_de_la_classe;
function blNom_de_la_classe_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblNom_de_la_classe;

implementation

function blNom_de_la_classe_from_sl( sl: TBatpro_StringList; Index: Integer): TblNom_de_la_classe;
begin
     _Classe_from_sl( Result, TblNom_de_la_classe, sl, Index);
end;

function blNom_de_la_classe_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblNom_de_la_classe;
begin
     _Classe_from_sl_sCle( Result, TblNom_de_la_classe, sl, sCle);
end;

{ TblNom_de_la_classe }

constructor TblNom_de_la_classe.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Nom_de_la_classe';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Nom_de_la_table';

     //champs persistants
//pattern_creation_champs
end;

destructor TblNom_de_la_classe.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblNom_de_la_classe.sCle: String;
begin
//pattern_sCle_Implementation_Body
end;

end.


