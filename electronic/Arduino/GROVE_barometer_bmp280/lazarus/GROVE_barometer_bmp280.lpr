program GROVE_barometer_bmp280;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, tachartlazaruspkg, LazSerialPort, ufGROVE_barometer_bmp280
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfGROVE_barometer_bmp280, fGROVE_barometer_bmp280);
 Application.Run;
end.

