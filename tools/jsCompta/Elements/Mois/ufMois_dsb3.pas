unit ufMois_dsb3;
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

     udkPiece_edit,
     ublPiece, 

    udkMois_edit,
    uodMois,

    uPhi_Form,
    ucDockableScrollbox,
    ucChamp_Edit,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,LCLIntf;

type

 { TfMois_dsb3 }

 TfMois_dsb3
 =
  class(TForm)
  ceAnnee: TChamp_Edit; 
   ceMois: TChamp_Edit; 
   ceMontant: TChamp_Edit; 
   ceDeclare: TChamp_Edit; 
   ceURSSAF: TChamp_Edit; 
  clkcbAnnee: TChamp_Lookup_ComboBox;
 
   bMois_Nouveau: TButton;
   bNouveau: TButton;
   bodMois: TBitBtn;
   bodMois_Modele: TButton;
    dsb: TDockableScrollbox;
    pattern_Details_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Membres_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Symetrics_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pc: TPageControl;
    pMois: TPanel;
    pDetail: TPanel;
    pListe: TPanel;
    pListe_Bas: TPanel;
    pListe_Haut: TPanel;
    tsPiece: TTabSheet;
    dsbPiece: TDockableScrollbox; 
    procedure bMois_NouveauClick(Sender: TObject);
    procedure bodMois_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bodMoisClick(Sender: TObject);
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

function fMois_dsb3: TfMois_dsb3;

implementation

{$R *.lfm}

var
   FfMois_dsb3: TfMois_dsb3;

function fMois_dsb3: TfMois_dsb3;
begin
     Clean_Get( Result, FfMois_dsb3, TfMois_dsb3);
end;

{ TfMois_dsb3 }

procedure TfMois_dsb3.FormCreate(Sender: TObject);
begin
     pool:= poolMois;
     inherited;
     EntreeLigneColonne_:= False;
     dsb.Classe_dockable:= TdkMois_edit;
     dsb.Classe_Elements:= TblMois;
     dsbPiece.Classe_dockable:= TdkPiece_edit;
     dsbPiece.Classe_Elements:= TblPiece; 
     ThPhi_Form.Create( Self);
end;

procedure TfMois_dsb3.FormDestroy(Sender: TObject);
begin
     inherited;
end;

procedure TfMois_dsb3.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blMois);
     _from_Mois;
end;

procedure TfMois_dsb3.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfMois_dsb3.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfMois_dsb3._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfMois_dsb3._from_Mois;
begin
     Champs_Affecte( blMois,[ ceAnnee,ceMois,ceMontant,ceDeclare,ceURSSAF ]);
     Champs_Affecte( blMois,[ clkcbAnnee ]);

     blMois.haPiece.Charge;
     dsbPiece.sl:= blMois.haPiece.sl; 
end;

procedure TfMois_dsb3.bNouveauClick(Sender: TObject);
var
   blNouveau: TblMois;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfMois_dsb3.bodMoisClick(Sender: TObject);
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

procedure TfMois_dsb3.bodMois_ModeleClick( Sender: TObject);
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

procedure TfMois_dsb3.bMois_NouveauClick( Sender: TObject);
var
   blNouveau: TblFacture_Ligne;
   blClient: TblClient;
begin
     if nil = blMois then exit;

     blNouveau:= poolFacture_Ligne.Nouveau;
     if blNouveau = nil then exit;

     blNouveau.Facture_id:= blMois.id;  //inclut Save_to_database;

     _from_Mois;
end;


initialization
              Clean_Create ( FfMois_dsb3, TfMois_dsb3);
finalization
              Clean_Destroy( FfMois_dsb3);
end.


