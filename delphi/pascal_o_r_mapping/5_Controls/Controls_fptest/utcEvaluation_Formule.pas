unit utcEvaluation_Formule;
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
    uReels,
    uEvaluation_Formule;

type
 TtcEvaluation_Formule
 =
  class( TTestCase)
  private
  protected
  published
    // Test methods
    procedure Teste;
  end;

implementation

{ TtcEvaluation_Formule }

procedure TtcEvaluation_Formule.Teste;
const
     FormuleFournie = '3*1+2-3/4';
     FormuleAttendue= '(((3,00*1,00)+2,00)-(3,00/4,00))';
     ValeurAttendue= 4.25;
var
   FormuleObtenue: String;
   ValeurObtenue: Double;
begin
     FormuleObtenue
     :=
       Evaluation_Formule( FormuleFournie, ValeurObtenue);

     Check( FormuleObtenue = FormuleAttendue,
            Format( 'La formule interprétée est différente de la formule attendue.'#13#10+
                    'Obtenue : %s'#13#10+
                    'Attendue: %s'#13#10,
                    [FormuleObtenue, FormuleAttendue]));

     Check( EgalReel( ValeurObtenue, ValeurAttendue, precision_Millionnieme),
            Format( 'La valeur obtenue est différente de la valeur attendue.'#13#10+
                    'Obtenue : %f'#13#10+
                    'Attendue: %f'#13#10+
                    'Formule évaluée:'#13#10'%s',
                    [ValeurObtenue, ValeurAttendue, FormuleEvaluee]));

end;

initialization
              TestFramework.RegisterTest( 'Evaluation_Formule',
                                          TtcEvaluation_Formule.Suite);

end.
