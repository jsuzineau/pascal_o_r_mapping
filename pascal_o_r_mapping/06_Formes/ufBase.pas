unit ufBase;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
  uhTriColonneChamps,
  uBatpro_Ligne,
  uPool,
  
  ufpBas,
  ucChampsGrid,
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, DBCtrls, Grids, DBGrids, ActnList, StdCtrls, ComCtrls, Buttons,
  ExtCtrls, DB, Menus;

type

 { TfBase }

 TfBase
 =
  class(TfpBas)
    pc: TPageControl;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    cg: TChampsGrid;
    bImprimer: TBitBtn;
    Label1: TLabel;
    lNbTotal: TLabel;
    Panel3: TPanel;
    cbReadOnly: TCheckBox;
    aReadOnly_Change: TAction;
    Label2: TLabel;
    lTri: TLabel;
    bNouveau: TButton;
    bSupprimer: TButton;
    procedure FormCreate(Sender: TObject);
    procedure aReadOnly_ChangeExecute(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure cgSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure bNouveauClick(Sender: TObject);
    procedure bSupprimerClick(Sender: TObject);
  private
    { D�clarations priv�es }
    procedure NbTotal_Change;
  public
    { D�clarations publiques }
    pool: TPool;
    EntreeLigneColonne_: Boolean;
    function Execute: Boolean; override;
  //Gestion du tri
  protected
    hTriColonneChamps: ThTriColonneChamps;
  //Rafraichissement
  protected
    procedure _from_pool; virtual;
  end;

implementation

{$R *.lfm}

{ TfBase }

procedure TfBase.FormCreate(Sender: TObject);
begin
     inherited;
     EntreeLigneColonne_:= False;
     pool.pFiltreChange.Abonne( Self, NbTotal_Change);
     cg.OnSelectCell:= nil;
     hTriColonneChamps
     :=
       ThTriColonneChamps.Create( cg, pool, lTri);
     hTriColonneChamps.OnSelectCell:= cgSelectCell;
end;

procedure TfBase.FormDestroy(Sender: TObject);
begin
     Free_nil( hTriColonneChamps);
     pool.pFiltreChange.Desabonne( Self, NbTotal_Change);
     inherited;
end;

procedure TfBase.cgSelectCell( Sender: TObject; ACol, ARow: Integer;
                               var CanSelect: Boolean);
begin
     pool.TrierFiltre;
end;

procedure TfBase.NbTotal_Change;
begin
     lNbTotal.Caption:= IntToStr( pool.slFiltre.Count);
end;

procedure TfBase.aReadOnly_ChangeExecute(Sender: TObject);
begin
     if cbReadOnly.Checked
     then
         cg.Options:= cg.Options - [goEditing]
     else
         cg.Options:= cg.Options + [goEditing];
end;

function TfBase.Execute: Boolean;
begin
     cbReadOnly.Checked:= True;
     aReadOnly_Change.Execute;
     pool.ToutCharger;
     _from_pool;
     Result:= inherited Execute;
end;

procedure TfBase._from_pool;
begin
     cg.sl:= pool.slFiltre;
     //cg.sl:= pool.T;
end;

procedure TfBase.bNouveauClick(Sender: TObject);
var
   blNouveau, bl: TBatpro_Ligne;
   I: Integer;
begin
     pool.Nouveau_Base( blNouveau);
     if blNouveau = nil then exit;

     cg.sl:= nil;
     _from_pool;
     for I:= 1 to cg.RowCount - 1
     do
       begin
       cg.Row:= I;
       cg.Get_bl( bl);
       if bl = blNouveau then break;
       end;
end;

procedure TfBase.bSupprimerClick(Sender: TObject);
var
   bl: TBatpro_Ligne;
begin
     cg.Get_bl( bl);
     if bl = nil then exit;

     if mrYes
        <>
        MessageDlg( '�tes vous s�r de vouloir supprimer la ligne ?'#13#10
                    +bl.Cell[0],
                    mtConfirmation, [mbYes, mbNo], 0)
     then
         exit;

     pool.Supprimer( bl);
     _from_pool;
end;

end.
object StringGrid1: TStringGrid
  Left = 220
  Height = 100
  Top = 90
  Width = 200
  TabOrder = 2
end
