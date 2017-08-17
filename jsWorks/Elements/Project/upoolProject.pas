unit upoolProject;
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

  ublProject,
  ublType_Tag,
  ublTag,
  ublWork,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  upoolTag,
  

  uhfProject,
  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolProject }

 TpoolProject
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfProject: ThfProject;
  //Accés général
  public
    function Get( _id: integer): TblProject;
  //Méthode de création de test
  public
    function Test( _Name: String):Integer;
  //To_Tag conversion en Tags
  public
    procedure To_Tag;
  end;

function poolProject: TpoolProject;

implementation



var
   FpoolProject: TpoolProject;

function poolProject: TpoolProject;
begin
     TPool.class_Get( Result, FpoolProject, TpoolProject);
end;

{ TpoolProject }

procedure TpoolProject.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Project';
     Classe_Elements:= TblProject;
     Classe_Filtre:= ThfProject;

     inherited;

     hfProject:= hf as ThfProject;
end;

function TpoolProject.Get( _id: integer): TblProject;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolProject.Test( _Name: String):Integer;
var                                                 
   bl: TblProject;                          
begin                                               
     Nouveau_Base( bl);
       bl.Name           := _Name         ;
     bl.Save_to_database;
     Result:= bl.id;                                 
end;

procedure TpoolProject.To_Tag;
var
   I: TIterateur;
   bl: TblProject;
   blTag: TblTag;
begin
     ToutCharger;
     I:= slT.Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;

       blTag:= poolTag.Assure( Type_Tag_id_Project, bl.Name);
       bl.haWork       .Tag( blTag);
       bl.haDevelopment.Tag( blTag);
       end;
end;

initialization
finalization
              TPool.class_Destroy( FpoolProject);
end.
