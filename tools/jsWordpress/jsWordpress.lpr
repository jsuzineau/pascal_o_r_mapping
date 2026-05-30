program jsWordpress;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 {$IFDEF HASAMIGA}
 athreads,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ujsWordpress_API_Client, uPascal_nom_app_API_Client, ufjsWordpress
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 {$PUSH}{$WARN 5044 OFF}
 Application.MainFormOnTaskbar:=True;
 {$POP}
 Application.Initialize;
 Application.CreateForm(TfjsWordpress, fjsWordpress);
 Application.Run;
end.

