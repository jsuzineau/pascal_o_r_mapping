program FileTree;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, httpsend, uStreamLexer, uOpenDocument, uCSS_Style_Parser_PYACC,
 ufFileTree, ufFileVirtualTree, uFileTree, uFileVirtualTree,
 uFileVirtualTree_odt
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfFileVirtualTree, fFileVirtualTree);
 Application.CreateForm(TfFileTree, fFileTree);
 Application.Run;
end.

