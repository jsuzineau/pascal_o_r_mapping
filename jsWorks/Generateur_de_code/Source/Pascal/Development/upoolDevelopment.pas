unit upoolDevelopment;
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

  ublDevelopment,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfDevelopment,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolDevelopment
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfDevelopment: ThfDevelopment;
  //Accés général
  public
    function Get( _id: integer): TblDevelopment;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _nProject: Integer;  _nState: Integer;  _nCreationWork: Integer;  _nSolutionWork: Integer;  _Description: String;  _Steps: String;  _Origin: String;  _Solution: String;  _nCategorie: Integer;  _isBug: Integer;  _nDemander: Integer;  _nSheetRef: Integer):Integer;

  end;

function poolDevelopment: TpoolDevelopment;

implementation

{$R *.dfm}

var
   FpoolDevelopment: TpoolDevelopment;

function poolDevelopment: TpoolDevelopment;
begin
     Clean_Get( Result, FpoolDevelopment, TpoolDevelopment);
end;

{ TpoolDevelopment }

procedure TpoolDevelopment.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'Development';
     Classe_Elements:= TblDevelopment;
     Classe_Filtre:= ThfDevelopment;

     inherited;

     hfDevelopment:= hf as ThfDevelopment;
end;

function TpoolDevelopment.Get( _id: integer): TblDevelopment;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure TpoolDevelopment.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'nProject'    ).AsInteger:= nProject;
       ParamByName( 'nState'    ).AsInteger:= nState;
       ParamByName( 'nCreationWork'    ).AsInteger:= nCreationWork;
       ParamByName( 'nSolutionWork'    ).AsInteger:= nSolutionWork;
       ParamByName( 'Description'    ).AsString:= Description;
       ParamByName( 'Steps'    ).AsString:= Steps;
       ParamByName( 'Origin'    ).AsString:= Origin;
       ParamByName( 'Solution'    ).AsString:= Solution;
       ParamByName( 'nCategorie'    ).AsInteger:= nCategorie;
       ParamByName( 'isBug'    ).AsInteger:= isBug;
       ParamByName( 'nDemander'    ).AsInteger:= nDemander;
       ParamByName( 'nSheetRef'    ).AsInteger:= nSheetRef;
       end;
end;

function TpoolDevelopment.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         nProject        = :nProject       '#13#10+
       '     and nState          = :nState         '#13#10+
       '     and nCreationWork   = :nCreationWork  '#13#10+
       '     and nSolutionWork   = :nSolutionWork  '#13#10+
       '     and Description     = :Description    '#13#10+
       '     and Steps           = :Steps          '#13#10+
       '     and Origin          = :Origin         '#13#10+
       '     and Solution        = :Solution       '#13#10+
       '     and nCategorie      = :nCategorie     '#13#10+
       '     and isBug           = :isBug          '#13#10+
       '     and nDemander       = :nDemander      '#13#10+
       '     and nSheetRef       = :nSheetRef      ';
end;

function TpoolDevelopment.Test( _nProject: Integer;  _nState: Integer;  _nCreationWork: Integer;  _nSolutionWork: Integer;  _Description: String;  _Steps: String;  _Origin: String;  _Solution: String;  _nCategorie: Integer;  _isBug: Integer;  _nDemander: Integer;  _nSheetRef: Integer):Integer;
var                                                 
   bl: TblDevelopment;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.nProject       := _nProject     ;
       bl.nState         := _nState       ;
       bl.nCreationWork  := _nCreationWork;
       bl.nSolutionWork  := _nSolutionWork;
       bl.Description    := _Description  ;
       bl.Steps          := _Steps        ;
       bl.Origin         := _Origin       ;
       bl.Solution       := _Solution     ;
       bl.nCategorie     := _nCategorie   ;
       bl.isBug          := _isBug        ;
       bl.nDemander      := _nDemander    ;
       bl.nSheetRef      := _nSheetRef    ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolDevelopment, TpoolDevelopment);
finalization
              Clean_destroy( FpoolDevelopment);
end.
