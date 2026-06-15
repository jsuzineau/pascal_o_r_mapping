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
 Forms, ujsWordpress_API_Client, ufjsWordpress, urust_html_clean, ufHTML,
uWordpress_verb;

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 {$PUSH}{$WARN 5044 OFF}
 Application.MainFormOnTaskbar:=True;
 {$POP}
 Application.Initialize;
 Application.CreateForm(TfjsWordpress, fjsWordpress);
 Application.CreateForm(TfHTML, fHTML);
 Application.Run;
end.

