unit ufpBas;
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
    u_loc_Formes,
    uUseCases,
    uSGBD,
    uClean,
    uEtat,
    uPublieur,

    ufBatpro_Desk,
    ufBatpro_Form,
    ufAccueil,

  Windows, Messages, SysUtils, Classes, FMX.Graphics, FMX.Controls, FMX.Forms, Dialogs,
  StdCtrls, Buttons, ExtCtrls, ComCtrls, ActnList, FMX.Menus;

type
 TfpBas
 =
  class(TfBatpro_Form)
    al: TActionList;
    pBas: TPanel;
    pFermer: TPanel;
    bAbandon: TBitBtn;
    StatusBar1: TStatusBar;
    bValidation: TBitBtn;
    aValidation: TAction;
    aAbandon: TAction;
    sLog: TSplitter;
    pLog: TPanel;
    lLog: TLabel;
    mLog: TMemo;
    pmValidation: TPopupMenu;
    miModele: TMenuItem;
    miOPN_fpBas: TMenuItem;
    miValidation_fAccueil: TMenuItem;
    miOPN_Requeteur_fpBas: TMenuItem;
    miValidation_AfficherLog: TMenuItem;
    miClassName: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure aValidationExecute(Sender: TObject);
    procedure aAbandonExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure mLogMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure miModeleClick(Sender: TObject);
    procedure miOPN_fpBasClick(Sender: TObject);
    procedure miValidation_fAccueilClick(Sender: TObject);
    procedure miOPN_Requeteur_fpBasClick(Sender: TObject);
    procedure miValidation_AfficherLogClick(Sender: TObject);
  //Gestion du cycle de vie
  public
    constructor Create( _Owner: TComponent); override;
    destructor Destroy; override;
  //Gestion du Log
  private
    FAfficher_Log: Boolean;
    procedure SetAfficher_Log( Value: Boolean);
    procedure LogChange;
    procedure AfficheLog; //pour abonnement à fAccueil
  public
    property Afficher_Log: Boolean read FAfficher_Log write SetAfficher_Log;
  //Titre boutons
  protected
    procedure Traite_Titres_Boutons;
  //Gestion de l'exécution
  protected
    Parametres_Valide: Boolean;
    procedure Parametres_from_; virtual;
    procedure Action( _Action: String); virtual;
  //pré- et post- exécution
  protected
    Valide: Boolean;
    function PreExecute: Boolean; override;
    procedure PostExecute; override;
  public
    pPostExecute: TPublieur;
  //Accés à la liste d'actions
  protected
    function ActionList: TActionList; override;
  //OPN_Requeteur
  public
    function OPN_Requeteur_SQL: String; virtual;
  end;

var
   ufpBas_fMot_de_passe_Modele_OOo_OK: function : Boolean of object= nil;

implementation

{$R *.dfm}

{ TfpBas }

constructor TfpBas.Create(_Owner: TComponent);
begin
     inherited;
     pPostExecute:= TPublieur.Create( ClassName+'.pPostExecute');
     miClassName.Caption:= 'Nom de la classe: '+ClassName;
end;

destructor TfpBas.Destroy;
begin
     Free_nil( pPostExecute);
     inherited;
end;

procedure TfpBas.FormCreate(Sender: TObject);
begin
     inherited;
     if not bValidation.Visible
     then
         uForms_ShowMessage( 'Point à signaler au développeur'#13#10+
                      Name+': bValidation.Visible= False ');

     Traite_Titres_Boutons;
     Execute_non_modal:= False;
end;

procedure TfpBas.FormDestroy(Sender: TObject);
begin
     fAccueil.publieur_LogChange.Desabonne( Self, LogChange);
     inherited;
end;

procedure TfpBas.Traite_Titres_Boutons;
begin
     if not bAbandon.Visible
     then
         begin
         bValidation.Kind:= bkClose;
         bValidation.Caption:= loc_Fermer;
         aValidation.Caption:= loc_Fermer;
         aAbandon.ShortCut:= scNone;
         end;
end;

procedure TfpBas.aValidationExecute(Sender: TObject);
begin
     //uClean_Log( ClassName+'aValidationExecute');
     //uForms_ShowMessage( ClassName+'aValidationExecute');
     Valide:= True;
     if Execute_non_modal
     then
         begin
         if Execute_Running
         then
             begin
             PostExecute;
             Affiche_Precedente;
             end;
         end
     else
         begin
         if     Execute_Running
            or (fsModal in FFormState)
         then
             if bAbandon.Visible
             then
                 ModalResult:= mrOK
             else
                 Close
         else
             Hide;
         end;
end;

procedure TfpBas.aAbandonExecute(Sender: TObject);
begin
     //uClean_Log( ClassName+'aAbandonExecute');
     //uForms_ShowMessage( ClassName+'aAbandonExecute');

     if Execute_Running and Execute_non_modal
     then
         begin
         PostExecute;
         Affiche_Precedente;
         end;

     if     Execute_Running
        or (fsModal in FFormState)
     then
         if bAbandon.Visible
         then
             ModalResult:= mrCancel
         else
             Close
     else
         Hide;
end;

procedure TfpBas.LogChange;
begin
     mLog.Text:= fAccueil.mHistorique.Text;
     Memo_Goto_end( mLog);
end;

procedure TfpBas.SetAfficher_Log(Value: Boolean);
const
     HauteurLog = 50;
begin
     if FAfficher_Log = Value then exit;

     FAfficher_Log:= Value;

     if FAfficher_Log
     then
         begin
         if Batpro_Desk and Execute_non_modal
         then
             fBatpro_Desk.ClientHeight:= fBatpro_Desk.ClientHeight+HauteurLog;
         ClientHeight:= ClientHeight  + HauteurLog;
         with pLog do Height:= Height + HauteurLog;
         end
     else
         begin
         ClientHeight:= ClientHeight  - HauteurLog;
         with pLog do Height:= Height - HauteurLog;
         end;

     pLog.Visible:= FAfficher_Log;
     sLog.Visible:= FAfficher_Log;
     if FAfficher_Log
     then
         begin
         sLog.Top:= pLog.Top;
         fAccueil.publieur_LogChange.Abonne( Self, LogChange);
         LogChange;
         end
     else
         begin
         fAccueil.publieur_LogChange.Desabonne( Self, LogChange);
         end;

     Dimensionner;

     Refresh;
end;

procedure TfpBas.AfficheLog; //pour abonnement à fAccueil
begin
     if not Is_Sommet_Execute then exit;
     Afficher_Log:= True;
end;

procedure TfpBas.FormShow(Sender: TObject);
begin
     inherited;
     //LogChange;
end;

procedure TfpBas.mLogMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if    (mbRight = Button)
        and(ssCtrl in Shift)
     then
         fAccueil.Execute;
end;

procedure TfpBas.miModeleClick(Sender: TObject);
begin
     if not Assigned( ufpBas_fMot_de_passe_Modele_OOo_OK) then exit;
     if not ufpBas_fMot_de_passe_Modele_OOo_OK            then exit;
     Action( 'M');
end;

procedure TfpBas.Parametres_from_;
begin
     Parametres_Valide:= True;
end;

procedure TfpBas.Action( _Action: String);
begin
     Parametres_from_;
end;

function TfpBas.PreExecute: Boolean;
begin
     Result:= inherited PreExecute;
     Valide:= False;
     fAccueil.pAfficheLog.Abonne( Self, AfficheLog);
     bValidation.Kind:= bkCustom;
     bAbandon   .Kind:= bkCustom;
     bValidation.ModalResult:= mrNone;
     bAbandon   .ModalResult:= mrNone;
     bValidation.Action:= aValidation;
     bAbandon.Action:= aAbandon;
     miValidation_AfficherLog.Checked:= Afficher_Log;
end;

procedure TfpBas.PostExecute;
begin
     inherited;
     fAccueil.pAfficheLog.Desabonne( Self, AfficheLog);
     Afficher_Log:= False;
     pPostExecute.Publie;
end;

function TfpBas.ActionList: TActionList;
begin
     Result:= al;
end;

procedure TfpBas.miOPN_fpBasClick(Sender: TObject);
begin
     uClean_OPN;
end;

procedure TfpBas.miOPN_Requeteur_fpBasClick(Sender: TObject);
begin
     uClean_OPN_Requeteur( OPN_Requeteur_SQL);
end;

procedure TfpBas.miValidation_fAccueilClick(Sender: TObject);
begin
     fAccueil.Show;
end;

procedure TfpBas.miValidation_AfficherLogClick(Sender: TObject);
begin
     with miValidation_AfficherLog do Checked:= not Checked;
     Afficher_Log:= miValidation_AfficherLog.Checked;
end;

function TfpBas.OPN_Requeteur_SQL: String;
begin
     Result:= '';
end;

end.

