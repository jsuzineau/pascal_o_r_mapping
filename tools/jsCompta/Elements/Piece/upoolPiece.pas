unit upoolPiece;
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

  ublPiece,

//Aggregations_Pascal_upool_uses_details_pas

  uhfPiece,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolPiece }

 TpoolPiece
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfPiece: ThfPiece;
  //Accés général
  public
    function Get( _id: integer): TblPiece;
  //Nouveau
  public
    function Nouveau: TblPiece;
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
    function Test( _Facture_id: Integer;  _Date: String):Integer;

  //Chargement d'un Facture
  public
    procedure Charge_Facture( _Facture_id: Integer; _slLoaded: TBatpro_StringList = nil);

  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Piece;
    function Iterateur_Decroissant: TIterateur_Piece;
  end;

function poolPiece: TpoolPiece;

implementation



var
   FpoolPiece: TpoolPiece;

function poolPiece: TpoolPiece;
begin
     TPool.class_Get( Result, FpoolPiece, TpoolPiece);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolPiece }

procedure TpoolPiece.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Piece';
     Classe_Elements:= TblPiece;
     Classe_Filtre:= ThfPiece;

     inherited;

     hfPiece:= hf as ThfPiece;
end;

function TpoolPiece.Get( _id: integer): TblPiece;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolPiece.Nouveau: TblPiece;
begin
     Nouveau_Base( Result);
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolPiece.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolPiece.SQLWHERE_ContraintesChamps: String;
begin
//pattern_SQLWHERE_ContraintesChamps_Body
end;

function TpoolPiece.Test( _Facture_id: Integer;  _Date: String):Integer;
var                                                 
   bl: TblPiece;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Facture_id     := _Facture_id   ;
       bl.Date           := _Date         ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


procedure TpoolPiece.Charge_Facture( _Facture_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Facture_id = '+IntToStr( _Facture_id);

     Load( SQL, _slLoaded);
end;


class function TpoolPiece.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Piece;
end;

function TpoolPiece.Iterateur: TIterateur_Piece;
begin
     Result:= TIterateur_Piece( Iterateur_interne);
end;

function TpoolPiece.Iterateur_Decroissant: TIterateur_Piece;
begin
     Result:= TIterateur_Piece( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolPiece);
end.
