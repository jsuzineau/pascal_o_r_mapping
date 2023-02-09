unit ufjsCompta;

{$mode objfpc}{$H+}

interface

uses
    udmDatabase,

    ublFacture,

    ufClient,
    ufPiece_dsb3,
    ufFacture,
    ufFacture_non_reglee,
    ufMois_dsb,

  ufPatternMainMenu, Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  StdCtrls, ExtCtrls, ucDockableScrollbox;

type

 { TfjsCompta }

 TfjsCompta
 =
  class(TForm)
   bFacture: TButton;
   bFacture_non_reglee: TButton;
   bPiece: TButton;
   bMois: TButton;
   bClient: TButton;
   procedure bClientClick(Sender: TObject);
   procedure bFactureClick(Sender: TObject);
   procedure bFacture_non_regleeClick(Sender: TObject);
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

procedure TfjsCompta.bFacture_non_regleeClick(Sender: TObject);
begin
     fFacture_non_reglee.Execute;
end;

procedure TfjsCompta.bClientClick(Sender: TObject);
begin
     fClient.Execute;
end;

procedure TfjsCompta.bPieceClick(Sender: TObject);
begin
     fPiece_dsb3.Execute;
end;

procedure TfjsCompta.bMoisClick(Sender: TObject);
begin
     fMois_dsb.Execute;
end;

end.

