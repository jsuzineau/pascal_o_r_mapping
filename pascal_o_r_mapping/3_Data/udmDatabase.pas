unit udmDatabase;
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
    uLog,
    uOD_Forms,
    uParametres_Ligne_de_commande,
    uBatpro_StringList,
    u_sys_,
    u_ini_,
    uDataUtilsU,
    uNetwork,
    uuStrings,
    uDataUtilsF,
    u_InformixLob,//juste pour exécuter l'initialization de u_InformixLob
    uEXE_INI,
    uSGBD,
    uInformix,
    uMySQL,
    uPostgres,
    uSQLServer,
    uSQLite3,

    ufAccueil_Erreur,

  {$IFNDEF FPC}
  Windows, Messages, Graphics, Controls, Forms, Dialogs,
  StdCtrls,Registry,
  {$ENDIF}
  {$IF DEFINED(MSWINDOWS) AND NOT DEFINED(FPC)}
  ucbvCustomConnection,
 {$IFEND}
  Classes,SysUtils,
  Db, SQLDB,
  mysql50conn,
    mysql51conn,
    mysql55conn,
    mysql56conn,
    odbcconn,
    mssqlconn,
    sqlite3conn_pour_test,
    IniFiles,
  FMTBcd, BufDataset;

type
 TCherche_table_Func= function ( tabname: String): Boolean of object;
 Tfunction_GetConnection= function :TSQLConnection of object;

 { TdmDatabase }

 TdmDatabase
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  private
    FLoginOK: Boolean;
    procedure SetLoginOK(Value: Boolean);
    function EmptyCommande( Commande: String): Boolean;
  protected
    procedure CopieConnection(source, cible: TDatabase);
  public //mis en public pour les tests automatiques utcLogin_MySQL
    procedure Ouvre_db; virtual;
    procedure Ferme_db; virtual;
    procedure Keep_Connection; virtual;
    procedure Do_not_Keep_Connection; virtual;
    procedure Init_Connection( _sqlc: TDatabase; _Database: String);
  //DBExpress
  protected
    procedure _from_Informix;
    procedure _from_MySQL;
    procedure _from_Postgres;
    procedure _from_SQLServer;
    procedure _from_SQLite3;
    procedure DBExpress_Informix;
    procedure DBExpress_MySQL;
    procedure DBExpress_Postgres;
    procedure DBExpress_SQLServer;
    procedure DBExpress_SQLite3;
  public
    procedure Initialise_DBExpress;
  public
    { Déclarations publiques }
    Ouvrable: Boolean;
    Ouvert: Boolean;
    Database_indefinie: Boolean;

    IsMySQL: Boolean;

    //similaires
    procedure DoCommande( Commande: String);
    function ExecQuery( _SQL: String): Boolean;

    procedure DoScript  ( NomFichierScriptSQL: String);
    procedure DoLOAD_INTO_MarchesSystem( NomFichier, NomTable: String;
                                         NbLignesEntete: Integer = 0);
    procedure DoLOAD_INTO_INFORMIX     ( NomFichier, NomTable: String;
                                         LinuxWindows_: Boolean);
    function MySQLPath(NomFichier: String): String;
    procedure WriteParam(Key, Value: String);
    procedure Start_SQLLog;
    procedure Stop_SQLLog;
    procedure Reconnecte;
    property LoginOK: Boolean read FLoginOK write SetLoginOK;
  //GED
  public
    procedure Connecte_GED;
  //Gestion de la base passée en ligne de commande
  public
    procedure Traite_autoexec_Database;
  //Récupération du nom du serveur et de la base
  public
    function Hote: String;
    function Database: String;
    function sSGBD_Database: String;
    function Base_sur: String;
  //Type de serveur
  private
    procedure SGBDChange;
  public
    procedure Sauve;
  //Récupération du nom des bases
  public
    procedure Fill_with_databases( _s: TStrings); overload;
//    procedure Fill_with_databases( _cb: TComboBox); overload;
  //Spécial Freepascal
  private
    sqltSYSMASTER: TSQLTransaction;
    sqlqSHOW_DATABASES: TSQLQuery;
    sqlqSYSDATABASES: TSQLQuery;
  public
    sqlcInformix: TSQLConnection;
    sqlcInformixSYSMASTER: TSQLConnection;
    sqlcMySQL    : TSQLConnection;
    sqlcSQLServer: TSybaseConnection;
    sqlcSQLite3: TSQLite3Connection;
    sqlc: TSQLConnection;
    sqlt: TSQLTransaction;
    sqlcGED: TSQLConnection;
    sqltGED: TSQLTransaction;
    procedure Connecte_SQLQuery( _SQLQuery: TSQLQuery);
  //fonctions accesseurs aux Connections, pour Freepascal
  public
    function Connection: TSQLConnection;
    function Connection_GED: TSQLConnection;
  //Gestion du log
  private
    procedure GetLogEvent( _Sender: TSQLConnection;
                           _EventType: TDBEventType;
                           const _Msg : String);
  end;

// constraint \"informix\"\.n{[0123456789_]*}
// constraint \"informix\"\.n{[0123456789_]*}
// constraint \"batprov3\"\.n{[0123456789_]*}
// constraint \"batpro\"\.n{[0123456789_]*}

// Locale code 1036	fr	Français (France) (paramètre pour TDatabase)

const
     //BDE
     db_bde_database= 'DATABASE NAME';
     db_bde_server  =   'SERVER NAME';
     db_bde_user    =   'USER NAME';

     //DBExpress, pilote Borland
     db_dbx_database= 'DataBase';
     db_dbx_server  = 'HostName';

     //DBExpress, pilote Luxena pour Informix
     db_dbx_Luxena_database= 'DataBase';

var
   dmDatabase: TdmDatabase;
   dmDatabase_IsMySQL: Boolean;

implementation

const
     inik_Mot_de_passe= 'Mot_de_passe';

constructor TdmDatabase.Create;
    function Cree_SQLTransaction_ODBC: TSQLTransaction;
    begin
         Result:= TSQLTransaction.Create( nil);
    end;
    function Cree_SQLTransaction: TSQLTransaction;
    begin
         Result:= TSQLTransaction.Create( nil);
         with Result do Options:= Options+[stoUseImplicit];
    end;
begin
     inherited;
     FLoginOK    := False;//redondant, initialisé dans Ouvre_db
     Ouvrable:= False;

     pSGBDChange.Abonne( Self, SGBDChange);

     sqlt         := Cree_SQLTransaction;
     sqltGED      := Cree_SQLTransaction;
     sqltSYSMASTER:= Cree_SQLTransaction_ODBC;


     sqlcInformix:= TODBCConnection.Create(nil);
     sqlcMySQL   := MySQL.Cree_Connection;
     sqlcSQLServer:= TSybaseConnection.Create(nil);
     sqlcSQLite3 := SQLite3.Cree_Connection;

     sqlcMySQL    .Transaction:= sqlt;
     sqlcSQLServer.Transaction:= sqlt;
     sqlcSQLite3  .Transaction:= sqlt;

     sqlcGED:= MySQL.Cree_Connection;
     sqlcGED.Transaction:= sqltGED;
     sqlcGED.UserName:= 'root';
     sqlcGED.Password:= '';
     sqlcGED.DatabaseName:= 'batpro_ged';

     sqlcInformixSYSMASTER:= TODBCConnection.Create(nil);
     sqlcInformixSYSMASTER.Transaction:= sqltSYSMASTER;
     sqlcInformixSYSMASTER.DatabaseName:= 'sysmaster';

     sqlqSYSDATABASES:= TSQLQuery.Create(nil);
     sqlqSYSDATABASES.SQL.Text:= 'select * from sysdatabases where name <> "sysmaster" and name <> "sysutils"';
     sqlqSYSDATABASES.Transaction:= sqltSYSMASTER;

     sqlqSHOW_DATABASES:= TSQLQuery.Create(nil);
     sqlqSHOW_DATABASES.SQL.Text:= 'show databases';

     sqlc:= nil;

     Ferme_db;

     Initialise_DBExpress;
     //Ouvre_db;
end;

destructor TdmDatabase.Destroy;
begin
     Ferme_db;
     pSGBDChange.Desabonne( Self, SGBDChange);

     FreeAndnil( sqlqSHOW_DATABASES);
     FreeAndnil( sqlt);
     FreeAndnil( sqltGED);
     FreeAndnil( sqlcInformix);
     FreeAndnil( sqlcMySQL);
     FreeAndnil( sqlcSQLServer);
     FreeAndnil( sqlcSQLite3);
     FreeAndnil( sqlcGED);

     inherited;
end;

procedure TdmDatabase.Initialise_DBExpress;
begin
     IsMySQL:= sgbdMySQL;
     dmDatabase_IsMySQL:= sgbdMySQL;
     if Assigned( sqlc) then sqlc.Transaction:= nil;
     case SGBD
     of
       sgbd_Informix : DBExpress_Informix;
       sgbd_MySQL    : DBExpress_MySQL;
       sgbd_Postgres : DBExpress_Postgres;
       sgbd_SQLServer: DBExpress_SQLServer;
       sgbd_SQLite3  : DBExpress_SQLite3;
       else
           begin
           Ouvrable:= False;
           Database_indefinie:= True;
           end;
       end;
     sqlc.Transaction:= sqlt;
end;

procedure TdmDatabase.Ouvre_db;
begin
     FLoginOK:= False;

     if not Ouvrable then exit;

     //Log.PrintLn( ClassName+'.Ouvre_db: Avant ouverture connection');
     Ouvert:= Ouvre_SQLConnection( sqlc);
     //Log.PrintLn( ClassName+'.Ouvre_db: Aprés ouverture connection');
     Log.PrintLn( Base_sur+' sqlc.Hostname='+sqlc.HostName+' sqlc.DatabaseName='+sqlc.DatabaseName);
     if not Ouvert then exit;

     case SGBD
     of
       sgbd_Informix:
         begin
         if Ouvre_SQLConnection( sqlcInformixSYSMASTER) // liste des bases informix
         then
             if RefreshQuery( sqlqSYSDATABASES)
             then
                 sqlqSYSDATABASES.Locate('name', Informix.DataBase, []);
         end;
       sgbd_MySQL:
         begin
         Connecte_SQLQuery( sqlqSHOW_DATABASES);
         if RefreshQuery( sqlqSHOW_DATABASES) // liste des bases mysql
         then
             sqlqSHOW_DATABASES.Locate('Database', MySQL.DataBase, []);
         end;
       sgbd_Postgres:
         begin
         (*if RefreshQuery( cdPG_DATABASES) // liste des bases Postgres
         then
             cdPG_DATABASES.Locate('datname', Postgres.DataBase, []);*)
         end;
       sgbd_SQLServer:
         begin
         {
         if RefreshQuery( cdPG_DATABASES) // liste des bases Postgres
         then
             cdPG_DATABASES.Locate('datname', Postgres.DataBase, []);
         }
         end;
       sgbd_SQLite3:
         begin
         end;
       sgbd_SQLite_Android:
         begin
         end;
       end;
end;

procedure TdmDatabase.Ferme_db;
begin
     Ouvert:= False;

     sqlqSHOW_DATABASES.Close;
     sqlqSYSDATABASES  .Close;

     sqlcInformixSYSMASTER.Close;
     sqlcInformix         .Close;

     sqlcMySQL            .Close;
     sqlcSQLServer        .Close;
     sqlcSQLite3          .Close;

     if Assigned( sqlc) then sqlc.Close;
     sqlcGED              .Close;
end;

procedure TdmDatabase.Do_not_Keep_Connection;
begin
      sqlcInformixSYSMASTER.KeepConnection:= False;sqlcInformixSYSMASTER.Connected:= False;
      sqlc                 .KeepConnection:= False;sqlc                 .Connected:= False;
end;

procedure TdmDatabase.Keep_Connection;
begin
      sqlc.KeepConnection:= True;
      Ouvre_SQLConnection( sqlc);
      if sgbdINFORMIX
      then
          begin
          sqlcInformixSYSMASTER.KeepConnection:= True;
          Ouvre_SQLConnection( sqlcInformixSYSMASTER);
          end;
end;

procedure TdmDatabase.CopieConnection( source, cible: TDatabase);
begin
     cible.Assign( source);
     (*cible.ConnectionName:= source.ConnectionName;
     cible.DriverName    := source.DriverName    ;
     cible.GetDriverFunc := source.GetDriverFunc ;
     cible.LibraryName   := source.LibraryName   ;
     cible.VendorLib     := source.VendorLib     ;*)
     cible.Params.Text   := source.Params.Text   ;
end;

procedure TdmDatabase.WriteParam(Key, Value: String);
begin
     sqlc.Params.Values[Key]:= Value;
end;

procedure TdmDatabase._from_Informix;
begin
     Database_indefinie:= Informix.DataBase = sys_Vide;
     if Database_indefinie
     then
         Informix.DataBase:= 'sysmaster'
     else
         Database_indefinie:= Informix.DataBase = 'sysmaster';

     Ouvrable
     :=
       //    (Informix.HostName  <> sys_Vide)
       //and (Informix.User_Name <> sys_Vide)
       (*and*) (Informix.Database  <> sys_Vide);


     sqlc.DatabaseName:= Informix.Database;
     //WriteParam( 'HostName' , Informix.HostName );
     //WriteParam( 'User_Name', Informix.User_Name);
     //WriteParam( 'Password' , Informix.Password );
     //WriteParam( 'DataBase' , Informix.Database );
end;

procedure TdmDatabase._from_MySQL;
begin
     Database_indefinie:= (MySQL.DataBase = sys_Vide) or (MySQL.DataBase='---');
     if Database_indefinie
     then
         MySQL.DataBase:= 'mysql'
     else
         Database_indefinie:= MySQL.DataBase = 'mysql';

     Ouvrable
     :=
           (MySQL.HostName  <> sys_Vide)
       and (MySQL.User_Name <> sys_Vide)
       and (MySQL.Database  <> sys_Vide);

     sqlc.HostName:= MySQL.HostName;
     sqlc.UserName:= MySQL.User_Name;
     sqlc.Password:= MySQL.Password;
     sqlc.DatabaseName:= MySQL.Database;
end;

procedure TdmDatabase._from_Postgres;
begin
     Database_indefinie:= Postgres.DataBase = sys_Vide;
     if Database_indefinie
     then
         Postgres.DataBase:= 'postgres'
     else
         Database_indefinie:= Postgres.DataBase = 'postgres';

     Ouvrable
     :=
           (Postgres.HostName  <> sys_Vide)
       and (Postgres.User_Name <> sys_Vide)
       and (Postgres.Database  <> sys_Vide);

     WriteParam( 'HostName'  , Postgres.HostName  );
     WriteParam( 'User_Name' , Postgres.User_Name );
     WriteParam( 'Password'  , Postgres.Password  );
     WriteParam( 'DataBase'  , Postgres.Database  );
     WriteParam( 'SchemaName', Postgres.SchemaName);
end;

procedure TdmDatabase._from_SQLServer;
begin
     Database_indefinie:= (SQLServer.DataBase = sys_Vide) or (SQLServer.DataBase='---');
     if Database_indefinie
     then
         SQLServer.DataBase:= 'SQLServer'
     else
         Database_indefinie:= SQLServer.DataBase = 'SQLServer';

     Ouvrable
     :=
           (SQLServer.HostName  <> sys_Vide)
       and (SQLServer.User_Name <> sys_Vide)
       and (SQLServer.Database  <> sys_Vide);

     sqlcSQLServer.HostName:= SQLServer.HostName;
     sqlcSQLServer.UserName:= SQLServer.User_Name;
     sqlcSQLServer.Password:= SQLServer.Password;
     sqlcSQLServer.DatabaseName:= SQLServer.Database;

     //WriteParam( 'HostName' , SQLServer.HostName );
     //WriteParam( 'User_Name', SQLServer.User_Name);
     //WriteParam( 'Password' , SQLServer.Password );
     //WriteParam( 'DataBase' , SQLServer.Database );
end;

procedure TdmDatabase._from_SQLite3;
var
   Default_Database: String;
begin
     Default_Database:= GetCurrentDir+DirectorySeparator+'SQLite3_database.db';

     Database_indefinie:= (SQLite3.DataBase = sys_Vide) or (SQLite3.DataBase='---');
     if Database_indefinie
     then
         SQLite3.DataBase:= Default_Database
     else
         Database_indefinie:= SQLite3.DataBase = Default_Database;

     Ouvrable
     :=
            (SQLite3.Database  <> sys_Vide)
        and FileExists(SQLite3.Database);

     sqlcSQLite3.DatabaseName:= SQLite3.Database;

end;

procedure TdmDatabase.DBExpress_Informix;
begin
     sqlc:= sqlcInformix;
     //WriteParam( 'Trim Char' , 'True');//sinon les champs CHAR() sont
                                       //remplis avec des espaces jusqu'à leur
                                       //taille maximum

     _from_Informix;
end;

procedure TdmDatabase.DBExpress_MySQL;
begin
     sqlc:= sqlcMySQL;
     _from_MySQL;
end;

procedure TdmDatabase.DBExpress_Postgres;
begin
     _from_Postgres;
end;

procedure TdmDatabase.DBExpress_SQLServer;
begin
     sqlc:= sqlcSQLServer;
     _from_SQLServer;
end;

procedure TdmDatabase.DBExpress_SQLite3;
begin
     sqlc:= sqlcSQLite3;
     _from_SQLite3;
end;

function TdmDatabase.EmptyCommande(Commande: String): Boolean;
var
   J: Integer;
begin
     Result:= True;
     for J:= 1 to Length( Commande)
     do
       begin
       Result:= Commande[J] in [' ', #13, #10];
       if not Result then break;
       end;
end;

procedure TdmDatabase.DoCommande( Commande: String);
begin
     if EmptyCommande( Commande) then exit;
     try
        sqlc.ExecuteDirect( Commande);
        Commande:= ChaineDe(80,'#')+ sys_N+ Commande + sys_N+ '---> Succés';
        fAccueil_Log( Commande);
     except
           on E: EDatabaseError
           do
             begin
             Commande:= ChaineDe(80,'#')+sys_N + Commande + sys_N+ '---> Echec:'+sys_N+
                        E.Message;
             fAccueil_Erreur( Commande);
             end;
           end;
end;

procedure TdmDatabase.DoScript( NomFichierScriptSQL: String);
var
   sl: TBatpro_StringList;
   S: String;
   Commande: String;
begin
     fAccueil_Log(   ChaineDe(80,'*')   +sys_N
                   + NomFichierScriptSQL+sys_N
                   + ChaineDe(80,'*')   +sys_N);
     sl:= TBatpro_StringList.Create;
     try
        sl.LoadFromFile( NomFichierScriptSQL);

        S:= sl.Text;
     finally
            Free_nil( sl);
            end;

     while S <> sys_Vide
     do
       begin
       Commande:= StrTok( ';', S);
       DoCommande( Commande);
       end;
end;

function TdmDatabase.MySQLPath( NomFichier: String): String;
var
   I: Integer;
begin
     Result:= NomFichier;
     for I:= 1 to Length(Result)
     do
       if Result[I] = '\' then Result[I]:= '/';
end;

procedure TdmDatabase.DoLOAD_INTO_INFORMIX( NomFichier,
                                                    NomTable: String;
                                                    LinuxWindows_: Boolean);
var
   FinLigne: String;
begin
     if LinuxWindows_
     then
         FinLigne:=   '\n'
     else
         FinLigne:= '\r\n';
     DoCommande( Format(  'LOAD DATA                             '+ sys_N
                         +'     INFILE ''%s''                      '+ sys_N
                         +'     REPLACE                          '+ sys_N
                         +'     INTO TABLE %s                    '+ sys_N
                         +'     FIELDS                           '+ sys_N
                         +'           TERMINATED BY ''|''          '+ sys_N
                         +'     LINES                            '+ sys_N
                         +'          TERMINATED BY ''%s''          '+ sys_N,
                         [ MySQLPath( NomFichier), NomTable, FinLigne]));
end;

procedure TdmDatabase.DoLOAD_INTO_MarchesSystem( NomFichier,
                                                         NomTable: String;
                                                         NbLignesEntete: Integer = 0);
begin
     DoCommande( Format(  'LOAD DATA                             '+ sys_N
                         +'     INFILE ''%s''                      '+ sys_N
                         +'     REPLACE                          '+ sys_N
                         +'     INTO TABLE %s                    '+ sys_N
                         +'     FIELDS                           '+ sys_N
                         +'           TERMINATED BY ''\t''         '+ sys_N
                         +'           OPTIONALLY ENCLOSED BY ''|'' '+ sys_N
                         +'     LINES                            '+ sys_N
                         +'          TERMINATED BY ''\r\n''        '+ sys_N
                         +'     IGNORE %d LINES                  '+ sys_N,
                         [ MySQLPath( NomFichier), NomTable, NbLignesEntete]));
end;

procedure TdmDatabase.Start_SQLLog;
begin
     sqlc.LogEvents:=LogAllEvents;
     sqlc.OnLog:= GetLogEvent;
end;

procedure TdmDatabase.Stop_SQLLog;
begin
     sqlc.LogEvents:=[];
     sqlc.OnLog    := nil;
end;

procedure TdmDatabase.Reconnecte;
begin
     sqlc.Connected:= False;
     sqlc.Connected:= True;
end;

procedure TdmDatabase.Connecte_GED;
begin
     sqlcGED.Close;
     MySQL.Assure_initialisation;

     sqlcGED.HostName:= MySQL.HostName;

     if sgbdMYSQL
     then
         begin
         sqlcGED.UserName:= MySQL.User_Name;
         sqlcGED.Password:= MySQL.Password;
         sqlcGED.DatabaseName:= MySQL.Database;
         end;
     sqlcGED.Open;
     //fAccueil.Erreur(  'Connection GED réussie:'#13#10
     //                 +sqlcGED.Params.Text)
end;

procedure TdmDatabase.Traite_autoexec_Database;
var
   OldDatabase: String;
   NewDatabase: String;
begin
     Ferme_db;

     uSGBD_Compute;
     NewDatabase:= autoexec_Database;
     if Trim(NewDatabase) = ''
     then
         begin
         fAccueil_Erreur(  'Erreur à signaler au développeur:'#13#10
                          +'  TdmDatabase.Traite_autoexec_Database: '
                          +'le nom de base de données passé en paramètre de ligne de commande est vide');
         {$IFNDEF FPC}
         end;
         InputQuery( 'Connection à la base de données',
                     'Entrez le nom de la base de données:',
                     NewDatabase);
         {$ENDIF}
         end;

     case SGBD
     of
       sgbd_Informix:
         begin
         OldDatabase:= Informix.DataBase; Informix.DataBase:= NewDatabase;
         end;
       sgbd_MySQL:
         begin
         OldDatabase:= MySQL   .DataBase; MySQL   .DataBase:= NewDatabase;
         end;
       sgbd_Postgres:
         begin
         OldDatabase:= Postgres.DataBase; Postgres.DataBase:= NewDatabase;
         end;
       sgbd_SQLServer:
         begin
         OldDatabase:= SQLServer.DataBase; SQLServer.DataBase:= NewDatabase;
         end;
       sgbd_SQLite3:
         begin
         OldDatabase:= SQLite3.DataBase; SQLite3.DataBase:= NewDatabase;
         end;
       else SGBD_non_gere( 'TdmDatabase.Traite_autoexec_Database; 1');
       end;

     try
        Initialise_DBExpress;
        Ouvre_db;
     except
           on E: Exception
           do
             begin
             case SGBD
             of
               sgbd_Informix : Informix .DataBase:= OldDatabase;
               sgbd_MySQL    : MySQL    .DataBase:= OldDatabase;
               sgbd_Postgres : Postgres .DataBase:= OldDatabase;
               sgbd_SQLServer: SQLServer.DataBase:= OldDatabase;
               sgbd_SQLite3  : SQLite3  .DataBase:= OldDatabase;
               else SGBD_non_gere( 'TdmDatabase.Traite_autoexec_Database; 2');
               end;
             raise;
             end;
           end;
end;

procedure TdmDatabase.SGBDChange;
begin
     Ferme_db;
     Initialise_DBExpress;
end;

//il faudrait mettre un ancêtre commun pour TInformix, TMySQL, ...
//pour simplifier et factoriser le code ci-dessous
function TdmDatabase.Hote: String;
begin
     case SGBD
     of
       sgbd_Informix : Result:= Informix  .HostName;
       sgbd_MySQL    : Result:= MySQL     .HostName;
       sgbd_Postgres : Result:= Postgres  .HostName;
       sgbd_SQLServer: Result:= SQLServer .HostName;
       sgbd_SQLite3  : Result:= 'local filesystem';
       else            Result:= Informix  .HostName;
       end;
end;

function TdmDatabase.Database: String;
begin
     case SGBD
     of
       sgbd_Informix : Result:= Informix .DataBase;
       sgbd_MySQL    : Result:= MySQL    .DataBase;
       sgbd_Postgres : Result:= Postgres .DataBase;
       sgbd_SQLServer: Result:= SQLServer.DataBase;
       sgbd_SQLite3  : Result:= SQLite3  .DataBase;
       else            Result:= Informix .DataBase;
       end;
end;

function TdmDatabase.sSGBD_Database: String;
begin
     Result
     :=
       'base '+DataBase+' sur '+sSGBD;
end;

function TdmDatabase.Base_sur: String;
begin
     Result:= 'base '+sSGBD+' '+Database+' sur '+Hote;
end;

procedure TdmDatabase.Sauve;
begin
     case SGBD
     of
       sgbd_Informix : Informix .Ecrire;
       sgbd_MySQL    : MySQL    .Ecrire;
       sgbd_Postgres : Postgres .Ecrire;
       sgbd_SQLServer: SQLServer.Ecrire;
       sgbd_SQLite3  : SQLite3  .Ecrire;
       end;
end;

procedure TdmDatabase.Fill_with_databases( _s: TStrings);
var
   sqlqSHOW_DATABASESDatabase: TStringField;
begin
     if _s = nil then exit;

     if not sqlc.Connected
     then
         Ouvre_SQLConnection( sqlc);

     sqlc.GetSchemaNames( _s);

     case SGBD
     of
       sgbd_Informix:
         begin
         (*cdSYSDATABASE.First;
         while not cdSYSDATABASE.Eof
         do
           begin
           _cb.Items.Add( cdSYSDATABASEname.Value);
           cdSYSDATABASE.Next;
           end;*)
         end;
       sgbd_MySQL   :begin end;
       sgbd_Postgres:
         begin
         (*cdPG_DATABASES.First;
         while not cdPG_DATABASES.Eof
         do
           begin
           _cb.Items.Add( cdPG_DATABASESdatname.Value);
           cdPG_DATABASES.Next;
           end;*)
         end;
       sgbd_SQLServer:
         begin
         end;
       sgbd_SQLite3:
         begin
         end;
       end;
end;

procedure TdmDatabase.Connecte_SQLQuery( _SQLQuery: TSQLQuery);
begin
     _SQLQuery.Database   := sqlc;
     _SQLQuery.Transaction:= sqlt;
end;

(*
procedure TdmDatabase.Fill_with_databases( _cb: TComboBox);
begin
     if _cb = nil then exit;

     Fill_with_databases( _cb.Items);
     _cb.Sorted:= True;
end;
*)

function TdmDatabase.ExecQuery(_SQL: String): Boolean;
begin
     Result:= uDataUtilsF.ExecQuery( sqlc, _SQL);
end;

procedure TdmDatabase.SetLoginOK( Value: Boolean);
begin
     if FLoginOK = Value then exit;
     FLoginOK:= Value;
end;

procedure TdmDatabase.Init_Connection( _sqlc: TDatabase;
                                       _Database: String);
begin
     CopieConnection( sqlc, _sqlc);
     _sqlc.Params.Values['DataBase']:= _Database;
end;

function TdmDatabase.Connection: TSQLConnection;
begin
     Result:= sqlc;
end;

function TdmDatabase.Connection_GED: TSQLConnection;
begin
     Result:= sqlcGED;
end;

procedure TdmDatabase.GetLogEvent( _Sender: TSQLConnection;
                                   _EventType: TDBEventType;
                                   const _Msg: String);
var
  Source: string;
begin
     case _EventType
     of
       detCustom:   Source:='Custom:  ';
       detPrepare:  Source:='Prepare: ';
       detExecute:  Source:='Execute: ';
       detFetch:    Source:='Fetch:   ';
       detCommit:   Source:='Commit:  ';
       detRollBack: Source:='Rollback:';
       else Source:='Unknown event. Please fix program code.';
     end;
     Log.PrintLn( Source + ' ' + _Msg);
end;
initialization
              dmDatabase:= TdmDatabase.Create;
finalization
              Free_nil( dmDatabase);
end.

