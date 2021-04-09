unit ufCanvas;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, uGeometrie;

type

 { TfCanvas }

 TfCanvas = class(TForm)
  pb: TPaintBox;
  procedure pbPaint(Sender: TObject);
 private

 public

 end;

var
 fCanvas: TfCanvas;

implementation

{$R *.lfm}

{ TfCanvas }

procedure TfCanvas.pbPaint(Sender: TObject);
var

begin

end;

end.

