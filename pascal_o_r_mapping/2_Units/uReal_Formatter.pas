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
    uLog,
    SysUtils, Classes,
    u_sys_;

function Format_Float( Value: Double; Tronque: Boolean= False;
                       Precision: Integer= 2;
                       _Separateur_Milliers: Boolean= False;
                       _DisplayFormat: String= ''): String;

var
   uReal_Formatter_Log: Boolean= False;

//Fonction provisoire car bugs dans freepascal 3:
// - pas de séparateur de milliers dans certains cas
// - l'espace insécable en unicode #$00A0
function French_FormatFloat( _Format: String; _Value: Extended): String;
function Ansi_French_FormatFloat( _Format: String; _Value: Extended): String;
function Space_French_FormatFloat( _Format: String; _Value: Extended): String;
function ThousandSeparator_FormatFloat( _Format: String; _Value: Extended; _ThousandSeparator: String): String;

implementation

//Fonction provisoire car bugs dans freepascal 3:
// - pas de séparateur de milliers dans certains cas
// - l'espace insécable en unicode #$00A0
function French_FormatFloat( _Format: String; _Value: Extended): String;
begin
     Result:= ThousandSeparator_FormatFloat( _Format, _Value, #$00A0);
end;

function Ansi_French_FormatFloat( _Format: String; _Value: Extended): String;
begin
     Result:= ThousandSeparator_FormatFloat( _Format, _Value, #$A0);
end;

function Space_French_FormatFloat( _Format: String; _Value: Extended): String;
begin
     Result:= ThousandSeparator_FormatFloat( _Format, _Value, ' ');
end;

function ThousandSeparator_FormatFloat( _Format: String; _Value: Extended; _ThousandSeparator: String): String;
var
   iPoint: Integer;
   procedure Traite_Float;
   var
      iDecimalSeparator: Integer;
      iMax: Integer;
      I: Integer;
   begin
        if 2 < iPoint
        then
            Delete( _Format, 1, iPoint-2);
        Result:= FormatFloat( _Format, _Value);
        iDecimalSeparator:= Pos( DefaultFormatSettings.DecimalSeparator, Result);
        if 0 = iDecimalSeparator
        then
            iDecimalSeparator:= Length( Result)+1;

        for I:= iDecimalSeparator-1 downto 2
        do
          begin
          if (I-iDecimalSeparator) mod 3  = 0 then Insert(_ThousandSeparator, Result, I);
          end;
   end;
   procedure Traite_Integer;
   var
      nValue: Integer;
      iFin: Integer;
      I: Integer;
   begin
        nValue:= Trunc( _Value);
        Result:= IntToStr( nValue);
        iFin:= Length( Result);
        for I:= iFin-1 downto 2
        do
          if (I-iFin) mod 3  = 0
          then
              Insert(_ThousandSeparator, Result, I);
   end;
begin
     iPoint:= Pos( '.', _Format);
     if iPoint < Length( _Format)
     then
         Traite_Float
     else
         Traite_Integer;
end;

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

     if 0 = Precision
     then
         sPrecision:= ''
     else
         sPrecision:= StringOfChar( sPrecisionChar, Precision);

     if '' <> _DisplayFormat then DisplayFormat:= _DisplayFormat
else if _Separateur_Milliers then DisplayFormat:= '###,###,###,##0.'+sPrecision//'###,###,###,##0.'+sPrecision
else                              DisplayFormat:= '###########0.'+sPrecision;

     if uReal_Formatter_Log
     then
         begin
         Log.PrintLn( 'uReal_Formatter.Format_Float: DisplayFormat='+DisplayFormat);
         Log.PrintLn( 'uReal_Formatter.Format_Float: DefaultFormatSettings= >'+DefaultFormatSettings.ThousandSeparator+'<');
         DefaultFormatSettings.ThousandSeparator:= ' ';
         Log.PrintLn( 'uReal_Formatter.Format_Float: test:'+FormatFloat( '###,###,###,##0.00',9999.99));
         end;
     Text:= French_FormatFloat( DisplayFormat, Value);//FormatFloat( DisplayFormat, Value);
     if uReal_Formatter_Log
     then
         begin
         Log.PrintLn( 'uReal_Formatter.Format_Float: Text='+Text);
         Log.PrintLn( 'uReal_Formatter.Format_Float: test sur Value:'+FormatFloat( '###,###,###,##0.00',Value));
         end;

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
