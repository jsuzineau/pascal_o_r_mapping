program Dock;

uses
  FMX.Forms,
  ufDock in 'ufDock.pas' {fDock},
  ufSource in 'ufSource.pas' {fSource};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfDock, fDock);
  Application.CreateForm(TfSource, fSource);
  Application.Run;
end.
