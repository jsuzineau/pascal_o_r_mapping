program jsKaraoke;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 {$IFDEF HASAMIGA}
 athreads,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufjsKaraoke, ublTexte, upoolTexte, uhfTexte, ufTexte_dsb, udkTexte_edit,
 udkTexte_display, udkTexte_display_1, udkTexte_display_3, ufChargement,
 udkTiming_edit, udkTiming_display, ublTiming, upoolTiming, ufTiming_dsb,
 ufTiming_Play, ufPlay
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfjsKaraoke, fjsKaraoke);
 Application.CreateForm(TfChargement, fChargement);
 Application.CreateForm(TfPlay, fPlay);
 Application.Run;
end.

