unit uOD_Dataset_Column;
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
 TOD_Dataset_Column
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _FieldName: String);
    destructor Destroy; override;
  //Attributs
  public
    FieldName: String;
    Debut, Fin: Integer;
    procedure SetDebutFin( _Debut, _Fin: Integer);
    procedure Set_from_( _odc: TOD_Dataset_Column);
  //Persistance dans le document OpenOffice
  private
    function Nom_( Prefixe: String): String;
    function Nom_Debut( Prefixe: String): String;
    function Nom_Fin  ( Prefixe: String): String;
  public
    procedure Assure_Modele( Prefixe: String; C: TOD_TextTableContext);
    procedure   to_Doc( Prefixe: String; C: TOD_TextTableContext);
    procedure from_Doc( Prefixe: String; C: TOD_TextTableContext);
   //Gestion de l'insertion de colonne
  public
    procedure InsererColonneApres( _Index: Integer);
 end;

  TOD_Dataset_Column_array= array of TOD_Dataset_Column;
  POD_Dataset_Column_array= ^TOD_Dataset_Column_array;
  
implementation

{ TOD_Dataset_Column }

constructor TOD_Dataset_Column.Create( _FieldName: String);
begin
     FieldName:= _FieldName;
     Debut    := 0;
     Fin      := 0;
end;

destructor TOD_Dataset_Column.Destroy;
begin

     inherited;
end;

function TOD_Dataset_Column.Nom_(Prefixe: String): String;
begin
     Result:= Prefixe+FieldName+'_';
end;

function TOD_Dataset_Column.Nom_Debut(Prefixe: String): String;
begin
     Result:= Nom_( Prefixe) + 'Debut';
end;

function TOD_Dataset_Column.Nom_Fin(Prefixe: String): String;
begin
     Result:= Nom_( Prefixe) + 'Fin' ;
end;

procedure TOD_Dataset_Column.Assure_Modele( Prefixe: String; C: TOD_TextTableContext);
begin
     C.Assure_Parametre( Nom_Debut( Prefixe), IntToStr( Debut));
     C.Assure_Parametre( Nom_Fin  ( Prefixe), IntToStr( Fin  ));
end;

procedure TOD_Dataset_Column.to_Doc( Prefixe: String; C: TOD_TextTableContext);
begin
     C.Ecrire( Nom_Debut( Prefixe), IntToStr( Debut));
     C.Ecrire( Nom_Fin  ( Prefixe), IntToStr( Fin  ));
end;

procedure TOD_Dataset_Column.from_Doc( Prefixe: String; C: TOD_TextTableContext);
var
   Valeur_Debut: String;
   Valeur_Fin  : String;
begin
     Valeur_Debut:= C.Lire(Nom_Debut(Prefixe)); TryStrToInt(Valeur_Debut,Debut);
     Valeur_Fin  := C.Lire(Nom_Fin  (Prefixe)); TryStrToInt(Valeur_Fin  ,Fin  );
end;

procedure TOD_Dataset_Column.SetDebutFin( _Debut, _Fin: Integer);
begin
     Debut:= _Debut;
     Fin  := _Fin  ;
end;

procedure TOD_Dataset_Column.Set_from_(_odc: TOD_Dataset_Column);
begin
     if _odc = nil then exit;

     Debut:= _odc.Debut;
     Fin  := _odc.Fin  ;
end;

procedure TOD_Dataset_Column.InsererColonneApres( _Index: Integer);
begin
     if Debut > _Index then Inc(Debut);
     if Fin   > _Index then Inc(Fin  );
end;

end.
