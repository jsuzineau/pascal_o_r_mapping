unit udkDevelopment;
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

{$IFDEF FPC}
{$mode delphi}
{$ENDIF}

interface

uses
    uClean,
    uBatpro_StringList,
    uChamps,

    ublDevelopment,
    upoolDevelopment,

    uDockable,
    ucBatpro_Shape, ucChamp_Label, ucChamp_Edit, ucBatproDateTimePicker,
    ucChamp_DateTimePicker, Classes, SysUtils, Forms, Controls,
    Graphics, Dialogs, Buttons, FMX.DialogService, UITypes;

type

 { TdkDevelopment}

 TdkDevelopment
 =
  class(TDockable)
  clDescription_Short: TChamp_Label;
  sbDetruire: TSpeedButton;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbDetruireClick(Sender: TObject);
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blDevelopment: TblDevelopment;
 end;

implementation

{$R *.lfm}

{ TdkDevelopment}

procedure TdkDevelopment.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blDevelopment, TblDevelopment, Value);

     Champs_Affecte( blDevelopment, [clDescription_Short]);
end;

procedure TdkDevelopment.sbDetruireClick(Sender: TObject);
begin
     TDialogService
     .
      MessageDialog( 'Etes vous sûr de vouloir supprimer le Development ?',
                     TMsgDlgType.mtConfirmation,
                     [TMsgDlgBtn.mbYes, TMsgDlgBtn.mbNo],
                     TMsgDlgBtn.mbNo,
                     0,
                     procedure (const _Result: TModalResult)
                     begin
                          if mrYes <> _Result then exit;
                          poolDevelopment.Supprimer( blDevelopment);
                          Do_DockableScrollbox_Suppression;
                     end
                     );
end;

procedure TdkDevelopment.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

end.

