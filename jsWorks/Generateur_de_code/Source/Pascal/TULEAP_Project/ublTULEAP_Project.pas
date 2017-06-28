unit ublTULEAP_Project;
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


 TblTULEAP_Project
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    uri: String;
    label: String;
    shortname: String;
    resources: String;
    additional_informations: String;
  //Gestion de la clé
  public
  
    function sCle: String; override;

  end;

 TIterateur_TULEAP_Project
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( var _Resultat: TblTULEAP_Project);
    function  not_Suivant( var _Resultat: TblTULEAP_Project): Boolean;
  end;

 TslTULEAP_Project
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
    function Iterateur: TIterateur_TULEAP_Project;
    function Iterateur_Decroissant: TIterateur_TULEAP_Project;
  end;

function blTULEAP_Project_from_sl( sl: TBatpro_StringList; Index: Integer): TblTULEAP_Project;
function blTULEAP_Project_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTULEAP_Project;

implementation

function blTULEAP_Project_from_sl( sl: TBatpro_StringList; Index: Integer): TblTULEAP_Project;
begin
     _Classe_from_sl( Result, TblTULEAP_Project, sl, Index);
end;

function blTULEAP_Project_from_sl_sCle( sl: TBatpro_StringList; sCle: String): TblTULEAP_Project;
begin
     _Classe_from_sl_sCle( Result, TblTULEAP_Project, sl, sCle);
end;

{ TIterateur_TULEAP_Project }

function TIterateur_TULEAP_Project.not_Suivant( var _Resultat: TblTULEAP_Project): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_TULEAP_Project.Suivant( var _Resultat: TblTULEAP_Project);
begin
     Suivant_interne( _Resultat);
end;

{ TslTULEAP_Project }

constructor TslTULEAP_Project.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, TblTULEAP_Project);
end;

destructor TslTULEAP_Project.Destroy;
begin
     inherited;
end;

class function TslTULEAP_Project.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_TULEAP_Project;
end;

function TslTULEAP_Project.Iterateur: TIterateur_TULEAP_Project;
begin
     Result:= TIterateur_TULEAP_Project( Iterateur_interne);
end;

function TslTULEAP_Project.Iterateur_Decroissant: TIterateur_TULEAP_Project;
begin
     Result:= TIterateur_TULEAP_Project( Iterateur_interne_Decroissant);
end;



{ TblTULEAP_Project }

constructor TblTULEAP_Project.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'TULEAP_Project';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'TULEAP_Project';

     //champs persistants
     Champs.  String_from_String ( uri            , 'uri'            );
     Champs.  String_from_String ( label          , 'label'          );
     Champs.  String_from_String ( shortname      , 'shortname'      );
     Champs.  String_from_String ( resources      , 'resources'      );
     Champs.  String_from_String ( additional_informations, 'additional_informations');

end;

destructor TblTULEAP_Project.Destroy;
begin

     inherited;
end;



function TblTULEAP_Project.sCle: String;
begin
     Result:= sCle_ID;
end;





end.


