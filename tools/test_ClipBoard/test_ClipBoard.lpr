program test_ClipBoard;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, uftest_ClipBoard
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(Tftest_ClipBoard, ftest_ClipBoard);
 Application.Run;
end.

