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
unit uCPL_G3;

{$mode delphi}

interface

uses
 Classes, SysUtils,uFrequence,uFrequences;

const
  CPL_G3_NbPorteuses= 36;
  CPL_G3_Min=35938;{Hz}
  CPL_G3_Max=90625;{Hz}
  CPL_G3_Espacement=1562.5;{Hz}
type
 { TCPL_G3 }

 TCPL_G3
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //F
  public
    F: array of double;
    procedure Calcule_F;
    function Liste: String;
  end;

function CPL_G3: TCPL_G3;

implementation

var
   FCPL_G3: TCPL_G3= nil;

function CPL_G3: TCPL_G3;
begin
     if nil = FCPL_G3
     then
         FCPL_G3:= TCPL_G3.Create;
     Result:= FCPL_G3;
end;

{ TCPL_G3 }

constructor TCPL_G3.Create;
begin
     Calcule_F;
end;

destructor TCPL_G3.Destroy;
begin
     inherited Destroy;
end;

procedure TCPL_G3.Calcule_F;
var
   I: Integer;
begin
     SetLength( F, CPL_G3_NbPorteuses);
     for I:= Low(F) to High(F)
     do
       F[I]:=CPL_G3_Min+ I*CPL_G3_Espacement;
end;

function TCPL_G3.Liste: String;
var
   I: Integer;
   NbCoherent, NbDeCoherent, NbNeutre: Integer;
   function sNb( _Nb: Integer; _S: String): String;
   var
      dPourcent: double;
   begin
        dPourcent:= (_Nb/CPL_G3_NbPorteuses)*100;
        Result:= IntToStr(_Nb)+_S+' soit '+ Format( '%.2f', [ dPourcent])+'% des fréquences porteuses'+uFrequence_Separateur_Lignes;
   end;
begin
     NbCoherent  := 0;
     NbDeCoherent:= 0;
     Result:= '';
     for I:= Low(F) to High(F)
     do
       Result:= Result+uFrequence_Separateur_Lignes+ IntToStr(I+1)+': '+uFrequence.sFrequence( F[I])+' '+Frequences.sMatch( 7, F[I], NbCoherent, NbDeCoherent);
     NbNeutre:= CPL_G3_NbPorteuses-NbCoherent-NbDeCoherent;

     Result
     :=
        '<pre>Fréquences porteuses CPL G3'+uFrequence_Separateur_Lignes
       +sNb( NbCoherent  , ' fréquences cohérentes'  )
       +sNb( NbDeCoherent, ' fréquences décohérentes')
       +sNb( NbNeutre    , ' fréquences neutres'     )
       +Result;
     Result:= Result+'</pre>';
end;

{$ifndef PAS2JS}
initialization

finalization
            Free_nil( FCPL_G3);
{$endif}
end.
