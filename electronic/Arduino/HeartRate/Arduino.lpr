program Arduino;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms, tachartlazaruspkg, ufArduino, LazSerialPort
  { you can add units after this };

{$R *.res}

begin
  //RequireDerivedFormResource := True;
  Application.Initialize;
 Application.CreateForm(TfArduino, fArduino);
  Application.Run;
end.

