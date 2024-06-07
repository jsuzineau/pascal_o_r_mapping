unit upoolChant;
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

  ublChant,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfChant,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolChant }

 TpoolChant
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfChant: ThfChant;
  //Accés général
  public
    function Get( _id: integer): TblChant;
  public
    function Iterateur_Filtre: TIterateur_Chant;
//Méthode de création de test
  public
    function Test( _Titre: String; _n1: String; _n2: String; _n3: String; _n4: String):Integer;

  end;

function poolChant: TpoolChant;

implementation

var
   FpoolChant: TpoolChant;

function poolChant: TpoolChant;
begin
     TPool.class_Get( Result, FpoolChant, TpoolChant);
end;

{ TpoolChant }

procedure TpoolChant.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Chant';
     Classe_Elements:= TblChant;
     Classe_Filtre:= ThfChant;

     inherited;

     hfChant:= hf as ThfChant;
end;

function TpoolChant.Get( _id: integer): TblChant;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolChant.Iterateur_Filtre: TIterateur_Chant;
begin
     Result:= TIterateur_Chant( slFiltre.Iterateur_interne);
end;

function TpoolChant.Test( _Titre: String; _n1: String; _n2: String; _n3: String; _n4: String):Integer;
var                                                 
   bl: TblChant;                          
begin                                               
     Nouveau_Base( bl);
       bl.Titre:= _Titre;
       bl.n1   := _n1   ;
       bl.n2   := _n2   ;
       bl.n3   := _n3   ;
       bl.n4   := _n4   ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
finalization
              TPool.class_Destroy( FpoolChant);
end.
