unit udkType_Tag_EDIT;
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
    ublType_Tag,
    upoolType_Tag,
    uDockable,
    ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
 Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons;

type

 { TdkType_Tag_edit }

 TdkType_Tag_edit
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
   blType_Tag: TblType_Tag;
 end;

implementation

{$R *.lfm}

{ TdkType_Tag_edit }

procedure TdkType_Tag_edit.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blType_Tag, TblType_Tag, Value);

     Champs_Affecte( blType_Tag, [ceName]);
end;

procedure TdkType_Tag_edit.sbDetruireClick(Sender: TObject);
begin
     Do_DockableScrollbox_Avant_Suppression;
     poolType_Tag.Supprimer( blType_Tag);
     Do_DockableScrollbox_Suppression;
end;

procedure TdkType_Tag_edit.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

end.

