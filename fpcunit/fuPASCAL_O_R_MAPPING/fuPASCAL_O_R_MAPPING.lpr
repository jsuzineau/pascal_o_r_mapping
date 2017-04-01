program fuPASCAL_O_R_MAPPING;

{$mode objfpc}{$H+}

uses
  Interfaces, Forms, GuiTestRunner, utcOpenDocument, ublTest, 
utcOpenDocument_Embed_Image;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TGuiTestRunner, TestRunner);
  Application.Run;
end.

