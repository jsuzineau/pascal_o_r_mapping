program jsFichiers;

uses
  Forms,
  ufjsFichiers in 'ufjsFichiers.pas' {fjsFichiers},
  uthjsFichiers in 'uthjsFichiers.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TfjsFichiers, fjsFichiers);
  Application.Run;
end.
