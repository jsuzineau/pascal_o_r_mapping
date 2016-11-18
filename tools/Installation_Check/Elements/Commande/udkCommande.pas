unit udkCommande ;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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

    ublCommande,

    uDockable, ucBatpro_Shape, ucChamp_Label, ucChamp_Edit,
    ucBatproDateTimePicker, ucChamp_DateTimePicker, ucChamp_LED, Classes,
    SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, Buttons, LCLType;

const
     udkCommande_Copy_to_current=0;

type

 { TdkCommande }

 TdkCommande
 =
  class(TDockable)
  cLED: TChamp_LED;
  clLibelle: TChamp_Label;
  procedure DockableKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blCommande: TblCommande;
 end;

implementation

{$R *.lfm}

{ TdkCommande }

procedure TdkCommande.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blCommande, TblCommande, Value);

     Champs_Affecte( blCommande, [cLED,clLibelle]);
end;

procedure TdkCommande.DockableKeyDown( Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     inherited;
end;

end.

