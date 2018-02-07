program Search_and_replace;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufSearch_and_replace
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Initialize;
 Application.CreateForm(TfSearch_and_replace, fSearch_and_replace);
 Application.Run;
end.

