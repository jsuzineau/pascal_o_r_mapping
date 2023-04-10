program test_rust;

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 {$IFDEF HASAMIGA}
 athreads,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, ufTest_rust
 {$IFDEF MSWINDOWS}
   ,Windows
 {$ENDIF}
 { you can add units after this };

{$R *.res}

begin
     //To activate the console in Windows
     {$IFDEF MSWINDOWS}
       AllocConsole;      // in Windows unit
       IsConsole := True; // in System unit
       SysInitStdIO;      // in System unit
     {$ENDIF}


     RequireDerivedFormResource:=True;
 Application.Scaled:=True;
     Application.Initialize;
     Application.CreateForm(TfTest_rust, fTest_rust);
     Application.Run;
end.

