unit ublG_CTXTYPE;
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
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,
    upoolG_CTX,
  SysUtils, Classes, DB;

type
 TblG_CTXTYPE
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    contextetype: String;
    hierarchie: String;
    libelle: String;

  //aggrégations faibles
    slG_CTX: TBatpro_StringList;
  public
//pattern_aggregations_faibles_declaration
  //Gestion de la clé
  public
    class function sCle_from_( _contextetype: String): String;

    function sCle: String; override;
  end;

function blG_CTXTYPE_from_sl( sl: TBatpro_StringList; Index: Integer): TblG_CTXTYPE;
function blG_CTXTYPE_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblG_CTXTYPE;

implementation

function blG_CTXTYPE_from_sl( sl: TBatpro_StringList; Index: Integer): TblG_CTXTYPE;
begin
     _Classe_from_sl( Result, TblG_CTXTYPE, sl, Index);
end;

function blG_CTXTYPE_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblG_CTXTYPE;
begin
     _Classe_from_sl_sCle( Result, TblG_CTXTYPE, sl, sCle);
end;

{ TblG_CTXTYPE }

constructor TblG_CTXTYPE.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'G_CTXTYPE';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'g_ctxtype';

     //champs persistants
     Champs.  String_from_String ( contextetype   , 'contextetype'   );
     Champs.  String_from_String ( hierarchie     , 'hierarchie'     );
     Champs.  String_from_String ( libelle        , 'libelle'        );


     //Aggrégations faibles
     slG_CTX:= TBatpro_StringList.Create;
     poolG_CTX.Charge_CONTEXTETYPE( contextetype, slG_CTX);
//pattern_aggregations_faibles_pool_get
     // Code manuel
end;

destructor TblG_CTXTYPE.Destroy;
begin
     Free_nil( slG_CTX);
     inherited;
end;

class function TblG_CTXTYPE.sCle_from_( _contextetype: String): String;
begin
     Result:=  Fixe_Length( _contextetype, 50);    
end;                                

function TblG_CTXTYPE.sCle: String;
begin
     Result:= sCle_from_( contextetype);
end;

end.


