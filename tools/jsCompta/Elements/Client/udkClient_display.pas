unit udkClient_display;
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

    ublClient,
    upoolClient,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkClient_display_Copy_to_current=0;

type

 { TdkClient_display }

 TdkClient_display
 =
  class(TDockable)
  clNom: TChamp_Label;
  clAdresse_1: TChamp_Label;
  clAdresse_2: TChamp_Label;
  clAdresse_3: TChamp_Label;
  clCode_Postal: TChamp_Label;
  clVille: TChamp_Label;
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
   blClient: TblClient;
 end;

implementation

{$R *.lfm}

{ TdkClient_display }

constructor TdkClient_display.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkClient_display.Destroy;
begin
     inherited Destroy;
end;

procedure TdkClient_display.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blClient, TblClient, Value);

     Champs_Affecte( blClient, [clNom,clAdresse_1,clAdresse_2,clAdresse_3,clCode_Postal,clVille]);
end;

procedure TdkClient_display.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Client ?',
                                'Suppression de Client',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     Do_DockableScrollbox_Avant_Suppression;
     poolClient .Supprimer( blClient );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkClient_display.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkClient_display.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkClient_display_Copy_to_current);
end;

end.

