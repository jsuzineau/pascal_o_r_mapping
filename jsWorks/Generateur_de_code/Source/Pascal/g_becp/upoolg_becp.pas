unit upoolg_becp;
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

  ublg_becp,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfg_becp,
  SysUtils, Classes, DB, SqlDB;

type
 Tpoolg_becp
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfg_becp: Thfg_becp;
  //Accés général
  public
    function Get( _id: integer): Tblg_becp;
  //Accés par clé
  protected
    procedure To_Params( _Params: TParams); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _nomclasse: String;  _libelle: String):Integer;

  end;

function poolg_becp: Tpoolg_becp;

implementation

{$R *.dfm}

var
   Fpoolg_becp: Tpoolg_becp;

function poolg_becp: Tpoolg_becp;
begin
     Clean_Get( Result, Fpoolg_becp, Tpoolg_becp);
end;

{ Tpoolg_becp }

procedure Tpoolg_becp.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_becp';
     Classe_Elements:= Tblg_becp;
     Classe_Filtre:= Thfg_becp;

     inherited;

     hfg_becp:= hf as Thfg_becp;
end;

function Tpoolg_becp.Get( _id: integer): Tblg_becp;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure Tpoolg_becp.To_Params( _Params: TParams);
begin
     inherited;
     with _Params
     do
       begin
       ParamByName( 'nomclasse'    ).AsString:= nomclasse;
       ParamByName( 'libelle'    ).AsString:= libelle;
       end;
end;

function Tpoolg_becp.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         nomclasse       = :nomclasse      '#13#10+
       '     and libelle         = :libelle        ';
end;

function Tpoolg_becp.Test( _nomclasse: String;  _libelle: String):Integer;
var                                                 
   bl: Tblg_becp;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.nomclasse      := _nomclasse    ;
       bl.libelle        := _libelle      ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( Fpoolg_becp, Tpoolg_becp);
finalization
              Clean_destroy( Fpoolg_becp);
end.
