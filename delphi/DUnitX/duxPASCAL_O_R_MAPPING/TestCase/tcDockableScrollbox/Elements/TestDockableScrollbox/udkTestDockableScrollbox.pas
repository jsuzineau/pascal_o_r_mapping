unit udkTestDockableScrollbox;
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

    ublTestDockableScrollbox,

    uDockable,
    ucBatpro_Shape, ucChamp_Label, ucChamp_Edit, ucBatproDateTimePicker,
    ucChamp_DateTimePicker, Classes, SysUtils, FMX.Forms, FMX.Controls,
    FMX.Graphics, FMX.Dialogs, FMX.Controls.Presentation, FMX.StdCtrls,
  FMX.Types, FMX.Objects;

type

 { TdkTestDockableScrollbox }

 TdkTestDockableScrollbox
 =
  class(TDockable)
  clNom: TChamp_Label;
 public
  procedure SetObjet(const Value: TObject); override;
 //attributs
 private
   blTestDockableScrollbox: TblTestDockableScrollbox;
 end;

implementation

{$R *.fmx}

{ TdkTestDockableScrollbox }

procedure TdkTestDockableScrollbox.SetObjet(const Value: TObject);
begin
     inherited SetObjet(Value);

     Affecte( blTestDockableScrollbox, TblTestDockableScrollbox, Value);

     Champs_Affecte( blTestDockableScrollbox, [clNom]);
end;

end.

