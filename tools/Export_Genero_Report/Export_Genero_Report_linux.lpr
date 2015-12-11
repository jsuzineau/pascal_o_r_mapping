program Export_Genero_Report_linux;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufExport_Genero_Report, uGenero_Report_from_ODRE_Table,
 uGenero_Report_from_Dataset
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource := True;
 Application.Initialize;
 Application.CreateForm(TfExport_Genero_Report, fExport_Genero_Report);
 Application.Run;
end.

