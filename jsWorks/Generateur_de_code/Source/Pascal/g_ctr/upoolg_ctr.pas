unit upoolg_ctr;
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

  ublg_ctr,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfg_ctr,
  SysUtils, Classes, DB, SqlDB;

type
 Tpoolg_ctr
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfg_ctr: Thfg_ctr;
  //Accés général
  public
    function Get( _id: integer): Tblg_ctr;
  //Accés par clé
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _soc: String;  _ets: String;  _code: String;  _libelle: String):Integer;

  end;

function poolg_ctr: Tpoolg_ctr;

implementation

{$R *.dfm}

var
   Fpoolg_ctr: Tpoolg_ctr;

function poolg_ctr: Tpoolg_ctr;
begin
     Clean_Get( Result, Fpoolg_ctr, Tpoolg_ctr);
end;

{ Tpoolg_ctr }

procedure Tpoolg_ctr.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_ctr';
     Classe_Elements:= Tblg_ctr;
     Classe_Filtre:= Thfg_ctr;

     inherited;

     hfg_ctr:= hf as Thfg_ctr;
end;

function Tpoolg_ctr.Get( _id: integer): Tblg_ctr;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure Tpoolg_ctr.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'soc'    ).AsString:= soc;
       ParamByName( 'ets'    ).AsString:= ets;
       ParamByName( 'code'    ).AsString:= code;
       ParamByName( 'libelle'    ).AsString:= libelle;
       end;
end;

function Tpoolg_ctr.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         soc             = :soc            '#13#10+
       '     and ets             = :ets            '#13#10+
       '     and code            = :code           '#13#10+
       '     and libelle         = :libelle        ';
end;

function Tpoolg_ctr.Test( _soc: String;  _ets: String;  _code: String;  _libelle: String):Integer;
var                                                 
   bl: Tblg_ctr;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.soc            := _soc          ;
       bl.ets            := _ets          ;
       bl.code           := _code         ;
       bl.libelle        := _libelle      ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( Fpoolg_ctr, Tpoolg_ctr);
finalization
              Clean_destroy( Fpoolg_ctr);
end.
