program pLabel;

uses
  FMX.Forms,
  ufLabel in 'ufLabel.pas' {Form1};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
