unit upoolIP;
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
  uBatpro_StringList,
{implementation_uses_key}

  udmDatabase,
  udmBatpro_DataModule,
  uPool,

  ublIP,

//Aggregations_Pascal_upool_uses_details_pas

  uhfIP,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolIP }

 TpoolIP
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfIP: ThfIP;
  //Accés général
  public
    function Get( _id: integer): TblIP;
  public
    function Iterateur_Filtre: TIterateur_IP;
  //Nouveau
  public
    function Nouveau: TblIP;
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
    function Test( _ip_address: Integer;  _nb: Integer;  _debut: String;  _fin: String):Integer;

//Details_Pascal_upool_charge_detail_declaration_pas
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_IP;
    function Iterateur_Decroissant: TIterateur_IP;
  //Chargement des premières lignes
  public
    procedure Charge_limit( _N: Integer; _slLoaded: TBatpro_StringList= nil);
  end;

function poolIP: TpoolIP;

implementation



var
   FpoolIP: TpoolIP;

function poolIP: TpoolIP;
begin
     TPool.class_Get( Result, FpoolIP, TpoolIP);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolIP }

procedure TpoolIP.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'IP';
     Classe_Elements:= TblIP;
     Classe_Filtre:= ThfIP;

     inherited;

     hfIP:= hf as ThfIP;
end;

function TpoolIP.Get( _id: integer): TblIP;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolIP.Iterateur_Filtre: TIterateur_IP;
begin
     Result:= TIterateur_IP( slFiltre.Iterateur_interne);
end;

function TpoolIP.Nouveau: TblIP;
begin
     Nouveau_Base( Result);
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolIP.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolIP.SQLWHERE_ContraintesChamps: String;
begin
//pattern_SQLWHERE_ContraintesChamps_Body
end;

function TpoolIP.Test( _ip_address: Integer;  _nb: Integer;  _debut: String;  _fin: String):Integer;
var                                                 
   bl: TblIP;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.ip_address     := _ip_address   ;
       bl.nb             := _nb           ;
       bl.debut          := _debut        ;
       bl.fin            := _fin          ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


//Details_Pascal_upool_charge_detail_implementation_pas

class function TpoolIP.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_IP;
end;

function TpoolIP.Iterateur: TIterateur_IP;
begin
     Result:= TIterateur_IP( Iterateur_interne);
end;

function TpoolIP.Iterateur_Decroissant: TIterateur_IP;
begin
     Result:= TIterateur_IP( Iterateur_interne_Decroissant);
end;

procedure TpoolIP.Charge_limit(_N: Integer; _slLoaded: TBatpro_StringList= nil);
var
   SQL: String;
begin
     SQL
     :=
        'select                  '#13#10
       +'      *                 '#13#10
       +'from                    '#13#10
       +'    IP                  '#13#10
       +'limit '+IntToStr(_N)+'  '#13#10
       ;
     Load( SQL, _slLoaded);
end;

initialization
finalization
              TPool.class_Destroy( FpoolIP);
end.
