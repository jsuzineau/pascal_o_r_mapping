program jsPrestashop;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 {$IFDEF HASAMIGA}
 athreads,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufjsPrestashop, uhfIP, ufIP_dsb, udkIP_edit, udkIP_display, ublIP,
 upoolIP, uacCloud_Filter
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfjsPrestashop, fjsPrestashop);
 Application.Run;
end.

