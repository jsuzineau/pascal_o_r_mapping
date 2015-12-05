program Export_Genero_Report;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufExport_Genero_Report, uGenero_Report_XML
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource := True;
 Application.Initialize;
 Application.CreateForm(TfExport_Genero_Report, fExport_Genero_Report);
 Application.Run;
end.

