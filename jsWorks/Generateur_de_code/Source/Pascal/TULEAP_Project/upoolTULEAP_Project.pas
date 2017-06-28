unit upoolTULEAP_Project;
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

  ublTULEAP_Project,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfTULEAP_Project,
  SysUtils, Classes, DB, SqlDB;

type
 TpoolTULEAP_Project
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfTULEAP_Project: ThfTULEAP_Project;
  //Accés général
  public
    function Get( _id: integer): TblTULEAP_Project;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _uri: String;  _label: String;  _shortname: String;  _resources: String;  _additional_informations: String):Integer;

  end;

function poolTULEAP_Project: TpoolTULEAP_Project;

implementation

{$R *.dfm}

var
   FpoolTULEAP_Project: TpoolTULEAP_Project;

function poolTULEAP_Project: TpoolTULEAP_Project;
begin
     Clean_Get( Result, FpoolTULEAP_Project, TpoolTULEAP_Project);
end;

{ TpoolTULEAP_Project }

procedure TpoolTULEAP_Project.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'TULEAP_Project';
     Classe_Elements:= TblTULEAP_Project;
     Classe_Filtre:= ThfTULEAP_Project;

     inherited;

     hfTULEAP_Project:= hf as ThfTULEAP_Project;
end;

function TpoolTULEAP_Project.Get( _id: integer): TblTULEAP_Project;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure TpoolTULEAP_Project.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'uri'    ).AsString:= uri;
       ParamByName( 'label'    ).AsString:= label;
       ParamByName( 'shortname'    ).AsString:= shortname;
       ParamByName( 'resources'    ).AsString:= resources;
       ParamByName( 'additional_informations'    ).AsString:= additional_informations;
       end;
end;

function TpoolTULEAP_Project.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         uri             = :uri            '#13#10+
       '     and label           = :label          '#13#10+
       '     and shortname       = :shortname      '#13#10+
       '     and resources       = :resources      '#13#10+
       '     and additional_informations = :additional_informations';
end;

function TpoolTULEAP_Project.Test( _uri: String;  _label: String;  _shortname: String;  _resources: String;  _additional_informations: String):Integer;
var                                                 
   bl: TblTULEAP_Project;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.uri            := _uri          ;
       bl.label          := _label        ;
       bl.shortname      := _shortname    ;
       bl.resources      := _resources    ;
       bl.additional_informations:= _additional_informations;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( FpoolTULEAP_Project, TpoolTULEAP_Project);
finalization
              Clean_destroy( FpoolTULEAP_Project);
end.
