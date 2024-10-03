unit uChamps_persistance;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uDataUtilsF,
    uChampDefinitions,
    u_sys_,
    uChamp,
    uChamps,
    ujsDataContexte,
    udmDatabase,
  SysUtils, Classes,
  FMTBcd, DB, SqlExpr;

type

	{ TChamps_persistance }

 TChamps_persistance
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  private
    sqlc: TSQLConnection;
    sqlq: TSQLQuery;
    function not_sqlc_from_( _jsDataConnexion: TjsDataConnexion): Boolean;
  //Méthodes
  private
    function Save_to_database_old( Champs: TChamps; _jsDataConnexion: TjsDataConnexion): Boolean;
  public
    function Save_to_database( Champs: TChamps; _jsDataConnexion: TjsDataConnexion): Boolean;
    function Insert_into_database( Champs: TChamps; _jsDataConnexion: TjsDataConnexion): Boolean;
    function Delete_from_database( Champs: TChamps; _jsDataConnexion: TjsDataConnexion): Boolean;
  end;

var
   Champs_persistance: TChamps_persistance= nil;

implementation

{ TChamps_persistance }

constructor TChamps_persistance.Create;
begin
     sqlq:= TSQLQuery.Create( nil);
     sqlq.SQLConnection:= nil;
     sqlq.Name:= 'Champs_persistance_sqlq';
end;

destructor TChamps_persistance.Destroy;
begin
     sqlq.Close;
     Free_nil( sqlq);
     inherited;
end;

function TChamps_persistance.not_sqlc_from_( _jsDataConnexion: TjsDataConnexion): Boolean;
var
   jsdcs: TjsDataConnexion_SQLQuery;
begin
     Result:= Affecte_( jsdcs, TjsDataConnexion_SQLQuery, _jsDataConnexion);
     if Result then exit;

     sqlc:= jsdcs.sqlc;
end;

function TChamps_persistance.Save_to_database_old( Champs: TChamps;
		                                             _jsDataConnexion: TjsDataConnexion): Boolean;
(*var
   T: TTransactionDesc;*)
begin
     (*T.TransactionID:= 1;
     T.IsolationLevel:= xilREADCOMMITTED;*)

     if not_sqlc_from_( _jsDataConnexion) then exit;
     sqlq.Close;
     sqlq.SQLConnection:= sqlc;

        sqlq.SQL.Text:= Champs.ChampDefinitions.ComposeSQL;
        Champs.To_Params_Update( sqlq.Params);

     (*sqlc.StartTransaction( T); //pour pilote Postgres Devart*)
     try
        Result:= ExecSQLQuery( sqlq);
     finally
            (*sqlc.Commit( T);*)
            end;
end;

function TChamps_persistance.Save_to_database( Champs: TChamps; _jsDataConnexion: TjsDataConnexion): Boolean;
begin
     _jsDataConnexion.Contexte.SQL:= Champs.ChampDefinitions.ComposeSQL;
     Champs.To_Params_Update( _jsDataConnexion.Contexte.Params);
     Result:= _jsDataConnexion.Contexte.ExecSQLQuery;
end;

function TChamps_persistance.Insert_into_database(Champs: TChamps;
		_jsDataConnexion: TjsDataConnexion): Boolean;
var
   (*T: TTransactionDesc;*)
   cID: TChamp;
begin
     (*T.TransactionID:= 1;
     T.IsolationLevel:= xilREADCOMMITTED;*)

     if not_sqlc_from_( _jsDataConnexion) then exit;

     sqlq.Close;
     sqlq.SQLConnection:= sqlc;

     cID:= Champs.cID;
     Result:= Assigned( cID);

     if not Result then exit;

     sqlq.SQL.Text:= Champs.ChampDefinitions.ComposeSQLInsert;
     Champs.To_Params_Insert( sqlq.Params);
     (*sqlc.StartTransaction( T); //pour pilote Postgres Devart*)
     try
        Result:= ExecSQLQuery( sqlq);
     finally
            (*sqlc.Commit( T);*)
            end;
     if not Result then exit;

     sqlq.SQL.Text:= Champs.ChampDefinitions.ComposeSQLChercheSerial;
     (*sqlc.StartTransaction( T); //pour pilote Postgres Devart*)
     try
        Result:= RefreshQuery( sqlq);
     finally
            (*sqlc.Commit( T);*)
            end;
     if Result
     then
         cID.Chaine:= sqlq.FieldByName( 'id').AsString;
end;

function TChamps_persistance.Delete_from_database(Champs: TChamps;
		_jsDataConnexion: TjsDataConnexion): Boolean;
(*var
   T: TTransactionDesc;*)
begin
     (*T.TransactionID:= 1;
     T.IsolationLevel:= xilREADCOMMITTED;*)

     if not_sqlc_from_( _jsDataConnexion) then exit;

     sqlq.Close;
     sqlq.SQLConnection:= sqlc;

     sqlq.SQL.Text:= Champs.ChampDefinitions.ComposeSQLDelete;
     Champs.To_Params_Delete( sqlq.Params);

     (*sqlc.StartTransaction( T); //pour pilote Postgres Devart*)
     try
        Result:= ExecSQLQuery( sqlq);
     finally
            (*sqlc.Commit( T);*)
            end;
end;

initialization
              Champs_persistance:= TChamps_persistance.Create;
finalization
              Free_nil( Champs_persistance);
end.
