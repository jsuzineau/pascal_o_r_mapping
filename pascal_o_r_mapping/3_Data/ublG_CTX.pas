unit ublG_CTX;
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
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    upool_Ancetre_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,
    upoolG_BECPCTX,
  SysUtils, Classes, DB;

type
 TblG_CTX
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    contexte: Integer;
    contextetype: String;
    libelle: String;

  //aggrégations faibles
    slG_BECPCTX: TBatpro_StringList;
  //Gestion de la clé
  public
    class function sCle_from_( _contexte: Integer): String;

    function sCle: String; override;
  end;

function blG_CTX_from_sl( sl: TBatpro_StringList; Index: Integer): TblG_CTX;
function blG_CTX_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblG_CTX;

implementation

function blG_CTX_from_sl( sl: TBatpro_StringList; Index: Integer): TblG_CTX;
begin
     _Classe_from_sl( Result, TblG_CTX, sl, Index);
end;

function blG_CTX_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblG_CTX;
begin
     _Classe_from_sl_sCle( Result, TblG_CTX, sl, sCle);
end;

{ TblG_CTX }

constructor TblG_CTX.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'G_CTX';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'g_ctx';

     //champs persistants
     Champs. Integer_from_Integer( contexte       , 'contexte'       );
     Champs.  String_from_String ( contextetype   , 'contextetype'   );
     Champs.  String_from_String ( libelle        , 'libelle'        );


     //Aggrégations faibles
     slG_BECPCTX:= TBatpro_StringList.Create;
     poolG_BECPCTX.Charge_Contexte( contexte, slG_BECPCTX);
//pattern_aggregations_faibles_pool_get
     // Code manuel
end;

destructor TblG_CTX.Destroy;
begin
     Free_nil( slG_BECPCTX);
     inherited;
end;

class function TblG_CTX.sCle_from_( _contexte: Integer): String;
begin                               
     Result:=  IntToStr( _contexte);    
end;                                

function TblG_CTX.sCle: String;
begin
     Result:= sCle_from_( contexte);
end;

end.


