unit upoolTiming;
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

  ublTiming,

//Aggregations_Pascal_upool_uses_details_pas

  uhfTiming,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolTiming }

 TpoolTiming
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfTiming: ThfTiming;
  //Accés général
  public
    function Get( _id: integer): TblTiming;
  //Nouveau
  public
    function Nouveau: TblTiming;
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
    function Test( _t: TDateTime;  _Texte_id: Integer):Integer;

  //Chargement d'un Texte
  public
    procedure Charge_Texte( _Texte_id: Integer; _slLoaded: TBatpro_StringList = nil);

  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Timing;
    function Iterateur_Decroissant: TIterateur_Timing;
  end;

function poolTiming: TpoolTiming;

implementation



var
   FpoolTiming: TpoolTiming;

function poolTiming: TpoolTiming;
begin
     TPool.class_Get( Result, FpoolTiming, TpoolTiming);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolTiming }

procedure TpoolTiming.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Timing';
     Classe_Elements:= TblTiming;
     Classe_Filtre:= ThfTiming;

     inherited;

     hfTiming:= hf as ThfTiming;
     ChampTri['t']:= +1;
end;

function TpoolTiming.Get( _id: integer): TblTiming;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTiming.Nouveau: TblTiming;
begin
     Nouveau_Base( Result);
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolTiming.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolTiming.SQLWHERE_ContraintesChamps: String;
begin
//pattern_SQLWHERE_ContraintesChamps_Body
end;

function TpoolTiming.Test(_t: TDateTime; _Texte_id: Integer): Integer;
var                                                 
   bl: TblTiming;                          
begin                                               
     Nouveau_Base( bl);
       bl.t              := _t            ;
       bl.Texte_id       := _Texte_id     ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


procedure TpoolTiming.Charge_Texte( _Texte_id: Integer; _slLoaded: TBatpro_StringList = nil);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where Texte_id = '+IntToStr( _Texte_id);

     Load( SQL, _slLoaded);
end;


class function TpoolTiming.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Timing;
end;

function TpoolTiming.Iterateur: TIterateur_Timing;
begin
     Result:= TIterateur_Timing( Iterateur_interne);
end;

function TpoolTiming.Iterateur_Decroissant: TIterateur_Timing;
begin
     Result:= TIterateur_Timing( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolTiming);
end.
