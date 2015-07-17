program jsWorks_mswindows;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{$mode objfpc}{$H+}

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms, uXML, ublG_BECP, ublG_BECPCTX, ublG_CTX, ublG_CTXTYPE, uhfG_BECP,
 uhfG_BECPCTX, uhfG_CTX, uhfG_CTXTYPE, upoolG_BECP, upoolG_BECPCTX, upoolG_CTX,
 upoolG_CTXTYPE, ublAutomatic, uPatternHandler, uJoinPoint,
 uGenerateur_de_code_Ancetre, ujpCSharp_Conteneurs, ujpCSharp_Contenus,
 ujpCSharp_DocksDetails, ujpCSharp_DocksDetails_Affiche,
 ujpCSharp_Champs_persistants, ujpCSharp_Chargement_Conteneurs,
 ujpPHP_Doctrine_Has_Column, ujpPHP_Doctrine_HasOne, ujpPHP_Doctrine_HasMany,
 ujpNom_de_la_classe, ujpNom_de_la_table, ujpNomTableMinuscule,
 ujpSQL_CREATE_TABLE, ujpSQL_Order_By_Key, ujpPascal_Declaration_cle,
 ujpPascal_Affecte, ujpPascal_Champ_EditDFM, ujpPascal_uses_ubl,
 ujpPascal_uses_upool, ujpPascal_f_implementation_uses_key,
 ujpPascal_sCle_from__Declaration, ujpPascal_sCle_from__Implementation,
 ujpPascal_sCle_Implementation_Body, ujpPascal_declaration_champs,
 ujpPascal_f_Execute_After_Key, ujpPascal_f_Execute_Before_Key,
 ujpPascal_Detail_declaration,
 ujpPascal_creation_champs,
 ujpPascal_Test_Declaration_Key, ujpPascal_Test_Implementation_Key,
 ujpPascal_To_SQLQuery_Params_Body, ujpPascal_Traite_Index_key,
 ujpPascal_QCalcFieldsKey, ujpPascal_QfieldsDFM, ujpPascal_QfieldsPAS,
 ujpPascal_SQLWHERE_ContraintesChamps_Body, ujpPascal_Test_Call_Key,
 ujpPascal_Get_by_Cle_Declaration, ujpPascal_Get_by_Cle_Implementation,
 ujpPascal_LabelsDFM, ujpPascal_LabelsPAS, ujpPascal_Ouverture_key,
 ujpPascal_Champ_EditPAS, uBatpro_Registry, uBatpro_StringList, uBinary_Tree,
 ubtInteger, uBTree, ubtString, uChamp, uChampDefinition, uChampDefinitions,
 uChamps, uChrono, uClean, uCode_barre, uContrainte, uCP1252_from_CP437,
 uDataUtilsU, u_db_, u_db_Composants, uEtat, uEvaluation_Formule, uEXE_INI,
 ufAccueil_Erreur, uForms, u_ini_, uIntervalle, uJCL, u_loc_,
 uLookupConnection_Ancetre, uOD_Column, uOD_Dataset_Column, uOD_Dataset_Columns,
 uOD_Error, uOD_Forms, uOD_JCL, uOD_Merge, uOD_Printer, uODRE_Table,
 uOD_SpreadsheetManager, uOD_Styles, uOD_SurTitre, uOD_Temporaire,
 uOD_TextFieldsCreator, uOD_TextTableContext, uOD_TextTableManager, uOOoChrono,
 uOOoDelphiReportEngineLog, uOOoStringList, uOOoStrings, uOpenDocument,
 uDockable, ucDockableScrollbox, uDessin, ufBase, ufBatpro_Form_Ancetre,
 ufBatpro_Form, blcksock, ufjsWorks, ublCategorie, ublDevelopment, ublProject,
 ublState, ublWork, uhfCategorie, uhfDevelopment, uhfJour_ferie, uhfProject,
 uhfState, uhfWork, upoolCategorie, upoolDevelopment, upoolJour_ferie,
 upoolProject, upoolState, upoolWork, ublJour_ferie, udkProject_EDIT,
 udkProject_LABEL, ufProject, udkWork, udkDevelopment, ublSession,
 uOD_Table_Batpro, ufAutomatic, uhdmSession, ublTAG, uhfTAG, upoolTAG,
 upoolTAG_DEVELOPMENT, uhfTAG_DEVELOPMENT, ublTAG_DEVELOPMENT, upoolTAG_WORK,
 uhfTAG_WORK, ublTAG_WORK, udkType_Tag_edit, ublType_Tag, upoolType_Tag,
 uhfType_Tag, ufType_Tag;

{$R *.res}

begin
 RequireDerivedFormResource := True;
 Application.Initialize;
 Application.CreateForm(TfjsWorks, fjsWorks);
 Application.CreateForm(TfProject, fProject);
 Application.CreateForm(TfTYPE_TAG, fTYPE_TAG);
 Application.Run;
end.

