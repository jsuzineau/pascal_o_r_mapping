unit ublattachment;
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
 Tblattachment= class;
//pattern_aggregation_classe_declaration

 { Tblattachment }

 Tblattachment
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
    permalink_template:   String; cpermalink_template: TChamp;
    generated_slug:   String; cgenerated_slug: TChamp;
    class_list: TJSONData; cclass_list: TChamp;
    title: TJSONData; ctitle: TChamp;
    author:  Integer; cauthor: TChamp;
    featured_media:  Integer; cfeatured_media: TChamp;
    comment_status:   String; ccomment_status: TChamp;
    ping_status:   String; cping_status: TChamp;
    meta: TJSONData; cmeta: TChamp;
    template:   String; ctemplate: TChamp;
    alt_text:   String; calt_text: TChamp;
    caption: TJSONData; ccaption: TChamp;
    description: TJSONData; cdescription: TChamp;
    media_type:   String; cmedia_type: TChamp;
    mime_type:   String; cmime_type: TChamp;
    media_details: TJSONData; cmedia_details: TChamp;
    post:  Integer; cpost: TChamp;
    source_url:   String; csource_url: TChamp;
    missing_image_sizes: TJSONData; cmissing_image_sizes: TChamp;
    filename:   String; cfilename: TChamp;
    filesize:  Integer; cfilesize: TChamp;
    exif_orientation:  Integer; cexif_orientation: TChamp; 
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

 TIterateur_attachment
 =
  class( TIterateur)
  //Iterateur
  public
    procedure Suivant( out _Resultat: Tblattachment);
    function  not_Suivant( out _Resultat: Tblattachment): Boolean;
  end;

 Tslattachment
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
    function Iterateur: TIterateur_attachment;
    function Iterateur_Decroissant: TIterateur_attachment;
  end;

function blattachment_from_sl( sl: TBatpro_StringList; Index: Integer): Tblattachment;
function blattachment_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblattachment;

//Details_Pascal_ubl_declaration_pools_aggregations_pas

implementation

function blattachment_from_sl( sl: TBatpro_StringList; Index: Integer): Tblattachment;
begin
     _Classe_from_sl( Result, Tblattachment, sl, Index);
end;

function blattachment_from_sl_sCle( sl: TBatpro_StringList; sCle: String): Tblattachment;
begin
     _Classe_from_sl_sCle( Result, Tblattachment, sl, sCle);
end;

{ TIterateur_attachment }

function TIterateur_attachment.not_Suivant( out _Resultat: Tblattachment): Boolean;
begin
     Result:= not_Suivant_interne( _Resultat);
end;

procedure TIterateur_attachment.Suivant( out _Resultat: Tblattachment);
begin
     Suivant_interne( _Resultat);
end;

{ Tslattachment }

constructor Tslattachment.Create( _Nom: String= '');
begin
     inherited CreateE( _Nom, Tblattachment);
end;

destructor Tslattachment.Destroy;
begin
     inherited;
end;

class function Tslattachment.Classe_Iterateur: TIterateur_Class;
begin
     Result:= TIterateur_attachment;
end;

function Tslattachment.Iterateur: TIterateur_attachment;
begin
     Result:= TIterateur_attachment( Iterateur_interne);
end;

function Tslattachment.Iterateur_Decroissant: TIterateur_attachment;
begin
     Result:= TIterateur_attachment( Iterateur_interne_Decroissant);
end;

//pattern_aggregation_classe_implementation

{ Tblattachment }

constructor Tblattachment.Create( _sl: TBatpro_StringList; _jsdc: TjsDataContexte; _pool: Tpool_Ancetre_Ancetre);
var
   CP: IblG_BECP;
begin
     CP:= Init_ClassParams;
     if Assigned( CP)
     then
         begin
         CP.Libelle:= 'attachment';
         CP.Font.Name:= sys_Times_New_Roman;
         CP.Font.Size:= 12;
         end;

     inherited;

     Champs.ChampDefinitions.NomTable:= 'attachment';

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
     cpermalink_template:=   String_from_String( permalink_template, 'permalink_template');
     cgenerated_slug:=   String_from_String( generated_slug, 'generated_slug');
     cclass_list:= JSON_from_String( class_list, 'class_list');
     ctitle:= JSON_from_String( title, 'title');
     cauthor:=  Integer_from_Integer( author, 'author');
     cfeatured_media:=  Integer_from_Integer( featured_media, 'featured_media');
     ccomment_status:=   String_from_String( comment_status, 'comment_status');
     cping_status:=   String_from_String( ping_status, 'ping_status');
     cmeta:= JSON_from_String( meta, 'meta');
     ctemplate:=   String_from_String( template, 'template');
     calt_text:=   String_from_String( alt_text, 'alt_text');
     ccaption:= JSON_from_String( caption, 'caption');
     cdescription:= JSON_from_String( description, 'description');
     cmedia_type:=   String_from_String( media_type, 'media_type');
     cmime_type:=   String_from_String( mime_type, 'mime_type');
     cmedia_details:= JSON_from_String( media_details, 'media_details');
     cpost:=  Integer_from_Integer( post, 'post');
     csource_url:=   String_from_String( source_url, 'source_url');
     cmissing_image_sizes:= JSON_from_String( missing_image_sizes, 'missing_image_sizes');
     cfilename:=   String_from_String( filename, 'filename');
     cfilesize:=  Integer_from_Integer( filesize, 'filesize');
     cexif_orientation:=  Integer_from_Integer( exif_orientation, 'exif_orientation');
//Pascal_ubl_constructor_pas_detail
end;

destructor Tblattachment.Destroy;
begin

     inherited;
end;

//pattern_sCle_from__Implementation

function Tblattachment.sCle: String;
begin
     Result:= sCle_ID;
end;

procedure Tblattachment.Unlink( be: TBatpro_Element);
begin
     inherited Unlink( be);
end;

//pattern_aggregation_accesseurs_implementation

//Pascal_ubl_implementation_pas_detail

initialization
finalization
end.


