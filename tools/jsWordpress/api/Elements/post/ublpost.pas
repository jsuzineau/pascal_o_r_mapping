unit ublpost;
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
 Tblpost= class;
//pattern_aggregation_classe_declaration

 { Tblpost }

 Tblpost
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
    title: TJSONData; ctitle: TChamp;
    content: TJSONData; ccontent: TChamp;
    author:  Integer; cauthor: TChamp;
    excerpt: TJSONData; cexcerpt: TChamp;
    featured_media:  Integer; cfeatured_media: TChamp;
    comment_status:   String; ccomment_status: TChamp;
    ping_status:   String; cping_status: TChamp;
    format:   String; cformat: TChamp;
    meta: TJSONData; cmeta: TChamp;
    sticky:  Boolean; csticky: TChamp;
    template:   String; ctemplate: TChamp;
    categories: TJSONData; ccategories: TChamp;
    tags: TJSONData; ctags: TChamp; 
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

 TIterateur_post
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: Tblpost);
    function  not_Suivant( out _Resultat: Tblpost): Boolean;
  end;

 Tslpost
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
    function Iterateur: TIterateur_post;
    function Iterateur_Decroissant: TIterateur_post;
  end;

function blpost_from_sl( sl: TBatpro_StringList; Index: Integer): Tblpost;
function blpost_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblpost;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blpost_from_sl( sl: TBatpro_StringList; Index: Integer): Tblpost;
begin
     _Classe_from_sl( Result, Tblpost, sl, Index);
end;

function blpost_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblpost;
begin
     _Classe_from_sl_sCle( Result, Tblpost, sl, sCle);
end;

{ TIterateur_post }

function TIterateur_post.not_Suivant( out _Resultat: Tblpost): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_post.Suivant( out _Resultat: Tblpost);
begin
     Suivant_interne( _Resultat);
end;

{ Tslpost }

constructor Tslpost.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, Tblpost);
end;

destructor Tslpost.Destroy;
begin
     inherited;
end;

class function Tslpost.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_post;
end;

function Tslpost.Iterateur: TIterateur_post;
begin
     Result:= TIterateur_post( Iterateur_interne);
end;

function Tslpost.Iterateur_Decroissant: TIterateur_post;
begin
     Result:= TIterateur_post( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ Tblpost }

constructor Tblpost.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'post';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'post';

     //champs persistants
     Champs.cID.Definition.Persistant:= False;
     cdate:= JSON_from_String( date, 'date', False);
     cdate_gmt:= JSON_from_String( date_gmt, 'date_gmt', False);
     cguid:= JSON_from_String( guid, 'guid', False);
     //cid:=  Integer_from_Integer( id, 'id', False);
     clink:=   String_from_String( link, 'link', False);
     cmodified:= JSON_from_String( modified_, 'modified', False);
     cmodified_gmt:= JSON_from_String( modified_gmt, 'modified_gmt', False);
     cslug:=   String_from_String( slug, 'slug', False);
     cstatus:=   String_from_String( status, 'status', False);
     ctype:=   String_from_String( type_, 'type', False);
     cpassword:=   String_from_String( password, 'password', False);
     cpermalink_template:=   String_from_String( permalink_template, 'permalink_template', False);
     cgenerated_slug:=   String_from_String( generated_slug, 'generated_slug', False);
     cclass_list:= JSON_from_String( class_list, 'class_list', False);
     ctitle:= JSON_from_String( title, 'title', False);
     ccontent:= JSON_from_String( content, 'content', False);
     cauthor:=  Integer_from_Integer( author, 'author', False);
     cexcerpt:= JSON_from_String( excerpt, 'excerpt', False);
     cfeatured_media:=  Integer_from_Integer( featured_media, 'featured_media', False);
     ccomment_status:=   String_from_String( comment_status, 'comment_status', False);
     cping_status:=   String_from_String( ping_status, 'ping_status', False);
     cformat:=   String_from_String( format, 'format', False);
     cmeta:= JSON_from_String( meta, 'meta', False);
     csticky:=  Ajoute_Boolean( sticky, 'sticky', False);
     ctemplate:=   String_from_String( template, 'template', False);
     ccategories:= JSON_from_String( categories, 'categories', False);
     ctags:= JSON_from_String( tags, 'tags', False);
//Pascal_ubl_constructor_pas_detail
end;

destructor Tblpost.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function Tblpost.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure Tblpost.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
     ;

end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


