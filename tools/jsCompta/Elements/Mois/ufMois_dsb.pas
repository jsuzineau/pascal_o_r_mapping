unit ufMois_dsb;
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
    ublMois,

    uPool,
    upoolMois,

     udkPiece_display,
     ublFacture, 
     udkFacture_display,

    udkMois_edit,
    uodMois,
    uPhi_Form,

    ucDockableScrollbox,
  SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB, lclintf;

type

 { TfMois_dsb }

 TfMois_dsb
 =
  class(TForm)
   bodMois_Modele: TButton;
    dsb: TDockableScrollbox;
    pc: TPageControl;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    bodMois: TBitBtn;
    Label1: TLabel;
    lNbTotal: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    lTri: TLabel;
    bNouveau: TButton;
    bSupprimer: TButton;
    tsPiece: TTabSheet;
    dsbPiece: TDockableScrollbox;

    tsFacture: TTabSheet;
    dsbFacture: TDockableScrollbox; 
    procedure bodMois_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bodMoisClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
  public
    { Déclarations publiques }
    pool: TpoolMois;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Mois
  private
    blMois: TblMois;
    procedure _from_Mois;
  end;

function fMois_dsb: TfMois_dsb;

implementation

{$R *.lfm}

var
   FfMois_dsb: TfMois_dsb;

function fMois_dsb: TfMois_dsb;
begin
     Clean_Get( Result, FfMois_dsb, TfMois_dsb);
end;

{ TfMois_dsb }

procedure TfMois_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolMois;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     dsb.Classe_dockable:= TdkMois_edit;
     dsb.Classe_Elements:= TblMois;
     dsbPiece.Classe_dockable:= TdkPiece_display;
     dsbPiece.Classe_Elements:= TblPiece;
     dsbFacture.Classe_dockable:= TdkFacture_display;
     dsbFacture.Classe_Elements:= TblFacture; 

     ThPhi_Form.Create( Self);
end;

procedure TfMois_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfMois_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blMois);
     _from_Mois;
end;

procedure TfMois_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfMois_dsb.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfMois_dsb._from_pool;
begin
     pool.TrierFiltre;
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfMois_dsb._from_Mois;
begin
     Champs_Affecte( blMois,[ ]);//laissé vide pour l'instant

     blMois.haFacture.Charge;
     dsbFacture.sl:= blMois.haFacture.sl;

     blMois.haPiece.Charge;
     dsbPiece.sl:= blMois.haPiece.sl;
end;

procedure TfMois_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblMois;
begin
     dsb.sl:= nil;
     try
        blNouveau:= pool.Nouveau;
        if blNouveau = nil then exit;
     finally
            _from_pool;
            end;
end;

procedure TfMois_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblMois;
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

procedure TfMois_dsb.bodMoisClick(Sender: TObject);
var
   bl: TblMois;
   odMois: TodMois;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odMois:= TodMois.Create;
     try
        odMois.Init( bl);
        Resultat:= odMois.Visualiser;
     finally
            FreeAndNil( odMois);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfMois_dsb.bodMois_ModeleClick( Sender: TObject);
var
   bl: TblMois;
   odMois: TodMois;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odMois:= TodMois.Create;
     try
        odMois.Init( bl);
        Resultat:= odMois.Editer_Modele_Impression;
     finally
            FreeAndNil( odMois);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

initialization
              Clean_Create ( FfMois_dsb, TfMois_dsb);
finalization
              Clean_Destroy( FfMois_dsb);
end.
