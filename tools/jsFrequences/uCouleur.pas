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
unit uCouleur;

{$mode objfpc}

interface

(*
Origines:
Point de départ: https://academo.org/demos/wavelength-to-colour-relationship/
Le site http://www.efg2.com/Lab/ScienceAndEngineering/Spectra.htm
n'existe plus (http://www.efg2.com/) mais  il en existe une archive à
https://web.archive.org/web/20190612221227/http://efg2.com/Lab/ScienceAndEngineering/Spectra.htm
cela pointe vers www.physics.sfasu.edu/astro/color.html dont une copie existe à
https://web.archive.org/web/20190522011454/http://www.midnightkite.com/color.html
et particulièrement le code Fortran à
https://web.archive.org/web/20190528182100/http://www.physics.sfasu.edu/astro/color/spectra.html
*)
uses
 Classes, SysUtils, Math;

CONST
     Nanometres_from_metre= 1E9;
     SpeedOfLight {c}   = 2.9979E8 {m/s};
     Couleur_WavelengthMinimum = 380;  // Nanometers
     Couleur_WavelengthMaximum = 780;
     Couleur_Frequence_Min= SpeedOfLight/(Couleur_WavelengthMaximum/Nanometres_from_metre);
     Couleur_Frequence_Max= SpeedOfLight/(Couleur_WavelengthMinimum/Nanometres_from_metre);

type
    Hertz= double;
    Nanometres= double;

function Vision_from_Longueur_onde( _Longueur_onde: Nanometres): double;

procedure RGB_from_Longueur_onde( _Longueur_onde: Nanometres;
                                  var _Red, _Green, _Blue: double);

function RGB_from_Longueur_onde_hex( _Longueur_onde: Nanometres): String;
function RGB_from_Longueur_onde_rgba( _Longueur_onde: Nanometres; _Alpha: double): String;

function Longueur_onde_from_Frequence( _Frequence: Hertz): Nanometres;

function Frequence_from_Longueur_onde( _Longueur_onde: Nanometres): Hertz;

function RGB_from_Frequency_hex ( _Frequence: Hertz): String;
function RGB_from_Frequency_rgba( _Frequence: Hertz; _Alpha: double): String;
function RGB_from_Frequency_tag( _Frequence: Hertz): String;
function RGB_from_Frequency_tag_begin( _Frequence: Hertz): String;
function RGB_from_Frequency_tag_body ( _Frequence: Hertz): String;
function RGB_from_Frequency_tag_end                      : String;

function Is_Visible( _Frequence_Min, _Frequence_Max: double): Boolean;overload;
function Is_Visible( _Frequence: double): Boolean;overload;

implementation

function Vision_from_Longueur_onde( _Longueur_onde: Nanometres): double;
     function Up( _Debut, _Fin: double): double;
     begin
          Result:= (_Longueur_onde - _Debut)/(_Fin-_Debut);
     end;
     function Down( _Debut, _Fin: double): double;
     begin
          Result:= (_Fin - _Longueur_onde)/(_Fin-_Debut);
     end;
begin
     // Let the intensity fall off near the vision limits
     case Trunc( _Longueur_onde)
     of
       380..419: Result:= 0.3 + 0.7*Up  ( 380, 420);
       420..700: Result:= 1.0;
       701..780: Result:= 0.3 + 0.7*Down( 700, 780);
       else      Result:= 0.0
       end;
end;

procedure RGB_from_Longueur_onde( _Longueur_onde: Nanometres;
                                  var _Red, _Green, _Blue: double);
var
   Factor: double;
   function Up( _Debut, _Fin: double): double;
   begin
        Result:= (_Longueur_onde - _Debut)/(_Fin-_Debut);
   end;
   function Down( _Debut, _Fin: double): double;
   begin
        Result:= (_Fin - _Longueur_onde)/(_Fin-_Debut);
   end;
   procedure RGB( _R, _G, _B: double);
   begin
        _Red  := _R;
        _Green:= _G;
        _Blue := _B;
   end;
   function Adjust(const Color, Factor: double): double;
   const
        Gamma= 0.80;
   begin
        Result:= 0;
        if 0 = Color then exit;

        Result:= Power(Color * Factor, Gamma);
   end;
begin
     case Trunc( _Longueur_onde)
     of
       380..439: RGB( Down( 380, 440), 0              , 1              );
       440..489: RGB( 0              , Up  ( 440, 490), 1              );
       490..509: RGB( 0              , 1              , Down( 490, 510));
       510..579: RGB( Up  ( 510, 580), 1              , 0              );
       580..644: RGB( 1              , Down( 580, 644), 0              );
       645..780: RGB( 1              , 0              , 0              );
       else      RGB( 0              , 0              , 0              );
       end;

     Factor:= Vision_from_Longueur_onde( _Longueur_onde);
     _Red  := Adjust(_Red  , Factor);
     _Green:= Adjust(_Green, Factor);
     _Blue := Adjust(_Blue , Factor)
end;

function RGB_from_Longueur_onde_hex( _Longueur_onde: Nanometres): String;
var
   Red, Green, Blue: double;
   function T( _d: double): String;
   var
      b: Byte;
   begin
        b:= Round( 255*_d);
        Result:= IntToHex( b, 2);
   end;
begin
     RGB_from_Longueur_onde( _Longueur_onde, Red, Green, Blue);
     Result:= '#'+T(Red)+T(Green)+T(Blue);
end;

function RGB_from_Longueur_onde_rgba( _Longueur_onde: Nanometres; _Alpha: double): String;
var
   Red, Green, Blue: double;
   function T( _d: double): String;
   var
      b: Byte;
   begin
        b:= Round( 255*_d);
        Result:= IntToStr( b);
   end;
begin
     RGB_from_Longueur_onde( _Longueur_onde, Red, Green, Blue);
     Result:= Format( 'rgba( %s, %s, %s, %f)',[T(Red), T(Green), T(Blue), _Alpha]);
     //WriteLn( 'Longueur onde:', _Longueur_onde, ' couleur: ',Result);
end;

function Longueur_onde_from_Frequence( _Frequence: Hertz): Nanometres;
begin
     Result:= Nanometres_from_metre * (SpeedOfLight / _Frequence) ;
end;

function Frequence_from_Longueur_onde( _Longueur_onde: Nanometres): Hertz;
begin
     Result:= SpeedOfLight / (_Longueur_onde/Nanometres_from_metre);
end;

function RGB_from_Frequency_hex( _Frequence: Hertz): String;
var
   Longueur_onde: Nanometres;
begin
     Longueur_onde:= Longueur_onde_from_Frequence( _Frequence);
     Result:= RGB_from_Longueur_onde_hex( Longueur_onde);
end;

function RGB_from_Frequency_rgba( _Frequence: Hertz; _Alpha: double): String;
var
   Longueur_onde: Nanometres;
begin
     Longueur_onde:= Longueur_onde_from_Frequence( _Frequence);
     Result:= RGB_from_Longueur_onde_rgba( Longueur_onde, _Alpha);
     //WriteLn( 'Frequence:', _Frequence, ' couleur: ',Result);
end;

function RGB_from_Frequency_tag( _Frequence: Hertz): String;
var
   Longueur_onde: Nanometres;
   Red, Green, Blue: double;
   R, G, B: Byte;
   hex: String;
begin
     Longueur_onde:= Longueur_onde_from_Frequence( _Frequence);
     RGB_from_Longueur_onde( Longueur_onde, Red, Green, Blue);
     R:= Round( 255*Red );
     G:= Round( 255*Green);
     B:= Round( 255*Blue);
     hex:= RGB_from_Frequency_hex( _Frequence);
     Result
     :=
        RGB_from_Frequency_tag_begin( _Frequence)
       +Format('longueur d''onde: %f nm  Rouge: %.3d; Vert: %.3d; Bleu: %.3d soit %s', [ Longueur_onde, R, G, B, hex])
       +RGB_from_Frequency_tag_end;
end;
function RGB_from_Frequency_tag_begin( _Frequence: Hertz): String;
var
   hex: String;
begin
     hex:= RGB_from_Frequency_hex( _Frequence);
     Result:= '<em style="background-color:'+hex+';">'
end;
function RGB_from_Frequency_tag_body ( _Frequence: Hertz): String;
var
   Longueur_onde: Nanometres;
   Red, Green, Blue: double;
   R, G, B: Byte;
   hex: String;
begin
     Longueur_onde:= Longueur_onde_from_Frequence( _Frequence);
     RGB_from_Longueur_onde( Longueur_onde, Red, Green, Blue);
     R:= Round( 255*Red );
     G:= Round( 255*Green);
     B:= Round( 255*Blue);
     hex:= RGB_from_Frequency_hex( _Frequence);
     Result
     :=
       Format( 'longueur d''onde: %f nm  Rouge: %.3d; Vert: %.3d; Bleu: %.3d soit %s',
               [ Longueur_onde, R, G, B, hex]);
end;
function RGB_from_Frequency_tag_end: String;
begin
     Result:= '</em>';
end;
function Is_Visible( _Frequence_Min, _Frequence_Max: double): Boolean; overload;
begin
     Result:= False;
     if _Frequence_Max < Couleur_Frequence_Min then exit;
     if _Frequence_Min > Couleur_Frequence_Max then exit;
     Result:= True;
end;

function Is_Visible( _Frequence: double): Boolean;overload;
begin
     Result:=(Couleur_Frequence_Min<=_Frequence)and(_Frequence<=Couleur_Frequence_Max);
end;

end.

