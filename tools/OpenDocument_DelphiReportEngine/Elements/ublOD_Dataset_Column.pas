unit ublOD_Dataset_Column;
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
    uOD_Dataset_Column,
    uBatpro_Element,
    uBatpro_Ligne,

 Classes, SysUtils, DB;

type

 { TblOD_Dataset_Column }

 TblOD_Dataset_Column
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //OD_Dataset_Column
  public
    DC: TOD_Dataset_Column;
    procedure Charge( _DC: TOD_Dataset_Column);
  //Attributs
  public
    property FieldName: String  read DC.FieldName write DC.FieldName;
    property Debut    : Integer read DC.Debut     write DC.Debut    ;
    property Fin      : Integer read DC.Fin       write DC.Fin      ;
  //Gestion de la clé
  public
    class function sCle_from_( _FieldName: String): String;
    function sCle: String; override;
  end;

 TIterateur_OD_Dataset_Column
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblOD_Dataset_Column);
    function  not_Suivant( out _Resultat: TblOD_Dataset_Column): Boolean;
  end;

 TslOD_Dataset_Column
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
    function Iterateur: TIterateur_OD_Dataset_Column;
    function Iterateur_Decroissant: TIterateur_OD_Dataset_Column;
  end;

function blOD_Dataset_Column_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Dataset_Column;
function blOD_Dataset_Column_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Dataset_Column;

implementation

function blOD_Dataset_Column_from_sl( sl: TBatpro_StringList; Index: Integer): TblOD_Dataset_Column;
begin
     _Classe_from_sl( Result, TblOD_Dataset_Column, sl, Index);
end;

function blOD_Dataset_Column_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblOD_Dataset_Column;
begin
     _Classe_from_sl_sCle( Result, TblOD_Dataset_Column, sl, sCle);
end;


{ TIterateur_OD_Dataset_Column }

function TIterateur_OD_Dataset_Column.not_Suivant( out _Resultat: TblOD_Dataset_Column): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_OD_Dataset_Column.Suivant( out _Resultat: TblOD_Dataset_Column);
begin
     Suivant_interne( _Resultat);
end;

{ TslOD_Dataset_Column }

constructor TslOD_Dataset_Column.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblOD_Dataset_Column);
end;

destructor TslOD_Dataset_Column.Destroy;
begin
     inherited;
end;

class function TslOD_Dataset_Column.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_OD_Dataset_Column;
end;

function TslOD_Dataset_Column.Iterateur: TIterateur_OD_Dataset_Column;
begin
     Result:= TIterateur_OD_Dataset_Column( Iterateur_interne);
end;

function TslOD_Dataset_Column.Iterateur_Decroissant: TIterateur_OD_Dataset_Column;
begin
     Result:= TIterateur_OD_Dataset_Column( Iterateur_interne_Decroissant);
end;

{ TblOD_Dataset_Column }

constructor TblOD_Dataset_Column.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _q, _pool);
end;

destructor TblOD_Dataset_Column.Destroy;
begin
     inherited Destroy;
end;

procedure TblOD_Dataset_Column.Charge( _DC: TOD_Dataset_Column);
begin
     DC:= _DC;

     cLibelle:= Ajoute_String ( DC.FieldName, 'FieldName');
     Ajoute_Integer( DC.Debut    , 'Debut'    );
     Ajoute_Integer( DC.Fin      , 'Fin'      );
end;

class function TblOD_Dataset_Column.sCle_from_( _FieldName: String): String;
begin
     Result:= _FieldName;
end;

function TblOD_Dataset_Column.sCle: String;
begin
     Result:= sCle_from_( FieldName);
end;

end.

