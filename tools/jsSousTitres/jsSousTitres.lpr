program jsSousTitres;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufjsSousTitres, uFichierASS, uFichierODT, ufTableaux
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfjsSousTitres, fjsSousTitres);
 Application.CreateForm(TfTableaux, fTableaux);
 Application.Run;
end.

