program fuQuasi_prime;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, utcGeometrie, utcQuasi_prime, uGeometrie,
  uGeometrie_old, uGeometrie_Base;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

