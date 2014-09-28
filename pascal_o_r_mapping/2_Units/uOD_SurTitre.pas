unit uOD_SurTitre;
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
 TOD_SurTitre
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  private
    procedure SetLength_from_Count;
  public
    Count: Integer;
    Libelle: array of String;
    Debut,
    Fin: array of Integer;
  public
    procedure  Init( _Libelle: array of String;
                     _Debut  ,
                     _Fin    : array of Integer);
  //Persistance dans le document OpenOffice
  private
     function Nom_Count  ( Prefixe: String): String;
     function Nom_Libelle( Prefixe: String; I: Integer): String;
     function Nom_Debut  ( Prefixe: String; I: Integer): String;
     function Nom_Fin    ( Prefixe: String; I: Integer): String;
  public
     procedure Assure_Modele( Prefixe: String; C: TOD_TextTableContext);
     procedure   to_Doc( Prefixe: String; C: TOD_TextTableContext);
     procedure from_Doc( Prefixe: String; C: TOD_TextTableContext);
  //Test si non vide
  public
    function NonVide: Boolean;
  //Ajout d'un surtitre
  public
    procedure Add( _Begin, _End: Integer; _Label: String);
  end;

implementation

{ TOD_SurTitre }

constructor TOD_SurTitre.Create;
begin
     Count:= 0;
     SetLength_from_Count;
end;

destructor TOD_SurTitre.Destroy;
begin
     inherited;
end;

procedure TOD_SurTitre.SetLength_from_Count;
begin
     SetLength( Libelle, Count);
     SetLength( Debut  , Count);
     SetLength( Fin    , Count);
end;

procedure TOD_SurTitre.Init( _Libelle: array of String;
                             _Debut, _Fin: array of Integer);
var
   I: Integer;
begin
     Count:= Length( _Libelle);
     SetLength_from_Count;
     for I:= Low( Libelle) to High( Libelle)
     do
       begin
       Libelle[I]:=_Libelle[I];
       Debut  [I]:=_Debut  [I];
       Fin    [I]:=_Fin    [I];
       end;
end;

procedure TOD_SurTitre.Add( _Begin, _End: Integer; _Label: String);
var
   I: Integer;
begin
     Inc( Count);
     SetLength_from_Count;
     I:= High( Libelle);
     Libelle[I]:= _Label;
     Debut  [I]:= _Begin;
     Fin    [I]:= _End  ;
end;

function TOD_SurTitre.Nom_Count( Prefixe: String): String;
begin
     Result:= Prefixe + 'Nombre';
end;

function TOD_SurTitre.Nom_Libelle( Prefixe: String; I: Integer): String;
begin
     Result:= Prefixe + Format('%.2d_', [I]) + 'Libelle';
end;

function TOD_SurTitre.Nom_Debut( Prefixe: String; I: Integer): String;
begin
     Result:= Prefixe + Format('%.2d_', [I]) + 'Debut';
end;

function TOD_SurTitre.Nom_Fin( Prefixe: String; I: Integer): String;
begin
     Result:= Prefixe + Format('%.2d_', [I]) + 'Fin';
end;

procedure TOD_SurTitre.Assure_Modele( Prefixe: String; C: TOD_TextTableContext);
var
   I: Integer;
begin
     C.Assure_Parametre( Nom_Count( Prefixe), IntToStr( Count));
     for I:= Low( Libelle) to High( Libelle)
     do
       begin
       C.Assure_Parametre( Nom_Libelle( Prefixe, I), Libelle[I]);
       C.Assure_Parametre( Nom_Debut  ( Prefixe, I), IntToStr(Debut[I]));
       C.Assure_Parametre( Nom_Fin    ( Prefixe, I), IntToStr(Fin  [I]));
       end;
end;

procedure TOD_SurTitre.to_Doc( Prefixe: String; C: TOD_TextTableContext);
var
   I: Integer;
begin
     C.Ecrire( Nom_Count( Prefixe), IntToStr( Count));
     for I:= Low( Libelle) to High( Libelle)
     do
       begin
       C.Ecrire( Nom_Libelle( Prefixe, I), Libelle[I]);
       C.Ecrire( Nom_Debut  ( Prefixe, I), IntToStr(Debut[I]));
       C.Ecrire( Nom_Fin    ( Prefixe, I), IntToStr(Fin  [I]));
       end;
end;

procedure TOD_SurTitre.from_Doc( Prefixe: String; C: TOD_TextTableContext);
var
   Valeur_Count, Valeur_Debut, Valeur_Fin: String;
   I: Integer;
begin
     Valeur_Count:= C.Lire( Nom_Count( Prefixe));
     if not TryStrToInt( Valeur_Count, Count) then exit;
     SetLength( Libelle, Count);
     SetLength( Debut  , Count);
     SetLength( Fin    , Count);
     for I:= Low( Libelle) to High( Libelle)
     do
       begin
       Libelle[I]  := C.Lire( Nom_Libelle( Prefixe, I));
       Valeur_Debut:= C.Lire( Nom_Debut  ( Prefixe, I));
       Valeur_Fin  := C.Lire( Nom_Fin    ( Prefixe, I));
       if not TryStrToInt( Valeur_Debut, Debut[ I]) then Debut[ I]:= 0;
       if not TryStrToInt( Valeur_Fin  , Fin  [ I]) then Fin  [ I]:= 0;
       end;
end;

function TOD_SurTitre.NonVide: Boolean;
begin
     Result:= Length( Libelle) > 0;
end;

end.
