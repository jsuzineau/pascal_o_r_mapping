unit uOD_TextTableContext;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2011,2012,2014 Jean SUZINEAU - MARS42                             |
    Copyright 2011,2012,2014 Cabinet Gilles DOUTRE - BATPRO                     |
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

interface

uses
    DOM,
    uDimensions_Image,
    uOOoStrings,
    uOD_Merge,
    uOD_TextFieldsCreator,
    uOD_JCL,
    uOD_Styles,
    uOpenDocument,
  SysUtils, Classes,
  {$IFNDEF FPC}
  Windows, Variants, Dialogs, Grids,
  {$ENDIF}
  DB;

type
 TOD_TextTableContext = class;

 TOD_TABLE_CELL
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Ajout d'un nouveau paragraphe
  public
    function NewParagraph: TOD_PARAGRAPH;
  //office:value-type
  private
    function  GetValue_Type: String;
    procedure SetValue_Type(const Value: String);
  public
    property Value_Type: String read GetValue_Type write SetValue_Type;
  //office:value="1"
  private
    function  GetValue: String;
    procedure SetValue(const Value: String);
  public
    property Value: String read GetValue write SetValue;
  //Contexte de table
  public
    Context: TOD_TextTableContext;
  //Position dans le tableau
  public
    Row, Column: Integer;
  //Nom de cellule
  public
    function CellName: String;
  //Nom de style de cellule
  public
    function StyleName: String;
  //Gestion du style
  public
    procedure AssureStyle;
  end;

 TOD_TABLE_ROW
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Ajout d'une nouvelle cellule
  public
    function NewCell( _Column: Integer): TOD_TABLE_CELL;
  //Formatage sur un nombre de colonnes données
  //avec mémorisation des TOD_TABLE_CELL et des TOD_PARAGRAPH
  public
    Cells: array of TOD_TABLE_CELL;
    Paragraphs: array of TOD_PARAGRAPH;
    procedure Formate( _Number_of_Cells: Integer);
    procedure Fusionne( _Debut, _Fin: Integer);
    procedure Supprime( _Index: Integer);
  //Contexte de table
  public
    Context: TOD_TextTableContext;
  //Numéro de ligne dans la table
  public
    Row: Integer;
  end;

 TOD_TABLE_HEADER_ROWS
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Ajout d'une nouvelle ligne
  public
    function NewRow: TOD_TABLE_ROW;
  end;

 TOD_TABLE_COLUMN
 =
  class( TOD_XML_Element)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument; _eRoot: TDOMNode); override;
  //Dimensionnement
  public
    procedure Dimensionne( _NbColonnes: Integer);
  //Création d'un style pour donner la largeur relative
  public
    procedure Style( _NomColonne: String; _Largeur: double; _Relatif: Boolean);
  //Initialisation - duplication
  public
    procedure Duplique( _odc: TOD_TABLE_COLUMN; _NomTable: String);
  end;

 { TOD_TextTableContext }

 TOD_TextTableContext
 =
  class
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument);
    destructor Destroy; override;
  //Général
  private
    OD_TextFieldsCreator: TOD_TextFieldsCreator;
  public
    Nom: String;
    Numero_NewPage: Integer;
    Bordures_Verticales_Colonnes: Boolean;
    D: TOpenDocument;

    eTABLE: TDOMNode;

    TABLE_HEADER_ROWS: TOD_TABLE_HEADER_ROWS;

    function  ComposeNomStyle_from_Field( F: TField): String;
    function  ComposeNomStyleColonne_from_Field( F: TField): String;
    procedure Init( _Nom: String; _Bordures_Verticales_Colonnes: Boolean; _MasquerTitreColonnes: Boolean);
  //Accés à la table
  public
    function Table_Existe: Boolean;
  //Création d'une table à l'endroit d'un bookmark
  public
    function Bookmark_Existe: Boolean;
    procedure Insere_table_au_bookmark;
  //Styles de base
  public
    NomStyleColonne: String;
    NomStyleMerge  : String;
    NomStyle_Contenu_tableau: String;
    procedure Cree_Styles_de_base;
  //Gestion du titre des colonnes
  public
    slTitreColonne: TStringList;
    function  ComposeNomTitreColonne_from_FieldName( FieldName: String): String;
    function  ComposeNomTitreColonne_from_Field( F: TField): String;
    procedure slTitreColonne_from_Document;

  //Gestion des largeurs de colonnes
  public
    slLargeurColonne: TStringList;
    function  ComposeNomLargeurColonne_from_FieldName( FieldName: String): String;
    function ComposeNomLargeurColonne_from_Field( F: TField): String;
    procedure slLargeurColonne_from_Document;

  //Gestion de la composition
  public
    function  ComposeNomComposition: String;

  // Raccourcis pour création et lecture de paramètres
  public
    function Assure_Parametre( Nom, ValeurInitiale: String): Boolean;
    function Lire( _Nom: String; _Default: String= ''): String;
    procedure Ecrire( _Nom: String; _Valeur: String);
  // Création d'une table à partir d'un dataset
  public
    procedure OD_TextTableName_from_Dataset( D: TDataset);
  {$IFNDEF FPC}
  // Création d'une table à partir d'un StringGrid
  public
    procedure OD_TextTableName_from_StringGrid( sg: TStringGrid);
    function  ComposeNomStyleColonne_from_StringGrid( sg: TStringGrid): String;
  {$ENDIF}
  //Initialisation d'une colonne dans le modèle
  public
    procedure Modelise_colonne( NomTitreColonne, NomLargeurColonne, Titre, Largeur: String); overload;
    procedure Modelise_colonne( F: TField); overload;
  //Initialisation d'un style de champ dans le modèle
  public
    procedure Modelise_style_champ( NomStyle: String); overload;
    procedure Modelise_style_champ( F: TField); overload;
  //Changer le style parent d'un style donné
  public
    procedure Change_style_parent( NomStyle, NomStyleParent: String);
  //Insertion éventuelle de la table dans le document
  public
    procedure Insere_table( Nouveau_Modele: Boolean);
  //Masquer le titre des colonnes
  public
    MasquerTitreColonnes: Boolean;
  //Bordure extérieure du tableau
  public
    procedure Formate_Titre  ( _X, _Y: Integer);
    procedure Formate_Cellule( _X, _Y: Integer;
                               _Top   : Boolean= False;
                               _Bottom: Boolean= False);
    procedure Bordure_Bottom( _X, _Y: Integer);
    procedure Traite_Bordure( _NbColonnes: Integer;
                              _Bordure_fin_table: Boolean);
  //Recherche de la table dans le XML
  public
    function  Is_Table( _e: TDOMNode): boolean;
    function  Cherche_table: TDOMNode;
  //Nombre de lignes
  public
    RowCount: Integer;
  //Ajout d'une nouvelle ligne
  public
    function NewRow: TOD_TABLE_ROW;
  //Ajout d'une nouvelle ligne d'entête
  public
    function NewHeaderRow: TOD_TABLE_ROW;
  //Ajout d'un saut de page
  public
    function New_Soft_page_break: TOD_SOFT_PAGE_BREAK;
  //Ajout d'un saut de page par duplication du tableau
  public
    procedure NewPage;
  //Effacement de toutes les lignes
  public
    procedure Efface;
  //Ajout d'un entête pour le nombre de colonnes
  public
    ODCs: array of TOD_TABLE_COLUMN;
    procedure Dimensionne( _ColumnLengths: array of Integer);
  end;


implementation

{ TOD_TABLE_CELL }

constructor TOD_TABLE_CELL.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'table:table-cell');
     D.Apply_Cell_Style( e);
     Value_Type:= 'string';
     Context:= nil;
end;

function TOD_TABLE_CELL.NewParagraph: TOD_PARAGRAPH;
begin
     Result:= TOD_PARAGRAPH.Create( D, e);
end;

function TOD_TABLE_CELL.GetValue_Type: String;
begin
     if D.not_Get_Property( e, 'office:value-type', Result)
     then
         Result:= '';
end;

procedure TOD_TABLE_CELL.SetValue_Type(const Value: String);
begin
     if Value = ''
     then
         D.Delete_Property( e, 'office:value-type')
     else
         D.Set_Property( e, 'office:value-type', Value);
end;

function TOD_TABLE_CELL.GetValue: String;
begin
     if D.not_Get_Property( e, 'office:value', Result)
     then
         Result:= '';
end;

procedure TOD_TABLE_CELL.SetValue(const Value: String);
begin
     if Value = ''
     then
         D.Delete_Property( e, 'office:value')
     else
         D.Set_Property( e, 'office:value', Value);
end;

function TOD_TABLE_CELL.CellName: String;
begin
     Result:= CellName_from_XY( Column, Row);
end;

function TOD_TABLE_CELL.StyleName: String;
begin
     Result:= '';
     if Context = nil then exit;
     Result:= Context.Nom+'.'+CellName;
end;

procedure TOD_TABLE_CELL.AssureStyle;
begin
     D.Set_Property( e, 'table:style-name', StyleName);

     if Context = nil then exit;
     D.Ensure_automatic_style_table_cell_properties( Context.Nom, Column, Row);
end;

{ TOD_TABLE_ROW }

constructor TOD_TABLE_ROW.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'table:table-row');
     Context:= nil;
end;

function TOD_TABLE_ROW.NewCell( _Column: Integer): TOD_TABLE_CELL;
begin
     Result:= TOD_TABLE_CELL.Create( D, e);
     Result.Context:= Context;
     Result.Row   := Row;
     Result.Column:= _Column;
     Result.AssureStyle;
end;

procedure TOD_TABLE_ROW.Formate( _Number_of_Cells: Integer);
var
   I: Integer;
   C: TOD_TABLE_CELL;
   P: TOD_PARAGRAPH;
begin
     RemoveChilds(e);

     SetLength( Cells, _Number_of_Cells);
     SetLength( Paragraphs, _Number_of_Cells);
     for I:= Low( Cells) to High( Cells)
     do
       begin
       C:= NewCell( I);
       P:= C.NewParagraph;
       Cells     [ I]:= C;
       Paragraphs[ I]:= P;
       if Assigned( Context)
       then
           Context.Formate_Cellule( I, Row);//pour lignes verticales
       end;
end;

procedure TOD_TABLE_ROW.Fusionne( _Debut, _Fin: Integer);
var
   I: Integer;
   C: TOD_TABLE_CELL;
   P: TOD_PARAGRAPH;
begin
     if _Debut = _Fin then exit;
     if _Debut > _Fin then exit;
     if Length( Cells) = 0 then exit;

     if _Debut < Low (Cells) then _Debut:= Low (Cells);
     if _Fin   > High(Cells) then _Fin  := High(Cells);
     C:= Cells     [ _Debut];
     P:= Paragraphs[ _Debut];
     for I:= _Debut+1 to _Fin
     do
       begin
       Supprime( I);
       Cells     [ I]:= C;
       Paragraphs[ I]:= P;
       end;
     C.Set_Property( 'table:number-columns-spanned', IntToStr( _Fin-_Debut+1));
end;

procedure TOD_TABLE_ROW.Supprime(_Index: Integer);
var
   C: TOD_TABLE_CELL;
begin
     C:= Cells[ _Index];
     FreeAndNil( C.e);
end;

{ TOD_TABLE_HEADER_ROWS }

constructor TOD_TABLE_HEADER_ROWS.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= D.Ensure_Item( eRoot, 'table:table-header-rows', [],[]);
end;

function TOD_TABLE_HEADER_ROWS.NewRow: TOD_TABLE_ROW;
begin
     Result:= TOD_TABLE_ROW.Create( D, e);
end;

{ TOD_TABLE_COLUMN }

constructor TOD_TABLE_COLUMN.Create( _D: TOpenDocument; _eRoot: TDOMNode);
begin
     inherited;
     e:= Cree_path( eRoot, 'table:table-column');
end;

procedure TOD_TABLE_COLUMN.Dimensionne( _NbColonnes: Integer);
begin
     D.Set_Property( e, 'table:number-columns-repeated', IntToStr( _NbColonnes));
end;

procedure TOD_TABLE_COLUMN.Duplique( _odc: TOD_TABLE_COLUMN; _NomTable: String);
var
   Previous_NomColonne, New_NomColonne: String;
begin
     if D.not_Get_Property( _odc.e, 'table:style-name', Previous_NomColonne) then exit;

     New_NomColonne:= Previous_NomColonne;
     StrToK( '.', New_NomColonne);
     New_NomColonne:= _NomTable+'.'+New_NomColonne;

     D.Duplique_Style_Colonne( Previous_NomColonne, New_NomColonne);

     D.Set_Property( e, 'table:style-name', New_NomColonne);
end;

procedure TOD_TABLE_COLUMN.Style( _NomColonne: String; _Largeur: double; _Relatif: Boolean);
begin
     D.Set_Property( e, 'table:style-name', _NomColonne);
     D.Add_style_table_column( _NomColonne, _Largeur, _Relatif);
end;

{ TOD_TextTableContext }

constructor TOD_TextTableContext.Create( _D: TOpenDocument);
begin
     slTitreColonne  := TStringList.Create;
     slLargeurColonne:= TStringList.Create;
     D:= _D;
     OD_TextFieldsCreator:= TOD_TextFieldsCreator.Create( D);
     RowCount:= 0;
     SetLength( ODCs, 0);
end;

destructor TOD_TextTableContext.Destroy;
begin
     FreeAndNil( OD_TextFieldsCreator);
     FreeAndNil( slLargeurColonne);
     FreeAndNil( slTitreColonne  );
     inherited;
end;

procedure TOD_TextTableContext.Init( _Nom: String;
                                     _Bordures_Verticales_Colonnes: Boolean;
                                     _MasquerTitreColonnes: Boolean);
begin
     Nom:= _Nom;
     Bordures_Verticales_Colonnes:= _Bordures_Verticales_Colonnes;
     MasquerTitreColonnes:= _MasquerTitreColonnes;
     Numero_NewPage:= 0;
     NomStyleColonne:= '_'+Nom+'_Style_Colonne';
     NomStyleMerge  := '_'+Nom+'_Style_Merge';
     NomStyle_Contenu_tableau:= 'Table Contents';
     if D.is_Calc
     then
         begin
         eTABLE:= nil;
         TABLE_HEADER_ROWS:= nil;
         end
     else
         begin
         eTABLE:= Cherche_table;
         TABLE_HEADER_ROWS:= nil;
         end;
end;

procedure TOD_TextTableContext.OD_TextTableName_from_Dataset( D: TDataset);
var
   D_Owner: TComponent;
begin
     if Nom = ''
     then
         begin
         Nom:= D.Name;
         D_Owner:= D.Owner;
         if Assigned( D_Owner)
         then
             Nom:= D_Owner.Name+'_'+Nom;
         end;
end;

{$IFNDEF FPC}
procedure TOD_TextTableContext.OD_TextTableName_from_StringGrid( sg: TStringGrid);
var
   sg_Owner: TComponent;
begin
     if Nom = ''
     then
         begin
         Nom:= sg.Name;
         sg_Owner:= sg.Owner;
         if Assigned( sg_Owner)
         then
             Nom:= sg_Owner.Name+'_'+Nom;
         end;
end;
{$ENDIF}

function TOD_TextTableContext.ComposeNomStyle_from_Field( F: TField): String;
begin
     Result:= '_'+Nom+'_'+F.FieldName;
end;

function TOD_TextTableContext.ComposeNomStyleColonne_from_Field( F: TField): String;
begin
     Result:= '_'+Nom+'_Titre_Colonne_'+F.FieldName;
end;

function TOD_TextTableContext.ComposeNomTitreColonne_from_FieldName( FieldName: String): String;
begin
     Result:= '_Titre_'+Nom+'_'+ FieldName;
end;

function TOD_TextTableContext.ComposeNomLargeurColonne_from_FieldName( FieldName: String): String;
begin
     Result:= '_Largeur_'+Nom+'_'+ FieldName;
end;

function TOD_TextTableContext.ComposeNomTitreColonne_from_Field( F: TField): String;
begin
     Result:= ComposeNomTitreColonne_from_FieldName( F.FieldName);
end;

function TOD_TextTableContext.ComposeNomLargeurColonne_from_Field( F: TField): String;
begin
     Result:= ComposeNomLargeurColonne_from_FieldName( F.FieldName);
end;

function TOD_TextTableContext.Assure_Parametre( Nom, ValeurInitiale: String): Boolean;
begin
     Result
     :=
       OD_TextFieldsCreator.Assure_Parametre( Nom, ValeurInitiale);
end;

function TOD_TextTableContext.ComposeNomComposition: String;
begin
     Result:= '_Composition_'+Nom;
end;

procedure TOD_TextTableContext.Ecrire( _Nom: String; _Valeur: String);
begin
     D.Ecrire( _Nom, _Valeur);
end;

function TOD_TextTableContext.Lire( _Nom: String; _Default: String= ''): String;
begin
     Result:= D.Lire( _Nom, _Default);
end;

procedure TOD_TextTableContext.slLargeurColonne_from_Document;
var
   NomComposition: String;
   ValeurComposition: String;
   NomLargeurColonne: String;
   NomColonne: String;
   Largeur_Colonne: String;
begin
     NomComposition:= ComposeNomComposition;
     ValeurComposition:= Lire( NomComposition);

     //NomLargeurColonne:= ComposeNomLargeurColonne_from_Field( I);
     slLargeurColonne.Clear;
     while ValeurComposition <> sys_Vide
     do
       begin
       NomColonne:= StrToK( ',', ValeurComposition);
       NomLargeurColonne:= ComposeNomLargeurColonne_from_FieldName( NomColonne);
       Largeur_Colonne:= Lire( NomLargeurColonne);
       slLargeurColonne.Values[ NomColonne]:= Largeur_Colonne;
       end;
end;

procedure TOD_TextTableContext.slTitreColonne_from_Document;
var
   NomComposition: String;
   ValeurComposition: String;
   NomTitreColonne: String;
   NomColonne: String;
   Titre_Colonne: String;
begin
     NomComposition:= ComposeNomComposition;
     ValeurComposition:= Lire( NomComposition);

     //NomTitreColonne:= ComposeNomTitreColonne_from_Field( I);
     slTitreColonne.Clear;
     while ValeurComposition <> sys_Vide
     do
       begin
       NomColonne:= StrToK( ',', ValeurComposition);
       NomTitreColonne:= ComposeNomTitreColonne_from_FieldName( NomColonne);
       Titre_Colonne:= Lire( NomTitreColonne);
       slTitreColonne.Values[ NomColonne]:= Titre_Colonne;
       end;
end;

{$IFNDEF FPC}
function TOD_TextTableContext.ComposeNomStyleColonne_from_StringGrid( sg: TStringGrid): String;
begin
     Result:= Nom+'_Style_Colonne';
end;
{$ENDIF}

procedure TOD_TextTableContext.Cree_Styles_de_base;
begin
     D.Ensure_style_paragraph( NomStyleColonne, NomStyle_Contenu_tableau);
     D.Ensure_style_paragraph( NomStyleMerge  , NomStyleColonne         );
end;

procedure TOD_TextTableContext.Modelise_colonne( NomTitreColonne,
                                                 NomLargeurColonne,
                                                 Titre, Largeur: String);
begin
     Assure_Parametre( NomTitreColonne  , Titre  );
     Assure_Parametre( NomLargeurColonne, Largeur);
end;

procedure TOD_TextTableContext.Modelise_colonne(F: TField);
var
   NomTitreColonne: String;
   NomLargeurColonne: String;
begin
     NomTitreColonne  := ComposeNomTitreColonne_from_Field( F);
     NomLargeurColonne:= ComposeNomLargeurColonne_from_Field( F);

     Modelise_colonne( NomTitreColonne,
                       NomLargeurColonne,
                       F.DisplayLabel,
                       IntToStr( F.DisplayWidth)
                       );
end;

procedure TOD_TextTableContext.Modelise_style_champ( NomStyle: String);
begin
     D.Ensure_style_paragraph( NomStyle, NomStyleColonne);
end;

procedure TOD_TextTableContext.Modelise_style_champ( F: TField);
var
   NomStyle: String;
begin
     NomStyle:= ComposeNomStyle_from_Field( F);
     Modelise_style_champ( NomStyle);
end;

procedure TOD_TextTableContext.Change_style_parent( NomStyle, NomStyleParent: String);
begin
     D.Change_style_parent( NomStyle, NomStyleParent);
end;

procedure TOD_TextTableContext.Insere_table( Nouveau_Modele: Boolean);
var
   eTEXT : TDOMNode;
begin
     if not Nouveau_Modele then exit;

     eTEXT:= D.Get_xmlContent_TEXT;
     if eTEXT = nil then exit;

     eTABLE:= Cree_table(eTEXT, Nom);
end;

procedure TOD_TextTableContext.NewPage;
var
   eTEXT, eTABLE_PROPERTIES: TDOMNode;
   Nom_New_TABLE: String;
   New_TABLE: TOD_TABLE;

   eAvant: TDOMNode;

   procedure Calcule_Nom_New_TABLE;
   var
      S: String;
   begin
        Inc( Numero_NewPage);

        S:= Nom;
        Nom_New_TABLE
        :=
            StrTok( '_NewPage_', S)
          +'_NewPage_'+IntToStr( Numero_NewPage);
   end;
   procedure Duplique_Styles_colonnes;
   var
      I: Integer;
      Previous_odc, New_odc: TOD_TABLE_COLUMN;
   begin
        for I:= Low( ODCs) to High( ODCs)
        do
          begin
          Previous_odc:= ODCs[I];
          if Previous_odc = nil then continue;

          New_odc:= TOD_TABLE_COLUMN.Create( D, eTABLE);
          New_odc.Duplique( Previous_odc, Nom_New_TABLE);

          ODCs[I]:= New_odc;
          end;
   end;
begin
     eTEXT:= D.Get_xmlContent_TEXT;
     if eTEXT = nil then exit;

     Calcule_Nom_New_TABLE;

     New_TABLE:= TOD_TABLE.Create( D, eTEXT);
     New_TABLE.Nom:= Nom_New_TABLE;
     D.Set_Property( New_TABLE.e, 'table:style-name', Nom_New_TABLE);

     eTABLE_PROPERTIES:= D.Get_Table_Properties( Nom_New_TABLE);
     D.Set_Property( eTABLE_PROPERTIES, 'fo:break-before', 'page'   );
     D.Set_Property( eTABLE_PROPERTIES, 'table:align'    , 'margins');//mis "au cas où"
     D.Set_Property( eTABLE_PROPERTIES, 'style:width'    , '17cm'   );//mis "au cas où"

     eAvant:= eTABLE;
     //au cas où eAvant serait lui aussi dans un paragraphe.
     if eAvant.ParentNode <> eTEXT
     then
         eAvant:= eAvant.ParentNode;

     eTABLE:= New_TABLE.e;
     TABLE_HEADER_ROWS:= nil;

     eTEXT.ReplaceChild( eTABLE, eAvant);
     eTEXT.InsertBefore( eAvant, eTABLE);

     //PROVISOIRE pour test 2013/10/07
     //Duplique_Styles_colonnes;

     Nom:= Nom_New_TABLE;
end;

function TOD_TextTableContext.Table_Existe: Boolean;
begin
     Result:= not D.is_Calc;
     if not Result then exit;

     Result:= Assigned( eTABLE);
end;

function TOD_TextTableContext.Bookmark_Existe: Boolean;
begin
     Result:= not D.is_Calc;
     if not Result then exit;

     Result:= False;
     //Result:= Bookmarks.hasByName( Nom)
end;

procedure TOD_TextTableContext.Insere_table_au_bookmark;
//var
//   BookMark,
//   BookMark_Anchor,
//   BookMark_Text,
//   BookMark_Cursor: Variant;
//   tt: TUNO_TextTable;
begin
//     BookMark:= Bookmark;
//     BookMark_Anchor:= BookMark.Anchor;
//     BookMark_Text:= BookMark_Anchor.Text;
//     BookMark_Cursor:= BookMark_Text.createTextCursorByRange( BookMark_Anchor);
//     tt:= TUNO_TextTable.Create( D.Document);
//     try
//        tt.Name:= Nom;
//        tt.initialize( 2, 1);
//        BookMark_Text.insertTextContent( BookMark_Cursor, tt.ole, False);
//     finally
//            FreeAndNil( tt);
//            end;
end;

procedure TOD_TextTableContext.Formate_Titre( _X, _Y: Integer);
var
   eTABLE_CELL_PROPERTIES: TDOMNode;
   procedure Set_Property( _PropName, _PropValue: String);
   begin
        D.Set_Property( eTABLE_CELL_PROPERTIES, _PropName, _PropValue);
   end;
begin
     eTABLE_CELL_PROPERTIES
     :=
       D.Ensure_automatic_style_table_cell_properties( Nom, _X, _Y);
     if eTABLE_CELL_PROPERTIES = nil then exit;

    Set_Property( 'fo:padding','0.097cm');
    Set_Property( 'fo:border' ,'0.05pt solid #000000');
end;

procedure TOD_TextTableContext.Formate_Cellule( _X, _Y: Integer;
                                                _Top   : Boolean= False;
                                                _Bottom: Boolean= False
                                                );
const
     border_Ligne_continue= '0.05pt solid #000000';
     border_Pas_de_ligne  = 'none';
var
   eTABLE_CELL_PROPERTIES: TDOMNode;
   border_top, border_bottom: String;
   procedure Set_Property( _PropName, _PropValue: String);
   begin
        D.Set_Property( eTABLE_CELL_PROPERTIES, _PropName, _PropValue);
   end;
   function border_from( _Ligne: Boolean): String;
   begin
        if _Ligne
        then
            Result:= border_Ligne_continue
        else
            Result:= border_Pas_de_ligne;
   end;
begin
     eTABLE_CELL_PROPERTIES
     :=
       D.Ensure_automatic_style_table_cell_properties( Nom, _X, _Y);
     if eTABLE_CELL_PROPERTIES = nil then exit;

     border_top   := border_from( _Top   );
     border_bottom:= border_from( _Bottom);

     Set_Property( 'fo:padding'      ,'0.097cm'            );
     if Bordures_Verticales_Colonnes
     then
         begin
         Set_Property( 'fo:border-left'  ,border_Ligne_continue);
         Set_Property( 'fo:border-right' ,border_Ligne_continue);
         end;
     Set_Property( 'fo:border-top'   ,border_top           );
     Set_Property( 'fo:border-bottom',border_bottom        );
end;

procedure TOD_TextTableContext.Bordure_Bottom( _X, _Y: Integer);
const
     border_Ligne_continue= '0.05pt solid #000000';
var
   eTABLE_CELL_PROPERTIES: TDOMNode;
   procedure Set_Property( _PropName, _PropValue: String);
   begin
        D.Set_Property( eTABLE_CELL_PROPERTIES, _PropName, _PropValue);
   end;
begin
     eTABLE_CELL_PROPERTIES
     :=
       D.Ensure_automatic_style_table_cell_properties( Nom, _X, _Y);
     if eTABLE_CELL_PROPERTIES = nil then exit;

     Set_Property( 'fo:border-bottom',border_Ligne_continue);
end;

procedure TOD_TextTableContext.Traite_Bordure( _NbColonnes: Integer;
                                               _Bordure_fin_table: Boolean);
var
   I: Integer;
   J: Integer;
begin
     if _Bordure_fin_table
     then
         begin
         J:= RowCount -1;
         for I:= 0 to _NbColonnes - 1
         do
           Bordure_Bottom( I, J);
         end;
end;

function TOD_TextTableContext.Is_Table( _e: TDOMNode): boolean;
var
   Name: String;
begin
     Result:= False;

     if _e = nil                                    then exit;
     if 'table:table' <> _e.NodeName                then exit;
     if D.not_Get_Property( _e, 'table:name', Name) then exit;

     Result:= Name = Nom;
end;

function TOD_TextTableContext.Cherche_table: TDOMNode;
     function C( _Root: TDOMNode): TDOMNode;
     var
        I: Integer;
        e: TDOMNode;
     begin
          Result:= nil;
          for I:= 0 to _Root.ChildNodes.Count - 1
          do
            begin
            e:= _Root.ChildNodes.Item[ I];
            if Is_Table( e)
            then
                Result:= e
            else
                Result:= C( e);
            if Assigned( Result) then break;
            end;
     end;
begin
     Result:= C( D.xmlContent.DocumentElement);
end;

function TOD_TextTableContext.NewRow: TOD_TABLE_ROW;
begin
     Result:= TOD_TABLE_ROW.Create( D, eTABLE);
     Result.Row:= RowCount;
     Result.Context:= Self;
     Inc( RowCount);
end;

function TOD_TextTableContext.NewHeaderRow: TOD_TABLE_ROW;
begin
     if TABLE_HEADER_ROWS = nil
     then
         TABLE_HEADER_ROWS:= TOD_TABLE_HEADER_ROWS.Create( D, eTABLE);
     Result:= TABLE_HEADER_ROWS.NewRow;
     Result.Row:= RowCount;
     Result.Context:= Self;
     Inc( RowCount);
end;

function TOD_TextTableContext.New_Soft_page_break: TOD_SOFT_PAGE_BREAK;
begin
     Result:= TOD_SOFT_PAGE_BREAK.Create( D, eTABLE);
end;

procedure TOD_TextTableContext.Efface;
begin
     if Assigned( eTABLE)
     then
         RemoveChilds( eTABLE);

     D.Efface_Styles_Table( Nom);
end;

procedure TOD_TextTableContext.Dimensionne( _ColumnLengths: array of Integer);
var
   I, iDebut, iFin: Integer;
   tc: TOD_TABLE_COLUMN;
   iLettre: Integer;
   Lettre: String;
   NomColonne: String;
   CL: double;
   Somme_ColumnLengths: Integer;
   sLargeur_Table: String;
   Largeur_Table: double;
   Relatif: Boolean;
begin
     Efface;

     sLargeur_Table:= D.Get_Table_Width( Nom);
     Relatif:= sLargeur_Table = '';
     if Relatif
     then
         Largeur_Table:= 0//inutilisé, juste pour warning du compilateur
     else
         begin
         Largeur_Table:= double_from_StrCM( sLargeur_Table);
         Relatif:= Largeur_Table = 0;
         end;

     iDebut:= Low ( _ColumnLengths);
     iFin  := High( _ColumnLengths);

     Somme_ColumnLengths:= 0;
     for I:= iDebut to iFin
     do
       Inc( Somme_ColumnLengths, _ColumnLengths[I]);

     //Peut se produire si LibreOffice "optimise"
     //en supprimant les variables non utilisées
     if 0 = Somme_ColumnLengths then Somme_ColumnLengths:= 1;

     SetLength( ODCs, Length( _ColumnLengths));

     for I:= iDebut to iFin
     do
       begin
       iLettre:= Ord('A')+(I-iDebut);
       Lettre:= Chr( iLettre);
       NomColonne:= Nom+'.'+Lettre;

       if Relatif
       then
           //Bugs sur OpenOffice 3 / LibreOffice 3
           CL:= _ColumnLengths[I]*100 //marche un peu mieux en *100
       else
           CL:= (_ColumnLengths[I]*Largeur_Table) / (Somme_ColumnLengths);

       if eTABLE = nil then continue;

       tc:= TOD_TABLE_COLUMN.Create( D, eTABLE);
       tc.Style( NomColonne, CL, Relatif);

       ODCs[I]:= tc;
       end;
end;

end.

