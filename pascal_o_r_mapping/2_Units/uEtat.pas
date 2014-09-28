unit uEtat;
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
    uForms,
 SysUtils, Classes, 
 uClean,
 u_sys_,
 uPublieur;

type
 TEtat
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    p: TPublieur;
    s: String;
  //Méthodes
  public
    procedure Change( _s: String);
  end;

var
   Etat: TEtat= nil;

implementation

{ TEtat }

constructor TEtat.Create;
begin
     p:= TPublieur.Create( 'Etat');
end;

destructor TEtat.Destroy;
begin
     Free_nil( p);
     inherited;
end;

procedure TEtat.Change(_s: String);
begin
     s:= _s;
     uForms_Set_Hint( s);
     p.Publie;
end;

initialization
              Etat:= TEtat.Create;
finalization
              Free_nil( Etat);
end.
