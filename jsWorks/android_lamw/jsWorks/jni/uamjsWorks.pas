{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
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
{Hint: save all files to location: C:\_freepascal\pascal_o_r_mapping\jsWorks\android_lamw\jsWorks\jni }
unit uamjsWorks;

{$mode delphi}

interface

uses
    uForms,
    uEXE_INI,
    ujsDataContexte,
    uSGBD,
    uInformix,
    uMySQL,
    uPostgres,
    uSQLServer,
    uSQLite3,
    uSQLite_Android,

    uParametres_Ligne_de_commande,

    ublWork,

    //udmDatabase,
    upoolWork,

    ufAccueil_Erreur,
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
		AndroidWidget;

{%region /fold 'dmDatabase'}
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

var
   dmDatabase_IsMySQL: Boolean;

function dmDatabase: TdmDatabase;
{%endregion}

type
 { TamjsWorks }

 TamjsWorks
 =
  class(jForm)
    bOuvrir: jButton;
    bState: jButton;
				bDemarrer: jButton;
				tw: jTextView;
    sc: jSqliteCursor;
    sda: jSqliteDataAccess;
    procedure amjsWorksCreate(Sender: TObject);
    procedure amjsWorksJNIPrompt(Sender: TObject);
				procedure bDemarrerClick(Sender: TObject);
    procedure bOuvrirClick(Sender: TObject);
    procedure bStateClick(Sender: TObject);
  private
    procedure Exec_query( _SQL: String);
    procedure Show_tables;
    procedure Log( _Message_Developpeur: String; _Message: String = '');
    procedure Test_SQLite_Android( _Filename: String);
  end;

var
  amjsWorks: TamjsWorks;

implementation
  
{$R *.lfm}

{%region /fold 'dmDatabase'}
{ TdmDatabase }

var
   FdmDatabase: TdmDatabase= nil;

function dmDatabase: TdmDatabase;
begin
     fAccueil_Log( 'dmDatabase: début');
     if nil = FdmDatabase
     then
         begin
         fAccueil_Log( 'dmDatabase: avant FdmDatabase:= TdmDatabase.Create;');
         FdmDatabase:= TdmDatabase.Create;
         fAccueil_Log( 'dmDatabase: aprés FdmDatabase:= TdmDatabase.Create;');
         end;
     Result:= FdmDatabase;
     fAccueil_Log( 'dmDatabase: fin');
end;

constructor TdmDatabase.Create;
begin
     fAccueil_Log( ClassName+'.Create;, début');
     inherited;
     FLoginOK:= False;//redondant, initialisé dans Ouvre_db

     Classe_jsDataConnexion:= nil;
     jsDataConnexion:= nil;

     fAccueil_Log( ClassName+'.Create;, avant pSGBDChange.Abonne( Self, SGBDChange);');
     pSGBDChange.Abonne( Self, SGBDChange);

     fAccueil_Log( ClassName+'.Create;, avant Ferme_db;');
     Ferme_db;

     fAccueil_Log( ClassName+'.Create;, avant Initialise;');
     Initialise;
     //Ouvre_db;
     fAccueil_Log( ClassName+'.Create;, Fin');
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
     case SGBD
     of
       sgbd_Informix : Classe_jsDataConnexion:= TInformix;
       sgbd_MySQL    : Classe_jsDataConnexion:= TMySQL;
       sgbd_Postgres : Classe_jsDataConnexion:= TPostgres;
       sgbd_SQLServer: Classe_jsDataConnexion:= TSQLServer;
       sgbd_SQLite3  : Classe_jsDataConnexion:= TSQLite3;
       else
           raise Exception.Create( ClassName+'.Initialise: sbgd non géré: '+sSGBDs[SGBD]);
       end;

     fAccueil_Log( ClassName+'.Initialise;, avant jsDataConnexion:= Classe_jsDataConnexion.Create;');
     jsDataConnexion:= Classe_jsDataConnexion.Create;
     fAccueil_Log( ClassName+'.Initialise;, avant jsDataConnexion.Prepare;');
     jsDataConnexion.Prepare;
     fAccueil_Log( ClassName+'.Initialise;, apréss jsDataConnexion.Prepare;');
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
end;

procedure TdmDatabase.Do_not_Keep_Connection;
begin
     if nil = jsDataConnexion then exit;

     jsDataConnexion.Do_not_Keep_Connection;
end;

procedure TdmDatabase.Keep_Connection;
begin
     if nil = jsDataConnexion then exit;

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

function TdmDatabase.Hote: String;
begin
     Result:= '';
     if nil = jsDataConnexion then exit;

     Result:= jsDataConnexion.HostName;
end;

function TdmDatabase.Database: String;
begin
     Result:= '';
     if nil = jsDataConnexion then exit;

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
     if nil = jsDataConnexion then exit;

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

{%endregion}

{ TamjsWorks }

procedure TamjsWorks.amjsWorksCreate(Sender: TObject);
begin

end;

procedure TamjsWorks.amjsWorksJNIPrompt(Sender: TObject);
var
   Filename: String;
   EnvironmentDirPath:String;
begin
     fAccueil_log_procedure:= Log;
     uForms_Android_ShowMessage:= Self.ShowMessage;
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, debut');
     Filename:= 'jsWorks.sqlite';
     EnvironmentDirPath:= GetEnvironmentDirectoryPath(dirDatabase);
     uEXE_INI_init_android( EnvironmentDirPath);
     tw.Text:= ClassName+'.amjsWorksJNIPrompt: Avant CopyFromAssetsToEnvironmentDir('+Filename+', '+EnvironmentDirPath+');';
     //CopyFromAssetsToEnvironmentDir(Filename, EnvironmentDirPath);
     //SQLite_Android.DataBase:= IncludeTrailingPathDelimiter( EnvironmentDirPath)+Filename;
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant SGBD_Set( sgbd_SQLite_Android);');
     SGBD_Set( sgbd_SQLite_Android);
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant Test_SQLite_Android;');
     Test_SQLite_Android( Filename);
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant dmDatabase.Initialise;');
     //dmDatabase.Initialise;
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant dmDatabase.Connection.DataBase:= Filename;');
     //dmDatabase.Connection.DataBase:= Filename;
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant dmDatabase.Ouvre_db;');
     //dmDatabase.Ouvre_db;
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant sda.DataBaseName:= Filename;');
     sda.DataBaseName:= Filename;
end;

procedure TamjsWorks.bDemarrerClick(Sender: TObject);
var
   bl: TblWork;
begin
     try
        writeln('avant bl:= poolWork.Start(0);')  ;
        bl:= poolWork.Start(0);
        if nil = bl
        then
            begin
            writeln('bl = nil');
            exit;
            end;
        writeln('avant tw.Text:= bl.Listing_Champs(#13#10);');
        tw.Text:= bl.Listing_Champs(#13#10);

					except
           on E: Exception
           do
             begin
             WriteLn( 'Exception : '#13#10
                      +E.Message+#13#10
                      +DumpCallStack);
             end;
					      end;
end;

procedure TamjsWorks.bOuvrirClick(Sender: TObject);
begin
     sda.OpenOrCreate(sda.DataBaseName);
     Show_tables;
end;

procedure TamjsWorks.Exec_query(_SQL: String);
var
   sl: TStringList;
   i: integer;
begin
     sl:= TStringList.Create;
     sl.StrictDelimiter:= True;
     sl.Delimiter:= sda.RowDelimiter;
     sl.DelimitedText:= sda.Select(_SQL);
     tw.Text:= sl.Text;
     sl.Free;
end;

procedure TamjsWorks.bStateClick(Sender: TObject);
begin
     Exec_query( 'SELECT * FROM State');
end;

procedure TamjsWorks.Show_tables;
begin
     Exec_query( 'SELECT name FROM sqlite_master WHERE type=''table''');
end;

procedure TamjsWorks.Log(_Message_Developpeur: String; _Message: String='');
begin
     ShowMessage( _Message_Developpeur)
end;

procedure TamjsWorks.Test_SQLite_Android( _Filename: String);
var
   sa: TSQLite_Android;
begin
     fAccueil_Log( ClassName+'.Test_SQLite_Android;, avant sa:= TSQLite_Android.Create;');
     sa:= TSQLite_Android.Create;
     fAccueil_Log( ClassName+'.Test_SQLite_Android;, aprés sa:= TSQLite_Android.Create;');
     try
        fAccueil_Log( ClassName+'.Test_SQLite_Android;, avant sa.Prepare;');
        sa.Prepare;
        fAccueil_Log( ClassName+'.Test_SQLite_Android;, aprés sa.Prepare;');
        fAccueil_Log( ClassName+'.Test_SQLite_Android;, avant sa.DataBase:= _Filename;');
        sa.DataBase:= _Filename;
        fAccueil_Log( ClassName+'.Test_SQLite_Android;, aprés sa.DataBase:= _Filename;');
        fAccueil_Log( ClassName+'.Test_SQLite_Android;, avant sa.Ouvre_db;');
        sa.Ouvre_db;
        fAccueil_Log( ClassName+'.Test_SQLite_Android;, aprés sa.Ouvre_db;');
					finally
            FreeAndNil( sa);
					       end;
end;

end.
