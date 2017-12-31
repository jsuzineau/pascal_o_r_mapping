unit ufRechercheBatpro_Ligne;
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
    uContextes,
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
    uhTriColonneChamps_StringGrid,
    uhDessinnateur,
    ufpBas,
    Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
    ActnList, ComCtrls, StdCtrls, Buttons, ExtCtrls, Grids, DBGrids,
    Db, DBTables, FMTBcd, Provider, SqlExpr, DBClient, Menus;

type
 TfRechercheBatpro_Ligne
 =
  class(TfpBas)
    pHaut: TPanel;
    pSG: TPanel;
    lTri: TLabel;
    sg: TStringGrid;
    gbSaisie: TGroupBox;
    bCreationModification: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure sgDblClick(Sender: TObject);
    procedure sgMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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
    hTriColonne: ThTriColonneChamps_StringGrid;
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
    hd: ThDessinnateur;
  //Gestion du tri
  public
    pool: TPool;
  //Mise à jour avant affichage
  public
    procedure Avant_Execute; virtual;
  //Gestion de la sélection
  private
    FSelection: TBatpro_Ligne;
    procedure SetSelection(const Value: TBatpro_Ligne);
  protected
    property Selection: TBatpro_Ligne read FSelection write SetSelection;
  end;

var
  fRechercheBatpro_Ligne: TfRechercheBatpro_Ligne;

implementation

{$R *.dfm}

procedure TfRechercheBatpro_Ligne.Loaded;
begin
     inherited;
end;

procedure TfRechercheBatpro_Ligne.Avant_OnCreate;
begin
     Classe_Elements:= nil;
     sl:= nil;
     bme:= nil;
     pool:= nil;
     FSelection:= nil;
     _from_sl_running:= False;
     Contexte:= ct_Masque;
end;

procedure TfRechercheBatpro_Ligne.Apres_OnCreate;
begin
     hTriColonne:= ThTriColonneChamps_StringGrid.Create( sg, pool, lTri);
     hd:= ThDessinnateur.Create( Contexte, sg, Name, nil);
     hd.Curseur_Colonne:= 0;
end;

procedure TfRechercheBatpro_Ligne.Avant_OnDestroy;
begin
     Free_nil( hd);
     Free_nil( hTriColonne);
end;

constructor TfRechercheBatpro_Ligne.Create(AOwner: TComponent);
begin
     Avant_OnCreate;
     inherited;
     if OldCreateOrder
     then
         Apres_OnCreate;
end;

procedure TfRechercheBatpro_Ligne.AfterConstruction;
begin
     inherited;
     if not OldCreateOrder
     then
         Apres_OnCreate;
end;

procedure TfRechercheBatpro_Ligne.BeforeDestruction;
begin
     if not OldCreateOrder
     then
         Avant_OnDestroy;
     inherited;
end;

destructor TfRechercheBatpro_Ligne.Destroy;
begin
     if OldCreateOrder
     then
         Avant_OnDestroy;
     inherited;
end;

procedure TfRechercheBatpro_Ligne.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
end;

function TfRechercheBatpro_Ligne.LigneUnique: Boolean;
begin
     Result:= sl.Count = 1;
end;

procedure TfRechercheBatpro_Ligne.Avant_Execute;
begin

end;

function TfRechercheBatpro_Ligne.Execute( _bme:TBatproMaskElement; _bme_PreExecute:Boolean):Boolean;
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
                    hd.Drag_Ligne:= 0;
                    Result:= True;
                    end;
                  bmed_Dernier:
                    begin
                    hd.Drag_Ligne:= sl.Count - 1;
                    Result:= True;
                    end;
                  end
            else
                Result:= inherited Execute;

        if Result
        then
            begin
            bl:= Batpro_Ligne_from_sl( sl, hd.Drag_Ligne);
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

procedure TfRechercheBatpro_Ligne.FormShow(Sender: TObject);
begin
     inherited;
     sg.SetFocus;
end;

procedure TfRechercheBatpro_Ligne.AfterSelect;
begin

end;

procedure TfRechercheBatpro_Ligne._from_sl;
//var
//   W: Integer;
begin
     if _from_sl_running then exit;
     try
        _from_sl_running:= True;
        //W:= GetSystemMetrics( SM_CXVSCROLL);

        Vide_StringGrid( sg);
        sg.ColCount:= 2;
        sg.RowCount:= sl.Count;
        hd.Charge_Colonne( sl, 1, 0);
        //sg.ColWidths[ 0]:= sg.ClientWidth - W;
        hd.Traite_Dimensions;
     finally
            _from_sl_running:= False;
            end;
end;

procedure TfRechercheBatpro_Ligne.sgDblClick(Sender: TObject);
begin
     hd.Drag_Ligne:= sg.Row;
     aValidation.Execute;
end;

procedure TfRechercheBatpro_Ligne.sgMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
   be: TBatpro_Element;
begin
     if Button <> mbRight then exit;

     be:= hd.sg_be( hd.Drag_Colonne, hd.Drag_Ligne);
     if be = nil then exit;

     if not (be is Classe_Elements) then exit;

     be.ClassParams.Edit_ContexteFont( Contexte);
     sg.Refresh;
end;

procedure TfRechercheBatpro_Ligne.SetSelection(const Value: TBatpro_Ligne);
begin
     if Assigned( FSelection) then FSelection.Selected:= False;
     FSelection := Value;
     if Assigned( FSelection) then FSelection.Selected:= True;

     sg.Refresh;
end;

end.
