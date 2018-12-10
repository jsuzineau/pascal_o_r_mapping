program jsLignes;

uses
  Forms,
  ufjsLignes in 'ufjsLignes.pas' {fjsLignes},
  uthjsLignes in 'uthjsLignes.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfjsLignes, fjsLignes);
  Application.Run;
end.
