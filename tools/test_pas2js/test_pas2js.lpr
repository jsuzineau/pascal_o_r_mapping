program test_pas2js;

{$mode objfpc}

uses
 browserconsole, browserapp, JS, Classes, SysUtils, Web;

type
 TMyApplication = class(TBrowserApplication)
  procedure doRun; override;
 end;

procedure TMyApplication.doRun;

begin
     // Your code here
     WriteLn( 'Hello World !');
     Terminate;
end;

var
 Application : TMyApplication;

begin
 Application:=TMyApplication.Create(nil);
 Application.Initialize;
 Application.Run;
 Application.Free;
end.
