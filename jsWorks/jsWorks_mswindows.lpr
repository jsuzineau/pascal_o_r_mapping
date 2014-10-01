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
 upoolG_CTXTYPE, uBatpro_Registry, uBatpro_StringList, uBinary_Tree, ubtInteger,
 uBTree, ubtString, uChamp, uChampDefinition, uChampDefinitions, uChamps,
 uChrono, uClean, uCode_barre, uContrainte, uCP1252_from_CP437, uDataUtilsU,
 u_db_, u_db_Composants, uEtat, uEvaluation_Formule, uEXE_INI, ufAccueil_Erreur,
 uForms, u_ini_, uIntervalle, uJCL, u_loc_, uLookupConnection_Ancetre,
 uOD_Column, uOD_Dataset_Column, uOD_Dataset_Columns, uOD_Error, uOD_Forms,
 uOD_JCL, uOD_Merge, uOD_Printer, uODRE_Table, uOD_SpreadsheetManager,
 uOD_Styles, uOD_SurTitre, uOD_Temporaire, uOD_TextFieldsCreator,
 uOD_TextTableContext, uOD_TextTableManager, uOOoChrono,
 uOOoDelphiReportEngineLog, uOOoStringList, uOOoStrings, uOpenDocument,
 uDockable, ucDockableScrollbox, uDessin, blcksock, ufjsWorks,
 ublCategorie, ublDevelopment, ublProject, ublState, ublWork, uhfCategorie,
 uhfDevelopment, uhfJour_ferie, uhfProject, uhfState, uhfWork, upoolCategorie,
 upoolDevelopment, upoolJour_ferie, upoolProject, upoolState, upoolWork,
 ublJour_ferie, udkProject_EDIT, udkProject_LABEL, ufProject, udkWork,
 udkDevelopment, uOD_Table_Batpro
 { you can add units after this };

{$R *.res}

begin
 RequireDerivedFormResource := True;
 Application.Initialize;
 Application.CreateForm(TfjsWorks, fjsWorks);
 Application.CreateForm(TfProject, fProject);
 Application.Run;
end.

