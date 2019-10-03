program AMS_Spectrometer;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, tachartlazaruspkg, LazSerialPort, ufAMS_Spectrometer, uAMS_AS7265x
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfAMS_Spectrometer, fAMS_Spectrometer);
 Application.Run;
end.

