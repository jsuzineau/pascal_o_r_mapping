unit u_sys_;
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

//Chaines non sujettes à traduction, relatives au système

interface

const
     sys_Vide : String = '';
     sys_N    : String = #13   ;//Passé à #13 seul pour Open Office. Marche aussi avec QuickReport
     sys_CR_NL: String = #13#10;//Pour les paramètres OpenOffice
     LineEnding: String = #13#10;//pour compatibilité Freepascal
     sys_Pipe : String = '|';
     sys_Point: String = '.';

     //Polices
     sys_Arial          : String= 'Arial'          ;
     sys_Courier_New    : String= 'Courier New'    ;
     sys_SmallFonts     : String= 'Small Fonts'    ;
     sys_Times_New_Roman: String= 'Times New Roman';

implementation

end.
