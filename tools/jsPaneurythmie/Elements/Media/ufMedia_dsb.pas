unit ufMedia_dsb;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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
    ublMedia,

    uPool,
    upoolMedia,

    //Pascal_uf_pc_uses_pas_aggregation

    udkMedia_edit,
    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB;

type

 { TfMedia_dsb }

 TfMedia_dsb
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
    procedure tShowTimer(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
  public
    { Déclarations publiques }
    pool: TpoolMedia;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Media
  private
    blMedia: TblMedia;
    procedure _from_Media;
  end;

function fMedia_dsb: TfMedia_dsb;

implementation

{$R *.lfm}

var
   FfMedia_dsb: TfMedia_dsb;

function fMedia_dsb: TfMedia_dsb;
begin
     Clean_Get( Result, FfMedia_dsb, TfMedia_dsb);
end;

{ TfMedia_dsb }

procedure TfMedia_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolMedia;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     dsb.Classe_dockable:= TdkMedia_edit;
     dsb.Classe_Elements:= TblMedia;
     //Pascal_uf_pc_initialisation_pas_Aggregation
end;

procedure TfMedia_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blMedia);
     _from_Media;
end;

procedure TfMedia_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfMedia_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfMedia_dsb.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
     tShow.Enabled:= True;
end;

procedure TfMedia_dsb._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfMedia_dsb._from_Media;
begin
     Champs_Affecte( blMedia,[ ]);//laissé vide pour l'instant

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfMedia_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblMedia;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfMedia_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblMedia;
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

procedure TfMedia_dsb.bImprimerClick(Sender: TObject);
begin
     {
     Batpro_Ligne_Printer.Execute( 'fMedia_dsb.stw',
                                   'Media',[],[],[],[],
                                   ['Media'],
                                   [poolMedia.slFiltre],
                                   [ nil],
                                   [ nil]);
     }
end;

procedure TfMedia_dsb.tShowTimer(Sender: TObject);
begin
     tShow.Enabled:= False;
     _from_pool;
end;

initialization
              Clean_Create ( FfMedia_dsb, TfMedia_dsb);
finalization
              Clean_Destroy( FfMedia_dsb);
end.