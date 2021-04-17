program GROVE_barometer_bmp280;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 {$IFDEF MSWINDOWS}
 windows,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, tachartlazaruspkg, LazSerialPort, uPool, ufGROVE_barometer_bmp280,
 ublMesure, upoolMesure, uhfMesure
 { you can add units after this };

{$R *.res}

begin
 {$IFDEF MSWINDOWS} //enlever truc pour afficher la console
 AllocConsole;      // in Windows unit
 IsConsole := True; // in System unit
 SysInitStdIO;      // in System unit
 {$ENDIF}
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfGROVE_barometer_bmp280, fGROVE_barometer_bmp280);
 Application.Run;
end.

