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
    uParametres_Ligne_de_commande,
    u_sys_,
    uDataUtilsU,
    uNetwork,
    uDataUtilsF,
    u_InformixLob,//juste pour exécuter l'initialization de u_InformixLob
    uEXE_INI,
    ujsDataContexte,
    uSGBD,
    {$ifdef android}
      uSQLite_Android,
    {$else}
      uInformix,
      uMySQL,
      uPostgres,
      uSQLServer,
      uSQLite3,
      uODBC_Access,
    {$endif}

    ufAccueil_Erreur,

  Classes,SysUtils,
  FMTBcd,
  Data.DBXInformix,
  Data.DBXMySQL,
  Data.DBXMSSQL,
  Data.SqlExpr, Data.DB,
  Datasnap.Provider, Datasnap.DBClient;

type
 TCherche_table_Func= function ( tabname: String): Boolean of object;
 Tfunction_GetConnexion= function :TjsDataConnexion of object;

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
  public //mis en public pour les tests automatiques utcLogin_MySQL
    procedure Ouvre_db; virtual;
    procedure Ferme_db; virtual;
  public
    procedure Initialise;
  public
    { Déclarations publiques }

    IsMySQL: Boolean;

    //similaires
    property LoginOK: Boolean read FLoginOK write SetLoginOK;
  //Gestion de la base passée en ligne de commande
  public
    procedure Traite_autoexec_Database;
  //Type de serveur
  private
    procedure SGBDChange;
  public
    procedure Sauve;
  //jsDataConnexion
  public
    Classe_jsDataConnexion: TjsDataConnexion_Class;
    jsDataConnexion: TjsDataConnexion;
    function Get_jsDataConnexion: TjsDataConnexion;
  end;

var
   dmDatabase_IsMySQL: Boolean;

function dmDatabase: TdmDatabase;

implementation

{ TdmDatabase }

var
   FdmDatabase: TdmDatabase= nil;

function dmDatabase: TdmDatabase;
begin
     //fAccueil_Log( 'dmDatabase: début');
     if nil = FdmDatabase
     then
         begin
         //fAccueil_Log( 'dmDatabase: avant FdmDatabase:= TdmDatabase.Create;');
         FdmDatabase:= TdmDatabase.Create;
         //fAccueil_Log( 'dmDatabase: aprés FdmDatabase:= TdmDatabase.Create;');
         end;
     Result:= FdmDatabase;
     //fAccueil_Log( 'dmDatabase: fin');
end;

constructor TdmDatabase.Create;
begin
     //fAccueil_Log( ClassName+'.Create;, début');
     inherited;
     FLoginOK:= False;//redondant, initialisé dans Ouvre_db

     Classe_jsDataConnexion:= nil;
     jsDataConnexion:= nil;

     //fAccueil_Log( ClassName+'.Create;, avant pSGBDChange.Abonne( Self, SGBDChange);');
     pSGBDChange.Abonne( Self, SGBDChange);

     //fAccueil_Log( ClassName+'.Create;, avant Ferme_db;');
     Ferme_db;

     //fAccueil_Log( ClassName+'.Create;, avant Initialise;');
     Initialise;
     //Ouvre_db;
     //fAccueil_Log( ClassName+'.Create;, Fin');
end;

destructor TdmDatabase.Destroy;
begin
     Ferme_db;
     pSGBDChange.Desabonne( Self, SGBDChange);

     inherited;
end;

procedure TdmDatabase.Initialise;
begin
     IsMySQL:= sgbdMySQL;
     dmDatabase_IsMySQL:= sgbdMySQL;
     {$ifdef android}
       Classe_jsDataConnexion:= TSQLite_Android; //SGBD = sgbd_SQLite_Android
     {$else}
       case SGBD
       of
         sgbd_Informix   : Classe_jsDataConnexion:= TInformix   ;
         sgbd_MySQL      : Classe_jsDataConnexion:= TMySQL      ;
         sgbd_Postgres   : Classe_jsDataConnexion:= TPostgres   ;
         sgbd_SQLServer  : Classe_jsDataConnexion:= TSQLServer  ;
         sgbd_SQLite3    : Classe_jsDataConnexion:= TSQLite3    ;
         sgbd_ODBC_Access: Classe_jsDataConnexion:= TODBC_Access;
         else
             raise Exception.Create( ClassName+'.Initialise: sbgd non géré: '+sSGBDs[SGBD]);
         end;
     {$endif}

     //fAccueil_Log( ClassName+'.Initialise;, avant jsDataConnexion:= Classe_jsDataConnexion.Create;');
     jsDataConnexion:= Classe_jsDataConnexion.Create( SGBD);
     //fAccueil_Log( ClassName+'.Initialise;, avant jsDataConnexion.Prepare;');
     jsDataConnexion.Prepare;
     //fAccueil_Log( ClassName+'.Initialise;, apréss jsDataConnexion.Prepare;');
end;

procedure TdmDatabase.Ouvre_db;
begin
     FLoginOK:= False;

     if nil = jsDataConnexion then exit;

     if not jsDataConnexion.Ouvrable then exit;

     jsDataConnexion.Ouvre_db;
end;

procedure TdmDatabase.Ferme_db;
begin
     if nil = jsDataConnexion then exit;

     jsDataConnexion.Ferme_db;

     FLoginOK:= False;
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
         //InputQuery( 'Connection à la base de données',  //ne marche pas en FMX
         //            'Entrez le nom de la base de données:',
         //            NewDatabase);
         {$ENDIF}
         end;

     OldDatabase:= jsDataConnexion.DataBase; jsDataConnexion.DataBase:= NewDatabase;

     try
        Initialise;
        Ouvre_db;
     except
           on E: Exception
           do
             begin
             jsDataConnexion.DataBase:= OldDatabase;
             raise;
             end;
           end;
end;

procedure TdmDatabase.SGBDChange;
begin
     Ferme_db;
     Initialise;
end;

procedure TdmDatabase.Sauve;
begin
     jsDataConnexion.Ecrire;
end;

function TdmDatabase.Get_jsDataConnexion: TjsDataConnexion;
begin
     Result:= jsDataConnexion;
end;

procedure TdmDatabase.SetLoginOK( Value: Boolean);
begin
     if FLoginOK = Value then exit;
     FLoginOK:= Value;
end;

initialization

finalization
              Free_nil( FdmDatabase);
end.

