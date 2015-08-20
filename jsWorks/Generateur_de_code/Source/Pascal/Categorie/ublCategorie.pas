unit ublCategorie;
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
    u_sys_,
    uuStrings,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type


 TblCategorie
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Symbol: String;
    Description: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;

  end;

 TIterateur_Categorie
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblCategorie);
    function  not_Suivant( var _Resultat: TblCategorie): Boolean;
  end;

 TslCategorie
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
    function Iterateur: TIterateur_Categorie;
    function Iterateur_Decroissant: TIterateur_Categorie;
  end;

function blCategorie_from_sl( sl: TBatpro_StringList; Index: Integer): TblCategorie;
function blCategorie_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblCategorie;

implementation

function blCategorie_from_sl( sl: TBatpro_StringList; Index: Integer): TblCategorie;
begin
     _Classe_from_sl( Result, TblCategorie, sl, Index);
end;

function blCategorie_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblCategorie;
begin
     _Classe_from_sl_sCle( Result, TblCategorie, sl, sCle);
end;

{ TIterateur_Categorie }

function TIterateur_Categorie.not_Suivant( var _Resultat: TblCategorie): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Categorie.Suivant( var _Resultat: TblCategorie);
begin
     Suivant_interne( _Resultat);
end;

{ TslCategorie }

constructor TslCategorie.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblCategorie);
end;

destructor TslCategorie.Destroy;
begin
     inherited;
end;

class function TslCategorie.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Categorie;
end;

function TslCategorie.Iterateur: TIterateur_Categorie;
begin
     Result:= TIterateur_Categorie( Iterateur_interne);
end;

function TslCategorie.Iterateur_Decroissant: TIterateur_Categorie;
begin
     Result:= TIterateur_Categorie( Iterateur_interne_Decroissant);
end;



{ TblCategorie }

constructor TblCategorie.Create( _sl: TBatpro_StringList; _q: TDataset; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Categorie';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Categorie';

     //champs persistants
     Champs.  String_from_String ( Symbol         , 'Symbol'         );
     Champs.  String_from_String ( Description    , 'Description'    );

end;

destructor TblCategorie.Destroy;
begin

     inherited;
end;



function TblCategorie.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


