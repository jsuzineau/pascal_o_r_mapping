{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Data;

interface

uses
 uBatpro_Element, uBatproFiltre, uBatpro_Ligne, uBatpro_OD_Printer, 
 uBatpro_OD_SpreadSheet_Manager, uBatpro_OD_TextFieldsCreator, 
 uBatpro_OD_TextTableManager, ublG_BECP, ublG_BECPCTX, ublG_CTX, ublG_CTXTYPE, 
 uCD_from_Params, uCD_from_SL, uChamps_persistance, uCharge_100, uCharMap, 
 uContextes, uDataUtils, uDataUtilsF, udmBatpro_DataModule, udmDatabase, 
 uDrawInfo, uGlobal_INI, uhAggregation, uhfG_BECP, uhfG_BECPCTX, uhfG_CTX, 
 uhfG_CTXTYPE, uhField, uhFiltre, uhFiltre_Ancetre, uInformix, u_InformixLob, 
 uINI_Batpro_OD_Report, u_ini_Formes, u_loc_Formes, uLog, uMailTo, uMotsCles, 
 uMySQL, uNetwork, uOD_Batpro_Table, uOD_BatproTextTableContext, uOD_Champ, 
 uOD_Niveau, uOOo_NomChamp_utilisateur, uParametres_Ancetre, uPool, 
 upool_Ancetre_Ancetre, upoolG_BECP, upoolG_BECPCTX, upoolG_CTX, 
 upoolG_CTXTYPE, uPostgres, uRegistry, uRequete, uSuppression, uSVG, 
 u_sys_Batpro_Element, uTri, uVide, uXML, uTraits, u_db_Formes, ubeChamp, 
 ubeClusterElement, ubeJalon, uberef, ubeSerie, uhRequete, uhrG_BECP, 
 uhrG_BECPCTX, uhrG_CTX, uhTriColonne, blcksock, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Data', @Register);
end.
