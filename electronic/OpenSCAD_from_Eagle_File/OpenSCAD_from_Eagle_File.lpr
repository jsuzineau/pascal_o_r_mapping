program OpenSCAD_from_Eagle_File;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufOpenSCAD_from_Eagle_File
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Initialize;
 Application.CreateForm(TfOpenSCAD_from_Eagle_File, fOpenSCAD_from_Eagle_File);
 Application.Run;
end.

