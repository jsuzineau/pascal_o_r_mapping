unit ufClient_dsb;
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
    ublClient,

    uPool,
    upoolClient,

     udkFacture_edit,
     ublFacture, 

    udkClient_edit,
    ucDockableScrollbox,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB;

type

 { TfClient_dsb }

 TfClient_dsb
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
    tsFacture: TTabSheet;
    dsbFacture: TDockableScrollbox; 
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
    pool: TpoolClient;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Client
  private
    blClient: TblClient;
    procedure _from_Client;
  end;

function fClient_dsb: TfClient_dsb;

implementation

{$R *.lfm}

var
   FfClient_dsb: TfClient_dsb;

function fClient_dsb: TfClient_dsb;
begin
     Clean_Get( Result, FfClient_dsb, TfClient_dsb);
end;

{ TfClient_dsb }

procedure TfClient_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolClient;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     dsb.Classe_dockable:= TdkClient_edit;
     dsb.Classe_Elements:= TblClient;
     dsbFacture.Classe_dockable:= TdkFacture_edit;
     dsbFacture.Classe_Elements:= TblFacture; 
end;

procedure TfClient_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blClient);
     _from_Client;
end;

procedure TfClient_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfClient_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfClient_dsb.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfClient_dsb._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfClient_dsb._from_Client;
begin
     Champs_Affecte( blClient,[ ]);//laissé vide pour l'instant

     blClient.haFacture.Charge;
     dsbFacture.sl:= blClient.haFacture.sl; 
end;

procedure TfClient_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblClient;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfClient_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblClient;
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

procedure TfClient_dsb.bImprimerClick(Sender: TObject);
begin
     {
     Batpro_Ligne_Printer.Execute( 'fClient_dsb.stw',
                                   'Client',[],[],[],[],
                                   ['Client'],
                                   [poolClient.slFiltre],
                                   [ nil],
                                   [ nil]);
     }
end;

initialization
              Clean_Create ( FfClient_dsb, TfClient_dsb);
finalization
              Clean_Destroy( FfClient_dsb);
end.
