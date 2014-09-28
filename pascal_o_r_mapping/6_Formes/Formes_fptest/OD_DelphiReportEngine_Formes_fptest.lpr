program OD_DelphiReportEngine_Formes_fptest;

{$mode objfpc}{$H+}

uses
    interfaces,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  GUITestRunner,
  formimages,
    uftBatpro_Element,
    utcBatpro_Element,
    utcLAST_INSERT_ID_MySQL,
    utc_MailTo;


begin
     RunRegisteredTests;
end.

