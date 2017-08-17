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
    ujsDataContexte,
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
    IniFiles,
  FMTBcd, BufDataset;

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
    procedure Keep_Connection; virtual;
    procedure Do_not_Keep_Connection; virtual;
  //DBExpress
  public
    procedure Initialise_DBExpress;
  public
    { Déclarations publiques }

    IsMySQL: Boolean;

    //similaires
    property LoginOK: Boolean read FLoginOK write SetLoginOK;
  //Gestion de la base passée en ligne de commande
  public
    procedure Traite_autoexec_Database;
  //Récupération du nom du serveur et de la base
  public
    function Hote: String;
    function Database: String;
    function sSGBD_Database: String;
  //Type de serveur
  private
    procedure SGBDChange;
  public
    procedure Sauve;
  //Récupération du nom des bases
  public
    procedure Fill_with_databases( _s: TStrings); overload;
//    procedure Fill_with_databases( _cb: TComboBox); overload;
  //jsDataConnexion
  public
    Classe_jsDataConnexion: TjsDataConnexion_Class;
    jsDataConnexion: TjsDataConnexion;
    function Connection: TjsDataConnexion;
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
begin
     inherited;
     FLoginOK:= False;//redondant, initialisé dans Ouvre_db

     Classe_jsDataConnexion:= nil;
     jsDataConnexion:= nil;

     pSGBDChange.Abonne( Self, SGBDChange);

     Ferme_db;

     Initialise_DBExpress;
     //Ouvre_db;
end;

destructor TdmDatabase.Destroy;
begin
     Ferme_db;
     pSGBDChange.Desabonne( Self, SGBDChange);

     inherited;
end;

procedure TdmDatabase.Initialise_DBExpress;
begin
     IsMySQL:= sgbdMySQL;
     dmDatabase_IsMySQL:= sgbdMySQL;
     case SGBD
     of
       sgbd_Informix : Classe_jsDataConnexion:= TInformix;
       sgbd_MySQL    : Classe_jsDataConnexion:= TMySQL;
       sgbd_Postgres : Classe_jsDataConnexion:= TPostgres;
       sgbd_SQLServer: Classe_jsDataConnexion:= TSQLServer;
       sgbd_SQLite3  : Classe_jsDataConnexion:= TSQLite3;
       else
           raise Exception.Create( ClassName+'.Initialise_DBExpress: sbgd non géré: '+sSGBDs[SGBD]);
       end;

     jsDataConnexion:= Classe_jsDataConnexion.Create;
     jsDataConnexion.Prepare;
end;

procedure TdmDatabase.Ouvre_db;
begin
     FLoginOK:= False;

     if not jsDataConnexion.Ouvrable then exit;

     jsDataConnexion.Ouvre_db;
end;

procedure TdmDatabase.Ferme_db;
begin
     jsDataConnexion.Ferme_db;
end;

procedure TdmDatabase.Do_not_Keep_Connection;
begin
     jsDataConnexion.Do_not_Keep_Connection;
end;

procedure TdmDatabase.Keep_Connection;
begin
     jsDataConnexion.Keep_Connection;
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

     OldDatabase:= jsDataConnexion.DataBase; jsDataConnexion.DataBase:= NewDatabase;

     try
        Initialise_DBExpress;
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
     Initialise_DBExpress;
end;

function TdmDatabase.Hote: String;
begin
     Result:= jsDataConnexion.HostName;
end;

function TdmDatabase.Database: String;
begin
     Result:= jsDataConnexion.DataBase;
end;

function TdmDatabase.sSGBD_Database: String;
begin
     Result
     :=
       'base '+DataBase+' sur '+sSGBD;
end;

procedure TdmDatabase.Sauve;
begin
     jsDataConnexion.Ecrire;
end;

procedure TdmDatabase.Fill_with_databases( _s: TStrings);
begin
     jsDataConnexion.Fill_with_databases( _s);
end;

function TdmDatabase.Connection: TjsDataConnexion;
begin
     Result:= jsDataConnexion;
end;

(*
procedure TdmDatabase.Fill_with_databases( _cb: TComboBox);
begin
     if _cb = nil then exit;

     Fill_with_databases( _cb.Items);
     _cb.Sorted:= True;
end;
*)

procedure TdmDatabase.SetLoginOK( Value: Boolean);
begin
     if FLoginOK = Value then exit;
     FLoginOK:= Value;
end;

initialization
              dmDatabase:= TdmDatabase.Create;
finalization
              Free_nil( dmDatabase);
end.

