program Generateur_source;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, ufGenerateur_source
  { you can add units after this };

{$R *.res}

begin
  Application.Initialize;
 Application.CreateForm(TfGenerateur_source, fGenerateur_source);
  Application.Run;
end.

