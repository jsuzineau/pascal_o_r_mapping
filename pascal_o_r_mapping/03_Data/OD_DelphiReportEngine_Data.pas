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
 uGlobal_INI, uhfG_BECP, uhfG_BECPCTX, uhfG_CTX, uhfG_CTXTYPE, uhField, 
 uhFiltre, uInformix, u_InformixLob, uINI_Batpro_OD_Report, u_ini_Formes, 
 u_loc_Formes, uMailTo, uMotsCles, uMySQL, uOD_Batpro_Table, 
 uOD_BatproTextTableContext, uOD_Champ, uOD_Niveau, uOOo_NomChamp_utilisateur, 
 uParametres_Ancetre, uPool, upool_Ancetre_Ancetre, upoolG_BECP, 
 upoolG_BECPCTX, upoolG_CTX, upoolG_CTXTYPE, uPostgres, uRequete, 
 uSuppression, uSVG, u_sys_Batpro_Element, uTri, uXML, uTraits, u_db_Formes, 
 ubeChamp, ubeClusterElement, ubeJalon, uberef, ubeSerie, uhTriColonne, 
 uHTTP_Interface, ubeCurseur, ubeExtended, ubeCoche, ubeListe_Batpro_Elements, 
 ubeString, ubeTraits, uOD_Table_Batpro, uTradingView, upoolJSON, 
 ublAutomatic, upoolAutomatic, uGenerateur_de_code_Ancetre, 
 uApplicationJoinPointFile, uContexteClasse, uContexteMembre, 
 uf_f_dbgKeyPress_Key_Pattern, upoolPostgres_Foreign_Key, 
 ublPostgres_Foreign_Key, uhfPostgres_Foreign_Key, uTemplateHandler, 
 uJoinPoint, ujpFile, ujpNom_de_la_table, ujpNomTableMinuscule, 
 ujpNom_de_la_classe, ujpSQL_CREATE_TABLE, ujpSQL_Order_By_Key, 
 ujpPascal_f_implementation_uses_key, ujpPascal_Get_by_Cle_Declaration, 
 ujpPascal_Get_by_Cle_Implementation, ujpPascal_LabelsDFM, 
 ujpPascal_LabelsPAS, ujpPascal_Ouverture_key, ujpPascal_QCalcFieldsKey, 
 ujpPascal_QfieldsDFM, ujpPascal_QfieldsPAS, ujpPascal_sCle_from__Declaration, 
 ujpPascal_sCle_from__Implementation, ujpPascal_sCle_Implementation_Body, 
 ujpPascal_SQLWHERE_ContraintesChamps_Body, ujpPascal_Test_Call_Key, 
 ujpPascal_Test_Declaration_Key, ujpPascal_Test_Implementation_Key, 
 ujpPascal_To_SQLQuery_Params_Body, ujpPascal_Traite_Index_key, 
 ujpPascal_uses_ubl, ujpPascal_uses_upool, ujpPascal_Affecte, 
 ujpPascal_aggregation_accesseurs_implementation, 
 ujpPascal_aggregation_declaration, ujpPascal_Assure_Declaration, 
 ujpPascal_Assure_Implementation, ujpPascal_Champ_EditDFM, 
 ujpPascal_Champ_EditPAS, ujpPascal_creation_champs, 
 ujpPascal_declaration_champs, ujpPascal_Declaration_cle, 
 ujpPascal_Detail_declaration, ujpPascal_Detail_pool_get, 
 ujpPascal_f_Execute_After_Key, ujpPascal_f_Execute_Before_Key, 
 ujpCSharp_Conteneurs, ujpCSharp_Contenus, ujpCSharp_DocksDetails, 
 ujpCSharp_DocksDetails_Affiche, ujpCSharp_Champs_persistants, 
 ujpCSharp_Chargement_Conteneurs, ujpPHP_Doctrine_HasMany, 
 ujpPHP_Doctrine_HasOne, ujpPHP_Doctrine_Has_Column, 
 ujpAngular_TypeScript_html_editeurs_champs, 
 ujpAngular_TypeScript_NomClasseElement, 
 ujpAngular_TypeScript_NomFichierElement, 
 ujpAngular_TypeScript_declaration_champs, uOD_Label_Printer, 
 uAPI_Client_pool, uTypeMapping, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Data', @Register);
end.
