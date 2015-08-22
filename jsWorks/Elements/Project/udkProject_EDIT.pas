unit udkProject_EDIT;
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

{$mode delphi}

interface

uses
    uClean,
    uBatpro_StringList,
    uChamps,
    ublProject,
    upoolProject,
    uDockable,
    ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons;

type

 { TdkProject_EDIT }

 TdkProject_EDIT
 =
  class(TDockable)
  ceName: TChamp_Edit;
  sbDetruire: TSpeedButton;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbDetruireClick(Sender: TObject);
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blProject: TblProject;
 end;

implementation

{$R *.lfm}

{ TdkProject_EDIT }

procedure TdkProject_EDIT.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blProject, TblProject, Value);

     Champs_Affecte( blProject, [ceName]);
end;

procedure TdkProject_EDIT.sbDetruireClick(Sender: TObject);
begin
     poolProject.Supprimer( blProject);
     Do_DockableScrollbox_Suppression;
end;

procedure TdkProject_EDIT.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

end.

