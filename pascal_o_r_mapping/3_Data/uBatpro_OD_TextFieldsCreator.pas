unit uBatpro_OD_TextFieldsCreator;
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
    uClean,
    uOpenDocument,
    uChampDefinitions,
    uChampDefinition,
    uChamps,
    uChamp,

    uOD_TextFieldsCreator,

    uBatpro_Ligne,
    
  SysUtils, Classes, DB;

type
 TBatpro_OD_TextFieldsCreator
 =
  class( TOD_TextFieldsCreator)
  //cycle de vie
  public
    constructor Create( _D: TOpenDocument);
    destructor Destroy; override;
  //création de champs à partir de tous les champs d'un Batpro_Ligne
  private
    function Execute_interne( Nom: String;
                              bl: TBatpro_Ligne;
                              UtiliseValeurs, CreeTextFields: Boolean): Boolean;
                              overload;
  public
    //juste pour les tests
    function OD_FieldName_from_DisplayLabel( DisplayLabel: String): String;

    function Execute_Modele( Nom: String;
                             bl: TBatpro_Ligne; Nouveau_Modele: Boolean): Boolean;
                             overload;
    function Execute       ( Nom: String;
                             bl: TBatpro_Ligne): Boolean;
                             overload;
  end;

implementation

{ TBatpro_OD_TextFieldsCreator }

constructor TBatpro_OD_TextFieldsCreator.Create( _D: TOpenDocument);
begin
     inherited;
end;

destructor TBatpro_OD_TextFieldsCreator.Destroy;
begin
     inherited;
end;


function TBatpro_OD_TextFieldsCreator.OD_FieldName_from_DisplayLabel( DisplayLabel: String): String;
var
   I: Integer;
begin
     Result:= DisplayLabel;
     for I:= 1 to Length( Result)
     do
       if Result[I] = ' ' then Result[I]:= '_';
end;

function TBatpro_OD_TextFieldsCreator.Execute_interne( Nom: String;
                                                   bl: TBatpro_Ligne;
                                                   UtiliseValeurs,
                                                   CreeTextFields: Boolean): Boolean;
var
   NbColonnes: Integer;
   I: Integer;
   Champ: TChamp;
   Definition: TChampDefinition;
   sOD_FieldName    ,
   sOD_FieldContent : String;
begin
     Result:= Assigned( bl);
     if not Result
     then
         begin
         if UtiliseValeurs
         then
             Field_Vide_Branche( Nom+'_');
         exit;
         end;

     NbColonnes:= bl.Champs.Count;

     for I:= 0 to NbColonnes-1
     do
       begin
       Champ:= bl.Champs.Champ_from_Index(I);
       if Assigned( Champ)
       then
           begin
           Definition:= Champ.Definition;
           if Assigned( Definition)
           then
               begin
               sOD_FieldName   := Nom+'_'+OD_FieldName_from_DisplayLabel( Definition.Nom);
               if UtiliseValeurs
               then
                   sOD_FieldContent:= Champ.Chaine
               else
                   sOD_FieldContent:= sOD_FieldName;

               Traite_Field( sOD_FieldName, sOD_FieldContent, CreeTextFields);
               end;
           end;
       end;
end;

function TBatpro_OD_TextFieldsCreator.Execute_Modele ( Nom: String;
                                                   bl: TBatpro_Ligne;
                                                   Nouveau_Modele: Boolean): Boolean;
begin
     Result:= Execute_interne( Nom, bl, False, Nouveau_Modele);
end;

function TBatpro_OD_TextFieldsCreator.Execute        ( Nom: String;
                                                   bl: TBatpro_Ligne): Boolean;
begin
     Result:= Execute_interne( Nom, bl, True, False);
end;

end.

