program jsLignes;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  {$ifdef unix}
    cthreads,
    cmem, // the c memory manager is on some systems much faster for multi-threading
  {$endif}
  Interfaces,
{$ENDIF}
  Forms,
  ufjsLignes in 'ufjsLignes.pas' {fjsLignes},
  uthjsLignes in 'uthjsLignes.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfjsLignes, fjsLignes);
  Application.Run;
end.
