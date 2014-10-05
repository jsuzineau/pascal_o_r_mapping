unit ujpNom_de_la_table;
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
    uGlobal,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
    SysUtils, Classes;

type
 TjpNom_de_la_table
 =
  class( TJoinPoint)
  //Attributs
  public
  //Gestion du cycle de vie
  public
    constructor Create;
  //Gestion de la visite d'une classe
  public
    procedure Initialise(_cc: TContexteClasse); override;
  end;

var
   jpNom_de_la_table: TjpNom_de_la_table;

implementation

{ TjpNom_de_la_table }

constructor TjpNom_de_la_table.Create;
begin
     Cle:= s_Nom_de_la_table;
end;

procedure TjpNom_de_la_table.Initialise(_cc: TContexteClasse);
begin
     inherited;
     Valeur:= cc.Nom_de_la_table;
end;

initialization
              jpNom_de_la_table:= TjpNom_de_la_table.Create;
finalization
              FreeAndNil( jpNom_de_la_table);
end.
