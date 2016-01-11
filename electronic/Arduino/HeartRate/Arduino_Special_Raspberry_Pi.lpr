program Arduino_Special_Raspberry_Pi;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, LazSerialPort_special_Raspberry_Pi, ufArduino,
  upoolPouls, ublPouls;

{$R *.res}

begin
  //RequireDerivedFormResource := True;
  Application.Initialize;
  Application.CreateForm(TfArduino, fArduino);
  Application.Run;
end.

