unit upoolState;
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

  ublState,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfState,
  SysUtils, Classes,
  DB, sqldb;

type
 TpoolState
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfState: ThfState;
  //Accés général
  public
    function Get( _id: integer): TblState;
  //Méthode de création de test
  public
    function Test( _Description: String; _Symbol: String):Integer;

  end;

function poolState: TpoolState;

implementation

{$R *.lfm}

var
   FpoolState: TpoolState;

function poolState: TpoolState;
begin
     Clean_Get( Result, FpoolState, TpoolState);
end;

{ TpoolState }

procedure TpoolState.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'State';
     Classe_Elements:= TblState;
     Classe_Filtre:= ThfState;

     inherited;

     hfState:= hf as ThfState;
end;

function TpoolState.Get( _id: integer): TblState;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolState.Test( _Description: String; _Symbol: String):Integer;
var                                                 
   bl: TblState;                          
begin                                               
     Nouveau_Base( bl);
       bl.Description    := _Description  ;
       bl.Symbol         := _Symbol       ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 

initialization
              Clean_Create ( FpoolState, TpoolState);
finalization
              Clean_destroy( FpoolState);
end.
