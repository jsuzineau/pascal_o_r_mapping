unit ufFacture_non_reglee;
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
    uBatpro_StringList,
    uBatpro_Ligne,
    ublClient,
    ublFacture,

    uPool,
    upoolClient,

     udkFacture_Ligne_display,
     ublFacture_Ligne, 
     upoolFacture_Ligne,

    udkFacture_display_Facture_non_reglee,
    uodFacture,

    uPhi_Form,

    ucDockableScrollbox, ucChamp_Edit, ucChamp_Memo,
    ucChamp_Label, ucChamp_DateTimePicker, Messages, SysUtils, Variants,
    Classes, Graphics, Controls, Forms, Dialogs, DBCtrls, Grids, DBGrids,
    ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls, DB, LCLIntf;

type

 { TfFacture_non_reglee }

 TfFacture_non_reglee
 =
  class(TForm)
   bodFacture: TBitBtn;
   bodFacture_Modele: TButton;
   bPiece_Nouveau: TButton;
   cdtpPiece_Date: TChamp_DateTimePicker;
   clClient_id: TChamp_Label;
   clid: TChamp_Label;
   clPiece_Numero: TChamp_Label;
    dsb: TDockableScrollbox;
    dsbFacture_Ligne: TDockableScrollbox;
    Label1: TLabel;
    Label2: TLabel;
    pFacture: TPanel;
    pDetail: TPanel;
    pListe: TPanel;
    pListe_Bas: TPanel;
    pListe_Haut: TPanel;

    procedure bodFacture_ModeleClick(Sender: TObject);
    procedure bPiece_NouveauClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bodFactureClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
  public
    { Déclarations publiques }
    pool: TpoolFacture;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //slFacture
  protected
    slFacture: TslFacture;
    procedure slFacture_from_pool;
  //Facture
  private
    blFacture: TblFacture;
    procedure _from_Facture;
  end;

function fFacture_non_reglee: TfFacture_non_reglee;

implementation

{$R *.lfm}

var
   FfFacture_non_reglee: TfFacture_non_reglee;

function fFacture_non_reglee: TfFacture_non_reglee;
begin
     Clean_Get( Result, FfFacture_non_reglee, TfFacture_non_reglee);
end;

{ TfFacture_non_reglee }

procedure TfFacture_non_reglee.FormCreate(Sender: TObject);
begin
     pool:= poolFacture;
     inherited;

     slFacture:= TslFacture.Create( 'slFacture');

     EntreeLigneColonne_:= False;
     dsb.Classe_dockable:= TdkFacture_display_Facture_non_reglee;
     dsb.Classe_Elements:= TblFacture;

     dsbFacture_Ligne.Classe_dockable:= TdkFacture_Ligne_display;
     dsbFacture_Ligne.Classe_Elements:= TblFacture_Ligne; 
end;

procedure TfFacture_non_reglee.FormDestroy(Sender: TObject);
begin
     FreeAndNil( slFacture);
     inherited;
end;

procedure TfFacture_non_reglee.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blFacture);
     _from_Facture;
end;

function TfFacture_non_reglee.Execute: Boolean;
begin
     poolClient.ToutCharger;
     pool.ToutCharger;
     slFacture_from_pool;
     Result:= True;
     Show;
end;

procedure TfFacture_non_reglee.slFacture_from_pool;
begin
     poolFacture.Charge_non_reglee( slFacture);
     dsb.sl:= slFacture;
end;

procedure TfFacture_non_reglee._from_Facture;
begin
     bPiece_Nouveau.Visible:= nil = blFacture.Piece_bl;
     Champs_Affecte( blFacture.Piece_bl,[clPiece_Numero, cdtpPiece_Date]);

     blFacture.haFacture_Ligne.Charge;
     dsbFacture_Ligne.sl:= blFacture.haFacture_Ligne.sl; 
end;

procedure TfFacture_non_reglee.bodFactureClick(Sender: TObject);
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

procedure TfFacture_non_reglee.FormResize(Sender: TObject);
begin
     Phi_Form_Up_horizontal( Self);
end;

procedure TfFacture_non_reglee.bodFacture_ModeleClick( Sender: TObject);
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

procedure TfFacture_non_reglee.bPiece_NouveauClick(Sender: TObject);
begin
     blFacture.Piece_Nouveau;
     _from_Facture;

     //dsb.sl:= nil;
     //slFacture_from_pool;
end;


initialization
              Clean_Create ( FfFacture_non_reglee, TfFacture_non_reglee);
finalization
              Clean_Destroy( FfFacture_non_reglee);
end.

