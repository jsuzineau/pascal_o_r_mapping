unit ublType_Tag;
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

const
     Type_Tag_id_Project  =1;
     Type_Tag_id_Categorie=2;
     Type_Tag_id_Client   =3;

type
 TblType_Tag
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Name: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;
  end;

function blType_Tag_from_sl( sl: TBatpro_StringList; Index: Integer): TblType_Tag;
function blType_Tag_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblType_Tag;

implementation

function blType_Tag_from_sl( sl: TBatpro_StringList; Index: Integer): TblType_Tag;
begin
     _Classe_from_sl( Result, TblType_Tag, sl, Index);
end;

function blType_Tag_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblType_Tag;
begin
     _Classe_from_sl_sCle( Result, TblType_Tag, sl, sCle);
end;

{ TblType_Tag }

constructor TblType_Tag.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Type_Tag';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Type_Tag';

     //champs persistants
     Champs.  String_from_String ( Name           , 'Name'           );

end;

destructor TblType_Tag.Destroy;
begin

     inherited;
end;



function TblType_Tag.sCle: String;
begin
     Result:= sCle_ID;
end;

end.


