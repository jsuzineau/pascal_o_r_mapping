unit ublMesure;
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
    uDataUtilsU,
    uBatpro_StringList,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,

    SysUtils, Classes, SqlDB, DB;

type


 { TblMesure }

 TblMesure
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    temps: String;
    pression: Double;
  //Temps
  public
    function dTemps: TDateTime;
  //Gestion de la clé
  public
    function sCle: String; override;
  end;

 TIterateur_Mesure
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: TblMesure);
    function  not_Suivant( out _Resultat: TblMesure): Boolean;
  end;

 TslMesure
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
    function Iterateur: TIterateur_Mesure;
    function Iterateur_Decroissant: TIterateur_Mesure;
  end;

function blMesure_from_sl( sl: TBatpro_StringList; Index: Integer): TblMesure;
function blMesure_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblMesure;

implementation

function blMesure_from_sl( sl: TBatpro_StringList; Index: Integer): TblMesure;
begin
     _Classe_from_sl( Result, TblMesure, sl, Index);
end;

function blMesure_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblMesure;
begin
     _Classe_from_sl_sCle( Result, TblMesure, sl, sCle);
end;

{ TIterateur_Mesure }

function TIterateur_Mesure.not_Suivant( out _Resultat: TblMesure): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_Mesure.Suivant( out _Resultat: TblMesure);
begin
     Suivant_interne( _Resultat);
end;

{ TslMesure }

constructor TslMesure.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblMesure);
end;

destructor TslMesure.Destroy;
begin
     inherited;
end;

class function TslMesure.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_Mesure;
end;

function TslMesure.Iterateur: TIterateur_Mesure;
begin
     Result:= TIterateur_Mesure( Iterateur_interne);
end;

function TslMesure.Iterateur_Decroissant: TIterateur_Mesure;
begin
     Result:= TIterateur_Mesure( Iterateur_interne_Decroissant);
end;



{ TblMesure }

constructor TblMesure.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'Mesure';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'Mesure';

     //champs persistants
     Champs.String_from_( temps   , 'temps'   );
     Champs.Double_from_( pression, 'pression');

end;

destructor TblMesure.Destroy;
begin

     inherited;
end;

function TblMesure.dTemps: TDateTime;
begin
     Result:= DateTime_from_DateTimeSQL_sans_quotes( temps);
end;

function TblMesure.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


