unit ufAnnee_dsb;
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
    ublAnnee,

    uPool,
    upoolAnnee,

     udkMois_edit,
     ublMois, 

    udkAnnee_edit,
    uodAnnee,
    uPhi_Form,

    ucDockableScrollbox,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,LCLIntf;

type

 { TfAnnee_dsb }

 TfAnnee_dsb
 =
  class(TForm)
   bodAnnee_Modele: TButton;
    dsb: TDockableScrollbox;
    pc: TPageControl;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    bodAnnee: TBitBtn;
    Label1: TLabel;
    lNbTotal: TLabel;
    Panel3: TPanel;
    Label2: TLabel;
    lTri: TLabel;
    bNouveau: TButton;
    bSupprimer: TButton;
    tsMois: TTabSheet;
    dsbMois: TDockableScrollbox; 
    procedure bodAnnee_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
    procedure bodAnneeClick(Sender: TObject);
  private
    { Déclarations privées }
    procedure NbTotal_Change;
  public
    { Déclarations publiques }
    pool: TpoolAnnee;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
    procedure pool_Suppression_Avant;
  //Annee
  private
    blAnnee: TblAnnee;
    procedure _from_Annee;
  end;

function fAnnee_dsb: TfAnnee_dsb;

implementation

{$R *.lfm}

var
   FfAnnee_dsb: TfAnnee_dsb;

function fAnnee_dsb: TfAnnee_dsb;
begin
     Clean_Get( Result, FfAnnee_dsb, TfAnnee_dsb);
end;

{ TfAnnee_dsb }

procedure TfAnnee_dsb.FormCreate(Sender: TObject);
begin
     pool:= poolAnnee;
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     pool.Suppression.pAvant.Abonne( Self, pool_Suppression_Avant);

     dsb.Classe_dockable:= TdkAnnee_edit;
     dsb.Classe_Elements:= TblAnnee;
     dsbMois.Classe_dockable:= TdkMois_edit;
     dsbMois.Classe_Elements:= TblMois; 

     ThPhi_Form.Create( Self);
end;

procedure TfAnnee_dsb.FormDestroy(Sender: TObject);
begin
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     pool.Suppression.pAvant.DesAbonne( Self, pool_Suppression_Avant);
     inherited;
end;

procedure TfAnnee_dsb.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blAnnee);
     _from_Annee;
end;

procedure TfAnnee_dsb.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfAnnee_dsb.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfAnnee_dsb._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfAnnee_dsb.pool_Suppression_Avant;
begin
     blAnnee:= nil;
     _from_Annee;
end;

procedure TfAnnee_dsb._from_Annee;
begin
     Champs_Affecte( blAnnee,[ ]);//laissé vide pour l'instant

     if Assigned(blAnnee)
     then
         begin
         blAnnee.haMois.Charge;
         blAnnee.haMois.Mois_Charge_Pieces;
         dsbMois.sl:= blAnnee.haMois.sl;
         end
     else
         begin
         dsbMois.sl:= nil;
         end;
end;

procedure TfAnnee_dsb.bNouveauClick(Sender: TObject);
var
   blNouveau: TblAnnee;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfAnnee_dsb.bSupprimerClick(Sender: TObject);
var
   bl: TblAnnee;
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

procedure TfAnnee_dsb.bodAnneeClick(Sender: TObject);
var
   bl: TblAnnee;
   odAnnee: TodAnnee;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odAnnee:= TodAnnee.Create;
     try
        odAnnee.Init( bl);
        Resultat:= odAnnee.Visualiser;
     finally
            FreeAndNil( odAnnee);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfAnnee_dsb.bodAnnee_ModeleClick( Sender: TObject);
var
   bl: TblAnnee;
   odAnnee: TodAnnee;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odAnnee:= TodAnnee.Create;
     try
        odAnnee.Init( bl);
        Resultat:= odAnnee.Editer_Modele_Impression;
     finally
            FreeAndNil( odAnnee);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

initialization
              Clean_Create ( FfAnnee_dsb, TfAnnee_dsb);
finalization
              Clean_Destroy( FfAnnee_dsb);
end.
