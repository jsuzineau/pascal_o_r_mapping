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

    udmDatabase,
    upool,
    upoolWork,

    ufAccueil_Erreur,
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
		AndroidWidget;

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
  //Connexion
  private
   sa: TSQLite_Android;
  end;

var
  amjsWorks: TamjsWorks;

implementation
  
{$R *.lfm}

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
     uPool_Default_jsDataConnexion:= sa;
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant dmDatabase.Initialise;');
     dmDatabase.Initialise;
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant dmDatabase.Connection.DataBase:= Filename;');
     dmDatabase.jsDataConnexion.DataBase:= Filename;
     fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant dmDatabase.Ouvre_db;');
     dmDatabase.Ouvre_db;
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
            //FreeAndNil( sa);
					       end;
end;

end.
