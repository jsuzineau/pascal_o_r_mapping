unit upoolTYPE_TAG;
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

  ublTYPE_TAG,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTYPE_TAG,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolTYPE_TAG
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTYPE_TAG: ThfTYPE_TAG;
  //Accés général
  public
    function Get( _id: integer): TblTYPE_TAG;
  //Méthode de création de test
  public
    function Test( _id: Integer;  _Name: String):Integer;

  end;

function poolTYPE_TAG: TpoolTYPE_TAG;

implementation

{$R *.dfm}

var
   FpoolTYPE_TAG: TpoolTYPE_TAG;

function poolTYPE_TAG: TpoolTYPE_TAG;
begin
     Clean_Get( Result, FpoolTYPE_TAG, TpoolTYPE_TAG);
end;

{ TpoolTYPE_TAG }

procedure TpoolTYPE_TAG.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Type_Tag';
     Classe_Elements:= TblTYPE_TAG;
     Classe_Filtre:= ThfTYPE_TAG;

     inherited;

     hfTYPE_TAG:= hf as ThfTYPE_TAG;
end;

function TpoolTYPE_TAG.Get( _id: integer): TblTYPE_TAG;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTYPE_TAG.Test( _id: Integer;  _Name: String):Integer;
var                                                 
   bl: TblTYPE_TAG;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.id             := _id           ;
       bl.Name           := _Name         ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolTYPE_TAG, TpoolTYPE_TAG);
finalization
              Clean_destroy( FpoolTYPE_TAG);
end.
