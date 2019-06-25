unit udkWork ;
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

    ublWork,
    upoolWork,

    uDockable,
    ucBatpro_Shape, ucChamp_Label, ucChamp_Edit, ucBatproDateTimePicker,
    ucChamp_DateTimePicker, Classes, SysUtils, FileUtil, Forms, Controls,
    Graphics, Dialogs, Buttons,LCLType;

const
     udkWork_Copy_to_current=0;

type

 { TdkWork }

 TdkWork
 =
  class(TDockable)
  clBeginning: TChamp_Label;
  clDescription: TChamp_Label;
  sbCopy_to_current: TSpeedButton;
  sbDetruire: TSpeedButton;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbCopy_to_currentClick(Sender: TObject);
  procedure sbDetruireClick(Sender: TObject);
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blWork: TblWork;
 end;

implementation

{$R *.lfm}

{ TdkWork }

procedure TdkWork.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blWork, TblWork, Value);

     Champs_Affecte( blWork, [clBeginning,clDescription]);
end;

procedure TdkWork.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer la session ?',
                                'Suppression de Session',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolWork .Supprimer( blWork );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkWork.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkWork.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkWork_Copy_to_current);
end;

end.

