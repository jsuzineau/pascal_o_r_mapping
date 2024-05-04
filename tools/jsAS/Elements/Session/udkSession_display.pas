unit udkSession_display;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2022 Jean SUZINEAU - MARS42                                       |
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

    ublSession,
    upoolSession,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkSession_display_Copy_to_current=0;

type

 { TdkSession_display }

 TdkSession_display
 =
  class(TDockable)
  clApplicationKey: TChamp_Label;
  clcookie_id: TChamp_Label;
  clPort: TChamp_Label;
  sbCopy_to_current: TSpeedButton;
  sbDetruire: TSpeedButton;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  procedure sbCopy_to_currentClick(Sender: TObject);
  procedure sbDetruireClick(Sender: TObject);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blSession: TblSession;
 end;

implementation

{$R *.lfm}

{ TdkSession_display }

constructor TdkSession_display.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkSession_display.Destroy;
begin
     inherited Destroy;
end;

procedure TdkSession_display.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blSession, TblSession, Value);

     Champs_Affecte( blSession, [clApplicationKey,clcookie_id,clPort]);
end;

procedure TdkSession_display.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Session ?',
                                'Suppression de Session',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     Do_DockableScrollbox_Avant_Suppression;
     poolSession .Supprimer( blSession );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkSession_display.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkSession_display.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkSession_display_Copy_to_current);
end;

end.

