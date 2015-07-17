unit ujpCSharp_Contenus;
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
    SysUtils, Classes,
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint;

type
 TjpCSharp_Contenus
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
    procedure VisiteDetail( s_Detail,sNomTableMembre: String); override;
    procedure Finalise; override;
  end;

var
   jpCSharp_Contenus: TjpCSharp_Contenus;

implementation

{ TjpCSharp_Contenus }

constructor TjpCSharp_Contenus.Create;
begin
     Cle:= '//Point d''insertion aggrégations faibles, listes de contenus';
end;

procedure TjpCSharp_Contenus.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpCSharp_Contenus.VisiteDetail(s_Detail,sNomTableMembre: String);
begin
     inherited;
     if Valeur = ''
     then
         Valeur:= '		#region Aggrégations faibles, pointeurs vers contenus'#13#10#13#10
     else
         Valeur:= Valeur + #13#10;
     Valeur
     :=
         Valeur
       + '		public ThAggregation  ha'+s_Detail
       + '= new ThAggregation();';
end;

procedure TjpCSharp_Contenus.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur + #13#10#13#10'   #endregion'#13#10;
end;

initialization
              jpCSharp_Contenus:= TjpCSharp_Contenus.Create;
finalization
              FreeAndNil( jpCSharp_Contenus);
end.
