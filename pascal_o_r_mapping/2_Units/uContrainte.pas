unit uContrainte;
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
    uuStrings,
    uDataUtilsU,
    uBatpro_StringList,
  SysUtils, Classes;

type
 TContrainte_Operateur
 =
  (
  co_Egal             ,
  co_Different        ,
  co_Like             ,
  co_Inferieur_ou_Egal,
  co_Superieur_ou_Egal
  );
 TContrainte_TypeOperande
 =
  (
  cto_Chaine  ,
  cto_Entier  ,
  cto_Flottant,
  cto_Date
  );
 TContrainte
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Attributs
  public
    Active: Boolean;
    NomChamp: String;
    Operateur: TContrainte_Operateur;
    TypeOperande: TContrainte_TypeOperande;
    Critere_Chaine  : String;
    Critere_Entier  : Integer;
    Critere_Flottant: double;
    Critere_Date    : TDateTime;
  //Critere
  public
    function sCritere: String;
  //Méthodes
  public
    function IsDate: Boolean;
  //Test
  public
    Valeur_Chaine  : String;
    Valeur_entier  : Integer;
    Valeur_Flottant: double;
    Valeur_Date    : TDateTime;
    function Passe_le_test: Boolean;
  //Affichage
  public
    function Contenu: String;
  //SQL
  public
    function SQL: String;
  end;


implementation

{ TContrainte }

constructor TContrainte.Create;
begin
     Active:= False;
     NomChamp := '';
     Operateur:= co_Egal;
     TypeOperande:= cto_Chaine;
     Critere_Chaine  := '';
     Critere_Entier  := 0;
     Critere_Flottant:= 0;
     Critere_Date    := 0;
end;

destructor TContrainte.Destroy;
begin

     inherited;
end;

function TContrainte.IsDate: Boolean;
begin
     Result:= cto_Date = TypeOperande;
end;

function TContrainte.Passe_le_test: Boolean;
begin
     Result:= not Active;
     if Result then exit;

     case Operateur
     of
       co_Egal:
         case TypeOperande
         of
           cto_Chaine  : Result:= Critere_Chaine   = Valeur_Chaine  ;
           cto_Entier  : Result:= Critere_Entier   = Valeur_Entier  ;
           cto_Flottant: Result:= Critere_Flottant = Valeur_Flottant;
           cto_Date    : Result:= Critere_Date     = Valeur_Date    ;
           end;
       co_Different:
         case TypeOperande
         of
           cto_Chaine  : Result:= Critere_Chaine   <> Valeur_Chaine  ;
           cto_Entier  : Result:= Critere_Entier   <> Valeur_Entier  ;
           cto_Flottant: Result:= Critere_Flottant <> Valeur_Flottant;
           cto_Date    : Result:= Critere_Date     <> Valeur_Date    ;
           end;
       co_Like:
         case TypeOperande
         of
           cto_Chaine  : Result:= 1= Pos( Critere_Chaine, Valeur_Chaine);
           cto_Entier  : Result:= Valeur_Entier   = Critere_Entier  ;
           cto_Flottant: Result:= Valeur_Flottant = Critere_Flottant;
           cto_Date    : Result:= Valeur_Date     = Critere_Date    ;
           end;
       co_Inferieur_ou_Egal:
         case TypeOperande
         of
           cto_Chaine  : Result:= Valeur_Chaine   <= Critere_Chaine  ;
           cto_Entier  : Result:= Valeur_Entier   <= Critere_Entier  ;
           cto_Flottant: Result:= Valeur_Flottant <= Critere_Flottant;
           cto_Date    : Result:= Valeur_Date     <= Critere_Date    ;
           end;
       co_Superieur_ou_Egal:
         case TypeOperande
         of
           cto_Chaine  : Result:= Valeur_Chaine   >= Critere_Chaine  ;
           cto_Entier  : Result:= Valeur_Entier   >= Critere_Entier  ;
           cto_Flottant: Result:= Valeur_Flottant >= Critere_Flottant;
           cto_Date    : Result:= Valeur_Date     >= Critere_Date    ;
           end;
       end;
end;

function TContrainte.sCritere: String;
begin
     case TypeOperande
     of
       cto_Chaine  : Result:= '"'+               Critere_Chaine   +'"';
       cto_Entier  : Result:=          IntToStr( Critere_Entier  )    ;
       cto_Flottant: Result:=        FloatToStr( Critere_Flottant)    ;
       cto_Date    : Result:=     DateTimeToStr( Critere_Date    )    ;
       else          Result:= '';
       end;
end;

function TContrainte.Contenu: String;
begin
     Result:= '';
     if not Active then exit;

     case Operateur
     of
       co_Egal:
         Result:= 'X = '+sCritere;
       co_Different:
         Result:= 'X <> '+sCritere;
       co_Like:
         case TypeOperande
         of
           cto_Chaine  : Result:= '1= Pos( "'+Critere_Chaine+'", X)';
           else          Result:= 'X = '+sCritere;
           end;
       co_Inferieur_ou_Egal:
         Result:= 'X <= '+sCritere;
       co_Superieur_ou_Egal:
         Result:= 'X >= '+sCritere;
       end;
end;

function TContrainte.SQL: String;
begin
     Result:= '';
     if not Active then exit;

     case Operateur
     of
       co_Egal:
         Result:= SQL_EGAL( NomChamp, sCritere);
       co_Different:
         Result:= SQL_OP( NomChamp, '<>', sCritere);
       co_Like:
         case TypeOperande
         of
           cto_Chaine  : Result:= SQL_Racine( NomChamp, sCritere);
           else          Result:= SQL_EGAL  ( NomChamp, sCritere);
           end;
       co_Inferieur_ou_Egal:
         Result:= SQL_OP( NomChamp, '<=', sCritere);
       co_Superieur_ou_Egal:
         Result:= SQL_OP( NomChamp, '>=', sCritere);
       end;
end;

end.
