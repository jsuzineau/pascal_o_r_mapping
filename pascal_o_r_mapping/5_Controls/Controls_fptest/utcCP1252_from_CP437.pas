unit utcCP1252_from_CP437;
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
    uForms,
    SysUtils, 
    TestFrameWork,
    uCP1252_from_CP437;

type
 TtcCP1252_from_CP437
 =
  class( TTestCase)
  private
    sCP437 : String;
    sCP1252: String;
    procedure Cree;
  protected
  published
    // Test methods
    procedure Teste;
  end;

implementation

{ TtcCP1252_from_CP437 }

procedure TtcCP1252_from_CP437.Cree;
var
   I: Integer;
begin
     SetLength( sCP437, 255);
     for I:= 1 to 255
     do
       sCP437[I]:= Chr( I);

     SetLength( sCP1252, 255);
     //initialisation, par défaut source = cible
     for I:= 1 to 255
     do
       sCP1252[I]:= Chr( I);

     for i:= 127 to 255
     do
       sCP1252[i]:= Chr( 183);//la puce

     //définition des traductions
     sCP1252[128]:= Chr( $C7);
     sCP1252[129]:= Chr( $FC);
     sCP1252[130]:= Chr( $E9);
     sCP1252[131]:= Chr( $E2);
     sCP1252[132]:= Chr( $E4);
     sCP1252[133]:= Chr( $E0);
     sCP1252[134]:= Chr( $E5);
     sCP1252[135]:= Chr( $E7);
     sCP1252[136]:= Chr( $EA);
     sCP1252[137]:= Chr( $EB);
     sCP1252[138]:= Chr( $E8);
     sCP1252[139]:= Chr( $EF);
     sCP1252[140]:= Chr( $EE);
     sCP1252[141]:= Chr( $EC);
     sCP1252[142]:= Chr( $C4);
     sCP1252[143]:= Chr( $C5);
     sCP1252[144]:= Chr( $C9);
     sCP1252[145]:= Chr( $E6);
     sCP1252[146]:= Chr( $C6);
     sCP1252[147]:= Chr( $F4);
     sCP1252[148]:= Chr( $F6);
     sCP1252[149]:= Chr( $F2);
     sCP1252[150]:= Chr( $FB);
     sCP1252[151]:= Chr( $F9);
     sCP1252[152]:= Chr( $FF);
     sCP1252[153]:= Chr( $D6);
     sCP1252[154]:= Chr( $DC);
     sCP1252[155]:= Chr( $A2);
     sCP1252[156]:= Chr( $A3);
     sCP1252[157]:= Chr( $A5);

     sCP1252[160]:= Chr( $E1);
     sCP1252[161]:= Chr( $ED);
     sCP1252[162]:= Chr( $F3);
     sCP1252[163]:= Chr( $FA);
     sCP1252[164]:= Chr( $F1);
     sCP1252[165]:= Chr( $D1);
     sCP1252[166]:= Chr( $AA);
     sCP1252[167]:= Chr( $BA);
     sCP1252[168]:= Chr( $BF);

     sCP1252[170]:= Chr( $AC);
     sCP1252[171]:= Chr( $BD);
     sCP1252[172]:= Chr( $BC);
     sCP1252[173]:= Chr( $A1);
     sCP1252[174]:= Chr( $AB);
     sCP1252[175]:= Chr( $BB);

     sCP1252[225]:= Chr( $DF);

     sCP1252[230]:= Chr( $B5);

     sCP1252[241]:= Chr( $B1);

     sCP1252[246]:= Chr( $F7);

     sCP1252[248]:= Chr( $B0);

     sCP1252[250]:= Chr( $B7);

     sCP1252[253]:= Chr( $B2);

     sCP1252[255]:= Chr( $A0);
end;

procedure TtcCP1252_from_CP437.Teste;
var
   sObtenue: String;
begin
     Cree;
     sObtenue:= CP1252_from_CP437( sCP437);

     Check( sObtenue = sCP1252,
            Format( 'La chaine convertie obtenue est différente de la chaine de caractères attendue.'#13#10+
                    'Obtenue : %s'#13#10+
                    'Attendue: %s'#13#10,
                    [sObtenue, sCP1252]));

     //Delete( sObtenue, 1, 127);
     //uForms_ShowMessage( sObtenue);
end;

initialization
              TestFramework.RegisterTest( 'Conversion page de de code MSDOS CP437 vers Windows CP1252',
                                          TtcCP1252_from_CP437.Suite);

end.
