unit u_sys_Batpro_Element;
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

const
     sys_Format_Quantite : String= '###,###,###,###,###.';
     sys_Format_Date     : String= 'dddddd';
     sys_Format_flottant : String= '###,###,###,###,###.00';
     sys_Format_flottant4: String= '###,###,###,###,###.0000';
     sys_Format_Pourcentage: String= '##0.00" %"';
     sys_Format_Pourcentage_sans_espace: String= '##0.00"%"';

function sf_Millionieme( E: Extended): String;

implementation

uses
    SysUtils,
    u_sys_,
    uReels;

{ sf_Millionieme
• Retourne une chaine vide si la valeur absolue de E est inférieure à un
  millionième.
• Dans les autre cas retourne une chaine représentant E, formatée selon la
  constante typée sys_Format_flottant (##.00)
}

function sf_Millionieme( E: Extended): String;
begin
     if EgalReel( E, 0, precision_Millionnieme)
     then
         Result:= sys_Vide
     else
         Result:= FormatFloat( sys_Format_flottant, E);
end;

end.
