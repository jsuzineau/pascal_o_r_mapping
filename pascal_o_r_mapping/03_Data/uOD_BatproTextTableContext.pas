unit uOD_BatproTextTableContext;
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
    uOOoStrings,
    uChampDefinition,
    uChamp,
    uOpenDocument,
    uOD_Merge,
    uOD_TextFieldsCreator,
    uOD_TextTableContext,

  SysUtils, Classes, DB;

type
 TOD_BatproTextTableContext
 =
  class( TOD_TextTableContext)
  //Cycle de vie
  public
    constructor Create( _D: TOpenDocument);
    destructor Destroy; override;
  //Gestion des styles
  public
    function  ComposeNomStyle_from_Field( C: TChamp): String;
    function  ComposeNomStyleColonne_from_Field( C: TChamp): String;
    function  ComposeNomStyle_from_FieldName( FieldName: String): String;
  //Gestion du titre des colonnes
  public
    function  ComposeNomTitreColonne_from_Field( C: TChamp): String;
    function  ComposeNomTitreColonne_from_FieldName( FieldName: String): String;
  //Gestion des largeurs de colonnes
  public
    function  ComposeNomLargeurColonne_from_Field( C: TChamp): String;
    function  ComposeNomLargeurColonne_from_FieldName( FieldName: String): String;
  //Initialisation d'une colonne dans le modèle
  public
    procedure Modelise_colonne( C: TChamp); overload;
  //Initialisation d'un style de champ dans le modèle
  public
    procedure Modelise_style_champ( C: TChamp); overload;
  // Création d'une table à partir d'une liste
  public
    function  ComposeOD_TextTableName: String;
  end;

implementation

{ TOD_BatproTextTableContext }

constructor TOD_BatproTextTableContext.Create( _D: TOpenDocument);
begin
     inherited;
end;

destructor TOD_BatproTextTableContext.Destroy;
begin
     inherited;
end;

function TOD_BatproTextTableContext.ComposeNomStyle_from_Field( C: TChamp): String;
begin
     Result:= '_'+Nom+'_'+C.Definition.Nom;
end;

function TOD_BatproTextTableContext.ComposeNomStyleColonne_from_Field( C: TChamp): String;
begin
     Result:= '_'+Nom+'_Titre_Colonne_'+C.Definition.Nom;
end;

function TOD_BatproTextTableContext.ComposeNomTitreColonne_from_Field( C: TChamp): String;
begin
     Result:= ComposeNomTitreColonne_from_FieldName( C.Definition.Nom);
end;

function TOD_BatproTextTableContext.ComposeNomLargeurColonne_from_Field( C: TChamp): String;
begin
     Result:= ComposeNomLargeurColonne_from_FieldName( C.Definition.Nom);
end;

function TOD_BatproTextTableContext.ComposeNomStyle_from_FieldName( FieldName: String): String;
begin
     Result:= '_'+Nom+'_'+ FieldName;
end;

function TOD_BatproTextTableContext.ComposeNomTitreColonne_from_FieldName( FieldName: String): String;
begin
     Result:= '_Titre_'+Nom+'_'+ FieldName;
end;

function TOD_BatproTextTableContext.ComposeNomLargeurColonne_from_FieldName( FieldName: String): String;
begin
     Result:= '_Largeur_'+Nom+'_'+ FieldName;
end;

procedure TOD_BatproTextTableContext.Modelise_colonne( C: TChamp);
var
   NomTitreColonne: String;
   NomLargeurColonne: String;
begin
     NomTitreColonne  := ComposeNomTitreColonne_from_Field( C);
     NomLargeurColonne:= ComposeNomLargeurColonne_from_Field( C);

     Modelise_colonne( NomTitreColonne,
                       NomLargeurColonne,
                       C.Definition.Libelle,
                       IntToStr( C.Definition.Longueur)
                       );
end;

procedure TOD_BatproTextTableContext.Modelise_style_champ( C: TChamp);
var
   NomStyle: String;
begin
     NomStyle:= ComposeNomStyle_from_Field( C);
     Modelise_style_champ( NomStyle);
end;

function TOD_BatproTextTableContext.ComposeOD_TextTableName: String;
begin
     Result:= Nom;
end;

end.
