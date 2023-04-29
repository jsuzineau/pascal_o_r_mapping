unit uBatproFiltre;
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
    DB,
    u_sys_,
    uuStrings;


procedure BatproFiltre_to_Chantier_LIKE( BatproFiltre: String;
                                         var Chantier, LIKE: String);
procedure BatproFiltre_to_Chantier( var secteur_LIKE, chantier_LIKE: String);

function BatproFiltre_from_( sf: TStringField;TailleRacine:Integer):String;

implementation

procedure BatproFiltre_to_Chantier_LIKE( BatproFiltre: String;
                                         var Chantier, LIKE: String);
var
   I: Integer;
   C: Char;
begin
     Chantier:= sys_Vide;
     LIKE    := sys_Vide;
     for I:= 1 to Length( BatproFiltre)
     do
       begin
       C:= BatproFiltre[I];
       if C = '-'
       then
           begin
           Chantier:= Chantier+'0';
           LIKE    := LIKE    +'_';
           end
       else
           begin
           Chantier:= Chantier+C;
           LIKE    := LIKE    +C;
           end;
       end;
end;

procedure BatproFiltre_to_Chantier( var secteur_LIKE, chantier_LIKE: String);
var
   Poubelle: String;
begin
     BatproFiltre_to_Chantier_LIKE(  secteur_LIKE,  secteur_LIKE, Poubelle);
     BatproFiltre_to_Chantier_LIKE( chantier_LIKE, chantier_LIKE, Poubelle);
end;

function BatproFiltre_from_( sf: TStringField;TailleRacine:Integer):String;
var
   s: String;
begin
     s:= sf.Value;
     if TailleRacine <= 0
     then
         Result:= s
     else
         Result:= Copy( s,1,TailleRacine) + ChaineDe( sf.Size-TailleRacine,'-');
end;


end.
