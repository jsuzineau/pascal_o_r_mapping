program TestOpen;

uses
  Forms,
  Unit1 in 'Unit1.pas' {Form1},
  OOoTools in 'OOoTools.pas',
  OOoConstants in 'OOoConstants.pas',
  OOoXray in 'OOoXray.pas' {xrayForm1},
  OOoXray2 in 'OOoXray2.pas' {xrayForm2},
  OOoXray3 in 'OOoXray3.pas' {xrayForm3},
  OOoExamples in 'OOoExamples.pas',
  OOoMessages in 'OOoMessages.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TxrayForm1, xrayForm1);
  Application.CreateForm(TxrayForm2, xrayForm2);
  Application.CreateForm(TxrayForm3, xrayForm3);
  Application.Run;
end.
