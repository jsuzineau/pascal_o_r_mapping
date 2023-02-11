unit ufFacture_Nouveau;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    uChamps,
    uDataUtilsU,
    uBatpro_StringList,
    uBatpro_Ligne,
    ublClient,
    ublFacture,

    uPool,
    upoolClient,

     udkFacture_Ligne_edit_Facture,
     ublFacture_Ligne, 
     upoolFacture_Ligne,

    udkFacture_display_Facture,
    uodFacture,

    ucDockableScrollbox, ucChamp_Edit, ucChamp_Lookup_ComboBox, ucChamp_Memo,
    ucChamp_Label, ucChamp_DateTimePicker, Messages, SysUtils, Variants,
    Classes, Graphics, Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids,
    ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, DB, LCLIntf,  Clipbrd;

type

 { TfFacture_Nouveau }

 TfFacture_Nouveau
 =
  class(TForm)
   bDate: TButton;
   bFacture_Ligne_Nouveau: TButton;
   bNouveau: TButton;
   bodFacture: TBitBtn;
   bodFacture_Modele: TButton;
   ceAnnee: TChamp_Edit;
   ceMontant: TChamp_Edit;
   ceNbHeures: TChamp_Edit;
   ceNom: TChamp_Edit;
   ceNumeroDansAnnee: TChamp_Edit;
   cdtpDate: TChamp_DateTimePicker;
   clClient_id: TChamp_Label;
   clid: TChamp_Label;
   clkcbClient: TChamp_Lookup_ComboBox;
   clNumero: TChamp_Label;
   clPiece_Date: TChamp_Label;
   clPiece_Numero: TChamp_Label;
    dsbFacture_Ligne: TDockableScrollbox;
    Label1: TLabel;
    Label2: TLabel;
    pFacture: TPanel;
    pDetail: TPanel;
    sbNom_from_: TSpeedButton;

    procedure bDateClick(Sender: TObject);
    procedure bFacture_Ligne_NouveauClick(Sender: TObject);
    procedure bodFacture_ModeleClick(Sender: TObject);
    procedure ceNomMouseDown(Sender: TObject; Button: TMouseButton;
     Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bodFactureClick(Sender: TObject);
    procedure sbNom_from_Click(Sender: TObject);
  public
    { Déclarations publiques }
    pool: TpoolFacture;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Facture
  private
    blFacture: TblFacture;
    procedure _from_Facture;
  end;

function fFacture_Nouveau: TfFacture_Nouveau;

implementation

{$R *.lfm}

var
   FfFacture_Nouveau: TfFacture_Nouveau;

function fFacture_Nouveau: TfFacture_Nouveau;
begin
     Clean_Get( Result, FfFacture_Nouveau, TfFacture_Nouveau);
end;

{ TfFacture_Nouveau }

procedure TfFacture_Nouveau.FormCreate(Sender: TObject);
begin
     pool:= poolFacture;
     inherited;
     EntreeLigneColonne_:= False;
     dsbFacture_Ligne.Classe_dockable:= TdkFacture_Ligne_edit_Facture;
     dsbFacture_Ligne.Classe_Elements:= TblFacture_Ligne;
     blFacture:= nil;
end;


procedure TfFacture_Nouveau.FormDestroy(Sender: TObject);
begin
     inherited;
end;

function TfFacture_Nouveau.Execute: Boolean;
begin
     poolClient.ToutCharger;
     blFacture:= nil;
     Result:= True;
     Show;
     _from_Facture;
     bNouveau.Show;
end;

procedure TfFacture_Nouveau.bNouveauClick(Sender: TObject);
begin
     blFacture:= pool.Nouveau;
     if blFacture = nil then exit;

     bNouveau.Hide;
     _from_Facture;
end;

procedure TfFacture_Nouveau._from_Facture;
var
   blPiece: TblPiece;
begin
     Champs_Affecte( blFacture,
                     [
                     ceAnnee,
                     ceNumeroDansAnnee,
                     clNumero,
                     cdtpDate,
                     clkcbClient,
                     ceNom,
                     ceNbHeures,
                     ceMontant
                     ]);
     if nil = blFacture
     then
         blPiece:= nil
     else
         blPiece:= blFacture.Piece_bl;

     Champs_Affecte( blPiece,[clPiece_Numero, clPiece_Date]);

     if nil = blFacture
     then
         dsbFacture_Ligne.sl:= nil
     else
         begin
         blFacture.haFacture_Ligne.Charge;
         dsbFacture_Ligne.sl:= blFacture.haFacture_Ligne.sl;
         end;
end;

procedure TfFacture_Nouveau.bodFactureClick(Sender: TObject);
var
   odFacture: TodFacture;
   Resultat: String;
begin
     if blFacture = nil then exit;

     odFacture:= TodFacture.Create;
     try
        odFacture.Init( blFacture);
        Resultat:= odFacture.Visualiser;
     finally
            FreeAndNil( odFacture);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfFacture_Nouveau.sbNom_from_Click(Sender: TObject);
begin
     blFacture.Nom_from_;
end;

procedure TfFacture_Nouveau.bDateClick(Sender: TObject);
begin
     blFacture.Date_from_Now;
end;

procedure TfFacture_Nouveau.bodFacture_ModeleClick( Sender: TObject);
var
   odFacture: TodFacture;
   Resultat: String;
begin
     if blFacture = nil then exit;

     odFacture:= TodFacture.Create;
     try
        odFacture.Init( blFacture);
        Resultat:= odFacture.Editer_Modele_Impression;
     finally
            FreeAndNil( odFacture);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfFacture_Nouveau.ceNomMouseDown( Sender: TObject;
                                            Button: TMouseButton;
                                            Shift: TShiftState; X, Y: Integer);
begin
     if nil = blFacture then exit;
     Clipboard.AsText:= blFacture.Nom;
end;

procedure TfFacture_Nouveau.bFacture_Ligne_NouveauClick(Sender: TObject);
var
   blNouveau: TblFacture_Ligne;
   blClient: TblClient;
begin
     if nil = blFacture then exit;

     blNouveau:= poolFacture_Ligne.Nouveau;
     if blNouveau = nil then exit;

     if Affecte( blClient, TblClient, blFacture.Client_bl)
     then
         blNouveau.Prix_unitaire:= blClient.Tarif_horaire;
     blNouveau.Facture_id:= blFacture.id;  //inclut Save_to_database;

     _from_Facture;
end;


initialization
              Clean_Create ( FfFacture_Nouveau, TfFacture_Nouveau);
finalization
              Clean_Destroy( FfFacture_Nouveau);
end.

