unit ublODRE_Table;
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
    uVide,
    uBatpro_StringList,
    ufAccueil_Erreur,
    uOD_TextTableContext,
    uODRE_Table,
    uOD_Column,
    uOD_Dataset_Columns,
    uOD_Dataset_Column,

    uBatpro_Element,
    uBatpro_Ligne,
    ublOD_Column,
    ublOD_Dataset_Columns,
    ublOD_Dataset_Column,

 Classes, SysUtils, DB;

type

 { ThaODRE_Table__OD_Column }
 ThaODRE_Table__OD_Column
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
    procedure Charge; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_OD_Column;
    function Iterateur_Decroissant: TIterateur_OD_Column;
  end;

 { ThaODRE_Table__OD_Dataset_Columns }
 ThaODRE_Table__OD_Dataset_Columns
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
    procedure Charge; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_OD_Dataset_Columns;
    function Iterateur_Decroissant: TIterateur_OD_Dataset_Columns;
  //Ajout d'un dataset
  public
    procedure AddDataset( _Nom: String; _C: TOD_TextTableContext);
  end;

 { TblODRE_Table }

 TblODRE_Table
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //ODRE_Table
  public
    T: TODRE_Table;
    procedure Charge( _Nom: String; _C: TOD_TextTableContext);
  //Champs
  public
    property Nom: String read T.Nom write T.Nom;
  //Gestion de la clé
  public
    class function sCle_from_( _Nom: String): String;
    function sCle: String; override;
  //Aggrégations
  protected
    procedure Create_Aggregation( Name: String; P: ThAggregation_Create_Params); override;
  //Aggrégation vers les OD_Column correspondants
  private
    FhaOD_Column: ThaODRE_Table__OD_Column;
    function GethaOD_Column: ThaODRE_Table__OD_Column;
  public
    property haOD_Column: ThaODRE_Table__OD_Column read GethaOD_Column;
  //Aggrégation vers les OD_Dataset_Columns correspondants
  private
    FhaOD_Dataset_Columns: ThaODRE_Table__OD_Dataset_Columns;
    function GethaOD_Dataset_Columns: ThaODRE_Table__OD_Dataset_Columns;
  public
    property haOD_Dataset_Columns: ThaODRE_Table__OD_Dataset_Columns read GethaOD_Dataset_Columns;
  end;

 TIterateur_ODRE_Table
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblODRE_Table);
    function  not_Suivant( var _Resultat: TblODRE_Table): Boolean;
  end;

 TslODRE_Table
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
    function Iterateur: TIterateur_ODRE_Table;
    function Iterateur_Decroissant: TIterateur_ODRE_Table;
  end;

function blODRE_Table_from_sl( sl: TBatpro_StringList; Index: Integer): TblODRE_Table;
function blODRE_Table_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblODRE_Table;

implementation

function blODRE_Table_from_sl( sl: TBatpro_StringList; Index: Integer): TblODRE_Table;
begin
     _Classe_from_sl( Result, TblODRE_Table, sl, Index);
end;

function blODRE_Table_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblODRE_Table;
begin
     _Classe_from_sl_sCle( Result, TblODRE_Table, sl, sCle);
end;


{ TIterateur_ODRE_Table }

function TIterateur_ODRE_Table.not_Suivant( var _Resultat: TblODRE_Table): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_ODRE_Table.Suivant( var _Resultat: TblODRE_Table);
begin
     Suivant_interne( _Resultat);
end;

{ TslODRE_Table }

constructor TslODRE_Table.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblODRE_Table);
end;

destructor TslODRE_Table.Destroy;
begin
     inherited;
end;

class function TslODRE_Table.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_ODRE_Table;
end;

function TslODRE_Table.Iterateur: TIterateur_ODRE_Table;
begin
     Result:= TIterateur_ODRE_Table( Iterateur_interne);
end;

function TslODRE_Table.Iterateur_Decroissant: TIterateur_ODRE_Table;
begin
     Result:= TIterateur_ODRE_Table( Iterateur_interne_Decroissant);
end;

{ ThaODRE_Table__OD_Column }

constructor ThaODRE_Table__OD_Column.Create( _Parent: TBatpro_Element;
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

destructor ThaODRE_Table__OD_Column.Destroy;
begin
     inherited;
end;

procedure ThaODRE_Table__OD_Column.Charge;
var
   blParent: TblODRE_Table;
   C: TOD_Column;
   bl: TblOD_Column;
begin
     Vide_StringList( sl);
     inherited Charge;
     if Affecte_( blParent, TblODRE_Table, Parent) then exit;

     for C in blParent.T.Columns
     do
       begin
       bl:= TblOD_Column.Create( sl, nil, nil);
       bl.Charge( C);
       Ajoute( bl);
       end;
end;

class function ThaODRE_Table__OD_Column.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Column;
end;

function ThaODRE_Table__OD_Column.Iterateur: TIterateur_OD_Column;
begin
     Result:= TIterateur_OD_Column( Iterateur_interne);
end;

function ThaODRE_Table__OD_Column.Iterateur_Decroissant: TIterateur_OD_Column;
begin
     Result:= TIterateur_OD_Column( Iterateur_interne_Decroissant);
end;

{ ThaODRE_Table__OD_Dataset_Columns }

constructor ThaODRE_Table__OD_Dataset_Columns.Create( _Parent: TBatpro_Element;
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

destructor ThaODRE_Table__OD_Dataset_Columns.Destroy;
begin
     inherited;
end;

procedure ThaODRE_Table__OD_Dataset_Columns.Charge;
var
   blParent: TblODRE_Table;
   DCs: TOD_Dataset_Columns;
   bl: TblOD_Dataset_Columns;
begin
     Vide_StringList( sl);
     inherited Charge;
     if Affecte_( blParent, TblODRE_Table, Parent) then exit;

     for DCs in blParent.T.OD_Datasets
     do
       begin
       bl:= TblOD_Dataset_Columns.Create( sl, nil, nil);
       bl.Charge( '', DCs);
       end;
end;

class function ThaODRE_Table__OD_Dataset_Columns.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Dataset_Columns;
end;

function ThaODRE_Table__OD_Dataset_Columns.Iterateur: TIterateur_OD_Dataset_Columns;
begin
     Result:= TIterateur_OD_Dataset_Columns( Iterateur_interne);
end;

function ThaODRE_Table__OD_Dataset_Columns.Iterateur_Decroissant: TIterateur_OD_Dataset_Columns;
begin
     Result:= TIterateur_OD_Dataset_Columns( Iterateur_interne_Decroissant);
end;

procedure ThaODRE_Table__OD_Dataset_Columns.AddDataset( _Nom: String; _C: TOD_TextTableContext);
var
   blParent: TblODRE_Table;
   bl: TblOD_Dataset_Columns;
   DCs: TOD_Dataset_Columns;
begin
     if Affecte_( blParent, TblODRE_Table, Parent) then exit;
     if -1 <> sl.IndexOf( _Nom)                    then exit;

     bl:= TblOD_Dataset_Columns.Create( sl, nil, nil);
     DCs:= blParent.T.AddDataset( bl.D);
     DCs.from_Doc( '_'+blParent.Nom+'_', _C);
     bl.Charge( _Nom, DCs);
     Ajoute( bl);
end;

{ TblODRE_Table }

constructor TblODRE_Table.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _q, _pool);
end;

destructor TblODRE_Table.Destroy;
begin
     inherited Destroy;
end;

procedure TblODRE_Table.Charge( _Nom: String; _C: TOD_TextTableContext);
begin
     T:= TODRE_Table.Create( _Nom);
     T.Pas_de_persistance:= False;


     Ajoute_String( T.Nom, 'Nom');
     T.from_Doc( _C);
     haOD_Column.Charge;
end;

class function TblODRE_Table.sCle_from_( _Nom: String): String;
begin
     Result:= _Nom;
end;

function TblODRE_Table.sCle: String;
begin
     Result:= sCle_from_( Nom);
end;

procedure TblODRE_Table.Create_Aggregation( Name: String; P: ThAggregation_Create_Params);
begin
          if 'OD_Column'          = Name then P.Forte( ThaODRE_Table__OD_Column         , TblOD_Column         , nil)
     else if 'OD_Dataset_Columns' = Name then P.Forte( ThaODRE_Table__OD_Dataset_Columns, TblOD_Dataset_Columns, nil)
     else                                     inherited Create_Aggregation( Name, P);
end;

function  TblODRE_Table.GethaOD_Column: ThaODRE_Table__OD_Column;
begin
     if FhaOD_Column = nil
     then
         FhaOD_Column:= Aggregations['OD_Column'] as ThaODRE_Table__OD_Column;

     Result:= FhaOD_Column;
end;

function  TblODRE_Table.GethaOD_Dataset_Columns: ThaODRE_Table__OD_Dataset_Columns;
begin
     if FhaOD_Dataset_Columns = nil
     then
         FhaOD_Dataset_Columns:= Aggregations['OD_Dataset_Columns'] as ThaODRE_Table__OD_Dataset_Columns;

     Result:= FhaOD_Dataset_Columns;
end;

end.

