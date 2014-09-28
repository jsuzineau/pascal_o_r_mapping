unit utc_uStrings;
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
  uuStrings;

type
  Ttc_uStrings = class(TTestCase)
  private

  protected

//    procedure SetUp; override;
//    procedure TearDown; override;

  published

    // Test methods
    procedure Test_Fixe_Min;
    procedure Test_Dedouble_fins_de_ligne_CRLF;
    procedure Test_Supprime_LF_finaux;
    procedure Test_StrReadString_Cesure;
    procedure Test_Wordbreak;
  end;

implementation

{ Ttc_uStrings }


{ Ttc_uStrings }

procedure Ttc_uStrings.Test_Fixe_Min;
const
     L= 12;

     procedure T( Fourni, Attendu: String);
     var
        Obtenu: String;
     begin
          Obtenu:= Fixe_Min( Fourni, L);
          Check( Attendu = Obtenu,
                 Format( 'Fixe_Min: Fourni: >%s<  Attendu: >%s< Obtenu: >%s<',[Fourni, Attendu, Obtenu]));
     end;
begin
//12345678901234567890123456789012345678901234567890123456789012345678901234567890
//         1         2         3         4         5         6         7          8

     T( '1234567890', '1234567890  ');
end;

procedure Ttc_uStrings.Test_Dedouble_fins_de_ligne_CRLF;
     procedure T( Fourni, Attendu: String);
     var
        Obtenu: String;
     begin
          Obtenu:= Dedouble_fins_de_ligne_CRLF( Fourni);
          Check( Attendu = Obtenu,
                 Format( 'Dedouble_fins_de_ligne_CRLF: Fourni: >%s<  Attendu: >%s< Obtenu: >%s<',[Fourni, Attendu, Obtenu]));
     end;
begin
     T( 'Ligne1'#13#10#13#10'Ligne2', 'Ligne1'#13#10'Ligne2');
     T( 'Ligne1'#13#10'Ligne2'      , 'Ligne1'#13#10'Ligne2');
end;

procedure Ttc_uStrings.Test_Supprime_LF_finaux;
     procedure T( Fourni, Attendu: String);
     var
        Obtenu: String;
     begin
          Obtenu:= Supprime_LF_finaux( Fourni);
          Check( Attendu = Obtenu,
                 Format( 'Supprime_LF_finaux: Fourni: >%s<  Attendu: >%s< Obtenu: >%s<',[Fourni, Attendu, Obtenu]));
     end;
begin
     T( 'Ligne1'#13#10#13#10'Ligne2'#10#10, 'Ligne1'#13#10#13#10'Ligne2');
     T( 'Ligne1'#13#10'Ligne2'            , 'Ligne1'#13#10'Ligne2');
end;

procedure Ttc_uStrings.Test_StrReadString_Cesure;
     procedure T( Fourni, Attendu: String);
     var
        S, Obtenu: String;
     begin
          S:= Fourni;
          Obtenu:= StrReadString_Cesure( S, 5);
          Check( Attendu = Obtenu,
                 Format( 'StrReadString_Cesure: Fourni: >%s<  Attendu: >%s< Obtenu: >%s<',[Fourni, Attendu, Obtenu]));
     end;
begin
     T( '12345 7','12345');
     T( '1234 67','1234 ');
     T( '123 567','123 ' );
end;

procedure Ttc_uStrings.Test_Wordbreak;
     procedure T( Fourni, Attendu, Attendu_suivant: String);
     var
        Obtenu, Obtenu_suivant: String;
     begin
          Obtenu:= Fourni;
          Obtenu_suivant:= '';
          Wordbreak( Obtenu, Obtenu_suivant);
          Check( (Attendu = Obtenu) and (Attendu_suivant = Obtenu_suivant),
                 Format( 'Wordbreak: Fourni: >%s<  Attendu: >%s<,>%s< Obtenu: >%s<,>%s<',
                         [Fourni, Attendu, Attendu_suivant, Obtenu, Obtenu_suivant]));
     end;
begin
     T('aaaaa'  ,'aaaaa' ,'' );
     T('aaaa a' ,'aaaa ' ,'a');
     T('aaa a a','aaa a ','a');
end;

initialization

  TestFramework.RegisterTest('utc_uStrings Suite',Ttc_uStrings.Suite);

end.

