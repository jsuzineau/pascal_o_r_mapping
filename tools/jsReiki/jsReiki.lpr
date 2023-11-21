program jsReiki;

{$MODE Delphi}

uses
  Forms, Interfaces,
  ufjsReiki in 'ufjsReiki.pas' {fjsReiki};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfjsReiki, fjsReiki);
  Application.Run;
end.
