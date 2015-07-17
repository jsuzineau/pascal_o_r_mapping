unit upoolTAG;
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

  ublTAG,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTAG,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolTAG
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTAG: ThfTAG;
  //Accés général
  public
    function Get( _id: integer): TblTAG;
      function Get_by_Cle( _idType: Integer;  _Name: String): TblTAG;
  //Méthode de création de test
  public
    function Test( _id: Integer;  _idType: Integer;  _Name: String):Integer;

  end;

function poolTAG: TpoolTAG;

implementation

{$R *.dfm}

var
   FpoolTAG: TpoolTAG;

function poolTAG: TpoolTAG;
begin
     Clean_Get( Result, FpoolTAG, TpoolTAG);
end;

{ TpoolTAG }

procedure TpoolTAG.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Tag';
     Classe_Elements:= TblTAG;
     Classe_Filtre:= ThfTAG;

     inherited;

     hfTAG:= hf as ThfTAG;
end;

function TpoolTAG.Get( _id: integer): TblTAG;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTAG.Get_by_Cle( _idType: Integer;  _Name: String): TblTAG;
begin                               
     idType:=  _idType;
     Name:=  _Name;
     sCle:= TblTAG.sCle_from_( idType, Name);
     Get_Interne( Result);       
end;                             


function TpoolTAG.Test( _id: Integer;  _idType: Integer;  _Name: String):Integer;
var                                                 
   bl: TblTAG;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.id             := _id           ;
       bl.idType         := _idType       ;
       bl.Name           := _Name         ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolTAG, TpoolTAG);
finalization
              Clean_destroy( FpoolTAG);
end.
