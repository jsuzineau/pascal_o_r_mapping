unit ufRechercheBatpro_Ligne_ChampGrid;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
    uChamp,
    uChamps,
    uBatpro_StringList,
    u_sys_,
    uDataUtilsU,
    uEXE_INI,
    ucBatproMaskElement,

    uVide,
    uDataUtilsF,
    uDataClasses,
    uBatpro_Element,
    uBatpro_Ligne,
    uPool,
    uhTriColonneChamps,
    uhDessinnateur,
    ufpBas,

  Windows, Messages, SysUtils, Classes, FMX.Graphicso, FMX.Controls, FMX.Forms, Dialogs,
  ActnList, ComCtrls, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids,
  Db, DBTables, FMTBcd, Provider, SqlExpr, DBClient, ucChampsGrid, FMX.Menus;

type
 TfRechercheBatpro_Ligne_ChampGrid
 =
  class(TfpBas)
    pHaut: TPanel;
    pSG: TPanel;
    lTri: TLabel;
    gbSaisie: TGroupBox;
    bCreationModification: TButton;
    cg: TChampsGrid;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure cgDblClick(Sender: TObject);
  private
    { Déclarations privées }
    _from_sl_running: Boolean;
  protected
    CodeFieldName: String;
    bme:TBatproMaskElement;
    procedure AfterSelect( bme:TBatproMaskElement; _bl: TBatpro_Ligne); virtual;
    procedure _from_sl; virtual;
  public
    { Déclarations publiques }
    Classe_Elements: TBatpro_Ligne_Class;
    Contexte: Integer;
    hTriColonne: ThTriColonneChamps;
    function Execute( _bme:TBatproMaskElement; _bme_PreExecute:Boolean):Boolean;reintroduce; virtual;
    function LigneUnique: Boolean;

    //recopié de Tdm pour gérer Classe_Elements
    procedure AfterConstruction; override;
    procedure BeforeDestruction; override;
    procedure Avant_OnCreate;
    procedure Apres_OnCreate; virtual;
    procedure Avant_OnDestroy;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure Loaded; override;

  // Gestion de la liste
  public
    sl: TBatpro_StringList;
  //Gestion du tri
  public
    pool: TPool;
  //Mise à jour avant affichage
  public
    procedure Avant_Execute; virtual;
  end;

var
  fRechercheBatpro_Ligne_ChampGrid: TfRechercheBatpro_Ligne_ChampGrid;

implementation

{$R *.dfm}

procedure TfRechercheBatpro_Ligne_ChampGrid.Loaded;
begin
     inherited;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.Avant_OnCreate;
begin
     Classe_Elements:= nil;
     sl:= nil;
     bme:= nil;
     pool:= nil;
     _from_sl_running:= False;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.Apres_OnCreate;
begin
     cg.Classe_Elements:= Classe_Elements;
     hTriColonne:= ThTriColonneChamps.Create( cg, pool, lTri);
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.Avant_OnDestroy;
begin
     Free_nil( hTriColonne);
end;

constructor TfRechercheBatpro_Ligne_ChampGrid.Create(AOwner: TComponent);
begin
     Avant_OnCreate;
     inherited;
     if OldCreateOrder
     then
         Apres_OnCreate;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.AfterConstruction;
begin
     inherited;
     if not OldCreateOrder
     then
         Apres_OnCreate;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.BeforeDestruction;
begin
     if not OldCreateOrder
     then
         Avant_OnDestroy;
     inherited;
end;

destructor TfRechercheBatpro_Ligne_ChampGrid.Destroy;
begin
     if OldCreateOrder
     then
         Avant_OnDestroy;
     inherited;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
end;

function TfRechercheBatpro_Ligne_ChampGrid.LigneUnique: Boolean;
begin
     Result:= sl.Count = 1;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.Avant_Execute;
begin

end;

function TfRechercheBatpro_Ligne_ChampGrid.Execute( _bme:TBatproMaskElement; _bme_PreExecute:Boolean):Boolean;
var
   bl: TBatpro_Ligne;
   Code: String;
   cID: TChamp;
   procedure Traite_bl;
   var
      CS: TChamps;
      id: Integer;
   begin
        Result:= Assigned( bl);
        if Result
        then
            begin
            id:= bl.id;
            CS:= bl.Champs;
            end
        else
            begin
            id:= 0;
            CS:= nil;
            end;

        bme._from_Champs( CS, bl, id);
        if Assigned( cID)
        then
            cID.asInteger:= id;

        if Result
        then
            AfterSelect( bme, bl);
   end;
begin
     hTriColonne.Update_l;
     try
        gbSaisie.Visible:= EXE_INI.Delphi_autonome;

        bme:= _bme;
        CodeFieldName:= bme.bme2Code;
        cID:= bme.GetChamp_id;

        hTriColonne.Reset;

        Avant_Execute;

        _from_sl;

        Result:= LigneUnique and not EXE_INI.Delphi_autonome;

        if not Result
        then
            if _bme_PreExecute
            then
                case bme.Default
                of
                  bmed_Aucun  : ;
                  bmed_Premier:
                    begin
                    if cg.RowCount > 1
                    then
                        cg.Row:= 1;
                    Result:= True;
                    end;
                  bmed_Dernier:
                    begin
                    if cg.RowCount > 1
                    then
                        cg.Row:= cg.RowCount - 1;
                    Result:= True;
                    end;
                  end
            else
                Result:= inherited Execute;

        if Result
        then
            begin
            cg.Get_bl( bl);
            Traite_bl;
            end
        else
            if _bme_PreExecute //cas _bme_PreExecute, bme.Default = bmed_Aucun
            then
                begin
                Code:= bme.Text;
                if cID = nil
                then
                    bl:= Batpro_Ligne_from_sl_sCle( sl, Code)
                else
                    pool.Get_Interne_from_id( cID.asInteger, bl);

                Traite_bl;
                end;
     finally
            bme:= nil;
            end;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.FormShow(Sender: TObject);
begin
     inherited;
     cg.SetFocus;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.AfterSelect;
begin

end;

procedure TfRechercheBatpro_Ligne_ChampGrid._from_sl;
begin
     if _from_sl_running then exit;
     try
        _from_sl_running:= True;

        cg.sl:= sl;
     finally
            _from_sl_running:= False;
            end;
end;

procedure TfRechercheBatpro_Ligne_ChampGrid.cgDblClick(Sender: TObject);
begin
     aValidation.Execute;
end;

end.
