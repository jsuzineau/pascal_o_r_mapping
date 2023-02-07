unit uReal_Formatter;
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
    u_sys_;

function Format_Float( Value: Double; Tronque: Boolean= False;
                       Precision: Integer= 2): String;

implementation

function Format_Float( Value: Double; Tronque: Boolean= False;
                       Precision: Integer= 2): String;
var
   Text: String;
   I: Integer;
   DisplayFormat: String;
   sPrecisionChar: Char;
   sPrecision: String;
   FF: TFormatSettings;
   function Zero: Boolean;
   begin
        Result:= I > 0;
        if Result
        then
            Result:= Text[I] = '0';
   end;
   function Virgule: Boolean;
   begin
        Result:= I > 0;
        if Result
        then
            Result:= Text[I] = DecimalSeparator;
   end;
   function Valeur_Zero: Boolean;
   var
      J: Integer;
   begin
        Result:= True;
        for J:= 1 to Length( Text)
        do
          begin
          Result:= Text[ J] in ['+', '-', '0', DecimalSeparator, ' '];
          if not Result then break;
          end;
   end;
begin
     sPrecisionChar:= '0';

     sPrecision:= StringOfChar( sPrecisionChar, Precision);
     DisplayFormat:= '###,###,###,##0.'+sPrecision;

     FF:= DefaultFormatSettings;
     //Writeln( 'FF.ThousandSeparator=', Ord(FF.ThousandSeparator));
     FF.ThousandSeparator:= #160;//espace insécable &nbsp; en ISO8859
     Text:= FormatFloat( DisplayFormat, Value, FF);
     Text:= StringReplace( Text, #160, #194#160, [rfReplaceAll]);//conversion espace insécable &nbsp; en UTF8
     I:= Length(Text);

     if Tronque //fait rapidement, redondant avec (not FF.currency)
     then
         if Pos( DecimalSeparator, Text) > 0
         then
             begin
             //Suppression des 0
             while Zero
             do
               begin
               Text[I]:= ' ';
               Dec( I);
               end;

             // Suppression de la virgule orpheline, le cas échéant
             if Virgule
             then
                 begin
                 Text[I]:= ' ';
                 Dec( I);
                 end;
             end;

     // Remplacement d'une valeur 0 par un vide
     if    Valeur_Zero
     then
         Text:= ' ';
     if Value = 0
     then
         Text:= ' ';
     if Trim(Text) = sys_Vide
     then
         Text:= ' ';

     Result:= Text;
end;


end.
