program Infrason;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, tachartlazaruspkg, LazSerialPort, uPool, lmcomponents, ufInfrason,
 ublMesure, uhfMesure, upoolMesure
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfInfrason, fInfrason);
 Application.Run;
end.

