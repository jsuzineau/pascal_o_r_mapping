program fuPASCAL_O_R_MAPPING;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, utcOpenDocument, ublTest, utcOpenDocument_Embed_Image,
  utcWinUtils, uftcWinUtils, utcDockableScrollbox,
  uhdmTestDockableScrollbox, ublTestDockableScrollbox, udkTestDockableScrollbox,
  uhdmTestWinUtils, ublTestWinUtils, utcCode_barre_pdf417, ucDockableScrollbox,
  uCode_barre_pdf417, utcOpenDocument_AddHTML;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

