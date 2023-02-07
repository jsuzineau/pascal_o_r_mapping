unit ufjsCompta;

{$mode objfpc}{$H+}

interface

uses
    udmDatabase,

    ublPiece,
    upoolPiece,

    ufPiece_dsb,
    ufFacture,
    ufMois_dsb,

  ufPatternMainMenu, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ucDockableScrollbox;

type

 { TfjsCompta }

 TfjsCompta
 =
  class(TForm)
   bFacture: TButton;
   bPiece: TButton;
   bMois: TButton;
   procedure bFactureClick(Sender: TObject);
   procedure bMoisClick(Sender: TObject);
   procedure bPieceClick(Sender: TObject);
   procedure FormCreate(Sender: TObject);
  private
   //fPiece: TfPiece_dsb;
  public

  end;

var
 fjsCompta: TfjsCompta;

implementation

{$R *.lfm}

{ TfjsCompta }

procedure TfjsCompta.FormCreate(Sender: TObject);
begin
     Caption:= Caption+' - '+dmDatabase.jsDataConnexion.Base_sur;
     {
     fPiece:= TfPiece_dsb.Create( Self);
     ClientWidth := fPiece.Width;
     ClientHeight:= fPiece.Height;
     fPiece.Parent:= Self;
     fPiece.Align:= alClient;
     fPiece.BorderStyle:= bsNone;
     fPiece.Execute;
     }
end;

procedure TfjsCompta.bFactureClick(Sender: TObject);
begin
     fFacture.Execute;
end;

procedure TfjsCompta.bPieceClick(Sender: TObject);
begin
     fPiece_dsb.Execute;
end;

procedure TfjsCompta.bMoisClick(Sender: TObject);
begin
     fMois_dsb.Execute;
end;

end.

