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
 TpoolChant
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfChant: ThfChant;
  //Acc�s g�n�ral
  public
    function Get( _id: integer): TblChant;
  //M�thode de cr�ation de test
  public
    function Test( _Titre: String;  _Soprano: String;  _Alto: String;  _Tenor: String;  _Basse: String):Integer;

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

function TpoolChant.Test( _Titre: String;  _Soprano: String;  _Alto: String;  _Tenor: String;  _Basse: String):Integer;
var                                                 
   bl: TblChant;                          
begin                                               
     Nouveau_Base( bl);
       bl.Titre          := _Titre        ;
       bl.Soprano        := _Soprano      ;
       bl.Alto           := _Alto         ;
       bl.Tenor          := _Tenor        ;
       bl.Basse          := _Basse        ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
finalization
              TPool.class_Destroy( FpoolChant);
end.