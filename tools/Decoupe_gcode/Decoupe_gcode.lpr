program Decoupe_gcode;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, uEXE_INI, ufDecoupe_gcode, uFichierGCODE
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Initialize;
 Application.CreateForm(TfDecoupe_gcode, fDecoupe_gcode);
 Application.Run;
end.

