unit upoolTag_Development;
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

  ublTag_Development,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTag_Development,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolTag_Development }

 TpoolTag_Development
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);  override;
  //Filtre
  public
    hfTag_Development: ThfTag_Development;
  //Accés général
  public
    function Get( _id: integer): TblTag_Development;
  //Accés par clé
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
    idTag: Integer;
    idDevelopment: Integer;
    function Get_by_Cle( _idTag: Integer; _idDevelopment: Integer): TblTag_Development;
    function Assure( _idTag: Integer;  _idDevelopment: Integer): TblTag_Development;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _id: Integer;  _idTag: Integer;  _idDevelopment: Integer):Integer;

  end;

function poolTag_Development: TpoolTag_Development;

implementation



var
   FpoolTag_Development: TpoolTag_Development;

function poolTag_Development: TpoolTag_Development;
begin
     TPool.class_Get( Result, FpoolTag_Development, TpoolTag_Development);
end;

{ TpoolTag_Development }

procedure TpoolTag_Development.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Tag_Development';
     Classe_Elements:= TblTag_Development;
     Classe_Filtre:= ThfTag_Development;

     inherited;

     hfTag_Development:= hf as ThfTag_Development;
end;

procedure TpoolTag_Development.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'idTag'    ).AsInteger:= idTag;
       ParamByName( 'idDevelopment'    ).AsInteger:= idDevelopment;
       end;
end;

function TpoolTag_Development.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
       'where                        '#13#10+
       '         idTag           = :idTag          '#13#10+
       '     and idDevelopment   = :idDevelopment  ';
end;

function TpoolTag_Development.Get( _id: integer): TblTag_Development;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTag_Development.Test( _id: Integer;  _idTag: Integer;  _idDevelopment: Integer):Integer;
var                                                 
   bl: TblTag_Development;                          
begin                                               
     Nouveau_Base( bl);
     bl.id             := _id           ;
     bl.idTag          := _idTag        ;
     bl.idDevelopment  := _idDevelopment;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 

function TpoolTag_Development.Get_by_Cle( _idTag: Integer; _idDevelopment: Integer): TblTag_Development;
begin
     idTag:=  _idTag;
     idDevelopment:=  _idDevelopment;
     sCle:= TblTag_Development.sCle_from_( idTag, idDevelopment);
     Get_Interne( Result);
end;

function TpoolTag_Development.Assure( _idTag: Integer;  _idDevelopment: Integer): TblTag_Development;
begin
     Result:= Get_by_Cle(  _idTag,  _idDevelopment);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);
       Result.idTag          := _idTag        ;
       Result.idDevelopment  := _idDevelopment;
     Result.Save_to_database;
end;

initialization
finalization
              TPool.class_Destroy( FpoolTag_Development);
end.
