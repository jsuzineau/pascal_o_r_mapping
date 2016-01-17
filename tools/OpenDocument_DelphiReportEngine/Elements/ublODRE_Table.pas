unit ublODRE_Table;
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
    uODRE_Table,
    uBatpro_Element,
    uBatpro_Ligne,

 Classes, SysUtils, DB;

type

 { TblODRE_Table }

 TblODRE_Table
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //ODRE_Table
  public
    T: TODRE_Table;
    procedure Charge( _Nom: String; _C: TOD_TextTableContext);
  //Champs
  public
    property Nom: String read T.Nom write T.Nom;
  //Gestion de la clé
  public
    class function sCle_from_( _Nom: String): String;
    function sCle: String; override;
  end;

 TIterateur_ODRE_Table
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblODRE_Table);
    function  not_Suivant( var _Resultat: TblODRE_Table): Boolean;
  end;

 TslODRE_Table
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
    function Iterateur: TIterateur_ODRE_Table;
    function Iterateur_Decroissant: TIterateur_ODRE_Table;
  end;

function blODRE_Table_from_sl( sl: TBatpro_StringList; Index: Integer): TblODRE_Table;
function blODRE_Table_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblODRE_Table;

implementation

function blODRE_Table_from_sl( sl: TBatpro_StringList; Index: Integer): TblODRE_Table;
begin
     _Classe_from_sl( Result, TblODRE_Table, sl, Index);
end;

function blODRE_Table_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblODRE_Table;
begin
     _Classe_from_sl_sCle( Result, TblODRE_Table, sl, sCle);
end;


{ TIterateur_ODRE_Table }

function TIterateur_ODRE_Table.not_Suivant( var _Resultat: TblODRE_Table): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_ODRE_Table.Suivant( var _Resultat: TblODRE_Table);
begin
     Suivant_interne( _Resultat);
end;

{ TslODRE_Table }

constructor TslODRE_Table.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblODRE_Table);
end;

destructor TslODRE_Table.Destroy;
begin
     inherited;
end;

class function TslODRE_Table.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_ODRE_Table;
end;

function TslODRE_Table.Iterateur: TIterateur_ODRE_Table;
begin
     Result:= TIterateur_ODRE_Table( Iterateur_interne);
end;

function TslODRE_Table.Iterateur_Decroissant: TIterateur_ODRE_Table;
begin
     Result:= TIterateur_ODRE_Table( Iterateur_interne_Decroissant);
end;

{ TblODRE_Table }

constructor TblODRE_Table.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
begin
     inherited Create(_sl, _q, _pool);
end;

destructor TblODRE_Table.Destroy;
begin
     inherited Destroy;
end;

procedure TblODRE_Table.Charge( _Nom: String; _C: TOD_TextTableContext);
begin
     T:= TODRE_Table.Create( _Nom);
     T.Pas_de_persistance:= False;

     Ajoute_String( T.Nom, 'Nom');
     T.from_Doc( _C);
end;

class function TblODRE_Table.sCle_from_( _Nom: String): String;
begin
     Result:= _Nom;
end;

function TblODRE_Table.sCle: String;
begin
     Result:= sCle_from_( Nom);
end;

end.

