program jsWorks;
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
 {$IFDEF UNIX}
 cthreads,
 {$ENDIF}
 Interfaces, // this includes the LCL widgetset
 Forms,
 datetimectrls,
 {$IFDEF MSWINDOWS}
 windows,
 {$ENDIF}
 ufjsWorks, ublCategorie, ublDevelopment, ublProject, ublState, ublWork,
 uhfCategorie, uhfDevelopment, uhfJour_ferie, uhfProject, uhfState, uodTag,
 ufTemps, ujsWorks_API_Client, udkSession, uhfWork, upoolCategorie,
 upoolDevelopment, upoolJour_ferie, upoolProject, upoolState, upoolWork,
 ublJour_ferie, udkProject_EDIT, udkProject_LABEL, ufProject, udkWork,
 udkDevelopment, ublSession, uhdmSession, uodSession, ublTag, uhfTag, upoolTag,
 upoolTag_Development, uhfTag_Development, ublTag_Development, upoolTag_Work,
 uhfTag_Work, ublTag_Work, udkType_Tag_EDIT, ublType_Tag, upoolType_Tag,
 uhfType_Tag, ufType_Tag, udkTag_LABEL, uodWork_from_Period, udkWork_JSON,
 udkTag_LABEL_od, udkWork_haTag_from_Description_LABEL;

{$R *.res}

begin
 {$IFDEF trucMSWINDOWS} //enlever truc pour afficher la console
 AllocConsole;      // in Windows unit
 IsConsole := True; // in System unit
 SysInitStdIO;      // in System unit
 {$ENDIF}
 RequireDerivedFormResource := True;
 Application.Initialize;
 Application.CreateForm(TfjsWorks, fjsWorks);
 Application.CreateForm(TfProject, fProject);
 Application.CreateForm(TfTYPE_Tag, fTYPE_Tag);
 Application.Run;
end.

