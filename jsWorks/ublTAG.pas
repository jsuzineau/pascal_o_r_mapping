unit ublTAG;
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
 TblTAG
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
    idType: Integer;
    //Gestion de la clé
    public
      class function sCle_from_( _idType: Integer;  _Name: String): String;

      function sCle: String; override;
  end;

function blTAG_from_sl( sl: TBatpro_StringList; Index: Integer): TblTAG;
function blTAG_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTAG;

implementation

function blTAG_from_sl( sl: TBatpro_StringList; Index: Integer): TblTAG;
begin
     _Classe_from_sl( Result, TblTAG, sl, Index);
end;

function blTAG_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTAG;
begin
     _Classe_from_sl_sCle( Result, TblTAG, sl, sCle);
end;

{ TblTAG }

constructor TblTAG.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'TAG';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Tag';

     //champs persistants
     Champs. Integer_from_Integer( id             , 'id'             );
     Champs. Integer_from_Integer( idType         , 'idType'         );
     Champs.  String_from_String ( Name           , 'Name'           );

end;

destructor TblTAG.Destroy;
begin

     inherited;
end;

class function TblTAG.sCle_from_( _idType: Integer;  _Name: String): String;
begin
     Result:=  IntToHex( _idType, 8)+ _Name;
end;

function TblTAG.sCle: String;
begin
     Result:= sCle_from_(  _idType,  _Name);
end;

end.


