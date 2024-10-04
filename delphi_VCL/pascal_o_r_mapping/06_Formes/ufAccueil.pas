unit ufAccueil;
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
    uForms,
    uOD_Forms,
    uOD_Error,
    uBatpro_StringList,
    uPublieur,
    uVersion,
    //uFTP,
    uNetwork,
    uLog,
    uWinUtils,

    udmDatabase,

    //udllOOoDelphiReportEngineAutomation_Register,// pour assurer l'initialisation
    ufBatpro_Informix,
    ufBatpro_MySQL,
    ufBatpro_Parametres_Client,

  Windows, Messages, SysUtils, Classes,
  VCL.Graphics, VCL.Controls, VCL.Forms, VCL.Dialogs,
  VCL.ExtCtrls, VCL.StdCtrls, DB,
  System.UITypes, Vcl.ComCtrls, Vcl.Buttons;

type
 TfAccueil
 =
  class(TForm)
    Label1: TLabel;
    mHistorique_Developpeur: TMemo;
    Panel2: TPanel;
    bOK: TBitBtn;
    bEnregistrer: TButton;
    SaveDialog: TSaveDialog;
    bTerminer: TButton;
    bTuer: TButton;
    tRefresh: TTimer;
    tsHistorique_Developpeur: TTabSheet;
    tExecute: TTimer;
    cbErreurModal: TCheckBox;
    Label2: TLabel;
    gbEnvoyer: TGroupBox;
    bFTP: TButton;
    bMail: TButton;
    bInformix: TButton;
    bMySQL: TButton;
    bVariables_d_environnement: TButton;
    pc: TPageControl;
    tsErreur_Courante: TTabSheet;
    tsLigne_Courante: TTabSheet;
    m: TMemo;
    tsHistorique: TTabSheet;
    mHistorique: TMemo;
    Panel1: TPanel;
    bTeleassistance: TButton;
    bParametres: TButton;
    Panel3: TPanel;
    Panel4: TPanel;
    Panel5: TPanel;
    bOPN: TButton;
    bOPN_Requeteur: TButton;
    procedure bEnregistrerClick(Sender: TObject);
    procedure bTerminerClick(Sender: TObject);
    procedure bTuerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tExecuteTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bMailClick(Sender: TObject);
    procedure bFTPClick(Sender: TObject);
    procedure bInformixClick(Sender: TObject);
    procedure bMySQLClick(Sender: TObject);
    procedure bVariables_d_environnementClick(Sender: TObject);
    procedure bTeleassistanceClick(Sender: TObject);
    procedure bParametresClick(Sender: TObject);
    procedure Panel2MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure pcChange(Sender: TObject);
    procedure bOPNClick(Sender: TObject);
    procedure bOPN_RequeteurClick(Sender: TObject);
    procedure tRefreshTimer(Sender: TObject);
  private
    procedure Add( _S_Developpeur, _S: String);
    procedure Add_Developpeur( _S_Developpeur: String);
    function Afficher: Boolean;
    procedure SendMail;
  public
    publieur_LogChange: TPublieur;

    Has_Log: Boolean;
    Has_Errors: Boolean;
    function Get_Has_Log: Boolean;
    procedure Set_Has_Log( _Has_Log: Boolean);
    procedure Log( _Message_Developpeur: String; _Message: String = '');
    function Erreur( _Message_Developpeur: String; _Message: String = ''): Boolean;
    function Execute: Boolean;
    procedure Affichage_Boutons_Erreur(is_Error: Boolean);
    procedure Affichage_Bouton_OK(Afficher: Boolean);
    procedure Add_File(NomFichier: String; Debut, Fin: Char);
    procedure Send_Errors;
  //Log d'une ligne de dataset
  public
    procedure Dataset_Log_row( ds: TDataset);
  //Affichage lisible
  private
    procedure Affichage_lisible;
  //Publication d'une demande d'affichage du log
  private
    LogBas_running: Boolean;
  public
    pAfficheLog: TPublieur;
    procedure LogBas( _Message_Developpeur: String; _Message: String = '');//log avec affichage en bas de la fenêtre courante
    procedure LogBas_ShowMessage( _Message_Developpeur: String; _Message: String = '');//log avec affichage en bas de la fenêtre courante
  //Messages d'erreur Opendocument
  private
    procedure Erreur_OpenDocument( _Message: String);
  end;

function fAccueil: TfAccueil;

procedure Memo_Goto_end( _Memo: TMemo);

implementation

uses
    u_sys_,
    uuStrings,
    uParametres_Ligne_de_commande,
    uMailTo,
    uClean, ufAccueil_Erreur;

{$R *.dfm}

procedure Memo_Goto_end( _Memo: TMemo);
begin
     _Memo.SelStart:= Length( _Memo.Text)-1;
     _Memo.SelLength:= 1;
end;

{ TfAccueil }
var
   FfAccueil: TfAccueil;

function fAccueil: TfAccueil;
begin
     Clean_Get( Result, FfAccueil, TfAccueil);
end;

procedure TfAccueil.FormCreate(Sender: TObject);
begin
     inherited;
     Label1.Caption:= uOD_Forms_Title + ' - ' + GetVersionProgramme;
     publieur_LogChange:= TPublieur.Create('fAccueil.publieur_LogChange');
     pAfficheLog       := TPublieur.Create('fAccueil.pAfficheLog');
     Has_Log:= False;
     Has_Errors:= False;
     LogBas_running:= False;
     OD_Error.CallBack:= Erreur_OpenDocument;
end;

procedure TfAccueil.FormDestroy(Sender: TObject);
begin
     OD_Error.CallBack:= nil;
     tExecute.Enabled:= False;
     Free_nil( publieur_LogChange);
     Free_nil( pAfficheLog);
     inherited;
end;

procedure TfAccueil.SendMail;
var
   Body: String;
begin
     if mrYes<>MessageDlg('Souhaitez vous envoyer automatiquement par mail les '+
                          'messages d''erreurs à Batpro ?', mtConfirmation,
                          [mbYes, mbNo], 0)
     then
         exit;


     Body:=   ParamStr(0)                   +#13#10
             + 'Version '+GetVersionProgramme+#13#10
             + mHistorique_Developpeur.Lines.Text;


     //MailTo_Batpro( ChangeFileExt( ExtractFileName( ParamStr(0)), sys_Vide),
     //               Body, []);
end;

function TfAccueil.Afficher: Boolean;
begin
     Result:= ModeDEBUG_3;
end;

procedure TfAccueil.Add_Developpeur( _S_Developpeur: String);
var
   S_Developpeur: String;
   procedure Publie;
   var
      Old_uPublieur_Log_Publications: Boolean;
   begin
         Old_uPublieur_Log_Publications:= uPublieur_Log_Publications;
         try
            uPublieur_Log_Publications:= False;
            publieur_LogChange.Publie;
         finally
                uPublieur_Log_Publications:= Old_uPublieur_Log_Publications;
                end;
   end;
begin
     S_Developpeur
     :=
         FormatDateTime( 'ddddd tt', Now)+#13#10
       + _S_Developpeur;

     m.Text:= S_Developpeur;

     mHistorique_Developpeur.Lines.Add( S_Developpeur);

     if LogBas_running
     then
         Publie;
end;

procedure TfAccueil.Add( _S_Developpeur, _S: String);
var
   S_Developpeur: String;
   procedure Publie;
   var
      Old_uPublieur_Log_Publications: Boolean;
   begin
         Old_uPublieur_Log_Publications:= uPublieur_Log_Publications;
         try
            uPublieur_Log_Publications:= False;
            publieur_LogChange.Publie;
         finally
                uPublieur_Log_Publications:= Old_uPublieur_Log_Publications;
                end;
   end;
begin
     m.Text:= _S;

     mHistorique.Lines.Add( _S);

     S_Developpeur:= FormatDateTime( 'ddddd tt', Now);
     Formate_Liste( S_Developpeur, #13#10, _S);
     Formate_Liste( S_Developpeur, #13#10, _S_Developpeur);


     mHistorique_Developpeur.Lines.Add( S_Developpeur);

     if LogBas_running
     then
         Publie;
end;

procedure TfAccueil.Affichage_Boutons_Erreur( is_Error: Boolean);
begin
     bTerminer.Visible:= is_Error;
     bTuer    .Visible:= is_Error;
end;

procedure TfAccueil.Affichage_Bouton_OK(Afficher: Boolean);
begin
     bOK.Visible:= Afficher;
     if Afficher
     then
         bOK.SetFocus;
end;

procedure TfAccueil.Log( _Message_Developpeur: String; _Message: String = '');
begin
     Has_Log:= True;

     //Visible:= True;
     Affichage_Boutons_Erreur( False);
     Affichage_Bouton_OK( False);

     if _Message = ''
     then
         Add_Developpeur( _Message_Developpeur)
     else
         Add( _Message_Developpeur, _Message);

     //Visible:= False;
     if Afficher
     then
         begin
         Show;
         Refresh;
         end;
end;

procedure TfAccueil.Add_File( NomFichier: String; Debut, Fin: Char);
var
   sl: TBatpro_StringList;
begin
     if FileExists( NomFichier)
     then
         begin
         sl:= TBatpro_StringList.Create;
         try
            sl.LoadFromFile( NomFichier);
            Log( ChaineDe(80, Debut)+sys_N+
                 sl.Text+sys_N+
                 ChaineDe(80, Fin  ));
         finally
                free_nil( sl);
                end;
         end;
end;

function TfAccueil.Erreur( _Message_Developpeur: String; _Message: String = ''): Boolean;
     procedure Do_Show;
     begin
         Show;
         Refresh;
         Result:= True;
     end;
     procedure Do_ShowModal;
     begin
          try
             Result:= ShowModal = mrOK
          except
                on E: Exception
                do
                  Do_Show;
                end;
     end;
begin
     Has_Errors:= True;
     Visible:= True;

     Affichage_Boutons_Erreur( True);
     Affichage_Bouton_OK( True);

     if _Message = ''
     then
         Add_Developpeur( _Message_Developpeur)
     else
         Add( _Message_Developpeur, _Message);
         
     pc.ActivePage:= tsHistorique_Developpeur; //bricolage avec tRefresh pour problèmes de rafraichissement sur Ubuntu
     //pc.ActivePage:= tsLigne_Courante;

     Visible:= False;
     tRefresh.Enabled:= True;
     if cbErreurModal.Checked
     then
         Do_ShowModal
     else
         Do_Show;

     bOK.Visible:= False;
     Visible:= Afficher;
end;

function TfAccueil.Execute: Boolean;
begin
     Has_Log:= False;
     Visible:= True;
     Affichage_Boutons_Erreur( False);
     Affichage_Bouton_OK( True);
     Visible:= False;
     tExecute.Enabled:= True;
     Result:= ShowModal = mrOK;
end;

procedure TfAccueil.bEnregistrerClick(Sender: TObject);
begin
     if SaveDialog.Execute
     then
         mHistorique_Developpeur.Lines.SaveToFile( SaveDialog.FileName);
end;

procedure TfAccueil.bTerminerClick(Sender: TObject);
begin
     uOD_Forms_Terminate;
end;

procedure TfAccueil.bTuerClick(Sender: TObject);
begin
     Halt;
end;

procedure TfAccueil.tExecuteTimer(Sender: TObject);
begin
     tExecute.Enabled:= False;
     pc.ActivePage:= tsHistorique;
     mHistorique.SetFocus;
     Add( ' ', ' ');
end;

procedure TfAccueil.bMailClick(Sender: TObject);
begin
     SendMail;
end;

procedure TfAccueil.Send_Errors;
begin
     if Has_Errors
     then
         bFTP.Click;
end;

procedure TfAccueil.Dataset_Log_row(ds: TDataset);
var
   I: Integer;
   F: TField;
   S: String;
begin
     S:= sys_Vide;
     for I:= 0 to ds.FieldCount-1
     do
       begin
       F:= ds.Fields[ I];
       if Assigned( F)
       then
           begin
           S:= S + F.FieldName + ': '+F.AsString+', ';
           end;
       end;
     Log( S);
end;

procedure TfAccueil.bFTPClick(Sender: TObject);
var
   NomFichier: String;
   NomZIPLogs: String;
   NomZIPLogs_Hier: String;
begin
     NomFichier
     :=
         dmDatabase.jsDataConnexion.DataBase + '_'
       + Network.Nom_Hote                + '_'
       + FormatDateTime( 'yyyy"_"mm"_"dd"_"hh"h"nn"min"ss', Now)
       + '_fAccueil.txt';
     NomZIPLogs
     :=
         dmDatabase.jsDataConnexion.DataBase + '_'
       + Network.Nom_Hote                + '_'
       + FormatDateTime( 'yyyy"_"mm"_"dd"_"hh"h"nn"min"ss', Now)
       + '_log.zip';
     NomZIPLogs_Hier
     :=
         dmDatabase.jsDataConnexion.DataBase + '_'
       + Network.Nom_Hote                + '_'
       + FormatDateTime( 'yyyy"_"mm"_"dd"_"hh"h"nn"min"ss', Now)
       + '_log_hier.zip';
     //FTP.PutStrings( mHistorique_Developpeur.Lines, NomFichier, False);
     //FTP.PutDirectoryZip( ExcludeTrailingPathDelimiter( uLog.Log.Repertoire), NomZIPLogs, False);
     //FTP.PutDirectoryZip( ExcludeTrailingPathDelimiter( uLog.Log.Repertoire_Hier), NomZIPLogs_Hier, False);
     MessageDlg('Transfert effectué avec succés', mtInformation, [mbOK], 0);
end;

procedure TfAccueil.bInformixClick(Sender: TObject);
begin
     fBatpro_Informix.ShowModal;
end;

procedure TfAccueil.bMySQLClick(Sender: TObject);
begin
     fBatpro_MySQL.ShowModal;
end;

procedure TfAccueil.bVariables_d_environnementClick(Sender: TObject);
begin
     Log( uForms_Variables_d_environnement);
end;

procedure TfAccueil.bTeleassistanceClick(Sender: TObject);
begin
     uForms_Lance_Programme( ExtractFilePath( uOD_Forms_EXE_Name)+ 'TeamViewerQS_fr.exe');
end;

procedure TfAccueil.bParametresClick(Sender: TObject);
begin
     fBatpro_Parametres_Client.Show;
end;

procedure TfAccueil.Panel2MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if Button = mbRight
     then
         Affichage_lisible;
end;

procedure TfAccueil.Affichage_lisible;
begin
     m.Font.Name:= 'Courier New';
     m.Font.Size:= 8;
end;

procedure TfAccueil.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Affichage_lisible;
end;

procedure TfAccueil.LogBas( _Message_Developpeur: String; _Message: String = '');
begin
     try
        LogBas_running:= True;
        Log( _Message_Developpeur, _Message);
        pAfficheLog.Publie;
     finally
            LogBas_running:= False;
            end;
end;

procedure TfAccueil.LogBas_ShowMessage( _Message_Developpeur, _Message: String);
begin
     uForms_ShowMessage( _Message_Developpeur);
     LogBas( _Message_Developpeur, _Message);
end;

procedure TfAccueil.pcChange(Sender: TObject);
begin
     if tsHistorique            =pc.ActivePage then Memo_Goto_end(mHistorique            )
else if tsHistorique_Developpeur=pc.ActivePage then Memo_Goto_end(mHistorique_Developpeur);
end;

procedure TfAccueil.bOPNClick(Sender: TObject);
begin
     uClean_OPN;
end;

procedure TfAccueil.bOPN_RequeteurClick(Sender: TObject);
begin
     uClean_OPN_Requeteur;
end;

procedure TfAccueil.tRefreshTimer(Sender: TObject);
begin
     pc.ActivePage:= tsLigne_Courante;
     tRefresh.Enabled:= False;
     m                      .Refresh;
     mHistorique            .Refresh;;
     mHistorique_Developpeur.Refresh;;
end;

procedure TfAccueil.Erreur_OpenDocument( _Message: String);
begin
     Erreur( _Message, 'Erreur OpenDocument');
end;

function TfAccueil.Get_Has_Log: Boolean;
begin
     Result:= Has_Log;
end;

procedure TfAccueil.Set_Has_Log(_Has_Log: Boolean);
begin
     Has_Log:= _Has_Log;
end;

initialization
              {$IFNDEF UNIX}//rajouté car plante sur Ubuntu 24.04, ok sur 22.04, erreurs dans libxml, librsvg
              Clean_Create ( FfAccueil, TfAccueil);
              fAccueil_Erreur_function := fAccueil.Erreur;
              fAccueil_log_procedure   := fAccueil.Log;
              fAccueil_LogBas_procedure:= fAccueil.LogBas;
              fAccueil_LogBas_ShowMessage_procedure:= fAccueil.LogBas_ShowMessage;
              fAccueil_Dataset_Log_row_procedure:= fAccueil.Dataset_Log_row;
              fAccueil_Has_Log_function:= fAccueil.Get_Has_Log;
              fAccueil_Set_Has_Log_procedure:= fAccueil.Set_Has_Log;
              fAccueil_Execute_function:= fAccueil.Execute;
              if ufAccueil_Erreur_Tampon <> ''
              then
                  fAccueil_Erreur( ufAccueil_Erreur_Tampon);
              {$ENDIF}
finalization
              fAccueil_Erreur_function := nil;
              fAccueil_log_procedure   := nil;
              fAccueil_LogBas_procedure:= nil;
              fAccueil_LogBas_ShowMessage_procedure:= nil;
              fAccueil_Dataset_Log_row_procedure:= nil;
              fAccueil_Has_Log_function:= nil;
              fAccueil_Set_Has_Log_procedure:= nil;
              fAccueil_Execute_function:= nil;
              Clean_Destroy( FfAccueil);
end.

