unit ufFacture_Ligne_dsb;
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
    ublFacture_Ligne,

    uPool,
    upoolFacture_Ligne,

    //Pascal_uf_pc_uses_pas_aggregation

    udkFacture_Ligne_edit,
    uPhi_Form,

    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB;

type

 { TfFacture_Ligne_dsb }

 TfFacture_Ligne_dsb
 =
  class(TForm)
    dsb: TDockableScrollbox;
    pc: TPageControl;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    bImprimer: TBitBtn;
    Label1: TLabel;
    lNbTotal: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    lTri: TLabel;
    bNouveau: TButton;
    bSupprimer: TButton;
    tsPascal_uf_pc_dfm_Aggregation: TTabSheet;
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
  public
    { Déclarations publiques }
    pool: TpoolFacture_Ligne;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Facture_Ligne
  private
    blFacture_Ligne: TblFacture_Ligne;
    procedure _from_Facture_Ligne;
  end;

function fFacture_Ligne_dsb: TfFacture_Ligne_dsb;

implementation

{$R *.lfm}

var
   FfFacture_Ligne_dsb: TfFacture_Ligne_dsb;

function fFacture_Ligne_dsb: TfFacture_Ligne_dsb;
begin
     Clean_Get( Result, FfFacture_Ligne_dsb, TfFacture_Ligne_dsb);
end;

{ TfFacture_Ligne_dsb }

procedure TfFacture_Ligne_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolFacture_Ligne;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     dsb.Classe_dockable:= TdkFacture_Ligne_edit;
     dsb.Classe_Elements:= TblFacture_Ligne;
     //Pascal_uf_pc_initialisation_pas_Aggregation

     ThPhi_Form.Create( Self);
end;

procedure TfFacture_Ligne_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blFacture_Ligne);
     _from_Facture_Ligne;
end;

procedure TfFacture_Ligne_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfFacture_Ligne_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfFacture_Ligne_dsb.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfFacture_Ligne_dsb._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfFacture_Ligne_dsb._from_Facture_Ligne;
begin
     Champs_Affecte( blFacture_Ligne,[ ]);//laissé vide pour l'instant

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfFacture_Ligne_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblFacture_Ligne;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfFacture_Ligne_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblFacture_Ligne;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     if mrYes
        <>
        MessageDlg( 'Êtes vous sûr de vouloir supprimer la ligne ?'#13#10
                    +bl.GetLibelle,
                    mtConfirmation, [mbYes, mbNo], 0)
     then
         exit;

     pool.Supprimer( bl);
     _from_pool;
end;

procedure TfFacture_Ligne_dsb.bImprimerClick(Sender: TObject);
begin
     {
     Batpro_Ligne_Printer.Execute( 'fFacture_Ligne_dsb.stw',
                                   'Facture_Ligne',[],[],[],[],
                                   ['Facture_Ligne'],
                                   [poolFacture_Ligne.slFiltre],
                                   [ nil],
                                   [ nil]);
     }
end;

initialization
              Clean_Create ( FfFacture_Ligne_dsb, TfFacture_Ligne_dsb);
finalization
              Clean_Destroy( FfFacture_Ligne_dsb);
end.
