unit ublMois;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
 TblMois= class;
//pattern_aggregation_classe_declaration

 { TblMois }

 TblMois
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Annee: Integer;
    Mois: Integer;
    Montant: Double;
    Declare: Double;
    URSSAF: Double;
//Pascal_ubl_declaration_pas_detail
  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
//pattern_aggregation_function_Create_Aggregation_declaration
  end;

 TIterateur_Mois
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblMois);
    function  not_Suivant( out _Resultat: TblMois): Boolean;
  end;

 TslMois
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
    function Iterateur: TIterateur_Mois;
    function Iterateur_Decroissant: TIterateur_Mois;
  end;

function blMois_from_sl( sl: TBatpro_StringList; Index: Integer): TblMois;
function blMois_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblMois;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blMois_from_sl( sl: TBatpro_StringList; Index: Integer): TblMois;
begin
     _Classe_from_sl( Result, TblMois, sl, Index);
end;

function blMois_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblMois;
begin
     _Classe_from_sl_sCle( Result, TblMois, sl, sCle);
end;

{ TIterateur_Mois }

function TIterateur_Mois.not_Suivant( out _Resultat: TblMois): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Mois.Suivant( out _Resultat: TblMois);
begin
     Suivant_interne( _Resultat);
end;

{ TslMois }

constructor TslMois.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblMois);
end;

destructor TslMois.Destroy;
begin
     inherited;
end;

class function TslMois.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Mois;
end;

function TslMois.Iterateur: TIterateur_Mois;
begin
     Result:= TIterateur_Mois( Iterateur_interne);
end;

function TslMois.Iterateur_Decroissant: TIterateur_Mois;
begin
     Result:= TIterateur_Mois( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblMois }

constructor TblMois.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Mois';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Mois';

     //champs persistants
     Champs. Integer_from_Integer( Annee          , 'Annee'          );
     Champs. Integer_from_Integer( Mois           , 'Mois'           );
     Champs.  Double_from_       ( Montant        , 'Montant'        );
     Champs.  Double_from_       ( Declare        , 'Declare'        );
     Champs.  Double_from_       ( URSSAF         , 'URSSAF'         );

//Pascal_ubl_constructor_pas_detail
end;

destructor TblMois.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblMois.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblMois.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
;

end;

(*
procedure TblMois.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          
     else                  inherited Create_Aggregation( Name, P);
end;
*)

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


