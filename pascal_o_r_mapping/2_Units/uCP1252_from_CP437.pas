unit uCP1252_from_CP437;
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
    SysUtils;

function CP1252_from_CP437( S: String): String;

implementation

var
   t: array[0..255] of byte;

procedure Init_t;
var
   I: Integer;
begin
     //initialisation, par défaut source = cible
     for i:= 0 to 126
     do
       t[i]:= i;
     for i:= 127 to 255
     do
       t[i]:= 183;//la puce

     //définition des traductions
     t[128]:= $C7;
     t[129]:= $FC;
     t[130]:= $E9;
     t[131]:= $E2;
     t[132]:= $E4;
     t[133]:= $E0;
     t[134]:= $E5;
     t[135]:= $E7;
     t[136]:= $EA;
     t[137]:= $EB;
     t[138]:= $E8;
     t[139]:= $EF;
     t[140]:= $EE;
     t[141]:= $EC;
     t[142]:= $C4;
     t[143]:= $C5;
     t[144]:= $C9;
     t[145]:= $E6;
     t[146]:= $C6;
     t[147]:= $F4;
     t[148]:= $F6;
     t[149]:= $F2;
     t[150]:= $FB;
     t[151]:= $F9;
     t[152]:= $FF;
     t[153]:= $D6;
     t[154]:= $DC;
     t[155]:= $A2;
     t[156]:= $A3;
     t[157]:= $A5;

     t[160]:= $E1;
     t[161]:= $ED;
     t[162]:= $F3;
     t[163]:= $FA;
     t[164]:= $F1;
     t[165]:= $D1;
     t[166]:= $AA;
     t[167]:= $BA;
     t[168]:= $BF;

     t[170]:= $AC;
     t[171]:= $BD;
     t[172]:= $BC;
     t[173]:= $A1;
     t[174]:= $AB;
     t[175]:= $BB;

     t[225]:= $DF;

     t[230]:= $B5;

     t[241]:= $B1;

     t[246]:= $F7;

     t[248]:= $B0;

     t[250]:= $B7;

     t[253]:= $B2;

     t[255]:= $A0;
end;

function CP1252_from_CP437( S: String): String;
var
   I: Integer;
begin
     Result:= S;

     for I:= 1 to Length( Result)
     do
       Result[I]:= Chr( T[ Ord( Result[I])]);
end;

initialization
              Init_t;
finalization
end.
