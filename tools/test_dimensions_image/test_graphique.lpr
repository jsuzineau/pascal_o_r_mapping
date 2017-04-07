program test_graphique;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, imagesforlazarus, ufTest_Graphique, uJPEG_File, uPNG_File, uDimensions_from_pasjpeg
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Initialize;
 Application.CreateForm(TfTest_Graphique, fTest_Graphique);
 Application.Run;
end.

