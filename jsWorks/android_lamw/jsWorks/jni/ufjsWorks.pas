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
unit ufjsWorks;

{$mode delphi}

interface

uses
    uForms,
    uEXE_INI,
    ujsDataContexte,
    uSGBD,
    uSQLite_Android,
    uLog,
    uAndroid_Database,
    uChamps,

    uParametres_Ligne_de_commande,

    ublWork,

    udmDatabase,
    upool,
    upoolWork,

    ufAccueil_Erreur, 
    ufTest_SQLiteDataAccess,
    ufUtilitaires, ufWork,
  Classes, SysUtils, DB,Laz_And_Controls,AndroidWidget, menu, And_jni, uchChamp_Edit;

type
 { TfjsWorks }

 TfjsWorks
 =
  class(jForm)
    bDemarrer: jButton;
    jceBeginning: jEditText;
    jceEnd: jEditText;
    jceDescription: jEditText;
    hceBeginning  : ThChamp_Edit;
    hceEnd        : ThChamp_Edit;
    hceDescription: ThChamp_Edit;
    jm: jMenu;
    jpBeginning: jPanel;
    jpEnd: jPanel;
    jTextView3: jTextView;
    lDebut: jTextView;
    lDescription: jTextView;
    lFin: jTextView;
    procedure bDemarrerClick(Sender: TObject);
    procedure bWorkClick(Sender: TObject);
    procedure fjsWorksJNIPrompt(Sender: TObject);
    procedure fjsWorksCreateOptionMenu   ( Sender: TObject; jObjMenu: jObject);
    procedure fjsWorksClickOptionMenuItem( Sender: TObject; jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
  private
    Filename: String;
    procedure LogP( _Message_Developpeur: String; _Message: String = '');
  //Connexion
  private
   procedure Test_SQLite_Android( _Filename: String);
  //poolWork
  private
    procedure test_poolWork;
  //Test TParams
  private
    procedure Test_TParams;
  //Work
  private
    bl: TblWork;
  end;

var
  fjsWorks: TfjsWorks;

implementation
  
{$R *.lfm}

{ TfjsWorks }

procedure TfjsWorks.bWorkClick(Sender: TObject);
begin
     fWork.Show;
end;

procedure TfjsWorks.bDemarrerClick(Sender: TObject);
begin
     try
        try
           Log.PrintLn( 'avant bl:= poolWork.Start(0);')  ;
           bl:= poolWork.Start(0);
           if nil = bl
           then
               begin
               Log.PrintLn( 'bl = nil');
               exit;
               end;
           Log.PrintLn( 'avant tw.Text:= bl.Listing_Champs(#13#10);');
           Log.PrintLn( bl.Listing_Champs(#13#10));

           bl.Description:= 'Test';
           WriteLn( ClassName+'.Edit, avant Champs_Affecte');
           Champs_Affecte( bl, [hceBeginning, hceEnd, hceDescription]);
           WriteLn( ClassName+'.Edit, aprés Champs_Affecte');
     	except
              on E: Exception
              do
                begin
                Log.PrintLn( 'Exception : '#13#10
                         +E.Message+#13#10
                         +DumpCallStack);
                end;
     	      end;

     finally
            //fTest_SQLiteDataAccess.Dump_LastWork;
            end;
end;

var compteur: integer=0;
procedure TfjsWorks.fjsWorksJNIPrompt(Sender: TObject);
begin
     inc(compteur);Writeln( ClassName+'.amjsWorksJNIPrompt, compteur=',compteur);
     Filename:= 'jsWorks.sqlite';
     uSQLite_Android_jForm:= Self;
     fAccueil_log_procedure:= LogP;
     uForms_Android_ShowMessage:= Self.ShowMessage;
     //uSQLite_Android_sc := fTest_SQLiteDataAccess.sc ;
     //uSQLite_Android_sda:= fTest_SQLiteDataAccess.sda;
     //uPool_Default_jsDataConnexion:= am;
     uAndroid_Database_Traite_Environment( Self);

     //fAccueil_Log( ClassName+'.amjsWorksJNIPrompt, avant SGBD_Set( sgbd_SQLite_Android);');
     SGBD_Set( sgbd_SQLite_Android);

     //Test_SQLite_Android( Filename);

     dmDatabase.Initialise;
     dmDatabase.jsDataConnexion.DataBase:= Filename;

     //Test_TParams;

     //test_poolWork;

     Show;
end;

procedure TfjsWorks.fjsWorksCreateOptionMenu( Sender: TObject; jObjMenu: jObject);
begin
     jm.AddItem( jObjMenu, 1, 'jsWorks'              , 'ic_launcher', mitDefault, misIfRoomWithText);
     jm.AddItem( jObjMenu, 2, 'Test_SQLiteDataAccess', 'ic_launcher', mitDefault, misIfRoomWithText);
     jm.AddItem( jObjMenu, 3, 'Utilitaires'          , 'ic_launcher', mitDefault, misIfRoomWithText);
     jm.AddItem( jObjMenu, 4, 'Work'                 , 'ic_launcher', mitDefault, misIfRoomWithText);
end;

procedure TfjsWorks.fjsWorksClickOptionMenuItem( Sender: TObject; jObjMenuItem: jObject; itemID: integer; itemCaption: string; checked: boolean);
begin
     case itemID
     of
       1: fjsWorks                        .Show;
       2: fTest_SQLiteDataAccess(Filename).Show;
       3: fUtilitaires          (Filename).Show;
       4: fWork                           .Show;
       end;
end;

procedure TfjsWorks.LogP( _Message_Developpeur: String; _Message: String= '');
begin
     Log.PrintLn( _Message+_Message_Developpeur);
end;

procedure TfjsWorks.Test_SQLite_Android( _Filename: String);
var
   sa: TSQLite_Android;
   s: String;
begin
     Log.PrintLn( ClassName+'.Test_SQLite_Android;, avant sa:= TSQLite_Android.Create;');
     sa:= TSQLite_Android.Create( SGBD);
     Log.PrintLn( ClassName+'.Test_SQLite_Android;, aprés sa:= TSQLite_Android.Create;');
     try
        Log.PrintLn( ClassName+'.Test_SQLite_Android;, avant sa.Prepare;');
        sa.Prepare;
        Log.PrintLn( ClassName+'.Test_SQLite_Android;, aprés sa.Prepare;');
        Log.PrintLn( ClassName+'.Test_SQLite_Android;, avant sa.DataBase:= _Filename;');
        sa.DataBase:= _Filename;
        Log.PrintLn( ClassName+'.Test_SQLite_Android;, aprés sa.DataBase:= _Filename;');
        Log.PrintLn( ClassName+'.Test_SQLite_Android;, avant sa.Ouvre_db;');
        sa.Ouvre_db;
        Log.PrintLn( ClassName+'.Test_SQLite_Android;, aprés sa.Ouvre_db;');
        Log.PrintLn( ClassName+'.Test_SQLite_Android;, avant sa.jsdc.sResultat_from_Requete;');
        s:= sa.jsdc.sResultat_from_Requete( 'SELECT * FROM State');
        WriteLn( s);
        Log.PrintLn( ClassName+'.Test_SQLite_Android;, aprés sa.jsdc.sResultat_from_Requete;');
					finally
            FreeAndNil( sa);
					       end;
end;

procedure TfjsWorks.test_poolWork;
var
   pw: TpoolWork;
var
   bl: TblWork;
begin
     Log.PrintLn( ClassName+'.test_poolWork;, avant pw:= TpoolWork.Create( nil);');
     pw:= TpoolWork.Create( nil);
     Log.PrintLn( ClassName+'.test_poolWork;, aprés pw:= TpoolWork.Create( nil);');
     try
        try
           Log.PrintLn( 'avant bl:= poolWork.Start(0);')  ;
           bl:= pw.Start(0);
           if nil = bl
           then
               begin
               Log.PrintLn( 'bl = nil');
               exit;
               end;
           Log.PrintLn( 'avant tw.Text:= bl.Listing_Champs(#13#10);');
           Log.PrintLn( bl.Listing_Champs(#13#10));
   					except
              on E: Exception
              do
                begin
                Log.PrintLn( 'Exception : '#13#10
                         +E.Message+#13#10
                         +DumpCallStack);
                end;
   					      end;
					finally
            FreeAndNil( pw);
            fTest_SQLiteDataAccess(Filename).Dump_LastWork;
					       end;
end;

procedure TfjsWorks.Test_TParams;
var
   p: TParams;
begin
     Log.PrintLn( ClassName+'.Test_TParams;, début');
     p:= TParams.Create;
     Log.PrintLn( ClassName+'.Test_TParams;, aprés p:= TParams.Create;');
     try
	      try
          Log.PrintLn( ClassName+'.Test_TParams;, avant p.Clear;');
	         p.Clear;
          Log.PrintLn( ClassName+'.Test_TParams;, aprés p.Clear;');
						 except
	            on E: Exception
	            do
	              begin
	              Log.PrintLn( 'Exception : '#13#10
	                       +E.Message+#13#10
	                       +DumpCallStack);
	              end;
						       end;
					finally
            FreeAndNil( p);
					       end;
end;

end.


