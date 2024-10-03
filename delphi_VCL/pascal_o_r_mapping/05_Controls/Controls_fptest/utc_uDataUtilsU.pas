unit utc_uDataUtilsU;
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
    utA_CHT,
    uDataUtilsU,
  TestFrameWork;

type
 Ttc_uDataUtilsU
 =
  class(TTestCase)
  // Test methods
  published
    procedure Test_Indente;
    procedure Test_SQL_AND;
  end;

implementation

{ Ttc_uDataUtilsU }

procedure Ttc_uDataUtilsU.Test_Indente;
const
     Indentation= '  ';
     Source = 'a'#13#10'b'#13'c'#10'd';
     Attendu_False= 'a'#13#10+Indentation+'b'#13'c'#10'd';
     Attendu_True = Indentation+'a'#13#10+Indentation+'b'#13'c'#10'd';
var
   Obtenu: String;
begin
     Obtenu:= Indente( Source, Indentation, False);
     Check( Obtenu = Attendu_False, 'Echec du test de Indente( ..., False)'#13#10+Obtenu);

     Obtenu:= Indente( Source, Indentation, True);
     Check( Obtenu = Attendu_True, 'Echec du test de Indente( ..., True)'#13#10+Obtenu);
end;

procedure Ttc_uDataUtilsU.Test_SQL_AND;
const
     Attendu=
 'select id from A_PLA'#13#10
+'where'#13#10
+'          ((socets = ''DEM001''))'#13#10
+'      AND '#13#10
+'          (NOT ( '#13#10
+'                     ((secteur = '''+dbv_secteur_provisoire+'''))'#13#10
+'                 AND ((chantier LIKE '''+dbv_chantier_prefixe_Modele_planning+'%''))'#13#10
+'                ))';
var
   Obtenu: String;
begin
     Obtenu
     :=
        'select id from A_PLA'#13#10
       +'where'#13#10
       +IndenteWhere(
              SQL_AND([
                  SQL_EGAL( 'socets', 'DEM001'),
                  SQL_NOT(
                        SQL_AND([
                                  SQL_EGAL( 'secteur', dbv_secteur_provisoire),
                                  SQL_Racine( 'chantier', dbv_chantier_prefixe_Modele_planning)
                                  ])
                  )
                 ]));

     Check( Obtenu = Attendu, 'Echec du test de SQL_AND: '#13#10+Obtenu);
end;

initialization
  TestFramework.RegisterTest('utc_uDataUtilsU Suite',
    Ttc_uDataUtilsU.Suite);
end.
 
