unit ubluser;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2026 Jean SUZINEAU - MARS42                                       |
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
    ufAccueil_Erreur,
    u_sys_,
    uuStrings,
    uBatpro_StringList,
    uChamp,

    uBatpro_Element,
    uBatpro_Ligne,

    udmDatabase,
    upool_Ancetre_Ancetre,
    upool,

//Aggregations_Pascal_ubl_uses_details_pas


    SysUtils, Classes, SqlDB, DB,fpjson;

type
 Tbluser= class;
//pattern_aggregation_classe_declaration

 { Tbluser }

 Tbluser
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    //id:  Integer; cid: TChamp;
    username:   String; cusername: TChamp;
    name:   String; cname: TChamp;
    first_name:   String; cfirst_name: TChamp;
    last_name:   String; clast_name: TChamp;
    email:   String; cemail: TChamp;
    url:   String; curl: TChamp;
    description:   String; cdescription: TChamp;
    link:   String; clink: TChamp;
    locale:   String; clocale: TChamp;
    nickname:   String; cnickname: TChamp;
    slug:   String; cslug: TChamp;
    registered_date: TJSONData; cregistered_date: TChamp;
    roles: TJSONData; croles: TChamp;
    password:   String; cpassword: TChamp;
    capabilities: TJSONData; ccapabilities: TChamp;
    extra_capabilities: TJSONData; cextra_capabilities: TChamp;
    avatar_urls: TJSONData; cavatar_urls: TChamp;
    meta: TJSONData; cmeta: TChamp; 
//Pascal_ubl_declaration_pas_detail
  //Gestion de la clé
  public
//pattern_sCle_from__Declaration
    function sCle: String; override;
  //Gestion des déconnexions
  public
    procedure Unlink(be: TBatpro_Element); override;
//pattern_aggregation_function_Create_Aggregation_declaration
  end;

 TIterateur_user
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: Tbluser);
    function  not_Suivant( out _Resultat: Tbluser): Boolean;
  end;

 Tsluser
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
    function Iterateur: TIterateur_user;
    function Iterateur_Decroissant: TIterateur_user;
  end;

function bluser_from_sl( sl: TBatpro_StringList; Index: Integer): Tbluser;
function bluser_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tbluser;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function bluser_from_sl( sl: TBatpro_StringList; Index: Integer): Tbluser;
begin
     _Classe_from_sl( Result, Tbluser, sl, Index);
end;

function bluser_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tbluser;
begin
     _Classe_from_sl_sCle( Result, Tbluser, sl, sCle);
end;

{ TIterateur_user }

function TIterateur_user.not_Suivant( out _Resultat: Tbluser): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_user.Suivant( out _Resultat: Tbluser);
begin
     Suivant_interne( _Resultat);
end;

{ Tsluser }

constructor Tsluser.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, Tbluser);
end;

destructor Tsluser.Destroy;
begin
     inherited;
end;

class function Tsluser.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_user;
end;

function Tsluser.Iterateur: TIterateur_user;
begin
     Result:= TIterateur_user( Iterateur_interne);
end;

function Tsluser.Iterateur_Decroissant: TIterateur_user;
begin
     Result:= TIterateur_user( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ Tbluser }

constructor Tbluser.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'user';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'user';

     //champs persistants
     //cid:=  Integer_from_Integer( id, 'id');
     cusername:=   String_from_String( username, 'username');
     cname:=   String_from_String( name, 'name');
     cfirst_name:=   String_from_String( first_name, 'first_name');
     clast_name:=   String_from_String( last_name, 'last_name');
     cemail:=   String_from_String( email, 'email');
     curl:=   String_from_String( url, 'url');
     cdescription:=   String_from_String( description, 'description');
     clink:=   String_from_String( link, 'link');
     clocale:=   String_from_String( locale, 'locale');
     cnickname:=   String_from_String( nickname, 'nickname');
     cslug:=   String_from_String( slug, 'slug');
     cregistered_date:= JSON_from_String( registered_date, 'registered_date');
     croles:= JSON_from_String( roles, 'roles');
     cpassword:=   String_from_String( password, 'password');
     ccapabilities:= JSON_from_String( capabilities, 'capabilities');
     cextra_capabilities:= JSON_from_String( extra_capabilities, 'extra_capabilities');
     cavatar_urls:= JSON_from_String( avatar_urls, 'avatar_urls');
     cmeta:= JSON_from_String( meta, 'meta');
//Pascal_ubl_constructor_pas_detail
end;

destructor Tbluser.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function Tbluser.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure Tbluser.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


