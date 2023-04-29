unit uhFiltre_Ancetre;
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
    uContrainte,
    uBatpro_StringList;

{ ThFiltre_Ancetre
Ancêtre de ThFiltre pour usage dans TBatpro_Ligne en évitant
des références circulaire entre TBatpro_Ligne et ThFiltre
}

type
 ThFiltre_Ancetre
 =
  class
  public
    slLIKE     : TBatpro_StringList;
    slOR_LIKE  : TBatpro_StringList;
    slLIKE_ou_VIDE: TBatpro_StringList;
    slDIFFERENT: TBatpro_StringList;
    slEGAL     : TBatpro_StringList;
    Contraintes: array of TContrainte;
  end;

const
     uhFiltre_Ancetre_Code_pour_Vide=#255; // si l'on met '' en guise de valeur
                                           // pour le Stringlist il ne prend
                                           // pas la valeur

implementation
end.
