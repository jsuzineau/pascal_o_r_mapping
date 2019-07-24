program OD_DelphiReportEngine_Components_fptest;

{$mode delphi}{$H+}

uses
  interfaces,
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes,
  utcOD_Printer,
  utcOD_SpreadsheetManager,
  utcOpenDocument,
  utc_Batpro_Button,
  utc_Batpro_RadioGroup,
  utcBatpro_StringList,
  utc_Binary_Tree,
  utc_btInteger,
  utc_btString,
  utcCP1252_from_CP437,

  utcDataUtilsU,
  utcEvaluation_Formule,
  utcIntervalle,
  utc_Publieur,
  utcReal_Formatter,
  utc_uDataUtilsU,
  utc_uStrings,
  utcOD_TestCase,

  GUITestRunner,formimages;


begin
  RunRegisteredTests;
end.

