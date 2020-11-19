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
    uLog,
    uuStrings,
    uPublieur,
    uBatpro_StringList,
    uOD_TextTableContext,
    uOD_Dataset_Columns,
    uOD_Dataset_Column,
    uVide,

    uBatpro_Element,
    uBatpro_Ligne,
    ubeString,
    ublOD_Dataset_Column,
    ublOD_Affectation,

    ufAccueil_Erreur,
 Classes, SysUtils, DB, BufDataset,math;

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
  //DCa
  public
    function DCs_set: TOD_Dataset_Column_set; virtual;
  //Vide
  public
     procedure Vide; override;
  // Mise_a_blanc
  public
    procedure Mise_a_blanc;
  //Chargement de tous les détails
  public
    procedure Charge; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_OD_Dataset_Column;
    function Iterateur_Decroissant: TIterateur_OD_Dataset_Column;
  //Cree pour 1 DC
  private
     function Cree( _DC: TOD_Dataset_Column): TblOD_Dataset_Column;
  // Ajoute = Cree + ajout dans composition
  public
     function Ajoute( _FieldName: String): TblOD_Dataset_Column;

  end;

 { ThaOD_Dataset_Columns__OD_Affectation }
 ThaOD_Dataset_Columns__OD_Affectation
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
    function Iterateur: TIterateur_OD_Affectation;
    function Iterateur_Decroissant: TIterateur_OD_Affectation;
  //Vide
  public
     procedure Vide; override;
  //Formatage pour un nombre de colonnes donné
  private
    function Cree: TblOD_Affectation;
    procedure NomChamp_Change;
    procedure Affectation_to_DC;
  public
    C: TOD_TextTableContext;
    haDC: ThaOD_Dataset_Columns__OD_Dataset_Column;
    procedure Formate( _Nb_Colonnes: Integer;
                       _haDC: ThaOD_Dataset_Columns__OD_Dataset_Column;
                       _C: TOD_TextTableContext);
    function _from_Colonne_Document( _Colonne: Integer): TblOD_Affectation;
    procedure Blanc;
  //Suppression d'une colonne
  public
    procedure SupprimerColonne( _Index: Integer);
  //Insertion d'une colonne
  public
    procedure InsererColonne( _Index: Integer; _Apres: Boolean);
  end;

 { ThaOD_Dataset_Columns__OD_Dataset_Column_Avant }
 ThaOD_Dataset_Columns__OD_Dataset_Column_Avant
 =
  class( ThaOD_Dataset_Columns__OD_Dataset_Column)
  //Chargement de tous les détails
  public
    function DCs_set: TOD_Dataset_Column_set; override;
  end;

 { ThaOD_Dataset_Columns__OD_Dataset_Column_Apres }
 ThaOD_Dataset_Columns__OD_Dataset_Column_Apres
 =
  class( ThaOD_Dataset_Columns__OD_Dataset_Column)
  //Chargement de tous les détails
  public
    function DCs_set: TOD_Dataset_Column_set; override;
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
    Table_To_Doc_procedure: TAbonnement_Objet_Proc;
    procedure Charge( _Nom: String; _DCs: TOD_Dataset_Columns; _Table_To_Doc_procedure: TAbonnement_Objet_Proc);
    procedure Table_To_Doc;
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
  //Aggrégation vers les OD_Affectation correspondants
  private
    FhaAvant_Affectation: ThaOD_Dataset_Columns__OD_Affectation;
    function GethaAvant_Affectation: ThaOD_Dataset_Columns__OD_Affectation;
  public
    property haAvant_Affectation: ThaOD_Dataset_Columns__OD_Affectation read GethaAvant_Affectation;
  //Aggrégation vers les OD_Affectation correspondants
  private
    FhaApres_Affectation: ThaOD_Dataset_Columns__OD_Affectation;
    function GethaApres_Affectation: ThaOD_Dataset_Columns__OD_Affectation;
  public
    property haApres_Affectation: ThaOD_Dataset_Columns__OD_Affectation read GethaApres_Affectation;
  //Suppression d'une colonne
  public
    procedure Affectation_SupprimerColonne( _Index: Integer);
  //Insertion d'une colonne
  public
    procedure Affectation_InsererColonne( _Index: Integer; _Apres: Boolean);
  //Vidage des affectations
  public
    procedure Affectation_Vide;
  //Formatage des affectations
  public
    procedure Affectation_Formate( _Nb_Colonnes: Integer;
                                   _C: TOD_TextTableContext);
  //Chargement des affectations
  private
    procedure Affectation_Charge_interne( _ODRE_Table_Nom: String;
                                  _Avant_Apres: String;
                                  _ha: ThaOD_Dataset_Columns__OD_Dataset_Column;
                                  _haAffectation: ThaOD_Dataset_Columns__OD_Affectation);
  public
    procedure Affectation_Charge_Avant( _ODRE_Table_Nom: String);
    procedure Affectation_Charge_Apres( _ODRE_Table_Nom: String);
    procedure Affectation_Charge( _ODRE_Table_Nom: String);
  //Cellules de titre avant aprés
  public
    bsAvant: TbeString;
    bsApres: TbeString;
  end;

 TIterateur_OD_Dataset_Columns
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblOD_Dataset_Columns);
    function  not_Suivant( out _Resultat: TblOD_Dataset_Columns): Boolean;
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

function ThaOD_Dataset_Columns__OD_Dataset_Column_Avant.DCs_set: TOD_Dataset_Column_set;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= nil;
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.Avant;
end;

{ ThaOD_Dataset_Columns__OD_Dataset_Column_Apres }

function ThaOD_Dataset_Columns__OD_Dataset_Column_Apres.DCs_set: TOD_Dataset_Column_set;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= nil;
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.Apres;
end;

{ TIterateur_OD_Dataset_Columns }

function TIterateur_OD_Dataset_Columns.not_Suivant( out _Resultat: TblOD_Dataset_Columns): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_OD_Dataset_Columns.Suivant( out _Resultat: TblOD_Dataset_Columns);
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

function ThaOD_Dataset_Columns__OD_Dataset_Column.DCs_set: TOD_Dataset_Column_set;
var
   blParent: TblOD_Dataset_Columns;
begin
     Result:= nil;
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     Result:= blParent.DCs.Avant;
end;

function ThaOD_Dataset_Columns__OD_Dataset_Column.Cree( _DC: TOD_Dataset_Column): TblOD_Dataset_Column;
begin
     Result:= TblOD_Dataset_Column.Create( sl, nil, nil);
     Result.Charge( _DC);
     inherited Ajoute( Result);
end;

function ThaOD_Dataset_Columns__OD_Dataset_Column.Ajoute( _FieldName: String): TblOD_Dataset_Column;
var
   DC: TOD_Dataset_Column;
begin
     Result:= nil;

     DC:= DCs_set.Column[ _FieldName];
     if nil = DC then exit;

     Result:= Cree( DC);
end;

procedure ThaOD_Dataset_Columns__OD_Dataset_Column.Charge;
var
   blParent: TblOD_Dataset_Columns;
   DC: TOD_Dataset_Column;
   bl: TblOD_Dataset_Column;
begin
     inherited Charge;
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     for DC in DCs_set.DCA
     do
       begin
       if not DCs_set.Displayed( DC.FieldName) then continue;

       bl:= Cree( DC);

       Log.PrintLn( '  '+bl.FieldName);
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

procedure ThaOD_Dataset_Columns__OD_Dataset_Column.Vide;
begin
     Vide_StringList( sl);
end;

procedure ThaOD_Dataset_Columns__OD_Dataset_Column.Mise_a_blanc;
var
   I: TIterateur_OD_Dataset_Column;
    DC: TOD_Dataset_Column;
   bl: TblOD_Dataset_Column;
begin
     DCs_set.Composition:= '';
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       bl.Debut:=100;//au pif, il faudrait mettre le numéro de colonne max + 1
       bl.Fin  :=-1;
       end;
end;


{ ThaOD_Dataset_Columns__OD_Affectation }

constructor ThaOD_Dataset_Columns__OD_Affectation.Create( _Parent: TBatpro_Element;
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

destructor ThaOD_Dataset_Columns__OD_Affectation.Destroy;
begin
     inherited;
end;

class function ThaOD_Dataset_Columns__OD_Affectation.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Affectation;
end;

function ThaOD_Dataset_Columns__OD_Affectation.Iterateur: TIterateur_OD_Affectation;
begin
     Result:= TIterateur_OD_Affectation( Iterateur_interne);
end;

function ThaOD_Dataset_Columns__OD_Affectation.Iterateur_Decroissant: TIterateur_OD_Affectation;
begin
     Result:= TIterateur_OD_Affectation( Iterateur_interne_Decroissant);
end;

procedure ThaOD_Dataset_Columns__OD_Affectation.Vide;
begin
     inherited Vide;
     Vide_StringList( sl);
end;

function ThaOD_Dataset_Columns__OD_Affectation.Cree: TblOD_Affectation;
begin
     Result:= TblOD_Affectation.Create( Self, nil, nil);
     Ajoute( Result);
end;

procedure ThaOD_Dataset_Columns__OD_Affectation.NomChamp_Change;
begin
     Affectation_to_DC;
end;

procedure ThaOD_Dataset_Columns__OD_Affectation.Affectation_to_DC;
var
   blParent: TblOD_Dataset_Columns;

   I: TIterateur_OD_Affectation;
   bl: TblOD_Affectation;
   blDC: TblOD_Dataset_Column;
begin
     if Affecte_( blParent, TblOD_Dataset_Columns, Parent) then exit;

     haDC.Mise_a_blanc;
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       blDC:= haDC.Ajoute( bl.NomChamp);
       if nil = blDC then continue;

       blDC.Debut:= ifthen( -1 = blDC.Debut, bl.Colonne, Min( bl.Colonne, blDC.Debut));
       blDC.Fin  := ifthen( -1 = blDC.Fin  , bl.Colonne, Max( bl.Colonne, blDC.Fin  ));
       end;
     //blParent.DCs.to_Doc( blParent.DCs.Prefixe_Table, C);
     blParent.Table_To_Doc;
end;

procedure ThaOD_Dataset_Columns__OD_Affectation.Formate( _Nb_Colonnes: Integer;
                                                         _haDC: ThaOD_Dataset_Columns__OD_Dataset_Column;
                                                         _C: TOD_TextTableContext);
var
   I: Integer;
   bl: TblOD_Affectation;
begin
     haDC:= _haDC;
     C:= _C;

     Vide;
     for I:= 1 to _Nb_Colonnes
     do
       begin
       bl:= Cree;
       if nil = bl then continue;

       bl.DCs_set:= haDC.DCs_set;
       bl.cNomChamp.OnChange.Abonne( Self, NomChamp_Change);

       bl.Colonne:= I-1;//premier = 0
       end;
end;

procedure ThaOD_Dataset_Columns__OD_Affectation.SupprimerColonne( _Index: Integer);
var
   I: Integer;
   bl, bl1: TblOD_Affectation;
begin
     for I:= _Index to sl.Count-2
     do
       begin
       bl := _from_Colonne_Document( I  );
       if nil = bl  then continue;

       bl1:= _from_Colonne_Document( I+1);
       if nil = bl1 then continue;

       bl.NomChamp        := bl1.NomChamp;
       bl.NomChamp_Libelle:= bl1.NomChamp_Libelle;
       bl.cNomChamp.OnChange.Publie;
       end;
end;

procedure ThaOD_Dataset_Columns__OD_Affectation.InsererColonne( _Index: Integer; _Apres: Boolean);
var
   IndexCible: Integer;
   I: Integer;
   bl, bl1: TblOD_Affectation;
begin
     if _Apres
     then
         IndexCible:= _Index+1
     else
         IndexCible:= _Index;

     for I:= sl.Count-2 downto IndexCible
     do
       begin
       bl := _from_Colonne_Document( I  );
       if nil = bl  then continue;

       bl1:= _from_Colonne_Document( I+1);
       if nil = bl1 then continue;

       bl1.NomChamp        := bl.NomChamp;
       bl1.NomChamp_Libelle:= bl.NomChamp_Libelle;
       bl1.cNomChamp.OnChange.Publie;

       bl.NomChamp        := '';
       bl.NomChamp_Libelle:= '';
       bl .cNomChamp.OnChange.Publie;
       end;
end;


function ThaOD_Dataset_Columns__OD_Affectation._from_Colonne_Document( _Colonne: Integer): TblOD_Affectation;
begin
     Result:= blOD_Affectation_from_sl( sl, _Colonne);
end;

procedure ThaOD_Dataset_Columns__OD_Affectation.Blanc;
var
   I: TIterateur_OD_Affectation;
   bl: TblOD_Affectation;
begin
     I:= Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       bl.NomChamp:= '';
       end;
end;

{ TblOD_Dataset_Columns }

constructor TblOD_Dataset_Columns.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _q, _pool);
     D:= TBufDataset.Create( nil);

     bsAvant:= TbeString.Create( nil, '', clWhite,bea_Gauche);
     bsApres:= TbeString.Create( nil, '', clWhite,bea_Gauche);
     Table_To_Doc_procedure:= nil;
end;

destructor TblOD_Dataset_Columns.Destroy;
begin
     Free_nil( bsAvant);
     Free_nil( bsApres);
     Free_nil( D);
     inherited Destroy;
end;

procedure TblOD_Dataset_Columns.Charge( _Nom: String;
                                        _DCs: TOD_Dataset_Columns;
                                        _Table_To_Doc_procedure: TAbonnement_Objet_Proc);
begin
     Nom:= _Nom;
     DCs:= _DCs;
     Table_To_Doc_procedure:= _Table_To_Doc_procedure;

     D.Name:= Nom;
     cLibelle:= Ajoute_String ( Nom, 'Nom'  );

     bsAvant.S:= Nom+' avant';
     bsApres.S:= Nom+' aprés';
end;

procedure TblOD_Dataset_Columns.Table_To_Doc;
begin
     if Assigned( Table_To_Doc_procedure) then Table_To_Doc_procedure;
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
          if 'Avant'       = Name then P.Forte( ThaOD_Dataset_Columns__OD_Dataset_Column_Avant, TblOD_Dataset_Column, nil)
     else if 'Apres'       = Name then P.Forte( ThaOD_Dataset_Columns__OD_Dataset_Column_Apres, TblOD_Dataset_Column, nil)
     else if 'Avant_Affectation' = Name then P.Forte( ThaOD_Dataset_Columns__OD_Affectation, TblOD_Affectation, nil)
     else if 'Apres_Affectation' = Name then P.Forte( ThaOD_Dataset_Columns__OD_Affectation, TblOD_Affectation, nil)
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

function  TblOD_Dataset_Columns.GethaAvant_Affectation: ThaOD_Dataset_Columns__OD_Affectation;
begin
     if FhaAvant_Affectation = nil
     then
         FhaAvant_Affectation:= Aggregations['Avant_Affectation'] as ThaOD_Dataset_Columns__OD_Affectation;

     Result:= FhaAvant_Affectation;
end;

function  TblOD_Dataset_Columns.GethaApres_Affectation: ThaOD_Dataset_Columns__OD_Affectation;
begin
     if FhaApres_Affectation = nil
     then
         FhaApres_Affectation:= Aggregations['Apres_Affectation'] as ThaOD_Dataset_Columns__OD_Affectation;

     Result:= FhaApres_Affectation;
end;

procedure TblOD_Dataset_Columns.Affectation_SupprimerColonne(_Index: Integer);
begin
     haAvant_Affectation.SupprimerColonne( _Index);
     haApres_Affectation.SupprimerColonne( _Index);
end;

procedure TblOD_Dataset_Columns.Affectation_InsererColonne( _Index: Integer; _Apres: Boolean);
begin
     haAvant_Affectation.InsererColonne( _Index, _Apres);
     haApres_Affectation.InsererColonne( _Index, _Apres);
end;

procedure TblOD_Dataset_Columns.Affectation_Vide;
begin
     haAvant_Affectation.Vide;
     haApres_Affectation.Vide;
end;

procedure TblOD_Dataset_Columns.Affectation_Formate( _Nb_Colonnes: Integer; _C: TOD_TextTableContext);
begin
     haAvant_Affectation.Formate( _Nb_Colonnes, haAvant, _C);
     haApres_Affectation.Formate( _Nb_Colonnes, haApres, _C);
end;

procedure TblOD_Dataset_Columns.Affectation_Charge_interne( _ODRE_Table_Nom: String;
                                                    _Avant_Apres: String;
                                                    _ha: ThaOD_Dataset_Columns__OD_Dataset_Column;
                                                    _haAffectation: ThaOD_Dataset_Columns__OD_Affectation);
var
   I: TIterateur_OD_Dataset_Column;
   bl: TblOD_Dataset_Column;
   blA: TblOD_Affectation;
   iCol: Integer;
begin
     _haAffectation.Blanc;

     I:= _ha.Iterateur;
     while I.Continuer
     do
       begin
       if I.not_Suivant( bl) then continue;

       for iCol:= bl.DC.Debut to bl.DC.Fin
       do
         begin
         Log.PrintLn( _ODRE_Table_Nom+' '+Nom+' '+_Avant_Apres+' '+bl.FieldName+' col:'+IntToStr( iCol));

         blA:= _haAffectation._from_Colonne_Document( iCol);
         if nil = blA then continue;

         blA.NomChamp:= bl.FieldName;
         end;
       end;
end;

procedure TblOD_Dataset_Columns.Affectation_Charge_Avant( _ODRE_Table_Nom: String);
begin
     Affectation_Charge_interne( _ODRE_Table_Nom, 'Avant', haAvant, haAvant_Affectation);
end;

procedure TblOD_Dataset_Columns.Affectation_Charge_Apres( _ODRE_Table_Nom: String);
begin
     Affectation_Charge_interne( _ODRE_Table_Nom, 'Apres', haApres, haApres_Affectation);
end;

procedure TblOD_Dataset_Columns.Affectation_Charge(_ODRE_Table_Nom: String);
begin
     Affectation_Charge_Avant( _ODRE_Table_Nom);
     Affectation_Charge_Apres( _ODRE_Table_Nom);
end;

end.

