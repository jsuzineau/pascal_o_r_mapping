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
unit uResonances_de_Schumann;

{$mode delphi}

interface

uses
    uFrequence,
    uFrequences,
 Classes, SysUtils, Math, Types;

const
 uResonances_de_Schumann_source='https://fr.wikipedia.org/wiki/R%C3%A9sonances_de_Schumann';
 uResonances_de_Schumann_frequences: array of double = [7.83, 14.1, 20.3, 26.4, 32.4];
type

 { TResonances_de_Schumann }

 TResonances_de_Schumann
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Affichage de l'harmonique d'une fréquence
  public
    function Liste: String;
  end;

function Resonances_de_Schumann: TResonances_de_Schumann;

implementation

var
   FResonances_de_Schumann: TResonances_de_Schumann= nil;

function Resonances_de_Schumann: TResonances_de_Schumann;
begin
     if nil = FResonances_de_Schumann
     then
         FResonances_de_Schumann:= TResonances_de_Schumann.Create;
     Result:= FResonances_de_Schumann;
end;

{ TResonances_de_Schumann }

constructor TResonances_de_Schumann.Create;
begin
end;

destructor TResonances_de_Schumann.Destroy;
begin
     inherited Destroy;
end;

function TResonances_de_Schumann.Liste: String;
var
   NbCoherent, NbDeCoherent, NbNeutre: Integer;
   I: Integer;
begin
     Result
     :=
        '<pre>Résonances de Schumann, source '
       +uResonances_de_Schumann_source+uFrequence_Separateur_Lignes;
     for I:= Low(uResonances_de_Schumann_frequences) to High(uResonances_de_Schumann_frequences)
     do
       Result
       :=
           Result+uFrequence_Separateur_Lignes
         + IntToStr(I+1)+': '
         +sFrequence( uResonances_de_Schumann_frequences[I])
         +' '+Frequences.sMatch( -5, uResonances_de_Schumann_frequences[I], NbCoherent, NbDeCoherent);
     Result:= Result+'</pre>';
end;

{$ifndef PAS2JS}
initialization

finalization
            Free_nil( FResonances_de_Schumann);
{$endif}
end.

