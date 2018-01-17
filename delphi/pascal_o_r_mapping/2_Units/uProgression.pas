unit uProgression;
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

var
   uProgression_Demarre        : procedure ( Titre: String;
                                             Min, Max: Single;
                                             _Immediat: Boolean = False;
                                             _Interruptible: Boolean= False) of object = nil;
   uProgression_DemarreImmediat: procedure ( Titre: String; Min, Max: Single;
                                             _Interruptible: Boolean= False) of object = nil;
   uProgression_Termine        : procedure of object = nil;
   uProgression_AddProgress    : procedure ( Value: Single) of object= nil;
   uProgression_GetInterrompre : function : Boolean of object= nil;

implementation

end.
