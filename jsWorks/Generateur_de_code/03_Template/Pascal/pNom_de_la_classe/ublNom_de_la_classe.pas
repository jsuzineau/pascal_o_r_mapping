unit ublNom_de_la_classe;
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
    u_sys_,
    uuStrings,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type
//pattern_aggregation_classe_declaration

 TblNom_de_la_classe
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
//pattern_declaration_champs
  //Gestion de la clé
  public
//pattern_sCle_from__Declaration  
    function sCle: String; override;
//pattern_aggregation_function_Create_Aggregation_declaration
  end;

 TIterateur_Nom_de_la_classe
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblNom_de_la_classe);
    function  not_Suivant( out _Resultat: TblNom_de_la_classe): Boolean;
  end;

 TslNom_de_la_classe
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
    function Iterateur: TIterateur_Nom_de_la_classe;
    function Iterateur_Decroissant: TIterateur_Nom_de_la_classe;
  end;

function blNom_de_la_classe_from_sl( sl: TBatpro_StringList; Index: Integer): TblNom_de_la_classe;
function blNom_de_la_classe_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblNom_de_la_classe;

implementation

function blNom_de_la_classe_from_sl( sl: TBatpro_StringList; Index: Integer): TblNom_de_la_classe;
begin
     _Classe_from_sl( Result, TblNom_de_la_classe, sl, Index);
end;

function blNom_de_la_classe_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblNom_de_la_classe;
begin
     _Classe_from_sl_sCle( Result, TblNom_de_la_classe, sl, sCle);
end;

{ TIterateur_Nom_de_la_classe }

function TIterateur_Nom_de_la_classe.not_Suivant( out _Resultat: TblNom_de_la_classe): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Nom_de_la_classe.Suivant( out _Resultat: TblNom_de_la_classe);
begin
     Suivant_interne( _Resultat);
end;

{ TslNom_de_la_classe }

constructor TslNom_de_la_classe.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblNom_de_la_classe);
end;

destructor TslNom_de_la_classe.Destroy;
begin
     inherited;
end;

class function TslNom_de_la_classe.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Nom_de_la_classe;
end;

function TslNom_de_la_classe.Iterateur: TIterateur_Nom_de_la_classe;
begin
     Result:= TIterateur_Nom_de_la_classe( Iterateur_interne);
end;

function TslNom_de_la_classe.Iterateur_Decroissant: TIterateur_Nom_de_la_classe;
begin
     Result:= TIterateur_Nom_de_la_classe( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ TblNom_de_la_classe }

constructor TblNom_de_la_classe.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Nom_de_la_classe';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Nom_de_la_table';

     //champs persistants
//pattern_creation_champs
end;

destructor TblNom_de_la_classe.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function TblNom_de_la_classe.sCle: String;
begin
//pattern_sCle_Implementation_Body
end;

//pattern_aggregation_Create_Aggregation_implementation

//pattern_aggregation_accesseurs_implementation

end.


