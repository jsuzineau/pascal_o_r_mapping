unit ublg_ctrcir;
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


 Tblg_ctrcir
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    soc: String;
    ets: String;
    type: String;
    circuit: String;
    no_reference: String;
    d1: String;
    d2: String;
    d3: String;
    ok_d1: String;
    ok_d2: String;
    ok_d3: String;
    date_ok1: TDateTime;
    date_ok2: TDateTime;
    date_ok3: TDateTime;
  //Gestion de la clé
  public
  
    function sCle: String; override;

  end;

 TIterateur_g_ctrcir
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: Tblg_ctrcir);
    function  not_Suivant( var _Resultat: Tblg_ctrcir): Boolean;
  end;

 Tslg_ctrcir
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_g_ctrcir;
    function Iterateur_Decroissant: TIterateur_g_ctrcir;
  end;

function blg_ctrcir_from_sl( sl: TBatpro_StringList; Index: Integer): Tblg_ctrcir;
function blg_ctrcir_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblg_ctrcir;

implementation

function blg_ctrcir_from_sl( sl: TBatpro_StringList; Index: Integer): Tblg_ctrcir;
begin
     _Classe_from_sl( Result, Tblg_ctrcir, sl, Index);
end;

function blg_ctrcir_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblg_ctrcir;
begin
     _Classe_from_sl_sCle( Result, Tblg_ctrcir, sl, sCle);
end;

{ TIterateur_g_ctrcir }

function TIterateur_g_ctrcir.not_Suivant( var _Resultat: Tblg_ctrcir): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_g_ctrcir.Suivant( var _Resultat: Tblg_ctrcir);
begin
     Suivant_interne( _Resultat);
end;

{ Tslg_ctrcir }

constructor Tslg_ctrcir.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, Tblg_ctrcir);
end;

destructor Tslg_ctrcir.Destroy;
begin
     inherited;
end;

class function Tslg_ctrcir.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_g_ctrcir;
end;

function Tslg_ctrcir.Iterateur: TIterateur_g_ctrcir;
begin
     Result:= TIterateur_g_ctrcir( Iterateur_interne);
end;

function Tslg_ctrcir.Iterateur_Decroissant: TIterateur_g_ctrcir;
begin
     Result:= TIterateur_g_ctrcir( Iterateur_interne_Decroissant);
end;



{ Tblg_ctrcir }

constructor Tblg_ctrcir.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'g_ctrcir';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'g_ctrcir';

     //champs persistants
     Champs.  String_from_String ( soc            , 'soc'            );
     Champs.  String_from_String ( ets            , 'ets'            );
     Champs.  String_from_String ( type           , 'type'           );
     Champs.  String_from_String ( circuit        , 'circuit'        );
     Champs.  String_from_String ( no_reference   , 'no_reference'   );
     Champs.  String_from_String ( d1             , 'd1'             );
     Champs.  String_from_String ( d2             , 'd2'             );
     Champs.  String_from_String ( d3             , 'd3'             );
     Champs.  String_from_String ( ok_d1          , 'ok_d1'          );
     Champs.  String_from_String ( ok_d2          , 'ok_d2'          );
     Champs.  String_from_String ( ok_d3          , 'ok_d3'          );
     Champs.DateTime_from_       ( date_ok1       , 'date_ok1'       );
     Champs.DateTime_from_       ( date_ok2       , 'date_ok2'       );
     Champs.DateTime_from_       ( date_ok3       , 'date_ok3'       );

end;

destructor Tblg_ctrcir.Destroy;
begin

     inherited;
end;



function Tblg_ctrcir.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


