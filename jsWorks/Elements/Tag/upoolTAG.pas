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

 { TpoolTAG }

 TpoolTAG
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTAG: ThfTAG;
  //Accés général
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
    idType: Integer;
    Name: String;
    function Get( _id: integer): TblTag;
    function Get_by_Cle( _idType: Integer;  _Name: String): TblTag;
    function Assure( _idType: Integer; _Name: String): TblTag;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _id: Integer;  _Name: String;  _idType: Integer):Integer;
  //Chargement des tags d'un Work
  public
    procedure Charge_Work( _idWork: Integer; _slLoaded: TBatpro_StringList);
  //Chargement des tags contenus dans la description d'un Work
  public
    procedure Charge_Work_from_Description( _Description: String; _slLoaded, _haTag_sl: TBatpro_StringList);
  //Chargement des tags d'un Development
  public
    procedure Charge_Development( _idDevelopment: Integer; _slLoaded: TBatpro_StringList);
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
     Classe_Elements:= TblTag;
     Classe_Filtre:= ThfTAG;

     inherited;

     hfTAG:= hf as ThfTAG;
     ChampTri['idType']:= +1;
     ChampTri['Name'  ]:= +1;
end;

function TpoolTAG.Get( _id: integer): TblTag;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTAG.Get_by_Cle( _idType: Integer;  _Name: String): TblTag;
begin
     idType:=  _idType;
     Name:=  _Name;
     sCle:= TblTag.sCle_from_( idType, Name);
     Get_Interne( Result);
end;

function TpoolTAG.Assure(_idType: Integer; _Name: String): TblTag;
begin
     Result:= Get_by_Cle(  _idType,  _Name);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);
       Result.idType         := _idType       ;
       Result.Name           := _Name         ;
     Result.Save_to_database;
end;

procedure TpoolTAG.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'idType'    ).AsInteger:= idType;
       ParamByName( 'Name'    ).AsString:= Name;
       end;
end;

function TpoolTAG.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
       'where                        '#13#10+
       '         idType          = :idType         '#13#10+
       '     and Name            = :Name           ';
end;

function TpoolTAG.Test( _id: Integer;  _Name: String;  _idType: Integer):Integer;
var                                                 
   bl: TblTag;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.id             := _id           ;
       bl.Name           := _Name         ;
       bl.idType         := _idType       ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;

procedure TpoolTAG.Charge_Work( _idWork: Integer; _slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL
     :=
 'select                                          '#13#10
+'      Tag.*                                     '#13#10
+'from                                            '#13#10
+'    Tag                                         '#13#10
+'right join Tag_Work                             '#13#10
+'on                                              '#13#10
+'      (Tag_Work.idTag  = Tag.id               ) '#13#10
+'  and (Tag_Work.idWork = '+IntToStr(_idWork)+') '#13#10
+'where                                           '#13#10
+'         Tag.id is not null                     '#13#10
+'     and Tag_Work.id is not null                '#13#10;
     Load( SQL, _slLoaded);
end;

procedure TpoolTAG.Charge_Work_from_Description( _Description: String;
                                                 _slLoaded, _haTag_sl: TBatpro_StringList);
var
   I: TIterateur;
   bl: TblTag;
begin
     _slLoaded.Clear;
     ToutCharger;
     I:= slT.Iterateur_interne;
     while I.Continuer
     do
       begin
       if I.not_Suivant_interne( bl) then continue;

       if 0 = Pos( bl.Name, _Description) then continue;

       if -1 <> _haTag_sl.IndexOfObject( bl) then continue;

       _slLoaded.AddObject( bl.sCle, bl);
       end;
end;

procedure TpoolTAG.Charge_Development( _idDevelopment: Integer;
                                       _slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL
     :=
 'select                                          '#13#10
+'      Tag.*                                     '#13#10
+'from                                            '#13#10
+'    Tag                                         '#13#10
+'right join Tag_Development                      '#13#10
+'on                                              '#13#10
+'      (Tag_Development.idTag  = Tag.id        ) '#13#10
+'  and (Tag_Development.idDevelopment = '+IntToStr(_idDevelopment)+') '#13#10
+'where                                           '#13#10
+'         Tag.id is not null                     '#13#10
+'     and Tag_Development.id is not null         '#13#10;
     Load( SQL, _slLoaded);
end;


initialization
              Clean_Create ( FpoolTAG, TpoolTAG);
finalization
              Clean_destroy( FpoolTAG);
end.
