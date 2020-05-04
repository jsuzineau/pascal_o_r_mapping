{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2020 Jean SUZINEAU - MARS42                                       |
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
unit uFrequence;

{$mode delphi}

interface

uses
 Classes, SysUtils,Math, Types, strutils;

function sFrequence( _Frequence: double; _digits: Integer=6; _Separateur: String= ' '; _Unit: Boolean= True): String;

var
   uFrequence_Separateur_Lignes: String= #13#10;

procedure Log_Frequences(_Titre: String; _Frequences: TDoubleDynArray);

function Note( _Index: Integer): String;
function Note_Latine( _Index: Integer): String;
function Liste_Octaves( _Octave: Integer; _NbOctaves: Integer): String;

implementation

function sFrequence( _Frequence: double; _digits: Integer=6; _Separateur: String= ' '; _Unit: Boolean= True): String;
   function s_from_d( _d: double): String;
      procedure Traite_Zero;
      begin
           Result:= '0';
      end;
      procedure Traite_Entier;
      begin
           Result:= FloatToStr( _d);
      end;
      procedure Traite_str;
      var
         Nb_Chiffres_partie_entiere: Integer;
         Decimals: Integer;
      begin
           Nb_Chiffres_partie_entiere:= Trunc(Log10(_d))+1;
           Decimals:= _digits-1{virgule}-Nb_Chiffres_partie_entiere;
           if Decimals < 0 then Decimals:=0;
           str( _d:_digits:Decimals, Result);
      end;
   begin
             if 0 = _d        then Traite_Zero
        else if 0 = Frac( _d) then Traite_Entier
        else                       Traite_str;
   end;
   function U( S: String): String;
   begin
        Result:= IfThen( _Unit, S, '');
   end;
   procedure  Hz;begin Result:= s_from_d( _Frequence     )+U(_Separateur+ 'Hz'); end;
   procedure KHz;begin Result:= s_from_d( _Frequence/1E3 )+U(_Separateur+'KHz'); end;
   procedure MHz;begin Result:= s_from_d( _Frequence/1E6 )+U(_Separateur+'MHz'); end;
   procedure GHz;begin Result:= s_from_d( _Frequence/1E9 )+U(_Separateur+'GHz'); end;
   procedure THz;begin Result:= s_from_d( _Frequence/1E12)+U(_Separateur+'THz'); end;
   procedure PHz;begin Result:= s_from_d( _Frequence/1E15)+U(_Separateur+'PHz'); end;
begin
          if _Frequence < 1E3  then  Hz
     else if _Frequence < 1E6  then KHz
     else if _Frequence < 1E9  then MHz
     else if _Frequence < 1E12 then GHz
     else if _Frequence < 1E15 then THz
     else if _Frequence < 1E18 then PHz
     else                            Hz;
end;

procedure Log_Frequences( _Titre: String; _Frequences: TDoubleDynArray);
var
   I: Integer;
   F: double;
begin
     WriteLn( _Titre);
     for I:= Low(_Frequences) to High(_Frequences)
     do
       begin
       F:= _Frequences[I];
       WriteLn( I, ':', sFrequence( F));
       end;
end;

function Note( _Index: Integer): String;
begin
     case _Index mod 12
     of
        0: Result:= 'C';
        1: Result:= 'C#';
        2: Result:= 'D';
        3: Result:= 'Eb';
        4: Result:= 'E';
        5: Result:= 'F';
        6: Result:= 'F#';
        7: Result:= 'G';
        8: Result:= 'G#';
        9: Result:= 'A';
       10: Result:= 'Bb';
       11: Result:= 'B';
       end;
end;

function Note_Latine( _Index: Integer): String;
begin
     case _Index mod 12
     of
        0: Result:= 'do  ';
        1: Result:= 'do# ';
        2: Result:= 'ré  ';
        3: Result:= 'ré# ';
        4: Result:= 'mi  ';
        5: Result:= 'fa  ';
        6: Result:= 'fa# ';
        7: Result:= 'sol ';
        8: Result:= 'sol#';
        9: Result:= 'la  ';
       10: Result:= 'la# ';
       11: Result:= 'si  ';
       end;
end;

function Liste_Octaves( _Octave, _NbOctaves: Integer): String;
  procedure Traite_1;
  begin
       Result:= 'Octave: '+IntToStr(_Octave);
  end;
  procedure Traite;
  var
     I: Integer;
  begin
       Result:= 'Octaves ';
       for I:= 0 to _NbOctaves-1
       do
         begin
         if I>0 then Result:= Result+', ';
         Result:= Result+IntToStr(_Octave+I);
         end;
  end;
begin
     if 1 = _NbOctaves then Traite_1
     else                   Traite;
end;
end.

