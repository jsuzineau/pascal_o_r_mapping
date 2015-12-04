program rdd_explorer_linux;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufRDD_Explorer, uRDD, uVide
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource := True;
 Application.Initialize;
 Application.CreateForm(TfRDD_Explorer, fRDD_Explorer);
 Application.Run;
end.

