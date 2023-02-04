unit ublAnnee;
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
 TblAnnee= class;
//pattern_aggregation_classe_declaration

 { TblAnnee }

 TblAnnee
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Annee: Integer;
    Declare: Double;
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

 TIterateur_Annee
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblAnnee);
    function  not_Suivant( out _Resultat: TblAnnee): Boolean;
  end;

 TslAnnee
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
    function Iterateur: TIterateur_Annee;
    function Iterateur_Decroissant: TIterateur_Annee;
  end;

function blAnnee_from_sl( sl: TBatpro_StringList; Index: Integer): TblAnnee;
function blAnnee_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblAnnee;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blAnnee_from_sl( sl: TBatpro_StringList; Index: Integer): TblAnnee;
begin
     _Classe_from_sl( Result, TblAnnee, sl, Index);
end;

function blAnnee_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblAnnee;
begin
     _Classe_from_sl_sCle( Result, TblAnnee, sl, sCle);
end;

{ TIterateur_Annee }

function TIterateur_Annee.not_Suivant( out _Resultat: TblAnnee): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Annee.Suivant( out _Resultat: TblAnnee);
begin
     Suivant_interne( _Resultat);
end;

{ TslAnnee }

constructor TslAnnee.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblAnnee);
end;

destructor TslAnnee.Destroy;
begin
     inherited;
end;

class function TslAnnee.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Annee;
end;

function TslAnnee.Iterateur: TIterateur_Annee;
begin
     Result:= TIterateur_Annee( Iterateur_interne);
end;

function TslAnnee.Iterateur_Decroissant: TIterateur_Annee;
begin
     Result:= TIterateur_Annee( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblAnnee }

constructor TblAnnee.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Annee';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Annee';

     //champs persistants
     Champs. Integer_from_Integer( Annee          , 'Annee'          );
     Champs.  Double_from_       ( Declare        , 'Declare'        );

//Pascal_ubl_constructor_pas_detail
end;

destructor TblAnnee.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblAnnee.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblAnnee.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
;

end;

(*
procedure TblAnnee.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          
     else                  inherited Create_Aggregation( Name, P);
end;
*)

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


