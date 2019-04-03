unit ujpAngular_TypeScript_NomFichierElement;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
  SysUtils, Classes;

type
 TjpAngular_TypeScript_NomFichierElement
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
   jpAngular_TypeScript_NomFichierElement: TjpAngular_TypeScript_NomFichierElement;

implementation

{ TjpAngular_TypeScript_NomFichierElement }

constructor TjpAngular_TypeScript_NomFichierElement.Create;
begin
     Cle:= 'Angular_TypeScript_NomFichierElement';
end;

procedure TjpAngular_TypeScript_NomFichierElement.Initialise(_cc: TContexteClasse);
begin
     inherited;
     Valeur:= cc.NomTableMinuscule;
end;

initialization
              jpAngular_TypeScript_NomFichierElement:= TjpAngular_TypeScript_NomFichierElement.Create;
finalization
              FreeAndNil( jpAngular_TypeScript_NomFichierElement);
end.
