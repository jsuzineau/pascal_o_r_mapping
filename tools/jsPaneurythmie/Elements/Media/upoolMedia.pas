unit upoolMedia;
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

  ublMedia,

//Aggregations_Pascal_upool_uses_details_pas

  uhfMedia,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolMedia }

 TpoolMedia
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfMedia: ThfMedia;
  //Accés général
  public
    function Get( _id: integer): TblMedia;
  //Nouveau
  public
    function Nouveau: TblMedia;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  //Méthode de création de test
  public
    function Test(_Titre: String; _NomFichier: String; _Boucler: Boolean): Integer;

//Details_Pascal_upool_charge_detail_declaration_pas
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Media;
    function Iterateur_Decroissant: TIterateur_Media;
  end;

function poolMedia: TpoolMedia;

implementation



var
   FpoolMedia: TpoolMedia;

function poolMedia: TpoolMedia;
begin
     TPool.class_Get( Result, FpoolMedia, TpoolMedia);
//Aggregations_Pascal_upool_affectation_pool_details_pas
end;

{ TpoolMedia }

procedure TpoolMedia.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Media';
     Classe_Elements:= TblMedia;
     Classe_Filtre:= ThfMedia;

     inherited;

     hfMedia:= hf as ThfMedia;
end;

function TpoolMedia.Get( _id: integer): TblMedia;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolMedia.Nouveau: TblMedia;
begin
     Nouveau_Base( Result);
end;

//pattern_Get_by_Cle_Implementation

//pattern_Assure_Implementation

procedure TpoolMedia.To_Params( _Params: TParams);
begin
     with _Params
     do
       begin
//pattern_To_SQLQuery_Params_Body
       end;
end;

function TpoolMedia.Test( _Titre: String;  _NomFichier: String;  _Boucler: Boolean):Integer;
var                                                 
   bl: TblMedia;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.Titre          := _Titre        ;
       bl.NomFichier     := _NomFichier   ;
       bl.Boucler        := _Boucler      ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


//Details_Pascal_upool_charge_detail_implementation_pas

class function TpoolMedia.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Media;
end;

function TpoolMedia.Iterateur: TIterateur_Media;
begin
     Result:= TIterateur_Media( Iterateur_interne);
end;

function TpoolMedia.Iterateur_Decroissant: TIterateur_Media;
begin
     Result:= TIterateur_Media( Iterateur_interne_Decroissant);
end;

initialization
finalization
              TPool.class_Destroy( FpoolMedia);
end.
