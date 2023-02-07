unit ufClient;
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

     udkFacture_display,
     ublFacture, 

    udkClient_display_Client,
    ucDockableScrollbox, ucChamp_Edit,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB;

type

 { TfClient }

 TfClient
 =
  class(TForm)
   bNouveau1: TButton;
   ceAdresse_1: TChamp_Edit;
   ceAdresse_2: TChamp_Edit;
   ceAdresse_3: TChamp_Edit;
   ceCode_Postal: TChamp_Edit;
   ceNom: TChamp_Edit;
   ceTarif_horaire: TChamp_Edit;
   ceVille: TChamp_Edit;
    dsb: TDockableScrollbox;
    dsbFacture: TDockableScrollbox;
    pClient: TPanel;
    pDetail: TPanel;
    pListe: TPanel;
    pListe_bas: TPanel;
    bImprimer: TBitBtn;
    pListe_Haut: TPanel;
    bNouveau: TButton;
    sbAdresse1_from_Nom: TSpeedButton;
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bImprimerClick(Sender: TObject);
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

function fClient: TfClient;

implementation

{$R *.lfm}

var
   FfClient: TfClient;

function fClient: TfClient;
begin
     Clean_Get( Result, FfClient, TfClient);
end;

{ TfClient }

procedure TfClient.FormCreate(Sender: TObject);
begin
     pool:= poolClient;
     inherited;
     EntreeLigneColonne_:= False;
     dsb.Classe_dockable:= TdkClient_display_Client;
     dsb.Classe_Elements:= TblClient;
     dsbFacture.Classe_dockable:= TdkFacture_display;
     dsbFacture.Classe_Elements:= TblFacture; 
end;

procedure TfClient.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blClient);
     _from_Client;
end;

procedure TfClient.FormDestroy(Sender: TObject);
begin
     inherited;
end;

function TfClient.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfClient._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfClient._from_Client;
begin
     Champs_Affecte( blClient,[ ceNom,ceAdresse_1,ceAdresse_2,ceAdresse_3,
                                ceCode_Postal,ceVille,ceTarif_horaire]);

     blClient.haFacture.Charge;
     dsbFacture.sl:= blClient.haFacture.sl; 
end;

procedure TfClient.bNouveauClick(Sender: TObject);
var
   blNouveau: TblClient;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfClient.bSupprimerClick(Sender: TObject);
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

procedure TfClient.bImprimerClick(Sender: TObject);
begin
     {
     Batpro_Ligne_Printer.Execute( 'fClient.stw',
                                   'Client',[],[],[],[],
                                   ['Client'],
                                   [poolClient.slFiltre],
                                   [ nil],
                                   [ nil]);
     }
end;

initialization
              Clean_Create ( FfClient, TfClient);
finalization
              Clean_Destroy( FfClient);
end.

