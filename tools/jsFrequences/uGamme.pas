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
unit uGamme;

{$mode delphi}

interface

uses
    uFrequence,
 Classes, SysUtils, Math, Types;

type

 { TGamme_Temperee }

 TGamme_Temperee
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Diapason: double);
    destructor Destroy; override;
  //Attributs
  public
    Diapason: double;
    Base: array[0..11] of double;
  //Méthodes
  private
    procedure Calcule;
  //Affichage de l'harmonique d'une fréquence
  public
    function Frequences( _Octave, _NbOctaves: Integer): TDoubleDynArray;
    function sFrequence(_Octave: Integer; _Base: double; _Note_Index: Integer
     ): String;

    function Liste( _Octave: Integer): String;
  private
    function Harmonique( _Frequence: double; _Octave: Integer): double;
  end;

function Gamme_418Hz: TGamme_Temperee;
function Gamme_432Hz: TGamme_Temperee;
function Gamme_440Hz: TGamme_Temperee;

implementation

var
   FGamme_418Hz: TGamme_Temperee= nil;
   FGamme_432Hz: TGamme_Temperee= nil;
   FGamme_440Hz: TGamme_Temperee= nil;

function Gamme_418Hz: TGamme_Temperee;
begin
     if nil = FGamme_418Hz
     then
         FGamme_418Hz:= TGamme_Temperee.Create( 418);
     Result:= FGamme_418Hz;
end;

function Gamme_432Hz: TGamme_Temperee;
begin
     if nil = FGamme_432Hz
     then
         FGamme_432Hz:= TGamme_Temperee.Create( 432);
     Result:= FGamme_432Hz;
end;

function Gamme_440Hz: TGamme_Temperee;
begin
     if nil = FGamme_440Hz
     then
         FGamme_440Hz:= TGamme_Temperee.Create( 440);
     Result:= FGamme_440Hz;
end;

{ TGamme_Temperee }

constructor TGamme_Temperee.Create(_Diapason: double);
begin
     Diapason:= _Diapason;
     Calcule;
end;

destructor TGamme_Temperee.Destroy;
begin
     inherited Destroy;
end;

procedure TGamme_Temperee.Calcule;
var
   I: Integer;
begin
     for I:= Low(Base) to High(Base)
     do
       Base[I]:= Diapason * (2**((I-9)/12));
end;

function TGamme_Temperee.Harmonique( _Frequence: double; _Octave: Integer): double;
begin
     Result:= _Frequence*(2**_Octave)
end;

function TGamme_Temperee.sFrequence(_Octave: Integer; _Base: double; _Note_Index: Integer): String;
var
   Frequence: double;
begin
     Frequence:= Harmonique( _Base, _Octave);
     Result:= Note_Latine(_Note_Index)+' '+uFrequence.sFrequence( Frequence);
end;

function TGamme_Temperee.Frequences( _Octave, _NbOctaves: Integer): TDoubleDynArray;
var
   LBase, O, I, iResult: Integer;
begin
     LBase:= Length(Base);
     SetLength( Result, _NbOctaves*LBase);
     for O:= 0 to _NbOctaves-1
     do
       for I:= Low(Base) to High(Base)
       do
         Result[O*LBase+I]:= Harmonique( Base[I], _Octave+O);
end;

function TGamme_Temperee.Liste( _Octave: Integer): String;
var
   I: Integer;
begin
     Result:= '<pre>'+IntToStr(_Octave)+uFrequence_Separateur_Lignes+'Gamme tempérée, diapason '+FloatToStr( Diapason)+' Hz';
     for I:= Low(Base) to High(Base)
     do
       Result:= Result+uFrequence_Separateur_Lignes+ sFrequence( _Octave, Base[I],I);
     Result:= Result+'</pre>';
end;

{$ifndef PAS2JS}
initialization

finalization
            Free_nil( FGamme_418Hz);
            Free_nil( FGamme_432Hz);
            Free_nil( FGamme_440Hz);
{$endif}
end.
