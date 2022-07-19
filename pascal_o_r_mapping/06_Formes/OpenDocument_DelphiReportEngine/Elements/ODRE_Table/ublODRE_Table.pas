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
    uPublieur,
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
  //Vidage
  public
    procedure Vide; override;
  //Chargement de tous les détails
  public
    procedure Charge; override;
  //Réponse aux changements de colonnes
  public
    procedure Column_Change;
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
  //Suppression d'une colonne
  public
    procedure SupprimerColonne( _Index: Integer);
  //Insertion d'une colonne
  public
    procedure InsererColonne( _Index: Integer; _Apres: Boolean);
  //Vidage des affectations
  public
    procedure Affectation_Vide;
  //Formatage des affectations
  public
    procedure Affectation_Formate( _C: TOD_TextTableContext);
  //Chargement des affectations
  public
    procedure Affectation_Charge( _ODRE_Table_Nom: String);
  end;

 { TblODRE_Table }

 TblODRE_Table
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //ODRE_Table
  public
    C: TOD_TextTableContext;
    T: TODRE_Table;
    procedure Charge( _Nom: String; _C: TOD_TextTableContext);
    procedure To_Doc;
  //Champs
  private
    function GetNom                         : String ; procedure SetNom                         ( _Value: String );
    function GetForceBordure                : Boolean; procedure SetForceBordure                ( _Value: Boolean);
    function GetBordure_Ligne               : Boolean; procedure SetBordure_Ligne               ( _Value: Boolean);
    function GetMasquerTitreColonnes        : Boolean; procedure SetMasquerTitreColonnes        ( _Value: Boolean);
    function GetBordures_Verticales_Colonnes: Boolean; procedure SetBordures_Verticales_Colonnes( _Value: Boolean);
  public
    property Nom                         : String  read GetNom                          write SetNom                         ;
    property ForceBordure                : Boolean read GetForceBordure                 write SetForceBordure                ;
    property Bordure_Ligne               : Boolean read GetBordure_Ligne                write SetBordure_Ligne               ;
    property MasquerTitreColonnes        : Boolean read GetMasquerTitreColonnes         write SetMasquerTitreColonnes        ;
    property Bordures_Verticales_Colonnes: Boolean read GetBordures_Verticales_Colonnes write SetBordures_Verticales_Colonnes;
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
  //Méthodes
  public
    procedure SupprimerColonne( _Index: Integer; _C: TOD_TextTableContext);
    procedure InsererColonne  ( _Index: Integer; _C: TOD_TextTableContext; _Apres: Boolean);
  //Visiteurs des Fields du Document
  public
    //procedure Document_Fields_Visitor_for_ODRE_Table     ( _Name, _Value: String);
    //procedure Document_Fields_Visitor_for_Traite_Tables  ( _Name, _Value: String);//détection des datasets dans les tables
    procedure Document_Fields_Visitor_for_Traite_Datasets( _C: TOD_TextTableContext;
                                                           _SubName, _Value: String);//détection des champs dans les datasets
  //Chargement des affectations
  public
    procedure Affectation_Charge;
  end;

 TIterateur_ODRE_Table
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblODRE_Table);
    function  not_Suivant( out _Resultat: TblODRE_Table): Boolean;
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

function TIterateur_ODRE_Table.not_Suivant( out _Resultat: TblODRE_Table): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_ODRE_Table.Suivant( out _Resultat: TblODRE_Table);
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

procedure ThaODRE_Table__OD_Column.Vide;
begin
     Vide_StringList( sl);
end;

procedure ThaODRE_Table__OD_Column.Charge;
var
   blParent: TblODRE_Table;
   C: TOD_Column;
   bl: TblOD_Column;
begin
     inherited Charge;
     if Affecte_( blParent, TblODRE_Table, Parent) then exit;

     for C in blParent.T.Columns
     do
       begin
       bl:= TblOD_Column.Create( sl, nil, nil);
       bl.Charge( C);
       bl.cTitre  .OnChange.Abonne( Self, Column_Change);
       bl.cLargeur.OnChange.Abonne( Self, Column_Change);
       Ajoute( bl);
       end;
end;

procedure ThaODRE_Table__OD_Column.Column_Change;
var
   blParent: TblODRE_Table;
begin
     if Affecte_( blParent, TblODRE_Table, Parent) then exit;

     blParent.To_Doc;
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
       bl.Charge( '', DCs, blParent.To_Doc);
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
   NbColonnes: Integer;
begin
     if Affecte_( blParent, TblODRE_Table, Parent) then exit;
     if -1 <> sl.IndexOf( _Nom)                    then exit;

     bl:= TblOD_Dataset_Columns.Create( nil, nil, nil);
     DCs:= blParent.T.AddDataset( bl.D);
     bl.Charge( _Nom, DCs, blParent.To_Doc);
     DCs.from_Doc( '_'+blParent.Nom+'_', _C);
     Ajoute( bl);

     NbColonnes:= blParent.T.GetNbColonnes;
     bl.Affectation_Formate( NbColonnes, _C);
end;

procedure ThaODRE_Table__OD_Dataset_Columns.SupprimerColonne( _Index: Integer);
var
   I: TIterateur_OD_Dataset_Columns;
   bl: TblOD_Dataset_Columns;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       bl.Affectation_SupprimerColonne( _Index);
       end;
end;

procedure ThaODRE_Table__OD_Dataset_Columns.InsererColonne( _Index: Integer; _Apres: Boolean);
var
   I: TIterateur_OD_Dataset_Columns;
   bl: TblOD_Dataset_Columns;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       bl.Affectation_InsererColonne( _Index, _Apres);
       end;
end;


procedure ThaODRE_Table__OD_Dataset_Columns.Affectation_Vide;
var
   I: TIterateur_OD_Dataset_Columns;
   bl: TblOD_Dataset_Columns;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       bl.Affectation_Vide;
       end;
end;

procedure ThaODRE_Table__OD_Dataset_Columns.Affectation_Formate( _C: TOD_TextTableContext);
var
   blParent: TblODRE_Table;
   I: TIterateur_OD_Dataset_Columns;
   bl: TblOD_Dataset_Columns;
   NbColonnes: Integer;
begin
     if Affecte_( blParent, TblODRE_Table, Parent) then exit;

     NbColonnes:= blParent.T.GetNbColonnes;

     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       bl.Affectation_Formate( NbColonnes, _C);
       end;
end;

procedure ThaODRE_Table__OD_Dataset_Columns.Affectation_Charge( _ODRE_Table_Nom: String);
var
   I: TIterateur_OD_Dataset_Columns;
   bl: TblOD_Dataset_Columns;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       bl.Affectation_Charge( _ODRE_Table_Nom);
       end;
end;

{ TblODRE_Table }

constructor TblODRE_Table.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _jsdc, _pool);
end;

destructor TblODRE_Table.Destroy;
begin
     inherited Destroy;
end;

procedure TblODRE_Table.Charge( _Nom: String; _C: TOD_TextTableContext);
begin
     C:= _C;
     T:= TODRE_Table.Create( _Nom);
     T.Pas_de_persistance:= False;

     Ajoute_String ( T.Nom                         , 'Nom'                         , False).OnChange.Abonne( Self, To_Doc);
     Ajoute_Boolean( T.ForceBordure                , 'ForceBordure'                , False).OnChange.Abonne( Self, To_Doc);
     Ajoute_Boolean( T.Bordure_Ligne               , 'Bordure_Ligne'               , False).OnChange.Abonne( Self, To_Doc);
     Ajoute_Boolean( T.MasquerTitreColonnes        , 'MasquerTitreColonnes'        , False).OnChange.Abonne( Self, To_Doc);
     Ajoute_Boolean( T.Bordures_Verticales_Colonnes, 'Bordures_Verticales_Colonnes', False).OnChange.Abonne( Self, To_Doc);

     T.from_Doc( _C);
     haOD_Column.Charge;
end;

function TblODRE_Table.GetNom                         : String ; begin Result:= T.Nom                         ; end; procedure TblODRE_Table.SetNom                         (_Value: String ); begin T.Nom                         := _Value; end;
function TblODRE_Table.GetForceBordure                : Boolean; begin Result:= T.ForceBordure                ; end; procedure TblODRE_Table.SetForceBordure                (_Value: Boolean); begin T.ForceBordure                := _Value; end;
function TblODRE_Table.GetBordure_Ligne               : Boolean; begin Result:= T.Bordure_Ligne               ; end; procedure TblODRE_Table.SetBordure_Ligne               (_Value: Boolean); begin T.Bordure_Ligne               := _Value; end;
function TblODRE_Table.GetMasquerTitreColonnes        : Boolean; begin Result:= T.MasquerTitreColonnes        ; end; procedure TblODRE_Table.SetMasquerTitreColonnes        (_Value: Boolean); begin T.MasquerTitreColonnes        := _Value; end;
function TblODRE_Table.GetBordures_Verticales_Colonnes: Boolean; begin Result:= T.Bordures_Verticales_Colonnes; end; procedure TblODRE_Table.SetBordures_Verticales_Colonnes(_Value: Boolean); begin T.Bordures_Verticales_Colonnes:= _Value; end;

procedure TblODRE_Table.To_Doc;
begin
     T.To_Doc( C);
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

procedure TblODRE_Table.Document_Fields_Visitor_for_Traite_Datasets( _C: TOD_TextTableContext; _SubName, _Value: String);
var
   I: TIterateur_OD_Dataset_Columns;
   bl: TblOD_Dataset_Columns;
   Prefixe: String;
   function not_Traite_Avant: Boolean;
   const
        sAvant='Avant_';
        lAvant=Length( sAvant);
   var
      DCs: TOD_Dataset_Columns;
      NomAvant: String;
      DC: TOD_Dataset_Column;
   begin
        Result:= True;
        if 1 <> Pos( sAvant, _SubName) then exit;

        Result:= False;
        Delete( _SubName, 1, lAvant);

        DCs:= bl.DCs;

        DC:= DCs.Avant.Assure( _SubName);
        if nil = DC then exit;

        //DCs.Avant.from_Doc( Nom);
        NomAvant:= DCs.Avant.Nom_set( '_'+Nom+'_'+Prefixe);
        DC.from_Doc( NomAvant+'_', _C);
   end;
   function not_Traite_Apres: Boolean;
   const
        sApres='Apres_';
        lApres=Length( sApres);
   var
      DCs: TOD_Dataset_Columns;
      NomApres: String;
      DC: TOD_Dataset_Column;
   begin
        Result:= True;
        if 1 <> Pos( sApres, _SubName) then exit;

        Result:= False;
        Delete( _SubName, 1, lApres);

        DCs:= bl.DCs;

        DC:= DCs.Apres.Assure( _SubName);
        if nil = DC then exit;

        NomApres:= DCs.Apres.Nom_set( '_'+Nom+'_'+Prefixe);
        DC.from_Doc( NomApres+'_', _C);
   end;
begin
     I:= haOD_Dataset_Columns.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl)     then continue;

       Prefixe:= bl.Nom+'_';
       if 1 <> Pos( Prefixe, _SubName) then continue;

       Delete( _SubName, 1, Length(Prefixe));

       if   not_Traite_Avant
       then not_Traite_Apres;

       bl.haAvant.Charge;
       bl.haApres.Charge;
       end;
end;

procedure TblODRE_Table.Affectation_Charge;
begin
     haOD_Dataset_Columns.Affectation_Charge( Nom);
end;

procedure TblODRE_Table.SupprimerColonne( _Index: Integer; _C: TOD_TextTableContext);
begin
     //Décalage du contenu des colonnes vers la gauche à partir de la colonne supprimée
     haOD_Dataset_Columns.SupprimerColonne( _Index);

     //Vidage
     haOD_Column.Vide;
     haOD_Dataset_Columns.Affectation_Vide;

     //Suppression
     T.SupprimerColonne( _Index);

     //Rechargement
     haOD_Column.Charge;
     haOD_Dataset_Columns.Affectation_Formate( _C);

     //Enregistrmeent dans le xml
     T.To_Doc( _C);
end;

procedure TblODRE_Table.InsererColonne( _Index: Integer; _C: TOD_TextTableContext; _Apres: Boolean);
begin
     //Vidage
     haOD_Column.Vide;
     //haOD_Dataset_Columns.Affectation_Vide;

     //Insertion
     T.InsererColonne( _Index, _Apres);

     //Rechargement
     haOD_Column.Charge;
     haOD_Dataset_Columns.Affectation_Formate( _C);
     Affectation_Charge;

     //Décalage du contenu des colonnes vers la droite à partir de la colonne insérée
     haOD_Dataset_Columns.InsererColonne( _Index, _Apres);

     //Enregistrmeent dans le xml
     T.To_Doc( _C);
end;

end.

