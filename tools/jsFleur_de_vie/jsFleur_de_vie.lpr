program jsFleur_de_vie;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 cmem,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufjsFleur_de_vie, uFleur_de_vie
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfjsFleur_de_vie, fjsFleur_de_vie);
 Application.Run;
end.

