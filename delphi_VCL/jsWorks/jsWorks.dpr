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
uses
  FMX.Forms,
  uhdmCalendrier in 'Elements\Calendrier\uhdmCalendrier.pas',
  uodCalendrier in 'Elements\Calendrier\uodCalendrier.pas',
  ublCalendrier in 'Elements\Calendrier\ublCalendrier.pas',
  uhfCategorie in 'Elements\Categorie\uhfCategorie.pas',
  upoolCategorie in 'Elements\Categorie\upoolCategorie.pas',
  ublCategorie in 'Elements\Categorie\ublCategorie.pas',
  udkDevelopment in 'Elements\Development\udkDevelopment.pas',
  uhfDevelopment in 'Elements\Development\uhfDevelopment.pas',
  upoolDevelopment in 'Elements\Development\upoolDevelopment.pas',
  ublDevelopment in 'Elements\Development\ublDevelopment.pas',
  uhfJour_ferie in 'Elements\Jour_Ferie\uhfJour_ferie.pas',
  upoolJour_ferie in 'Elements\Jour_Ferie\upoolJour_ferie.pas',
  ublJour_ferie in 'Elements\Jour_Ferie\ublJour_ferie.pas',
  ufProject in 'Elements\Project\ufProject.pas',
  uhfProject in 'Elements\Project\uhfProject.pas',
  upoolProject in 'Elements\Project\upoolProject.pas',
  ublProject in 'Elements\Project\ublProject.pas',
  udkProject_EDIT in 'Elements\Project\udkProject_EDIT.pas',
  udkProject_LABEL in 'Elements\Project\udkProject_LABEL.pas',
  udkSession in 'Elements\Session\udkSession.pas',
  uhdmSession in 'Elements\Session\uhdmSession.pas',
  uodSession in 'Elements\Session\uodSession.pas',
  ublSession in 'Elements\Session\ublSession.pas',
  uhfState in 'Elements\State\uhfState.pas',
  upoolState in 'Elements\State\upoolState.pas',
  ublState in 'Elements\State\ublState.pas',
  udkWork_haTag_LABEL in 'Elements\Tag\udkWork_haTag_LABEL.pas',
  ufTag in 'Elements\Tag\ufTag.pas',
  uhfTag in 'Elements\Tag\uhfTag.pas',
  uodTag in 'Elements\Tag\uodTag.pas',
  upoolTag in 'Elements\Tag\upoolTag.pas',
  ublTag in 'Elements\Tag\ublTag.pas',
  udkTag_LABEL in 'Elements\Tag\udkTag_LABEL.pas',
  udkTag_LABEL_od in 'Elements\Tag\udkTag_LABEL_od.pas',
  udkWork_haTag_from_Description_LABEL in 'Elements\Tag\udkWork_haTag_from_Description_LABEL.pas',
  uhfTag_Development in 'Elements\Tag_Development\uhfTag_Development.pas',
  upoolTag_Development in 'Elements\Tag_Development\upoolTag_Development.pas',
  ublTag_Development in 'Elements\Tag_Development\ublTag_Development.pas',
  uhfTag_Work in 'Elements\Tag_Work\uhfTag_Work.pas',
  upoolTag_Work in 'Elements\Tag_Work\upoolTag_Work.pas',
  ublTag_Work in 'Elements\Tag_Work\ublTag_Work.pas',
  ufType_Tag in 'Elements\Type_Tag\ufType_Tag.pas',
  uhfType_Tag in 'Elements\Type_Tag\uhfType_Tag.pas',
  upoolType_Tag in 'Elements\Type_Tag\upoolType_Tag.pas',
  ublType_Tag in 'Elements\Type_Tag\ublType_Tag.pas',
  udkType_Tag_EDIT in 'Elements\Type_Tag\udkType_Tag_EDIT.pas',
  udkWork in 'Elements\Work\udkWork.pas',
  uhfWork in 'Elements\Work\uhfWork.pas',
  uodWork_from_Period in 'Elements\Work\uodWork_from_Period.pas',
  upoolWork in 'Elements\Work\upoolWork.pas',
  ublWork in 'Elements\Work\ublWork.pas',
  ufTemps in 'ufTemps.pas',
  ufjsWorks in 'ufjsWorks.pas';

{$R *.res}

begin
     Application.Initialize;
     Application.CreateForm(TfjsWorks, fjsWorks);
     Application.Run;
end.

