program jsFichiers;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

uses
{$IFnDEF FPC}
{$ELSE}
  Interfaces,
{$ENDIF}
  Forms,
  ufjsFichiers in 'ufjsFichiers.pas' {fjsFichiers},
  uthjsFichiers in 'uthjsFichiers.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfjsFichiers, fjsFichiers);
  Application.Run;
end.
