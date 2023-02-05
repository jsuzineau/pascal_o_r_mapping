unit ufPatternMainMenu;

interface

uses
  Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, Menus, ActnList, StdCtrls, ComCtrls, Buttons, ExtCtrls,
  ufAnnee_dsb,
  ufClient_dsb,
  ufFacture_dsb,
  ufFacture_Ligne_dsb,
  ufMois_dsb,
  ufPiece_dsb,
  
  uClean;

type
 TfPatternMainMenu
 =
  class(TForm)
    mm: TMainMenu;
    miBase: TMenuItem;
    miVide: TMenuItem;
    miRelations: TMenuItem;
    miRelationVide: TMenuItem;
    miBaseCalcule: TMenuItem;
    miBaseCalculeVide: TMenuItem;
    miRelationsCalcule: TMenuItem;
    miRelationsCalculeVide: TMenuItem;
    procedure FormCreate(Sender: TObject);
        procedure AnneeClick(Sender: TObject);
    procedure ClientClick(Sender: TObject);
    procedure FactureClick(Sender: TObject);
    procedure Facture_LigneClick(Sender: TObject);
    procedure MoisClick(Sender: TObject);
    procedure PieceClick(Sender: TObject);

  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

function fPatternMainMenu: TfPatternMainMenu;

implementation

{$R *.lfm}

var
   FfPatternMainMenu: TfPatternMainMenu;

function fPatternMainMenu: TfPatternMainMenu;
begin
     Clean_Get( Result, FfPatternMainMenu, TfPatternMainMenu);
end;

{ TfPatternMainMenu }

procedure TfPatternMainMenu.FormCreate(Sender: TObject);
begin
     inherited;
     miVide        .Visible:= False;
     miRelationVide.Visible:= False;
     miBaseCalculeVide     .Visible:= False;
     miRelationsCalculeVide.Visible:= False;
end;

procedure TfPatternMainMenu.AnneeClick(Sender: TObject);
begin
     fAnnee_dsb.Execute;
end;

procedure TfPatternMainMenu.ClientClick(Sender: TObject);
begin
     fClient_dsb.Execute;
end;

procedure TfPatternMainMenu.FactureClick(Sender: TObject);
begin
     fFacture_dsb.Execute;
end;

procedure TfPatternMainMenu.Facture_LigneClick(Sender: TObject);
begin
     fFacture_Ligne_dsb.Execute;
end;

procedure TfPatternMainMenu.MoisClick(Sender: TObject);
begin
     fMois_dsb.Execute;
end;

procedure TfPatternMainMenu.PieceClick(Sender: TObject);
begin
     fPiece_dsb.Execute;
end;



initialization
              Clean_Create ( FfPatternMainMenu, TfPatternMainMenu);
finalization
              Clean_Destroy( FfPatternMainMenu);
end.

