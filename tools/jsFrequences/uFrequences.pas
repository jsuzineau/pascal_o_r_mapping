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
unit uFrequences;
{$mode objfpc}
interface

uses
    uFrequence,
    uCouleur,
 Classes, SysUtils, Math, Types;
const
  uFrequences_coherent: array of double= (256, 269.8, 288, 303.1, 324, 341.2, 364.7, 384, 404.5, 432, 455.1, 486);
  uFrequences_decoherent: array of double= (249.4, 262.8, 278.8, 295.5, 313.4, 332.5, 352.8, 374.3, 394.1, 418.0, 443.2, 470.3);
  uFrequences_band_half_width=0.85;{%}
  uFrequences_Bas_factor =(1-(uFrequences_band_half_width/100));
  uFrequences_Haut_factor=(1+(uFrequences_band_half_width/100));


type

 { TFrequences }

 TFrequences
 =
  class
  //Affichage de l'harmonique d'une fréquence
  private
    function Boundaries(_Octave, _NbOctaves: Integer; _Base: TDoubleDynArray; _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
    function Centers(_Octave, _NbOctaves: Integer;_Base: TDoubleDynArray; _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
  public
    function sFrequence( _Octave: Integer; _Base: double; _Note_Index: Integer): String;

    function   aCoherent_boundaries( _Octave, _NbOctaves: Integer; _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
    function aDeCoherent_boundaries( _Octave, _NbOctaves: Integer; _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
    function   aCoherent_centers( _Octave, _NbOctaves: Integer; _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
    function aDeCoherent_centers( _Octave, _NbOctaves: Integer; _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
    function Liste( _Octave: Integer; _NbOctaves: Integer=1; _iDebut: Integer=-1; _iFin: Integer=-1): String;

    function Liste_from_Frequence( _Frequence: double): String;

    function Match_Base(_Octave: Integer; _Base: double; _Frequence: double;
     _Prefixe: String; _Note_Index: Integer; var _Nb: Integer): String;
    function sMatch( _Octave: Integer; _Frequence: double; var _NbCoherent, _NbDeCoherent: Integer): String;
    function Octave_from_Frequence( _Frequence: double): Integer;
    function Frequence_from_Midi( _Index: Integer): double;
    function Octave_from_Midi( _Index: Integer):Integer;
  private
    function Harmonique( _Frequence: double; _Octave: Integer): double;
    function Frequence_in_Octave( _Frequence: double; _Octave: Integer): Boolean;
  end;

function Frequences: TFrequences;

function uFrequences_Min: double;
function uFrequences_Max: double;

implementation

function uFrequences_Min: double;
begin
     Result:= uFrequences_decoherent[0];
end;

function uFrequences_Max: double;
begin
     Result:= uFrequences_coherent[High(uFrequences_coherent)];
end;

var
   FFrequences: TFrequences= nil;

function Frequences: TFrequences;
begin
     if nil = FFrequences
     then
         FFrequences:= TFrequences.Create;
     Result:= FFrequences;
end;

{ TFrequences }

function TFrequences.Harmonique( _Frequence: double; _Octave: Integer): double;
begin
     Result:= _Frequence*(2**_Octave)
end;

function TFrequences.sFrequence( _Octave: Integer; _Base: double; _Note_Index: Integer): String;
var
   Frequence, Bas, Haut: double;
begin
     Frequence:= Harmonique( _Base, _Octave);
     Bas := Frequence*uFrequences_Bas_factor;
     Haut:= Frequence*uFrequences_Haut_factor;
     Result:= Note_Latine(_Note_Index)+' Min: '+uFrequence.sFrequence( Bas)+' / Centre: '+uFrequence.sFrequence( Frequence)+' / Max: '+uFrequence.sFrequence( Haut);
     if Is_Visible( Frequence)
     then
         Result
         :=
            RGB_from_Frequency_tag_begin( Frequence)
           +Result + ' '
           +RGB_from_Frequency_tag_body( Frequence)
           +RGB_from_Frequency_tag_end;
end;

function TFrequences.Boundaries( _Octave, _NbOctaves: Integer; _Base: TDoubleDynArray;
                                 _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
var
   LBase, TailleResult, O, I: Integer;
   procedure Traite_Frequence;
   var
      Frequence, Bas, Haut: double;
      iBase, iResult: Integer;
   begin
        Frequence:= Harmonique( _Base[I], _Octave+O);
        Bas := Frequence*uFrequences_Bas_factor;
        Haut:= Frequence*uFrequences_Haut_factor;
        iBase:=O*LBase+I;
        if iBase < _iDebut then exit;
        if _iFin <  iBase  then exit;
        iResult:= 2*(iBase-_iDebut);
        Result[iResult+0]:= Bas;
        Result[iResult+1]:= Haut;
   end;
begin
     LBase:= Length( _Base);
     if -1 = _iDebut
     then
         begin
         _iDebut:= 0;
         _iFin := _NbOctaves*LBase-1;
         end;
     TailleResult:= 2*(_iFin-_iDebut + 1);
     SetLength( Result, TailleResult);
     for O:= 0 to _NbOctaves-1
     do
       for I:= Low(_Base) to High(_Base)
       do
         Traite_Frequence;
end;

function TFrequences.aCoherent_boundaries( _Octave, _NbOctaves: Integer;
                                           _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
begin
     Result:= Boundaries( _Octave, _NbOctaves, uFrequences_coherent, _iDebut, _iFin);
end;

function TFrequences.aDeCoherent_boundaries( _Octave, _NbOctaves: Integer;
                                             _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
begin
     Result:= Boundaries( _Octave, _NbOctaves, uFrequences_decoherent, _iDebut, _iFin);
end;

function TFrequences.Centers( _Octave, _NbOctaves: Integer; _Base: TDoubleDynArray;
                              _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
var
   LBase, TailleResult, O, I, iBase, iResult: Integer;
begin
     LBase:= Length(_Base);
     if -1 = _iDebut
     then
         begin
         _iDebut:= 0;
         _iFin := _NbOctaves*LBase-1;
         end;
     TailleResult:= _iFin-_iDebut + 1;
     SetLength( Result, TailleResult);
     for O:= 0 to _NbOctaves-1
     do
       for I:= Low(_Base) to High(_Base)
       do
         begin
         iBase:=O*LBase+I;
         if iBase < _iDebut then continue;
         if _iFin <  iBase  then continue;
         iResult:= iBase-_iDebut;
         Result[iResult]:= Harmonique( _Base[I], _Octave+O);
         end;
end;

function TFrequences.aCoherent_centers( _Octave, _NbOctaves: Integer;
                                        _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
begin
     Result:= Centers( _Octave, _NbOctaves, uFrequences_coherent, _iDebut, _iFin);
end;

function TFrequences.aDeCoherent_centers( _Octave, _NbOctaves: Integer;
                                          _iDebut: Integer=-1; _iFin: Integer=-1): TDoubleDynArray;
begin
     Result:= Centers( _Octave, _NbOctaves, uFrequences_decoherent, _iDebut, _iFin);
end;

function TFrequences.Liste( _Octave: Integer; _NbOctaves: Integer;
                            _iDebut: Integer=-1; _iFin: Integer=-1): String;
var
   LBase,I, O, iBase, iResult: Integer;
begin
     LBase:= Length(uFrequences_coherent);
     if -1 = _iDebut
     then
         begin
         _iDebut:= 0;
         _iFin := _NbOctaves*LBase-1;
         end;

     Result:= '<pre>'+Liste_Octaves( _Octave, _NbOctaves)+uFrequence_Separateur_Lignes+'Bandes de fréquences cohérentes';
     for O:= 0 to _NbOctaves-1
     do
       for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
       do
         begin
         iBase:=O*LBase+I;
         if iBase < _iDebut then continue;
         if _iFin <  iBase  then continue;
         iResult:= iBase-_iDebut;
         Result:= Result+uFrequence_Separateur_Lignes+ sFrequence( _Octave+O, uFrequences_coherent[I], I);
         end;

     Result:= Result+uFrequence_Separateur_Lignes+ 'Bandes de fréquences décohérentes';
     for O:= 0 to _NbOctaves-1
     do
       for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
       do
         begin
         iBase:=O*LBase+I;
         if iBase < _iDebut then continue;
         if _iFin <  iBase  then continue;
         iResult:= iBase-_iDebut;
         Result:= Result+uFrequence_Separateur_Lignes+ sFrequence( _Octave+O, uFrequences_decoherent[I], I);
         end;
     Result:= Result+'</pre>';
end;

function TFrequences.Match_Base(_Octave: Integer; _Base: double; _Frequence: double; _Prefixe: String; _Note_Index: Integer; var _Nb: Integer): String;
var
   F, Bas, Haut: double;
begin
     F:= Harmonique( _Base, _Octave);
     Bas := F*uFrequences_Bas_factor;
     Haut:= F*uFrequences_Haut_factor;
     if (Bas <= _Frequence) and (_Frequence <= Haut)
     then
         begin
         Result:= _Prefixe+' dans la bande '+ sFrequence( _Octave, _Base, _Note_Index);
         Inc( _Nb);
         end
     else
         Result:= '';
end;

function TFrequences.sMatch(_Octave: Integer; _Frequence: double; var _NbCoherent, _NbDeCoherent: Integer): String;
var
   I: Integer;
begin
     Result:= '';
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+Match_Base( _Octave, uFrequences_coherent[I], _Frequence, '  cohérent', I, _NbCoherent);
     for I:= Low(uFrequences_coherent) to High(uFrequences_coherent)
     do
       Result:= Result+Match_Base( _Octave+1, uFrequences_coherent[I], _Frequence, '  cohérent', I, _NbCoherent);

     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+Match_Base( _Octave, uFrequences_decoherent[I], _Frequence, 'décohérent', I, _NbDeCoherent);
     for I:= Low(uFrequences_decoherent) to High(uFrequences_decoherent)
     do
       Result:= Result+Match_Base( _Octave+1, uFrequences_decoherent[I], _Frequence, 'décohérent', I, _NbDeCoherent);
end;

function TFrequences.Octave_from_Frequence(_Frequence: double): Integer;
begin
     if _Frequence > uFrequences_Min
     then
         Result:= Trunc( Log2(_Frequence/uFrequences_Min))
     else
         Result:= -Trunc( Log2(uFrequences_Max/_Frequence));
end;

function TFrequences.Frequence_from_Midi( _Index: Integer): double;
var
   Frequence_Base: double;
begin
     Frequence_Base:= uFrequences_coherent[_Index mod 12];
     Result:= Harmonique( Frequence_Base, Octave_from_Midi( _Index));
end;

function TFrequences.Octave_from_Midi( _Index: Integer): Integer;
begin
     Result:= (_Index - 60(*début gamme diapason*)) div 12;
end;

function TFrequences.Frequence_in_Octave(_Frequence: double; _Octave: Integer): Boolean;
var
   Bas, Haut: double;
begin
     Bas := Harmonique( uFrequences_Min, _Octave);
     Haut:= Harmonique( uFrequences_Max, _Octave);
     Result:= (Bas <= _Frequence)and(_Frequence<= Haut);
end;

function TFrequences.Liste_from_Frequence(_Frequence: double): String;
var
   Octave: Integer;
begin
     Octave:= Octave_from_Frequence( _Frequence);
     Result
     :=
        '<pre>Fréquence: '+uFrequence.sFrequence( _Frequence)+uFrequence_Separateur_Lignes
       + Liste( Octave);
     Result:= Result+'</pre>';
end;

{$ifndef PAS2JS}
initialization

finalization
            FreeAndNil( FFrequences);
{$endif}
end.

