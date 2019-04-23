unit ublOD_Affectation;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2016 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    uClean,
    uBatpro_StringList,
    uOD_TextTableContext,
    uOD_Column,
    uOD_Dataset_Column,
    uOD_Dataset_Columns,
    uChamps,
    uChamp,
    uLookupConnection_Ancetre,
    uBatpro_Element,
    uBatpro_Ligne,

 Classes, SysUtils, DB;

type

 { TblOD_Affectation }

 TblOD_Affectation
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //DCs
  public
    DCs_set: TOD_Dataset_Column_set;
  //NomChamp
  public
    NomChamp: String;
    cNomChamp: TChamp;
  //NomChamp_Libelle
  public
    NomChamp_Libelle: String;
    cNomChamp_Libelle: TChamp;
    procedure NomChamp_Libelle_GetLookupListItems( _Current_Key: String;
                                           _Keys, _Labels: TStrings;
                                           _Connection_Ancetre: TLookupConnection_Ancetre;
                                           _CodeId_: Boolean= False);
  //Gestion du Hint
  public
    function Contenu( Contexte: Integer; Col, Row: Integer): String; override;
  //Colonne
  public
    Colonne: Integer;
  //Comparaison
  public
    function Egale( be: TBatpro_Element): Boolean; override;
  end;

 TIterateur_OD_Affectation
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblOD_Affectation);
    function  not_Suivant( var _Resultat: TblOD_Affectation): Boolean;
  end;

 TslOD_Affectation
 =
  class( TBatpro_StringList)
  //Gestion du cycle de vie
  public
    constructor Create( _Nom: String= ''); override;
    destructor Destroy; override;
  //Création d'itérateur
  protected
    class function Classe_Iterateur: TIterateur_Class; override;
  public
    function Iterateur: TIterateur_OD_Affectation;
    function Iterateur_Decroissant: TIterateur_OD_Affectation;
  end;

function blOD_Affectation_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Affectation;
function blOD_Affectation_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Affectation;

implementation

function blOD_Affectation_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Affectation;
begin
     _Classe_from_sl( Result, TblOD_Affectation, sl, Index);
end;

function blOD_Affectation_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Affectation;
begin
     _Classe_from_sl_sCle( Result, TblOD_Affectation, sl, sCle);
end;


{ TIterateur_OD_Affectation }

function TIterateur_OD_Affectation.not_Suivant( var _Resultat: TblOD_Affectation): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_OD_Affectation.Suivant( var _Resultat: TblOD_Affectation);
begin
     Suivant_interne( _Resultat);
end;

{ TslOD_Affectation }

constructor TslOD_Affectation.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblOD_Affectation);
end;

destructor TslOD_Affectation.Destroy;
begin
     inherited;
end;

class function TslOD_Affectation.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Affectation;
end;

function TslOD_Affectation.Iterateur: TIterateur_OD_Affectation;
begin
     Result:= TIterateur_OD_Affectation( Iterateur_interne);
end;

function TslOD_Affectation.Iterateur_Decroissant: TIterateur_OD_Affectation;
begin
     Result:= TIterateur_OD_Affectation( Iterateur_interne_Decroissant);
end;

{ TblOD_Affectation }

constructor TblOD_Affectation.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _jsdc, _pool);
     DCs_set:= nil;

     NomChamp:= '';
     cNomChamp:= Ajoute_String( NomChamp, 'NomChamp', False);

     NomChamp_Libelle:= '';
     cNomChamp_Libelle:= Champs.String_Lookup ( NomChamp_Libelle, 'NomChamp_Libelle', cNomChamp, NomChamp_Libelle_GetLookupListItems, '');

     cLibelle:= cNomChamp;

end;

destructor TblOD_Affectation.Destroy;
begin
     inherited Destroy;
end;

procedure TblOD_Affectation.NomChamp_Libelle_GetLookupListItems( _Current_Key: String;
                                                         _Keys, _Labels: TStrings;
                                                         _Connection_Ancetre: TLookupConnection_Ancetre;
                                                         _CodeId_: Boolean);
var
   DC: TOD_Dataset_Column;
begin
     if nil = DCs_set then exit;

     _Keys  .Clear;
     _Labels.Clear;

     _Keys  .Add( '');
     _Labels.Add( '<Aucun>');
     for DC in DCs_set.DCa
     do
       begin
       _Keys  .Add( DC.FieldName);
       _Labels.Add( DC.FieldName);
       end;
end;

function TblOD_Affectation.Contenu( Contexte: Integer; Col, Row: Integer): String;
begin
     Result:= inherited Contenu(Contexte, Col, Row) + Listing_Champs(#13#10);
end;

function TblOD_Affectation.Egale(be: TBatpro_Element): Boolean;
var
   bl: TblOD_Affectation;
begin
     Result:= inherited Egale(be);
     exit;
     Result:= False;
     if Affecte_( bl, TblOD_Affectation, be) then exit;

     Result
     :=
           (DCs_set  = bl.DCs_set )
       and (NomChamp = bl.NomChamp);
end;

end.

