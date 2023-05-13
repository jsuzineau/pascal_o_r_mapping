unit ufSource;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation;

type
  TfSource = class(TForm)
    p: TPanel;
    b: TButton;
    l: TLabel;
  private
    { Déclarations privées }
  public
    { Déclarations publiques }
  end;

var
  fSource: TfSource;

implementation

{$R *.fmx}
{$R *.Windows.fmx MSWINDOWS}

end.
