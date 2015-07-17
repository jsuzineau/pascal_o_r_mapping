unit ublPROJECT;
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
    uDataClasses,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlExpr, DB, Grids;

type
 TblPROJECT
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    id: Integer;
    Name: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;
  end;

function blPROJECT_from_sl( sl: TBatpro_StringList; Index: Integer): TblPROJECT;
function blPROJECT_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPROJECT;
function sg_blPROJECT( sg: TStringGrid; Colonne, Ligne: Integer): TblPROJECT;

implementation

function blPROJECT_from_sl( sl: TBatpro_StringList; Index: Integer): TblPROJECT;
begin
     _Classe_from_sl( Result, TblPROJECT, sl, Index);
end;

function blPROJECT_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPROJECT;
begin
     _Classe_from_sl_sCle( Result, TblPROJECT, sl, sCle);
end;

function sg_blPROJECT( sg: TStringGrid; Colonne, Ligne: Integer): TblPROJECT;
var
   be: TBatpro_Element;
begin
     Result:= nil;

     be:= Batpro_Element_from_sg( sg, Colonne, Ligne);
     if be = nil then exit;
     if not (be is TblPROJECT) then exit;

     Result:=TblPROJECT( be);
end;

{ TblPROJECT }

constructor TblPROJECT.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'PROJECT';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Project';

     //champs persistants
     Champs. Integer_from_Integer( id             , 'id'             );
     Champs.  String_from_String ( Name           , 'Name'           );

end;

destructor TblPROJECT.Destroy;
begin

     inherited;
end;



function TblPROJECT.sCle: String;
begin
     Result:= sCle_ID;
end;

end.


