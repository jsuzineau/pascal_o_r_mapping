unit upoolClient;
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

  ublClient,

    ublFacture,
    upoolFacture,


  uhfClient,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolClient }

 TpoolClient
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfClient: ThfClient;
  //Accés général
  public
    function Get( _id: integer): TblClient;
  //Nouveau
  public
    function Nouveau: TblClient;
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
    function Test( _Nom: String;  _Adresse_1: String;  _Adresse_2: String;  _Adresse_3: String;  _Code_Postal: String;  _Ville: String):Integer;

//Details_Pascal_upool_charge_detail_declaration_pas
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Client;
    function Iterateur_Decroissant: TIterateur_Client;
  end;

function poolClient: TpoolClient;

implementation



var
   FpoolClient: TpoolClient;

function poolClient: TpoolClient;
begin
     TPool.class_Get( Result, FpoolClient, TpoolClient);

     if nil = ublFacture_poolClient
     then
         ublFacture_poolClient:= Result;

end;

{ TpoolClient }

procedure TpoolClient.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Client';
     Classe_Elements:= TblClient;
     Classe_Filtre:= ThfClient;

     inherited;

     hfClient:= hf as ThfClient;
end;

function TpoolClient.Get( _id: integer): TblClient;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolClient.Nouveau: TblClient;
begin
     Nouveau_Base( Result);
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolClient.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolClient.SQLWHERE_ContraintesChamps: String;
begin
//pattern_SQLWHERE_ContraintesChamps_Body
end;

function TpoolClient.Test( _Nom: String;  _Adresse_1: String;  _Adresse_2: String;  _Adresse_3: String;  _Code_Postal: String;  _Ville: String):Integer;
var                                                 
   bl: TblClient;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Nom            := _Nom          ;
       bl.Adresse_1      := _Adresse_1    ;
       bl.Adresse_2      := _Adresse_2    ;
       bl.Adresse_3      := _Adresse_3    ;
       bl.Code_Postal    := _Code_Postal  ;
       bl.Ville          := _Ville        ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


//Details_Pascal_upool_charge_detail_implementation_pas

class function TpoolClient.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Client;
end;

function TpoolClient.Iterateur: TIterateur_Client;
begin
     Result:= TIterateur_Client( Iterateur_interne);
end;

function TpoolClient.Iterateur_Decroissant: TIterateur_Client;
begin
     Result:= TIterateur_Client( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolClient);
end.
