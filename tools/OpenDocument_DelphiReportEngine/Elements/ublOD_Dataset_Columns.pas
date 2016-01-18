unit ublOD_Dataset_Columns;
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
    uOD_Dataset_Columns,
    uBatpro_Element,
    uBatpro_Ligne,

 Classes, SysUtils, DB, BufDataset;

type

 { TblOD_Dataset_Columns }

 TblOD_Dataset_Columns
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //OD_Dataset_Columns
  public
    Nom: String;
    D: TBufDataset;
    DCs: TOD_Dataset_Columns;
    procedure Charge( _Nom: String; _DCs: TOD_Dataset_Columns);
  //Gestion de la clé
  public
    class function sCle_from_( _Nom: String): String;
    function sCle: String; override;
  end;

 TIterateur_OD_Dataset_Columns
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblOD_Dataset_Columns);
    function  not_Suivant( var _Resultat: TblOD_Dataset_Columns): Boolean;
  end;

 TslOD_Dataset_Columns
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
    function Iterateur: TIterateur_OD_Dataset_Columns;
    function Iterateur_Decroissant: TIterateur_OD_Dataset_Columns;
  end;

function blOD_Dataset_Columns_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Dataset_Columns;
function blOD_Dataset_Columns_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Dataset_Columns;

implementation

function blOD_Dataset_Columns_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Dataset_Columns;
begin
     _Classe_from_sl( Result, TblOD_Dataset_Columns, sl, Index);
end;

function blOD_Dataset_Columns_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Dataset_Columns;
begin
     _Classe_from_sl_sCle( Result, TblOD_Dataset_Columns, sl, sCle);
end;


{ TIterateur_OD_Dataset_Columns }

function TIterateur_OD_Dataset_Columns.not_Suivant( var _Resultat: TblOD_Dataset_Columns): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_OD_Dataset_Columns.Suivant( var _Resultat: TblOD_Dataset_Columns);
begin
     Suivant_interne( _Resultat);
end;

{ TslOD_Dataset_Columns }

constructor TslOD_Dataset_Columns.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblOD_Dataset_Columns);
end;

destructor TslOD_Dataset_Columns.Destroy;
begin
     inherited;
end;

class function TslOD_Dataset_Columns.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Dataset_Columns;
end;

function TslOD_Dataset_Columns.Iterateur: TIterateur_OD_Dataset_Columns;
begin
     Result:= TIterateur_OD_Dataset_Columns( Iterateur_interne);
end;

function TslOD_Dataset_Columns.Iterateur_Decroissant: TIterateur_OD_Dataset_Columns;
begin
     Result:= TIterateur_OD_Dataset_Columns( Iterateur_interne_Decroissant);
end;

{ TblOD_Dataset_Columns }

constructor TblOD_Dataset_Columns.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _q, _pool);
     D:= TBufDataset.Create( nil);
end;

destructor TblOD_Dataset_Columns.Destroy;
begin
     Free_nil( D);
     inherited Destroy;
end;

procedure TblOD_Dataset_Columns.Charge( _Nom: String; _DCs: TOD_Dataset_Columns);
begin
     Nom:= _Nom;
     DCs:= _DCs;

     D.Name:= Nom;
     Ajoute_String ( Nom, 'Nom'  );
end;

class function TblOD_Dataset_Columns.sCle_from_( _Nom: String): String;
begin
     Result:= _Nom;
end;

function TblOD_Dataset_Columns.sCle: String;
begin
     Result:= sCle_from_( Nom);
end;

end.

