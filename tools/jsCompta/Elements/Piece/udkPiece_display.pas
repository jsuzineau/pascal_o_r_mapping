unit udkPiece_display;
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

    ublPiece,
    upoolPiece,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

const
     udkPiece_display_Copy_to_current=0;

type

 { TdkPiece_display }

 TdkPiece_display
 =
  class(TDockable)
  clidFacture: TChamp_Label;
  clDate: TChamp_Label;
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
   blPiece: TblPiece;
 end;

implementation

{$R *.lfm}

{ TdkPiece_display }

constructor TdkPiece_display.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkPiece_display.Destroy;
begin
     inherited Destroy;
end;

procedure TdkPiece_display.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blPiece, TblPiece, Value);

     Champs_Affecte( blPiece, [clidFacture,clDate]);
end;

procedure TdkPiece_display.sbDetruireClick(Sender: TObject);
begin
     if IDYES
        <>
        Application.MessageBox( 'Etes vous sûr de vouloir supprimer Piece ?',
                                'Suppression de Piece',
                                MB_ICONQUESTION+MB_YESNO)
     then
         exit;
     poolPiece .Supprimer( blPiece );
     Do_DockableScrollbox_Suppression;
end;

procedure TdkPiece_display.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

procedure TdkPiece_display.sbCopy_to_currentClick(Sender: TObject);
begin
     Envoie_Message( udkPiece_display_Copy_to_current);
end;

end.

