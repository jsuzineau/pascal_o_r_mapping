unit upoolWork;
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

  ublWork,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfWork,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolWork
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfWork: ThfWork;
  //Accés général
  public
    function Get( _id: integer): TblWork;
  //Accés par clé
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _nProject: Integer;  _Beginning: TDateTime;  _End: TDateTime;  _Description: String;  _nUser: Integer):Integer;

  end;

function poolWork: TpoolWork;

implementation

{$R *.dfm}

var
   FpoolWork: TpoolWork;

function poolWork: TpoolWork;
begin
     Clean_Get( Result, FpoolWork, TpoolWork);
end;

{ TpoolWork }

procedure TpoolWork.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Work';
     Classe_Elements:= TblWork;
     Classe_Filtre:= ThfWork;

     inherited;

     hfWork:= hf as ThfWork;
end;

function TpoolWork.Get( _id: integer): TblWork;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure TpoolWork.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'nProject'    ).AsInteger:= nProject;
       ParamByName( 'Beginning'    ).AsTDateTime:= Beginning;
       ParamByName( 'End'    ).AsTDateTime:= End;
       ParamByName( 'Description'    ).AsString:= Description;
       ParamByName( 'nUser'    ).AsInteger:= nUser;
       end;
end;

function TpoolWork.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         nProject        = :nProject       '#13#10+
       '     and Beginning       = :Beginning      '#13#10+
       '     and End             = :End            '#13#10+
       '     and Description     = :Description    '#13#10+
       '     and nUser           = :nUser          ';
end;

function TpoolWork.Test( _nProject: Integer;  _Beginning: TDateTime;  _End: TDateTime;  _Description: String;  _nUser: Integer):Integer;
var                                                 
   bl: TblWork;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.nProject       := _nProject     ;
       bl.Beginning      := _Beginning    ;
       bl.End            := _End          ;
       bl.Description    := _Description  ;
       bl.nUser          := _nUser        ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolWork, TpoolWork);
finalization
              Clean_destroy( FpoolWork);
end.
