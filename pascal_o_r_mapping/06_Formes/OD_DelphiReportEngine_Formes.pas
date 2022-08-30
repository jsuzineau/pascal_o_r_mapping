{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Formes;

{$warn 5023 off : no warning about unused units}
interface

uses
 uAide, uAtom, uDataClasses, ufAccueil, ufBatpro_Desk, ufBatpro_Form, 
 ufBatpro_Informix, ufBatpro_MySQL, ufBatpro_Parametres_Client, ufBitmaps, 
 ufHelp_Creator, ufMailTo, ufOOoModelSelect, ufOOo_NomFichier_Modele, ufpBas, 
 ufReconcileError, uImpression_Font_Size_Multiplier, udmxCreator, 
 ufBatpro_Form_Ancetre, uhDessinnateur, ufBloqueur, uHorloge, ufBase_dsb, 
 ufOpenDocument_DelphiReportEngine, ublOD_Dataset_Column, 
 ublOD_Dataset_Columns, uhVST_ODR, ublOD_Affectation, ublOD_Column, 
 udkODRE_Table, uhdODRE_Table, ublODRE_Table, 
 uhdmOpenDocument_DelphiReportEngine_Test, 
 uodOpenDocument_DelphiReportEngine_Test, 
 ublOpenDocument_DelphiReportEngine_Test, ufFields_vstInsertion, 
 ufFields_vstTables, ufStringList, ufTextFile, ufXML_Editor, ufFields_vle, 
 ufFields_vst, uhVST, ufjpFile, ufjpFiles, ufAutomatic_VST, ufAutomatic, 
 ufAutomatic_Genere_tout_sl, ufODBC, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Formes', @Register);
end.
