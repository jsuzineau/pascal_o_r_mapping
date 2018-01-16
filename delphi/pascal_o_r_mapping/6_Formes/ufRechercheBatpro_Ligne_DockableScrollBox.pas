unit ufRechercheBatpro_Ligne_DockableScrollBox;
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

  Windows, Messages, SysUtils, Classes, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs,
  FMX.ActnList, FMX.ComCtrls, FMX.StdCtrls, Buttons, FMX.ExtCtrls, Grids, DBGrids,
  Db, DBTables, FMTBcd, Provider, SqlExpr, DBClient, ucDockableScrollBox,
  FMX.Menus;

type
 TfRechercheBatpro_Ligne_DockableScrollBox
 =
  class(TfpBas)
    pHaut: TPanel;
    pSG: TPanel;
    gbSaisie: TGroupBox;
    bCreationModification: TButton;
    dsb: TDockableScrollBox;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure dsbValidate(Sender: TObject);
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
  fRechercheBatpro_Ligne_DockableScrollBox: TfRechercheBatpro_Ligne_DockableScrollBox;

implementation

{$R *.fmx}

procedure TfRechercheBatpro_Ligne_DockableScrollBox.Loaded;
begin
     inherited;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.Avant_OnCreate;
begin
     Classe_Elements:= nil;
     sl:= nil;
     bme:= nil;
     pool:= nil;
     _from_sl_running:= False;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.Apres_OnCreate;
begin
     dsb.Classe_Elements:= Classe_Elements;
     dsb.Tri:= pool.Tri;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.Avant_OnDestroy;
begin
end;

constructor TfRechercheBatpro_Ligne_DockableScrollBox.Create(AOwner: TComponent);
begin
     Avant_OnCreate;
     inherited;
     if OldCreateOrder
     then
         Apres_OnCreate;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.AfterConstruction;
begin
     inherited;
     if not OldCreateOrder
     then
         Apres_OnCreate;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.BeforeDestruction;
begin
     if not OldCreateOrder
     then
         Avant_OnDestroy;
     inherited;
end;

destructor TfRechercheBatpro_Ligne_DockableScrollBox.Destroy;
begin
     if OldCreateOrder
     then
         Avant_OnDestroy;
     inherited;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.FormCreate(Sender: TObject);
begin
     inherited;
     Maximiser:= False;
end;

function TfRechercheBatpro_Ligne_DockableScrollBox.LigneUnique: Boolean;
begin
     Result:= sl.Count = 1;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.Avant_Execute;
begin

end;

function TfRechercheBatpro_Ligne_DockableScrollBox.Execute( _bme:TBatproMaskElement; _bme_PreExecute:Boolean):Boolean;
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

        Avant_Execute;

        _from_sl;

        Result:= LigneUnique and not EXE_INI.Delphi_autonome;

        if not Result
        then
            if _bme_PreExecute
            then
                begin
                if bme = nil //mis pour éviter une exception dans le planning journalier
                then         //pas trop propre, en principe on ne doit pas avoir bme = nil ici
                    begin
                    end
                else
                    case bme.Default
                    of
                      bmed_Aucun  : ;
                      bmed_Premier: begin dsb.Goto_Premier; Result:= True; end;
                      bmed_Dernier: begin dsb.Goto_Dernier; Result:= True; end;
                      end;
                end
            else
                Result:= inherited Execute;

        if Result
        then
            begin
            dsb.Get_bl( bl);
            Traite_bl;
            end
        else
            if _bme_PreExecute //cas _bme_PreExecute, bme.Default = bmed_Aucun
               and Assigned( bme)
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
            dsb.sl:= nil;//Vidage aprés exécution
            end;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.FormShow(Sender: TObject);
begin
     inherited;
     dsb.SetFocus;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.AfterSelect;
begin

end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox._from_sl;
begin
     if _from_sl_running then exit;
     try
        _from_sl_running:= True;

        dsb.sl:= sl;
     finally
            _from_sl_running:= False;
            end;
end;

procedure TfRechercheBatpro_Ligne_DockableScrollBox.dsbValidate( Sender: TObject);
begin
     aValidation.Execute;
end;

end.
