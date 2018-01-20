program test;

uses
  System.StartUpCopy,
  FMX.Forms,
  ufTest in 'ufTest.pas' {fTest};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfTest, fTest);
  Application.Run;
end.
