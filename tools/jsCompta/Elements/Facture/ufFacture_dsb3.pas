unit ufFacture_dsb3;
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
    uBatpro_Ligne,
    ublFacture,

    uPool,
    upoolFacture,

     udkFacture_Ligne_edit,
     ublFacture_Ligne, 

    udkFacture_edit,
    uodFacture,

    uPhi_Form,
    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,LCLIntf;

type

 { TfFacture_dsb3 }

 TfFacture_dsb3
 =
  class(TForm)
  ceAnnee: TChamp_Edit; 
   ceNumeroDansAnnee: TChamp_Edit; 
   ceDate: TChamp_Edit; 
   ceClient_id: TChamp_Edit; 
   ceNom: TChamp_Edit; 
   ceNbHeures: TChamp_Edit; 
   ceMontant: TChamp_Edit; 
   cePiece_id: TChamp_Edit; 
  clkcbClient: TChamp_Lookup_ComboBox;
 
   bFacture_Nouveau: TButton;
   bNouveau: TButton;
   bodFacture: TBitBtn;
   bodFacture_Modele: TButton;
    dsb: TDockableScrollbox;
    pattern_Details_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Membres_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Symetrics_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pc: TPageControl;
    pFacture: TPanel;
    pDetail: TPanel;
    pListe: TPanel;
    pListe_Bas: TPanel;
    pListe_Haut: TPanel;
    tsFacture_Ligne: TTabSheet;
    dsbFacture_Ligne: TDockableScrollbox; 
    procedure bFacture_NouveauClick(Sender: TObject);
    procedure bodFacture_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bodFactureClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
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

function fFacture_dsb3: TfFacture_dsb3;

implementation

{$R *.lfm}

var
   FfFacture_dsb3: TfFacture_dsb3;

function fFacture_dsb3: TfFacture_dsb3;
begin
     Clean_Get( Result, FfFacture_dsb3, TfFacture_dsb3);
end;

{ TfFacture_dsb3 }

procedure TfFacture_dsb3.FormCreate(Sender: TObject);
begin
     pool:= poolFacture;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     dsb.Classe_dockable:= TdkFacture_edit;
     dsb.Classe_Elements:= TblFacture;
     dsbFacture_Ligne.Classe_dockable:= TdkFacture_Ligne_edit;
     dsbFacture_Ligne.Classe_Elements:= TblFacture_Ligne; 
end;

procedure TfFacture_dsb3.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blFacture);
     _from_Facture;
end;

procedure TfFacture_dsb3.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfFacture_dsb3.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfFacture_dsb3.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfFacture_dsb3._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfFacture_dsb3._from_Facture;
begin
     Champs_Affecte( blFacture,[ ceAnnee,ceNumeroDansAnnee,ceDate,ceClient_id,ceNom,ceNbHeures,ceMontant,cePiece_id ]);
     Champs_Affecte( blFacture,[ clkcbClient ]);

     blFacture.haFacture_Ligne.Charge;
     dsbFacture_Ligne.sl:= blFacture.haFacture_Ligne.sl; 
end;

procedure TfFacture_dsb3.bNouveauClick(Sender: TObject);
var
   blNouveau: TblFacture;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfFacture_dsb3.bodFactureClick(Sender: TObject);
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

procedure TfFacture_dsb3.FormResize(Sender: TObject);
begin
     Phi_Form_Up_horizontal( Self);
end;

procedure TfFacture_dsb3.bodFacture_ModeleClick( Sender: TObject);
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

procedure TfFacture_dsb3.bFacture_NouveauClick( Sender: TObject);
var
   blNouveau: TblFacture_Ligne;
   blClient: TblClient;
begin
     if nil = blFacture then exit;

     blNouveau:= poolFacture_Ligne.Nouveau;
     if blNouveau = nil then exit;

     blNouveau.Facture_id:= blFacture.id;  //inclut Save_to_database;

     _from_Facture;
end;


initialization
              Clean_Create ( FfFacture_dsb3, TfFacture_dsb3);
finalization
              Clean_Destroy( FfFacture_dsb3);
end.


