unit upoolTAG_DEVELOPMENT;
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

  ublTAG_DEVELOPMENT,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTAG_DEVELOPMENT,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolTAG_DEVELOPMENT }

 TpoolTAG_DEVELOPMENT
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTAG_DEVELOPMENT: ThfTAG_DEVELOPMENT;
  //Accés général
  public
    function Get( _id: integer): TblTAG_DEVELOPMENT;
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

function poolTAG_DEVELOPMENT: TpoolTAG_DEVELOPMENT;

implementation

{$R *.dfm}

var
   FpoolTAG_DEVELOPMENT: TpoolTAG_DEVELOPMENT;

function poolTAG_DEVELOPMENT: TpoolTAG_DEVELOPMENT;
begin
     Clean_Get( Result, FpoolTAG_DEVELOPMENT, TpoolTAG_DEVELOPMENT);
end;

{ TpoolTAG_DEVELOPMENT }

procedure TpoolTAG_DEVELOPMENT.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Tag_Development';
     Classe_Elements:= TblTAG_DEVELOPMENT;
     Classe_Filtre:= ThfTAG_DEVELOPMENT;

     inherited;

     hfTAG_DEVELOPMENT:= hf as ThfTAG_DEVELOPMENT;
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

function TpoolTAG_DEVELOPMENT.Get( _id: integer): TblTAG_DEVELOPMENT;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTAG_DEVELOPMENT.Test( _id: Integer;  _idTag: Integer;  _idDevelopment: Integer):Integer;
var                                                 
   bl: TblTAG_DEVELOPMENT;                          
begin                                               
     Nouveau_Base( bl);
     bl.id             := _id           ;
     bl.idTag          := _idTag        ;
     bl.idDevelopment  := _idDevelopment;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 

function TpoolTAG_DEVELOPMENT.Get_by_Cle( _idTag: Integer; _idDevelopment: Integer): TblTag_Development;
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
              Clean_Create ( FpoolTAG_DEVELOPMENT, TpoolTAG_DEVELOPMENT);
finalization
              Clean_destroy( FpoolTAG_DEVELOPMENT);
end.
