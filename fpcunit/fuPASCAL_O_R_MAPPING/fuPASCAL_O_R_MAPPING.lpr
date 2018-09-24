program fuPASCAL_O_R_MAPPING;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, utcOpenDocument, ublTest,
  utcOpenDocument_Embed_Image, utcWinUtils, uftcWinUtils, utcDockableScrollbox,
  uhdmTestDockableScrollbox, ublTestDockableScrollbox, udkTestDockableScrollbox,
  uhdmTestWinUtils, ublTestWinUtils, utcCode_barre_pdf417, ucDockableScrollbox,
  blcksock, uCode_barre_pdf417, uOD, utcOpenDocument_AddHTML, utcStrings, utcOD,
  utcDataUtilsU;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

