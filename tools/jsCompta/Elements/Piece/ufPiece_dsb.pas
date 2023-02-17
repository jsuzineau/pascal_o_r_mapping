unit ufPiece_dsb;
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

    //Pascal_uf_pc_uses_pas_aggregation

    udkPiece_edit,
    uodPiece,
    uPhi_Form,

    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,LCLIntf;

type

 { TfPiece_dsb }

 TfPiece_dsb
 =
  class(TForm)
   bodPiece_Modele: TButton;
    dsb: TDockableScrollbox;
    pc: TPageControl;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    bodPiece: TBitBtn;
    Label1: TLabel;
    lNbTotal: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    lTri: TLabel;
    bNouveau: TButton;
    bSupprimer: TButton;
    tsPascal_uf_pc_dfm_Aggregation: TTabSheet;
    procedure bodPiece_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bodPieceClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
  public
    { Déclarations publiques }
    pool: TpoolPiece;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Piece
  private
    blPiece: TblPiece;
    procedure _from_Piece;
  end;

function fPiece_dsb: TfPiece_dsb;

implementation

{$R *.lfm}

var
   FfPiece_dsb: TfPiece_dsb;

function fPiece_dsb: TfPiece_dsb;
begin
     Clean_Get( Result, FfPiece_dsb, TfPiece_dsb);
end;

{ TfPiece_dsb }

procedure TfPiece_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolPiece;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     dsb.Classe_dockable:= TdkPiece_edit;
     dsb.Classe_Elements:= TblPiece;
     //Pascal_uf_pc_initialisation_pas_Aggregation

     ThPhi_Form.Create( Self);
end;

procedure TfPiece_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blPiece);
     _from_Piece;
end;

procedure TfPiece_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfPiece_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfPiece_dsb.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfPiece_dsb._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfPiece_dsb._from_Piece;
begin
     Champs_Affecte( blPiece,[ ]);//laissé vide pour l'instant

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfPiece_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblPiece;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfPiece_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblPiece;
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

procedure TfPiece_dsb.bodPieceClick(Sender: TObject);
var
   bl: TblPiece;
   odPiece: TodPiece;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odPiece:= TodPiece.Create;
     try
        odPiece.Init( bl);
        Resultat:= odPiece.Visualiser;
     finally
            FreeAndNil( odPiece);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfPiece_dsb.bodPiece_ModeleClick( Sender: TObject);
var
   bl: TblPiece;
   odPiece: TodPiece;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odPiece:= TodPiece.Create;
     try
        odPiece.Init( bl);
        Resultat:= odPiece.Editer_Modele_Impression;
     finally
            FreeAndNil( odPiece);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

initialization
              Clean_Create ( FfPiece_dsb, TfPiece_dsb);
finalization
              Clean_Destroy( FfPiece_dsb);
end.
