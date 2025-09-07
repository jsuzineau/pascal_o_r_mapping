program jsBlueTooth;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 {$IFDEF HASAMIGA}
 athreads,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufjsBlueTooth,
 uDBUS_BlueTooth_Devices, uBlueZ_BlueTooth_Client, bluetoothlaz, 
uBlueZ_BlueTooth_Server, uDBUS, uDBUS_BlueTooth_SPP_Server_Register;

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 {$PUSH}{$WARN 5044 OFF}
 Application.MainFormOnTaskbar:=True;
 {$POP}
 Application.Initialize;
 Application.CreateForm(TfjsBlueTooth, fjsBlueTooth);
 Application.Run;
end.

