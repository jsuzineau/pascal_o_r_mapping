unit ujpPascal_Champ_EditPAS;
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
 TjpPascal_Champ_EditPAS
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
   jpPascal_Champ_EditPAS: TjpPascal_Champ_EditPAS;

implementation

{ TjpPascal_Champ_EditPAS }

constructor TjpPascal_Champ_EditPAS.Create;
begin
     Cle:= '    {JoinPoint_Champ_EditPAS}';

end;

procedure TjpPascal_Champ_EditPAS.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_Champ_EditPAS.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     Valeur:= Valeur+'    ce'+UpperCase(_cm.sNomChamp)+': TChamp_Edit;'#13#10;
end;

procedure TjpPascal_Champ_EditPAS.Finalise;
begin
     inherited;
end;

initialization
              jpPascal_Champ_EditPAS:= TjpPascal_Champ_EditPAS.Create;
finalization
              FreeAndNil( jpPascal_Champ_EditPAS);
end.
