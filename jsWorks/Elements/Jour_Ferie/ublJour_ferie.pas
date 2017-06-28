unit ublJour_ferie;
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

    SysUtils, Classes, SqlDB, DB;

type
 TblJour_ferie
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Jour: TDateTime;

  //Gestion de la clé
  public
    function sCle: String; override;
  end;

function blJour_ferie_from_sl( sl: TBatpro_StringList; Index: Integer): TblJour_ferie;
function blJour_ferie_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblJour_ferie;

implementation

function blJour_ferie_from_sl( sl: TBatpro_StringList; Index: Integer): TblJour_ferie;
begin
     _Classe_from_sl( Result, TblJour_ferie, sl, Index);
end;

function blJour_ferie_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblJour_ferie;
begin
     _Classe_from_sl_sCle( Result, TblJour_ferie, sl, sCle);
end;

{ TblJour_ferie }

constructor TblJour_ferie.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Jour_ferie';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Jour_ferie';

     //champs persistants
     Champs.DateTime_from_( Jour           , 'Jour'           );

end;

destructor TblJour_ferie.Destroy;
begin

     inherited;
end;

function TblJour_ferie.sCle: String;
begin
     Result:= sCle_id;
end;

end.


