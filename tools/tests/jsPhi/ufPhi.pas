unit ufPhi;

{$mode objfpc}{$H+}

interface

uses
    uPhi,
    uPhi_Form,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

 { TfPhi }

 TfPhi = class(TForm)
  bDown_horizontal: TButton;
  bUp_horizontal: TButton;
  bDown_vertical: TButton;
  bUp_vertical: TButton;
  procedure bDown_horizontalClick(Sender: TObject);
  procedure bUp_horizontalClick(Sender: TObject);
  procedure bDown_verticalClick(Sender: TObject);
  procedure bUp_verticalClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormResize(Sender: TObject);
 private
 public

 end;

var
 fPhi: TfPhi;

implementation

{$R *.lfm}

{ TfPhi }

procedure TfPhi.FormCreate(Sender: TObject);
begin

end;

procedure TfPhi.FormResize(Sender: TObject);
begin
     Phi_Form_Up_horizontal    ( Self);
end;

procedure TfPhi.bUp_horizontalClick(Sender: TObject);
begin
     Phi_Form_Up_horizontal    ( Self);
end;

procedure TfPhi.bDown_horizontalClick(Sender: TObject);
begin
     Phi_Form_Down_horizontal  ( Self);
end;

procedure TfPhi.bUp_verticalClick(Sender: TObject);
begin
     Phi_Form_Up_vertical      ( Self);
end;

procedure TfPhi.bDown_verticalClick(Sender: TObject);
begin
     Phi_Form_Down_vertical    ( Self);
end;

end.

