program FileTree;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 //{$IFDEF MSWINDOWS} //this added to display the console
 //Windows,
 //{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms,
 ufFileTree, ufFileVirtualTree, uFileTree, uFileVirtualTree,
 uFileVirtualTree_odt, uText_to_PDF;

{$R *.res}

begin
 (*
 {$IFDEF MSWINDOWS} //this added to display the console
 AllocConsole;      // in Windows unit
 IsConsole := True; // in System unit
 SysInitStdIO;      // in System unit
 {$ENDIF}
 *)
 RequireDerivedFormResource:=True;
 Application.Scaled:=True;
 Application.Initialize;
 Application.CreateForm(TfFileVirtualTree, fFileVirtualTree);
 Application.CreateForm(TfFileTree, fFileTree);
 Application.Run;
end.

