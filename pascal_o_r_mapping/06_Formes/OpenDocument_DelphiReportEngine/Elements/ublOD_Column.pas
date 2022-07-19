unit ublOD_Column;
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
    uChamp,
    uBatpro_StringList,
    uOD_TextTableContext,
    uOD_Column,
    uBatpro_Element,
    uBatpro_Ligne,

 Classes, SysUtils, DB;

type

 { TblOD_Column }

 TblOD_Column
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //OD_Column
  public
    C: TOD_Column;
    procedure Charge( _C: TOD_Column);
  //Champs
  public
    cTitre  : TChamp;
    cLargeur: TChamp;
  //Gestion de la clé
  public
    class function sCle_from_( _id: Integer): String;
    function sCle: String; override;
  end;

 TIterateur_OD_Column
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblOD_Column);
    function  not_Suivant( var _Resultat: TblOD_Column): Boolean;
  end;

 TslOD_Column
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
    function Iterateur: TIterateur_OD_Column;
    function Iterateur_Decroissant: TIterateur_OD_Column;
  end;

function blOD_Column_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Column;
function blOD_Column_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Column;

implementation

function blOD_Column_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Column;
begin
     _Classe_from_sl( Result, TblOD_Column, sl, Index);
end;

function blOD_Column_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Column;
begin
     _Classe_from_sl_sCle( Result, TblOD_Column, sl, sCle);
end;


{ TIterateur_OD_Column }

function TIterateur_OD_Column.not_Suivant( var _Resultat: TblOD_Column): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_OD_Column.Suivant( var _Resultat: TblOD_Column);
begin
     Suivant_interne( _Resultat);
end;

{ TslOD_Column }

constructor TslOD_Column.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblOD_Column);
end;

destructor TslOD_Column.Destroy;
begin
     inherited;
end;

class function TslOD_Column.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Column;
end;

function TslOD_Column.Iterateur: TIterateur_OD_Column;
begin
     Result:= TIterateur_OD_Column( Iterateur_interne);
end;

function TslOD_Column.Iterateur_Decroissant: TIterateur_OD_Column;
begin
     Result:= TIterateur_OD_Column( Iterateur_interne_Decroissant);
end;

{ TblOD_Column }

constructor TblOD_Column.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _jsdc, _pool);
end;

destructor TblOD_Column.Destroy;
begin
     inherited Destroy;
end;

procedure TblOD_Column.Charge( _C: TOD_Column);
begin
     C:= _C;

     cTitre  :=Ajoute_String ( C.Titre  , 'Titre'  , False);
     cLargeur:=Ajoute_Integer( C.Largeur, 'Largeur', False);
     cLibelle:= cTitre;
end;

class function TblOD_Column.sCle_from_( _id: Integer): String;
begin
     Result:= sCle_ID_from_( _id);
end;

function TblOD_Column.sCle: String;
begin
     Result:= sCle_from_( id);
end;

end.

