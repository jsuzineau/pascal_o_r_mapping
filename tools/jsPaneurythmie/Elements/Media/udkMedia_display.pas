unit udkMedia_display;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2024 Jean SUZINEAU - MARS42                                       |
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

    ublMedia,
    upoolMedia,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucDockableScrollbox,
    Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons,
    LCLType;

type

 { TdkMedia_display }

 TdkMedia_display
 =
  class(TDockable)
  clTitre: TChamp_Label;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
 //Gestion du cycle de vie
 public
   constructor Create(AOwner: TComponent); override;
   destructor Destroy; override;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blMedia: TblMedia;
 end;

implementation

{$R *.lfm}

{ TdkMedia_display }

constructor TdkMedia_display.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
end;

destructor TdkMedia_display.Destroy;
begin
     inherited Destroy;
end;

procedure TdkMedia_display.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blMedia, TblMedia, Value);

     Champs_Affecte( blMedia, [clTitre]);
end;

procedure TdkMedia_display.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

end.

