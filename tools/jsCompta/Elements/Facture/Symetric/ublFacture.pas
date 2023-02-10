unit ublFacture;
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
    uReels,
    uReal_Formatter,
    uDataUtilsU,
    uRequete,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,
    uLog,
    ujsDataContexte,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,
    uPool,

    {$I ublFacture_interface_uses.inc}
    {$I ../../Piece/Symetric/ublPiece_interface_uses.inc} 

    SysUtils, Classes, SqlDB, DB;

type
{$I ublFacture_interface_type_forward.inc}
{$I ../../Piece/Symetric/ublPiece_interface_type_forward.inc} 
{$I ublFacture_interface_type.inc}
{$I ../../Piece/Symetric/ublPiece_interface_type.inc} 

{$I ublFacture_interface_var.inc}
{$I ../../Piece/Symetric/ublPiece_interface_var.inc} 

implementation

{$I ublFacture_implementation.inc}
{$I ../../Piece/Symetric/ublPiece_implementation.inc} 

initialization
finalization
            {$I ublFacture_finalization.inc}
            {$I ../../Piece/Symetric/ublPiece_finalization.inc} 
end.


