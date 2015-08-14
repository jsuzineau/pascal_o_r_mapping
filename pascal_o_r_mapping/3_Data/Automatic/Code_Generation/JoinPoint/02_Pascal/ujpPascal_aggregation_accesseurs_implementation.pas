unit ujpPascal_aggregation_accesseurs_implementation;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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
    uuStrings,
    uContexteClasse,
    uContexteMembre,
    uJoinPoint,
  SysUtils, Classes;

type

 { TjpPascal_aggregation_accesseurs_implementation }

 TjpPascal_aggregation_accesseurs_implementation
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
    procedure VisiteAggregation( s_Aggregation, sNomTableMembre: String); override;
    procedure Finalise; override;
  end;

var
   jpPascal_aggregation_accesseurs_implementation: TjpPascal_aggregation_accesseurs_implementation;

implementation

{ TjpPascal_aggregation_accesseurs_implementation }

constructor TjpPascal_aggregation_accesseurs_implementation.Create;
begin
     Cle:= '//pattern_aggregation_accesseurs_implementation';
end;

procedure TjpPascal_aggregation_accesseurs_implementation.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_aggregation_accesseurs_implementation.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
end;

procedure TjpPascal_aggregation_accesseurs_implementation.VisiteDetail( s_Detail, sNomTableMembre: String);
begin
     inherited VisiteDetail(s_Detail, sNomTableMembre);
end;

procedure TjpPascal_aggregation_accesseurs_implementation.VisiteAggregation( s_Aggregation, sNomTableMembre: String);
var
   sImplementation: String;
begin
     inherited VisiteAggregation(s_Aggregation, sNomTableMembre);

     sImplementation
     :=
 'function  Tbl'+cc.Nom_de_la_classe+'.Getha'+s_Aggregation+': Tha'+cc.Nom_de_la_table+'__'+s_Aggregation+';'#13#10
+'begin                                                        '#13#10
+'     if Fha'+s_Aggregation+' = nil                           '#13#10
+'     then                                                    '#13#10
+'         Fha'+s_Aggregation+':= Aggregations['''+s_Aggregation+'''] as Tha'+cc.Nom_de_la_table+'__'+s_Aggregation+';'#13#10
+'                                                             '#13#10
+'     Result:= Fha'+s_Aggregation+';                          '#13#10
+'end;                                                         '#13#10
       ;

     Formate_Liste( Valeur, #13#10, Utf8ToAnsi(sImplementation));
end;

procedure TjpPascal_aggregation_accesseurs_implementation.Finalise;
begin
     inherited;
end;

initialization
              jpPascal_aggregation_accesseurs_implementation:= TjpPascal_aggregation_accesseurs_implementation.Create;
finalization
              FreeAndNil( jpPascal_aggregation_accesseurs_implementation);
end.
