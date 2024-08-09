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

const //n° octave du La 440 Hz
     nMidi_Diapason= 60;
     nOctave_diapason_midi   =5;//60
     nOctave_diapason_anglais=4;//C4
     nOctave_diapason_latin  =3;//C4=do3

const
     Note_Index_C = 0;
     Note_Index_Cd= 1;
     Note_Index_D = 2;
     Note_Index_Eb= 3;
     Note_Index_E = 4;
     Note_Index_F = 5;
     Note_Index_Fd= 6;
     Note_Index_G = 7;
     Note_Index_Gd= 8;
     Note_Index_A = 9;
     Note_Index_Bb=10;
     Note_Index_B =11;
     Note_from_Note_Index: array of String
     =
      [
      { 0} 'C',
      { 1} 'C#',
      { 2} 'D',
      { 3} 'Eb',
      { 4} 'E',
      { 5} 'F',
      { 6} 'F#',
      { 7} 'G',
      { 8} 'G#',
      { 9} 'A',
      {10} 'Bb',
      {11} 'B'
      ];
const
     Note_Index_DO  = 0;
     Note_Index_DOd = 1;
     Note_Index_RE  = 2;
     Note_Index_MIb = 3;
     Note_Index_MI  = 4;
     Note_Index_FA  = 5;
     Note_Index_FAd = 6;
     Note_Index_SOL = 7;
     Note_Index_SOLd= 8;
     Note_Index_LA  = 9;
     Note_Index_SIb =10;
     Note_Index_SI  =11;
     Note_Latine_from_Note_Index: array of String
     =
      [
      { 0} 'do  ',
      { 1} 'do# ',
      { 2} 'ré  ',
      { 3} 'mib ',
      { 4} 'mi  ',
      { 5} 'fa  ',
      { 6} 'fa# ',
      { 7} 'sol ',
      { 8} 'sol#',
      { 9} 'la  ',
      {10} 'sib ',
      {11} 'si  '
      ];

var
   uFrequence_Separateur_Lignes: String= #13#10;

procedure Log_Frequences(_Titre: String; _Frequences: TDoubleDynArray);

function Note_Index_from_Midi( _Midi: Integer): Integer;

function Note       ( _Midi: Integer): String;
function Note_Latine( _Midi: Integer): String;

function nOctave_from_Midi ( _Midi, nOctave_diapason: Integer): Integer;
function Note_Octave       ( _Midi: Integer): String;
function Note_Octave_Latine( _Midi: Integer): String;

function Liste_Octaves( _Octave: Integer; _NbOctaves: Integer): String;
function Midi_from_Note( _Note: String): Integer;

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

function Note_Index_from_Midi( _Midi: Integer): Integer;
begin
     Result:= _Midi mod 12;
end;

function Note( _Midi: Integer): String;
var
   Note_Index: Integer;
begin
     Note_Index:= Note_Index_from_Midi( _Midi);
     Result:= Note_from_Note_Index[ Note_Index];
end;

function Note_Latine( _Midi: Integer): String;
var
   Note_Index: Integer;
begin
     Note_Index:= Note_Index_from_Midi( _Midi);
     Result:= Note_Latine_from_Note_Index[ Note_Index];
end;

function nOctave_from_Midi( _Midi, nOctave_diapason: Integer): Integer;
begin
     Result:= _Midi div 12 - nOctave_diapason_midi + nOctave_diapason;
end;
function Note_Octave(_Midi: Integer): String;
var
   nOctave: Integer;
begin
     Result:= Trim(Note( _Midi));
     nOctave:= nOctave_from_Midi( _Midi, nOctave_diapason_anglais);
     Result:= Result+IntToStr( nOctave);
end;

function Note_Octave_Latine(_Midi: Integer): String;
var
   nOctave: Integer;
begin
     Result:= Trim(Note_Latine( _Midi));
     nOctave:= nOctave_from_Midi( _Midi, nOctave_diapason_latin);
     Result:= Result+IntToStr( nOctave);
end;

function Midi_from_Note( _Note: String): Integer;
var
   nOctave: Integer;
   sNote: String;
   nNote: Integer;
   Octave_par_defaut: Boolean;
   latin: Boolean;
   procedure Extrait_Octave;
   var
      i: integer;
      sOctave: String;
   begin
        _Note:= Trim(_Note);
        sOctave:= '';
        Octave_par_defaut:= False;
        i:= Length( _Note);
        while (i>0) and (_Note[i] in ['0'..'9'])
        do
          begin
          sOctave:= _Note[i]+sOctave;
          dec(i);
          end;
        sNote:= Lowercase( Copy( _Note, 1, Length(_Note)-Length(sOctave)));

        Octave_par_defaut:= 0 = Length(sOctave);
        if not TryStrToInt( sOctave, nOctave)
        then
            nOctave:= 0;
   end;
   procedure Decode_Note;
   var
      i: Integer;
      function Suivant: Char;
      begin
           inc(i);

           if i > Length(sNote)
           then
               Result:= ' '
           else
               Result:= sNote[i];
      end;
   begin
        nNote:= 0;
        latin:= False;
        i:= 0;
        case Suivant
        of
          'a': nNote:= 9;
          'b':
            case Suivant
            of
              'b' :nNote:= 10;//Bb
              else nNote:= 11;//B
              end;
          'c':
            case Suivant
            of
              '#' :nNote:= 1;//C#
              else nNote:= 0;//C
              end;
          'd':
            case Suivant
            of
              'o' :
                begin
                latin:= True;
                case Suivant
                of
                  '#' :nNote:= 1;//do#
                  else nNote:= 0;//do
                  end;
                end;
              else nNote:= 2;//D
              end;
          'e':
            case Suivant
            of
              'b' :nNote:= 3;//Eb
              else nNote:= 4;//E
              end;
          'f':
            case Suivant
            of
              'a' :
                begin
                latin:= True;
                case Suivant
                of
                  '#' :nNote:= 6;//fa#
                  else nNote:= 5;//fa
                  end;
                end;
              '#' :nNote:= 6;//f#
              else nNote:= 5;//f
              end;
          'g':
            case Suivant
            of
              '#' :nNote:= 8;//G#
              else nNote:= 7;//G
              end;
          'l':
            case Suivant
            of
              'a' :
                begin
                latin:= True;
                case Suivant
                of
                  '#' :nNote:=10;//la#
                  else nNote:= 9;//la
                  end;
                end;
              end;
          'm':
            case Suivant
            of
              'i' :
                begin
                latin:= True;
                case Suivant
                of
                  'b' : nNote:=3;
                  else  nNote:=4;//mi
                  end;
                end;
              end;
          'r': //traitement différent pour éviter les problèmes avec l'UTF8
            begin
            latin:= True;
            if '#' = sNote[Length(sNote)]
            then
                nNote:= 3 //ré#
            else
                nNote:= 2;//ré
            end;
          's':
            begin
            latin:= True;
            case Suivant
            of
              'i' :
                case Suivant
                of
                  'b' : nNote:=10;
                  else  nNote:=11;
                  end;
              'o' :
                case Suivant
                of
                  'l' :
                    case Suivant
                    of
                      '#' :nNote:= 8;//sol#
                      else nNote:= 7;//sol
                      end;
                  end;
              end;
            end;
          end;
   end;
   var
      Base_Midi: Integer;
      nOctave_diapason: Integer;
begin
     Extrait_Octave;
     Decode_Note;
     nOctave_diapason:= ifthen( latin, nOctave_diapason_latin, nOctave_diapason_anglais);
     if Octave_par_defaut
     then
         nOctave:= nOctave_diapason;
     Base_Midi:= nMidi_Diapason+(nOctave-nOctave_diapason)*12;
     Result:= nNote+Base_Midi;
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

