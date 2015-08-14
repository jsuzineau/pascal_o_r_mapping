unit ujpPascal_aggregation_Create_Aggregation_implementation;
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

 { TjpPascal_aggregation_Create_Aggregation_implementation }

 TjpPascal_aggregation_Create_Aggregation_implementation
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
   jpPascal_aggregation_Create_Aggregation_implementation: TjpPascal_aggregation_Create_Aggregation_implementation;

implementation

{ TjpPascal_aggregation_Create_Aggregation_implementation }

constructor TjpPascal_aggregation_Create_Aggregation_implementation.Create;
begin
     Cle:= '//pattern_aggregation_Create_Aggregation_implementation';
end;

procedure TjpPascal_aggregation_Create_Aggregation_implementation.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_aggregation_Create_Aggregation_implementation.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
end;

procedure TjpPascal_aggregation_Create_Aggregation_implementation.VisiteDetail( s_Detail, sNomTableMembre: String);
begin
     inherited VisiteDetail(s_Detail, sNomTableMembre);
end;

procedure TjpPascal_aggregation_Create_Aggregation_implementation.VisiteAggregation( s_Aggregation, sNomTableMembre: String);
var
   sImplementation: String;
begin
     inherited VisiteAggregation(s_Aggregation, sNomTableMembre);

     if Valeur = ''
     then
         Valeur
         :=
 'procedure Tbl'+cc.Nom_de_la_classe+'.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);'#13#10
+'begin'#13#10
+'          if '
     else
         Valeur:= Valeur + #13#10'     else if ';
     sImplementation
     :=
       ''''+s_Aggregation+''' = Name then P.Faible( Tha'+cc.Nom_de_la_table+'__'+s_Aggregation+', Tbl'+sNomTableMembre+', pool'+sNomTableMembre+')'
       ;

     Valeur:= Valeur + Utf8ToAnsi(sImplementation);
end;

procedure TjpPascal_aggregation_Create_Aggregation_implementation.Finalise;
begin
     inherited;
     if Valeur <> ''
     then
         Valeur
         :=
             Valeur
           +
 #13#10
+'     else                  inherited Create_Aggregation( Name, P);'#13#10
+'end;'#13#10
           ;
end;

initialization
              jpPascal_aggregation_Create_Aggregation_implementation:= TjpPascal_aggregation_Create_Aggregation_implementation.Create;
finalization
              FreeAndNil( jpPascal_aggregation_Create_Aggregation_implementation);
end.
