unit ufPhi;

{$mode objfpc}{$H+}

interface

uses
    uPhi,
    uPhi_Form,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

 { TfPhi }

 TfPhi = class(TForm)
  bDown_horizontal: TButton;
  bDown_vertical: TButton;
  bLeft: TButton;
  bUp_horizontal: TButton;
  bUp_vertical: TButton;
  m: TMemo;
  Panel1: TPanel;
  t: TTimer;
  procedure bDown_horizontalClick(Sender: TObject);
  procedure bLeftClick(Sender: TObject);
  procedure bUp_horizontalClick(Sender: TObject);
  procedure bDown_verticalClick(Sender: TObject);
  procedure bUp_verticalClick(Sender: TObject);
  procedure FormCreate(Sender: TObject);
  procedure FormResize(Sender: TObject);
  procedure tTimer(Sender: TObject);
 private
  FormResize_running: Boolean;
  procedure Log_Top_Left( _S: String);
  procedure Do_resize;
 public

 end;

var
 fPhi: TfPhi;

implementation

{$R *.lfm}

{ TfPhi }

procedure TfPhi.FormCreate(Sender: TObject);
begin
     Log_Top_Left( 'FormCreate');
     FormResize_running:= False;
end;

procedure TfPhi.FormResize(Sender: TObject);
begin
     if FormResize_running then exit;
     try
        //Do_resize;
        t.Enabled:= False;
        t.Enabled:= True;
     finally
            FormResize_running:= False;
            end;
end;

procedure TfPhi.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     Do_resize;
end;

procedure TfPhi.Do_resize;
begin
     Log_Top_Left( 'Do_resize, début');
     Phi_Form_Up_horizontal    ( Self);
     Log_Top_Left( 'Do_resize, fin');
end;

procedure TfPhi.Log_Top_Left( _S: String);
begin
     m.Lines.Add(_S);
     //m.Lines.Add('Left  : '+Format('%4d', [Left  ]));
     m.Lines.Add('Top   : '+Format('%4d', [Top   ]));
     //m.Lines.Add('Width : '+Format('%4d', [Width ]));
     m.Lines.Add('Height: '+Format('%4d', [Height]));
end;

procedure TfPhi.bUp_horizontalClick(Sender: TObject);
begin
     Phi_Form_Up_horizontal    ( Self);
end;

procedure TfPhi.bDown_horizontalClick(Sender: TObject);
begin
     Phi_Form_Down_horizontal  ( Self);
end;

procedure TfPhi.bLeftClick(Sender: TObject);
begin
     Left:= Left;
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

