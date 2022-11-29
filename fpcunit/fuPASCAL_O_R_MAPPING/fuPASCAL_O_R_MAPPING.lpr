program fuPASCAL_O_R_MAPPING;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, sqlite3laz, utcOpenDocument, ublTest,
  utcOpenDocument_Embed_Image, utcWinUtils, uftcWinUtils, utcDockableScrollbox,
  uftcDockableScrollbox, uhdmTestDockableScrollbox, ublTestDockableScrollbox,
  udkTestDockableScrollbox, uhdmTestWinUtils, ublTestWinUtils,
  utcCode_barre_pdf417, ucDockableScrollbox, uCode_barre_pdf417, utcSQLite,
  udmSQLite, uDataUtilsF, ufSQLite, tcSQLITE_LastInsertId,
  utcOpenDocument_AddHTML, ublTest_HTML, utcExcel_from_ODRE_Table,
  utcOpenDocument_Etiquettes, utcOD_Label_Printer;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

