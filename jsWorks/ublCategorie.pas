unit ublCategorie;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
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

    SysUtils, Classes, Sqldb, DB;

const
     db_Categorie_Question_formation   : Integer= 1;
     db_Categorie_Bug_signale          : Integer= 2;
     db_Categorie_Demande_developpement: Integer= 3;
     db_Categorie_Compta_client        : Integer= 4;
     db_Categorie_Compta_fournisseur   : Integer= 5;
     db_Categorie_Prospect             : Integer= 6;

type
 TblCategorie
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Symbol: String;
    Description: String;

    function sCle: String; override;
  end;

function blCategorie_from_sl( sl: TBatpro_StringList; Index: Integer): TblCategorie;
function blCategorie_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblCategorie;

implementation

function blCategorie_from_sl( sl: TBatpro_StringList; Index: Integer): TblCategorie;
begin
     _Classe_from_sl( Result, TblCategorie, sl, Index);
end;

function blCategorie_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblCategorie;
begin
     _Classe_from_sl_sCle( Result, TblCategorie, sl, sCle);
end;

{ TblCategorie }

constructor TblCategorie.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Categorie';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Categorie';

     //champs persistants
     String_from_( Symbol         , 'Symbol'         );
     cLibelle:= String_from_( Description    , 'Description'    );


end;

destructor TblCategorie.Destroy;
begin

     inherited;
end;

function TblCategorie.sCle: String;
begin
     Result:= sCle_id;
end;

end.


