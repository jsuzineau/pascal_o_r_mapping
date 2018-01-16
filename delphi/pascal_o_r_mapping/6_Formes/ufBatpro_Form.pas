unit ufBatpro_Form;
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
    uEXE_INI,
    uWinUtils,
    uuStrings,
    uDataUtilsU,
    uAide,
    u_sys_,
    uPublieur,
    uBatpro_StringList,
    uEtat,
    uHorloge,

    ufBatpro_Desk,
    ufAccueil_Erreur,
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
  IniFiles, FMX.StdCtrls, FMX.ExtCtrls, DB, ucBatproMasque,
  Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Controls;

type
 TfBatpro_Form
  =
  class(TfBatpro_Form_Ancetre)
    pSociete: FMX.StdCtrls.TPanel;
    lSociete: FMX.StdCtrls.TLabel;
    lHeure: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  protected
    Execute_Running: Boolean;
    Maximiser: Boolean;
    procedure DoShow; override;
    procedure INIWriteInteger(Key: String; Value: Integer);
    function  INIReadInteger (Key: String; Default: Integer): Integer;
    procedure Dimensionner;
    procedure OnDesaffiche; virtual;
  public
    function Affiche_Precedente: Boolean; virtual;
    function Affiche: Boolean; virtual;
    procedure Assure_DataSource(C: TComponent; Defaut: TDatasource);
    procedure Horloge_Change; virtual;
    procedure Centre_sur_WORKAREA;
    procedure Dimensionne_sur_WORKAREA;
  //Animation
  public
    procedure Demarre_Animation;
    procedure Termine_Animation;
  //Affichage du bandeau d'entête
  public
    procedure Bandeau_from_;
  //Sommet de la pile d'appels à Execute
  public
    function Is_Sommet_Execute: Boolean;

  //indice dans la liste d'exécution
  private
    iExecute: Integer;
  //pré- et post- exécution
  protected
    Execute_non_modal: Boolean;
    function PreExecute: Boolean; virtual;
    procedure PostExecute; virtual;
  // Exécution
  public
    function Execute: Boolean; virtual;
    function Execute_quiet: Boolean;
  //Dimensions orginales
  private
    Original_Width, Original_Height: Integer;
  end;

var
   fAffiche: TfBatpro_Form = nil;
   ufBatpro_Form_slExecute: TBatpro_StringList;
   ufBatpro_Form_Bandeau_from_: TPublieur= nil;
   ufBatpro_Form_Couleur_societe: TColor= TColorRec.White;
   ufBatpro_Form_Nom_Societe: String= '';
   ufBatpro_Form_code_util: String= '';

function fBatpro_Form_from_sl( sl: TBatpro_StringList; Index: Integer): TfBatpro_Form;

procedure ufBatpro_Form_Demarre_Animation;
procedure ufBatpro_Form_Termine_Animation;

implementation

{$R *.dfm}

var
   Precedentes: TList;

function fBatpro_Form_from_sl( sl: TBatpro_StringList; Index: Integer): TfBatpro_Form;
var
   O: TObject;
begin
     Result:= nil;

     if sl = nil                        then exit;
     if (Index < 0)or(sl.Count<= Index) then exit;

     O:= sl.Objects[ Index];
     if O = nil                         then exit;
     if not (O is TfBatpro_Form)      then exit;

     Result:= TfBatpro_Form(O);
end;

function Get_fExecute: TfBatpro_Form;
begin
     Result:= fBatpro_Form_from_sl( ufBatpro_Form_slExecute,
                                    ufBatpro_Form_slExecute.Count-1);
end;

procedure fExecute_Show;
var
   f: TfBatpro_Form;
begin
     f:= Get_fExecute;
     if Assigned( f)
     then
         begin
         f.Show;
         //Application.MainForm:= f;
         end;
end;
procedure fExecute_Hide;
var
   f: TfBatpro_Form;
begin
     f:= Get_fExecute;
     if Assigned( f)
     then
         begin
         f.Hide;
         end;
end;

procedure ufBatpro_Form_Demarre_Animation;
var
   f: TfBatpro_Form;
begin
     f:= Get_fExecute;
     if Assigned( f)
     then
         f.Demarre_Animation;
end;

procedure ufBatpro_Form_Termine_Animation;
var
   f: TfBatpro_Form;
begin
     f:= Get_fExecute;
     if Assigned( f)
     then
         f.Termine_Animation;
end;

{ TfBatpro_Form }

procedure TfBatpro_Form.Centre_sur_WORKAREA;
var
   WorkArea: TRect;
   W, H: Integer;
begin
     {à revoir pour FMX
     SystemParametersInfo( SPI_GETWORKAREA, 0, @WorkArea, 0);
     W:= WorkArea.Right  - WorkArea.Left;
     H:= WorkArea.Bottom - WorkArea.Top ;
     Left:= WorkArea.Left + (W - Width ) div 2;
     Top := WorkArea.Top  + (H - Height) div 2;
     }
end;

procedure TfBatpro_Form.Dimensionne_sur_WORKAREA;
var
   WorkArea: TRect;
   W, H: Integer;
begin
     { à revoir pour FMX
     SystemParametersInfo( SPI_GETWORKAREA, 0, @WorkArea, 0);
     W:= WorkArea.Right  - WorkArea.Left;
     H:= WorkArea.Bottom - WorkArea.Top ;
     Left  := WorkArea.Left;
     Top   := WorkArea.Top ;
     Width := W;
     Height:= H;
     }
end;

procedure TfBatpro_Form.FormCreate(Sender: TObject);
var
   Message: String;
begin
     inherited;
     iExecute:= -1;
     Message
     :=#13#10+
       'Création de la fiche Delphi'#13#10+
       'Titre               : "%s"'#13#10+
       'Nom dans code source: %s';
     Message:= Format( Message, [ Caption, Name]);
     //fAccueil_Log( Message);
     fAccueil_Set_Has_Log( False);
     Etat.Change( 'Création de la fiche "'+Caption+'"');
     //Horloge.HeureChange.Abonne( Self, Horloge_Change);
     lHeure.Visible:= False;

     //à revoir pour FMX
     //OnHelp:= Objet_Aide.Aide;
     //HelpContext:= 1;
     //HelpFile:= Name;

     Execute_Running:= False;

     Original_Width := Width;
     Original_Height:= Height;

     Maximiser:= True;
     Centre_sur_WORKAREA;
     ufBatpro_Form_Bandeau_from_.Abonne( Self, Bandeau_from_);
end;

procedure TfBatpro_Form.FormDestroy(Sender: TObject);
var
   iPrecedentes: Integer;
begin
     ufBatpro_Form_Bandeau_from_.Desabonne( Self, Bandeau_from_);

     iPrecedentes:= Precedentes.IndexOf( Self);
     while iPrecedentes <> -1
     do
       begin
       Precedentes.Delete( iPrecedentes);
       iPrecedentes:= Precedentes.IndexOf( Self);
       end;

     if fAffiche = Self then fAffiche:= nil;

     //OnHelp:= nil;
     //Horloge.HeureChange.Desabonne( Self, Horloge_Change);
     inherited;
end;

procedure TfBatpro_Form.Dimensionner;
begin
     if Maximiser
     then
         begin
         if Batpro_Desk
         then
             fBatpro_Desk.Dimensionne_sur_WORKAREA
         else
             Dimensionne_sur_WORKAREA;
         end
     else
         begin
         if Batpro_Desk
         then
             fBatpro_Desk.Centre_sur_WORKAREA( Original_Width, Original_Height)
         else
             begin
             Width := Original_Width ;
             Height:= Original_Height;
             Centre_sur_WORKAREA;
             end;
         end;
end;

function TfBatpro_Form.Affiche: Boolean;
begin
     if Batpro_Desk
     then
         fBatpro_Desk.Hide;

     if fAffiche <> Self
     then
         begin
         if Assigned( fAffiche)
         then
             begin
             fAffiche.OnDesaffiche;
             fAffiche.Hide;
             end;
         fAffiche:= Self;

         Precedentes.Add( Self);
         end;

     Dimensionner;

     if Batpro_Desk
     then
         begin
         //à revoir pour FMX
         //ManualDock( fBatpro_Desk, nil, alClient);
         fBatpro_Desk.FenetreCourante:= Self;
         fBatpro_Desk.Caption:= Caption;
         //Align:= alClient;
         //Left:= 0;
         //Top:= 0;
         //Width := fBatpro_Desk.ClientWidth ;
         //Height:= fBatpro_Desk.ClientHeight;
         end;
     Show;

     if Batpro_Desk
     then
         fBatpro_Desk.Show;
     Result:= True;
end;

function TfBatpro_Form.PreExecute: Boolean;
begin
     Result:= True;
     //fExecute_Hide;

     iExecute:= -1;
     if not Batpro_Desk
     then
         Dimensionner;
     Execute_Running:= True;
     iExecute:= ufBatpro_Form_slExecute.AddObject( sys_Vide, Self);
end;

procedure TfBatpro_Form.PostExecute;
begin
     Execute_Running:= False;
     if iExecute <> -1
     then
         ufBatpro_Form_slExecute.Delete( iExecute);

     //fExecute_Show;
end;

function TfBatpro_Form.Execute: Boolean;
   procedure Cas_non_Modal;
   begin
        Result:= PreExecute;
        Affiche;
   end;
   procedure Cas_Modal;
   begin
        try
           Result:= PreExecute;
           if not Result then exit;

           Result:= ShowModal = mrOK;
           //ShowModal;
           //Result:= True;
        finally
               PostExecute;
               end;
   end;
begin
     if Execute_non_modal
     then
         Cas_non_Modal
     else
         Cas_Modal;
end;

function TfBatpro_Form.Execute_quiet: Boolean;
begin
     Result:= PreExecute;
     PostExecute;
end;

procedure TfBatpro_Form.Assure_DataSource( C: TComponent;  Defaut: TDatasource);
begin
     uDataUtilsU.Assure_Datasource( Name, C, Defaut);
end;

procedure TfBatpro_Form.Bandeau_from_;
var
   N: Single;
   SD: String;
begin
     SD:= FormatDateTime( 'dddddd', Now);
     N:= NbChars( lSociete.Font, lSociete.Width);
     //pSociete.Color:= ufBatpro_Form_Couleur_societe;
     //lSociete.Color:= ufBatpro_Form_Couleur_Societe;
     lHeure.Color  := ufBatpro_Form_Couleur_Societe;
     lSociete.Text:= Justifie( [ufBatpro_Form_code_util+' '+ufBatpro_Form_Nom_Societe,SD], Trunc(N));
end;

procedure TfBatpro_Form.DoShow;
   procedure PreExecute;
   //var
   //   I: Integer;
   //   C: TComponent;
   //   bm: TBatproMasque;
   begin
        //for I:= 0 to ComponentCount-1
        //do
        //  begin
        //  C:= Components[ I];
        //  if C is TBatproMasque
        //  then
        //      begin
        //      bm:= TBatproMasque( C);
        //      bm.PreExecute;
        //      end;
        //  end;
   end;
begin
     Bandeau_from_;
     inherited DoShow;
     PreExecute;
end;

procedure TfBatpro_Form.Horloge_Change;
begin
     lHeure.Caption:= '>'+FormatSettings.ThousandSeparator+'<'+Horloge.sHeure;
     lHeure.Refresh;
end;

procedure TfBatpro_Form.INIWriteInteger(Key: String; Value: Integer);
begin
     EXE_INI.WriteInteger( Name, Key, Value);
end;

function TfBatpro_Form.INIReadInteger(Key: String; Default: Integer): Integer;
begin
     Result:= EXE_INI.ReadInteger( Name, Key, Default);
end;

procedure TfBatpro_Form.OnDesaffiche;
begin

end;

function TfBatpro_Form.Affiche_Precedente: Boolean;
var
   Precedente: TfBatpro_Form;
   Precedentes_Count: Integer;
begin
     Precedentes_Count:= Precedentes.Count;

     //contient au moins self et une autre
     Result:= Precedentes_Count > 1;
     if not Result
     then
         begin
         if Batpro_Desk
         then
             begin
             fBatpro_Desk.Close;
             fBatpro_Desk.FenetreCourante:= nil;
             end;
         exit;
         end;

     //la courante est bien self
     Result:= Self = TfBatpro_Form( Precedentes.Items[Precedentes_Count-1]);
     if not Result then exit;

     Precedente:= TfBatpro_Form( Precedentes.Items[Precedentes_Count-2]);

     Precedentes.Delete( Precedentes_Count-1);
     Precedentes.Delete( Precedentes_Count-2);

     //juste par sécurité
     Result:= Assigned( Precedente);
     if not Result then exit;

     Precedente.Affiche;
end;

procedure TfBatpro_Form.Demarre_Animation;
begin
     //animation.Active := True;
end;

procedure TfBatpro_Form.Termine_Animation;
begin
     //animation.Active := False;
end;

function TfBatpro_Form.Is_Sommet_Execute: Boolean;
begin
     Result:= Self = Get_fExecute;
end;

procedure TfBatpro_Form.FormClose(Sender: TObject; var Action: TCloseAction);
begin
     if Execute_Running and Execute_non_modal
     then
         begin
         PostExecute;
         Affiche_Precedente;
         end;
end;

initialization
              Precedentes:= TList.Create;
              ufBatpro_Form_slExecute:= TBatpro_StringList.Create;
              ufBatpro_Form_Bandeau_from_:= TPublieur.Create( 'ufBatpro_Form_Bandeau_from_');
finalization
            Free_nil( ufBatpro_Form_Bandeau_from_);
            Free_nil( ufBatpro_Form_slExecute    );
            Free_nil( Precedentes                );
end.


