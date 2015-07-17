unit ujpPascal_aggregations_faibles_declaration;
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
    uGenerateur_de_code_Ancetre,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
  SysUtils, Classes;

type

 { TjpPascal_aggregations_faibles_declaration }

 TjpPascal_aggregations_faibles_declaration
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
    procedure VisiteDetail( s_Detail, sNomTableMembre: String); override;
    procedure Finalise; override;
  end;

var
   jpPascal_aggregations_faibles_declaration: TjpPascal_aggregations_faibles_declaration;

implementation

{ TjpPascal_aggregations_faibles_declaration }

constructor TjpPascal_aggregations_faibles_declaration.Create;
begin
     Cle:= '//pattern_aggregations_faibles_declaration';
end;

procedure TjpPascal_aggregations_faibles_declaration.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_aggregations_faibles_declaration.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
     if not cm.CleEtrangere then exit;
     if '' <> Valeur
     then
         Valeur:= Valeur + #13#10;
     Valeur:= Valeur+'     '+cm.s_NomAggregation+': T'+cm.s_bl+';';
end;

procedure TjpPascal_aggregations_faibles_declaration.VisiteDetail( s_Detail, sNomTableMembre: String);
begin
     inherited VisiteDetail(s_Detail, sNomTableMembre);
end;

procedure TjpPascal_aggregations_faibles_declaration.Finalise;
begin
     inherited;
end;

initialization
              jpPascal_aggregations_faibles_declaration:= TjpPascal_aggregations_faibles_declaration.Create;
finalization
              FreeAndNil( jpPascal_aggregations_faibles_declaration);
end.
