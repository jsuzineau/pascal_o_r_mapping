program fuQuasi_prime;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, utcQuasi_prime;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

