program test;

uses
  {$IFDEF FPC}
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  {$ELSE}
  Vcl.Forms,
  {$ENDIF}
  ufTest in 'ufTest.pas' {fTest},
  uCSS_Style_Parser_PYACC in 'generated\uCSS_Style_Parser_PYACC.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
 Application.CreateForm(TfTest, fTest);
  Application.Run;
end.
