unit ublpage;
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
 Tblpage= class;
//pattern_aggregation_classe_declaration

 { Tblpage }

 Tblpage
 =
  class( TBatpro_Ligne)
  //Gestion du cycle de vie
  public
    constructor Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre); override;
    destructor Destroy; override;
  //champs persistants
  public
    date: TJSONData; cdate: TChamp;
    date_gmt: TJSONData; cdate_gmt: TChamp;
    guid: TJSONData; cguid: TChamp;
    //id:  Integer; cid: TChamp;
    link:   String; clink: TChamp;
    modified_: TJSONData; cmodified: TChamp;
    modified_gmt: TJSONData; cmodified_gmt: TChamp;
    slug:   String; cslug: TChamp;
    status:   String; cstatus: TChamp;
    type_:   String; ctype: TChamp;
    password:   String; cpassword: TChamp;
    permalink_template:   String; cpermalink_template: TChamp;
    generated_slug:   String; cgenerated_slug: TChamp;
    class_list: TJSONData; cclass_list: TChamp;
    parent:  Integer; cparent: TChamp;
    title: TJSONData; ctitle: TChamp;
    content: TJSONData; ccontent: TChamp;
    author:  Integer; cauthor: TChamp;
    excerpt: TJSONData; cexcerpt: TChamp;
    featured_media:  Integer; cfeatured_media: TChamp;
    comment_status:   String; ccomment_status: TChamp;
    ping_status:   String; cping_status: TChamp;
    menu_order:  Integer; cmenu_order: TChamp;
    meta: TJSONData; cmeta: TChamp;
    template:   String; ctemplate: TChamp; 
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

 TIterateur_page
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: Tblpage);
    function  not_Suivant( out _Resultat: Tblpage): Boolean;
  end;

 Tslpage
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
    function Iterateur: TIterateur_page;
    function Iterateur_Decroissant: TIterateur_page;
  end;

function blpage_from_sl( sl: TBatpro_StringList; Index: Integer): Tblpage;
function blpage_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblpage;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blpage_from_sl( sl: TBatpro_StringList; Index: Integer): Tblpage;
begin
     _Classe_from_sl( Result, Tblpage, sl, Index);
end;

function blpage_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblpage;
begin
     _Classe_from_sl_sCle( Result, Tblpage, sl, sCle);
end;

{ TIterateur_page }

function TIterateur_page.not_Suivant( out _Resultat: Tblpage): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_page.Suivant( out _Resultat: Tblpage);
begin
     Suivant_interne( _Resultat);
end;

{ Tslpage }

constructor Tslpage.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, Tblpage);
end;

destructor Tslpage.Destroy;
begin
     inherited;
end;

class function Tslpage.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_page;
end;

function Tslpage.Iterateur: TIterateur_page;
begin
     Result:= TIterateur_page( Iterateur_interne);
end;

function Tslpage.Iterateur_Decroissant: TIterateur_page;
begin
     Result:= TIterateur_page( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ Tblpage }

constructor Tblpage.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'page';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'page';

     //champs persistants
     cdate:= JSON_from_String( date, 'date');
     cdate_gmt:= JSON_from_String( date_gmt, 'date_gmt');
     cguid:= JSON_from_String( guid, 'guid');
     //cid:=  Integer_from_Integer( id, 'id');
     clink:=   String_from_String( link, 'link');
     cmodified:= JSON_from_String( modified_, 'modified');
     cmodified_gmt:= JSON_from_String( modified_gmt, 'modified_gmt');
     cslug:=   String_from_String( slug, 'slug');
     cstatus:=   String_from_String( status, 'status');
     ctype:=   String_from_String( type_, 'type');
     cpassword:=   String_from_String( password, 'password');
     cpermalink_template:=   String_from_String( permalink_template, 'permalink_template');
     cgenerated_slug:=   String_from_String( generated_slug, 'generated_slug');
     cclass_list:= JSON_from_String( class_list, 'class_list');
     cparent:=  Integer_from_Integer( parent, 'parent');
     ctitle:= JSON_from_String( title, 'title');
     ccontent:= JSON_from_String( content, 'content');
     cauthor:=  Integer_from_Integer( author, 'author');
     cexcerpt:= JSON_from_String( excerpt, 'excerpt');
     cfeatured_media:=  Integer_from_Integer( featured_media, 'featured_media');
     ccomment_status:=   String_from_String( comment_status, 'comment_status');
     cping_status:=   String_from_String( ping_status, 'ping_status');
     cmenu_order:=  Integer_from_Integer( menu_order, 'menu_order');
     cmeta:= JSON_from_String( meta, 'meta');
     ctemplate:=   String_from_String( template, 'template');
//Pascal_ubl_constructor_pas_detail
end;

destructor Tblpage.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function Tblpage.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure Tblpage.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


