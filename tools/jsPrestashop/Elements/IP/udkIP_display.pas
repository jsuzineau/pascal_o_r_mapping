unit udkIP_display;
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

    ublIP,
    upoolIP,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkIP_display_Copy_to_current=0;

type

 { TdkIP_display }

 TdkIP_display
 =
  class(TDockable)
  clip_address: TChamp_Label;
  clnb: TChamp_Label;
  cldebut: TChamp_Label;
  clfin: TChamp_Label;
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
   blIP: TblIP;
 end;

implementation

{$R *.lfm}

{ TdkIP_display }

constructor TdkIP_display.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkIP_display.Destroy;
begin
     inherited Destroy;
end;

procedure TdkIP_display.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blIP, TblIP, Value);

     Champs_Affecte( blIP, [clip_address,clnb,cldebut,clfin]);
end;

procedure TdkIP_display.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer IP ?',
                                'Suppression de IP',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolIP .Supprimer( blIP );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkIP_display.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkIP_display.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkIP_display_Copy_to_current);
end;

end.

