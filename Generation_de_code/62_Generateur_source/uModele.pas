unit uModele;
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

// non instancié, sert seulement de modèle pour le générateur de code
//inclu dans Batpro_Formes pour garantir la compilation et la mise au point

interface

uses
    uBatpro_StringList,
    uBatpro_Element,
    uDataClasses,
    uhAggregation,
    upool_Ancetre_Ancetre,
    ufAccueil_Erreur,
  Grids;

type
 TElement= class end;//juste pour compilation

 TIterateur_Suffixe
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TElement);
    function  not_Suivant( var _Resultat: TElement): Boolean;
  end;

 TslSuffixe
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Suffixe;
    function Iterateur_Decroissant: TIterateur_Suffixe;
  end;

 ThaElement
 =
  class( ThAggregation)
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element;
                        _Classe_Elements: TBatpro_Element_Class;
                        _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
    destructor  Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_Suffixe;
    function Iterateur_Decroissant: TIterateur_Suffixe;
  end;

 function blSuffixe_from_sl( sl: TBatpro_StringList; Index: Integer): TElement;
 function blSuffixe_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TElement;
 function sg_blSuffixe( sg: TStringGrid; Colonne, Ligne: Integer): TElement;

implementation

function blSuffixe_from_sl( sl: TBatpro_StringList; Index: Integer): TElement;
begin
     _Classe_from_sl( Result, TElement, sl, Index);
end;

function blSuffixe_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TElement;
begin
     _Classe_from_sl_sCle( Result, TElement, sl, sCle);
end;

function sg_blSuffixe( sg: TStringGrid; Colonne, Ligne: Integer): TElement;
var
   be: TBatpro_Element;
begin
     be:= Batpro_Element_from_sg( sg, Colonne, Ligne);
     Affecte( Result, TElement, be);
end;

{ TIterateur_Suffixe }

function TIterateur_Suffixe.not_Suivant( var _Resultat: TElement): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Suffixe.Suivant( var _Resultat: TElement);
begin
     Suivant_interne( _Resultat);
end;

{ TslSuffixe }

constructor TslSuffixe.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TElement);
end;

destructor TslSuffixe.Destroy;
begin
     inherited;
end;

class function TslSuffixe.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Suffixe;
end;

function TslSuffixe.Iterateur: TIterateur_Suffixe;
begin
     Result:= TIterateur_Suffixe( Iterateur_interne);
end;

function TslSuffixe.Iterateur_Decroissant: TIterateur_Suffixe;
begin
     Result:= TIterateur_Suffixe( Iterateur_interne_Decroissant);
end;

{ ThaElement }

constructor ThaElement.Create( _Parent: TBatpro_Element;
                               _Classe_Elements: TBatpro_Element_Class;
                               _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre);
begin
     inherited;
     if Classe_Elements <> _Classe_Elements
     then
         fAccueil_Erreur(  'Erreur à signaler au développeur: '#13#10
                          +' '+ClassName+'.Create: Classe_Elements <> _Classe_Elements:'#13#10
                          +' Classe_Elements='+ Classe_Elements.ClassName+#13#10
                          +'_Classe_Elements='+_Classe_Elements.ClassName
                          );
end;

destructor ThaElement.Destroy;
begin
     inherited;
end;

class function ThaElement.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Suffixe;
end;

function ThaElement.Iterateur: TIterateur_Suffixe;
begin
     Result:= TIterateur_Suffixe( Iterateur_interne);
end;

function ThaElement.Iterateur_Decroissant: TIterateur_Suffixe;
begin
     Result:= TIterateur_Suffixe( Iterateur_interne_Decroissant);
end;

end.
