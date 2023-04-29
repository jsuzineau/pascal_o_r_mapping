unit uReal_Formatter;
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
    System.SysUtils,
    Classes,
    u_sys_;

function Format_Float( Value: Double; Tronque: Boolean= False;
                       Precision: Integer= 2;
                       _Separateur_Milliers: Boolean= False;
                       _DisplayFormat: String= ''): String;

implementation

function Format_Float( Value: Double;
                       Tronque: Boolean= False;
                       Precision: Integer= 2;
                       _Separateur_Milliers: Boolean= False;
                       _DisplayFormat: String= ''): String;
var
   Text: String;
   I: Integer;
   DisplayFormat: String;
   sPrecisionChar: Char;
   sPrecision: String;
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
            Result:= Text[I] = FormatSettings.DecimalSeparator;
   end;
   function Valeur_Zero: Boolean;
   var
      J: Integer;
   begin
        Result:= True;
        for J:= 1 to Length( Text)
        do
          begin
          Result:= Text[ J] in ['+', '-', '0', FormatSettings.DecimalSeparator, ' '];
          if not Result then break;
          end;
   end;
begin
     sPrecisionChar:= '0';

     sPrecision:= StringOfChar( sPrecisionChar, Precision);
     if '' <> _DisplayFormat then DisplayFormat:= _DisplayFormat
else if _Separateur_Milliers then DisplayFormat:= '###,###,###,##0.'+sPrecision
else                              DisplayFormat:= '###########0.'+sPrecision;

     Text:= FormatFloat( DisplayFormat, Value);
     I:= Length(Text);

     if Tronque //fait rapidement, redondant avec (not FF.currency)
     then
         if Pos( FormatSettings.DecimalSeparator, Text) > 0
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
