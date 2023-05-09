program duxPASCAL_O_R_MAPPING;

{$IFNDEF TESTINSIGHT}
{$APPTYPE CONSOLE}
{$ENDIF}{$STRONGLINKTYPES ON}
















uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ENDIF }
  DUnitX.Loggers.Console,
  DUnitX.Loggers.Xml.NUnit,
  DUnitX.TestFramework,
  utcOpenDocument_Embed_Image in 'TestCase\tcOpenDocument_Embed_Image\utcOpenDocument_Embed_Image.pas',
  ublTest in 'TestCase\tcOpenDocument_Embed_Image\Elements\Test\ublTest.pas',
  ufBitmaps in '..\..\pascal_o_r_mapping\06_Formes\ufBitmaps.pas',
  uImpression_Font_Size_Multiplier in '..\..\pascal_o_r_mapping\06_Formes\uImpression_Font_Size_Multiplier.pas',
  uAide in '..\..\pascal_o_r_mapping\06_Formes\uAide.pas',
  ufHelp_Creator in '..\..\pascal_o_r_mapping\06_Formes\ufHelp_Creator.pas',
  ufpBas in '..\..\pascal_o_r_mapping\06_Formes\ufpBas.pas',
  ufBatpro_Form in '..\..\pascal_o_r_mapping\06_Formes\ufBatpro_Form.pas',
  ufBatpro_Desk in '..\..\pascal_o_r_mapping\06_Formes\ufBatpro_Desk.pas',
  uHorloge in '..\..\pascal_o_r_mapping\06_Formes\uHorloge.pas',
  ufAccueil in '..\..\pascal_o_r_mapping\06_Formes\ufAccueil.pas',
  ufBatpro_Informix in '..\..\pascal_o_r_mapping\06_Formes\ufBatpro_Informix.pas',
  ufBatpro_MySQL in '..\..\pascal_o_r_mapping\06_Formes\ufBatpro_MySQL.pas',
  ufBatpro_Parametres_Client in '..\..\pascal_o_r_mapping\06_Formes\ufBatpro_Parametres_Client.pas',
  udmSMTP in '..\..\pascal_o_r_mapping\06_Formes\udmSMTP.pas',
  ufProgression in '..\..\pascal_o_r_mapping\06_Formes\ufProgression.pas',
  ufReconcileError in '..\..\pascal_o_r_mapping\06_Formes\ufReconcileError.pas',
  udkProgression in '..\..\pascal_o_r_mapping\06_Formes\udkProgression.pas',
  uLog in '..\..\pascal_o_r_mapping\06_Formes\uLog.pas',
  uDockable in '..\..\pascal_o_r_mapping\05_Controls\uDockable.pas';

var
  runner : ITestRunner;
  results : IRunResults;
  logger : ITestLogger;
  nunitLogger : ITestLogger;
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
  exit;
{$ENDIF}
  try
    //Check command line options, will exit if invalid
    TDUnitX.CheckCommandLine;
    //Create the test runner
    runner := TDUnitX.CreateRunner;
    //Tell the runner to use RTTI to find Fixtures
    runner.UseRTTI := True;
    //tell the runner how we will log things
    //Log to the console window
    logger := TDUnitXConsoleLogger.Create(true);
    runner.AddLogger(logger);
    //Generate an NUnit compatible XML File
    nunitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    runner.AddLogger(nunitLogger);
    runner.FailsOnNoAsserts := False; //When true, Assertions must be made during tests;

    //Run tests
    results := runner.Execute;
    if not results.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    //We don't want this happening when running under CI.
    if TDUnitX.Options.ExitBehavior = TDUnitXExitBehavior.Pause then
    begin
      System.Write('Done.. press <Enter> key to quit.');
      System.Readln;
    end;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
end.
