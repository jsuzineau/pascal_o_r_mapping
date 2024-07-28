unit ufjsPaneurythmie;

{$mode objfpc}{$H+}

interface

uses
  uPhi_Form,
  udmDatabase,
  ufMedia_dsb,
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs,
  ExtCtrls, StdCtrls, lclvlc;

type

 { TfjsPaneurythmie }

 TfjsPaneurythmie = class(TForm)
  bOptions: TButton;
  p: TPanel;
  Panel1: TPanel;
  vlc: TLCLVLCPlayer;
  procedure bOptionsClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
 private

 public

 end;

var
 fjsPaneurythmie: TfjsPaneurythmie;

implementation

{$R *.lfm}

{ TfjsPaneurythmie }

procedure TfjsPaneurythmie.FormCreate(Sender: TObject);
begin
     Caption:= Caption+' - '+dmDatabase.jsDataConnexion.Base_sur;
     ThPhi_Form.Create( Self);
end;

procedure TfjsPaneurythmie.bOptionsClick(Sender: TObject);
begin
     fMedia_dsb.Execute;
end;

end.

