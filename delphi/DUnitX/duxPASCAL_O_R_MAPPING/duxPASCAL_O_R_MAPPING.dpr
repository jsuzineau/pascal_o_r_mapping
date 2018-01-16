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
  uEXE_INI in '..\..\pascal_o_r_mapping\2_Units\uEXE_INI.pas',
  uBinary_Tree in '..\..\pascal_o_r_mapping\2_Units\uBinary_Tree.pas',
  ubtInteger in '..\..\pascal_o_r_mapping\2_Units\ubtInteger.pas',
  uBTree in '..\..\pascal_o_r_mapping\2_Units\uBTree.pas',
  ubtString in '..\..\pascal_o_r_mapping\2_Units\ubtString.pas',
  uChamp in '..\..\pascal_o_r_mapping\2_Units\uChamp.pas',
  uChampDefinition in '..\..\pascal_o_r_mapping\2_Units\uChampDefinition.pas',
  uChampDefinitions in '..\..\pascal_o_r_mapping\2_Units\uChampDefinitions.pas',
  uChamps in '..\..\pascal_o_r_mapping\2_Units\uChamps.pas',
  uChrono in '..\..\pascal_o_r_mapping\2_Units\uChrono.pas',
  uClean in '..\..\pascal_o_r_mapping\2_Units\uClean.pas',
  uCode_barre in '..\..\pascal_o_r_mapping\2_Units\uCode_barre.pas',
  uContrainte in '..\..\pascal_o_r_mapping\2_Units\uContrainte.pas',
  uCP1252_from_CP437 in '..\..\pascal_o_r_mapping\2_Units\uCP1252_from_CP437.pas',
  uDataUtilsU in '..\..\pascal_o_r_mapping\2_Units\uDataUtilsU.pas',
  uEtat in '..\..\pascal_o_r_mapping\2_Units\uEtat.pas',
  uEvaluation_Formule in '..\..\pascal_o_r_mapping\2_Units\uEvaluation_Formule.pas',
  ufAccueil_Erreur in '..\..\pascal_o_r_mapping\2_Units\ufAccueil_Erreur.pas',
  uForms in '..\..\pascal_o_r_mapping\2_Units\uForms.pas',
  uhFiltre_Ancetre in '..\..\pascal_o_r_mapping\2_Units\uhFiltre_Ancetre.pas',
  uIntervalle in '..\..\pascal_o_r_mapping\2_Units\uIntervalle.pas',
  uJCL in '..\..\pascal_o_r_mapping\2_Units\uJCL.pas',
  uLog in '..\..\pascal_o_r_mapping\2_Units\uLog.pas',
  uLookupConnection_Ancetre in '..\..\pascal_o_r_mapping\2_Units\uLookupConnection_Ancetre.pas',
  uNetwork in '..\..\pascal_o_r_mapping\2_Units\uNetwork.pas',
  uOD_Column in '..\..\pascal_o_r_mapping\2_Units\uOD_Column.pas',
  uOD_Dataset_Column in '..\..\pascal_o_r_mapping\2_Units\uOD_Dataset_Column.pas',
  uOD_Dataset_Columns in '..\..\pascal_o_r_mapping\2_Units\uOD_Dataset_Columns.pas',
  uOD_Error in '..\..\pascal_o_r_mapping\2_Units\uOD_Error.pas',
  uOD_Forms in '..\..\pascal_o_r_mapping\2_Units\uOD_Forms.pas',
  uOD_JCL in '..\..\pascal_o_r_mapping\2_Units\uOD_JCL.pas',
  uOD_Merge in '..\..\pascal_o_r_mapping\2_Units\uOD_Merge.pas',
  uOD_Patch in '..\..\pascal_o_r_mapping\2_Units\uOD_Patch.pas',
  uOD_Printer in '..\..\pascal_o_r_mapping\2_Units\uOD_Printer.pas',
  uOD_SpreadsheetManager in '..\..\pascal_o_r_mapping\2_Units\uOD_SpreadsheetManager.pas',
  uOD_Styles in '..\..\pascal_o_r_mapping\2_Units\uOD_Styles.pas',
  uOD_SurTitre in '..\..\pascal_o_r_mapping\2_Units\uOD_SurTitre.pas',
  uOD_Temporaire in '..\..\pascal_o_r_mapping\2_Units\uOD_Temporaire.pas',
  uOD_TextFieldsCreator in '..\..\pascal_o_r_mapping\2_Units\uOD_TextFieldsCreator.pas',
  uOD_TextTableContext in '..\..\pascal_o_r_mapping\2_Units\uOD_TextTableContext.pas',
  uOD_TextTableManager in '..\..\pascal_o_r_mapping\2_Units\uOD_TextTableManager.pas',
  uODRE_Table in '..\..\pascal_o_r_mapping\2_Units\uODRE_Table.pas',
  uOOoChrono in '..\..\pascal_o_r_mapping\2_Units\uOOoChrono.pas',
  uOOoDelphiReportEngineLog in '..\..\pascal_o_r_mapping\2_Units\uOOoDelphiReportEngineLog.pas',
  uOOoStringList in '..\..\pascal_o_r_mapping\2_Units\uOOoStringList.pas',
  uOOoStrings in '..\..\pascal_o_r_mapping\2_Units\uOOoStrings.pas',
  uOpenDocument in '..\..\pascal_o_r_mapping\2_Units\uOpenDocument.pas',
  uParametre in '..\..\pascal_o_r_mapping\2_Units\uParametre.pas',
  uParametres_Ligne_de_commande in '..\..\pascal_o_r_mapping\2_Units\uParametres_Ligne_de_commande.pas',
  uProgression in '..\..\pascal_o_r_mapping\2_Units\uProgression.pas',
  uPublieur in '..\..\pascal_o_r_mapping\2_Units\uPublieur.pas',
  uPublieur_sans_btree in '..\..\pascal_o_r_mapping\2_Units\uPublieur_sans_btree.pas',
  uReal_Field_Formatter in '..\..\pascal_o_r_mapping\2_Units\uReal_Field_Formatter.pas',
  uReal_Formatter in '..\..\pascal_o_r_mapping\2_Units\uReal_Formatter.pas',
  uReels in '..\..\pascal_o_r_mapping\2_Units\uReels.pas',
  uSGBD in '..\..\pascal_o_r_mapping\2_Units\uSGBD.pas',
  uskInteger in '..\..\pascal_o_r_mapping\2_Units\uskInteger.pas',
  uSkipList in '..\..\pascal_o_r_mapping\2_Units\uSkipList.pas',
  uskString in '..\..\pascal_o_r_mapping\2_Units\uskString.pas',
  uStringArray in '..\..\pascal_o_r_mapping\2_Units\uStringArray.pas',
  uTemporaire in '..\..\pascal_o_r_mapping\2_Units\uTemporaire.pas',
  uTri_Ancetre in '..\..\pascal_o_r_mapping\2_Units\uTri_Ancetre.pas',
  uUseCase in '..\..\pascal_o_r_mapping\2_Units\uUseCase.pas',
  uUseCases in '..\..\pascal_o_r_mapping\2_Units\uUseCases.pas',
  uuStrings in '..\..\pascal_o_r_mapping\2_Units\uuStrings.pas',
  uVersion in '..\..\pascal_o_r_mapping\2_Units\uVersion.pas',
  u_db_ in '..\..\pascal_o_r_mapping\2_Units\u_db_.pas',
  u_db_Composants in '..\..\pascal_o_r_mapping\2_Units\u_db_Composants.pas',
  u_ini_ in '..\..\pascal_o_r_mapping\2_Units\u_ini_.pas',
  u_loc_ in '..\..\pascal_o_r_mapping\2_Units\u_loc_.pas',
  u_reg_ in '..\..\pascal_o_r_mapping\2_Units\u_reg_.pas',
  u_sys_ in '..\..\pascal_o_r_mapping\2_Units\u_sys_.pas',
  uBatpro_Registry in '..\..\pascal_o_r_mapping\2_Units\uBatpro_Registry.pas',
  uBatpro_StringList in '..\..\pascal_o_r_mapping\2_Units\uBatpro_StringList.pas',
  uWinUtils in '..\..\pascal_o_r_mapping\5_Controls\uWinUtils.pas',
  uWindows in '..\..\pascal_o_r_mapping\1_LCL\mswindows\uWindows.pas',
  ufBitmaps in '..\..\pascal_o_r_mapping\6_Formes\ufBitmaps.pas',
  uImpression_Font_Size_Multiplier in '..\..\pascal_o_r_mapping\6_Formes\uImpression_Font_Size_Multiplier.pas',
  uAide in '..\..\pascal_o_r_mapping\6_Formes\uAide.pas',
  ufHelp_Creator in '..\..\pascal_o_r_mapping\6_Formes\ufHelp_Creator.pas',
  ufpBas in '..\..\pascal_o_r_mapping\6_Formes\ufpBas.pas',
  ufBatpro_Form in '..\..\pascal_o_r_mapping\6_Formes\ufBatpro_Form.pas',
  ufBatpro_Desk in '..\..\pascal_o_r_mapping\6_Formes\ufBatpro_Desk.pas',
  uHorloge in '..\..\pascal_o_r_mapping\6_Formes\uHorloge.pas',
  ucBatproMasque in '..\..\pascal_o_r_mapping\5_Controls\ucBatproMasque.pas',
  ucBatproMaskElement in '..\..\pascal_o_r_mapping\5_Controls\ucBatproMaskElement.pas',
  uEdit_WANTTAB in '..\..\pascal_o_r_mapping\5_Controls\uEdit_WANTTAB.pas',
  ufAccueil in '..\..\pascal_o_r_mapping\6_Formes\ufAccueil.pas',
  ucbvCustomConnection in '..\..\pascal_o_r_mapping\4_Components\ucbvCustomConnection.pas',
  ucBatproVerifieur in '..\..\pascal_o_r_mapping\4_Components\ucBatproVerifieur.pas',
  ufBatpro_Informix in '..\..\pascal_o_r_mapping\6_Formes\ufBatpro_Informix.pas',
  ufBatpro_MySQL in '..\..\pascal_o_r_mapping\6_Formes\ufBatpro_MySQL.pas',
  ufBatpro_Parametres_Client in '..\..\pascal_o_r_mapping\6_Formes\ufBatpro_Parametres_Client.pas',
  udmSMTP in '..\..\pascal_o_r_mapping\6_Formes\udmSMTP.pas',
  ufProgression in '..\..\pascal_o_r_mapping\6_Formes\ufProgression.pas',
  ufReconcileError in '..\..\pascal_o_r_mapping\6_Formes\ufReconcileError.pas',
  udkProgression in '..\..\pascal_o_r_mapping\6_Formes\udkProgression.pas',
  ucDockScrollbox in '..\..\pascal_o_r_mapping\5_Controls\ucDockScrollbox.pas',
  uDockable in '..\..\pascal_o_r_mapping\5_Controls\uDockable.pas',
  ucChamp_Edit in '..\..\pascal_o_r_mapping\5_Controls\ucChamp_Edit.pas',
  ucChamp_Label in '..\..\pascal_o_r_mapping\5_Controls\ucChamp_Label.pas',
  ucChamp_Lookup_ComboBox in '..\..\pascal_o_r_mapping\5_Controls\ucChamp_Lookup_ComboBox.pas',
  ucChamp_CheckBox in '..\..\pascal_o_r_mapping\5_Controls\ucChamp_CheckBox.pas',
  ucChamp_Integer_SpinEdit in '..\..\pascal_o_r_mapping\5_Controls\ucChamp_Integer_SpinEdit.pas',
  ucBatpro_Shape in '..\..\pascal_o_r_mapping\5_Controls\ucBatpro_Shape.pas',
  Unit1 in 'Unit1.pas' {Form1};

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
