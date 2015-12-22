unit ublTag_Work;
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
 TblTag_Work
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    idTag: Integer;
    idWork: Integer;
  //Gestion de la clé
  public
    class function sCle_from_( _idTag: Integer;  _idWork: Integer): String;
    function sCle: String; override;
  end;

function blTag_Work_from_sl( sl: TBatpro_StringList; Index: Integer): TblTag_Work;
function blTag_Work_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTag_Work;

implementation

function blTag_Work_from_sl( sl: TBatpro_StringList; Index: Integer): TblTag_Work;
begin
     _Classe_from_sl( Result, TblTag_Work, sl, Index);
end;

function blTag_Work_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTag_Work;
begin
     _Classe_from_sl_sCle( Result, TblTag_Work, sl, sCle);
end;

{ TblTag_Work }

constructor TblTag_Work.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Tag_Work';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Tag_Work';

     //champs persistants
     Champs. Integer_from_Integer( idTag          , 'idTag'          );
     Champs. Integer_from_Integer( idWork         , 'idWork'         );

end;

destructor TblTag_Work.Destroy;
begin

     inherited;
end;

class function TblTag_Work.sCle_from_( _idTag: Integer;  _idWork: Integer): String;
begin
     Result
     :=
         IntToHex( _idTag , 8)
       + IntToHex( _idWork, 8);
end;

function TblTag_Work.sCle: String;
begin
     Result:= sCle_from_( idTag, idWork);
end;

end.


