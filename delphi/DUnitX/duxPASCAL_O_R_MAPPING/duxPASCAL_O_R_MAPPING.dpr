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
  uVide in '..\..\pascal_o_r_mapping\3_Data\uVide.pas',
  uBatpro_OD_Printer in '..\..\pascal_o_r_mapping\3_Data\uBatpro_OD_Printer.pas',
  uOD_Niveau in '..\..\pascal_o_r_mapping\3_Data\uOD_Niveau.pas',
  uOD_Batpro_Table in '..\..\pascal_o_r_mapping\3_Data\uOD_Batpro_Table.pas',
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
  uRequete in '..\..\pascal_o_r_mapping\3_Data\uRequete.pas',
  uSuppression in '..\..\pascal_o_r_mapping\3_Data\uSuppression.pas',
  uSVG in '..\..\pascal_o_r_mapping\3_Data\uSVG.pas',
  uTraits in '..\..\pascal_o_r_mapping\3_Data\uTraits.pas',
  uTri in '..\..\pascal_o_r_mapping\3_Data\uTri.pas',
  uXML in '..\..\pascal_o_r_mapping\3_Data\uXML.pas',
  u_db_Formes in '..\..\pascal_o_r_mapping\3_Data\u_db_Formes.pas',
  u_InformixLob in '..\..\pascal_o_r_mapping\3_Data\u_InformixLob.pas',
  u_ini_Formes in '..\..\pascal_o_r_mapping\3_Data\u_ini_Formes.pas',
  u_loc_Formes in '..\..\pascal_o_r_mapping\3_Data\u_loc_Formes.pas',
  u_sys_Batpro_Element in '..\..\pascal_o_r_mapping\3_Data\u_sys_Batpro_Element.pas',
  uBatpro_Element in '..\..\pascal_o_r_mapping\3_Data\uBatpro_Element.pas',
  uBatpro_Ligne in '..\..\pascal_o_r_mapping\3_Data\uBatpro_Ligne.pas',
  uBatpro_OD_SpreadSheet_Manager in '..\..\pascal_o_r_mapping\3_Data\uBatpro_OD_SpreadSheet_Manager.pas',
  uBatpro_OD_TextFieldsCreator in '..\..\pascal_o_r_mapping\3_Data\uBatpro_OD_TextFieldsCreator.pas',
  uBatpro_OD_TextTableManager in '..\..\pascal_o_r_mapping\3_Data\uBatpro_OD_TextTableManager.pas',
  uBatproFiltre in '..\..\pascal_o_r_mapping\3_Data\uBatproFiltre.pas',
  ubeChamp in '..\..\pascal_o_r_mapping\3_Data\ubeChamp.pas',
  ubeClusterElement in '..\..\pascal_o_r_mapping\3_Data\ubeClusterElement.pas',
  ubeCoche in '..\..\pascal_o_r_mapping\3_Data\ubeCoche.pas',
  ubeCurseur in '..\..\pascal_o_r_mapping\3_Data\ubeCurseur.pas',
  ubeExtended in '..\..\pascal_o_r_mapping\3_Data\ubeExtended.pas',
  ubeJalon in '..\..\pascal_o_r_mapping\3_Data\ubeJalon.pas',
  ubeListe_Batpro_Elements in '..\..\pascal_o_r_mapping\3_Data\ubeListe_Batpro_Elements.pas',
  uberef in '..\..\pascal_o_r_mapping\3_Data\uberef.pas',
  ubeSerie in '..\..\pascal_o_r_mapping\3_Data\ubeSerie.pas',
  ubeString in '..\..\pascal_o_r_mapping\3_Data\ubeString.pas',
  ubeTraits in '..\..\pascal_o_r_mapping\3_Data\ubeTraits.pas',
  ublG_BECP in '..\..\pascal_o_r_mapping\3_Data\ublG_BECP.pas',
  ublG_BECPCTX in '..\..\pascal_o_r_mapping\3_Data\ublG_BECPCTX.pas',
  ublG_CTX in '..\..\pascal_o_r_mapping\3_Data\ublG_CTX.pas',
  ublG_CTXTYPE in '..\..\pascal_o_r_mapping\3_Data\ublG_CTXTYPE.pas',
  uCD_from_Params in '..\..\pascal_o_r_mapping\3_Data\uCD_from_Params.pas',
  uCD_from_SL in '..\..\pascal_o_r_mapping\3_Data\uCD_from_SL.pas',
  uChamps_persistance in '..\..\pascal_o_r_mapping\3_Data\uChamps_persistance.pas',
  uCharge_100 in '..\..\pascal_o_r_mapping\3_Data\uCharge_100.pas',
  uCharMap in '..\..\pascal_o_r_mapping\3_Data\uCharMap.pas',
  uContextes in '..\..\pascal_o_r_mapping\3_Data\uContextes.pas',
  uDataUtils in '..\..\pascal_o_r_mapping\3_Data\uDataUtils.pas',
  uDataUtilsF in '..\..\pascal_o_r_mapping\3_Data\uDataUtilsF.pas',
  udmBatpro_DataModule in '..\..\pascal_o_r_mapping\3_Data\udmBatpro_DataModule.pas',
  udmDatabase in '..\..\pascal_o_r_mapping\3_Data\udmDatabase.pas',
  uDrawInfo in '..\..\pascal_o_r_mapping\3_Data\uDrawInfo.pas',
  uGlobal_INI in '..\..\pascal_o_r_mapping\3_Data\uGlobal_INI.pas',
  uhAggregation in '..\..\pascal_o_r_mapping\3_Data\uhAggregation.pas',
  uhfG_BECP in '..\..\pascal_o_r_mapping\3_Data\uhfG_BECP.pas',
  uhfG_BECPCTX in '..\..\pascal_o_r_mapping\3_Data\uhfG_BECPCTX.pas',
  uhfG_CTX in '..\..\pascal_o_r_mapping\3_Data\uhfG_CTX.pas',
  uhfG_CTXTYPE in '..\..\pascal_o_r_mapping\3_Data\uhfG_CTXTYPE.pas',
  uhField in '..\..\pascal_o_r_mapping\3_Data\uhField.pas',
  uhFiltre in '..\..\pascal_o_r_mapping\3_Data\uhFiltre.pas',
  uhRequete in '..\..\pascal_o_r_mapping\3_Data\uhRequete.pas',
  uhrG_BECP in '..\..\pascal_o_r_mapping\3_Data\uhrG_BECP.pas',
  uhrG_BECPCTX in '..\..\pascal_o_r_mapping\3_Data\uhrG_BECPCTX.pas',
  uhrG_CTX in '..\..\pascal_o_r_mapping\3_Data\uhrG_CTX.pas',
  uhTriColonne in '..\..\pascal_o_r_mapping\3_Data\uhTriColonne.pas',
  uInformix in '..\..\pascal_o_r_mapping\3_Data\uInformix.pas',
  uINI_Batpro_OD_Report in '..\..\pascal_o_r_mapping\3_Data\uINI_Batpro_OD_Report.pas',
  uMailTo in '..\..\pascal_o_r_mapping\3_Data\uMailTo.pas',
  uMotsCles in '..\..\pascal_o_r_mapping\3_Data\uMotsCles.pas',
  uMySQL in '..\..\pascal_o_r_mapping\3_Data\uMySQL.pas',
  uOD_BatproTextTableContext in '..\..\pascal_o_r_mapping\3_Data\uOD_BatproTextTableContext.pas',
  uOD_Champ in '..\..\pascal_o_r_mapping\3_Data\uOD_Champ.pas',
  uOOo_NomChamp_utilisateur in '..\..\pascal_o_r_mapping\3_Data\uOOo_NomChamp_utilisateur.pas',
  uParametres_Ancetre in '..\..\pascal_o_r_mapping\3_Data\uParametres_Ancetre.pas',
  uPool in '..\..\pascal_o_r_mapping\3_Data\uPool.pas',
  upool_Ancetre_Ancetre in '..\..\pascal_o_r_mapping\3_Data\upool_Ancetre_Ancetre.pas',
  upoolG_BECP in '..\..\pascal_o_r_mapping\3_Data\upoolG_BECP.pas',
  upoolG_BECPCTX in '..\..\pascal_o_r_mapping\3_Data\upoolG_BECPCTX.pas',
  upoolG_CTX in '..\..\pascal_o_r_mapping\3_Data\upoolG_CTX.pas',
  upoolG_CTXTYPE in '..\..\pascal_o_r_mapping\3_Data\upoolG_CTXTYPE.pas',
  uPostgres in '..\..\pascal_o_r_mapping\3_Data\uPostgres.pas',
  uRegistry in '..\..\pascal_o_r_mapping\3_Data\uRegistry.pas',
  uWinUtils in '..\..\pascal_o_r_mapping\5_Controls\uWinUtils.pas',
  uWindows in '..\..\pascal_o_r_mapping\1_LCL\mswindows\uWindows.pas',
  ufBitmaps in '..\..\pascal_o_r_mapping\6_Formes\ufBitmaps.pas',
  uImpression_Font_Size_Multiplier in '..\..\pascal_o_r_mapping\6_Formes\uImpression_Font_Size_Multiplier.pas';

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
