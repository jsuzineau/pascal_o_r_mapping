program jsSousTitres;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, uBatpro_Ligne, ufjsSousTitres, uFichierASS, uFichierODT, ufTableaux,
 uOD_Table_Batpro, ublSousTitre, uodSousTitre
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

