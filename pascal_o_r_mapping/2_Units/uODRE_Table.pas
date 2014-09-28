unit uODRE_Table;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2012,2014 Jean SUZINEAU - MARS42                                  |
    Copyright 2012,2014 Cabinet Gilles DOUTRE - BATPRO                          |
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
    uOpenDocument,
    uOD_JCL,
    uOD_Column,
    uOD_SurTitre,
    uOD_Merge,
    uOD_Dataset_Columns,
    uOD_TextTableContext,
    uOD_Styles,
  SysUtils, Classes, DB;

type
 TODRE_Table
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String; _Bordure_Ligne: Boolean= True);
    destructor  Destroy; override;
  //Attributs
  public
    Nom: String;
    Prefixe: String;
    Columns: array of TOD_Column;
    OD_Datasets : TOD_Dataset_Columns_array;
    OD_SurTitre : TOD_SurTitre;
    OD_Merge    : TOD_Merge;
  //Nombre de colonnes
  public
    function GetNbColonnes: Integer;
  //Méthodes
  public
    procedure Application_Taille_Colonnes;
    procedure AddColumn( _Largeur: Integer; _Titre: String);
    function AddDataset( _D: TDataset): TOD_Dataset_Columns;
    procedure SupprimerColonne( _Index: Integer);
    procedure InsererColonneApres( _Index: Integer);
    procedure DecalerChampsApresColonne( _Index: Integer);
  //Persistance dans le document OpenOffice
  private
    function Prefixe_Colonne( iColonne: Integer): String;
    function Prefixe_OD_SurTitre: String;
    function Prefixe_ForceBordure: String;
    function Prefixe_Bordure_fin_table: String;
    function Prefixe_Bordures_Verticales_Colonnes: String;
  public
    Nom_NbColonnes: String;
    Pas_de_persistance: Boolean;
    procedure Assure_Modele( C: TOD_TextTableContext);
    procedure To_Doc( C: TOD_TextTableContext);
    procedure from_Doc( C: TOD_TextTableContext);
  //Test du surtitre
  public
    function SurTitre_Actif: Boolean;
  //Gestion de la bordure extérieure du tableau
  public
    ForceBordure: Boolean;
    procedure Traite_Bordure( C: TOD_TextTableContext);
  //Gestion des bordures de ligne
  public
    Bordure_Ligne: Boolean;
  //Gestion des colonnes
  private
   procedure Dimensionne_Colonnes_interne( _C: TOD_TextTableContext);
   function Cree_Paragraphe_Tabule_interne( _C: TOD_TextTableContext;
                                            _root: TDOMNode;
                                            _Is_Header: Boolean;
                                            _OD_Styles: TOD_Styles;
                                            _NewPage: Boolean): TOD_PARAGRAPH;
  public
   ColumnLengths: array of Integer;
   procedure Dimensionne_Colonnes( _C: TOD_TextTableContext);
   procedure Ajoute_Titres       ( _C: TOD_TextTableContext);
   procedure Ajoute_Titres_sans_tableau( _C: TOD_TextTableContext);
   function Cree_Paragraphe_Tabule( _C: TOD_TextTableContext; _OD_Styles: TOD_Styles;
                                    _NewPage: Boolean= False): TOD_PARAGRAPH;
   function Cree_Paragraphe_Tabule_Entete( _C: TOD_TextTableContext): TOD_PARAGRAPH;
  //Ajout d'un saut de page par duplication du tableau
  public
    procedure NewPage( _C: TOD_TextTableContext);
  //Gestion de l'affichage des bordures
  public
    Bordure_fin_table: String;
    Bordures_Verticales_Colonnes: String;
    procedure Bordures_Assure( _C: TOD_TextTableContext);
    procedure Bordures_Lire( _C: TOD_TextTableContext);
    procedure Bordures_Ecrire( _C: TOD_TextTableContext);
  end;

implementation

{ TODRE_Table }

constructor TODRE_Table.Create( _Nom: String; _Bordure_Ligne: Boolean= True);
begin
     inherited Create;
     Nom          := _Nom;
     Bordure_Ligne:= _Bordure_Ligne;

     Prefixe:= '_'+Nom+'_';
     Nom_NbColonnes:= Prefixe+'NbColonnes';
     OD_SurTitre:= TOD_SurTitre.Create;
     ForceBordure:= True;

     Pas_de_persistance:= False;
end;

destructor TODRE_Table.Destroy;
begin
     FreeAndNil( OD_SurTitre);
     inherited;
end;

procedure TODRE_Table.AddColumn( _Largeur: Integer; _Titre: String);
var
   C: TOD_Column;
begin
     C:= TOD_Column.Create( _Largeur, _Titre);

     SetLength( Columns, Length( Columns) + 1);
     Columns[High(Columns)]:= C;
end;

procedure TODRE_Table.Application_Taille_Colonnes;
begin

end;

function TODRE_Table.AddDataset(_D: TDataset): TOD_Dataset_Columns;
begin
     Result:= TOD_Dataset_Columns.Create( _D);

     SetLength( OD_Datasets, Length( OD_Datasets) + 1);
     OD_Datasets[High(OD_Datasets)]:= Result;
end;

function TODRE_Table.Prefixe_Colonne( iColonne: Integer): String;
begin
     Result:= Prefixe+'column_'+Format('%.2d', [iColonne])+'_';
end;

function TODRE_Table.Prefixe_OD_SurTitre: String;
begin
     Result:= Prefixe+'SurTitre_';
end;

function TODRE_Table.Prefixe_ForceBordure: String;
begin
     Result:= Prefixe+'ForceBordure';
end;

function TODRE_Table.Prefixe_Bordure_fin_table: String;
begin
     Result:= Prefixe+'Bordure_fin_table';
end;

function TODRE_Table.Prefixe_Bordures_Verticales_Colonnes: String;
begin
     Result:= Prefixe+'Bordures_Verticales_Colonnes';
end;

procedure TODRE_Table.Assure_Modele( C: TOD_TextTableContext);
var
   Valeur_NbColonnes: String;
   I:Integer;
begin
     if Pas_de_persistance then exit;

     Valeur_NbColonnes:= IntToStr( Length( Columns));
     C.Assure_Parametre( Nom_NbColonnes, Valeur_NbColonnes);
     for I:= Low( Columns) to High( Columns)
     do
       Columns[I].Assure_Modele( Prefixe_Colonne( I), C);
     for I:= Low( OD_Datasets) to High( OD_Datasets)
     do
       OD_Datasets[I].Assure_Modele( Prefixe, C);
     OD_SurTitre.Assure_Modele( Prefixe_OD_SurTitre, C);
     C.Assure_Parametre( Prefixe_ForceBordure, '1');
     Bordures_Assure( C);
end;

procedure TODRE_Table.To_Doc( C: TOD_TextTableContext);
var
   Valeur_NbColonnes: String;
   I:Integer;
begin
     if Pas_de_persistance then exit;

     Valeur_NbColonnes:= IntToStr( Length( Columns));
     C.Ecrire( Nom_NbColonnes, Valeur_NbColonnes);
     for I:= Low( Columns) to High( Columns)
     do
       Columns[I].to_Doc( Prefixe_Colonne( I), C);
     for I:= Low( OD_Datasets) to High( OD_Datasets)
     do
       OD_Datasets[I].to_Doc( Prefixe, C);
     OD_SurTitre.to_Doc( Prefixe_OD_SurTitre, C);
     C.Ecrire( Prefixe_ForceBordure, '1');
     Bordures_Ecrire( C);
end;

procedure TODRE_Table.from_Doc( C: TOD_TextTableContext);
var
   Valeur_NbColonnes: String;
   NbColonnes: Integer;
   I:Integer;
begin
     if Pas_de_persistance then exit;

     Valeur_NbColonnes:= C.Lire( Nom_NbColonnes);
     if TryStrToInt( Valeur_NbColonnes, NbColonnes)
     then
         begin
         if NbColonnes < Length( Columns)
         then
             SetLength( Columns, NbColonnes)
         else
             while Length( Columns) < NbColonnes
             do
               AddColumn( 1, 'Nouveau');
         end;
     for I:= Low( Columns) to High( Columns)
     do
       Columns[I].from_Doc( Prefixe_Colonne( I), C);

     if NbColonnes > 0
     then
         begin
         I:= High( Columns);
         while    (I > Low( Columns))
               and(Columns[I].Largeur = 0)
         do
           begin
           Dec( NbColonnes);
           SetLength( Columns, NbColonnes);
           Dec( I);
           end;
         end;

     for I:= Low( OD_Datasets) to High( OD_Datasets)
     do
       OD_Datasets[I].from_Doc( Prefixe, C);
     OD_SurTitre.from_Doc( Prefixe_OD_SurTitre, C);
     ForceBordure:= C.Lire( Prefixe_ForceBordure, '1') = '1';
     Bordures_Lire( C);
end;

function TODRE_Table.SurTitre_Actif: Boolean;
begin
     Result
     :=
           Assigned( OD_SurTitre)
       and OD_SurTitre.NonVide;
end;

procedure TODRE_Table.Traite_Bordure( C: TOD_TextTableContext);
begin
     //if not ForceBordure then exit;
     C.Traite_Bordure( GetNbColonnes, Bordure_fin_table='1');
end;

function TODRE_Table.GetNbColonnes: Integer;
begin
     Result:= Length( Columns);
end;

procedure TODRE_Table.SupprimerColonne( _Index: Integer);
var
   I: Integer;
begin
     if (_Index < Low(Columns))or(High(Columns)< _Index) then exit;

     FreeAndNil( Columns[ _Index]);
     for I:= _Index+1 to High( Columns)
     do
       Columns[I-1]:= Columns[I];
     SetLength( Columns, Length(Columns)-1);
end;

procedure TODRE_Table.InsererColonneApres(_Index: Integer);
var
   I: Integer;
begin
     if (_Index < Low(Columns))or(High(Columns)< _Index) then exit;
     SetLength( Columns, Length(Columns)+1);

     for I:= High( Columns) downto _Index
     do
       Columns[I+1]:= Columns[I];

     //DecalerChampsApresColonne( _Index); désactivé pour l'instant: les dataset ne sont pas chargés
end;

procedure TODRE_Table.DecalerChampsApresColonne( _Index: Integer);
var
   I: Integer;
   od: TOD_Dataset_Columns;
begin
     if (_Index < Low(Columns))or(High(Columns)< _Index) then exit;

     for I:= Low( OD_Datasets) to High( OD_Datasets)
     do
       begin
       od:= OD_Datasets[I];
       od.InsererColonneApres( _Index);
       end;
end;

procedure TODRE_Table.Dimensionne_Colonnes_interne( _C: TOD_TextTableContext);
var
   NbColonnes: Integer;
   iColonne: Integer;
   OD_Column: TOD_Column;
begin
     NbColonnes:= Length( Columns);
     SetLength( ColumnLengths, NbColonnes);

     //Entêtes de colonnes
     for iColonne:= Low(Columns) to High( Columns)
     do
       begin
       OD_Column:= Columns[iColonne];
       ColumnLengths[iColonne]:= OD_Column.Largeur;
       end;
end;

procedure TODRE_Table.Dimensionne_Colonnes( _C: TOD_TextTableContext);
begin
     Dimensionne_Colonnes_interne( _C);
     _C.Dimensionne( ColumnLengths);
end;

function TODRE_Table.Cree_Paragraphe_Tabule_interne( _C: TOD_TextTableContext;
                                                     _root: TDOMNode;
                                                     _Is_Header: Boolean;
                                                     _OD_Styles: TOD_Styles;
                                                     _NewPage: Boolean): TOD_PARAGRAPH;
var
   iColonne: Integer;
   LargeurTotale: Integer;
   Largeur_Imprimable: double;
   Cumul: Integer;

   TabStops: TOD_TAB_STOPS;
   TabStop: TOD_TAB_STOP;
   A: TOD_Style_Alignment;
   Gauche, Droite, Centre: Integer;
   PositionTabulationCM: double;
   Offset_Droit : double;
   Offset_Gauche: double;
   function Cm_from_relatif( _d: double): double;
   begin
        Result:= _d * Largeur_Imprimable/LargeurTotale;
   end;
begin
     Dimensionne_Colonnes_interne( _C);

     LargeurTotale:= 0;
     for iColonne:= Low(Columns) to High( Columns)
     do
       Inc( LargeurTotale, ColumnLengths[iColonne]);

     Largeur_Imprimable:= _C.D.Largeur_Imprimable;

     Result:= TOD_PARAGRAPH.Create( _C, _root);
     Result.Is_Header:= _Is_Header;

     Delete_Property( Result.Style_Automatique, 'style:class');
     if _NewPage
     then
         Set_Property( Result.PARAGRAPH_PROPERTIES.e, 'fo:break-before','page');
     TabStops:= Result.PARAGRAPH_PROPERTIES.TAB_STOPS;

     if Length( Columns) = 0 then exit;

     Offset_Droit := 0.01;
     Offset_Gauche:= 0.01;

     Cumul:= ColumnLengths[Low(Columns)];
     for iColonne:= Low(Columns)+1 to High( Columns)
     do
       begin
       //Calcul des bases d'alignement en relatif
       Gauche:= Cumul;
       Inc( Cumul, ColumnLengths[iColonne]);
       Droite:= Cumul;
       Centre:= (Gauche+Droite) div 2;

       //Type d'alignement
       A:= osa_Left;
       if Assigned( _OD_Styles)
       then
           A:= _OD_Styles.Alignments[ iColonne];

       //Position de la tabulation
       case A
       of
         osa_Left  : PositionTabulationCM:= Cm_from_relatif( Gauche)+Offset_Gauche;
         osa_Center: PositionTabulationCM:= Cm_from_relatif( Centre);
         osa_Right : PositionTabulationCM:= Cm_from_relatif( Droite)-Offset_Droit;
         else        PositionTabulationCM:= Cm_from_relatif( Gauche)+Offset_Gauche;
         end;
       //Application
       TabStop:= TabStops.Cree_TAB_STOP( A);
       TabStop.SetPositionCM( PositionTabulationCM);
       end;
end;

function TODRE_Table.Cree_Paragraphe_Tabule( _C: TOD_TextTableContext; _OD_Styles: TOD_Styles;
                                                     _NewPage: Boolean= False): TOD_PARAGRAPH;
begin
     Result:= Cree_Paragraphe_Tabule_interne( _C, _C.D.Get_xmlContent_TEXT, False, _OD_Styles, _NewPage);
end;

function TODRE_Table.Cree_Paragraphe_Tabule_Entete( _C: TOD_TextTableContext): TOD_PARAGRAPH;
begin
     Result:= Cree_Paragraphe_Tabule_interne( _C, _C.D.FirstHeader, True, nil, False);
end;

procedure TODRE_Table.Ajoute_Titres( _C: TOD_TextTableContext);
var
   rowTitre, rowSurTitre: TOD_TABLE_ROW;
   iColonne: Integer;
   OD_Column: TOD_Column;
   cellTitre: TOD_TABLE_CELL;
   paragraphTitre: TOD_PARAGRAPH;
   sCellValue: String;
begin
     //Ajout éventuel ligne pour SurTitres
     if SurTitre_Actif
     then
         rowSurTitre:= _C.NewHeaderRow
     else
         rowSurTitre:= nil;

     if _C.MasquerTitreColonnes
     then
         rowTitre:= nil
     else
         rowTitre:= _C.NewHeaderRow;

     //Entêtes de colonnes
     for iColonne:= Low(Columns) to High( Columns)
     do
       begin
       OD_Column:= Columns[iColonne];
       sCellValue:= OD_Column.Titre;
       ColumnLengths[iColonne]:= OD_Column.Largeur;

       if _C.MasquerTitreColonnes then continue;

       _C.Formate_Titre( iColonne, rowTitre.Row);
       cellTitre:= rowTitre.NewCell( iColonne);
       paragraphTitre:= cellTitre.NewParagraph;
       paragraphTitre.Set_Style( 'Table Heading');
       paragraphTitre.AddText( sCellValue);
       end;
end;

procedure TODRE_Table.Ajoute_Titres_sans_tableau(_C: TOD_TextTableContext);
var
   Paragraph_SurTitres: TOD_PARAGRAPH;
   Paragraph_Titres: TOD_PARAGRAPH;

   iColonne: Integer;
   OD_Column: TOD_Column;
   sCellValue: String;
begin
     //Ajout éventuel ligne pour SurTitres
     if SurTitre_Actif
     then
         Paragraph_SurTitres:= Cree_Paragraphe_Tabule_Entete( _C)
     else
         Paragraph_SurTitres:= nil;

     if _C.MasquerTitreColonnes
     then
         Paragraph_Titres:= nil
     else
         Paragraph_Titres:= Cree_Paragraphe_Tabule_Entete( _C);

     //Entêtes de colonnes
     for iColonne:= Low(Columns) to High( Columns)
     do
       begin
       OD_Column:= Columns[iColonne];
       sCellValue:= OD_Column.Titre;
       ColumnLengths[iColonne]:= OD_Column.Largeur;

       if _C.MasquerTitreColonnes then continue;

       if iColonne > Low(Columns)
       then
           Paragraph_Titres.AddTab;

       Paragraph_Titres.AddText( sCellValue);
       end;
end;

procedure TODRE_Table.NewPage( _C: TOD_TextTableContext);
begin
     _C.NewPage;
     _C.Dimensionne( ColumnLengths);
     Ajoute_Titres( _C);
end;

procedure TODRE_Table.Bordures_Assure( _C: TOD_TextTableContext);
begin
     _C.Assure_Parametre( Prefixe_Bordure_fin_table, '1');
     _C.Assure_Parametre( Prefixe_Bordures_Verticales_Colonnes, '1');
end;

procedure TODRE_Table.Bordures_Lire( _C: TOD_TextTableContext);
begin
     Bordure_fin_table:= _C.Lire( Prefixe_Bordure_fin_table, '1');
     Bordures_Verticales_Colonnes:= _C.Lire( Prefixe_Bordures_Verticales_Colonnes, '1');
end;

procedure TODRE_Table.Bordures_Ecrire( _C: TOD_TextTableContext);
begin
     _C.Ecrire( Prefixe_Bordure_fin_table, Bordure_fin_table);
     _C.Ecrire( Prefixe_Bordures_Verticales_Colonnes, Bordures_Verticales_Colonnes);
end;

end.
