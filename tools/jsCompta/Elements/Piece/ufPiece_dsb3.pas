unit ufPiece_dsb3;
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

    ucDockableScrollbox,
    ucChamp_Edit,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB,LCLIntf;

type

 { TfPiece_dsb3 }

 TfPiece_dsb3
 =
  class(TForm)
   bodPiece: TBitBtn;
   bodPiece_Modele: TButton;
    dsb: TDockableScrollbox;
    pattern_Details_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Membres_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pattern_Symetrics_Pascal_uf_dsb3_edit_component_list_lfm: TLabel;
    pc: TPageControl;
    pPiece: TPanel;
    pDetail: TPanel;
    pListe: TPanel;
    pListe_Bas: TPanel;
    pListe_Haut: TPanel;
    tsPascal_uf_pc_dfm_Aggregation: TTabSheet;
    procedure bodPiece_ModeleClick(Sender: TObject);
    procedure dsbSelect(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure bodPieceClick(Sender: TObject);
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

function fPiece_dsb3: TfPiece_dsb3;

implementation

{$R *.lfm}

var
   FfPiece_dsb3: TfPiece_dsb3;

function fPiece_dsb3: TfPiece_dsb3;
begin
     Clean_Get( Result, FfPiece_dsb3, TfPiece_dsb3);
end;

{ TfPiece_dsb3 }

procedure TfPiece_dsb3.FormCreate(Sender: TObject);
begin
     pool:= poolPiece;
     inherited;
     EntreeLigneColonne_:= False;
     dsb.Classe_dockable:= TdkPiece_edit;
     dsb.Classe_Elements:= TblPiece;
     //Pascal_uf_pc_initialisation_pas_Aggregation
end;

procedure TfPiece_dsb3.dsbSelect(Sender: TObject);
begin
     dsb.Get_bl( blPiece);
     _from_Piece;
end;

procedure TfPiece_dsb3.FormDestroy(Sender: TObject);
begin
     inherited;
end;

function TfPiece_dsb3.Execute: Boolean;
begin
     pool.ToutCharger;
     _from_pool;
     Result:= True;
     Show;
end;

procedure TfPiece_dsb3._from_pool;
begin
     dsb.sl:= pool.slFiltre;
     //dsb.sl:= pool.T;
end;

procedure TfPiece_dsb3._from_Piece;
begin
     //Champs_Affecte( blPiece,[ ceFacture_id,ceDate,ceNumero ]);
     //Champs_Affecte( blPiece,[ {pattern_Details_Pascal_uf_dsb3_edit_components_list_pas}]);

     //Pascal_uf_pc_charge_pas_Aggregation
end;

procedure TfPiece_dsb3.bodPieceClick(Sender: TObject);
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

procedure TfPiece_dsb3.bodPiece_ModeleClick( Sender: TObject);
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
              Clean_Create ( FfPiece_dsb3, TfPiece_dsb3);
finalization
              Clean_Destroy( FfPiece_dsb3);
end.


