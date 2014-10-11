unit ujpCSharp_Conteneurs;
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
    uGenerateur_Delphi_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint;

type
 TjpCSharp_Conteneurs
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
    procedure VisiteMembre(_cm: TContexteMembre); override;
    
  end;

var
   jpCSharp_Conteneurs: TjpCSharp_Conteneurs;

implementation

{ TjpCSharp_Conteneurs }

constructor TjpCSharp_Conteneurs.Create;
begin
     Cle:= '//Point d''insertion aggrégations faibles, pointeurs vers conteneurs';
end;

procedure TjpCSharp_Conteneurs.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpCSharp_Conteneurs.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     if cm.CleEtrangere
     then
         begin
         if Valeur = ''
         then
             Valeur:= '		#region Aggrégations faibles, pointeurs vers conteneurs'#13#10#13#10
         else
             Valeur:= Valeur + #13#10;
         Valeur:= Valeur +  '		Tml'+cm.sNomTableMembre+' ml'+cm.Member_Name+';';
         end;
end;

procedure TjpCSharp_Conteneurs.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur + #13#10#13#10'   #endregion'#13#10;
end;

initialization
              jpCSharp_Conteneurs:= TjpCSharp_Conteneurs.Create;
finalization
              FreeAndNil( jpCSharp_Conteneurs);
end.
