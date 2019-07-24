unit ublPostgres_Foreign_Key;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2019 Jean SUZINEAU - MARS42                                       |
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
    u_sys_,
    uuStrings,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type


 { TblPostgres_Foreign_Key }

 TblPostgres_Foreign_Key
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Constraint: String;
    Definition: String;
  //Gestion de la clé
  public
    function sCle: String; override;

  //méthodes
  public
    procedure Calcule_Champs;
  // FOREIGN_KEY
  public
    FOREIGN_KEY: String;
  // Reference_Table
  public
    Reference_Table: String;
  // Reference_Field
  public
    Reference_Field: String;
  end;

 TIterateur_Postgres_Foreign_Key
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblPostgres_Foreign_Key);
    function  not_Suivant( out _Resultat: TblPostgres_Foreign_Key): Boolean;
  end;

 TslPostgres_Foreign_Key
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
    function Iterateur: TIterateur_Postgres_Foreign_Key;
    function Iterateur_Decroissant: TIterateur_Postgres_Foreign_Key;
  end;

function blPostgres_Foreign_Key_from_sl( sl: TBatpro_StringList; Index: Integer): TblPostgres_Foreign_Key;
function blPostgres_Foreign_Key_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPostgres_Foreign_Key;

implementation

function blPostgres_Foreign_Key_from_sl( sl: TBatpro_StringList; Index: Integer): TblPostgres_Foreign_Key;
begin
     _Classe_from_sl( Result, TblPostgres_Foreign_Key, sl, Index);
end;

function blPostgres_Foreign_Key_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblPostgres_Foreign_Key;
begin
     _Classe_from_sl_sCle( Result, TblPostgres_Foreign_Key, sl, sCle);
end;

{ TIterateur_Postgres_Foreign_Key }

function TIterateur_Postgres_Foreign_Key.not_Suivant( out _Resultat: TblPostgres_Foreign_Key): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Postgres_Foreign_Key.Suivant( out _Resultat: TblPostgres_Foreign_Key);
begin
     Suivant_interne( _Resultat);
end;

{ TslPostgres_Foreign_Key }

constructor TslPostgres_Foreign_Key.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblPostgres_Foreign_Key);
end;

destructor TslPostgres_Foreign_Key.Destroy;
begin
     inherited;
end;

class function TslPostgres_Foreign_Key.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Postgres_Foreign_Key;
end;

function TslPostgres_Foreign_Key.Iterateur: TIterateur_Postgres_Foreign_Key;
begin
     Result:= TIterateur_Postgres_Foreign_Key( Iterateur_interne);
end;

function TslPostgres_Foreign_Key.Iterateur_Decroissant: TIterateur_Postgres_Foreign_Key;
begin
     Result:= TIterateur_Postgres_Foreign_Key( Iterateur_interne_Decroissant);
end;



{ TblPostgres_Foreign_Key }

constructor TblPostgres_Foreign_Key.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Postgres_Foreign_Key';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Postgres_Foreign_Key';

     //champs persistants
     Champs.  String_from_String ( Constraint     , 'Constraint'     );
     Champs.  String_from_String ( Definition     , 'Definition'     );

     //Champs calculés
     Ajoute_String( FOREIGN_KEY    ,'FOREIGN_KEY'    , False);
     Ajoute_String( Reference_Table,'Reference_Table', False);
     Ajoute_String( Reference_Field,'Reference_Field', False);

     Calcule_Champs;
end;

destructor TblPostgres_Foreign_Key.Destroy;
begin

     inherited;
end;

function TblPostgres_Foreign_Key.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure TblPostgres_Foreign_Key.Calcule_Champs;
var
   S: String;
begin
     S:= Definition;
     //    "FOREIGN KEY (truc) REFERENCES troc(troc_id)"
                       StrToK( '('          , S);
     FOREIGN_KEY    := StrToK( ')'          , S);
                       StrToK( 'REFERENCES ', S);
     Reference_Table:= StrToK( '('          , S);
     Reference_Field:= StrToK( ')'          , S);
end;


end.


