unit ujpCSharp_DocksDetails_Affiche;
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
 TjpCSharp_DocksDetails_Affiche
 =
  class( TJoinPoint)
  //Attributs
  public
    procedure Finalise; override;
  //Gestion du cycle de vie
  public
    constructor Create;
  //Gestion de la visite d'une classe
  public
    procedure Initialise(_cc: TContexteClasse); override;
    procedure VisiteDetail(s_Detail,sNomTableMembre: String); override;
  end;

var
   jpCSharp_DocksDetails_Affiche: TjpCSharp_DocksDetails_Affiche;

implementation

{ TjpCSharp_DocksDetails_Affiche }

constructor TjpCSharp_DocksDetails_Affiche.Create;
begin
     Cle:= '//Point d''insertion aggrégations faibles, accrochage des dock de détails';
end;

procedure TjpCSharp_DocksDetails_Affiche.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpCSharp_DocksDetails_Affiche.VisiteDetail(s_Detail,sNomTableMembre: String);
begin
     inherited;
     if Valeur = ''
     then
         Valeur:= '		#region Aggrégations faibles, accrochage des dock de détails'#13#10#13#10
     else
         Valeur:= Valeur + #13#10;
     Valeur
     :=
         Valeur
       + '      dkd'+s_Detail+'.Affiche( ml, ml.ha'+s_Detail+');';
end;

procedure TjpCSharp_DocksDetails_Affiche.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur + #13#10#13#10'   #endregion'#13#10;
end;

initialization
              jpCSharp_DocksDetails_Affiche:= TjpCSharp_DocksDetails_Affiche.Create;
finalization
              FreeAndNil( jpCSharp_DocksDetails_Affiche);
end.
