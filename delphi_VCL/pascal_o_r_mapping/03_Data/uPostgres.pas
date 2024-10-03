unit uPostgres;
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
    u_sys_,
    uRegistry,
    uEXE_INI,
    uBatpro_StringList,
    ujsDataContexte,
    uSGBD,
    ufAccueil_Erreur,
    {$IFDEF FPC}
      pqconnection,
      SQLDB,
    {$ELSE}
      SQLExpr,
    {$ENDIF}
  SysUtils, Classes;

type


{ TPostgres }

 TPostgres
 =
  class( TjsDataConnexion_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _SGBD: TSGBD); override;
    destructor Destroy; override;
  //Persistance dans la base de registre
  private
    Initialized: Boolean;
    procedure Lit  ( NomValeur: String; out Valeur: String; _Mot_de_passe: Boolean= False);
    procedure Ecrit( NomValeur: String;     Valeur: String; _Mot_de_passe: Boolean= False);
  public
    procedure Assure_initialisation;
    procedure Ecrire; override;
  //Connexion
  protected
    function Cree_SQLConnection: TSQLConnection; override;
  public
    function sqlc_p: TSQLConnection;
  //Contexte
  protected
    function Classe_Contexte: TjsDataContexte_class; override;
  public
    jsdc_p: TjsDataContexte_SQLQuery;
  //Méthodes
  public
    procedure Prepare; override;
    procedure Ouvre_db; override;
    procedure Ferme_db; override;
    procedure Keep_Connection; override;
    procedure Do_not_Keep_Connection; override;

    procedure Fill_with_databases( _s: TStrings); override;
  //Schema
  public
    SchemaName: String;
    procedure Set_Schema( _SchemaName: String= '');
    procedure GetSchemaNames( _List:TStrings);
  //Last_Insert_id
  public
    function Last_Insert_id( _NomTable: String): Integer; override;
  //Liste des tables
  public
    procedure GetTableNames( _List:TStrings); override;
  end;

 { TjsDataContexte_Postgres }

 TjsDataContexte_Postgres
 =
  class( TjsDataContexte_SQLQuery)
  //Gestion du cycle de vie
  public
    constructor Create( _Name: String); override;
    destructor Destroy; override;
  //Connection
  private
    jsDataConnexion_Postgres: TPostgres;
  protected
    procedure SetConnection(_Value: TjsDataConnexion); override;
  //Liste des tables
  public
    procedure GetTableNames( _List:TStrings); override;
  //Liste des views
  public
    procedure AddViewNames( _List:TStrings);
  //Liste des bases de données
  public
    procedure Fill_with_databases( _s: TStrings); override;
  //Liste des schémas
  public
    procedure GetSchemaNames( _List:TStrings);
  end;

const
     inis_Postgres= 'Postgres';

function Crypto( S: String): String;

implementation

function Crypto( S: String): String; // avec un XOR, cryptage et décryptage
var                                  // se font de la même façon
   I: Integer;
begin
     Result:= S;
     for I:= 1 to Length( Result)
     do
       Result[I]:= Chr( Ord(Result[I]) XOR $31);
end;

{ TPostgres }

constructor TPostgres.Create( _SGBD: TSGBD);
begin
     inherited Create( _SGBD);
     Initialized:= False;

     {$ifndef android}
     Assure_initialisation;
     {$endif}
end;

destructor TPostgres.Destroy;
begin
     inherited;
end;

procedure TPostgres.Assure_initialisation;
begin
     if Initialized then exit;
     Lit( regv_HostName  , FHostName );HostName:= FHostName;
     Lit( regv_User_Name , User_Name);
     Lit( regv_PassWord  , PassWord , True);
     Lit( regv_Database  , DataBase );
     Lit( regv_SchemaName, SchemaName );
     if '' = SchemaName
     then
         SchemaName:= 'public';
     Initialized:= True;
end;

procedure TPostgres.Ecrire;
begin
     inherited Ecrire;

     Ecrit( regv_HostName  , HostName );
     Ecrit( regv_User_Name , User_Name);
     Ecrit( regv_PassWord  , PassWord , True);
     Ecrit( regv_Database  , DataBase  );
     Ecrit( regv_SchemaName, SchemaName);
end;

procedure TPostgres.Lit( NomValeur: String; out Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     ValeurBrute:= EXE_INI.ReadString( inis_Postgres, NomValeur, sys_Vide);
     if _Mot_de_passe
     then
         Valeur:= Crypto( ValeurBrute)
     else
         Valeur:= ValeurBrute;
end;

procedure TPostgres.Ecrit(NomValeur: String;     Valeur: String; _Mot_de_passe: Boolean= False);
var
   ValeurBrute: String;
begin
     if NomValeur = ''
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'   TPostgres.Ecrit: NomValeur est vide');
     if _Mot_de_passe
     then
         ValeurBrute:= Crypto( Valeur)
     else
         ValeurBrute:= Valeur;

     EXE_INI.WriteString( inis_Postgres, NomValeur, ValeurBrute);
end;

function TPostgres.Cree_SQLConnection: TSQLConnection;
begin
     Result:= TSQLConnection.Create( nil);
     Result.Params.Text
     :=
       'à implémenter en delphi 10'
       ;
end;

function TPostgres.sqlc_p: TSQLConnection;
begin
     Result:= sqlc;
end;

function TPostgres.Classe_Contexte: TjsDataContexte_class;
begin
     Result:= TjsDataContexte_Postgres;
end;

procedure TPostgres.Prepare;
begin
     inherited Prepare;
     Database_indefinie:= DataBase = sys_Vide;
     if Database_indefinie
     then
         DataBase:= 'postgres'
     else
         Database_indefinie:= DataBase = 'postgres';

     Ouvrable
     :=
           (HostName  <> sys_Vide)
       and (User_Name <> sys_Vide)
       and (Database  <> sys_Vide);

     WriteParam( 'HostName'  , HostName  );
     WriteParam( 'User_Name' , User_Name );
     WriteParam( 'Password'  , Password  );
     WriteParam( 'DataBase'  , Database  );
     WriteParam( 'SchemaName', SchemaName);
end;

procedure TPostgres.Ouvre_db;
begin
     inherited Ouvre_db;
     Set_Schema;
end;

procedure TPostgres.Ferme_db;
begin
     inherited Ferme_db;
end;

procedure TPostgres.Keep_Connection;
begin
     inherited Keep_Connection;
end;

procedure TPostgres.Do_not_Keep_Connection;
begin
     inherited Do_not_Keep_Connection;
end;

procedure TPostgres.Fill_with_databases(_s: TStrings);
begin
     Contexte.Fill_with_databases(_s);
end;

procedure TPostgres.Set_Schema( _SchemaName: String= '');
begin
     if '' <> _SchemaName
     then
         SchemaName:= _SchemaName;
     DoCommande( 'set search_path to '+SchemaName);
                //123456789012345678901234567890123456789012345678901234567890123456789
                //         1         2         3         4         5         6
end;

procedure TPostgres.GetSchemaNames(_List: TStrings);
begin
     jsdc.GetSchemaNames( _List);
end;

function TPostgres.Last_Insert_id( _NomTable: String): Integer;
var
   SQL: String;
begin
     SQL:= 'select currval( '''+_NomTable+'_SEQ'')';
     Contexte.Integer_from( SQL, Result);
end;

procedure TPostgres.GetTableNames(_List: TStrings);
begin
     Contexte.GetTableNames( _List);
end;

{ TjsDataContexte_Postgres }

constructor TjsDataContexte_Postgres.Create(_Name: String);
begin
     inherited Create( _Name);
     jsDataConnexion_Postgres:= nil;
end;

destructor TjsDataContexte_Postgres.Destroy;
begin
     inherited Destroy;
end;

procedure TjsDataContexte_Postgres.SetConnection( _Value: TjsDataConnexion);
begin
     if Affecte_( jsDataConnexion_Postgres, TPostgres, _Value)
     then
         raise Exception.Create( ClassName+'.SetConnection: Wrong type');
     inherited SetConnection( _Value);
end;

procedure TjsDataContexte_Postgres.GetTableNames(_List: TStrings);
var
   SQL: String;
begin
     SQL
     :=
        'SELECT                   '#13#10
       +'      tablename          '#13#10
       +'FROM                     '#13#10
       +'    pg_catalog.pg_tables '#13#10
       +'WHERE                    '#13#10
       +' schemaname = '''+jsDataConnexion_Postgres.SchemaName+''''#13#10;

     Liste_Champ( SQL, 'tablename', _List);
     AddViewNames( _List);
end;

procedure TjsDataContexte_Postgres.AddViewNames(_List: TStrings);
var
   SQL: String;
   sl: TStringList;
begin
     SQL
     :=
        'SELECT                   '#13#10
       +'      viewname           '#13#10
       +'FROM                     '#13#10
       +'    pg_catalog.pg_views  '#13#10
       +'WHERE                    '#13#10
       +' schemaname = '''+jsDataConnexion_Postgres.SchemaName+''''#13#10;

     sl:= TStringList.Create;
     try
        Liste_Champ( SQL, 'viewname', sl);
        _List.AddStrings( sl);
     finally
            Free_nil( sl);
            end;
end;


procedure TjsDataContexte_Postgres.Fill_with_databases(_s: TStrings);
var
   SQL: String;
begin
     SQL
     :=
        'SELECT                   '#13#10
       +'      datname            '#13#10
       +'FROM                     '#13#10
       +'    pg_database          '#13#10;

     Liste_Champ( SQL, 'datname', _s);
end;

procedure TjsDataContexte_Postgres.GetSchemaNames(_List: TStrings);
begin
     jsDataConnexion_Postgres.sqlc_p.GetSchemaNames( _List);
end;


end.
