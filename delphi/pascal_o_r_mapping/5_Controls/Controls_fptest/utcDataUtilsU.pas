unit utcDataUtilsU;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
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
  uDataUtilsU;

type
  TtcDataUtilsU = class(TTestCase)
  private

  protected

//    procedure SetUp; override;
//    procedure TearDown; override;

  published

    // Test methods
    procedure Test_Arrondi_00;
  end;

implementation

{ TtcDataUtilsU }

procedure TtcDataUtilsU.Test_Arrondi_00;
var
   Quantite, PrixUnitaire, MontantFourni, MontantAttendu: Double;
     procedure T( Fourni, Attendu: Double);
     var
        Obtenu: Double;
     begin
          Obtenu:= Arrondi_00( Fourni);
          Check( Attendu = Obtenu,
                 Format( 'Arrondi_00: Fourni: %f  Attendu: %f Obtenu: %f',[Fourni, Attendu, Obtenu]));
     end;

begin
     T(  7.75*3.42, 26.51);
     T( 32.3 *1.05, 33.92);

     Quantite    := 32.30;
     PrixUnitaire:=  1.05;
     MontantFourni := Quantite*PrixUnitaire;
     MontantAttendu:= 33.92;
     T( MontantFourni, MontantAttendu);

     Quantite    := 332.750;
     PrixUnitaire:=  13.10;
     MontantFourni := Quantite*PrixUnitaire;
     MontantAttendu:= 4359.03;
     T( MontantFourni, MontantAttendu);

end;

initialization

  TestFramework.RegisterTest('utcDataUtilsU Suite',TtcDataUtilsU.Suite);

end.
 
