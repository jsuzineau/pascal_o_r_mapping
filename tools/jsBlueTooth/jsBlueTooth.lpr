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
 Forms, ufjsBlueTooth, uWinSock2_BlueTooth, uWinSock2_BlueTooth_Devices, 
uWinSock2_BlueTooth_Server, uWinSock2_BlueTooth_Client
 { you can add units after this };

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

