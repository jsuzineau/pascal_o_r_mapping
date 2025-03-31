unit ublIP;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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
    ufAccueil_Erreur,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upool,

//Aggregations_Pascal_ubl_uses_details_pas


    SysUtils, Classes, SqlDB, DB;

type
 TblIP= class;
//pattern_aggregation_classe_declaration

 { TblIP }

 TblIP
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    ip_address: Integer;
    nb: Integer;
    debut: String;
    fin: String;
//Pascal_ubl_declaration_pas_detail
  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
//pattern_aggregation_function_Create_Aggregation_declaration
  //champ calculé ip
  public
    ip: String;
  end;

 TIterateur_IP
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblIP);
    function  not_Suivant( out _Resultat: TblIP): Boolean;
  end;

 TslIP
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
    function Iterateur: TIterateur_IP;
    function Iterateur_Decroissant: TIterateur_IP;
  end;

function blIP_from_sl( sl: TBatpro_StringList; Index: Integer): TblIP;
function blIP_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblIP;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blIP_from_sl( sl: TBatpro_StringList; Index: Integer): TblIP;
begin
     _Classe_from_sl( Result, TblIP, sl, Index);
end;

function blIP_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblIP;
begin
     _Classe_from_sl_sCle( Result, TblIP, sl, sCle);
end;

{ TIterateur_IP }

function TIterateur_IP.not_Suivant( out _Resultat: TblIP): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_IP.Suivant( out _Resultat: TblIP);
begin
     Suivant_interne( _Resultat);
end;

{ TslIP }

constructor TslIP.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblIP);
end;

destructor TslIP.Destroy;
begin
     inherited;
end;

class function TslIP.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_IP;
end;

function TslIP.Iterateur: TIterateur_IP;
begin
     Result:= TIterateur_IP( Iterateur_interne);
end;

function TslIP.Iterateur_Decroissant: TIterateur_IP;
begin
     Result:= TIterateur_IP( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblIP }

constructor TblIP.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'IP';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'IP';

     //champs persistants
     Champs. Integer_from_Integer( ip_address     , 'ip_address'     );
     Champs. Integer_from_Integer( nb             , 'nb'             );
     Champs.  String_from_String ( debut          , 'debut'          );
     Champs.  String_from_String ( fin            , 'fin'            );
     Ajoute_String( ip, 'ip',False);

     ip:= Format( '%d.%d.%d.%d',
                  [
                  Hi(Hi(Longint(ip_address))),
                  Lo(Hi(Longint(ip_address))),
                  Hi(Lo(Longint(ip_address))),
                  Lo(Lo(Longint(ip_address)))
                  ])
//Pascal_ubl_constructor_pas_detail
end;

destructor TblIP.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblIP.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblIP.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


