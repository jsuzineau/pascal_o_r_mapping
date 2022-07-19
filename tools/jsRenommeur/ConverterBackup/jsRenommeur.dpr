program jsRenommeur;

uses
  Forms,
  ufjsRenommeur in 'ufjsRenommeur.pas' {fjsRenommeur};

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfjsRenommeur, fjsRenommeur);
  Application.Run;
end.
