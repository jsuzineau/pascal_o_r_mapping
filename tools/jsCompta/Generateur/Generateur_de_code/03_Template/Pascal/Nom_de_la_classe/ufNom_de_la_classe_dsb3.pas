unit ufNom_de_la_classe_dsb3;
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
    ublNom_de_la_classe,

    uPool,
    upoolNom_de_la_classe,

    //Pascal_uf_pc_uses_pas_aggregation

    udkNom_de_la_classe_edit,
    uodNom_de_la_classe,

    uPhi_Form,
    ucDockableScrollbox,
    ucChamp_Edit,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,LCLIntf;

type

 { TfNom_de_la_classe_dsb3 }

 TfNom_de_la_classe_dsb3
 =
  class(TForm)
//pattern_Membres_Pascal_uf_dsb3_edit_components_declaration_pas
//pattern_Details_Pascal_uf_dsb3_edit_components_declaration_pas
   bNom_de_la_classe_Nouveau: TButton;
   bNouveau: TButton;
   bodNom_de_la_classe: TBitBtn;
   bodNom_de_la_classe_Modele: TButton;
    dsb: TDockableScrollbox;
    pattern_Details_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Membres_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Symetrics_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pc: TPageControl;
    pNom_de_la_classe: TPanel;
    pDetail: TPanel;
    pListe: TPanel;
    pListe_Bas: TPanel;
    pListe_Haut: TPanel;
    tsPascal_uf_pc_dfm_Aggregation: TTabSheet;
    procedure bNom_de_la_classe_NouveauClick(Sender: TObject);
    procedure bodNom_de_la_classe_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bNouveauClick(Sender: TObject);
    procedure bodNom_de_la_classeClick(Sender: TObject);
  public
    { Déclarations publiques }
    pool: TpoolNom_de_la_classe;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean;
  //Rafraichissement
  protected
    procedure _from_pool;
  //Nom_de_la_classe
  private
    blNom_de_la_classe: TblNom_de_la_classe;
    procedure _from_Nom_de_la_classe;
  end;

function fNom_de_la_classe_dsb3: TfNom_de_la_classe_dsb3;

implementation

{$R *.lfm}

var
   FfNom_de_la_classe_dsb3: TfNom_de_la_classe_dsb3;

function fNom_de_la_classe_dsb3: TfNom_de_la_classe_dsb3;
begin
     Clean_Get( Result, FfNom_de_la_classe_dsb3, TfNom_de_la_classe_dsb3);
end;

{ TfNom_de_la_classe_dsb3 }

procedure TfNom_de_la_classe_dsb3.FormCreate(Sender: TObject);
begin
     pool:= poolNom_de_la_classe;
     inherited;
     EntreeLigneColonne_:= False;
     dsb.Classe_dockable:= TdkNom_de_la_classe_edit;
     dsb.Classe_Elements:= TblNom_de_la_classe;
     //Pascal_uf_pc_initialisation_pas_Aggregation
     ThPhi_Form.Create( Self);
end;

procedure TfNom_de_la_classe_dsb3.FormDestroy(Sender: TObject);
begin
     inherited;
end;

procedure TfNom_de_la_classe_dsb3.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blNom_de_la_classe);
     _from_Nom_de_la_classe;
end;

procedure TfNom_de_la_classe_dsb3.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

function TfNom_de_la_classe_dsb3.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfNom_de_la_classe_dsb3._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfNom_de_la_classe_dsb3._from_Nom_de_la_classe;
begin
     Champs_Affecte( blNom_de_la_classe,[ {pattern_Membres_Pascal_uf_dsb3_edit_components_list_pas}]);
     Champs_Affecte( blNom_de_la_classe,[ {pattern_Details_Pascal_uf_dsb3_edit_components_list_pas}]);

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfNom_de_la_classe_dsb3.bNouveauClick(Sender: TObject);
var
   blNouveau: TblNom_de_la_classe;
begin
     blNouveau:= pool.Nouveau;
     if blNouveau = nil then exit;

     dsb.sl:= nil;
     _from_pool;
end;

procedure TfNom_de_la_classe_dsb3.bodNom_de_la_classeClick(Sender: TObject);
var
   bl: TblNom_de_la_classe;
   odNom_de_la_classe: TodNom_de_la_classe;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odNom_de_la_classe:= TodNom_de_la_classe.Create;
     try
        odNom_de_la_classe.Init( bl);
        Resultat:= odNom_de_la_classe.Visualiser;
     finally
            FreeAndNil( odNom_de_la_classe);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfNom_de_la_classe_dsb3.bodNom_de_la_classe_ModeleClick( Sender: TObject);
var
   bl: TblNom_de_la_classe;
   odNom_de_la_classe: TodNom_de_la_classe;
   Resultat: String;
begin
     dsb.Get_bl( bl);
     if bl = nil then exit;

     odNom_de_la_classe:= TodNom_de_la_classe.Create;
     try
        odNom_de_la_classe.Init( bl);
        Resultat:= odNom_de_la_classe.Editer_Modele_Impression;
     finally
            FreeAndNil( odNom_de_la_classe);
            end;
     if not OpenDocument( Resultat)
     then
         ShowMessage( 'OpenDocument failed on '+Resultat);
end;

procedure TfNom_de_la_classe_dsb3.bNom_de_la_classe_NouveauClick( Sender: TObject);
var
   blNouveau: TblFacture_Ligne;
   blClient: TblClient;
begin
     if nil = blNom_de_la_classe then exit;

     blNouveau:= poolFacture_Ligne.Nouveau;
     if blNouveau = nil then exit;

     blNouveau.Facture_id:= blNom_de_la_classe.id;  //inclut Save_to_database;

     _from_Nom_de_la_classe;
end;


initialization
              Clean_Create ( FfNom_de_la_classe_dsb3, TfNom_de_la_classe_dsb3);
finalization
              Clean_Destroy( FfNom_de_la_classe_dsb3);
end.


