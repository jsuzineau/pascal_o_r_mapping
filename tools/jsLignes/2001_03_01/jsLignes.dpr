program jsLignes;

uses
  Forms,
  ufjsLignes in 'ufjsLignes.pas' {Form1},
  ujsLignes in 'ujsLignes.pas',
  ujsLignesTree in 'ujsLignesTree.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
