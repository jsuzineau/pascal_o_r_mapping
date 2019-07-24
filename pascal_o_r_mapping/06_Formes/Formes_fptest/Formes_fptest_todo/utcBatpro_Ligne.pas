unit utcBatpro_Ligne;
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
    SysUtils, Classes,
    TestFrameWork,
    uBatpro_Ligne,
    ublTest_Batpro_Ligne,
    udmxTest_Batpro_Ligne,
    ufTest_Batpro_Ligne;

type
  TtcBatpro_Ligne = class(TTestCase)
  private
   procedure Ouvrir;
   procedure ReOuvrir;
   procedure Fermer;
  protected

  published
    // Test methods
    procedure Test;
    procedure TestChampsGrid;
    procedure TestChampEdit;
  end;

implementation

uses ufTestChampGrid;

{ TtcBatpro_Ligne }

procedure TtcBatpro_Ligne.Ouvrir;
begin
     Check( dmxTest_Batpro_Ligne.Ouvrir_LectureSeule,
            'Echec de dmxTest_Batpro_Ligne.Ouvrir_LectureSeule');
end;

procedure TtcBatpro_Ligne.ReOuvrir;
begin
     Check( dmxTest_Batpro_Ligne.ReOuvrir,
            'Echec de dmxTest_Batpro_Ligne.ReOuvrir');
end;

procedure TtcBatpro_Ligne.Fermer;
begin
     Check( dmxTest_Batpro_Ligne.Fermer,
            'Echec de dmxTest_Batpro_Ligne.Fermer');
end;

procedure TtcBatpro_Ligne.Test;
const
     sCle= '1';
var
   bl: TblTest_Batpro_Ligne;
   test_string, test_string_ORIGINAL: String;
   procedure Trouve_bl;
   begin
        bl:= blTest_Batpro_Ligne_from_sl_sCle( dmxTest_Batpro_Ligne.hr.T, sCle);
        Check( Assigned(bl),
               'objet blTest_Batpro_Ligne clé "'+sCle+'" introuvable');
   end;
begin
     test_string:= FormatDateTime( 'dddddd", "tt', Now);

     Ouvrir;
     try
        Trouve_bl;
        test_string_ORIGINAL:= bl.test_string;
        bl.test_string:= test_string;
        bl.Save_to_database;

        ReOuvrir;
        Trouve_bl;
        Check( bl.test_string = test_string,
               'bl.Save_to_database n''a pas fonctionné, 1');
        bl.test_string:= test_string_ORIGINAL;
        bl.Save_to_database;
        ReOuvrir;
        Trouve_bl;
        Check( bl.test_string = test_string_ORIGINAL,
               'bl.Save_to_database n''a pas fonctionné, 2');
     finally
            Fermer;
            end;
end;

procedure TtcBatpro_Ligne.TestChampsGrid;
begin
     Ouvrir;
     try
        fTestChampGrid.Execute( dmxTest_Batpro_Ligne.hr.T);
     finally
            Fermer;
            end;
end;

procedure TtcBatpro_Ligne.TestChampEdit;
begin
     Ouvrir;
     try
        fTest_Batpro_Ligne.Execute( blTest_Batpro_Ligne_from_sl(dmxTest_Batpro_Ligne.hr.T, 0));
     finally
            Fermer;
            end;
end;

initialization
              TestFramework.RegisterTest( 'utcBatpro_Ligne Suite',
                                          TtcBatpro_Ligne.Suite);

end.
//Test_Batpro_Ligne
//12345678901234567890123456789012345678901234567890123456789012345678901234567890
//         1         2         3         4         5         6         7          8
