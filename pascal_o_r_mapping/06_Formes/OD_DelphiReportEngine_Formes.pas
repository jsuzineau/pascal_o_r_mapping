{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Formes;

{$warn 5023 off : no warning about unused units}
interface

uses
 uAide, uAtom, uDataClasses, ufAccueil, ufBatpro_Desk, ufBatpro_Form, 
 ufBatpro_Informix, ufBatpro_MySQL, ufBatpro_Parametres_Client, ufBitmaps, 
 ufHelp_Creator, ufMailTo, ufOOoModelSelect, ufOOo_NomFichier_Modele, 
 ufOpenDocument_DelphiReportEngine, ufpBas, ufReconcileError, 
 uImpression_Font_Size_Multiplier, udmxCreator, ufBatpro_Form_Ancetre, 
 uhDessinnateur, ufBloqueur, uHorloge, ufBase_dsb, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Formes', @Register);
end.
