program fujsCompta;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, utcAnnee, upoolAnnee, utcFacture, upoolFacture, utcMois,
  upoolMois, utcPiece, upoolPiece, utcClient, upoolClient, GuiTestRunner;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

