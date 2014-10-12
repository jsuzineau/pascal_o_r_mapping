unit ujpPascal_Get_by_Cle_Declaration;
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
 TjpPascal_Get_by_Cle_Declaration
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
    procedure VisiteMembre(_cm: TContexteMembre); override;
    procedure Finalise; override;
  end;

var
   jpPascal_Get_by_Cle_Declaration: TjpPascal_Get_by_Cle_Declaration;

implementation

{ TjpPascal_Get_by_Cle_Declaration }

constructor TjpPascal_Get_by_Cle_Declaration.Create;
begin
     Cle:= '//pattern_Get_by_Cle_Declaration';
end;

procedure TjpPascal_Get_by_Cle_Declaration.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_Get_by_Cle_Declaration.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;

     if not cm.Belongs_to_sCle then exit;

     if Valeur = ''
     then
         Valeur:= '    function Get_by_Cle('
     else
         Valeur:= Valeur + '; ';

     Valeur:= Valeur+cm.sPascal_DeclarationParametre;
end;

procedure TjpPascal_Get_by_Cle_Declaration.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur+'): Tbl'+cc.Nom_de_la_classe+';';
end;

initialization
              jpPascal_Get_by_Cle_Declaration:= TjpPascal_Get_by_Cle_Declaration.Create;
finalization
              FreeAndNil( jpPascal_Get_by_Cle_Declaration);
end.
