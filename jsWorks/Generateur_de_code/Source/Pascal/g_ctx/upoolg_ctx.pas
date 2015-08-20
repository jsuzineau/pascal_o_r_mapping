unit upoolg_ctx;
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

  ublg_ctx,

  udmDatabase,
  udmBatpro_DataModule,
  uPool,
  

  uhfg_ctx,
  SysUtils, Classes, DB, SqlDB;

type
 Tpoolg_ctx
 =
  class( TPool)
    procedure DataModuleCreate(Sender: TObject);
  //Filtre
  public
    hfg_ctx: Thfg_ctx;
  //Accés général
  public
    function Get( _id: integer): Tblg_ctx;
  //Accés par clé
  protected
    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
  
  
  
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Méthode de création de test
  public
    function Test( _contexte: Integer;  _contextetype: String;  _libelle: String):Integer;

  end;

function poolg_ctx: Tpoolg_ctx;

implementation

{$R *.dfm}

var
   Fpoolg_ctx: Tpoolg_ctx;

function poolg_ctx: Tpoolg_ctx;
begin
     Clean_Get( Result, Fpoolg_ctx, Tpoolg_ctx);
end;

{ Tpoolg_ctx }

procedure Tpoolg_ctx.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_ctx';
     Classe_Elements:= Tblg_ctx;
     Classe_Filtre:= Thfg_ctx;

     inherited;

     hfg_ctx:= hf as Thfg_ctx;
end;

function Tpoolg_ctx.Get( _id: integer): Tblg_ctx;
begin
     Get_Interne_from_id( _id, Result);
end;





procedure Tpoolg_ctx.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'contexte'    ).AsInteger:= contexte;
       ParamByName( 'contextetype'    ).AsString:= contextetype;
       ParamByName( 'libelle'    ).AsString:= libelle;
       end;
end;

function Tpoolg_ctx.SQLWHERE_ContraintesChamps: String;
begin
     Result                                    
     :=                                        
       'where                        '#13#10+
       '         contexte        = :contexte       '#13#10+
       '     and contextetype    = :contextetype   '#13#10+
       '     and libelle         = :libelle        ';
end;

function Tpoolg_ctx.Test( _contexte: Integer;  _contextetype: String;  _libelle: String):Integer;
var                                                 
   bl: Tblg_ctx;                          
begin                                               
          Nouveau_Base( bl);                        
       bl.contexte       := _contexte     ;
       bl.contextetype   := _contextetype ;
       bl.libelle        := _libelle      ;
     bl.Save_to_database;                            
     Result:= bl.id;                                 
end;                                                 


initialization
              Clean_Create ( Fpoolg_ctx, Tpoolg_ctx);
finalization
              Clean_destroy( Fpoolg_ctx);
end.
