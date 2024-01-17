program jsWorks;

{$mode objfpc}

uses
 browserconsole, browserapp, JS, Classes, SysUtils, Web;

type
 TMyApplication = class(TBrowserApplication)
  procedure doRun; override;
 end;

procedure TMyApplication.doRun;
var
   hr:TJSXMLHttpRequest;
begin
     hr:= TJSXMLHttpRequest.new;
     hr.Open('GET', 'Project');
     hr.addEventListener
       (
       'load',
       procedure
       begin
            writeln( hr.responseText);
       end
       );
     hr.send;
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
