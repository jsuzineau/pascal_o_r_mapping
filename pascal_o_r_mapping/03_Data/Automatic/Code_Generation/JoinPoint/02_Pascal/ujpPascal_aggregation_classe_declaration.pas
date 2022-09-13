unit ujpPascal_aggregation_classe_declaration;
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

 { TjpPascal_aggregation_classe_declaration }

 TjpPascal_aggregation_classe_declaration
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
   jpPascal_aggregation_classe_declaration: TjpPascal_aggregation_classe_declaration;

implementation

{ TjpPascal_aggregation_classe_declaration }

constructor TjpPascal_aggregation_classe_declaration.Create;
begin
     Cle:= '//pattern_aggregation_classe_declaration';
end;

procedure TjpPascal_aggregation_classe_declaration.Initialise(_cc: TContexteClasse);
begin
     inherited;
end;

procedure TjpPascal_aggregation_classe_declaration.VisiteMembre(_cm: TContexteMembre);
begin
     inherited;
end;

procedure TjpPascal_aggregation_classe_declaration.VisiteDetail( s_Detail, sNomTableMembre: String);
begin
     inherited VisiteDetail(s_Detail, sNomTableMembre);
end;

procedure TjpPascal_aggregation_classe_declaration.VisiteAggregation( s_Aggregation, sNomTableMembre: String);
var
   sDeclaration: String;
begin
     inherited VisiteAggregation(s_Aggregation, sNomTableMembre);

     sDeclaration
     :=
 '  { Tha'+cc.Nom_de_la_table+'__'+s_Aggregation+' }'    +#13#10
+'  Tha'+cc.Nom_de_la_table+'__'+s_Aggregation+''        +#13#10
+'  ='                                                   +#13#10
+'   class( ThAggregation)'                              +#13#10
+'   //Gestion du cycle de vie'                          +#13#10
+'   public'                                             +#13#10
+'     constructor Create( _Parent: TBatpro_Element;'    +#13#10
+'                         _Classe_Elements: TBatpro_Element_Class;'                +#13#10
+'                         _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;'+#13#10
+'     destructor  Destroy; override;'                                              +#13#10
+'   //Chargement de tous les détails'                  +#13#10
+'   public'                                            +#13#10
+'     procedure Charge; override;'                     +#13#10
+'   //Création d''itérateur'                           +#13#10
+'   protected'                                         +#13#10
+'     class function Classe_Iterateur: TIterateur_Class; override;'     +#13#10
+'   public'                                                             +#13#10
+'     function Iterateur: TIterateur_'+sNomTableMembre+';'              +#13#10
+'     function Iterateur_Decroissant: TIterateur_'+sNomTableMembre+';'  +#13#10
+'   end;'                                                               +#13#10
       ;

     Formate_Liste( Valeur, #13#10, sDeclaration);
end;

procedure TjpPascal_aggregation_classe_declaration.Finalise;
begin
     inherited;
end;

initialization
              jpPascal_aggregation_classe_declaration:= TjpPascal_aggregation_classe_declaration.Create;
finalization
              FreeAndNil( jpPascal_aggregation_classe_declaration);
end.
