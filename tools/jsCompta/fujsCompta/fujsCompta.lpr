program fujsCompta;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, utcAnnee, upoolAnnee, utcFacture, ublFacture,
  utcMois, upoolMois, utcPiece, utcClient, upoolClient,
  uhfFacture_Ligne, upoolFacture_Ligne, ublFacture_Ligne,
  udkFacture_Ligne_display, udkFacture_Ligne_edit, ufFacture_Ligne_dsb,
  utcFacture_Ligne, GuiTestRunner;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

