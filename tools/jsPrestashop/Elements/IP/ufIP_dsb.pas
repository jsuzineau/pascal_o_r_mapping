unit ufIP_dsb;
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
    ublIP,

    uPool,
    upoolIP,

    //Pascal_uf_pc_uses_pas_aggregation

    udkIP_edit,
    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB, Clipbrd;

type

 { TfIP_dsb }

 TfIP_dsb
 =
  class(TForm)
   bCompose_Delete: TButton;
   bCompose_Delete_4_requests: TButton;
   bQualification: TButton;
    dsb: TDockableScrollbox;
    Panel1: TPanel;
    Panel2: TPanel;
    Label1: TLabel;
    lNbTotal: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    lTri: TLabel;
    bNouveau: TButton;
    bSupprimer: TButton;
    procedure bCompose_DeleteClick(Sender: TObject);
    procedure bCompose_Delete_4_requestsClick(Sender: TObject);
    procedure bQualificationClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
  public
    { Déclarations publiques }
    pool: TpoolIP;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //IP
  private
    blIP: TblIP;
    procedure _from_IP;
  end;

function fIP_dsb: TfIP_dsb;

implementation

{$R *.lfm}

var
   FfIP_dsb: TfIP_dsb;

function fIP_dsb: TfIP_dsb;
begin
     Clean_Get( Result, FfIP_dsb, TfIP_dsb);
end;

{ TfIP_dsb }

procedure TfIP_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolIP;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     dsb.Classe_dockable:= TdkIP_edit;
     dsb.Classe_Elements:= TblIP;
     //Pascal_uf_pc_initialisation_pas_Aggregation
end;

procedure TfIP_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blIP);
     _from_IP;
end;

procedure TfIP_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfIP_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfIP_dsb.Execute: Boolean;
begin
     //pool.ToutCharger;
     //poolIP.Charge_limit(50);
     poolIP.Charge_limit(500);
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfIP_dsb._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfIP_dsb._from_IP;
begin
     Champs_Affecte( blIP,[ ]);//laissé vide pour l'instant

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfIP_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblIP;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfIP_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblIP;
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

procedure TfIP_dsb.bCompose_Delete_4_requestsClick(Sender: TObject);
var
   I: TIterateur_IP;
   bl: TblIP;
   S: String;
begin
     S:= '';
     I:= TslIP(pool.slFiltre).Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;
          S:= S + bl.Compose_Delete_4_requests;
          end;
     finally
            FreeAndNil( I);
            end;
     Clipboard.AsText:= S;
end;

procedure TfIP_dsb.bQualificationClick(Sender: TObject);
begin
     TslIP(pool.slFiltre).Qualification;
     ShowMessage( 'Qualification terminée');
end;

procedure TfIP_dsb.bCompose_DeleteClick(Sender: TObject);
var
   I: TIterateur_IP;
   bl: TblIP;
   S: String;
begin
     S:= '';
     I:= TslIP(pool.slFiltre).Iterateur;
     try
        while I.Continuer
        do
          begin
          if I.not_Suivant( bl) then continue;
          if bl.Reputation <> ir_Bad then continue;
          S:= S + bl.Compose_Delete;
          end;
     finally
            FreeAndNil( I);
            end;
     Clipboard.AsText:= S;
end;

initialization
              Clean_Create ( FfIP_dsb, TfIP_dsb);
finalization
              Clean_Destroy( FfIP_dsb);
end.

