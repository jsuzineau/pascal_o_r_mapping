unit ufTexte_dsb;
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
    ublTexte,

    uPool,
    upoolTexte,

    //Pascal_uf_pc_uses_pas_aggregation

    udkTexte_edit,
    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB;

type

 { TfTexte_dsb }

 TfTexte_dsb
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
    tShow: TTimer;
    tsPascal_uf_pc_dfm_Aggregation: TTabSheet;
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tShowTimer(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
  public
    { Déclarations publiques }
    pool: TpoolTexte;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Texte
  private
    blTexte: TblTexte;
    procedure _from_Texte;
  end;

function fTexte_dsb: TfTexte_dsb;

implementation

{$R *.lfm}

var
   FfTexte_dsb: TfTexte_dsb;

function fTexte_dsb: TfTexte_dsb;
begin
     Clean_Get( Result, FfTexte_dsb, TfTexte_dsb);
end;

{ TfTexte_dsb }

procedure TfTexte_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolTexte;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, @NbTotal_Change);
     dsb.Classe_dockable:= TdkTexte_edit;
     dsb.Classe_Elements:= TblTexte;
     //Pascal_uf_pc_initialisation_pas_Aggregation
end;

procedure TfTexte_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blTexte);
     _from_Texte;
end;

procedure TfTexte_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, @NbTotal_Change);
     inherited;
end;

procedure TfTexte_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfTexte_dsb.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfTexte_dsb._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfTexte_dsb._from_Texte;
begin
     Champs_Affecte( blTexte,[ ]);//laissé vide pour l'instant

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfTexte_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblTexte;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfTexte_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblTexte;
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

procedure TfTexte_dsb.bImprimerClick(Sender: TObject);
begin
     {
     Batpro_Ligne_Printer.Execute( 'fTexte_dsb.stw',
                                   'Texte',[],[],[],[],
                                   ['Texte'],
                                   [poolTexte.slFiltre],
                                   [ nil],
                                   [ nil]);
     }
end;

procedure TfTexte_dsb.FormShow(Sender: TObject);
begin
     tShow.Enabled:= True;
end;

procedure TfTexte_dsb.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     _from_pool;
end;

initialization
              Clean_Create ( FfTexte_dsb, TfTexte_dsb);
finalization
              Clean_Destroy( FfTexte_dsb);
end.
