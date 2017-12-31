unit uOD_Column;
{                                                                               |
    Part of package pOpenDocument_DelphiReportEngine                            |
                                                                                |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright (C) 2004-2011  Jean SUZINEAU - MARS42                             |
    Copyright (C) 2004-2011  Cabinet Gilles DOUTRE - BATPRO                     |
                                                                                |
    See pOpenDocument_DelphiReportEngine.dpk.LICENSE for full copyright notice. |
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
