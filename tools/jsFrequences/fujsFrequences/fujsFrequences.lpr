program fujsFrequences;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, utcFrequence, uFrequence, utcFrequences;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

