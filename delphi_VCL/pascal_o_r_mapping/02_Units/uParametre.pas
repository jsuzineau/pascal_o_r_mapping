unit uParametre;
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
    uuStrings,
    uDataUtilsU;

type
 IParametre
 =
  interface
    function Parametre: String;
    function SQLConstraint: String;
  end;

function  uParametre_Parametres( a: array of IParametre): String;
function  uParametre_SQLConstraint( a: array of IParametre): String;
procedure uParametre_Execute( a: array of IParametre; var _Parametres, _SQLConstraint: String);

implementation

function uParametre_Parametres( a: array of IParametre): String;
var
   I: Integer;
   Parametre: IParametre;
begin
     Result:= '';
     for I:= Low( a) to High( a)
     do
       begin
       Parametre:= a[I];
       if Parametre = nil then continue;
       if Result <> ''
       then
           Result:= Result + #13#10;
       Result:= Result + Parametre.Parametre;
       end;
end;

function uParametre_SQLConstraint( a: array of IParametre): String;
var
   I: Integer;
   Parametre: IParametre;
   s: array of String;
begin
     SetLength( s, Length(a));
     for I:= Low( a) to High( a)
     do
       begin
       Parametre:= a[I];
       if Parametre = nil
       then
           s[I]:= ''
       else
           s[I]:= Parametre.SQLConstraint;
       end;

     Result:= SQL_AND( s);
end;

procedure uParametre_Execute( a: array of IParametre; var _Parametres, _SQLConstraint: String);
var
   I: Integer;
   Parametre: IParametre;
   s: array of String;
begin
     _Parametres:= '';
     SetLength( s, Length(a));
     for I:= Low( a) to High( a)
     do
       begin
       Parametre:= a[I];
       Ajoute_Separateur( _Parametres, Parametre.Parametre);
       if Parametre = nil
       then
           s[I]:= ''
       else
           s[I]:= Parametre.SQLConstraint;
       end;

     _SQLConstraint:= SQL_AND( s);
end;

end.
