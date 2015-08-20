unit upoolg_becpctx;
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

  ublg_becpctx,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfg_becpctx,
  SysUtils, Classes, DB, SqlDB;

type
 Tpoolg_becpctx
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfg_becpctx: Thfg_becpctx;
  //Accés général
  public
    function Get( _id: integer): Tblg_becpctx;
  //Accés par clé
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _nomclasse: String;  _contexte: Integer;  _logfont: String;  _stringlist: String):Integer;

  end;

function poolg_becpctx: Tpoolg_becpctx;

implementation

{$R *.dfm}

var
   Fpoolg_becpctx: Tpoolg_becpctx;

function poolg_becpctx: Tpoolg_becpctx;
begin
     Clean_Get( Result, Fpoolg_becpctx, Tpoolg_becpctx);
end;

{ Tpoolg_becpctx }

procedure Tpoolg_becpctx.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_becpctx';
     Classe_Elements:= Tblg_becpctx;
     Classe_Filtre:= Thfg_becpctx;

     inherited;

     hfg_becpctx:= hf as Thfg_becpctx;
end;

function Tpoolg_becpctx.Get( _id: integer): Tblg_becpctx;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure Tpoolg_becpctx.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'nomclasse'    ).AsString:= nomclasse;
       ParamByName( 'contexte'    ).AsInteger:= contexte;
       ParamByName( 'logfont'    ).AsString:= logfont;
       ParamByName( 'stringlist'    ).AsString:= stringlist;
       end;
end;

function Tpoolg_becpctx.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         nomclasse       = :nomclasse      '#13#10+
       '     and contexte        = :contexte       '#13#10+
       '     and logfont         = :logfont        '#13#10+
       '     and stringlist      = :stringlist     ';
end;

function Tpoolg_becpctx.Test( _nomclasse: String;  _contexte: Integer;  _logfont: String;  _stringlist: String):Integer;
var                                                 
   bl: Tblg_becpctx;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.nomclasse      := _nomclasse    ;
       bl.contexte       := _contexte     ;
       bl.logfont        := _logfont      ;
       bl.stringlist     := _stringlist   ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( Fpoolg_becpctx, Tpoolg_becpctx);
finalization
              Clean_destroy( Fpoolg_becpctx);
end.
