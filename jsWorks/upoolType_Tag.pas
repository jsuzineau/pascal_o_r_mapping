unit upoolType_Tag;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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

  ublType_Tag,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,


  uhfType_Tag,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolType_Tag
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfType_Tag: ThfType_Tag;
  //Accés général
  public
    function Get( _id: integer): TblType_Tag;
  //Méthode de création de test
  public
    function Test( _id: Integer;  _Name: String):Integer;

  end;

function poolType_Tag: TpoolType_Tag;

implementation

{$R *.dfm}

var
   FpoolType_Tag: TpoolType_Tag;

function poolType_Tag: TpoolType_Tag;
begin
     Clean_Get( Result, FpoolType_Tag, TpoolType_Tag);
end;

{ TpoolType_Tag }

procedure TpoolType_Tag.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Type_Tag';
     Classe_Elements:= TblType_Tag;
     Classe_Filtre:= ThfType_Tag;
     is_Base:= True;

     inherited;

     hfType_Tag:= hf as ThfType_Tag;
end;

function TpoolType_Tag.Get( _id: integer): TblType_Tag;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolType_Tag.Test( _id: Integer;  _Name: String):Integer;
var                                                 
   bl: TblType_Tag;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.id             := _id           ;
       bl.Name           := _Name         ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolType_Tag, TpoolType_Tag);
finalization
              Clean_destroy( FpoolType_Tag);
end.
