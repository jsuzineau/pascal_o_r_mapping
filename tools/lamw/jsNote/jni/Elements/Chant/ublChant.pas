unit ublChant;
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


 TblChant
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    Titre: String;
    Soprano: String;
    Alto: String;
    Tenor: String;
    Basse: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;

  end;

 TIterateur_Chant
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblChant);
    function  not_Suivant( out _Resultat: TblChant): Boolean;
  end;

 TslChant
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
    function Iterateur: TIterateur_Chant;
    function Iterateur_Decroissant: TIterateur_Chant;
  end;

function blChant_from_sl( sl: TBatpro_StringList; Index: Integer): TblChant;
function blChant_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblChant;

implementation

function blChant_from_sl( sl: TBatpro_StringList; Index: Integer): TblChant;
begin
     _Classe_from_sl( Result, TblChant, sl, Index);
end;

function blChant_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblChant;
begin
     _Classe_from_sl_sCle( Result, TblChant, sl, sCle);
end;

{ TIterateur_Chant }

function TIterateur_Chant.not_Suivant( out _Resultat: TblChant): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Chant.Suivant( out _Resultat: TblChant);
begin
     Suivant_interne( _Resultat);
end;

{ TslChant }

constructor TslChant.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblChant);
end;

destructor TslChant.Destroy;
begin
     inherited;
end;

class function TslChant.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Chant;
end;

function TslChant.Iterateur: TIterateur_Chant;
begin
     Result:= TIterateur_Chant( Iterateur_interne);
end;

function TslChant.Iterateur_Decroissant: TIterateur_Chant;
begin
     Result:= TIterateur_Chant( Iterateur_interne_Decroissant);
end;



{ TblChant }

constructor TblChant.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Chant';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Chant';

     //champs persistants
     Champs.  String_from_String ( Titre          , 'Titre'          );
     Champs.  String_from_String ( Soprano        , 'Soprano'        );
     Champs.  String_from_String ( Alto           , 'Alto'           );
     Champs.  String_from_String ( Tenor          , 'Tenor'          );
     Champs.  String_from_String ( Basse          , 'Basse'          );

end;

destructor TblChant.Destroy;
begin

     inherited;
end;



function TblChant.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


