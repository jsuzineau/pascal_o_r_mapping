{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Data;

{$warn 5023 off : no warning about unused units}
interface

uses
 uBatpro_Element, uBatproFiltre, uBatpro_Ligne, uBatpro_OD_Printer, 
 uBatpro_OD_SpreadSheet_Manager, uBatpro_OD_TextFieldsCreator, 
 uBatpro_OD_TextTableManager, ublG_BECP, ublG_BECPCTX, ublG_CTX, ublG_CTXTYPE, 
 uCD_from_Params, uCD_from_SL, uChamps_persistance, uCharge_100, uCharMap, 
 uContextes, uDataUtils, udmBatpro_DataModule, udmDatabase, uDrawInfo, 
 uGlobal_INI, uhAggregation, uhfG_BECP, uhfG_BECPCTX, uhfG_CTX, uhfG_CTXTYPE, 
 uhField, uhFiltre, uInformix, u_InformixLob, uINI_Batpro_OD_Report, 
 u_ini_Formes, u_loc_Formes, uMailTo, uMotsCles, uMySQL, uOD_Batpro_Table, 
 uOD_BatproTextTableContext, uOD_Champ, uOD_Niveau, uOOo_NomChamp_utilisateur, 
 uParametres_Ancetre, uPool, upool_Ancetre_Ancetre, upoolG_BECP, 
 upoolG_BECPCTX, upoolG_CTX, upoolG_CTXTYPE, uPostgres, uRequete, 
 uSuppression, uSVG, u_sys_Batpro_Element, uTri, uXML, uTraits, u_db_Formes, 
 ubeChamp, ubeClusterElement, ubeJalon, uberef, ubeSerie, uhRequete, 
 uhrG_BECP, uhrG_BECPCTX, uhrG_CTX, uhTriColonne, ssl_streamsec, blcksock, 
 mimeinln, ssl_cryptlib, pingsend, mimepart, ftpsend, clamsend, imapsend, 
 laz_synapse, slogsend, synafpc, nntpsend, synachar, synautil, ssl_sbb, 
 dnssend, ssl_openssl_lib, mimemess, snmpsend, ldapsend, ssl_openssl, synsock, 
 tlntsend, sntpsend, synamisc, httpsend, synadbg, synaip, synacrypt, synaser, 
 synaicnv, pop3send, ftptsend, smtpsend, synacode, asn1util, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Data', @Register);
end.
