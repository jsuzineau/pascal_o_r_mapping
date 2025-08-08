unit upoolReputation;
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

  ublReputation,

//Aggregations_Pascal_upool_uses_details_pas

  uhfReputation,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolReputation }

 TpoolReputation
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfReputation: ThfReputation;
  //Accés général
  public
    function Get( _id: integer): TblReputation;
  public
    function Iterateur_Filtre: TIterateur_Reputation;
  //Nouveau
  public
    function Nouveau: TblReputation;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
    ip_address: Integer;

    function Get_by_Cle( _ip_address: Integer): TblReputation;
    function Assure( _ip_address: Integer): TblReputation;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _ip_address: Integer;  _bad: Integer;  _tested: String;  _ip: String):Integer;

//Details_Pascal_upool_charge_detail_declaration_pas
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Reputation;
    function Iterateur_Decroissant: TIterateur_Reputation;
  end;

function poolReputation: TpoolReputation;

implementation



var
   FpoolReputation: TpoolReputation;

function poolReputation: TpoolReputation;
begin
     TPool.class_Get( Result, FpoolReputation, TpoolReputation);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolReputation }

procedure TpoolReputation.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Reputation';
     Classe_Elements:= TblReputation;
     Classe_Filtre:= ThfReputation;

     inherited;

     hfReputation:= hf as ThfReputation;
end;

function TpoolReputation.Get( _id: integer): TblReputation;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolReputation.Iterateur_Filtre: TIterateur_Reputation;
begin
     Result:= TIterateur_Reputation( slFiltre.Iterateur_interne);
end;

function TpoolReputation.Nouveau: TblReputation;
begin
     Nouveau_Base( Result);
end;

function TpoolReputation.Get_by_Cle( _ip_address: Integer): TblReputation;
begin                               
     ip_address:=  _ip_address;
     sCle:= TblReputation.sCle_from_( ip_address);
     Get_Interne( Result);       
end;                             


function TpoolReputation.Assure( _ip_address: Integer): TblReputation;
begin                               
     Result:= Get_by_Cle(  _ip_address);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.ip_address     := _ip_address   ;
     Result.Save_to_database;
end;


procedure TpoolReputation.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
       ParamByName( 'ip_address'    ).AsInteger:= ip_address;
       end;
end;

function TpoolReputation.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         ip_address      = :ip_address     ';
end;

function TpoolReputation.Test( _ip_address: Integer;  _bad: Integer;  _tested: String;  _ip: String):Integer;
var                                                 
   bl: TblReputation;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.ip_address     := _ip_address   ;
       bl.bad            := _bad          ;
       bl.tested         := _tested       ;
       bl.ip             := _ip           ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


//Details_Pascal_upool_charge_detail_implementation_pas

class function TpoolReputation.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Reputation;
end;

function TpoolReputation.Iterateur: TIterateur_Reputation;
begin
     Result:= TIterateur_Reputation( Iterateur_interne);
end;

function TpoolReputation.Iterateur_Decroissant: TIterateur_Reputation;
begin
     Result:= TIterateur_Reputation( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolReputation);
end.
