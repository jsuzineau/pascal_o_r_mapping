unit uOD_Column;
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
    SysUtils, Classes,
    uOD_TextTableContext;


type
  TOD_Column
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create( _Largeur: Integer; _Titre: String);
     destructor Destroy; override;
   //Attributs
   public
     Largeur: Integer;
     Titre: String;
  //Persistance dans le document OpenOffice
  private
     function Nom_Largeur( Prefixe: String): String;
     function Nom_Titre  ( Prefixe: String): String;
  public
     procedure Assure_Modele( Prefixe: String; C: TOD_TextTableContext);
     procedure   to_Doc( Prefixe: String; C: TOD_TextTableContext);
     procedure from_Doc( Prefixe: String; C: TOD_TextTableContext);
   end;

implementation

{ TOD_Column }

constructor TOD_Column.Create( _Largeur: Integer; _Titre: String);
begin
     Largeur:= _Largeur;
     Titre  := _Titre;
end;

destructor TOD_Column.Destroy;
begin

     inherited;
end;

function TOD_Column.Nom_Largeur( Prefixe: String): String;
begin
     Result:= Prefixe + 'Largeur';
end;

function TOD_Column.Nom_Titre( Prefixe: String): String;
begin
     Result:= Prefixe + 'Titre';
end;

procedure TOD_Column.Assure_Modele( Prefixe: String; C: TOD_TextTableContext);
begin
     C.Assure_Parametre( Nom_Titre  ( Prefixe), Titre);
     C.Assure_Parametre( Nom_Largeur( Prefixe), IntToStr( Largeur));
end;

procedure TOD_Column.to_Doc( Prefixe: String; C: TOD_TextTableContext);
begin
     C.Ecrire( Nom_Titre  ( Prefixe), Titre);
     C.Ecrire( Nom_Largeur( Prefixe), IntToStr( Largeur));
end;

procedure TOD_Column.from_Doc(Prefixe: String; C: TOD_TextTableContext);
var
   _Titre: String;
   Valeur_Largeur: String;
begin
     _Titre:= C.Lire( Nom_Titre  ( Prefixe));
     if _Titre <> ''
     then
         Titre:= _Titre;

     Valeur_Largeur:= C.Lire( Nom_Largeur( Prefixe));
     TryStrToInt( Valeur_Largeur, Largeur);
end;

end.
