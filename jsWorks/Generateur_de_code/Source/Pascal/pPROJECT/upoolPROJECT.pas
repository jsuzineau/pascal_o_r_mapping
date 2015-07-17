unit upoolPROJECT;
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

  ublPROJECT,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfPROJECT,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, FMTBcd, Provider, DBClient, DB, SqlExpr;

type
 TpoolPROJECT
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfPROJECT: ThfPROJECT;
  //Accés général
  public
    function Get( _id: integer): TblPROJECT;
  //Gestion de la clé
  protected

    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public

  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _id: Integer;  _Name: String):Integer;

  end;

function poolPROJECT: TpoolPROJECT;

implementation

{$R *.dfm}

var
   FpoolPROJECT: TpoolPROJECT;

function poolPROJECT: TpoolPROJECT;
begin
     Clean_Get( Result, FpoolPROJECT, TpoolPROJECT);
end;

{ TpoolPROJECT }

procedure TpoolPROJECT.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Project';
     Classe_Elements:= TblPROJECT;
     Classe_Filtre:= ThfPROJECT;

     inherited;

     hfPROJECT:= hf as ThfPROJECT;
end;

function TpoolPROJECT.Get( _id: integer): TblPROJECT;
begin
     Get_Interne_from_id( _id, Result);
end;



procedure TpoolPROJECT.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'id'    ).AsInteger:= id;
       ParamByName( 'Name'    ).AsString:= Name;
       end;
end;

function TpoolPROJECT.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         id              = :id             '#13#10+
       '     and Name            = :Name           ';
end;

function TpoolPROJECT.Test( _id: Integer;  _Name: String):Integer;
var                                                 
   bl: TblPROJECT;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.id             := _id           ;
       bl.Name           := _Name         ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolPROJECT, TpoolPROJECT);
finalization
              Clean_destroy( FpoolPROJECT);
end.
