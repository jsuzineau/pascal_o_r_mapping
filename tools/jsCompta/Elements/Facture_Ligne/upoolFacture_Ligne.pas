unit upoolFacture_Ligne;
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

  ublFacture_Ligne,

//Aggregations_Pascal_upool_uses_details_pas

  uhfFacture_Ligne,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolFacture_Ligne }

 TpoolFacture_Ligne
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfFacture_Ligne: ThfFacture_Ligne;
  //Accés général
  public
    function Get( _id: integer): TblFacture_Ligne;
  //Nouveau
  public
    function Nouveau: TblFacture_Ligne;
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
    function Test( _Facture_id: Integer;  _Date: String;  _Libelle: String;  _NbHeures: Double;  _Prix_unitaire: Double;  _Montant: Double):Integer;

  //Chargement d'un Facture
  public
    procedure Charge_Facture( _Facture_id: Integer; _slLoaded: TBatpro_StringList = nil);

  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Facture_Ligne;
    function Iterateur_Decroissant: TIterateur_Facture_Ligne;
  end;

function poolFacture_Ligne: TpoolFacture_Ligne;

implementation



var
   FpoolFacture_Ligne: TpoolFacture_Ligne;

function poolFacture_Ligne: TpoolFacture_Ligne;
begin
     TPool.class_Get( Result, FpoolFacture_Ligne, TpoolFacture_Ligne);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolFacture_Ligne }

procedure TpoolFacture_Ligne.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Facture_Ligne';
     Classe_Elements:= TblFacture_Ligne;
     Classe_Filtre:= ThfFacture_Ligne;

     inherited;

     hfFacture_Ligne:= hf as ThfFacture_Ligne;
end;

function TpoolFacture_Ligne.Get( _id: integer): TblFacture_Ligne;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolFacture_Ligne.Nouveau: TblFacture_Ligne;
begin
     Nouveau_Base( Result);
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolFacture_Ligne.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolFacture_Ligne.SQLWHERE_ContraintesChamps: String;
begin
//pattern_SQLWHERE_ContraintesChamps_Body
end;

function TpoolFacture_Ligne.Test( _Facture_id: Integer;  _Date: String;  _Libelle: String;  _NbHeures: Double;  _Prix_unitaire: Double;  _Montant: Double):Integer;
var                                                 
   bl: TblFacture_Ligne;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Facture_id     := _Facture_id   ;
       bl.Date           := _Date         ;
       bl.Libelle        := _Libelle      ;
       bl.NbHeures       := _NbHeures     ;
       bl.Prix_unitaire  := _Prix_unitaire;
       bl.Montant        := _Montant      ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


procedure TpoolFacture_Ligne.Charge_Facture( _Facture_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Facture_id = '+IntToStr( _Facture_id);

     Load( SQL, _slLoaded);
end;


class function TpoolFacture_Ligne.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Facture_Ligne;
end;

function TpoolFacture_Ligne.Iterateur: TIterateur_Facture_Ligne;
begin
     Result:= TIterateur_Facture_Ligne( Iterateur_interne);
end;

function TpoolFacture_Ligne.Iterateur_Decroissant: TIterateur_Facture_Ligne;
begin
     Result:= TIterateur_Facture_Ligne( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolFacture_Ligne);
end.
