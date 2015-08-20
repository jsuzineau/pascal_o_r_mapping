unit upoolTag_Work;
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

  ublTag_Work,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTag_Work,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolTag_Work
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTag_Work: ThfTag_Work;
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
    function Test( _idTag: Integer;  _idWork: Integer):Integer;

  end;

function poolTag_Work: TpoolTag_Work;

implementation

{$R *.dfm}

var
   FpoolTag_Work: TpoolTag_Work;

function poolTag_Work: TpoolTag_Work;
begin
     Clean_Get( Result, FpoolTag_Work, TpoolTag_Work);
end;

{ TpoolTag_Work }

procedure TpoolTag_Work.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Tag_Work';
     Classe_Elements:= TblTag_Work;
     Classe_Filtre:= ThfTag_Work;

     inherited;

     hfTag_Work:= hf as ThfTag_Work;
end;

function TpoolTag_Work.Get( _id: integer): TblTag_Work;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolTag_Work.Get_by_Cle( _idTag: Integer;  _idWork: Integer): TblTag_Work;
begin                               
     idTag:=  _idTag;
     idWork:=  _idWork;
     sCle:= TblTag_Work.sCle_from_( idTag, idWork);
     Get_Interne( Result);       
end;                             


function TpoolTag_Work.Assure( _idTag: Integer;  _idWork: Integer): TblTag_Work;
begin                               
     Result:= Get_by_Cle(  _idTag,  _idWork);
     if Assigned( Result) then exit;

     Nouveau_Base( Result);                        
       Result.idTag          := _idTag        ;
       Result.idWork         := _idWork       ;
     Result.Save_to_database;
end;


procedure TpoolTag_Work.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'idTag'    ).AsInteger:= idTag;
       ParamByName( 'idWork'    ).AsInteger:= idWork;
       end;
end;

function TpoolTag_Work.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         idTag           = :idTag          '#13#10+
       '     and idWork          = :idWork         ';
end;

function TpoolTag_Work.Test( _idTag: Integer;  _idWork: Integer):Integer;
var                                                 
   bl: TblTag_Work;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.idTag          := _idTag        ;
       bl.idWork         := _idWork       ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolTag_Work, TpoolTag_Work);
finalization
              Clean_destroy( FpoolTag_Work);
end.
