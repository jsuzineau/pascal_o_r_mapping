unit ublTexte;
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
 TblTexte= class;
//pattern_aggregation_classe_declaration

 { TblTexte }

 TblTexte
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    t: String;
    Cyrillique: String;
    Translitteration: String;
    Francais: String;
//Pascal_ubl_declaration_pas_detail
  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
    function sCle: String; override;
  //Gestion des déconnexions
  public
//pattern_aggregation_function_Create_Aggregation_declaration
  end;

 TIterateur_Texte
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblTexte);
    function  not_Suivant( out _Resultat: TblTexte): Boolean;
  end;

 TslTexte
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
    function Iterateur: TIterateur_Texte;
    function Iterateur_Decroissant: TIterateur_Texte;
  end;

function blTexte_from_sl( sl: TBatpro_StringList; Index: Integer): TblTexte;
function blTexte_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTexte;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blTexte_from_sl( sl: TBatpro_StringList; Index: Integer): TblTexte;
begin
     _Classe_from_sl( Result, TblTexte, sl, Index);
end;

function blTexte_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTexte;
begin
     _Classe_from_sl_sCle( Result, TblTexte, sl, sCle);
end;

{ TIterateur_Texte }

function TIterateur_Texte.not_Suivant( out _Resultat: TblTexte): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Texte.Suivant( out _Resultat: TblTexte);
begin
     Suivant_interne( _Resultat);
end;

{ TslTexte }

constructor TslTexte.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTexte);
end;

destructor TslTexte.Destroy;
begin
     inherited;
end;

class function TslTexte.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Texte;
end;

function TslTexte.Iterateur: TIterateur_Texte;
begin
     Result:= TIterateur_Texte( Iterateur_interne);
end;

function TslTexte.Iterateur_Decroissant: TIterateur_Texte;
begin
     Result:= TIterateur_Texte( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblTexte }

constructor TblTexte.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Texte';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Texte';

     //champs persistants
     Champs.  String_from_String ( t              , 't'              );
     Champs.  String_from_String ( Cyrillique     , 'Cyrillique'     );
     Champs.  String_from_String ( Translitteration, 'Translitteration');
     Champs.  String_from_String ( Francais       , 'Francais'       );

//Pascal_ubl_constructor_pas_detail
end;

destructor TblTexte.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblTexte.sCle: String;
begin
     Result:= sCle_ID;
end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


