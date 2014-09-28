unit upoolG_CTX;
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
    udmDatabase,
    uBatpro_StringList,

    ublG_CTX,

    udmBatpro_DataModule,
    uPool,

    uhfG_CTX,

  SysUtils, Classes,
  FMTBcd, BufDataset, DB, SQLDB;

type

 { TpoolG_CTX }

 TpoolG_CTX
 =
  class( TPool)
    sqlqID_contextes: TSQLQuery;
    sqlqID_contextesid: TLongintField;
    sqlqID_contextetype: TSQLQuery;
    sqlqID_contextetypeid: TLongintField;
    procedure DataModuleCreate(Sender: TObject);
    procedure DataModuleDestroy(Sender: TObject);
  //Filtre
  public
    hfG_CTX: ThfG_CTX;
  //Accés général
  public
    function Get( _id: integer): TblG_CTX;
  //Gestion de la clé
  protected
    contexte: Integer;

    procedure To_SQLQuery_Params( SQLQuery: TSQLQuery); override;
  public
    function Get_by_Cle( _contexte: Integer): TblG_CTX;
  //Gestion de l'insertion
  protected
    function SQL_INSERT: String; override;
  //Indépendance par rapport au SGBD Informix ou MySQL
  protected
    function SQLWHERE_ContraintesChamps: String; override;
  //Chargement d'un lot de contextes
  public
    procedure Charge_Contextes( Contextes: array of Integer;
                                slLoaded: TBatpro_StringList);
  //Chargement des contextes d'un certain type
  public
    procedure Charge_CONTEXTETYPE( _contextetype: String; slLoaded: TBatpro_StringList);
  end;

var
   poolG_CTX: TpoolG_CTX;

implementation

{$R *.dfm}

{ TpoolG_CTX }

procedure TpoolG_CTX.DataModuleCreate(Sender: TObject);
begin
     NomTable:= 'g_ctx';
     Classe_Elements:= TblG_CTX;
     Classe_Filtre:= ThfG_CTX;

     inherited;

     hfG_CTX:= hf as ThfG_CTX;
     Creer_si_non_trouve:= True;
end;

procedure TpoolG_CTX.DataModuleDestroy(Sender: TObject);
begin
     inherited;
end;

function TpoolG_CTX.Get( _id: integer): TblG_CTX;
begin
     Get_Interne_from_id( _id, Result);
end;

function TpoolG_CTX.Get_by_Cle( _contexte: Integer): TblG_CTX;
begin                               
     contexte:=  _contexte;
     sCle:= TblG_CTX.sCle_from_( contexte);
     Get_Interne( Result);
end;

function TpoolG_CTX.SQL_INSERT: String;
begin
     is_Base:= False;
     Result:= 'insert into g_ctx (contexte) values (:contexte)';

end;

procedure TpoolG_CTX.To_SQLQuery_Params(SQLQuery: TSQLQuery);
begin
     inherited;
     with SQLQuery.Params
     do
       begin
       ParamByName( 'contexte'    ).AsInteger:= contexte;
       end;
end;

function TpoolG_CTX.SQLWHERE_ContraintesChamps: String;
begin
     Result
     :=
       'where                        '#13#10+
       '         contexte        = :contexte       ';
end;

procedure TpoolG_CTX.Charge_Contextes( Contextes: array of Integer;
                                       slLoaded: TBatpro_StringList);
var
   I: Integer;
   bl: TblG_CTX;
begin
     slLoaded.Clear;
     for I:= Low( Contextes) to High( Contextes)
     do
       begin
       bl:= Get_by_Cle( Contextes[I]);
       if Assigned( bl)
       then
           slLoaded.AddObject( bl.sCle, bl);
       end;
end;

procedure TpoolG_CTX.Charge_CONTEXTETYPE( _contextetype: String;
                                          slLoaded: TBatpro_StringList);
begin
     sqlqID_contextetype
     .
      Params.ParamByName( 'contextetype').AsString:= _contextetype;
     Load_by_id( sqlqID_contextetype, sqlqID_contextetypeid, slLoaded);
end;

initialization
              Clean_Create( poolG_CTX, TpoolG_CTX);
finalization
              Clean_Destroy( poolG_CTX);
end.


