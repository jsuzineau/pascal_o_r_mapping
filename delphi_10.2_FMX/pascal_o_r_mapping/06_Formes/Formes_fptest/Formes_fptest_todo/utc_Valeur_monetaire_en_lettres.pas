unit utc_Valeur_monetaire_en_lettres;
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
  SysUtils, FMX.Controls, FMX.Dialogs,
  TestFrameWork;

type
 Ttc_Valeur_monetaire_en_lettres
 =
  class( TTestCase)
  private
  protected
  published
    // Test methods
    procedure Test_Manuel;
  end;


implementation
uses
    utLogin, uf_Valeur_monetaire_en_lettres;

{ Ttc_Valeur_monetaire_en_lettres }

procedure Ttc_Valeur_monetaire_en_lettres.Test_Manuel;
begin
     Assure_Login;
     Check( f_Valeur_monetaire_en_lettres.Execute, 'Echec');
end;

initialization
              TestFramework.RegisterTest( 'Conversion d''une valeur monétaire en lettres',
                                          Ttc_Valeur_monetaire_en_lettres.Suite);
end.
 
