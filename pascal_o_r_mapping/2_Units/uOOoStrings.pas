unit uOOoStrings;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2008,2011,2012,2014 Jean SUZINEAU - MARS42                        |
    Copyright 2008,2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

interface

uses
    uOD_Forms,
 SysUtils, Classes, DOM;

const
     sys_Vide= '';

function StrToK( Key: String; var S: String): String; overload;
function StrToK( Key: DOMString; var S: DOMString): DOMString; overload;

procedure Modele_inexistant( _NomFichierModele: String);

implementation

function StrToK( Key: String; var S: String): String; overload;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

function StrToK( Key: DOMString; var S: DOMString): DOMString; overload;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

procedure Modele_inexistant( _NomFichierModele: String);
var
   S: String;
begin
     if _NomFichierModele = ''
     then
         S:= 'Pas de modèle trouvé pour ce choix.'
     else
         S:= 'Le modèle ci-dessous entre > et < n''existe pas.'#13#10
            +'>'+_NomFichierModele+'<';
     uOD_Forms_ShowMessage( S);
end;

end.
