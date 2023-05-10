unit ublState;
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

    SysUtils, Classes, SQLExpr, DB;

const
     db_State_Non_traite: Integer= 1;
     db_State_Traite : Integer= 2;
     db_State_Realise: Integer= 3;
     db_State_Incertain: Integer= 4;
     db_State_Laisse_de_Cote: Integer= 5;

type
 TblState
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Description: String;
    Symbol: String;
  //Gestion de la clé
  public
    function sCle: String; override;
  end;

function blState_from_sl( sl: TBatpro_StringList; Index: Integer): TblState;
function blState_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblState;

implementation

function blState_from_sl( sl: TBatpro_StringList; Index: Integer): TblState;
begin
     _Classe_from_sl( Result, TblState, sl, Index);
end;

function blState_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblState;
begin
     _Classe_from_sl_sCle( Result, TblState, sl, sCle);
end;

{ TblState }

constructor TblState.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'State';
         CP.Font.Family:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'State';

     //champs persistants
     String_from_( Symbol         , 'Symbol'         );
     cLibelle:= String_from_( Description    , 'Description'    );
end;

destructor TblState.Destroy;
begin

     inherited;
end;

function TblState.sCle: String;
begin
     Result:= sCle_ID;
end;

end.


