unit uOD_Batpro_Table;
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

interface

uses
    {$IFNDEF FPC}
    DOM,
    {$ELSE}
    DOM,
    {$ENDIF}
    uOpenDocument,
    uOD_Column,
    uOD_SurTitre,
    uOD_Merge,
    uOD_Niveau,
    uOD_TextTableContext,
    uOD_BatproTextTableContext,

  SysUtils, Classes, DB;

type
 TOD_Batpro_Table
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
    Niveaux : TOD_Niveau_array;
    OD_SurTitre : TOD_SurTitre;
    OD_Merge    : TOD_Merge;
  //Méthodes
  public
    procedure Application_Taille_Colonnes;
    procedure AddSurtitre( _Debut, _Fin: Integer; _Titre: String);
    procedure AddColumn  ( _Largeur: Integer; _Titre: String);
    function AddNiveau( _Nom_Aggregation: String): TOD_Niveau;
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
    procedure Assure_Modele( C: TOD_BatproTextTableContext);
    procedure to_Doc( C: TOD_BatproTextTableContext);
    procedure from_Doc( C: TOD_BatproTextTableContext);
  //Test du surtitre
  public
    function SurTitre_Actif: Boolean;
  //Gestion de la bordure extérieure du tableau
  public
    ForceBordure: Boolean;
    procedure Traite_Bordure( C: TOD_BatproTextTableContext);
  //Gestion des bordures de ligne
  public
    Bordure_Ligne: Boolean;
  //Gestion des colonnes
  public
   ColumnLengths: array of Integer;
   procedure Dimensionne_Colonnes( _C: TOD_BatproTextTableContext);
   procedure Ajoute_Titres       ( _C: TOD_BatproTextTableContext;
                                   var _J,
                                       _OffSet_SurTitre,
                                       _JTitre: Integer);
  //Ajout d'un saut de page par duplication du tableau
  public
    procedure NewPage( _C: TOD_BatproTextTableContext;
                       var _J,
                           _OffSet_SurTitre,
                           _JTitre: Integer);
  //Gestion de l'affichage des bordures
  public
    Bordure_fin_table: String;
    Bordures_Verticales_Colonnes: String;
    procedure Bordures_Assure( _C: TOD_BatproTextTableContext);
    procedure Bordures_Lire( _C: TOD_BatproTextTableContext);
    procedure Bordures_Ecrire( _C: TOD_BatproTextTableContext);
  end;

implementation

{ TOD_Batpro_Table }

constructor TOD_Batpro_Table.Create(_Nom: String; _Bordure_Ligne: Boolean= True);
begin
     inherited Create;
     Nom:= _Nom;
     Prefixe:= '_'+Nom+'_';
     Nom_NbColonnes:= Prefixe+'NbColonnes';
     OD_SurTitre:= TOD_SurTitre.Create;
     ForceBordure:= True;
     Bordure_Ligne:= _Bordure_Ligne;
     Pas_de_persistance:= False;
end;

destructor TOD_Batpro_Table.Destroy;
begin
     FreeAndNil( OD_SurTitre);
     inherited;
end;

procedure TOD_Batpro_Table.AddColumn( _Largeur: Integer; _Titre: String);
var
   C: TOD_Column;
begin
     C:= TOD_Column.Create( _Largeur, _Titre);

     SetLength( Columns, Length( Columns) + 1);
     Columns[High(Columns)]:= C;
end;

procedure TOD_Batpro_Table.AddSurtitre( _Debut, _Fin: Integer; _Titre: String);
begin
     OD_SurTitre.Add( _Debut, _Fin, _Titre);
end;

procedure TOD_Batpro_Table.Application_Taille_Colonnes;
begin

end;

function TOD_Batpro_Table.AddNiveau( _Nom_Aggregation: String): TOD_Niveau;
begin
     Result:= TOD_Niveau.Create( _Nom_Aggregation);

     if Length( Niveaux) > 0
     then
         Niveaux[High(Niveaux)].SousNiveau:= Result;

     SetLength( Niveaux, Length( Niveaux) + 1);
     Niveaux[High(Niveaux)]:= Result;
end;

function TOD_Batpro_Table.Prefixe_Colonne( iColonne: Integer): String;
begin
     Result:= Prefixe+'column_'+Format('%.2d', [iColonne])+'_';
end;

function TOD_Batpro_Table.Prefixe_OD_SurTitre: String;
begin
     Result:= Prefixe+'SurTitre_';
end;

function TOD_Batpro_Table.Prefixe_ForceBordure: String;
begin
     Result:= Prefixe+'ForceBordure';
end;

function TOD_Batpro_Table.Prefixe_Bordure_fin_table: String;
begin
     Result:= Prefixe+'Bordure_fin_table';
end;

function TOD_Batpro_Table.Prefixe_Bordures_Verticales_Colonnes: String;
begin
     Result:= Prefixe+'Bordures_Verticales_Colonnes';
end;

procedure TOD_Batpro_Table.Assure_Modele( C: TOD_BatproTextTableContext);
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
     for I:= Low( Niveaux) to High( Niveaux)
     do
       Niveaux[I].Assure_Modele( Prefixe, C);
     OD_SurTitre.Assure_Modele( Prefixe_OD_SurTitre, C);
     C.Assure_Parametre( Prefixe_ForceBordure, '1');
     Bordures_Assure( C);
end;

procedure TOD_Batpro_Table.to_Doc( C: TOD_BatproTextTableContext);
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
     for I:= Low( Niveaux) to High( Niveaux)
     do
       Niveaux[I].to_Doc( Prefixe, C);
     OD_SurTitre.to_Doc( Prefixe_OD_SurTitre, C);
     C.Ecrire( Prefixe_ForceBordure, '1');
     Bordures_Ecrire( C);
end;

procedure TOD_Batpro_Table.from_Doc( C: TOD_BatproTextTableContext);
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
     for I:= Low( Niveaux) to High( Niveaux)
     do
       Niveaux[I].from_Doc( Prefixe, C);
     OD_SurTitre.from_Doc( Prefixe_OD_SurTitre, C);
     ForceBordure:= C.Lire( Prefixe_ForceBordure, '1') = '1';
     Bordures_Lire( C);
end;

function TOD_Batpro_Table.SurTitre_Actif: Boolean;
begin
     Result
     :=
           Assigned( OD_SurTitre)
       and OD_SurTitre.NonVide;
end;

procedure TOD_Batpro_Table.Traite_Bordure( C: TOD_BatproTextTableContext);
begin
     //if not ForceBordure then exit;

     C.Traite_Bordure( Length( Columns), True);
end;

procedure TOD_Batpro_Table.Dimensionne_Colonnes( _C: TOD_BatproTextTableContext);
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

     _C.Dimensionne( ColumnLengths);
end;

procedure TOD_Batpro_Table.Ajoute_Titres( _C: TOD_BatproTextTableContext;
                                          var _J,
                                              _OffSet_SurTitre,
                                              _JTitre: Integer);
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
         begin
         rowSurTitre:= _C.NewHeaderRow;
         Inc( _J);
         _OffSet_SurTitre:= 1;
         end
     else
         begin
         rowSurTitre:= nil;
         _OffSet_SurTitre:= 0;
         end;

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
     _JTitre:= _J;
end;

procedure TOD_Batpro_Table.NewPage( _C: TOD_BatproTextTableContext;
                                    var _J,
                                        _OffSet_SurTitre,
                                        _JTitre: Integer);
begin
     _C.NewPage;
     _C.Dimensionne( ColumnLengths);
     Ajoute_Titres( _C, _J, _OffSet_SurTitre, _JTitre);
end;

procedure TOD_Batpro_Table.Bordures_Assure(_C: TOD_BatproTextTableContext);
begin
     _C.Assure_Parametre( Prefixe_Bordure_fin_table, '1');
     _C.Assure_Parametre( Prefixe_Bordures_Verticales_Colonnes, '1');
end;

procedure TOD_Batpro_Table.Bordures_Lire(_C: TOD_BatproTextTableContext);
begin
     Bordure_fin_table:= _C.Lire( Prefixe_Bordure_fin_table, '1');
     Bordures_Verticales_Colonnes:= _C.Lire( Prefixe_Bordures_Verticales_Colonnes, '1');
end;

procedure TOD_Batpro_Table.Bordures_Ecrire(_C: TOD_BatproTextTableContext);
begin
     _C.Ecrire( Prefixe_Bordure_fin_table, Bordure_fin_table);
     _C.Ecrire( Prefixe_Bordures_Verticales_Colonnes, Bordures_Verticales_Colonnes);
end;

end.
