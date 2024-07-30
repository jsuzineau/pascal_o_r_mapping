program jsPaneurythmie;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 {$IFDEF HASAMIGA}
 athreads,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufjsPaneurythmie,
 ufMedia_dsb, udkMedia_edit, udkMedia_display, ublMedia, upoolMedia, uhfMedia
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfjsPaneurythmie, fjsPaneurythmie);
 Application.Run;
end.

