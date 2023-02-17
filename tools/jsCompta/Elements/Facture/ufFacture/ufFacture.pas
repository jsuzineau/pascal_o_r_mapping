unit ufFacture;
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

    uPhi_Form,

    ucDockableScrollbox, ucChamp_Edit, ucChamp_Lookup_ComboBox, ucChamp_Memo,
    ucChamp_Label, ucChamp_DateTimePicker, Messages, SysUtils, Variants,
    Classes, Graphics, Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids,
    ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, DB, LCLIntf;

type

 { TfFacture }

 TfFacture
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
    dsb: TDockableScrollbox;
    dsbFacture_Ligne: TDockableScrollbox;
    Label1: TLabel;
    Label2: TLabel;
    pFacture: TPanel;
    pDetail: TPanel;
    pListe: TPanel;
    pListe_Bas: TPanel;
    pListe_Haut: TPanel;
    sbNom_from_: TSpeedButton;

    procedure bDateClick(Sender: TObject);
    procedure bFacture_Ligne_NouveauClick(Sender: TObject);
    procedure bodFacture_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
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
  //Rafraichissement
  protected
    procedure _from_pool;
  //Facture
  private
    blFacture: TblFacture;
    procedure _from_Facture;
  end;

function fFacture: TfFacture;

implementation

{$R *.lfm}

var
   FfFacture: TfFacture;

function fFacture: TfFacture;
begin
     Clean_Get( Result, FfFacture, TfFacture);
end;

{ TfFacture }

procedure TfFacture.FormCreate(Sender: TObject);
begin
     pool:= poolFacture;
     inherited;
     EntreeLigneColonne_:= False;
     dsb.Classe_dockable:= TdkFacture_display_Facture;
     dsb.Classe_Elements:= TblFacture;

     dsbFacture_Ligne.Classe_dockable:= TdkFacture_Ligne_edit_Facture;
     dsbFacture_Ligne.Classe_Elements:= TblFacture_Ligne; 

     ThPhi_Form.Create( Self);
end;

procedure TfFacture.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blFacture);
     _from_Facture;
end;

procedure TfFacture.FormDestroy(Sender: TObject);
begin
     inherited;
end;

function TfFacture.Execute: Boolean;
begin
     poolClient.ToutCharger;
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfFacture._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfFacture._from_Facture;
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
     Champs_Affecte( blFacture.Piece_bl,[clPiece_Numero, clPiece_Date]);

     blFacture.haFacture_Ligne.Charge;
     dsbFacture_Ligne.sl:= blFacture.haFacture_Ligne.sl; 
end;

procedure TfFacture.bNouveauClick(Sender: TObject);
var
   blNouveau: TblFacture;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfFacture.bodFactureClick(Sender: TObject);
var
   bl: TblFacture;
   odFacture: TodFacture;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odFacture:= TodFacture.Create;
     try
        odFacture.Init( bl);
        Resultat:= odFacture.Visualiser;
     finally
            FreeAndNil( odFacture);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfFacture.sbNom_from_Click(Sender: TObject);
begin
     blFacture.Nom_from_;
end;

procedure TfFacture.bDateClick(Sender: TObject);
begin
     blFacture.Date_from_Now;
end;

procedure TfFacture.bodFacture_ModeleClick( Sender: TObject);
var
   bl: TblFacture;
   odFacture: TodFacture;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odFacture:= TodFacture.Create;
     try
        odFacture.Init( bl);
        Resultat:= odFacture.Editer_Modele_Impression;
     finally
            FreeAndNil( odFacture);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfFacture.bFacture_Ligne_NouveauClick(Sender: TObject);
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
              Clean_Create ( FfFacture, TfFacture);
finalization
              Clean_Destroy( FfFacture);
end.

