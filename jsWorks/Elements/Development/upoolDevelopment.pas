unit upoolDevelopment;
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

    ublDevelopment,
    ublCategorie,
    ublState,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,


    uhfDevelopment,

    uHTTP_Interface,
  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolDevelopment }

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
  //Méthode de création de test
  public
    function Test( _nCategorie: Integer; _Solution: String; _Origin: String; _nSheetref: Integer; _nDemander: Integer; _isBug: Integer; _Steps: String; _nState: Integer; _nProject: Integer; _Description: String; _nSolutionWork: Integer; _nCreationWork: Integer):Integer;
  //Chargement d'un projet
  public
    procedure Charge_Project( _nProject: Integer; _slLoaded: TBatpro_StringList = nil);
  //Créateurs
  public
    function Point( _nProject: Integer): TblDevelopment;
    function Bug  ( _nProject: Integer): TblDevelopment;
  //Gestion communication HTTP avec pages html Angular / JSON
  public
    function Traite_HTTP: Boolean; override;
  end;

function poolDevelopment: TpoolDevelopment;

implementation

{$R *.lfm}

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

function TpoolDevelopment.Test( _nCategorie: Integer;
                                _Solution: String;
                                _Origin: String;
                                _nSheetref: Integer;
                                _nDemander: Integer;
                                _isBug: Integer;
                                _Steps: String;
                                _nState: Integer;
                                _nProject: Integer;
                                _Description: String;
                                _nSolutionWork: Integer;
                                _nCreationWork: Integer):Integer;
var                                                 
   bl: TblDevelopment;                          
begin                                               
     Nouveau_Base( bl);
       bl.nCategorie     := _nCategorie   ;
       bl.Solution       := _Solution     ;
       bl.Origin         := _Origin       ;
       bl.nSheetref      := _nSheetref    ;
       bl.nDemander      := _nDemander    ;
       bl.isBug          := _isBug        ;
       bl.Steps          := _Steps        ;
       bl.nState         := _nState       ;
       bl.nProject       := _nProject     ;
       bl.Description    := _Description  ;
       bl.nSolutionWork  := _nSolutionWork;
       bl.nCreationWork  := _nCreationWork;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;

procedure TpoolDevelopment.Charge_Project( _nProject: Integer;
                                           _slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where nProject = '+IntToStr( _nProject);

     Load( SQL, _slLoaded);
end;

function TpoolDevelopment.Point( _nProject: Integer): TblDevelopment;
begin
     poolDevelopment.Nouveau_Base( Result);
     if nil = Result then exit;
     Result.nProject:= _nProject;
     Result.nCategorie:= db_Categorie_Demande_developpement;
     Result.nState:= db_State_Non_traite;
     Result.Save_to_database;
end;

function TpoolDevelopment.Bug( _nProject: Integer): TblDevelopment;
begin
     poolDevelopment.Nouveau_Base( Result);
     if nil = Result then exit;
     Result.nProject:= _nProject;
     Result.nCategorie:= db_Categorie_Bug_signale;
     Result.nState:= db_State_Non_traite;
     Result.Save_to_database;
end;

function TpoolDevelopment.Traite_HTTP: Boolean;
     function http_from_Project: Boolean;
     var
        sidProject: String;
        idProject: Integer;
        sl: TBatpro_StringList;
     begin
          sidProject:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidProject, idProject);
          if not Result then exit;

          sl:= TBatpro_StringList.Create;
          Charge_Project( idProject, sl);
          HTTP_Interface.Send_JSON( sl.JSON);
          FreeAndNil( sl);
     end;
     function http_Point: Boolean;
     var
        sidProject: String;
        idProject: Integer;
        bl: TblDevelopment;
     begin
          sidProject:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidProject, idProject);
          if not Result then exit;

          bl:= Point( idProject);
          Result:= Assigned( bl);
          if not Result then exit;

          HTTP_Interface.Send_JSON( bl.JSON);
     end;
     function http_Bug: Boolean;
     var
        sidProject: String;
        idProject: Integer;
        bl: TblDevelopment;
     begin
          sidProject:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidProject, idProject);
          if not Result then exit;

          bl:= Bug( idProject);
          Result:= Assigned( bl);
          if not Result then exit;

          HTTP_Interface.Send_JSON( bl.JSON);
     end;
begin
     Result:=inherited Traite_HTTP;
     if Result then exit;

          if HTTP_Interface.Prefixe('_from_Project')then Result:= http_from_Project
     else if HTTP_Interface.Prefixe('_Point'       )then Result:= http_Point
     else if HTTP_Interface.Prefixe('_Bug'         )then Result:= http_Bug
     else                                                Result:= False;
end;


initialization
              Clean_Create ( FpoolDevelopment, TpoolDevelopment);
finalization
              Clean_destroy( FpoolDevelopment);
end.
