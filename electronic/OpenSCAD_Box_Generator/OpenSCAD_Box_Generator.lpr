program OpenSCAD_Box_Generator;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufOpenSCAD_Box_Generator
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Initialize;
 Application.CreateForm(TfOpenSCAD_Box_Generator, fOpenSCAD_Box_Generator);
 Application.Run;
end.

