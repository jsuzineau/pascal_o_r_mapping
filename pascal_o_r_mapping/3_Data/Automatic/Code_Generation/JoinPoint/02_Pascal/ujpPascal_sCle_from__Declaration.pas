unit ujpPascal_sCle_from__Declaration;
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
 TjpPascal_sCle_from__Declaration
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
   jpPascal_sCle_from__Declaration: TjpPascal_sCle_from__Declaration;

implementation

{ TjpPascal_sCle_from__Declaration }

constructor TjpPascal_sCle_from__Declaration.Create;
begin
     Cle:= '//pattern_sCle_from__Declaration';
end;

procedure TjpPascal_sCle_from__Declaration.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_sCle_from__Declaration.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;

     if not cm.Belongs_to_sCle then exit;

     if Valeur = ''
     then
         Valeur:= '    class function sCle_from_('
     else
         Valeur:= Valeur + '; ';

     Valeur:= Valeur+cm.sPascal_DeclarationParametre;
end;

procedure TjpPascal_sCle_from__Declaration.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur:= Valeur+'): String;'#13#10;
end;

initialization
              jpPascal_sCle_from__Declaration:= TjpPascal_sCle_from__Declaration.Create;
finalization
              FreeAndNil( jpPascal_sCle_from__Declaration);
end.
