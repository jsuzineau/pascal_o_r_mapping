unit ublOD_Dataset_Columns;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{$mode delphi}

interface

uses
    uClean,
    uBatpro_StringList,
    uOD_TextTableContext,
    uOD_Dataset_Columns,
    uOD_Dataset_Column,
    uVide,

    uBatpro_Element,
    uBatpro_Ligne,
    ublOD_Dataset_Column,

    ufAccueil_Erreur,
 Classes, SysUtils, DB, BufDataset;

type

 { ThaOD_Dataset_Columns__OD_Dataset_Column }
 ThaOD_Dataset_Columns__OD_Dataset_Column
 =
  class( ThAggregation)
  //Gestion du cycle de vie
  public
    constructor Create( _Parent: TBatpro_Element;
                        _Classe_Elements: TBatpro_Element_Class;
                        _pool_Ancetre_Ancetre: Tpool_Ancetre_Ancetre); override;
    destructor  Destroy; override;
  //Chargement de tous les détails
  public
    function DCa: TOD_Dataset_Column_array; virtual;
    function Composition: String; virtual;
    procedure Charge; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_OD_Dataset_Column;
    function Iterateur_Decroissant: TIterateur_OD_Dataset_Column;
  end;

 { ThaOD_Dataset_Columns__OD_Dataset_Column_Avant }
 ThaOD_Dataset_Columns__OD_Dataset_Column_Avant
 =
  class( ThaOD_Dataset_Columns__OD_Dataset_Column)
  //Chargement de tous les détails
  public
    function DCa: TOD_Dataset_Column_array; override;
    function Composition: String; override;
  end;

 { ThaOD_Dataset_Columns__OD_Dataset_Column_Apres }
 ThaOD_Dataset_Columns__OD_Dataset_Column_Apres
 =
  class( ThaOD_Dataset_Columns__OD_Dataset_Column)
  //Chargement de tous les détails
  public
    function DCa: TOD_Dataset_Column_array; override;
    function Composition: String; override;
  end;

 { TblOD_Dataset_Columns }

 TblOD_Dataset_Columns
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //OD_Dataset_Columns
  public
    Nom: String;
    D: TBufDataset;
    DCs: TOD_Dataset_Columns;
    procedure Charge( _Nom: String; _DCs: TOD_Dataset_Columns);
  //Gestion de la clé
  public
    class function sCle_from_( _Nom: String): String;
    function sCle: String; override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les OD_Dataset_Column Avant correspondants
  private
    FhaAvant: ThaOD_Dataset_Columns__OD_Dataset_Column_Avant;
    function GethaAvant: ThaOD_Dataset_Columns__OD_Dataset_Column_Avant;
  public
    property haAvant: ThaOD_Dataset_Columns__OD_Dataset_Column_Avant read GethaAvant;
  //Aggrégation vers les OD_Dataset_Column Apres correspondants
  private
    FhaApres: ThaOD_Dataset_Columns__OD_Dataset_Column_Apres;
    function GethaApres: ThaOD_Dataset_Columns__OD_Dataset_Column_Apres;
  public
    property haApres: ThaOD_Dataset_Columns__OD_Dataset_Column_Apres read GethaApres;
  end;

 TIterateur_OD_Dataset_Columns
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblOD_Dataset_Columns);
    function  not_Suivant( var _Resultat: TblOD_Dataset_Columns): Boolean;
  end;

 TslOD_Dataset_Columns
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
    function Iterateur: TIterateur_OD_Dataset_Columns;
    function Iterateur_Decroissant: TIterateur_OD_Dataset_Columns;
  end;

function blOD_Dataset_Columns_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Dataset_Columns;
function blOD_Dataset_Columns_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Dataset_Columns;

implementation

function blOD_Dataset_Columns_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Dataset_Columns;
begin
     _Classe_from_sl( Result, TblOD_Dataset_Columns, sl, Index);
end;

function blOD_Dataset_Columns_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Dataset_Columns;
begin
     _Classe_from_sl_sCle( Result, TblOD_Dataset_Columns, sl, sCle);
end;

{ ThaOD_Dataset_Columns__OD_Dataset_Column_Avant }

function ThaOD_Dataset_Columns__OD_Dataset_Column_Avant.DCa: TOD_Dataset_Column_array;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= nil;
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.FAvant;
end;

function ThaOD_Dataset_Columns__OD_Dataset_Column_Avant.Composition: String;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= '';
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.Avant_Composition;
end;


{ ThaOD_Dataset_Columns__OD_Dataset_Column_Apres }

function ThaOD_Dataset_Columns__OD_Dataset_Column_Apres.DCa: TOD_Dataset_Column_array;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= nil;
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.FAvant;
end;

function ThaOD_Dataset_Columns__OD_Dataset_Column_Apres.Composition: String;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= '';
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.Apres_Composition;
end;


{ TIterateur_OD_Dataset_Columns }

function TIterateur_OD_Dataset_Columns.not_Suivant( var _Resultat: TblOD_Dataset_Columns): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_OD_Dataset_Columns.Suivant( var _Resultat: TblOD_Dataset_Columns);
begin
     Suivant_interne( _Resultat);
end;

{ TslOD_Dataset_Columns }

constructor TslOD_Dataset_Columns.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblOD_Dataset_Columns);
end;

destructor TslOD_Dataset_Columns.Destroy;
begin
     inherited;
end;

class function TslOD_Dataset_Columns.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Dataset_Columns;
end;

function TslOD_Dataset_Columns.Iterateur: TIterateur_OD_Dataset_Columns;
begin
     Result:= TIterateur_OD_Dataset_Columns( Iterateur_interne);
end;

function TslOD_Dataset_Columns.Iterateur_Decroissant: TIterateur_OD_Dataset_Columns;
begin
     Result:= TIterateur_OD_Dataset_Columns( Iterateur_interne_Decroissant);
end;

{ ThaOD_Dataset_Columns__OD_Dataset_Column }

constructor ThaOD_Dataset_Columns__OD_Dataset_Column.Create( _Parent: TBatpro_Element;
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

destructor ThaOD_Dataset_Columns__OD_Dataset_Column.Destroy;
begin
     inherited;
end;

function ThaOD_Dataset_Columns__OD_Dataset_Column.DCa: TOD_Dataset_Column_array;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= nil;
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.FAvant;
end;

function ThaOD_Dataset_Columns__OD_Dataset_Column.Composition: String;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= '';
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.Avant_Composition;
end;

procedure ThaOD_Dataset_Columns__OD_Dataset_Column.Charge;
var
   blParent: TblOD_Dataset_Columns;
   DC: TOD_Dataset_Column;
   bl: TblOD_Dataset_Column;
begin
     Vide_StringList( sl);
     inherited Charge;
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     for DC in DCa
     do
       begin
       if not FieldName_in_Composition( DC.FieldName, Composition) then continue;

       bl:= TblOD_Dataset_Column.Create( sl, nil, nil);
       bl.Charge( DC);
       Ajoute( bl);
       end;
end;

class function ThaOD_Dataset_Columns__OD_Dataset_Column.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Dataset_Column;
end;

function ThaOD_Dataset_Columns__OD_Dataset_Column.Iterateur: TIterateur_OD_Dataset_Column;
begin
     Result:= TIterateur_OD_Dataset_Column( Iterateur_interne);
end;

function ThaOD_Dataset_Columns__OD_Dataset_Column.Iterateur_Decroissant: TIterateur_OD_Dataset_Column;
begin
     Result:= TIterateur_OD_Dataset_Column( Iterateur_interne_Decroissant);
end;

{ TblOD_Dataset_Columns }

constructor TblOD_Dataset_Columns.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _q, _pool);
     D:= TBufDataset.Create( nil);
end;

destructor TblOD_Dataset_Columns.Destroy;
begin
     Free_nil( D);
     inherited Destroy;
end;

procedure TblOD_Dataset_Columns.Charge( _Nom: String; _DCs: TOD_Dataset_Columns);
begin
     Nom:= _Nom;
     DCs:= _DCs;

     D.Name:= Nom;
     cLibelle:= Ajoute_String ( Nom, 'Nom'  );
end;

class function TblOD_Dataset_Columns.sCle_from_( _Nom: String): String;
begin
     Result:= _Nom;
end;

function TblOD_Dataset_Columns.sCle: String;
begin
     Result:= sCle_from_( Nom);
end;

procedure TblOD_Dataset_Columns.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'Avant' = Name then P.Forte( ThaOD_Dataset_Columns__OD_Dataset_Column_Avant, TblOD_Dataset_Column, nil)
     else if 'Apres' = Name then P.Forte( ThaOD_Dataset_Columns__OD_Dataset_Column_Apres, TblOD_Dataset_Column, nil)
     else                        inherited Create_Aggregation( Name, P);
end;

function  TblOD_Dataset_Columns.GethaAvant: ThaOD_Dataset_Columns__OD_Dataset_Column_Avant;
begin
     if FhaAvant = nil
     then
         FhaAvant:= Aggregations['Avant'] as ThaOD_Dataset_Columns__OD_Dataset_Column_Avant;

     Result:= FhaAvant;
end;

function  TblOD_Dataset_Columns.GethaApres: ThaOD_Dataset_Columns__OD_Dataset_Column_Apres;
begin
     if FhaApres = nil
     then
         FhaApres:= Aggregations['Apres'] as ThaOD_Dataset_Columns__OD_Dataset_Column_Apres;

     Result:= FhaApres;
end;

end.

