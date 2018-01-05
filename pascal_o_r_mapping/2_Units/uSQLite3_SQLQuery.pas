unit uSQLite3_SQLQuery;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2018 Jean SUZINEAU - MARS42                                       |
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
    uLog,
    uBatpro_StringList,
    u_sys_,
    uuStrings,
    uRegistry,
    uEXE_INI,
    ujsDataContexte,
    uSGBD,
    ufAccueil_Erreur,
  db, sqlite3conn_pour_test, SQLDB, sqlite3, FmtBCD,dateutils,
  SysUtils, Classes;

type

 { TSQLite3_SQLQuery }
 TSQLite3_SQLQuery
 =
  class( TjsDataConnexion_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _SGBD: TSGBD); override;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    Initialized: Boolean;
    procedure Lit  (NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
    procedure Ecrit(NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
  public
    procedure Assure_initialisation;
    procedure Ecrire; override;
  //Connexion
  protected
    function Cree_SQLConnection: TSQLConnection; override;
  public
    sqlcSQLite3: TSQLite3Connection;
  //DataBase
  public
    DataBase: String;
  //Méthodes
  public
    procedure Prepare; override;
  //Last_Insert_id
  public
    function Last_Insert_id( _NomTable: String): Integer; override;
  end;

const
     inis_sqlite3  = 'SQLite3';

implementation

function Crypto(S: String): String; // avec un XOR, cryptage et décryptage
var                                 // se font de la même façon
   I: Integer;
begin
     Result:= S;
     for I:= 1 to Length( Result)
     do
       Result[I]:= Chr( Ord(Result[I]) XOR $31);
end;

{ TSQLite3_SQLQuery }

constructor TSQLite3_SQLQuery.Create(_SGBD: TSGBD);
begin
     inherited Create( _SGBD);

     HostName:= 'local filesystem';
     DataBase := sys_Vide;
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

destructor TSQLite3_SQLQuery.Destroy;
begin
     Contexte:= nil;
     FreeAndNil( jsdc);
     sqlcSQLite3:= nil;
     inherited;
end;

procedure TSQLite3_SQLQuery.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_Database , DataBase);
     sqlc.DatabaseName:= DataBase;
     Prepare;
     Initialized:= True;
end;

procedure TSQLite3_SQLQuery.Ecrire;
begin
     inherited Ecrire;
     Ecrit( regv_Database , DataBase );
end;

procedure TSQLite3_SQLQuery.Lit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     ValeurBrute:= EXE_INI.ReadString( inis_sqlite3, NomValeur, sys_Vide);
     if _Mot_de_passe
     then
         Valeur:= Crypto( ValeurBrute)
     else
         Valeur:= ValeurBrute;
end;

procedure TSQLite3_SQLQuery.Ecrit( NomValeur: String; var Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     if NomValeur = ''
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'   TSQLite3.Ecrit: NomValeur est vide');
     if _Mot_de_passe
     then
         ValeurBrute:= Crypto( Valeur)
     else
         ValeurBrute:= Valeur;

     EXE_INI.WriteString( inis_sqlite3, NomValeur, ValeurBrute);
end;

function TSQLite3_SQLQuery.Cree_SQLConnection: TSQLConnection;
begin
     sqlcSQLite3:= TSQLite3Connection.Create( nil);
     Result:= sqlcSQLite3;
     if Assigned( Result)
     then
         Result.CharSet:= 'latin1';
         //Result.CharSet:= 'utf8';
         //Result.CharSet:= 'cp850';
end;

procedure TSQLite3_SQLQuery.Prepare;
var
   Default_Database: String;
begin
     inherited Prepare;

     Default_Database:= GetCurrentDir+DirectorySeparator+'SQLite3_database.db';

     Database_indefinie:= (DataBase = sys_Vide) or (DataBase='---');
     if Database_indefinie
     then
         DataBase:= Default_Database
     else
         Database_indefinie:= DataBase = Default_Database;

     Ouvrable
     :=
            (Database  <> sys_Vide)
        and FileExists(Database);

     sqlcSQLite3.DatabaseName:= Database;

end;

function TSQLite3_SQLQuery.Last_Insert_id( _NomTable: String): Integer;
var
   SQL: String;
begin
     SQL:= 'select last_insert_rowid()';
     Contexte.Integer_from( SQL, Result);
end;

end.
