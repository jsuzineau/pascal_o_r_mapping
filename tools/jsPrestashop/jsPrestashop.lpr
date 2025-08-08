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
 upoolIP, uacCloud_Filter, ublReputation, upoolReputation, ufReputation_dsb,
 udkReputation_edit, ufIP_Address_CSV
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfjsPrestashop, fjsPrestashop);
 Application.CreateForm(TfIP_Address_CSV, fIP_Address_CSV);
 Application.Run;
end.

