{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Formes;

interface

uses
 uAide, uAtom, uDataClasses, ufAccueil, ufBatpro_Desk, ufBatpro_Form, 
 ufBatpro_Informix, ufBatpro_MySQL, ufBatpro_Parametres_Client, ufBitmaps, 
 ufHelp_Creator, ufMailTo, ufOOoModelSelect, ufOOo_NomFichier_Modele, 
 ufOpenDocument_DelphiReportEngine, ufpBas, ufReconcileError, uhRequete, 
 uhTriColonne, uImpression_Font_Size_Multiplier, udmxCreator, 
 ufBatpro_Form_Ancetre, udmx, uhDessinnateur, ubeChamp, ubeCoche, ubeCurseur, 
 ubeExtended, ubeJalon, ubeListe_Batpro_Elements, uberef, ubeSerie, ubeString, 
 ubeTraits, ufBloqueur, uhrG_BECPCTX, udmxLAST_INSERT_ID_MySQL, ufSchemateur, 
 uHorloge, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Formes', @Register);
end.
