unit upoolTAG_WORK;
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
  uRequete,

  ublTAG_WORK,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTAG_WORK,
  SysUtils, Classes, DB, SqlDB;

type

 { TpoolTAG_WORK }

 TpoolTAG_WORK
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTAG_WORK: ThfTAG_WORK;
  //Accés général
  public
    function Get( _id: integer): TblTag_Work;
  //Accés par clé
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
     idTag: Integer;
    idWork: Integer;
    function Get_by_Cle( _idTag: Integer;  _idWork: Integer): TblTag_Work;
    function Assure( _idTag: Integer;  _idWork: Integer): TblTag_Work;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _id: Integer;  _idTag: Integer;  _idWork: Integer):Integer;
  //Suppression pour un work et un tag donné
  public
    procedure Supprime( _idTag, _idWork: Integer);
  end;

function poolTAG_WORK: TpoolTAG_WORK;

implementation

{$R *.dfm}

var
   FpoolTAG_WORK: TpoolTAG_WORK;

function poolTAG_WORK: TpoolTAG_WORK;
begin
     Clean_Get( Result, FpoolTAG_WORK, TpoolTAG_WORK);
end;

{ TpoolTAG_WORK }

procedure TpoolTAG_WORK.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Tag_Work';
     Classe_Elements:= TblTag_Work;
     Classe_Filtre:= ThfTAG_WORK;

     inherited;

     hfTAG_WORK:= hf as ThfTAG_WORK;
end;

procedure TpoolTAG_WORK.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'idTag'    ).AsInteger:= idTag;
       ParamByName( 'idWork'    ).AsInteger:= idWork;
       end;
end;

function TpoolTAG_WORK.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
       'where                        '#13#10+
       '         idTag           = :idTag          '#13#10+
       '     and idWork          = :idWork         ';
end;

function TpoolTAG_WORK.Get( _id: integer): TblTag_Work;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTAG_WORK.Get_by_Cle(_idTag: Integer; _idWork: Integer
 ): TblTag_Work;
begin
     idTag:=  _idTag;
     idWork:=  _idWork;
     sCle:= TblTag_Work.sCle_from_( idTag, idWork);
     Get_Interne( Result);
end;

function TpoolTAG_WORK.Assure(_idTag: Integer; _idWork: Integer): TblTag_Work;
begin
     Result:= Get_by_Cle(  _idTag,  _idWork);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);
       Result.idTag          := _idTag        ;
       Result.idWork         := _idWork       ;
     Result.Save_to_database;
end;

function TpoolTAG_WORK.Test( _id: Integer;  _idTag: Integer;  _idWork: Integer):Integer;
var                                                 
   bl: TblTag_Work;
begin                                               
          Nouveau_Base( bl);                        
       bl.id             := _id           ;
       bl.idTag          := _idTag        ;
       bl.idWork         := _idWork       ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;

procedure TpoolTAG_WORK.Supprime( _idTag, _idWork: Integer);
var
   bl: TblTag_Work;
   procedure Supprime_from_bl;
   begin
        Supprimer( bl);
   end;
   procedure Supprime_from_sql;
   begin
        Requete.SQL
        :=
 'delete from '+NomTable+#13#10
+'where                 '#13#10
+'         idTag  = '+IntToStr(_idTag)+''#13#10
+'     and idWork = '+IntToStr(_idWork)+''#13#10;
        Requete.Execute;
   end;
begin
     idTag:=  _idTag;
     idWork:=  _idWork;
     sCle:= TblTag_Work.sCle_from_( idTag, idWork);
     Get_Interne_from_Memory( bl);
     if Assigned( bl)
     then
         Supprime_from_bl
     else
         Supprime_from_sql;
end;


initialization
              Clean_Create ( FpoolTAG_WORK, TpoolTAG_WORK);
finalization
              Clean_destroy( FpoolTAG_WORK);
end.
