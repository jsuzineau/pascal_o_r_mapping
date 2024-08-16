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
 udkTexte_display, ufChargement
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfjsKaraoke, fjsKaraoke);
 Application.CreateForm(TfChargement, fChargement);
 Application.Run;
end.

