unit ufBase;
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
  uhTriColonneChamps,
  uBatpro_Ligne,
  uPool,

  ufpBas,
  ucChampsGrid,
  Windows, Messages, SysUtils, Variants, Classes, FMX.Graphics, FMX.Controls, FMX.Forms,
  FMX.Dialogs, FMX.Grid, FMX.ActnList, FMX.StdCtrls,VCL.ComCtrls,VCL.Buttons,
  FMX.ExtCtrls, DB, FMX.Menus,
  FMX.DialogService, UITypes;

type
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
    { Déclarations privées }
    procedure NbTotal_Change;
  public
    { Déclarations publiques }
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

{$R *.fmx}

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
     //hTriColonneChamps.OnSelectCell:= cgSelectCell;
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
     lNbTotal.Text:= IntToStr( pool.slFiltre.Count);
end;

procedure TfBase.aReadOnly_ChangeExecute(Sender: TObject);
begin
     if cbReadOnly.isChecked
     then
         cg.Options:= cg.Options - [TGridOption.Editing]
     else
         cg.Options:= cg.Options + [TGridOption.Editing];
end;

function TfBase.Execute: Boolean;
begin
     cbReadOnly.isChecked:= True;
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

     TDialogService
     .
      MessageDialog( 'Êtes vous sûr de vouloir supprimer la ligne ?'#13#10
                    +bl.Cell[0],
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
                     procedure (const _Result: TModalResult)
                     begin
                          if mrYes <> _Result then exit;
                          pool.Supprimer( bl);
                          _from_pool;
                     end
                     );
end;

end.
