unit upoolJour_ferie;
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

  ublJour_ferie,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfJour_ferie,
  SysUtils, Classes,
  DB, sqldb;

type
 TpoolJour_ferie
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfJour_ferie: ThfJour_ferie;
  //Accés général
  public
    function Get( _id: integer): TblJour_ferie;
  //Méthode de création de test
  public
    function Test( _Jour: TDateTime):Integer;
  end;

function poolJour_ferie: TpoolJour_ferie;

implementation

{$R *.lfm}

var
   FpoolJour_ferie: TpoolJour_ferie;

function poolJour_ferie: TpoolJour_ferie;
begin
     Clean_Get( Result, FpoolJour_ferie, TpoolJour_ferie);
end;

{ TpoolJour_ferie }

procedure TpoolJour_ferie.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Jour_ferie';
     Classe_Elements:= TblJour_ferie;
     Classe_Filtre:= ThfJour_ferie;

     inherited;

     hfJour_ferie:= hf as ThfJour_ferie;
end;

function TpoolJour_ferie.Get( _id: integer): TblJour_ferie;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolJour_ferie.Test( _Jour: TDateTime):Integer;
var                                                 
   bl: TblJour_ferie;                          
begin                                               
     Nouveau_Base( bl);
       bl.Jour           := _Jour         ;
     bl.Save_to_database;
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolJour_ferie, TpoolJour_ferie);
finalization
              Clean_destroy( FpoolJour_ferie);
end.
