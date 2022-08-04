program Generateur_Modeles;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 {$IFDEF HASAMIGA}
 athreads,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufGenerateur_Modeles
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfGenerateur_Modeles, fGenerateur_Modeles);
 Application.Run;
end.

