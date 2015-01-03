{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Units_windows;

interface

uses
 DBTables, DBXpress, JCLDebug, jpeg, Mask, Provider, SimpleDS, tabs, 
 uBatpro_Registry, uBatpro_StringList, uBinary_Tree, ubtInteger, uBTree, 
 ubtString, uChampDefinition, uChampDefinitions, uChamp, uChamps, uChrono, 
 uClean, uCode_barre, uContrainte, uCP1252_from_CP437, uDataUtilsU, 
 u_db_Composants, u_db_, uEtat, uEvaluation_Formule, uEXE_INI, 
 ufAccueil_Erreur, uForms, u_ini_, uIntervalle, uJCL, u_loc_, 
 uLookupConnection_Ancetre, uOD_Column, uOD_Dataset_Column, 
 uOD_Dataset_Columns, uOD_Error, uOD_Forms, uOD_JCL, uOD_Merge, uOD_Printer, 
 uODRE_Table, uOD_SpreadsheetManager, uOD_Styles, uOD_SurTitre, 
 uOD_Temporaire, uOD_TextFieldsCreator, uOD_TextTableContext, 
 uOD_TextTableManager, uOOoChrono, uOOoDelphiReportEngineLog, uOOoStringList, 
 uOOoStrings, uOpenDocument, uParametre, uParametres_Ligne_de_commande, 
 uPatchLanceur, uProgression, uPublieur, uPublieur_sans_btree, 
 uReal_Field_Formatter, uReal_Formatter, uReels, u_reg_, uSGBD, uskInteger, 
 uSkipList, uskString, uStringArray, u_sys_, uTemporaire, uTri_Ancetre, 
 uUseCase, uUseCases, uuStrings, uVersion, uWinUtils, uLog, uNetwork, 
 LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Units_windows', @Register);
end.
