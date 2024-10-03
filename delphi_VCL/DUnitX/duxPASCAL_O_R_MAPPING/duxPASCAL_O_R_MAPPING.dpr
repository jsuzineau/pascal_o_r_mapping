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
  uftcDockableScrollbox in 'TestCase\tcDockableScrollbox\uftcDockableScrollbox.pas',
  utcDockableScrollbox in 'TestCase\tcDockableScrollbox\utcDockableScrollbox.pas',
  ublTestDockableScrollbox in 'TestCase\tcDockableScrollbox\Elements\TestDockableScrollbox\ublTestDockableScrollbox.pas',
  udkTestDockableScrollbox in 'TestCase\tcDockableScrollbox\Elements\TestDockableScrollbox\udkTestDockableScrollbox.pas',
  uhdmTestDockableScrollbox in 'TestCase\tcDockableScrollbox\Elements\TestDockableScrollbox\uhdmTestDockableScrollbox.pas';

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
