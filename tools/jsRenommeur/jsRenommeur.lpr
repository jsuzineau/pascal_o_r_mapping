program jsRenommeur;

{$MODE Delphi}

uses
  Forms, Interfaces,
  ufjsRenommeur in 'ufjsRenommeur.pas' {fjsRenommeur};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfjsRenommeur, fjsRenommeur);
  Application.Run;
end.
