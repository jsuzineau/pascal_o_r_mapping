unit upoolg_ctrcir;
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

  ublg_ctrcir,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfg_ctrcir,
  SysUtils, Classes, DB, SqlDB;

type
 Tpoolg_ctrcir
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfg_ctrcir: Thfg_ctrcir;
  //Accés général
  public
    function Get( _id: integer): Tblg_ctrcir;
  //Accés par clé
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _soc: String;  _ets: String;  _type: String;  _circuit: String;  _no_reference: String;  _d1: String;  _d2: String;  _d3: String;  _ok_d1: String;  _ok_d2: String;  _ok_d3: String;  _date_ok1: TDateTime;  _date_ok2: TDateTime;  _date_ok3: TDateTime):Integer;

  end;

function poolg_ctrcir: Tpoolg_ctrcir;

implementation

{$R *.dfm}

var
   Fpoolg_ctrcir: Tpoolg_ctrcir;

function poolg_ctrcir: Tpoolg_ctrcir;
begin
     Clean_Get( Result, Fpoolg_ctrcir, Tpoolg_ctrcir);
end;

{ Tpoolg_ctrcir }

procedure Tpoolg_ctrcir.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_ctrcir';
     Classe_Elements:= Tblg_ctrcir;
     Classe_Filtre:= Thfg_ctrcir;

     inherited;

     hfg_ctrcir:= hf as Thfg_ctrcir;
end;

function Tpoolg_ctrcir.Get( _id: integer): Tblg_ctrcir;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure Tpoolg_ctrcir.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'soc'    ).AsString:= soc;
       ParamByName( 'ets'    ).AsString:= ets;
       ParamByName( 'type'    ).AsString:= type;
       ParamByName( 'circuit'    ).AsString:= circuit;
       ParamByName( 'no_reference'    ).AsString:= no_reference;
       ParamByName( 'd1'    ).AsString:= d1;
       ParamByName( 'd2'    ).AsString:= d2;
       ParamByName( 'd3'    ).AsString:= d3;
       ParamByName( 'ok_d1'    ).AsString:= ok_d1;
       ParamByName( 'ok_d2'    ).AsString:= ok_d2;
       ParamByName( 'ok_d3'    ).AsString:= ok_d3;
       ParamByName( 'date_ok1'    ).AsTDateTime:= date_ok1;
       ParamByName( 'date_ok2'    ).AsTDateTime:= date_ok2;
       ParamByName( 'date_ok3'    ).AsTDateTime:= date_ok3;
       end;
end;

function Tpoolg_ctrcir.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         soc             = :soc            '#13#10+
       '     and ets             = :ets            '#13#10+
       '     and type            = :type           '#13#10+
       '     and circuit         = :circuit        '#13#10+
       '     and no_reference    = :no_reference   '#13#10+
       '     and d1              = :d1             '#13#10+
       '     and d2              = :d2             '#13#10+
       '     and d3              = :d3             '#13#10+
       '     and ok_d1           = :ok_d1          '#13#10+
       '     and ok_d2           = :ok_d2          '#13#10+
       '     and ok_d3           = :ok_d3          '#13#10+
       '     and date_ok1        = :date_ok1       '#13#10+
       '     and date_ok2        = :date_ok2       '#13#10+
       '     and date_ok3        = :date_ok3       ';
end;

function Tpoolg_ctrcir.Test( _soc: String;  _ets: String;  _type: String;  _circuit: String;  _no_reference: String;  _d1: String;  _d2: String;  _d3: String;  _ok_d1: String;  _ok_d2: String;  _ok_d3: String;  _date_ok1: TDateTime;  _date_ok2: TDateTime;  _date_ok3: TDateTime):Integer;
var                                                 
   bl: Tblg_ctrcir;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.soc            := _soc          ;
       bl.ets            := _ets          ;
       bl.type           := _type         ;
       bl.circuit        := _circuit      ;
       bl.no_reference   := _no_reference ;
       bl.d1             := _d1           ;
       bl.d2             := _d2           ;
       bl.d3             := _d3           ;
       bl.ok_d1          := _ok_d1        ;
       bl.ok_d2          := _ok_d2        ;
       bl.ok_d3          := _ok_d3        ;
       bl.date_ok1       := _date_ok1     ;
       bl.date_ok2       := _date_ok2     ;
       bl.date_ok3       := _date_ok3     ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( Fpoolg_ctrcir, Tpoolg_ctrcir);
finalization
              Clean_destroy( Fpoolg_ctrcir);
end.
