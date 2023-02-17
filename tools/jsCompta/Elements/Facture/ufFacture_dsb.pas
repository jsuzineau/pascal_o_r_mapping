unit ufFacture_dsb;
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
    upoolClient,

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

 { TfFacture_dsb }

 TfFacture_dsb
 =
  class(TForm)
   bodFacture_Modele: TButton;
    dsb: TDockableScrollbox;
    pc: TPageControl;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    bodFacture: TBitBtn;
    Label1: TLabel;
    lNbTotal: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    lTri: TLabel;
    bNouveau: TButton;
    bSupprimer: TButton;
    tsFacture_Ligne: TTabSheet;
    dsbFacture_Ligne: TDockableScrollbox; 
    procedure bodFacture_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bodFactureClick(Sender: TObject);
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

function fFacture_dsb: TfFacture_dsb;

implementation

{$R *.lfm}

var
   FfFacture_dsb: TfFacture_dsb;

function fFacture_dsb: TfFacture_dsb;
begin
     Clean_Get( Result, FfFacture_dsb, TfFacture_dsb);
end;

{ TfFacture_dsb }

procedure TfFacture_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolFacture;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     dsb.Classe_dockable:= TdkFacture_edit;
     dsb.Classe_Elements:= TblFacture;
     dsbFacture_Ligne.Classe_dockable:= TdkFacture_Ligne_edit;
     dsbFacture_Ligne.Classe_Elements:= TblFacture_Ligne; 

     ThPhi_Form.Create( Self);
end;

procedure TfFacture_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blFacture);
     _from_Facture;
end;

procedure TfFacture_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfFacture_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfFacture_dsb.Execute: Boolean;
begin
     poolClient.ToutCharger;
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfFacture_dsb._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfFacture_dsb._from_Facture;
begin
     Champs_Affecte( blFacture,[ ]);//laissé vide pour l'instant

     blFacture.haFacture_Ligne.Charge;
     dsbFacture_Ligne.sl:= blFacture.haFacture_Ligne.sl; 
end;

procedure TfFacture_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblFacture;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfFacture_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblFacture;
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

procedure TfFacture_dsb.bodFactureClick(Sender: TObject);
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

procedure TfFacture_dsb.bodFacture_ModeleClick( Sender: TObject);
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

initialization
              Clean_Create ( FfFacture_dsb, TfFacture_dsb);
finalization
              Clean_Destroy( FfFacture_dsb);
end.
