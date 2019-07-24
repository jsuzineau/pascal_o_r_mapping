unit utc_Batpro_RadioGroup;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uClean,
    ucBatpro_RadioGroup,
    TestFrameWork,
    SysUtils, Classes, Forms, Controls;

type
 Ttc_Batpro_RadioGroup
 =
  class( TTestCase)
  published
    // Test methods
    procedure Test;
  end;

implementation

{ Ttc_Batpro_RadioGroup }

procedure Ttc_Batpro_RadioGroup.Test;
var
   F: TForm;
   brg: TBatpro_RadioGroup;
   I: Integer;
begin
     F:= TForm.Create( nil);
     try
        F.Name:= 'f_tc_Batpro_RadioGroup';
        F.Width:= 300;

        brg:= TBatpro_RadioGroup.Create( F);
        brg.Parent:= F;
        brg.Name:= 'brg';
        brg.Width:= 200;
        brg.Caption:= 'Test Batpro_RadioGroup';
        brg.Align:= alClient;
        for I := 0 to 6
        do
          brg.Items.Add( 'Ligne '+IntToStr(I));

        F.ShowModal;
     finally
            Free_nil( F);
            end;
end;

initialization

  TestFramework.RegisterTest('utc_Batpro_RadioGroup Suite',
    Ttc_Batpro_RadioGroup.Suite);

end.
