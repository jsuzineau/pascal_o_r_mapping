unit upoolCategorie;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
  uClean,
  uBatpro_StringList,

  ublType_Tag,

  ublTag,
  upoolTag,

  ublCategorie,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfCategorie,
  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolCategorie }

 TpoolCategorie
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfCategorie: ThfCategorie;
  //Accés général
  public
    function Get( _id: integer): TblCategorie;
  //Méthode de création de test
  public
    function Test( _Symbol: String; _Description: String):Integer;
  //To_Tag conversion en Tags
  public
    procedure To_Tag;
  end;

function poolCategorie: TpoolCategorie;

implementation



var
   FpoolCategorie: TpoolCategorie;

function poolCategorie: TpoolCategorie;
begin
     TPool.class_Get( Result, FpoolCategorie, TpoolCategorie);
end;

{ TpoolCategorie }

procedure TpoolCategorie.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Categorie';
     Classe_Elements:= TblCategorie;
     Classe_Filtre:= ThfCategorie;

     inherited;

     hfCategorie:= hf as ThfCategorie;
end;

function TpoolCategorie.Get( _id: integer): TblCategorie;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolCategorie.Test( _Symbol: String; _Description: String):Integer;
var                                                 
   bl: TblCategorie;                          
begin
     Nouveau_Base( bl);
       bl.Symbol         := _Symbol       ;
       bl.Description    := _Description  ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;

procedure TpoolCategorie.To_Tag;
var
   I: TIterateur;
   bl: TblCategorie;
   blTag: TblTag;
begin
     ToutCharger;
     I:= slT.Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;

       blTag:= poolTag.Assure( Type_Tag_id_Categorie, bl.Description);
       //bl.haWork       .Tag( blTag);
       //bl.haDevelopment.Tag( blTag);
       end;
end;


initialization
finalization
              TPool.class_Destroy( FpoolCategorie);
end.
