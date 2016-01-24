program fug_hDessinnateur_web;

{$mode objfpc}{$H+}

uses
    uhDessinnateurWeb, ubeCoche, uClean,
    utc_hDessinnateur_web,
  Interfaces, Forms, GuiTestRunner;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

