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
 uDBUS_BlueTooth_Devices
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

