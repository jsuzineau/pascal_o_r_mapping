unit ublNom_de_la_classe;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2023 Jean SUZINEAU - MARS42                                       |
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
    ufAccueil_Erreur,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upool,

    {$I ublNom_de_la_classe_interface_uses.inc}
//pattern_Symetrics_Pascal_ubl_inc_interface_uses_pas

    SysUtils, Classes, SqlDB, DB;

type
{$I ublNom_de_la_classe_interface_type_forward.inc}
//pattern_Symetrics_Pascal_ubl_inc_interface_type_forward_pas
{$I ublNom_de_la_classe_interface_type.inc}
//pattern_Symetrics_Pascal_ubl_inc_interface_type_pas

{$I ublNom_de_la_classe_interface_var.inc}
//pattern_Symetrics_Pascal_ubl_inc_interface_var_pas

implementation

{$I ublNom_de_la_classe_implementation.inc}
//pattern_Symetrics_Pascal_ubl_inc_implementation_pas

initialization
finalization
            {$I ublNom_de_la_classe_finalization.inc}
//pattern_Symetrics_Pascal_ubl_inc_finalization_pas
end.


