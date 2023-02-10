unit ufAnnee_dsb3;
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

    ucDockableScrollbox,
    ucChamp_Edit,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,LCLIntf;

type

 { TfAnnee_dsb3 }

 TfAnnee_dsb3
 =
  class(TForm)
  ceAnnee: TChamp_Edit; 
   ceDeclare: TChamp_Edit; 
//pattern_Details_Pascal_uf_dsb3_edit_components_declaration_pas
   bAnnee_Nouveau: TButton;
   bNouveau: TButton;
   bodAnnee: TBitBtn;
   bodAnnee_Modele: TButton;
    dsb: TDockableScrollbox;
    pattern_Details_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Membres_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Symetrics_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pc: TPageControl;
    pAnnee: TPanel;
    pDetail: TPanel;
    pListe: TPanel;
    pListe_Bas: TPanel;
    pListe_Haut: TPanel;
    tsMois: TTabSheet;
    dsbMois: TDockableScrollbox; 
    procedure bAnnee_NouveauClick(Sender: TObject);
    procedure bodAnnee_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bodAnneeClick(Sender: TObject);
  public
    { Déclarations publiques }
    pool: TpoolAnnee;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Annee
  private
    blAnnee: TblAnnee;
    procedure _from_Annee;
  end;

function fAnnee_dsb3: TfAnnee_dsb3;

implementation

{$R *.lfm}

var
   FfAnnee_dsb3: TfAnnee_dsb3;

function fAnnee_dsb3: TfAnnee_dsb3;
begin
     Clean_Get( Result, FfAnnee_dsb3, TfAnnee_dsb3);
end;

{ TfAnnee_dsb3 }

procedure TfAnnee_dsb3.FormCreate(Sender: TObject);
begin
     pool:= poolAnnee;
     inherited;
     EntreeLigneColonne_:= False;
     dsb.Classe_dockable:= TdkAnnee_edit;
     dsb.Classe_Elements:= TblAnnee;
     dsbMois.Classe_dockable:= TdkMois_edit;
     dsbMois.Classe_Elements:= TblMois; 
end;

procedure TfAnnee_dsb3.FormDestroy(Sender: TObject);
begin
     inherited;
end;

procedure TfAnnee_dsb3.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blAnnee);
     _from_Annee;
end;

procedure TfAnnee_dsb3.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfAnnee_dsb3.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfAnnee_dsb3._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfAnnee_dsb3._from_Annee;
begin
     Champs_Affecte( blAnnee,[ ceAnnee,ceDeclare ]);
     Champs_Affecte( blAnnee,[ {pattern_Details_Pascal_uf_dsb3_edit_components_list_pas}]);

     blAnnee.haMois.Charge;
     dsbMois.sl:= blAnnee.haMois.sl; 
end;

procedure TfAnnee_dsb3.bNouveauClick(Sender: TObject);
var
   blNouveau: TblAnnee;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfAnnee_dsb3.bodAnneeClick(Sender: TObject);
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

procedure TfAnnee_dsb3.bodAnnee_ModeleClick( Sender: TObject);
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

procedure TfAnnee_dsb3.bAnnee_NouveauClick( Sender: TObject);
var
   blNouveau: TblFacture_Ligne;
   blClient: TblClient;
begin
     if nil = blAnnee then exit;

     blNouveau:= poolFacture_Ligne.Nouveau;
     if blNouveau = nil then exit;

     blNouveau.Facture_id:= blAnnee.id;  //inclut Save_to_database;

     _from_Annee;
end;


initialization
              Clean_Create ( FfAnnee_dsb3, TfAnnee_dsb3);
finalization
              Clean_Destroy( FfAnnee_dsb3);
end.


