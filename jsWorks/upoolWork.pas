unit upoolWork;
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
    uhAggregation,
    uDataUtilsU,

    uBatpro_Element,
    ublWork,

    udmDatabase,
    udmBatpro_DataModule,
    uPool,

    uhfWork,

    uHTTP_Interface,

  SysUtils, Classes,
  DB, sqldb;

type

 { TpoolWork }

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
  //Méthode de création de test
  public
    function Test( _nProject   : Integer;
                   _Beginning  : TDateTime;
                   _End        : TDateTime;
                   _Description: String;
                   _nUser      : Integer
                   ):Integer;
  //Chargement d'un projet
  public
    procedure Charge_Project( _nProject: Integer; slLoaded: TBatpro_StringList = nil);
  //Début d'une nouvelle session
  public
    function Start( _nProject: Integer): TblWork;
  //Gestion communication HTTP avec pages html Angular / JSON
  public
    function Traite_HTTP: Boolean; override;
  //Chargement d'une période
  public
    procedure Charge_Periode( _Debut, _Fin: TDateTime; _slLoaded: TBatpro_StringList = nil);
  end;

function poolWork: TpoolWork;

implementation

{$R *.lfm}

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

function TpoolWork.Test( _nProject   : Integer;
                         _Beginning  : TDateTime;
                         _End        : TDateTime;
                         _Description: String;
                         _nUser      : Integer
                         ):Integer;
var
   bl: TblWork;
begin
     Nouveau_Base( bl);
       bl.End_           := _End          ;
       bl.Description    := _Description  ;
       bl.nUser          := _nUser        ;
       bl.nProject       := _nProject     ;
       bl.Beginning      := _Beginning    ;
     bl.Save_to_database;
     Result:= bl.id;
end;

procedure TpoolWork.Charge_Project( _nProject: Integer; slLoaded: TBatpro_StringList);
var
   SQL: String;
begin
     SQL:= 'select * from '+NomTable+' where nProject = '+IntToStr( _nProject);

     Load( SQL, slLoaded);
end;

function TpoolWork.Start( _nProject: Integer): TblWork;
begin
     Nouveau_Base( Result);
     if Result = nil then exit;

     Result.nProject:= _nProject;
     Result.Beginning:= Now;
     Result.Save_to_database;
end;

function TpoolWork.Traite_HTTP: Boolean;
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
     function http_Start: Boolean;
     var
        sidProject: String;
        idProject: Integer;
        bl: TblWork;
     begin
          sidProject:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidProject, idProject);
          if not Result then exit;

          bl:= Start( idProject);
          Result:= Assigned( bl);
          if not Result then exit;

          HTTP_Interface.Send_JSON( bl.JSON);
     end;
     function http_Stop: Boolean;
     var
        sidWork: String;
        idWork: Integer;
        bl: TblWork;
     begin
          sidWork:= HTTP_Interface.uri;
          Result:= TryStrToInt( sidWork, idWork);
          if not Result then exit;

          bl:= Get( idWork);
          Result:= Assigned( bl);
          if not Result then exit;

          bl.Stop;
          HTTP_Interface.Send_JSON( bl.JSON);
     end;
begin
     Result:=inherited Traite_HTTP;
     if Result then exit;

          if HTTP_Interface.Prefixe('_Start')       then Result:= http_Start
     else if HTTP_Interface.Prefixe('_Stop' )       then Result:= http_Stop
     else if HTTP_Interface.Prefixe('_from_Project')then Result:= http_from_Project
     else                                                Result:= False;
end;

procedure TpoolWork.Charge_Periode( _Debut, _Fin: TDateTime;
                                    _slLoaded: TBatpro_StringList);
var
   SQL: String;
   P: TParams;
   pDebut, pFin: TParam;
begin
     SQL:= 'select * from '+NomTable+' where Beginning >= :Debut and Beginning <= :Fin';
     P:= TParams.Create;
     try
        pDebut:= CreeParam( P, 'Debut');
        pFin  := CreeParam( P, 'Fin'  );
        pDebut.AsDateTime:= Trunc( _Debut);
        pFin  .AsDateTime:= Trunc(_Fin)+1;
        Load( SQL, _slLoaded, nil, P);
     finally
            FreeAndNil( P);
            end;
end;

initialization
              Clean_Create ( FpoolWork, TpoolWork);
finalization
              Clean_destroy( FpoolWork);
end.
