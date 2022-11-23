unit upoolNom_de_la_classe;
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
  uBatpro_StringList,
{implementation_uses_key}

  udmDatabase,
  udmBatpro_DataModule,
  uPool,

  ublNom_de_la_classe,

//Aggregations_Pascal_upool_uses_details_pas

  uhfNom_de_la_classe,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolNom_de_la_classe }

 TpoolNom_de_la_classe
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfNom_de_la_classe: ThfNom_de_la_classe;
  //Accés général
  public
    function Get( _id: integer): TblNom_de_la_classe;
  //Nouveau
  public
    function Nouveau: TblNom_de_la_classe;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
  //pattern_Declaration_cle
  //pattern_Get_by_Cle_Declaration
  //pattern_Assure_Declaration
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
{Test_Declaration_Key}
//Details_Pascal_upool_charge_detail_declaration_pas
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Nom_de_la_classe;
    function Iterateur_Decroissant: TIterateur_Nom_de_la_classe;
  end;

function poolNom_de_la_classe: TpoolNom_de_la_classe;

implementation



var
   FpoolNom_de_la_classe: TpoolNom_de_la_classe;

function poolNom_de_la_classe: TpoolNom_de_la_classe;
begin
     TPool.class_Get( Result, FpoolNom_de_la_classe, TpoolNom_de_la_classe);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolNom_de_la_classe }

procedure TpoolNom_de_la_classe.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Nom_de_la_table';
     Classe_Elements:= TblNom_de_la_classe;
     Classe_Filtre:= ThfNom_de_la_classe;

     inherited;

     hfNom_de_la_classe:= hf as ThfNom_de_la_classe;
end;

function TpoolNom_de_la_classe.Get( _id: integer): TblNom_de_la_classe;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolNom_de_la_classe.Nouveau: TblNom_de_la_classe;
begin
     Nouveau_Base( Result);
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolNom_de_la_classe.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolNom_de_la_classe.SQLWHERE_ContraintesChamps: String;
begin
//pattern_SQLWHERE_ContraintesChamps_Body
end;

{Test_Implementation_Key}

//Details_Pascal_upool_charge_detail_implementation_pas

class function TpoolNom_de_la_classe.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Nom_de_la_classe;
end;

function TpoolNom_de_la_classe.Iterateur: TIterateur_Nom_de_la_classe;
begin
     Result:= TIterateur_Nom_de_la_classe( Iterateur_interne);
end;

function TpoolNom_de_la_classe.Iterateur_Decroissant: TIterateur_Nom_de_la_classe;
begin
     Result:= TIterateur_Nom_de_la_classe( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolNom_de_la_classe);
end.
