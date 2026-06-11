unit ujsWordpress_API_Client;

{$mode Delphi}

interface

uses
    uuStrings,
    uMimeType,
 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type
    TWordpress_verb_content_type= (ct_json, ct_multipart_form_data, ct_attachment);

    { TWordpress_verb }

    TWordpress_verb
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create( _Username, _Password: String);
       destructor Destroy; override;
     //identification
     public
       Username, Password: String;
       token: String;
     //url
     public
       url: String;
     //Verb
     public
       Verb: String;
     //Gestion des paramètres
     public
       procedure Parameter_Path ( _name: String; _Value: String);
       procedure Parameter_Query( _name: String; _Value: String);
     //Gestion des properties
     public
       Properties: TJSONObject;
       procedure Property_( _name: String; _Value: TJSONData);
     //http
     public
       http: THTTPSend;
       hc: TFPHTTPClient;
       function String_from_http: String;
     //Request Body
     public
       rbssRequestBody: TRawByteStringStream;
     //Content type
     public
       Content_type: TWordpress_verb_content_type;
     //multipart/form-data
     private
       multipart_form_data_boundary: String;
       procedure Write_Boundary;
       procedure Write_Boundary_Final;
       procedure Write_String( _s: RawByteString);
     public
       procedure Set_multipart_form_data;
       procedure Add_File( _NomFichier: String; _MimeType:String='');
       procedure Set_attachment;
     //Exécution
     public
       function Execute: String;
     end;

//Liste des Paths
type
    //Chemin  /oembed/1.0
     T_oembed_1_0_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, 
       function namespace( _s: String): T_oembed_1_0_get; 
       // optional, 
       function context( _s: String): T_oembed_1_0_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /oembed/1.0/embed
     T_oembed_1_0_embed_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The URL of the resource for which to fetch oEmbed data.
       function url_( _s: String): T_oembed_1_0_embed_get; 
       // optional, 
       function format_( _s: String): T_oembed_1_0_embed_get; 
       // optional, 
       function maxwidth( _s: String): T_oembed_1_0_embed_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /oembed/1.0/proxy
     T_oembed_1_0_proxy_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The URL of the resource for which to fetch oEmbed data.
       function url_( _s: String): T_oembed_1_0_proxy_get; 
       // optional, The oEmbed format to use.
       function format_( _s: String): T_oembed_1_0_proxy_get; 
       // optional, The maximum width of the embed frame in pixels.
       function maxwidth( _s: String): T_oembed_1_0_proxy_get; 
       // optional, The maximum height of the embed frame in pixels.
       function maxheight( _s: String): T_oembed_1_0_proxy_get; 
       // optional, Whether to perform an oEmbed discovery request for unsanctioned providers.
       function discover( _s: String): T_oembed_1_0_proxy_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-openapi/v1
     T_wp_openapi_v1_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, 
       function namespace( _s: String): T_wp_openapi_v1_get; 
       // optional, 
       function context( _s: String): T_wp_openapi_v1_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-openapi/v1/schema
     T_wp_openapi_v1_schema_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, 
       function namespace( _s: String): T_wp_openapi_v1_schema_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2
     T_wp_v2_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, 
       function namespace( _s: String): T_wp_v2_get; 
       // optional, 
       function context( _s: String): T_wp_v2_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/posts
     T_wp_v2_posts_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_posts_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_posts_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_posts_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_posts_get; 
       // optional, Limit response to posts published after a given ISO8601 compliant date.
       function after( _s: String): T_wp_v2_posts_get; 
       // optional, Limit response to posts modified after a given ISO8601 compliant date.
       function modified_after( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to posts assigned to specific authors.
       function author( _s: String): T_wp_v2_posts_get; 
       // optional, Ensure result set excludes posts assigned to specific authors.
       function author_exclude( _s: String): T_wp_v2_posts_get; 
       // optional, Limit response to posts published before a given ISO8601 compliant date.
       function before( _s: String): T_wp_v2_posts_get; 
       // optional, Limit response to posts modified before a given ISO8601 compliant date.
       function modified_before( _s: String): T_wp_v2_posts_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_posts_get; 
       // optional, How to interpret the search input.
       function search_semantics( _s: String): T_wp_v2_posts_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_posts_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_posts_get; 
       // optional, Sort collection by post attribute.
       function orderby( _s: String): T_wp_v2_posts_get; 
       // optional, Array of column names to be searched.
       function search_columns( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to posts with one or more specific slugs.
       function slug( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to posts assigned one or more statuses.
       function status( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set based on relationship between multiple taxonomies.
       function tax_relation( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to items with specific terms assigned in the categories taxonomy.
       function categories( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to items except those with specific terms assigned in the categories taxonomy.
       function categories_exclude( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to items with specific terms assigned in the tags taxonomy.
       function tags( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to items except those with specific terms assigned in the tags taxonomy.
       function tags_exclude( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to items that are sticky.
       function sticky( _s: String): T_wp_v2_posts_get; 
       // optional, Whether to ignore sticky posts or not.
       function ignore_sticky( _s: String): T_wp_v2_posts_get; 
       // optional, Limit result set to items assigned one or more given formats.
       function format_( _s: String): T_wp_v2_posts_get;  
     //Properties
     public
 
     end;

     T_wp_v2_posts_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_posts_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_posts_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_posts_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_posts_post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_posts_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_posts_post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_posts_post; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_posts_post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_posts_post; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_posts_post; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_posts_post; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_posts_post; 
       // The format for the post.
       function format_( _jd: TJSONData): T_wp_v2_posts_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_posts_post; 
       // Whether or not the post should be treated as sticky.
       function sticky( _jd: TJSONData): T_wp_v2_posts_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_posts_post; 
       // The terms assigned to the post in the category taxonomy.
       function categories( _jd: TJSONData): T_wp_v2_posts_post; 
       // The terms assigned to the post in the post_tag taxonomy.
       function tags( _jd: TJSONData): T_wp_v2_posts_post;  
     end;

 
     //Chemin  /wp/v2/posts/{id}
     T_wp_v2_posts__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_posts__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_posts__id__get; 
       // optional, Override the default excerpt length.
       function excerpt_length( _s: String): T_wp_v2_posts__id__get; 
       // optional, The password for the post if it is password protected.
       function password( _s: String): T_wp_v2_posts__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_posts__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_posts__id__post;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The format for the post.
       function format_( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // Whether or not the post should be treated as sticky.
       function sticky( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The terms assigned to the post in the category taxonomy.
       function categories( _jd: TJSONData): T_wp_v2_posts__id__post; 
       // The terms assigned to the post in the post_tag taxonomy.
       function tags( _jd: TJSONData): T_wp_v2_posts__id__post;  
     end;

     T_wp_v2_posts__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_posts__id__put;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The format for the post.
       function format_( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // Whether or not the post should be treated as sticky.
       function sticky( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The terms assigned to the post in the category taxonomy.
       function categories( _jd: TJSONData): T_wp_v2_posts__id__put; 
       // The terms assigned to the post in the post_tag taxonomy.
       function tags( _jd: TJSONData): T_wp_v2_posts__id__put;  
     end;

     T_wp_v2_posts__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_posts__id__patch;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The format for the post.
       function format_( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // Whether or not the post should be treated as sticky.
       function sticky( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The terms assigned to the post in the category taxonomy.
       function categories( _jd: TJSONData): T_wp_v2_posts__id__patch; 
       // The terms assigned to the post in the post_tag taxonomy.
       function tags( _jd: TJSONData): T_wp_v2_posts__id__patch;  
     end;

     T_wp_v2_posts__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_posts__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_posts__id__delete;  
     end;

 
     //Chemin  /wp/v2/posts/{parent}/revisions
     T_wp_v2_posts__parent__revisions_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_posts__parent__revisions_get; 
       // optional, Sort collection by object attribute.
       function orderby( _s: String): T_wp_v2_posts__parent__revisions_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/posts/{parent}/revisions/{id}
     T_wp_v2_posts__parent__revisions__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_posts__parent__revisions__id__get; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_posts__parent__revisions__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_posts__parent__revisions__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_posts__parent__revisions__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_posts__parent__revisions__id__delete; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_posts__parent__revisions__id__delete;  
     //Properties
     public
       // Required to be true, as revisions do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_posts__parent__revisions__id__delete;  
     end;

 
     //Chemin  /wp/v2/posts/{id}/autosaves
     T_wp_v2_posts__id__autosaves_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_posts__id__autosaves_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_posts__id__autosaves_get; 
       // required, 
       function id( _s: String): T_wp_v2_posts__id__autosaves_get;  
     //Properties
     public
 
     end;

     T_wp_v2_posts__id__autosaves_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_posts__id__autosaves_post;  
     //Properties
     public
       // The ID for the parent of the autosave.
       function parent( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The format for the post.
       function format_( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // Whether or not the post should be treated as sticky.
       function sticky( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The terms assigned to the post in the category taxonomy.
       function categories( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
       // The terms assigned to the post in the post_tag taxonomy.
       function tags( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post;  
     end;

 
     //Chemin  /wp/v2/posts/{parent}/autosaves/{id}
     T_wp_v2_posts__parent__autosaves__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_posts__parent__autosaves__id__get; 
       // required, The ID for the autosave.
       function id( _s: String): T_wp_v2_posts__parent__autosaves__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_posts__parent__autosaves__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/pages
     T_wp_v2_pages_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_pages_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_pages_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_pages_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_pages_get; 
       // optional, Limit response to posts published after a given ISO8601 compliant date.
       function after( _s: String): T_wp_v2_pages_get; 
       // optional, Limit response to posts modified after a given ISO8601 compliant date.
       function modified_after( _s: String): T_wp_v2_pages_get; 
       // optional, Limit result set to posts assigned to specific authors.
       function author( _s: String): T_wp_v2_pages_get; 
       // optional, Ensure result set excludes posts assigned to specific authors.
       function author_exclude( _s: String): T_wp_v2_pages_get; 
       // optional, Limit response to posts published before a given ISO8601 compliant date.
       function before( _s: String): T_wp_v2_pages_get; 
       // optional, Limit response to posts modified before a given ISO8601 compliant date.
       function modified_before( _s: String): T_wp_v2_pages_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_pages_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_pages_get; 
       // optional, Limit result set to posts with a specific menu_order value.
       function menu_order( _s: String): T_wp_v2_pages_get; 
       // optional, How to interpret the search input.
       function search_semantics( _s: String): T_wp_v2_pages_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_pages_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_pages_get; 
       // optional, Sort collection by post attribute.
       function orderby( _s: String): T_wp_v2_pages_get; 
       // optional, Limit result set to items with particular parent IDs.
       function parent( _s: String): T_wp_v2_pages_get; 
       // optional, Limit result set to all items except those of a particular parent ID.
       function parent_exclude( _s: String): T_wp_v2_pages_get; 
       // optional, Array of column names to be searched.
       function search_columns( _s: String): T_wp_v2_pages_get; 
       // optional, Limit result set to posts with one or more specific slugs.
       function slug( _s: String): T_wp_v2_pages_get; 
       // optional, Limit result set to posts assigned one or more statuses.
       function status( _s: String): T_wp_v2_pages_get;  
     //Properties
     public
 
     end;

     T_wp_v2_pages_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_pages_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_pages_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_pages_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_pages_post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_pages_post; 
       // The ID for the parent of the post.
       function parent( _jd: TJSONData): T_wp_v2_pages_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_pages_post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_pages_post; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_pages_post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_pages_post; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_pages_post; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_pages_post; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_pages_post; 
       // The order of the post in relation to other posts.
       function menu_order( _jd: TJSONData): T_wp_v2_pages_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_pages_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_pages_post;  
     end;

 
     //Chemin  /wp/v2/pages/{id}
     T_wp_v2_pages__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_pages__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_pages__id__get; 
       // optional, Override the default excerpt length.
       function excerpt_length( _s: String): T_wp_v2_pages__id__get; 
       // optional, The password for the post if it is password protected.
       function password( _s: String): T_wp_v2_pages__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_pages__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_pages__id__post;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The ID for the parent of the post.
       function parent( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The order of the post in relation to other posts.
       function menu_order( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_pages__id__post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_pages__id__post;  
     end;

     T_wp_v2_pages__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_pages__id__put;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The ID for the parent of the post.
       function parent( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The order of the post in relation to other posts.
       function menu_order( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_pages__id__put; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_pages__id__put;  
     end;

     T_wp_v2_pages__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_pages__id__patch;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The ID for the parent of the post.
       function parent( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The order of the post in relation to other posts.
       function menu_order( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_pages__id__patch; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_pages__id__patch;  
     end;

     T_wp_v2_pages__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_pages__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_pages__id__delete;  
     end;

 
     //Chemin  /wp/v2/pages/{parent}/revisions
     T_wp_v2_pages__parent__revisions_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_pages__parent__revisions_get; 
       // optional, Sort collection by object attribute.
       function orderby( _s: String): T_wp_v2_pages__parent__revisions_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/pages/{parent}/revisions/{id}
     T_wp_v2_pages__parent__revisions__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_pages__parent__revisions__id__get; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_pages__parent__revisions__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_pages__parent__revisions__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_pages__parent__revisions__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_pages__parent__revisions__id__delete; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_pages__parent__revisions__id__delete;  
     //Properties
     public
       // Required to be true, as revisions do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_pages__parent__revisions__id__delete;  
     end;

 
     //Chemin  /wp/v2/pages/{id}/autosaves
     T_wp_v2_pages__id__autosaves_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_pages__id__autosaves_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_pages__id__autosaves_get; 
       // required, 
       function id( _s: String): T_wp_v2_pages__id__autosaves_get;  
     //Properties
     public
 
     end;

     T_wp_v2_pages__id__autosaves_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_pages__id__autosaves_post;  
     //Properties
     public
       // The ID for the parent of the post.
       function parent( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The order of the post in relation to other posts.
       function menu_order( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post;  
     end;

 
     //Chemin  /wp/v2/pages/{parent}/autosaves/{id}
     T_wp_v2_pages__parent__autosaves__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_pages__parent__autosaves__id__get; 
       // required, The ID for the autosave.
       function id( _s: String): T_wp_v2_pages__parent__autosaves__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_pages__parent__autosaves__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/media
     T_wp_v2_media_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_media_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_media_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_media_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_media_get; 
       // optional, Limit response to posts published after a given ISO8601 compliant date.
       function after( _s: String): T_wp_v2_media_get; 
       // optional, Limit response to posts modified after a given ISO8601 compliant date.
       function modified_after( _s: String): T_wp_v2_media_get; 
       // optional, Limit result set to posts assigned to specific authors.
       function author( _s: String): T_wp_v2_media_get; 
       // optional, Ensure result set excludes posts assigned to specific authors.
       function author_exclude( _s: String): T_wp_v2_media_get; 
       // optional, Limit response to posts published before a given ISO8601 compliant date.
       function before( _s: String): T_wp_v2_media_get; 
       // optional, Limit response to posts modified before a given ISO8601 compliant date.
       function modified_before( _s: String): T_wp_v2_media_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_media_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_media_get; 
       // optional, How to interpret the search input.
       function search_semantics( _s: String): T_wp_v2_media_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_media_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_media_get; 
       // optional, Sort collection by post attribute.
       function orderby( _s: String): T_wp_v2_media_get; 
       // optional, Limit result set to items with particular parent IDs.
       function parent( _s: String): T_wp_v2_media_get; 
       // optional, Limit result set to all items except those of a particular parent ID.
       function parent_exclude( _s: String): T_wp_v2_media_get; 
       // optional, Array of column names to be searched.
       function search_columns( _s: String): T_wp_v2_media_get; 
       // optional, Limit result set to posts with one or more specific slugs.
       function slug( _s: String): T_wp_v2_media_get; 
       // optional, Limit result set to posts assigned one or more statuses.
       function status( _s: String): T_wp_v2_media_get; 
       // optional, Limit result set to attachments of a particular media type or media types.
       function media_type( _s: String): T_wp_v2_media_get; 
       // optional, Limit result set to attachments of a particular MIME type or MIME types.
       function mime_type( _s: String): T_wp_v2_media_get;  
     //Properties
     public
 
     end;

     T_wp_v2_media_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_media_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_media_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_media_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_media_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_media_post; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_media_post; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_media_post; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_media_post; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_media_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_media_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_media_post; 
       // Alternative text to display when attachment is not displayed.
       function alt_text( _jd: TJSONData): T_wp_v2_media_post; 
       // The attachment caption.
       function caption( _jd: TJSONData): T_wp_v2_media_post; 
       // The attachment description.
       function description( _jd: TJSONData): T_wp_v2_media_post; 
       // The ID for the associated post of the attachment.
       function post( _jd: TJSONData): T_wp_v2_media_post;  
     end;

 
     //Chemin  /wp/v2/media/{id}
     T_wp_v2_media__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_media__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_media__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_media__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_media__id__post;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_media__id__post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_media__id__post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_media__id__post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_media__id__post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_media__id__post; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_media__id__post; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_media__id__post; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_media__id__post; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_media__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_media__id__post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_media__id__post; 
       // Alternative text to display when attachment is not displayed.
       function alt_text( _jd: TJSONData): T_wp_v2_media__id__post; 
       // The attachment caption.
       function caption( _jd: TJSONData): T_wp_v2_media__id__post; 
       // The attachment description.
       function description( _jd: TJSONData): T_wp_v2_media__id__post; 
       // The ID for the associated post of the attachment.
       function post( _jd: TJSONData): T_wp_v2_media__id__post;  
     end;

     T_wp_v2_media__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_media__id__put;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_media__id__put; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_media__id__put; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_media__id__put; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_media__id__put; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_media__id__put; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_media__id__put; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_media__id__put; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_media__id__put; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_media__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_media__id__put; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_media__id__put; 
       // Alternative text to display when attachment is not displayed.
       function alt_text( _jd: TJSONData): T_wp_v2_media__id__put; 
       // The attachment caption.
       function caption( _jd: TJSONData): T_wp_v2_media__id__put; 
       // The attachment description.
       function description( _jd: TJSONData): T_wp_v2_media__id__put; 
       // The ID for the associated post of the attachment.
       function post( _jd: TJSONData): T_wp_v2_media__id__put;  
     end;

     T_wp_v2_media__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_media__id__patch;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // The ID for the author of the post.
       function author( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // The ID of the featured media for the post.
       function featured_media( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // Whether or not comments are open on the post.
       function comment_status( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // Whether or not the post can be pinged.
       function ping_status( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // Alternative text to display when attachment is not displayed.
       function alt_text( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // The attachment caption.
       function caption( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // The attachment description.
       function description( _jd: TJSONData): T_wp_v2_media__id__patch; 
       // The ID for the associated post of the attachment.
       function post( _jd: TJSONData): T_wp_v2_media__id__patch;  
     end;

     T_wp_v2_media__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_media__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_media__id__delete;  
     end;

 
     //Chemin  /wp/v2/media/{id}/post-process
     T_wp_v2_media__id__post_process_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the attachment.
       function id( _s: String): T_wp_v2_media__id__post_process_post;  
     //Properties
     public
       // 
       function action( _jd: TJSONData): T_wp_v2_media__id__post_process_post;  
     end;

 
     //Chemin  /wp/v2/media/{id}/edit
     T_wp_v2_media__id__edit_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_media__id__edit_post;  
     //Properties
     public
       // URL to the edited image file.
       function src( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // Array of image edits.
       function modifiers( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // The amount to rotate the image clockwise in degrees. DEPRECATED: Use `modifiers` instead.
       function rotation( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // As a percentage of the image, the x position to start the crop from. DEPRECATED: Use `modifiers` instead.
       function x( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // As a percentage of the image, the y position to start the crop from. DEPRECATED: Use `modifiers` instead.
       function y( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // As a percentage of the image, the width to crop the image to. DEPRECATED: Use `modifiers` instead.
       function width( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // As a percentage of the image, the height to crop the image to. DEPRECATED: Use `modifiers` instead.
       function height( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // The attachment caption.
       function caption( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // The attachment description.
       function description( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // The ID for the associated post of the attachment.
       function post( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
       // Alternative text to display when attachment is not displayed.
       function alt_text( _jd: TJSONData): T_wp_v2_media__id__edit_post;  
     end;

 
     //Chemin  /wp/v2/menu-items
     T_wp_v2_menu_items_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_menu_items_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_menu_items_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit response to posts published after a given ISO8601 compliant date.
       function after( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit response to posts modified after a given ISO8601 compliant date.
       function modified_after( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit response to posts published before a given ISO8601 compliant date.
       function before( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit response to posts modified before a given ISO8601 compliant date.
       function modified_before( _s: String): T_wp_v2_menu_items_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_menu_items_get; 
       // optional, How to interpret the search input.
       function search_semantics( _s: String): T_wp_v2_menu_items_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_menu_items_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_menu_items_get; 
       // optional, Sort collection by object attribute.
       function orderby( _s: String): T_wp_v2_menu_items_get; 
       // optional, Array of column names to be searched.
       function search_columns( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit result set to posts with one or more specific slugs.
       function slug( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit result set to posts assigned one or more statuses.
       function status( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit result set based on relationship between multiple taxonomies.
       function tax_relation( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit result set to items with specific terms assigned in the menus taxonomy.
       function menus( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit result set to items except those with specific terms assigned in the menus taxonomy.
       function menus_exclude( _s: String): T_wp_v2_menu_items_get; 
       // optional, Limit result set to posts with a specific menu_order value.
       function menu_order( _s: String): T_wp_v2_menu_items_get;  
     //Properties
     public
 
     end;

     T_wp_v2_menu_items_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // The title for the object.
       function title( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The family of objects originally represented, such as "post_type" or "taxonomy".
       function type_( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // A named status for the object.
       function status( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The ID for the parent of the object.
       function parent( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // Text for the title attribute of the link element for this menu item.
       function attr_title( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // Class names for the link element of this menu item.
       function classes( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The description of this menu item.
       function description( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The DB ID of the nav_menu_item that is this item's menu parent, if any, otherwise 0.
       function menu_order( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The type of object originally represented, such as "category", "post", or "attachment".
       function object_( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The database ID of the original object this menu item represents, for example the ID for posts or the term_id for categories.
       function object_id( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The target attribute of the link element for this menu item.
       function target( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The URL to which this menu item points.
       function url_( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The XFN relationship expressed in the link of this menu item.
       function xfn( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // The terms assigned to the object in the nav_menu taxonomy.
       function menus( _jd: TJSONData): T_wp_v2_menu_items_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menu_items_post;  
     end;

 
     //Chemin  /wp/v2/menu-items/{id}
     T_wp_v2_menu_items__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_menu_items__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_menu_items__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_menu_items__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_menu_items__id__post;  
     //Properties
     public
       // The title for the object.
       function title( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The family of objects originally represented, such as "post_type" or "taxonomy".
       function type_( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // A named status for the object.
       function status( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The ID for the parent of the object.
       function parent( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // Text for the title attribute of the link element for this menu item.
       function attr_title( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // Class names for the link element of this menu item.
       function classes( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The description of this menu item.
       function description( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The DB ID of the nav_menu_item that is this item's menu parent, if any, otherwise 0.
       function menu_order( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The type of object originally represented, such as "category", "post", or "attachment".
       function object_( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The database ID of the original object this menu item represents, for example the ID for posts or the term_id for categories.
       function object_id( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The target attribute of the link element for this menu item.
       function target( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The URL to which this menu item points.
       function url_( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The XFN relationship expressed in the link of this menu item.
       function xfn( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // The terms assigned to the object in the nav_menu taxonomy.
       function menus( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menu_items__id__post;  
     end;

     T_wp_v2_menu_items__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_menu_items__id__put;  
     //Properties
     public
       // The title for the object.
       function title( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The family of objects originally represented, such as "post_type" or "taxonomy".
       function type_( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // A named status for the object.
       function status( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The ID for the parent of the object.
       function parent( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // Text for the title attribute of the link element for this menu item.
       function attr_title( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // Class names for the link element of this menu item.
       function classes( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The description of this menu item.
       function description( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The DB ID of the nav_menu_item that is this item's menu parent, if any, otherwise 0.
       function menu_order( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The type of object originally represented, such as "category", "post", or "attachment".
       function object_( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The database ID of the original object this menu item represents, for example the ID for posts or the term_id for categories.
       function object_id( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The target attribute of the link element for this menu item.
       function target( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The URL to which this menu item points.
       function url_( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The XFN relationship expressed in the link of this menu item.
       function xfn( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // The terms assigned to the object in the nav_menu taxonomy.
       function menus( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menu_items__id__put;  
     end;

     T_wp_v2_menu_items__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_menu_items__id__patch;  
     //Properties
     public
       // The title for the object.
       function title( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The family of objects originally represented, such as "post_type" or "taxonomy".
       function type_( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // A named status for the object.
       function status( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The ID for the parent of the object.
       function parent( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // Text for the title attribute of the link element for this menu item.
       function attr_title( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // Class names for the link element of this menu item.
       function classes( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The description of this menu item.
       function description( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The DB ID of the nav_menu_item that is this item's menu parent, if any, otherwise 0.
       function menu_order( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The type of object originally represented, such as "category", "post", or "attachment".
       function object_( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The database ID of the original object this menu item represents, for example the ID for posts or the term_id for categories.
       function object_id( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The target attribute of the link element for this menu item.
       function target( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The URL to which this menu item points.
       function url_( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The XFN relationship expressed in the link of this menu item.
       function xfn( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // The terms assigned to the object in the nav_menu taxonomy.
       function menus( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menu_items__id__patch;  
     end;

     T_wp_v2_menu_items__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_menu_items__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_menu_items__id__delete;  
     end;

 
     //Chemin  /wp/v2/menu-items/{id}/autosaves
     T_wp_v2_menu_items__id__autosaves_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_menu_items__id__autosaves_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_menu_items__id__autosaves_get; 
       // required, 
       function id( _s: String): T_wp_v2_menu_items__id__autosaves_get;  
     //Properties
     public
 
     end;

     T_wp_v2_menu_items__id__autosaves_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_menu_items__id__autosaves_post;  
     //Properties
     public
       // The ID for the parent of the object.
       function parent( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The title for the object.
       function title( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The family of objects originally represented, such as "post_type" or "taxonomy".
       function type_( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // A named status for the object.
       function status( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // Text for the title attribute of the link element for this menu item.
       function attr_title( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // Class names for the link element of this menu item.
       function classes( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The description of this menu item.
       function description( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The DB ID of the nav_menu_item that is this item's menu parent, if any, otherwise 0.
       function menu_order( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The type of object originally represented, such as "category", "post", or "attachment".
       function object_( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The database ID of the original object this menu item represents, for example the ID for posts or the term_id for categories.
       function object_id( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The target attribute of the link element for this menu item.
       function target( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The URL to which this menu item points.
       function url_( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The XFN relationship expressed in the link of this menu item.
       function xfn( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // The terms assigned to the object in the nav_menu taxonomy.
       function menus( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post;  
     end;

 
     //Chemin  /wp/v2/menu-items/{parent}/autosaves/{id}
     T_wp_v2_menu_items__parent__autosaves__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_menu_items__parent__autosaves__id__get; 
       // required, The ID for the autosave.
       function id( _s: String): T_wp_v2_menu_items__parent__autosaves__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_menu_items__parent__autosaves__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/blocks
     T_wp_v2_blocks_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_blocks_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_blocks_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit response to posts published after a given ISO8601 compliant date.
       function after( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit response to posts modified after a given ISO8601 compliant date.
       function modified_after( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit response to posts published before a given ISO8601 compliant date.
       function before( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit response to posts modified before a given ISO8601 compliant date.
       function modified_before( _s: String): T_wp_v2_blocks_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_blocks_get; 
       // optional, How to interpret the search input.
       function search_semantics( _s: String): T_wp_v2_blocks_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_blocks_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_blocks_get; 
       // optional, Sort collection by post attribute.
       function orderby( _s: String): T_wp_v2_blocks_get; 
       // optional, Array of column names to be searched.
       function search_columns( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit result set to posts with one or more specific slugs.
       function slug( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit result set to posts assigned one or more statuses.
       function status( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit result set based on relationship between multiple taxonomies.
       function tax_relation( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit result set to items with specific terms assigned in the wp_pattern_category taxonomy.
       function wp_pattern_category( _s: String): T_wp_v2_blocks_get; 
       // optional, Limit result set to items except those with specific terms assigned in the wp_pattern_category taxonomy.
       function wp_pattern_category_exclude( _s: String): T_wp_v2_blocks_get;  
     //Properties
     public
 
     end;

     T_wp_v2_blocks_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_blocks_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_blocks_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_blocks_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_blocks_post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_blocks_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_blocks_post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_blocks_post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_blocks_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_blocks_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_blocks_post; 
       // The terms assigned to the post in the wp_pattern_category taxonomy.
       function wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks_post;  
     end;

 
     //Chemin  /wp/v2/blocks/{id}
     T_wp_v2_blocks__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_blocks__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_blocks__id__get; 
       // optional, Override the default excerpt length.
       function excerpt_length( _s: String): T_wp_v2_blocks__id__get; 
       // optional, The password for the post if it is password protected.
       function password( _s: String): T_wp_v2_blocks__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_blocks__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_blocks__id__post;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_blocks__id__post; 
       // The terms assigned to the post in the wp_pattern_category taxonomy.
       function wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks__id__post;  
     end;

     T_wp_v2_blocks__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_blocks__id__put;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_blocks__id__put; 
       // The terms assigned to the post in the wp_pattern_category taxonomy.
       function wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks__id__put;  
     end;

     T_wp_v2_blocks__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_blocks__id__patch;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
       // The terms assigned to the post in the wp_pattern_category taxonomy.
       function wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks__id__patch;  
     end;

     T_wp_v2_blocks__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_blocks__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_blocks__id__delete;  
     end;

 
     //Chemin  /wp/v2/blocks/{parent}/revisions
     T_wp_v2_blocks__parent__revisions_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_blocks__parent__revisions_get; 
       // optional, Sort collection by object attribute.
       function orderby( _s: String): T_wp_v2_blocks__parent__revisions_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/blocks/{parent}/revisions/{id}
     T_wp_v2_blocks__parent__revisions__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_blocks__parent__revisions__id__get; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_blocks__parent__revisions__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_blocks__parent__revisions__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_blocks__parent__revisions__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_blocks__parent__revisions__id__delete; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_blocks__parent__revisions__id__delete;  
     //Properties
     public
       // Required to be true, as revisions do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_blocks__parent__revisions__id__delete;  
     end;

 
     //Chemin  /wp/v2/blocks/{id}/autosaves
     T_wp_v2_blocks__id__autosaves_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_blocks__id__autosaves_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_blocks__id__autosaves_get; 
       // required, 
       function id( _s: String): T_wp_v2_blocks__id__autosaves_get;  
     //Properties
     public
 
     end;

     T_wp_v2_blocks__id__autosaves_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_blocks__id__autosaves_post;  
     //Properties
     public
       // The ID for the parent of the autosave.
       function parent( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // The excerpt for the post.
       function excerpt( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
       // The terms assigned to the post in the wp_pattern_category taxonomy.
       function wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post;  
     end;

 
     //Chemin  /wp/v2/blocks/{parent}/autosaves/{id}
     T_wp_v2_blocks__parent__autosaves__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_blocks__parent__autosaves__id__get; 
       // required, The ID for the autosave.
       function id( _s: String): T_wp_v2_blocks__parent__autosaves__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_blocks__parent__autosaves__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/templates/{parent}/revisions
     T_wp_v2_templates__parent__revisions_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function parent( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_templates__parent__revisions_get; 
       // optional, Sort collection by object attribute.
       function orderby( _s: String): T_wp_v2_templates__parent__revisions_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/templates/{parent}/revisions/{id}
     T_wp_v2_templates__parent__revisions__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function parent( _s: String): T_wp_v2_templates__parent__revisions__id__get; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_templates__parent__revisions__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_templates__parent__revisions__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_templates__parent__revisions__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function parent( _s: String): T_wp_v2_templates__parent__revisions__id__delete; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_templates__parent__revisions__id__delete;  
     //Properties
     public
       // Required to be true, as revisions do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_templates__parent__revisions__id__delete;  
     end;

 
     //Chemin  /wp/v2/templates/{id}/autosaves
     T_wp_v2_templates__id__autosaves_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_templates__id__autosaves_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_templates__id__autosaves_get;  
     //Properties
     public
 
     end;

     T_wp_v2_templates__id__autosaves_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_templates__id__autosaves_post;  
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post;  
     end;

 
     //Chemin  /wp/v2/templates/{parent}/autosaves/{id}
     T_wp_v2_templates__parent__autosaves__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function parent( _s: String): T_wp_v2_templates__parent__autosaves__id__get; 
       // required, The ID for the autosave.
       function id( _s: String): T_wp_v2_templates__parent__autosaves__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_templates__parent__autosaves__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/templates
     T_wp_v2_templates_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_templates_get; 
       // optional, Limit to the specified post id.
       function wp_id( _s: String): T_wp_v2_templates_get; 
       // optional, Limit to the specified template part area.
       function area( _s: String): T_wp_v2_templates_get; 
       // optional, Post type to get the templates for.
       function post_type( _s: String): T_wp_v2_templates_get;  
     //Properties
     public
 
     end;

     T_wp_v2_templates_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_templates_post; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_templates_post; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_templates_post; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_templates_post; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_templates_post; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_templates_post; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_templates_post; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_templates_post;  
     end;

 
     //Chemin  /wp/v2/templates/lookup
     T_wp_v2_templates_lookup_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The slug of the template to get the fallback for
       function slug( _s: String): T_wp_v2_templates_lookup_get; 
       // optional, Indicates if a template is custom or part of the template hierarchy
       function is_custom( _s: String): T_wp_v2_templates_lookup_get; 
       // optional, The template prefix for the created template. This is used to extract the main template type, e.g. in `taxonomy-books` extracts the `taxonomy`
       function template_prefix( _s: String): T_wp_v2_templates_lookup_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/templates/{id}
     T_wp_v2_templates__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_templates__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_templates__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_templates__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_templates__id__post;  
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_templates__id__post; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_templates__id__post; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_templates__id__post; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_templates__id__post; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_templates__id__post; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_templates__id__post; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_templates__id__post; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_templates__id__post;  
     end;

     T_wp_v2_templates__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_templates__id__put;  
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_templates__id__put; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_templates__id__put; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_templates__id__put; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_templates__id__put; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_templates__id__put; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_templates__id__put; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_templates__id__put; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_templates__id__put;  
     end;

     T_wp_v2_templates__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_templates__id__patch;  
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_templates__id__patch; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_templates__id__patch; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_templates__id__patch; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_templates__id__patch; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_templates__id__patch; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_templates__id__patch; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_templates__id__patch; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_templates__id__patch;  
     end;

     T_wp_v2_templates__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_templates__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_templates__id__delete;  
     end;

 
     //Chemin  /wp/v2/template-parts/{parent}/revisions
     T_wp_v2_template_parts__parent__revisions_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function parent( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
       // optional, Sort collection by object attribute.
       function orderby( _s: String): T_wp_v2_template_parts__parent__revisions_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/template-parts/{parent}/revisions/{id}
     T_wp_v2_template_parts__parent__revisions__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function parent( _s: String): T_wp_v2_template_parts__parent__revisions__id__get; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_template_parts__parent__revisions__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_template_parts__parent__revisions__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_template_parts__parent__revisions__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function parent( _s: String): T_wp_v2_template_parts__parent__revisions__id__delete; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_template_parts__parent__revisions__id__delete;  
     //Properties
     public
       // Required to be true, as revisions do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_template_parts__parent__revisions__id__delete;  
     end;

 
     //Chemin  /wp/v2/template-parts/{id}/autosaves
     T_wp_v2_template_parts__id__autosaves_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_template_parts__id__autosaves_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_template_parts__id__autosaves_get;  
     //Properties
     public
 
     end;

     T_wp_v2_template_parts__id__autosaves_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_template_parts__id__autosaves_post;  
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
       // Where the template part is intended for use (header, footer, etc.)
       function area( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post;  
     end;

 
     //Chemin  /wp/v2/template-parts/{parent}/autosaves/{id}
     T_wp_v2_template_parts__parent__autosaves__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function parent( _s: String): T_wp_v2_template_parts__parent__autosaves__id__get; 
       // required, The ID for the autosave.
       function id( _s: String): T_wp_v2_template_parts__parent__autosaves__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_template_parts__parent__autosaves__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/template-parts
     T_wp_v2_template_parts_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_template_parts_get; 
       // optional, Limit to the specified post id.
       function wp_id( _s: String): T_wp_v2_template_parts_get; 
       // optional, Limit to the specified template part area.
       function area( _s: String): T_wp_v2_template_parts_get; 
       // optional, Post type to get the templates for.
       function post_type( _s: String): T_wp_v2_template_parts_get;  
     //Properties
     public
 
     end;

     T_wp_v2_template_parts_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_template_parts_post; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_template_parts_post; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_template_parts_post; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_template_parts_post; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_template_parts_post; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_template_parts_post; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_template_parts_post; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_template_parts_post; 
       // Where the template part is intended for use (header, footer, etc.)
       function area( _jd: TJSONData): T_wp_v2_template_parts_post;  
     end;

 
     //Chemin  /wp/v2/template-parts/lookup
     T_wp_v2_template_parts_lookup_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The slug of the template to get the fallback for
       function slug( _s: String): T_wp_v2_template_parts_lookup_get; 
       // optional, Indicates if a template is custom or part of the template hierarchy
       function is_custom( _s: String): T_wp_v2_template_parts_lookup_get; 
       // optional, The template prefix for the created template. This is used to extract the main template type, e.g. in `taxonomy-books` extracts the `taxonomy`
       function template_prefix( _s: String): T_wp_v2_template_parts_lookup_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/template-parts/{id}
     T_wp_v2_template_parts__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_template_parts__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_template_parts__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_template_parts__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_template_parts__id__post;  
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
       // Where the template part is intended for use (header, footer, etc.)
       function area( _jd: TJSONData): T_wp_v2_template_parts__id__post;  
     end;

     T_wp_v2_template_parts__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_template_parts__id__put;  
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
       // Where the template part is intended for use (header, footer, etc.)
       function area( _jd: TJSONData): T_wp_v2_template_parts__id__put;  
     end;

     T_wp_v2_template_parts__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_template_parts__id__patch;  
     //Properties
     public
       // Unique slug identifying the template.
       function slug( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
       // Theme identifier for the template.
       function theme( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
       // Type of template.
       function type_( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
       // Content of template.
       function content( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
       // Title of template.
       function title( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
       // Description of template.
       function description( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
       // Status of template.
       function status( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
       // The ID for the author of the template.
       function author( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
       // Where the template part is intended for use (header, footer, etc.)
       function area( _jd: TJSONData): T_wp_v2_template_parts__id__patch;  
     end;

     T_wp_v2_template_parts__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a template
       function id( _s: String): T_wp_v2_template_parts__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_template_parts__id__delete;  
     end;

 
     //Chemin  /wp/v2/global-styles/{parent}/revisions
     T_wp_v2_global_styles__parent__revisions_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_global_styles__parent__revisions_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/global-styles/{parent}/revisions/{id}
     T_wp_v2_global_styles__parent__revisions__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the global styles revision.
       function parent( _s: String): T_wp_v2_global_styles__parent__revisions__id__get; 
       // required, Unique identifier for the global styles revision.
       function id( _s: String): T_wp_v2_global_styles__parent__revisions__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_global_styles__parent__revisions__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/global-styles/themes/{stylesheet}/variations
     T_wp_v2_global_styles_themes__stylesheet__variations_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The theme identifier
       function stylesheet( _s: String): T_wp_v2_global_styles_themes__stylesheet__variations_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/global-styles/themes/{stylesheet}
     T_wp_v2_global_styles_themes__stylesheet__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The theme identifier
       function stylesheet( _s: String): T_wp_v2_global_styles_themes__stylesheet__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/global-styles/{id}
     T_wp_v2_global_styles__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, ID of global styles config.
       function id( _s: String): T_wp_v2_global_styles__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_global_styles__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_global_styles__id__post;  
     //Properties
     public
       // Global styles.
       function styles( _jd: TJSONData): T_wp_v2_global_styles__id__post; 
       // Global settings.
       function settings( _jd: TJSONData): T_wp_v2_global_styles__id__post; 
       // Title of the global styles variation.
       function title( _jd: TJSONData): T_wp_v2_global_styles__id__post;  
     end;

     T_wp_v2_global_styles__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_global_styles__id__put;  
     //Properties
     public
       // Global styles.
       function styles( _jd: TJSONData): T_wp_v2_global_styles__id__put; 
       // Global settings.
       function settings( _jd: TJSONData): T_wp_v2_global_styles__id__put; 
       // Title of the global styles variation.
       function title( _jd: TJSONData): T_wp_v2_global_styles__id__put;  
     end;

     T_wp_v2_global_styles__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_global_styles__id__patch;  
     //Properties
     public
       // Global styles.
       function styles( _jd: TJSONData): T_wp_v2_global_styles__id__patch; 
       // Global settings.
       function settings( _jd: TJSONData): T_wp_v2_global_styles__id__patch; 
       // Title of the global styles variation.
       function title( _jd: TJSONData): T_wp_v2_global_styles__id__patch;  
     end;

 
     //Chemin  /wp/v2/navigation
     T_wp_v2_navigation_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_navigation_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_navigation_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_navigation_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_navigation_get; 
       // optional, Limit response to posts published after a given ISO8601 compliant date.
       function after( _s: String): T_wp_v2_navigation_get; 
       // optional, Limit response to posts modified after a given ISO8601 compliant date.
       function modified_after( _s: String): T_wp_v2_navigation_get; 
       // optional, Limit response to posts published before a given ISO8601 compliant date.
       function before( _s: String): T_wp_v2_navigation_get; 
       // optional, Limit response to posts modified before a given ISO8601 compliant date.
       function modified_before( _s: String): T_wp_v2_navigation_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_navigation_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_navigation_get; 
       // optional, How to interpret the search input.
       function search_semantics( _s: String): T_wp_v2_navigation_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_navigation_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_navigation_get; 
       // optional, Sort collection by post attribute.
       function orderby( _s: String): T_wp_v2_navigation_get; 
       // optional, Array of column names to be searched.
       function search_columns( _s: String): T_wp_v2_navigation_get; 
       // optional, Limit result set to posts with one or more specific slugs.
       function slug( _s: String): T_wp_v2_navigation_get; 
       // optional, Limit result set to posts assigned one or more statuses.
       function status( _s: String): T_wp_v2_navigation_get;  
     //Properties
     public
 
     end;

     T_wp_v2_navigation_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_navigation_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_navigation_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_navigation_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_navigation_post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_navigation_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_navigation_post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_navigation_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_navigation_post;  
     end;

 
     //Chemin  /wp/v2/navigation/{id}
     T_wp_v2_navigation__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_navigation__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_navigation__id__get; 
       // optional, The password for the post if it is password protected.
       function password( _s: String): T_wp_v2_navigation__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_navigation__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_navigation__id__post;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_navigation__id__post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_navigation__id__post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_navigation__id__post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_navigation__id__post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_navigation__id__post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_navigation__id__post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_navigation__id__post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_navigation__id__post;  
     end;

     T_wp_v2_navigation__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_navigation__id__put;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_navigation__id__put; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_navigation__id__put; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_navigation__id__put; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_navigation__id__put; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_navigation__id__put; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_navigation__id__put; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_navigation__id__put; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_navigation__id__put;  
     end;

     T_wp_v2_navigation__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_navigation__id__patch;  
     //Properties
     public
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_navigation__id__patch;  
     end;

     T_wp_v2_navigation__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_navigation__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_navigation__id__delete;  
     end;

 
     //Chemin  /wp/v2/navigation/{parent}/revisions
     T_wp_v2_navigation__parent__revisions_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_navigation__parent__revisions_get; 
       // optional, Sort collection by object attribute.
       function orderby( _s: String): T_wp_v2_navigation__parent__revisions_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/navigation/{parent}/revisions/{id}
     T_wp_v2_navigation__parent__revisions__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_navigation__parent__revisions__id__get; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_navigation__parent__revisions__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_navigation__parent__revisions__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_navigation__parent__revisions__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the revision.
       function parent( _s: String): T_wp_v2_navigation__parent__revisions__id__delete; 
       // required, Unique identifier for the revision.
       function id( _s: String): T_wp_v2_navigation__parent__revisions__id__delete;  
     //Properties
     public
       // Required to be true, as revisions do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_navigation__parent__revisions__id__delete;  
     end;

 
     //Chemin  /wp/v2/navigation/{id}/autosaves
     T_wp_v2_navigation__id__autosaves_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_navigation__id__autosaves_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_navigation__id__autosaves_get; 
       // required, 
       function id( _s: String): T_wp_v2_navigation__id__autosaves_get;  
     //Properties
     public
 
     end;

     T_wp_v2_navigation__id__autosaves_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_navigation__id__autosaves_post;  
     //Properties
     public
       // The ID for the parent of the autosave.
       function parent( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
       // The date the post was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
       // The date the post was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
       // An alphanumeric identifier for the post unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
       // A named status for the post.
       function status( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
       // A password to protect access to the content and excerpt.
       function password( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
       // The title for the post.
       function title( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
       // The content for the post.
       function content( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
       // The theme file to use to display the post.
       function template( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post;  
     end;

 
     //Chemin  /wp/v2/navigation/{parent}/autosaves/{id}
     T_wp_v2_navigation__parent__autosaves__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent of the autosave.
       function parent( _s: String): T_wp_v2_navigation__parent__autosaves__id__get; 
       // required, The ID for the autosave.
       function id( _s: String): T_wp_v2_navigation__parent__autosaves__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_navigation__parent__autosaves__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/font-families
     T_wp_v2_font_families_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_font_families_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_font_families_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_font_families_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_font_families_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_font_families_get; 
       // optional, How to interpret the search input.
       function search_semantics( _s: String): T_wp_v2_font_families_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_font_families_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_font_families_get; 
       // optional, Sort collection by post attribute.
       function orderby( _s: String): T_wp_v2_font_families_get; 
       // optional, Limit result set to posts with one or more specific slugs.
       function slug( _s: String): T_wp_v2_font_families_get;  
     //Properties
     public
 
     end;

     T_wp_v2_font_families_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Version of the theme.json schema used for the typography settings.
       function theme_json_version( _jd: TJSONData): T_wp_v2_font_families_post; 
       // font-family declaration in theme.json format, encoded as a string.
       function font_family_settings( _jd: TJSONData): T_wp_v2_font_families_post;  
     end;

 
     //Chemin  /wp/v2/font-families/{id}
     T_wp_v2_font_families__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_font_families__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_font_families__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_font_families__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_font_families__id__post;  
     //Properties
     public
       // Version of the theme.json schema used for the typography settings.
       function theme_json_version( _jd: TJSONData): T_wp_v2_font_families__id__post; 
       // font-family declaration in theme.json format, encoded as a string.
       function font_family_settings( _jd: TJSONData): T_wp_v2_font_families__id__post;  
     end;

     T_wp_v2_font_families__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_font_families__id__put;  
     //Properties
     public
       // Version of the theme.json schema used for the typography settings.
       function theme_json_version( _jd: TJSONData): T_wp_v2_font_families__id__put; 
       // font-family declaration in theme.json format, encoded as a string.
       function font_family_settings( _jd: TJSONData): T_wp_v2_font_families__id__put;  
     end;

     T_wp_v2_font_families__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_font_families__id__patch;  
     //Properties
     public
       // Version of the theme.json schema used for the typography settings.
       function theme_json_version( _jd: TJSONData): T_wp_v2_font_families__id__patch; 
       // font-family declaration in theme.json format, encoded as a string.
       function font_family_settings( _jd: TJSONData): T_wp_v2_font_families__id__patch;  
     end;

     T_wp_v2_font_families__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the post.
       function id( _s: String): T_wp_v2_font_families__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_font_families__id__delete;  
     end;

 
     //Chemin  /wp/v2/font-families/{font_family_id}/font-faces
     T_wp_v2_font_families__font_family_id__font_faces_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent font family of the font face.
       function font_family_id( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, How to interpret the search input.
       function search_semantics( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
       // optional, Sort collection by post attribute.
       function orderby( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get;  
     //Properties
     public
 
     end;

     T_wp_v2_font_families__font_family_id__font_faces_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent font family of the font face.
       function font_family_id( _s: String): T_wp_v2_font_families__font_family_id__font_faces_post;  
     //Properties
     public
       // Version of the theme.json schema used for the typography settings.
       function theme_json_version( _jd: TJSONData): T_wp_v2_font_families__font_family_id__font_faces_post; 
       // font-face declaration in theme.json format, encoded as a string.
       function font_face_settings( _jd: TJSONData): T_wp_v2_font_families__font_family_id__font_faces_post;  
     end;

 
     //Chemin  /wp/v2/font-families/{font_family_id}/font-faces/{id}
     T_wp_v2_font_families__font_family_id__font_faces__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent font family of the font face.
       function font_family_id( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__get; 
       // required, Unique identifier for the font face.
       function id( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_font_families__font_family_id__font_faces__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The ID for the parent font family of the font face.
       function font_family_id( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__delete; 
       // required, Unique identifier for the font face.
       function id( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_font_families__font_family_id__font_faces__id__delete;  
     end;

 
     //Chemin  /wp/v2/types
     T_wp_v2_types_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_types_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/types/{type}
     T_wp_v2_types__type__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, An alphanumeric identifier for the post type.
       function type_( _s: String): T_wp_v2_types__type__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_types__type__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/statuses
     T_wp_v2_statuses_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_statuses_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/statuses/{status}
     T_wp_v2_statuses__status__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, An alphanumeric identifier for the status.
       function status( _s: String): T_wp_v2_statuses__status__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_statuses__status__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/taxonomies
     T_wp_v2_taxonomies_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_taxonomies_get; 
       // optional, Limit results to taxonomies associated with a specific post type.
       function type_( _s: String): T_wp_v2_taxonomies_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/taxonomies/{taxonomy}
     T_wp_v2_taxonomies__taxonomy__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, An alphanumeric identifier for the taxonomy.
       function taxonomy( _s: String): T_wp_v2_taxonomies__taxonomy__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_taxonomies__taxonomy__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/categories
     T_wp_v2_categories_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_categories_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_categories_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_categories_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_categories_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_categories_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_categories_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_categories_get; 
       // optional, Sort collection by term attribute.
       function orderby( _s: String): T_wp_v2_categories_get; 
       // optional, Whether to hide terms not assigned to any posts.
       function hide_empty( _s: String): T_wp_v2_categories_get; 
       // optional, Limit result set to terms assigned to a specific parent.
       function parent( _s: String): T_wp_v2_categories_get; 
       // optional, Limit result set to terms assigned to a specific post.
       function post( _s: String): T_wp_v2_categories_get; 
       // optional, Limit result set to terms with one or more specific slugs.
       function slug( _s: String): T_wp_v2_categories_get;  
     //Properties
     public
 
     end;

     T_wp_v2_categories_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_categories_post; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_categories_post; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_categories_post; 
       // The parent term ID.
       function parent( _jd: TJSONData): T_wp_v2_categories_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_categories_post;  
     end;

 
     //Chemin  /wp/v2/categories/{id}
     T_wp_v2_categories__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_categories__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_categories__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_categories__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_categories__id__post;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_categories__id__post; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_categories__id__post; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_categories__id__post; 
       // The parent term ID.
       function parent( _jd: TJSONData): T_wp_v2_categories__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_categories__id__post;  
     end;

     T_wp_v2_categories__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_categories__id__put;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_categories__id__put; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_categories__id__put; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_categories__id__put; 
       // The parent term ID.
       function parent( _jd: TJSONData): T_wp_v2_categories__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_categories__id__put;  
     end;

     T_wp_v2_categories__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_categories__id__patch;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_categories__id__patch; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_categories__id__patch; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_categories__id__patch; 
       // The parent term ID.
       function parent( _jd: TJSONData): T_wp_v2_categories__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_categories__id__patch;  
     end;

     T_wp_v2_categories__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_categories__id__delete;  
     //Properties
     public
       // Required to be true, as terms do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_categories__id__delete;  
     end;

 
     //Chemin  /wp/v2/tags
     T_wp_v2_tags_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_tags_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_tags_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_tags_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_tags_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_tags_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_tags_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_tags_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_tags_get; 
       // optional, Sort collection by term attribute.
       function orderby( _s: String): T_wp_v2_tags_get; 
       // optional, Whether to hide terms not assigned to any posts.
       function hide_empty( _s: String): T_wp_v2_tags_get; 
       // optional, Limit result set to terms assigned to a specific post.
       function post( _s: String): T_wp_v2_tags_get; 
       // optional, Limit result set to terms with one or more specific slugs.
       function slug( _s: String): T_wp_v2_tags_get;  
     //Properties
     public
 
     end;

     T_wp_v2_tags_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_tags_post; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_tags_post; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_tags_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_tags_post;  
     end;

 
     //Chemin  /wp/v2/tags/{id}
     T_wp_v2_tags__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_tags__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_tags__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_tags__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_tags__id__post;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_tags__id__post; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_tags__id__post; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_tags__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_tags__id__post;  
     end;

     T_wp_v2_tags__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_tags__id__put;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_tags__id__put; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_tags__id__put; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_tags__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_tags__id__put;  
     end;

     T_wp_v2_tags__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_tags__id__patch;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_tags__id__patch; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_tags__id__patch; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_tags__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_tags__id__patch;  
     end;

     T_wp_v2_tags__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_tags__id__delete;  
     //Properties
     public
       // Required to be true, as terms do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_tags__id__delete;  
     end;

 
     //Chemin  /wp/v2/menus
     T_wp_v2_menus_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_menus_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_menus_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_menus_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_menus_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_menus_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_menus_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_menus_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_menus_get; 
       // optional, Sort collection by term attribute.
       function orderby( _s: String): T_wp_v2_menus_get; 
       // optional, Whether to hide terms not assigned to any posts.
       function hide_empty( _s: String): T_wp_v2_menus_get; 
       // optional, Limit result set to terms assigned to a specific post.
       function post( _s: String): T_wp_v2_menus_get; 
       // optional, Limit result set to terms with one or more specific slugs.
       function slug( _s: String): T_wp_v2_menus_get;  
     //Properties
     public
 
     end;

     T_wp_v2_menus_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_menus_post; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_menus_post; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_menus_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menus_post; 
       // The locations assigned to the menu.
       function locations( _jd: TJSONData): T_wp_v2_menus_post; 
       // Whether to automatically add top level pages to this menu.
       function auto_add( _jd: TJSONData): T_wp_v2_menus_post;  
     end;

 
     //Chemin  /wp/v2/menus/{id}
     T_wp_v2_menus__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_menus__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_menus__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_menus__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_menus__id__post;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_menus__id__post; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_menus__id__post; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_menus__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menus__id__post; 
       // The locations assigned to the menu.
       function locations( _jd: TJSONData): T_wp_v2_menus__id__post; 
       // Whether to automatically add top level pages to this menu.
       function auto_add( _jd: TJSONData): T_wp_v2_menus__id__post;  
     end;

     T_wp_v2_menus__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_menus__id__put;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_menus__id__put; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_menus__id__put; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_menus__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menus__id__put; 
       // The locations assigned to the menu.
       function locations( _jd: TJSONData): T_wp_v2_menus__id__put; 
       // Whether to automatically add top level pages to this menu.
       function auto_add( _jd: TJSONData): T_wp_v2_menus__id__put;  
     end;

     T_wp_v2_menus__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_menus__id__patch;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_menus__id__patch; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_menus__id__patch; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_menus__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_menus__id__patch; 
       // The locations assigned to the menu.
       function locations( _jd: TJSONData): T_wp_v2_menus__id__patch; 
       // Whether to automatically add top level pages to this menu.
       function auto_add( _jd: TJSONData): T_wp_v2_menus__id__patch;  
     end;

     T_wp_v2_menus__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_menus__id__delete;  
     //Properties
     public
       // Required to be true, as terms do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_menus__id__delete;  
     end;

 
     //Chemin  /wp/v2/wp_pattern_category
     T_wp_v2_wp_pattern_category_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Sort collection by term attribute.
       function orderby( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Whether to hide terms not assigned to any posts.
       function hide_empty( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Limit result set to terms assigned to a specific post.
       function post( _s: String): T_wp_v2_wp_pattern_category_get; 
       // optional, Limit result set to terms with one or more specific slugs.
       function slug( _s: String): T_wp_v2_wp_pattern_category_get;  
     //Properties
     public
 
     end;

     T_wp_v2_wp_pattern_category_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_wp_pattern_category_post; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_wp_pattern_category_post; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_wp_pattern_category_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_wp_pattern_category_post;  
     end;

 
     //Chemin  /wp/v2/wp_pattern_category/{id}
     T_wp_v2_wp_pattern_category__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_wp_pattern_category__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_wp_pattern_category__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_wp_pattern_category__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_wp_pattern_category__id__post;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__post; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__post; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__post;  
     end;

     T_wp_v2_wp_pattern_category__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_wp_pattern_category__id__put;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__put; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__put; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__put;  
     end;

     T_wp_v2_wp_pattern_category__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_wp_pattern_category__id__patch;  
     //Properties
     public
       // HTML description of the term.
       function description( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__patch; 
       // HTML title for the term.
       function name( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__patch; 
       // An alphanumeric identifier for the term unique to its type.
       function slug( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__patch;  
     end;

     T_wp_v2_wp_pattern_category__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the term.
       function id( _s: String): T_wp_v2_wp_pattern_category__id__delete;  
     //Properties
     public
       // Required to be true, as terms do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__delete;  
     end;

 
     //Chemin  /wp/v2/users
     T_wp_v2_users_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_users_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_users_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_users_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_users_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_users_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_users_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_users_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_users_get; 
       // optional, Sort collection by user attribute.
       function orderby( _s: String): T_wp_v2_users_get; 
       // optional, Limit result set to users with one or more specific slugs.
       function slug( _s: String): T_wp_v2_users_get; 
       // optional, Limit result set to users matching at least one specific role provided. Accepts csv list or single role.
       function roles( _s: String): T_wp_v2_users_get; 
       // optional, Limit result set to users matching at least one specific capability provided. Accepts csv list or single capability.
       function capabilities( _s: String): T_wp_v2_users_get; 
       // optional, Limit result set to users who are considered authors.
       function who( _s: String): T_wp_v2_users_get; 
       // optional, Limit result set to users who have published posts.
       function has_published_posts( _s: String): T_wp_v2_users_get; 
       // optional, Array of column names to be searched.
       function search_columns( _s: String): T_wp_v2_users_get;  
     //Properties
     public
 
     end;

     T_wp_v2_users_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Login name for the user.
       function username( _jd: TJSONData): T_wp_v2_users_post; 
       // Display name for the user.
       function name( _jd: TJSONData): T_wp_v2_users_post; 
       // First name for the user.
       function first_name( _jd: TJSONData): T_wp_v2_users_post; 
       // Last name for the user.
       function last_name( _jd: TJSONData): T_wp_v2_users_post; 
       // The email address for the user.
       function email( _jd: TJSONData): T_wp_v2_users_post; 
       // URL of the user.
       function url_( _jd: TJSONData): T_wp_v2_users_post; 
       // Description of the user.
       function description( _jd: TJSONData): T_wp_v2_users_post; 
       // Locale for the user.
       function locale( _jd: TJSONData): T_wp_v2_users_post; 
       // The nickname for the user.
       function nickname( _jd: TJSONData): T_wp_v2_users_post; 
       // An alphanumeric identifier for the user.
       function slug( _jd: TJSONData): T_wp_v2_users_post; 
       // Roles assigned to the user.
       function roles( _jd: TJSONData): T_wp_v2_users_post; 
       // Password for the user (never included).
       function password( _jd: TJSONData): T_wp_v2_users_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_users_post;  
     end;

 
     //Chemin  /wp/v2/users/{id}
     T_wp_v2_users__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the user.
       function id( _s: String): T_wp_v2_users__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_users__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_users__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the user.
       function id( _s: String): T_wp_v2_users__id__post;  
     //Properties
     public
       // Login name for the user.
       function username( _jd: TJSONData): T_wp_v2_users__id__post; 
       // Display name for the user.
       function name( _jd: TJSONData): T_wp_v2_users__id__post; 
       // First name for the user.
       function first_name( _jd: TJSONData): T_wp_v2_users__id__post; 
       // Last name for the user.
       function last_name( _jd: TJSONData): T_wp_v2_users__id__post; 
       // The email address for the user.
       function email( _jd: TJSONData): T_wp_v2_users__id__post; 
       // URL of the user.
       function url_( _jd: TJSONData): T_wp_v2_users__id__post; 
       // Description of the user.
       function description( _jd: TJSONData): T_wp_v2_users__id__post; 
       // Locale for the user.
       function locale( _jd: TJSONData): T_wp_v2_users__id__post; 
       // The nickname for the user.
       function nickname( _jd: TJSONData): T_wp_v2_users__id__post; 
       // An alphanumeric identifier for the user.
       function slug( _jd: TJSONData): T_wp_v2_users__id__post; 
       // Roles assigned to the user.
       function roles( _jd: TJSONData): T_wp_v2_users__id__post; 
       // Password for the user (never included).
       function password( _jd: TJSONData): T_wp_v2_users__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_users__id__post;  
     end;

     T_wp_v2_users__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the user.
       function id( _s: String): T_wp_v2_users__id__put;  
     //Properties
     public
       // Login name for the user.
       function username( _jd: TJSONData): T_wp_v2_users__id__put; 
       // Display name for the user.
       function name( _jd: TJSONData): T_wp_v2_users__id__put; 
       // First name for the user.
       function first_name( _jd: TJSONData): T_wp_v2_users__id__put; 
       // Last name for the user.
       function last_name( _jd: TJSONData): T_wp_v2_users__id__put; 
       // The email address for the user.
       function email( _jd: TJSONData): T_wp_v2_users__id__put; 
       // URL of the user.
       function url_( _jd: TJSONData): T_wp_v2_users__id__put; 
       // Description of the user.
       function description( _jd: TJSONData): T_wp_v2_users__id__put; 
       // Locale for the user.
       function locale( _jd: TJSONData): T_wp_v2_users__id__put; 
       // The nickname for the user.
       function nickname( _jd: TJSONData): T_wp_v2_users__id__put; 
       // An alphanumeric identifier for the user.
       function slug( _jd: TJSONData): T_wp_v2_users__id__put; 
       // Roles assigned to the user.
       function roles( _jd: TJSONData): T_wp_v2_users__id__put; 
       // Password for the user (never included).
       function password( _jd: TJSONData): T_wp_v2_users__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_users__id__put;  
     end;

     T_wp_v2_users__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the user.
       function id( _s: String): T_wp_v2_users__id__patch;  
     //Properties
     public
       // Login name for the user.
       function username( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // Display name for the user.
       function name( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // First name for the user.
       function first_name( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // Last name for the user.
       function last_name( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // The email address for the user.
       function email( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // URL of the user.
       function url_( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // Description of the user.
       function description( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // Locale for the user.
       function locale( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // The nickname for the user.
       function nickname( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // An alphanumeric identifier for the user.
       function slug( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // Roles assigned to the user.
       function roles( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // Password for the user (never included).
       function password( _jd: TJSONData): T_wp_v2_users__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_users__id__patch;  
     end;

     T_wp_v2_users__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the user.
       function id( _s: String): T_wp_v2_users__id__delete;  
     //Properties
     public
       // Required to be true, as users do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_users__id__delete; 
       // Reassign the deleted user's posts and links to this user ID.
       function reassign( _jd: TJSONData): T_wp_v2_users__id__delete;  
     end;

 
     //Chemin  /wp/v2/users/me
     T_wp_v2_users_me_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_users_me_get;  
     //Properties
     public
 
     end;

     T_wp_v2_users_me_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Login name for the user.
       function username( _jd: TJSONData): T_wp_v2_users_me_post; 
       // Display name for the user.
       function name( _jd: TJSONData): T_wp_v2_users_me_post; 
       // First name for the user.
       function first_name( _jd: TJSONData): T_wp_v2_users_me_post; 
       // Last name for the user.
       function last_name( _jd: TJSONData): T_wp_v2_users_me_post; 
       // The email address for the user.
       function email( _jd: TJSONData): T_wp_v2_users_me_post; 
       // URL of the user.
       function url_( _jd: TJSONData): T_wp_v2_users_me_post; 
       // Description of the user.
       function description( _jd: TJSONData): T_wp_v2_users_me_post; 
       // Locale for the user.
       function locale( _jd: TJSONData): T_wp_v2_users_me_post; 
       // The nickname for the user.
       function nickname( _jd: TJSONData): T_wp_v2_users_me_post; 
       // An alphanumeric identifier for the user.
       function slug( _jd: TJSONData): T_wp_v2_users_me_post; 
       // Roles assigned to the user.
       function roles( _jd: TJSONData): T_wp_v2_users_me_post; 
       // Password for the user (never included).
       function password( _jd: TJSONData): T_wp_v2_users_me_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_users_me_post;  
     end;

     T_wp_v2_users_me_put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Login name for the user.
       function username( _jd: TJSONData): T_wp_v2_users_me_put; 
       // Display name for the user.
       function name( _jd: TJSONData): T_wp_v2_users_me_put; 
       // First name for the user.
       function first_name( _jd: TJSONData): T_wp_v2_users_me_put; 
       // Last name for the user.
       function last_name( _jd: TJSONData): T_wp_v2_users_me_put; 
       // The email address for the user.
       function email( _jd: TJSONData): T_wp_v2_users_me_put; 
       // URL of the user.
       function url_( _jd: TJSONData): T_wp_v2_users_me_put; 
       // Description of the user.
       function description( _jd: TJSONData): T_wp_v2_users_me_put; 
       // Locale for the user.
       function locale( _jd: TJSONData): T_wp_v2_users_me_put; 
       // The nickname for the user.
       function nickname( _jd: TJSONData): T_wp_v2_users_me_put; 
       // An alphanumeric identifier for the user.
       function slug( _jd: TJSONData): T_wp_v2_users_me_put; 
       // Roles assigned to the user.
       function roles( _jd: TJSONData): T_wp_v2_users_me_put; 
       // Password for the user (never included).
       function password( _jd: TJSONData): T_wp_v2_users_me_put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_users_me_put;  
     end;

     T_wp_v2_users_me_patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Login name for the user.
       function username( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // Display name for the user.
       function name( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // First name for the user.
       function first_name( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // Last name for the user.
       function last_name( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // The email address for the user.
       function email( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // URL of the user.
       function url_( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // Description of the user.
       function description( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // Locale for the user.
       function locale( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // The nickname for the user.
       function nickname( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // An alphanumeric identifier for the user.
       function slug( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // Roles assigned to the user.
       function roles( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // Password for the user (never included).
       function password( _jd: TJSONData): T_wp_v2_users_me_patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_users_me_patch;  
     end;

     T_wp_v2_users_me_delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Required to be true, as users do not support trashing.
       function force( _jd: TJSONData): T_wp_v2_users_me_delete; 
       // Reassign the deleted user's posts and links to this user ID.
       function reassign( _jd: TJSONData): T_wp_v2_users_me_delete;  
     end;

 
     //Chemin  /wp/v2/users/{user_id}/application-passwords
     T_wp_v2_users__user_id__application_passwords_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_users__user_id__application_passwords_get; 
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords_get;  
     //Properties
     public
 
     end;

     T_wp_v2_users__user_id__application_passwords_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords_post;  
     //Properties
     public
       // A UUID provided by the application to uniquely identify it. It is recommended to use an UUID v5 with the URL or DNS namespace.
       function app_id( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords_post; 
       // The name of the application password.
       function name( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords_post;  
     end;

     T_wp_v2_users__user_id__application_passwords_delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords_delete;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/users/{user_id}/application-passwords/introspect
     T_wp_v2_users__user_id__application_passwords_introspect_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_users__user_id__application_passwords_introspect_get; 
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords_introspect_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/users/{user_id}/application-passwords/{uuid}
     T_wp_v2_users__user_id__application_passwords__uuid__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__get; 
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__get; 
       // required, 
       function uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__get;  
     //Properties
     public
 
     end;

     T_wp_v2_users__user_id__application_passwords__uuid__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__post; 
       // required, 
       function uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__post;  
     //Properties
     public
       // A UUID provided by the application to uniquely identify it. It is recommended to use an UUID v5 with the URL or DNS namespace.
       function app_id( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__post; 
       // The name of the application password.
       function name( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__post;  
     end;

     T_wp_v2_users__user_id__application_passwords__uuid__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__put; 
       // required, 
       function uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__put;  
     //Properties
     public
       // A UUID provided by the application to uniquely identify it. It is recommended to use an UUID v5 with the URL or DNS namespace.
       function app_id( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__put; 
       // The name of the application password.
       function name( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__put;  
     end;

     T_wp_v2_users__user_id__application_passwords__uuid__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__patch; 
       // required, 
       function uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__patch;  
     //Properties
     public
       // A UUID provided by the application to uniquely identify it. It is recommended to use an UUID v5 with the URL or DNS namespace.
       function app_id( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__patch; 
       // The name of the application password.
       function name( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__patch;  
     end;

     T_wp_v2_users__user_id__application_passwords__uuid__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__delete; 
       // required, 
       function uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__delete;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/comments
     T_wp_v2_comments_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_comments_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_comments_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_comments_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_comments_get; 
       // optional, Limit response to comments published after a given ISO8601 compliant date.
       function after( _s: String): T_wp_v2_comments_get; 
       // optional, Limit result set to comments assigned to specific user IDs. Requires authorization.
       function author( _s: String): T_wp_v2_comments_get; 
       // optional, Ensure result set excludes comments assigned to specific user IDs. Requires authorization.
       function author_exclude( _s: String): T_wp_v2_comments_get; 
       // optional, Limit result set to that from a specific author email. Requires authorization.
       function author_email( _s: String): T_wp_v2_comments_get; 
       // optional, Limit response to comments published before a given ISO8601 compliant date.
       function before( _s: String): T_wp_v2_comments_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_comments_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_comments_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_comments_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_comments_get; 
       // optional, Sort collection by comment attribute.
       function orderby( _s: String): T_wp_v2_comments_get; 
       // optional, Limit result set to comments of specific parent IDs.
       function parent( _s: String): T_wp_v2_comments_get; 
       // optional, Ensure result set excludes specific parent IDs.
       function parent_exclude( _s: String): T_wp_v2_comments_get; 
       // optional, Limit result set to comments assigned to specific post IDs.
       function post( _s: String): T_wp_v2_comments_get; 
       // optional, Limit result set to comments assigned a specific status. Requires authorization.
       function status( _s: String): T_wp_v2_comments_get; 
       // optional, Limit result set to comments assigned a specific type. Requires authorization.
       function type_( _s: String): T_wp_v2_comments_get; 
       // optional, The password for the post if it is password protected.
       function password( _s: String): T_wp_v2_comments_get;  
     //Properties
     public
 
     end;

     T_wp_v2_comments_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // The ID of the user object, if author was a user.
       function author( _jd: TJSONData): T_wp_v2_comments_post; 
       // Email address for the comment author.
       function author_email( _jd: TJSONData): T_wp_v2_comments_post; 
       // IP address for the comment author.
       function author_ip( _jd: TJSONData): T_wp_v2_comments_post; 
       // Display name for the comment author.
       function author_name( _jd: TJSONData): T_wp_v2_comments_post; 
       // URL for the comment author.
       function author_url( _jd: TJSONData): T_wp_v2_comments_post; 
       // User agent for the comment author.
       function author_user_agent( _jd: TJSONData): T_wp_v2_comments_post; 
       // The content for the comment.
       function content( _jd: TJSONData): T_wp_v2_comments_post; 
       // The date the comment was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_comments_post; 
       // The date the comment was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_comments_post; 
       // The ID for the parent of the comment.
       function parent( _jd: TJSONData): T_wp_v2_comments_post; 
       // The ID of the associated post object.
       function post( _jd: TJSONData): T_wp_v2_comments_post; 
       // State of the comment.
       function status( _jd: TJSONData): T_wp_v2_comments_post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_comments_post;  
     end;

 
     //Chemin  /wp/v2/comments/{id}
     T_wp_v2_comments__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the comment.
       function id( _s: String): T_wp_v2_comments__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_comments__id__get; 
       // optional, The password for the parent post of the comment (if the post is password protected).
       function password( _s: String): T_wp_v2_comments__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_comments__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the comment.
       function id( _s: String): T_wp_v2_comments__id__post;  
     //Properties
     public
       // The ID of the user object, if author was a user.
       function author( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // Email address for the comment author.
       function author_email( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // IP address for the comment author.
       function author_ip( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // Display name for the comment author.
       function author_name( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // URL for the comment author.
       function author_url( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // User agent for the comment author.
       function author_user_agent( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // The content for the comment.
       function content( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // The date the comment was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // The date the comment was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // The ID for the parent of the comment.
       function parent( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // The ID of the associated post object.
       function post( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // State of the comment.
       function status( _jd: TJSONData): T_wp_v2_comments__id__post; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_comments__id__post;  
     end;

     T_wp_v2_comments__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the comment.
       function id( _s: String): T_wp_v2_comments__id__put;  
     //Properties
     public
       // The ID of the user object, if author was a user.
       function author( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // Email address for the comment author.
       function author_email( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // IP address for the comment author.
       function author_ip( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // Display name for the comment author.
       function author_name( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // URL for the comment author.
       function author_url( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // User agent for the comment author.
       function author_user_agent( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // The content for the comment.
       function content( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // The date the comment was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // The date the comment was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // The ID for the parent of the comment.
       function parent( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // The ID of the associated post object.
       function post( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // State of the comment.
       function status( _jd: TJSONData): T_wp_v2_comments__id__put; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_comments__id__put;  
     end;

     T_wp_v2_comments__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the comment.
       function id( _s: String): T_wp_v2_comments__id__patch;  
     //Properties
     public
       // The ID of the user object, if author was a user.
       function author( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // Email address for the comment author.
       function author_email( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // IP address for the comment author.
       function author_ip( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // Display name for the comment author.
       function author_name( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // URL for the comment author.
       function author_url( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // User agent for the comment author.
       function author_user_agent( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // The content for the comment.
       function content( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // The date the comment was published, in the site's timezone.
       function date( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // The date the comment was published, as GMT.
       function date_gmt( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // The ID for the parent of the comment.
       function parent( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // The ID of the associated post object.
       function post( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // State of the comment.
       function status( _jd: TJSONData): T_wp_v2_comments__id__patch; 
       // Meta fields.
       function meta( _jd: TJSONData): T_wp_v2_comments__id__patch;  
     end;

     T_wp_v2_comments__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the comment.
       function id( _s: String): T_wp_v2_comments__id__delete;  
     //Properties
     public
       // Whether to bypass Trash and force deletion.
       function force( _jd: TJSONData): T_wp_v2_comments__id__delete; 
       // The password for the parent post of the comment (if the post is password protected).
       function password( _jd: TJSONData): T_wp_v2_comments__id__delete;  
     end;

 
     //Chemin  /wp/v2/search
     T_wp_v2_search_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_search_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_search_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_search_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_search_get; 
       // optional, Limit results to items of an object type.
       function type_( _s: String): T_wp_v2_search_get; 
       // optional, Limit results to items of one or more object subtypes.
       function subtype( _s: String): T_wp_v2_search_get; 
       // optional, Ensure result set excludes specific IDs.
       function exclude( _s: String): T_wp_v2_search_get; 
       // optional, Limit result set to specific IDs.
       function include( _s: String): T_wp_v2_search_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/block-renderer/{name}
     T_wp_v2_block_renderer__name__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique registered name for the block.
       function name( _s: String): T_wp_v2_block_renderer__name__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_block_renderer__name__get; 
       // optional, Attributes for the block.
       function attributes( _s: String): T_wp_v2_block_renderer__name__get; 
       // optional, ID of the post context.
       function post_id( _s: String): T_wp_v2_block_renderer__name__get;  
     //Properties
     public
 
     end;

     T_wp_v2_block_renderer__name__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique registered name for the block.
       function name( _s: String): T_wp_v2_block_renderer__name__post;  
     //Properties
     public
       // Attributes for the block.
       function attributes( _jd: TJSONData): T_wp_v2_block_renderer__name__post; 
       // ID of the post context.
       function post_id( _jd: TJSONData): T_wp_v2_block_renderer__name__post;  
     end;

 
     //Chemin  /wp/v2/block-types
     T_wp_v2_block_types_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_block_types_get; 
       // optional, Block namespace.
       function namespace( _s: String): T_wp_v2_block_types_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/block-types/{namespace}
     T_wp_v2_block_types__namespace__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_block_types__namespace__get; 
       // required, Block namespace.
       function namespace( _s: String): T_wp_v2_block_types__namespace__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/block-types/{namespace}/{name}
     T_wp_v2_block_types__namespace___name__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Block name.
       function name( _s: String): T_wp_v2_block_types__namespace___name__get; 
       // required, Block namespace.
       function namespace( _s: String): T_wp_v2_block_types__namespace___name__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_block_types__namespace___name__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/settings
     T_wp_v2_settings_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

     T_wp_v2_settings_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Site title.
       function title( _jd: TJSONData): T_wp_v2_settings_post; 
       // Site tagline.
       function description( _jd: TJSONData): T_wp_v2_settings_post; 
       // Site URL.
       function url_( _jd: TJSONData): T_wp_v2_settings_post; 
       // This address is used for admin purposes, like new user notification.
       function email( _jd: TJSONData): T_wp_v2_settings_post; 
       // A city in the same timezone as you.
       function timezone( _jd: TJSONData): T_wp_v2_settings_post; 
       // A date format for all date strings.
       function date_format( _jd: TJSONData): T_wp_v2_settings_post; 
       // A time format for all time strings.
       function time_format( _jd: TJSONData): T_wp_v2_settings_post; 
       // A day number of the week that the week should start on.
       function start_of_week( _jd: TJSONData): T_wp_v2_settings_post; 
       // WordPress locale code.
       function language( _jd: TJSONData): T_wp_v2_settings_post; 
       // Convert emoticons like :-) and :-P to graphics on display.
       function use_smilies( _jd: TJSONData): T_wp_v2_settings_post; 
       // Default post category.
       function default_category( _jd: TJSONData): T_wp_v2_settings_post; 
       // Default post format.
       function default_post_format( _jd: TJSONData): T_wp_v2_settings_post; 
       // Blog pages show at most.
       function posts_per_page( _jd: TJSONData): T_wp_v2_settings_post; 
       // What to show on the front page
       function show_on_front( _jd: TJSONData): T_wp_v2_settings_post; 
       // The ID of the page that should be displayed on the front page
       function page_on_front( _jd: TJSONData): T_wp_v2_settings_post; 
       // The ID of the page that should display the latest posts
       function page_for_posts( _jd: TJSONData): T_wp_v2_settings_post; 
       // Allow link notifications from other blogs (pingbacks and trackbacks) on new articles.
       function default_ping_status( _jd: TJSONData): T_wp_v2_settings_post; 
       // Allow people to submit comments on new posts.
       function default_comment_status( _jd: TJSONData): T_wp_v2_settings_post; 
       // Site logo.
       function site_logo( _jd: TJSONData): T_wp_v2_settings_post; 
       // Site icon.
       function site_icon( _jd: TJSONData): T_wp_v2_settings_post;  
     end;

     T_wp_v2_settings_put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Site title.
       function title( _jd: TJSONData): T_wp_v2_settings_put; 
       // Site tagline.
       function description( _jd: TJSONData): T_wp_v2_settings_put; 
       // Site URL.
       function url_( _jd: TJSONData): T_wp_v2_settings_put; 
       // This address is used for admin purposes, like new user notification.
       function email( _jd: TJSONData): T_wp_v2_settings_put; 
       // A city in the same timezone as you.
       function timezone( _jd: TJSONData): T_wp_v2_settings_put; 
       // A date format for all date strings.
       function date_format( _jd: TJSONData): T_wp_v2_settings_put; 
       // A time format for all time strings.
       function time_format( _jd: TJSONData): T_wp_v2_settings_put; 
       // A day number of the week that the week should start on.
       function start_of_week( _jd: TJSONData): T_wp_v2_settings_put; 
       // WordPress locale code.
       function language( _jd: TJSONData): T_wp_v2_settings_put; 
       // Convert emoticons like :-) and :-P to graphics on display.
       function use_smilies( _jd: TJSONData): T_wp_v2_settings_put; 
       // Default post category.
       function default_category( _jd: TJSONData): T_wp_v2_settings_put; 
       // Default post format.
       function default_post_format( _jd: TJSONData): T_wp_v2_settings_put; 
       // Blog pages show at most.
       function posts_per_page( _jd: TJSONData): T_wp_v2_settings_put; 
       // What to show on the front page
       function show_on_front( _jd: TJSONData): T_wp_v2_settings_put; 
       // The ID of the page that should be displayed on the front page
       function page_on_front( _jd: TJSONData): T_wp_v2_settings_put; 
       // The ID of the page that should display the latest posts
       function page_for_posts( _jd: TJSONData): T_wp_v2_settings_put; 
       // Allow link notifications from other blogs (pingbacks and trackbacks) on new articles.
       function default_ping_status( _jd: TJSONData): T_wp_v2_settings_put; 
       // Allow people to submit comments on new posts.
       function default_comment_status( _jd: TJSONData): T_wp_v2_settings_put; 
       // Site logo.
       function site_logo( _jd: TJSONData): T_wp_v2_settings_put; 
       // Site icon.
       function site_icon( _jd: TJSONData): T_wp_v2_settings_put;  
     end;

     T_wp_v2_settings_patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Site title.
       function title( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Site tagline.
       function description( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Site URL.
       function url_( _jd: TJSONData): T_wp_v2_settings_patch; 
       // This address is used for admin purposes, like new user notification.
       function email( _jd: TJSONData): T_wp_v2_settings_patch; 
       // A city in the same timezone as you.
       function timezone( _jd: TJSONData): T_wp_v2_settings_patch; 
       // A date format for all date strings.
       function date_format( _jd: TJSONData): T_wp_v2_settings_patch; 
       // A time format for all time strings.
       function time_format( _jd: TJSONData): T_wp_v2_settings_patch; 
       // A day number of the week that the week should start on.
       function start_of_week( _jd: TJSONData): T_wp_v2_settings_patch; 
       // WordPress locale code.
       function language( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Convert emoticons like :-) and :-P to graphics on display.
       function use_smilies( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Default post category.
       function default_category( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Default post format.
       function default_post_format( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Blog pages show at most.
       function posts_per_page( _jd: TJSONData): T_wp_v2_settings_patch; 
       // What to show on the front page
       function show_on_front( _jd: TJSONData): T_wp_v2_settings_patch; 
       // The ID of the page that should be displayed on the front page
       function page_on_front( _jd: TJSONData): T_wp_v2_settings_patch; 
       // The ID of the page that should display the latest posts
       function page_for_posts( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Allow link notifications from other blogs (pingbacks and trackbacks) on new articles.
       function default_ping_status( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Allow people to submit comments on new posts.
       function default_comment_status( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Site logo.
       function site_logo( _jd: TJSONData): T_wp_v2_settings_patch; 
       // Site icon.
       function site_icon( _jd: TJSONData): T_wp_v2_settings_patch;  
     end;

 
     //Chemin  /wp/v2/themes
     T_wp_v2_themes_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Limit result set to themes assigned one or more statuses.
       function status( _s: String): T_wp_v2_themes_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/themes/{stylesheet}
     T_wp_v2_themes__stylesheet__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The theme's stylesheet. This uniquely identifies the theme.
       function stylesheet( _s: String): T_wp_v2_themes__stylesheet__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/plugins
     T_wp_v2_plugins_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_plugins_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_plugins_get; 
       // optional, Limits results to plugins with the given status.
       function status( _s: String): T_wp_v2_plugins_get;  
     //Properties
     public
 
     end;

     T_wp_v2_plugins_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // WordPress.org plugin directory slug.
       function slug( _jd: TJSONData): T_wp_v2_plugins_post; 
       // The plugin activation status.
       function status( _jd: TJSONData): T_wp_v2_plugins_post;  
     end;

 
     //Chemin  /wp/v2/plugins/{plugin}
     T_wp_v2_plugins__plugin__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_plugins__plugin__get; 
       // required, 
       function plugin( _s: String): T_wp_v2_plugins__plugin__get;  
     //Properties
     public
 
     end;

     T_wp_v2_plugins__plugin__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function plugin( _s: String): T_wp_v2_plugins__plugin__post;  
     //Properties
     public
       // The plugin activation status.
       function status( _jd: TJSONData): T_wp_v2_plugins__plugin__post;  
     end;

     T_wp_v2_plugins__plugin__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function plugin( _s: String): T_wp_v2_plugins__plugin__put;  
     //Properties
     public
       // The plugin activation status.
       function status( _jd: TJSONData): T_wp_v2_plugins__plugin__put;  
     end;

     T_wp_v2_plugins__plugin__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function plugin( _s: String): T_wp_v2_plugins__plugin__patch;  
     //Properties
     public
       // The plugin activation status.
       function status( _jd: TJSONData): T_wp_v2_plugins__plugin__patch;  
     end;

     T_wp_v2_plugins__plugin__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function plugin( _s: String): T_wp_v2_plugins__plugin__delete;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/sidebars
     T_wp_v2_sidebars_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_sidebars_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/sidebars/{id}
     T_wp_v2_sidebars__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The id of a registered sidebar
       function id( _s: String): T_wp_v2_sidebars__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_sidebars__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_sidebars__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_sidebars__id__post;  
     //Properties
     public
       // Nested widgets.
       function widgets( _jd: TJSONData): T_wp_v2_sidebars__id__post;  
     end;

     T_wp_v2_sidebars__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_sidebars__id__put;  
     //Properties
     public
       // Nested widgets.
       function widgets( _jd: TJSONData): T_wp_v2_sidebars__id__put;  
     end;

     T_wp_v2_sidebars__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_sidebars__id__patch;  
     //Properties
     public
       // Nested widgets.
       function widgets( _jd: TJSONData): T_wp_v2_sidebars__id__patch;  
     end;

 
     //Chemin  /wp/v2/widget-types
     T_wp_v2_widget_types_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_widget_types_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/widget-types/{id}
     T_wp_v2_widget_types__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The widget type id.
       function id( _s: String): T_wp_v2_widget_types__id__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_widget_types__id__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/widget-types/{id}/encode
     T_wp_v2_widget_types__id__encode_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The widget type id.
       function id( _s: String): T_wp_v2_widget_types__id__encode_post;  
     //Properties
     public
       // Current instance settings of the widget.
       function instance( _jd: TJSONData): T_wp_v2_widget_types__id__encode_post; 
       // Serialized widget form data to encode into instance settings.
       function form_data( _jd: TJSONData): T_wp_v2_widget_types__id__encode_post;  
     end;

 
     //Chemin  /wp/v2/widget-types/{id}/render
     T_wp_v2_widget_types__id__render_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The widget type id.
       function id( _s: String): T_wp_v2_widget_types__id__render_post;  
     //Properties
     public
       // Current instance settings of the widget.
       function instance( _jd: TJSONData): T_wp_v2_widget_types__id__render_post;  
     end;

 
     //Chemin  /wp/v2/widgets
     T_wp_v2_widgets_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_widgets_get; 
       // optional, The sidebar to return widgets for.
       function sidebar( _s: String): T_wp_v2_widgets_get;  
     //Properties
     public
 
     end;

     T_wp_v2_widgets_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
       // Unique identifier for the widget.
       function id( _jd: TJSONData): T_wp_v2_widgets_post; 
       // The type of the widget. Corresponds to ID in widget-types endpoint.
       function id_base( _jd: TJSONData): T_wp_v2_widgets_post; 
       // The sidebar the widget belongs to.
       function sidebar( _jd: TJSONData): T_wp_v2_widgets_post; 
       // Instance settings of the widget, if supported.
       function instance( _jd: TJSONData): T_wp_v2_widgets_post; 
       // URL-encoded form data from the widget admin form. Used to update a widget that does not support instance. Write only.
       function form_data( _jd: TJSONData): T_wp_v2_widgets_post;  
     end;

 
     //Chemin  /wp/v2/widgets/{id}
     T_wp_v2_widgets__id__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_widgets__id__get; 
       // required, 
       function id( _s: String): T_wp_v2_widgets__id__get;  
     //Properties
     public
 
     end;

     T_wp_v2_widgets__id__post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the widget.
       function id( _s: String): T_wp_v2_widgets__id__post;  
     //Properties
     public
       // The type of the widget. Corresponds to ID in widget-types endpoint.
       function id_base( _jd: TJSONData): T_wp_v2_widgets__id__post; 
       // The sidebar the widget belongs to.
       function sidebar( _jd: TJSONData): T_wp_v2_widgets__id__post; 
       // Instance settings of the widget, if supported.
       function instance( _jd: TJSONData): T_wp_v2_widgets__id__post; 
       // URL-encoded form data from the widget admin form. Used to update a widget that does not support instance. Write only.
       function form_data( _jd: TJSONData): T_wp_v2_widgets__id__post;  
     end;

     T_wp_v2_widgets__id__put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the widget.
       function id( _s: String): T_wp_v2_widgets__id__put;  
     //Properties
     public
       // The type of the widget. Corresponds to ID in widget-types endpoint.
       function id_base( _jd: TJSONData): T_wp_v2_widgets__id__put; 
       // The sidebar the widget belongs to.
       function sidebar( _jd: TJSONData): T_wp_v2_widgets__id__put; 
       // Instance settings of the widget, if supported.
       function instance( _jd: TJSONData): T_wp_v2_widgets__id__put; 
       // URL-encoded form data from the widget admin form. Used to update a widget that does not support instance. Write only.
       function form_data( _jd: TJSONData): T_wp_v2_widgets__id__put;  
     end;

     T_wp_v2_widgets__id__patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the widget.
       function id( _s: String): T_wp_v2_widgets__id__patch;  
     //Properties
     public
       // The type of the widget. Corresponds to ID in widget-types endpoint.
       function id_base( _jd: TJSONData): T_wp_v2_widgets__id__patch; 
       // The sidebar the widget belongs to.
       function sidebar( _jd: TJSONData): T_wp_v2_widgets__id__patch; 
       // Instance settings of the widget, if supported.
       function instance( _jd: TJSONData): T_wp_v2_widgets__id__patch; 
       // URL-encoded form data from the widget admin form. Used to update a widget that does not support instance. Write only.
       function form_data( _jd: TJSONData): T_wp_v2_widgets__id__patch;  
     end;

     T_wp_v2_widgets__id__delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, 
       function id( _s: String): T_wp_v2_widgets__id__delete;  
     //Properties
     public
       // Whether to force removal of the widget, or move it to the inactive sidebar.
       function force( _jd: TJSONData): T_wp_v2_widgets__id__delete;  
     end;

 
     //Chemin  /wp/v2/block-directory/search
     T_wp_v2_block_directory_search_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_block_directory_search_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_block_directory_search_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_block_directory_search_get; 
       // required, Limit result set to blocks matching the search term.
       function term( _s: String): T_wp_v2_block_directory_search_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/pattern-directory/patterns
     T_wp_v2_pattern_directory_patterns_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Limit results to those matching a category ID.
       function category( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Limit results to those matching a keyword ID.
       function keyword( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Limit results to those matching a pattern (slug).
       function slug( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Offset the result set by a specific number of items.
       function offset( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Order sort attribute ascending or descending.
       function order( _s: String): T_wp_v2_pattern_directory_patterns_get; 
       // optional, Sort collection by post attribute.
       function orderby( _s: String): T_wp_v2_pattern_directory_patterns_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/block-patterns/patterns
     T_wp_v2_block_patterns_patterns_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/block-patterns/categories
     T_wp_v2_block_patterns_categories_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/menu-locations
     T_wp_v2_menu_locations_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_menu_locations_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/menu-locations/{location}
     T_wp_v2_menu_locations__location__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, An alphanumeric identifier for the menu location.
       function location( _s: String): T_wp_v2_menu_locations__location__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_menu_locations__location__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/font-collections
     T_wp_v2_font_collections_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_font_collections_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_font_collections_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_font_collections_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/font-collections/{slug}
     T_wp_v2_font_collections__slug__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_font_collections__slug__get; 
       // required, 
       function slug( _s: String): T_wp_v2_font_collections__slug__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/icons
     T_wp_v2_icons_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_icons_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_v2_icons_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_v2_icons_get; 
       // optional, Limit results to those matching a string.
       function search( _s: String): T_wp_v2_icons_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp/v2/icons/{name}
     T_wp_v2_icons__name__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Icon name.
       function name( _s: String): T_wp_v2_icons__name__get; 
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_v2_icons__name__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-site-health/v1
     T_wp_site_health_v1_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, 
       function namespace( _s: String): T_wp_site_health_v1_get; 
       // optional, 
       function context( _s: String): T_wp_site_health_v1_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-site-health/v1/tests/background-updates
     T_wp_site_health_v1_tests_background_updates_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-site-health/v1/tests/loopback-requests
     T_wp_site_health_v1_tests_loopback_requests_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-site-health/v1/tests/https-status
     T_wp_site_health_v1_tests_https_status_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-site-health/v1/tests/dotorg-communication
     T_wp_site_health_v1_tests_dotorg_communication_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-site-health/v1/tests/authorization-header
     T_wp_site_health_v1_tests_authorization_header_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-site-health/v1/directory-sizes
     T_wp_site_health_v1_directory_sizes_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-site-health/v1/tests/page-cache
     T_wp_site_health_v1_tests_page_cache_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-block-editor/v1
     T_wp_block_editor_v1_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, 
       function namespace( _s: String): T_wp_block_editor_v1_get; 
       // optional, 
       function context( _s: String): T_wp_block_editor_v1_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-block-editor/v1/url-details
     T_wp_block_editor_v1_url_details_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, The URL to process.
       function url_( _s: String): T_wp_block_editor_v1_url_details_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-block-editor/v1/export
     T_wp_block_editor_v1_export_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-block-editor/v1/navigation-fallback
     T_wp_block_editor_v1_navigation_fallback_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
 
     //Properties
     public
 
     end;

 
     //Chemin  /wp-abilities/v1
     T_wp_abilities_v1_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, 
       function namespace( _s: String): T_wp_abilities_v1_get; 
       // optional, 
       function context( _s: String): T_wp_abilities_v1_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-abilities/v1/categories
     T_wp_abilities_v1_categories_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_abilities_v1_categories_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_abilities_v1_categories_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_abilities_v1_categories_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-abilities/v1/categories/{slug}
     T_wp_abilities_v1_categories__slug__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the ability category.
       function slug( _s: String): T_wp_abilities_v1_categories__slug__get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-abilities/v1/abilities/{name}/run
     T_wp_abilities_v1_abilities__name__run_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the ability.
       function name( _s: String): T_wp_abilities_v1_abilities__name__run_get; 
       // optional, Input parameters for the ability execution.
       function input( _s: String): T_wp_abilities_v1_abilities__name__run_get;  
     //Properties
     public
 
     end;

     T_wp_abilities_v1_abilities__name__run_post
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the ability.
       function name( _s: String): T_wp_abilities_v1_abilities__name__run_post;  
     //Properties
     public
       // Input parameters for the ability execution.
       function input( _jd: TJSONData): T_wp_abilities_v1_abilities__name__run_post;  
     end;

     T_wp_abilities_v1_abilities__name__run_put
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the ability.
       function name( _s: String): T_wp_abilities_v1_abilities__name__run_put;  
     //Properties
     public
       // Input parameters for the ability execution.
       function input( _jd: TJSONData): T_wp_abilities_v1_abilities__name__run_put;  
     end;

     T_wp_abilities_v1_abilities__name__run_patch
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the ability.
       function name( _s: String): T_wp_abilities_v1_abilities__name__run_patch;  
     //Properties
     public
       // Input parameters for the ability execution.
       function input( _jd: TJSONData): T_wp_abilities_v1_abilities__name__run_patch;  
     end;

     T_wp_abilities_v1_abilities__name__run_delete
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the ability.
       function name( _s: String): T_wp_abilities_v1_abilities__name__run_delete;  
     //Properties
     public
       // Input parameters for the ability execution.
       function input( _jd: TJSONData): T_wp_abilities_v1_abilities__name__run_delete;  
     end;

 
     //Chemin  /wp-abilities/v1/abilities
     T_wp_abilities_v1_abilities_get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // optional, Scope under which the request is made; determines fields present in response.
       function context( _s: String): T_wp_abilities_v1_abilities_get; 
       // optional, Current page of the collection.
       function page( _s: String): T_wp_abilities_v1_abilities_get; 
       // optional, Maximum number of items to be returned in result set.
       function per_page( _s: String): T_wp_abilities_v1_abilities_get; 
       // optional, Limit results to abilities in specific ability category.
       function category( _s: String): T_wp_abilities_v1_abilities_get;  
     //Properties
     public
 
     end;

 
     //Chemin  /wp-abilities/v1/abilities/{name}
     T_wp_abilities_v1_abilities__name__get
    =
     class( TWordpress_verb)
     //Gestion du cycle de vie
     public
       constructor Create( _root_url, _Username, _Password: String);
       destructor Destroy; override;
     //Parameters
     public
       // required, Unique identifier for the ability.
       function name( _s: String): T_wp_abilities_v1_abilities__name__get;  
     //Properties
     public
 
     end;

 //Fin Liste des Paths  //Fin Liste des Paths  

implementation

{ TWordpress_verb }

constructor TWordpress_verb.Create( _Username, _Password: String);
begin
     url:= '';
     Verb:= '';
     Properties:= TJSONObject.Create;
     Username:= _Username;
     Password:= _Password;
     token:= EncodeStringBase64( Username+':'+_Password);
     http:= THTTPSend.Create;
     http.Headers.Add( 'Authorization: Basic '+token);
     http.Headers.Add( 'User-Agent: jsWordpress');

     hc:= TFPHTTPClient.Create(nil);
     hc  .AddHeader  ( 'Authorization','Basic '+token);
     hc  .AddHeader  ( 'User-Agent','jsWordpress');

     Content_type:= ct_json;
     rbssRequestBody:= TRawByteStringStream.Create('');
end;

destructor TWordpress_verb.Destroy;
begin
     FreeAndNil( rbssRequestBody);
     FreeAndNil( hc);
     FreeAndNil( http);
     inherited Destroy;
end;

procedure TWordpress_verb.Parameter_Path( _name: String; _Value: String);
begin
     url:= StringReplace( url, '{'+_name+'}', _Value, []);
end;

procedure TWordpress_verb.Parameter_Query( _name: String; _Value: String);
begin
     if 0 = Pos('?', url)
     then
         url:= url+ '?'
     else
         url:= url + '&';
     url:= url+_name+'='+_Value;
end;

procedure TWordpress_verb.Property_(_name: String; _Value: TJSONData);
begin
     case Content_type
     of
       ct_json:
         Properties.Add( _name, _Value);
       ct_multipart_form_data:
         begin
         Write_Boundary;
         Write_String( 'Content-Disposition: form-data; name="'+_name+'"');
         Write_String( '');
         if    (jtObject = _Value.JSONType)
            or (jtArray = _Value.JSONType)
         then
             Write_String( _Value.AsJSON) //non testé
         else
             Write_String( _Value.AsString);
         end;
       ct_attachment: begin end;
       end;
end;

function TWordpress_verb.String_from_http: String;
var
   ss: TStringStream;
begin
     ss:= TStringStream.Create('');
     try
        http.Document.SaveToStream( ss);
        Result:= ss.DataString;
     finally
            FreeAndNil( ss);
            end;
end;

procedure TWordpress_verb.Write_String(_s: RawByteString);
begin
     rbssRequestBody.WriteString( _s);
end;

procedure TWordpress_verb.Write_Boundary;
begin
     Write_String( '--'+multipart_form_data_boundary);
end;

procedure TWordpress_verb.Write_Boundary_Final;
begin
     Write_String( '--'+multipart_form_data_boundary+'--');
end;

procedure TWordpress_verb.Set_multipart_form_data;
begin
     Content_type:= ct_multipart_form_data;
     multipart_form_data_boundary:= 'abcd1234efgh5678';
end;

procedure TWordpress_verb.Set_attachment;
begin
     Content_type:= ct_attachment;
end;

procedure TWordpress_verb.Add_File( _NomFichier: String; _MimeType: String);
var
   Contenu_Fichier: String;
begin
     if '' = _MimeType then _MimeType:= MimeType_from_Extension( ExtractFileExt( _NomFichier));
     Contenu_Fichier:= String_from_File( _NomFichier);

     case Content_type
     of
       ct_multipart_form_data:
         begin
         Write_Boundary;
         //Write_String( 'Content-Disposition: form-data; name="file"; filename="'+_NomFichier+'"');
         Write_String( 'Content-Disposition: form-data; name="data"; filename="'+ExtractFileName(_NomFichier)+'"');
         Write_String( 'Content-Type: '+_MimeType);
         Write_String( '');
         Write_String( Contenu_Fichier);
         end;
       ct_attachment:
         begin
         hc.AddHeader( 'Content-Disposition', 'attachment; filename="'+ExtractFileName(_NomFichier)+'"');
         hc.AddHeader( 'Content-Type'       , _MimeType                                );
         Write_String( Contenu_Fichier);
         end;
     end;
end;

{
function TWordpress_verb.Execute: String;
begin
     Verb:= Uppercase( Verb);

     http.Sock.SSL.VerifyCert:= False;
     WriteStrToStream( HTTP.Document, Properties.ToString);
     HTTP.MimeType := 'application/x-www-form-urlencoded';
     try
        if not http.HTTPMethod( Verb, URL)
        then
            Result:= 'Echec de '+URL+', '+Verb+':'#13#10+String_from_http
        else
            Result:= String_from_http;
     except
           on E: Exception
           do
             Result:= 'Echec de '+URL+', GET:'#13#10+E.Message;
           end;
end;
}
function TWordpress_verb.Execute: String;
var
   ss: TStringStream;
begin
     Verb:= Uppercase( Verb);

     case Content_type
     of
       ct_json:
         begin
           Write_String( Properties.AsJSON);
           //hc.AddHeader( 'Content-type','application/x-www-form-urlencoded');
           hc.AddHeader( 'Content-type','application/json');
         end;
       ct_multipart_form_data:
         begin
         Write_Boundary_Final;
         hc.AddHeader('Content-type', 'multipart/form-data; boundary='+multipart_form_data_boundary);
         hc.AddHeader('Content-Length', IntToStr(rbssRequestBody.Size));
         end;
       ct_attachment:
         begin
         end
       end;

     rbssRequestBody.Position:= 0;
     hc.RequestBody:= rbssRequestBody;
     try
        ss:= TStringStream.Create( '');
        try
           hc.HTTPMethod( Verb, URL, ss, []);
           Result:= ss.DataString;
        except
              on E: Exception
              do
                Result:= 'Echec de '+URL+', GET:'#13#10+E.Message;
              end;
     finally
            FreeAndNil( ss);
            end;
end;

//Chemin  /oembed/1.0

{ T_oembed_1_0_get }

constructor T_oembed_1_0_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/oembed/1.0';
     Verb:= 'get';
end;

destructor T_oembed_1_0_get.Destroy;
begin
     inherited Destroy;
end;

// T_oembed_1_0_get Parameters

function T_oembed_1_0_get.namespace( _s: String): T_oembed_1_0_get; 
begin
     Parameter_Query( 'namespace', _s);
     Result:= Self;
end;
function T_oembed_1_0_get.context( _s: String): T_oembed_1_0_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_oembed_1_0_get Properties

 

 
//Chemin  /oembed/1.0/embed

{ T_oembed_1_0_embed_get }

constructor T_oembed_1_0_embed_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/oembed/1.0/embed';
     Verb:= 'get';
end;

destructor T_oembed_1_0_embed_get.Destroy;
begin
     inherited Destroy;
end;

// T_oembed_1_0_embed_get Parameters

function T_oembed_1_0_embed_get.url_( _s: String): T_oembed_1_0_embed_get; 
begin
     Parameter_Query( 'url', _s);
     Result:= Self;
end;
function T_oembed_1_0_embed_get.format_( _s: String): T_oembed_1_0_embed_get; 
begin
     Parameter_Query( 'format', _s);
     Result:= Self;
end;
function T_oembed_1_0_embed_get.maxwidth( _s: String): T_oembed_1_0_embed_get; 
begin
     Parameter_Query( 'maxwidth', _s);
     Result:= Self;
end; 

// T_oembed_1_0_embed_get Properties

 

 
//Chemin  /oembed/1.0/proxy

{ T_oembed_1_0_proxy_get }

constructor T_oembed_1_0_proxy_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/oembed/1.0/proxy';
     Verb:= 'get';
end;

destructor T_oembed_1_0_proxy_get.Destroy;
begin
     inherited Destroy;
end;

// T_oembed_1_0_proxy_get Parameters

function T_oembed_1_0_proxy_get.url_( _s: String): T_oembed_1_0_proxy_get; 
begin
     Parameter_Query( 'url', _s);
     Result:= Self;
end;
function T_oembed_1_0_proxy_get.format_( _s: String): T_oembed_1_0_proxy_get; 
begin
     Parameter_Query( 'format', _s);
     Result:= Self;
end;
function T_oembed_1_0_proxy_get.maxwidth( _s: String): T_oembed_1_0_proxy_get; 
begin
     Parameter_Query( 'maxwidth', _s);
     Result:= Self;
end;
function T_oembed_1_0_proxy_get.maxheight( _s: String): T_oembed_1_0_proxy_get; 
begin
     Parameter_Query( 'maxheight', _s);
     Result:= Self;
end;
function T_oembed_1_0_proxy_get.discover( _s: String): T_oembed_1_0_proxy_get; 
begin
     Parameter_Query( 'discover', _s);
     Result:= Self;
end; 

// T_oembed_1_0_proxy_get Properties

 

 
//Chemin  /wp-openapi/v1

{ T_wp_openapi_v1_get }

constructor T_wp_openapi_v1_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-openapi/v1';
     Verb:= 'get';
end;

destructor T_wp_openapi_v1_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_openapi_v1_get Parameters

function T_wp_openapi_v1_get.namespace( _s: String): T_wp_openapi_v1_get; 
begin
     Parameter_Query( 'namespace', _s);
     Result:= Self;
end;
function T_wp_openapi_v1_get.context( _s: String): T_wp_openapi_v1_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_openapi_v1_get Properties

 

 
//Chemin  /wp-openapi/v1/schema

{ T_wp_openapi_v1_schema_get }

constructor T_wp_openapi_v1_schema_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-openapi/v1/schema';
     Verb:= 'get';
end;

destructor T_wp_openapi_v1_schema_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_openapi_v1_schema_get Parameters

function T_wp_openapi_v1_schema_get.namespace( _s: String): T_wp_openapi_v1_schema_get; 
begin
     Parameter_Query( 'namespace', _s);
     Result:= Self;
end; 

// T_wp_openapi_v1_schema_get Properties

 

 
//Chemin  /wp/v2

{ T_wp_v2_get }

constructor T_wp_v2_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2';
     Verb:= 'get';
end;

destructor T_wp_v2_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_get Parameters

function T_wp_v2_get.namespace( _s: String): T_wp_v2_get; 
begin
     Parameter_Query( 'namespace', _s);
     Result:= Self;
end;
function T_wp_v2_get.context( _s: String): T_wp_v2_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_get Properties

 

 
//Chemin  /wp/v2/posts

{ T_wp_v2_posts_get }

constructor T_wp_v2_posts_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts';
     Verb:= 'get';
end;

destructor T_wp_v2_posts_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts_get Parameters

function T_wp_v2_posts_get.context( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.page( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.per_page( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.search( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.after( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'after', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.modified_after( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'modified_after', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.author( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'author', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.author_exclude( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'author_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.before( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'before', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.modified_before( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'modified_before', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.exclude( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.include( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.search_semantics( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'search_semantics', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.offset( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.order( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.orderby( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.search_columns( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'search_columns', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.slug( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.status( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.tax_relation( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'tax_relation', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.categories( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'categories', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.categories_exclude( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'categories_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.tags( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'tags', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.tags_exclude( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'tags_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.sticky( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'sticky', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.ignore_sticky( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'ignore_sticky', _s);
     Result:= Self;
end;
function T_wp_v2_posts_get.format_( _s: String): T_wp_v2_posts_get; 
begin
     Parameter_Query( 'format', _s);
     Result:= Self;
end; 

// T_wp_v2_posts_get Properties

 

 { T_wp_v2_posts_post }

constructor T_wp_v2_posts_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts';
     Verb:= 'post';
end;

destructor T_wp_v2_posts_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts_post Parameters

 

// T_wp_v2_posts_post Properties

function T_wp_v2_posts_post.date( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.date_gmt( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.slug( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.status( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.password( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.title( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.content( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.author( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.excerpt( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.featured_media( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.comment_status( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.ping_status( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.format_( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'format', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.meta( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.sticky( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'sticky', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.template( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.categories( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'categories', _jd);
     Result:= Self;
end;
function T_wp_v2_posts_post.tags( _jd: TJSONData): T_wp_v2_posts_post; 
begin
     Property_( 'tags', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/posts/{id}

{ T_wp_v2_posts__id__get }

constructor T_wp_v2_posts__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_posts__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__id__get Parameters

function T_wp_v2_posts__id__get.id( _s: String): T_wp_v2_posts__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_posts__id__get.context( _s: String): T_wp_v2_posts__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_posts__id__get.excerpt_length( _s: String): T_wp_v2_posts__id__get; 
begin
     Parameter_Query( 'excerpt_length', _s);
     Result:= Self;
end;
function T_wp_v2_posts__id__get.password( _s: String): T_wp_v2_posts__id__get; 
begin
     Parameter_Query( 'password', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__id__get Properties

 

 { T_wp_v2_posts__id__post }

constructor T_wp_v2_posts__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_posts__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__id__post Parameters

function T_wp_v2_posts__id__post.id( _s: String): T_wp_v2_posts__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__id__post Properties

function T_wp_v2_posts__id__post.date( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.date_gmt( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.slug( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.status( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.password( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.title( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.content( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.author( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.excerpt( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.featured_media( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.comment_status( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.ping_status( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.format_( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'format', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.meta( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.sticky( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'sticky', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.template( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.categories( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'categories', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__post.tags( _jd: TJSONData): T_wp_v2_posts__id__post; 
begin
     Property_( 'tags', _jd);
     Result:= Self;
end; 

 { T_wp_v2_posts__id__put }

constructor T_wp_v2_posts__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_posts__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__id__put Parameters

function T_wp_v2_posts__id__put.id( _s: String): T_wp_v2_posts__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__id__put Properties

function T_wp_v2_posts__id__put.date( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.date_gmt( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.slug( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.status( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.password( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.title( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.content( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.author( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.excerpt( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.featured_media( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.comment_status( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.ping_status( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.format_( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'format', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.meta( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.sticky( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'sticky', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.template( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.categories( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'categories', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__put.tags( _jd: TJSONData): T_wp_v2_posts__id__put; 
begin
     Property_( 'tags', _jd);
     Result:= Self;
end; 

 { T_wp_v2_posts__id__patch }

constructor T_wp_v2_posts__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_posts__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__id__patch Parameters

function T_wp_v2_posts__id__patch.id( _s: String): T_wp_v2_posts__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__id__patch Properties

function T_wp_v2_posts__id__patch.date( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.date_gmt( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.slug( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.status( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.password( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.title( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.content( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.author( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.excerpt( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.featured_media( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.comment_status( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.ping_status( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.format_( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'format', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.meta( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.sticky( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'sticky', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.template( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.categories( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'categories', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__patch.tags( _jd: TJSONData): T_wp_v2_posts__id__patch; 
begin
     Property_( 'tags', _jd);
     Result:= Self;
end; 

 { T_wp_v2_posts__id__delete }

constructor T_wp_v2_posts__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_posts__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__id__delete Parameters

function T_wp_v2_posts__id__delete.id( _s: String): T_wp_v2_posts__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__id__delete Properties

function T_wp_v2_posts__id__delete.force( _jd: TJSONData): T_wp_v2_posts__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/posts/{parent}/revisions

{ T_wp_v2_posts__parent__revisions_get }

constructor T_wp_v2_posts__parent__revisions_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{parent}/revisions';
     Verb:= 'get';
end;

destructor T_wp_v2_posts__parent__revisions_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__parent__revisions_get Parameters

function T_wp_v2_posts__parent__revisions_get.parent( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.context( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.page( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.per_page( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.search( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.exclude( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.include( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.offset( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.order( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions_get.orderby( _s: String): T_wp_v2_posts__parent__revisions_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__parent__revisions_get Properties

 

 
//Chemin  /wp/v2/posts/{parent}/revisions/{id}

{ T_wp_v2_posts__parent__revisions__id__get }

constructor T_wp_v2_posts__parent__revisions__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{parent}/revisions/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_posts__parent__revisions__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__parent__revisions__id__get Parameters

function T_wp_v2_posts__parent__revisions__id__get.parent( _s: String): T_wp_v2_posts__parent__revisions__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions__id__get.id( _s: String): T_wp_v2_posts__parent__revisions__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions__id__get.context( _s: String): T_wp_v2_posts__parent__revisions__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__parent__revisions__id__get Properties

 

 { T_wp_v2_posts__parent__revisions__id__delete }

constructor T_wp_v2_posts__parent__revisions__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{parent}/revisions/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_posts__parent__revisions__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__parent__revisions__id__delete Parameters

function T_wp_v2_posts__parent__revisions__id__delete.parent( _s: String): T_wp_v2_posts__parent__revisions__id__delete; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__revisions__id__delete.id( _s: String): T_wp_v2_posts__parent__revisions__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__parent__revisions__id__delete Properties

function T_wp_v2_posts__parent__revisions__id__delete.force( _jd: TJSONData): T_wp_v2_posts__parent__revisions__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/posts/{id}/autosaves

{ T_wp_v2_posts__id__autosaves_get }

constructor T_wp_v2_posts__id__autosaves_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{id}/autosaves';
     Verb:= 'get';
end;

destructor T_wp_v2_posts__id__autosaves_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__id__autosaves_get Parameters

function T_wp_v2_posts__id__autosaves_get.parent( _s: String): T_wp_v2_posts__id__autosaves_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_get.context( _s: String): T_wp_v2_posts__id__autosaves_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_get.id( _s: String): T_wp_v2_posts__id__autosaves_get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__id__autosaves_get Properties

 

 { T_wp_v2_posts__id__autosaves_post }

constructor T_wp_v2_posts__id__autosaves_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{id}/autosaves';
     Verb:= 'post';
end;

destructor T_wp_v2_posts__id__autosaves_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__id__autosaves_post Parameters

function T_wp_v2_posts__id__autosaves_post.id( _s: String): T_wp_v2_posts__id__autosaves_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__id__autosaves_post Properties

function T_wp_v2_posts__id__autosaves_post.parent( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.date( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.date_gmt( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.slug( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.status( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.password( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.title( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.content( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.author( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.excerpt( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.featured_media( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.comment_status( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.ping_status( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.format_( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'format', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.meta( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.sticky( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'sticky', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.template( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.categories( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'categories', _jd);
     Result:= Self;
end;
function T_wp_v2_posts__id__autosaves_post.tags( _jd: TJSONData): T_wp_v2_posts__id__autosaves_post; 
begin
     Property_( 'tags', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/posts/{parent}/autosaves/{id}

{ T_wp_v2_posts__parent__autosaves__id__get }

constructor T_wp_v2_posts__parent__autosaves__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/posts/{parent}/autosaves/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_posts__parent__autosaves__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_posts__parent__autosaves__id__get Parameters

function T_wp_v2_posts__parent__autosaves__id__get.parent( _s: String): T_wp_v2_posts__parent__autosaves__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__autosaves__id__get.id( _s: String): T_wp_v2_posts__parent__autosaves__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_posts__parent__autosaves__id__get.context( _s: String): T_wp_v2_posts__parent__autosaves__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_posts__parent__autosaves__id__get Properties

 

 
//Chemin  /wp/v2/pages

{ T_wp_v2_pages_get }

constructor T_wp_v2_pages_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages';
     Verb:= 'get';
end;

destructor T_wp_v2_pages_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages_get Parameters

function T_wp_v2_pages_get.context( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.page( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.per_page( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.search( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.after( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'after', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.modified_after( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'modified_after', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.author( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'author', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.author_exclude( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'author_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.before( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'before', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.modified_before( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'modified_before', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.exclude( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.include( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.menu_order( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'menu_order', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.search_semantics( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'search_semantics', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.offset( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.order( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.orderby( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.parent( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.parent_exclude( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'parent_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.search_columns( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'search_columns', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.slug( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_pages_get.status( _s: String): T_wp_v2_pages_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end; 

// T_wp_v2_pages_get Properties

 

 { T_wp_v2_pages_post }

constructor T_wp_v2_pages_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages';
     Verb:= 'post';
end;

destructor T_wp_v2_pages_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages_post Parameters

 

// T_wp_v2_pages_post Properties

function T_wp_v2_pages_post.date( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.date_gmt( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.slug( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.status( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.password( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.parent( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.title( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.content( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.author( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.excerpt( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.featured_media( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.comment_status( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.ping_status( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.menu_order( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.meta( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_pages_post.template( _jd: TJSONData): T_wp_v2_pages_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/pages/{id}

{ T_wp_v2_pages__id__get }

constructor T_wp_v2_pages__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_pages__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__id__get Parameters

function T_wp_v2_pages__id__get.id( _s: String): T_wp_v2_pages__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_pages__id__get.context( _s: String): T_wp_v2_pages__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_pages__id__get.excerpt_length( _s: String): T_wp_v2_pages__id__get; 
begin
     Parameter_Query( 'excerpt_length', _s);
     Result:= Self;
end;
function T_wp_v2_pages__id__get.password( _s: String): T_wp_v2_pages__id__get; 
begin
     Parameter_Query( 'password', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__id__get Properties

 

 { T_wp_v2_pages__id__post }

constructor T_wp_v2_pages__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_pages__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__id__post Parameters

function T_wp_v2_pages__id__post.id( _s: String): T_wp_v2_pages__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__id__post Properties

function T_wp_v2_pages__id__post.date( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.date_gmt( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.slug( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.status( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.password( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.parent( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.title( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.content( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.author( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.excerpt( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.featured_media( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.comment_status( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.ping_status( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.menu_order( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.meta( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__post.template( _jd: TJSONData): T_wp_v2_pages__id__post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 { T_wp_v2_pages__id__put }

constructor T_wp_v2_pages__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_pages__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__id__put Parameters

function T_wp_v2_pages__id__put.id( _s: String): T_wp_v2_pages__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__id__put Properties

function T_wp_v2_pages__id__put.date( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.date_gmt( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.slug( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.status( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.password( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.parent( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.title( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.content( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.author( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.excerpt( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.featured_media( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.comment_status( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.ping_status( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.menu_order( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.meta( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__put.template( _jd: TJSONData): T_wp_v2_pages__id__put; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 { T_wp_v2_pages__id__patch }

constructor T_wp_v2_pages__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_pages__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__id__patch Parameters

function T_wp_v2_pages__id__patch.id( _s: String): T_wp_v2_pages__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__id__patch Properties

function T_wp_v2_pages__id__patch.date( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.date_gmt( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.slug( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.status( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.password( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.parent( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.title( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.content( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.author( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.excerpt( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.featured_media( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.comment_status( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.ping_status( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.menu_order( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.meta( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__patch.template( _jd: TJSONData): T_wp_v2_pages__id__patch; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 { T_wp_v2_pages__id__delete }

constructor T_wp_v2_pages__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_pages__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__id__delete Parameters

function T_wp_v2_pages__id__delete.id( _s: String): T_wp_v2_pages__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__id__delete Properties

function T_wp_v2_pages__id__delete.force( _jd: TJSONData): T_wp_v2_pages__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/pages/{parent}/revisions

{ T_wp_v2_pages__parent__revisions_get }

constructor T_wp_v2_pages__parent__revisions_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{parent}/revisions';
     Verb:= 'get';
end;

destructor T_wp_v2_pages__parent__revisions_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__parent__revisions_get Parameters

function T_wp_v2_pages__parent__revisions_get.parent( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.context( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.page( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.per_page( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.search( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.exclude( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.include( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.offset( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.order( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions_get.orderby( _s: String): T_wp_v2_pages__parent__revisions_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__parent__revisions_get Properties

 

 
//Chemin  /wp/v2/pages/{parent}/revisions/{id}

{ T_wp_v2_pages__parent__revisions__id__get }

constructor T_wp_v2_pages__parent__revisions__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{parent}/revisions/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_pages__parent__revisions__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__parent__revisions__id__get Parameters

function T_wp_v2_pages__parent__revisions__id__get.parent( _s: String): T_wp_v2_pages__parent__revisions__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions__id__get.id( _s: String): T_wp_v2_pages__parent__revisions__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions__id__get.context( _s: String): T_wp_v2_pages__parent__revisions__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__parent__revisions__id__get Properties

 

 { T_wp_v2_pages__parent__revisions__id__delete }

constructor T_wp_v2_pages__parent__revisions__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{parent}/revisions/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_pages__parent__revisions__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__parent__revisions__id__delete Parameters

function T_wp_v2_pages__parent__revisions__id__delete.parent( _s: String): T_wp_v2_pages__parent__revisions__id__delete; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__revisions__id__delete.id( _s: String): T_wp_v2_pages__parent__revisions__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__parent__revisions__id__delete Properties

function T_wp_v2_pages__parent__revisions__id__delete.force( _jd: TJSONData): T_wp_v2_pages__parent__revisions__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/pages/{id}/autosaves

{ T_wp_v2_pages__id__autosaves_get }

constructor T_wp_v2_pages__id__autosaves_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{id}/autosaves';
     Verb:= 'get';
end;

destructor T_wp_v2_pages__id__autosaves_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__id__autosaves_get Parameters

function T_wp_v2_pages__id__autosaves_get.parent( _s: String): T_wp_v2_pages__id__autosaves_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_get.context( _s: String): T_wp_v2_pages__id__autosaves_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_get.id( _s: String): T_wp_v2_pages__id__autosaves_get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__id__autosaves_get Properties

 

 { T_wp_v2_pages__id__autosaves_post }

constructor T_wp_v2_pages__id__autosaves_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{id}/autosaves';
     Verb:= 'post';
end;

destructor T_wp_v2_pages__id__autosaves_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__id__autosaves_post Parameters

function T_wp_v2_pages__id__autosaves_post.id( _s: String): T_wp_v2_pages__id__autosaves_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__id__autosaves_post Properties

function T_wp_v2_pages__id__autosaves_post.parent( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.date( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.date_gmt( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.slug( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.status( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.password( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.title( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.content( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.author( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.excerpt( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.featured_media( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.comment_status( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.ping_status( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.menu_order( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.meta( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_pages__id__autosaves_post.template( _jd: TJSONData): T_wp_v2_pages__id__autosaves_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/pages/{parent}/autosaves/{id}

{ T_wp_v2_pages__parent__autosaves__id__get }

constructor T_wp_v2_pages__parent__autosaves__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pages/{parent}/autosaves/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_pages__parent__autosaves__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pages__parent__autosaves__id__get Parameters

function T_wp_v2_pages__parent__autosaves__id__get.parent( _s: String): T_wp_v2_pages__parent__autosaves__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__autosaves__id__get.id( _s: String): T_wp_v2_pages__parent__autosaves__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_pages__parent__autosaves__id__get.context( _s: String): T_wp_v2_pages__parent__autosaves__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_pages__parent__autosaves__id__get Properties

 

 
//Chemin  /wp/v2/media

{ T_wp_v2_media_get }

constructor T_wp_v2_media_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media';
     Verb:= 'get';
end;

destructor T_wp_v2_media_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media_get Parameters

function T_wp_v2_media_get.context( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.page( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.per_page( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.search( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.after( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'after', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.modified_after( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'modified_after', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.author( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'author', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.author_exclude( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'author_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.before( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'before', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.modified_before( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'modified_before', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.exclude( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.include( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.search_semantics( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'search_semantics', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.offset( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.order( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.orderby( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.parent( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.parent_exclude( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'parent_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.search_columns( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'search_columns', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.slug( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.status( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.media_type( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'media_type', _s);
     Result:= Self;
end;
function T_wp_v2_media_get.mime_type( _s: String): T_wp_v2_media_get; 
begin
     Parameter_Query( 'mime_type', _s);
     Result:= Self;
end; 

// T_wp_v2_media_get Properties

 

 { T_wp_v2_media_post }

constructor T_wp_v2_media_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media';
     Verb:= 'post';
end;

destructor T_wp_v2_media_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media_post Parameters

 

// T_wp_v2_media_post Properties

function T_wp_v2_media_post.date( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.date_gmt( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.slug( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.status( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.title( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.author( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.featured_media( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.comment_status( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.ping_status( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.meta( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.template( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.alt_text( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'alt_text', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.caption( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'caption', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.description( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_media_post.post( _jd: TJSONData): T_wp_v2_media_post; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/media/{id}

{ T_wp_v2_media__id__get }

constructor T_wp_v2_media__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_media__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media__id__get Parameters

function T_wp_v2_media__id__get.id( _s: String): T_wp_v2_media__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_media__id__get.context( _s: String): T_wp_v2_media__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_media__id__get Properties

 

 { T_wp_v2_media__id__post }

constructor T_wp_v2_media__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_media__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media__id__post Parameters

function T_wp_v2_media__id__post.id( _s: String): T_wp_v2_media__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_media__id__post Properties

function T_wp_v2_media__id__post.date( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.date_gmt( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.slug( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.status( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.title( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.author( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.featured_media( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.comment_status( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.ping_status( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.meta( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.template( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.alt_text( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'alt_text', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.caption( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'caption', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.description( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__post.post( _jd: TJSONData): T_wp_v2_media__id__post; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end; 

 { T_wp_v2_media__id__put }

constructor T_wp_v2_media__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_media__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media__id__put Parameters

function T_wp_v2_media__id__put.id( _s: String): T_wp_v2_media__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_media__id__put Properties

function T_wp_v2_media__id__put.date( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.date_gmt( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.slug( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.status( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.title( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.author( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.featured_media( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.comment_status( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.ping_status( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.meta( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.template( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.alt_text( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'alt_text', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.caption( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'caption', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.description( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__put.post( _jd: TJSONData): T_wp_v2_media__id__put; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end; 

 { T_wp_v2_media__id__patch }

constructor T_wp_v2_media__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_media__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media__id__patch Parameters

function T_wp_v2_media__id__patch.id( _s: String): T_wp_v2_media__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_media__id__patch Properties

function T_wp_v2_media__id__patch.date( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.date_gmt( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.slug( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.status( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.title( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.author( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.featured_media( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'featured_media', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.comment_status( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.ping_status( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.meta( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.template( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.alt_text( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'alt_text', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.caption( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'caption', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.description( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__patch.post( _jd: TJSONData): T_wp_v2_media__id__patch; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end; 

 { T_wp_v2_media__id__delete }

constructor T_wp_v2_media__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_media__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media__id__delete Parameters

function T_wp_v2_media__id__delete.id( _s: String): T_wp_v2_media__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_media__id__delete Properties

function T_wp_v2_media__id__delete.force( _jd: TJSONData): T_wp_v2_media__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/media/{id}/post-process

{ T_wp_v2_media__id__post_process_post }

constructor T_wp_v2_media__id__post_process_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media/{id}/post-process';
     Verb:= 'post';
end;

destructor T_wp_v2_media__id__post_process_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media__id__post_process_post Parameters

function T_wp_v2_media__id__post_process_post.id( _s: String): T_wp_v2_media__id__post_process_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_media__id__post_process_post Properties

function T_wp_v2_media__id__post_process_post.action( _jd: TJSONData): T_wp_v2_media__id__post_process_post; 
begin
     Property_( 'action', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/media/{id}/edit

{ T_wp_v2_media__id__edit_post }

constructor T_wp_v2_media__id__edit_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/media/{id}/edit';
     Verb:= 'post';
end;

destructor T_wp_v2_media__id__edit_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_media__id__edit_post Parameters

function T_wp_v2_media__id__edit_post.id( _s: String): T_wp_v2_media__id__edit_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_media__id__edit_post Properties

function T_wp_v2_media__id__edit_post.src( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'src', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.modifiers( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'modifiers', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.rotation( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'rotation', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.x( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'x', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.y( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'y', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.width( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'width', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.height( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'height', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.caption( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'caption', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.description( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.title( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.post( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end;
function T_wp_v2_media__id__edit_post.alt_text( _jd: TJSONData): T_wp_v2_media__id__edit_post; 
begin
     Property_( 'alt_text', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/menu-items

{ T_wp_v2_menu_items_get }

constructor T_wp_v2_menu_items_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items';
     Verb:= 'get';
end;

destructor T_wp_v2_menu_items_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items_get Parameters

function T_wp_v2_menu_items_get.context( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.page( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.per_page( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.search( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.after( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'after', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.modified_after( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'modified_after', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.before( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'before', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.modified_before( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'modified_before', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.exclude( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.include( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.search_semantics( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'search_semantics', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.offset( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.order( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.orderby( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.search_columns( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'search_columns', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.slug( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.status( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.tax_relation( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'tax_relation', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.menus( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'menus', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.menus_exclude( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'menus_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items_get.menu_order( _s: String): T_wp_v2_menu_items_get; 
begin
     Parameter_Query( 'menu_order', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items_get Properties

 

 { T_wp_v2_menu_items_post }

constructor T_wp_v2_menu_items_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items';
     Verb:= 'post';
end;

destructor T_wp_v2_menu_items_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items_post Parameters

 

// T_wp_v2_menu_items_post Properties

function T_wp_v2_menu_items_post.title( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.type_( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.status( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.parent( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.attr_title( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'attr_title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.classes( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'classes', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.description( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.menu_order( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.object_( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'object', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.object_id( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'object_id', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.target( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'target', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.url_( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.xfn( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'xfn', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.menus( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'menus', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items_post.meta( _jd: TJSONData): T_wp_v2_menu_items_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/menu-items/{id}

{ T_wp_v2_menu_items__id__get }

constructor T_wp_v2_menu_items__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_menu_items__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items__id__get Parameters

function T_wp_v2_menu_items__id__get.id( _s: String): T_wp_v2_menu_items__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__get.context( _s: String): T_wp_v2_menu_items__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items__id__get Properties

 

 { T_wp_v2_menu_items__id__post }

constructor T_wp_v2_menu_items__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_menu_items__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items__id__post Parameters

function T_wp_v2_menu_items__id__post.id( _s: String): T_wp_v2_menu_items__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items__id__post Properties

function T_wp_v2_menu_items__id__post.title( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.type_( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.status( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.parent( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.attr_title( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'attr_title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.classes( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'classes', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.description( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.menu_order( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.object_( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'object', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.object_id( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'object_id', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.target( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'target', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.url_( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.xfn( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'xfn', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.menus( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'menus', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__post.meta( _jd: TJSONData): T_wp_v2_menu_items__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_menu_items__id__put }

constructor T_wp_v2_menu_items__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_menu_items__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items__id__put Parameters

function T_wp_v2_menu_items__id__put.id( _s: String): T_wp_v2_menu_items__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items__id__put Properties

function T_wp_v2_menu_items__id__put.title( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.type_( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.status( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.parent( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.attr_title( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'attr_title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.classes( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'classes', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.description( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.menu_order( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.object_( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'object', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.object_id( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'object_id', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.target( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'target', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.url_( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.xfn( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'xfn', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.menus( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'menus', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__put.meta( _jd: TJSONData): T_wp_v2_menu_items__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_menu_items__id__patch }

constructor T_wp_v2_menu_items__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_menu_items__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items__id__patch Parameters

function T_wp_v2_menu_items__id__patch.id( _s: String): T_wp_v2_menu_items__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items__id__patch Properties

function T_wp_v2_menu_items__id__patch.title( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.type_( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.status( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.parent( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.attr_title( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'attr_title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.classes( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'classes', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.description( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.menu_order( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.object_( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'object', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.object_id( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'object_id', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.target( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'target', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.url_( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.xfn( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'xfn', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.menus( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'menus', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__patch.meta( _jd: TJSONData): T_wp_v2_menu_items__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_menu_items__id__delete }

constructor T_wp_v2_menu_items__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_menu_items__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items__id__delete Parameters

function T_wp_v2_menu_items__id__delete.id( _s: String): T_wp_v2_menu_items__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items__id__delete Properties

function T_wp_v2_menu_items__id__delete.force( _jd: TJSONData): T_wp_v2_menu_items__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/menu-items/{id}/autosaves

{ T_wp_v2_menu_items__id__autosaves_get }

constructor T_wp_v2_menu_items__id__autosaves_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items/{id}/autosaves';
     Verb:= 'get';
end;

destructor T_wp_v2_menu_items__id__autosaves_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items__id__autosaves_get Parameters

function T_wp_v2_menu_items__id__autosaves_get.parent( _s: String): T_wp_v2_menu_items__id__autosaves_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_get.context( _s: String): T_wp_v2_menu_items__id__autosaves_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_get.id( _s: String): T_wp_v2_menu_items__id__autosaves_get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items__id__autosaves_get Properties

 

 { T_wp_v2_menu_items__id__autosaves_post }

constructor T_wp_v2_menu_items__id__autosaves_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items/{id}/autosaves';
     Verb:= 'post';
end;

destructor T_wp_v2_menu_items__id__autosaves_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items__id__autosaves_post Parameters

function T_wp_v2_menu_items__id__autosaves_post.id( _s: String): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items__id__autosaves_post Properties

function T_wp_v2_menu_items__id__autosaves_post.parent( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.title( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.type_( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.status( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.attr_title( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'attr_title', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.classes( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'classes', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.description( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.menu_order( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'menu_order', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.object_( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'object', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.object_id( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'object_id', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.target( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'target', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.url_( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.xfn( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'xfn', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.menus( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'menus', _jd);
     Result:= Self;
end;
function T_wp_v2_menu_items__id__autosaves_post.meta( _jd: TJSONData): T_wp_v2_menu_items__id__autosaves_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/menu-items/{parent}/autosaves/{id}

{ T_wp_v2_menu_items__parent__autosaves__id__get }

constructor T_wp_v2_menu_items__parent__autosaves__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-items/{parent}/autosaves/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_menu_items__parent__autosaves__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_items__parent__autosaves__id__get Parameters

function T_wp_v2_menu_items__parent__autosaves__id__get.parent( _s: String): T_wp_v2_menu_items__parent__autosaves__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items__parent__autosaves__id__get.id( _s: String): T_wp_v2_menu_items__parent__autosaves__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_menu_items__parent__autosaves__id__get.context( _s: String): T_wp_v2_menu_items__parent__autosaves__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_items__parent__autosaves__id__get Properties

 

 
//Chemin  /wp/v2/blocks

{ T_wp_v2_blocks_get }

constructor T_wp_v2_blocks_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks';
     Verb:= 'get';
end;

destructor T_wp_v2_blocks_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks_get Parameters

function T_wp_v2_blocks_get.context( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.page( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.per_page( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.search( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.after( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'after', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.modified_after( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'modified_after', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.before( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'before', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.modified_before( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'modified_before', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.exclude( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.include( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.search_semantics( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'search_semantics', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.offset( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.order( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.orderby( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.search_columns( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'search_columns', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.slug( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.status( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.tax_relation( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'tax_relation', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.wp_pattern_category( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'wp_pattern_category', _s);
     Result:= Self;
end;
function T_wp_v2_blocks_get.wp_pattern_category_exclude( _s: String): T_wp_v2_blocks_get; 
begin
     Parameter_Query( 'wp_pattern_category_exclude', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks_get Properties

 

 { T_wp_v2_blocks_post }

constructor T_wp_v2_blocks_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks';
     Verb:= 'post';
end;

destructor T_wp_v2_blocks_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks_post Parameters

 

// T_wp_v2_blocks_post Properties

function T_wp_v2_blocks_post.date( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.date_gmt( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.slug( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.status( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.password( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.title( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.content( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.excerpt( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.meta( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.template( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks_post.wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks_post; 
begin
     Property_( 'wp_pattern_category', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/blocks/{id}

{ T_wp_v2_blocks__id__get }

constructor T_wp_v2_blocks__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_blocks__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__id__get Parameters

function T_wp_v2_blocks__id__get.id( _s: String): T_wp_v2_blocks__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__id__get.context( _s: String): T_wp_v2_blocks__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__id__get.excerpt_length( _s: String): T_wp_v2_blocks__id__get; 
begin
     Parameter_Query( 'excerpt_length', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__id__get.password( _s: String): T_wp_v2_blocks__id__get; 
begin
     Parameter_Query( 'password', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__id__get Properties

 

 { T_wp_v2_blocks__id__post }

constructor T_wp_v2_blocks__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_blocks__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__id__post Parameters

function T_wp_v2_blocks__id__post.id( _s: String): T_wp_v2_blocks__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__id__post Properties

function T_wp_v2_blocks__id__post.date( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.date_gmt( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.slug( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.status( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.password( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.title( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.content( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.excerpt( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.meta( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.template( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__post.wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks__id__post; 
begin
     Property_( 'wp_pattern_category', _jd);
     Result:= Self;
end; 

 { T_wp_v2_blocks__id__put }

constructor T_wp_v2_blocks__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_blocks__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__id__put Parameters

function T_wp_v2_blocks__id__put.id( _s: String): T_wp_v2_blocks__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__id__put Properties

function T_wp_v2_blocks__id__put.date( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.date_gmt( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.slug( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.status( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.password( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.title( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.content( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.excerpt( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.meta( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.template( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__put.wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks__id__put; 
begin
     Property_( 'wp_pattern_category', _jd);
     Result:= Self;
end; 

 { T_wp_v2_blocks__id__patch }

constructor T_wp_v2_blocks__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_blocks__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__id__patch Parameters

function T_wp_v2_blocks__id__patch.id( _s: String): T_wp_v2_blocks__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__id__patch Properties

function T_wp_v2_blocks__id__patch.date( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.date_gmt( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.slug( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.status( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.password( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.title( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.content( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.excerpt( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.meta( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.template( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__patch.wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks__id__patch; 
begin
     Property_( 'wp_pattern_category', _jd);
     Result:= Self;
end; 

 { T_wp_v2_blocks__id__delete }

constructor T_wp_v2_blocks__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_blocks__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__id__delete Parameters

function T_wp_v2_blocks__id__delete.id( _s: String): T_wp_v2_blocks__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__id__delete Properties

function T_wp_v2_blocks__id__delete.force( _jd: TJSONData): T_wp_v2_blocks__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/blocks/{parent}/revisions

{ T_wp_v2_blocks__parent__revisions_get }

constructor T_wp_v2_blocks__parent__revisions_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{parent}/revisions';
     Verb:= 'get';
end;

destructor T_wp_v2_blocks__parent__revisions_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__parent__revisions_get Parameters

function T_wp_v2_blocks__parent__revisions_get.parent( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.context( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.page( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.per_page( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.search( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.exclude( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.include( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.offset( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.order( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions_get.orderby( _s: String): T_wp_v2_blocks__parent__revisions_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__parent__revisions_get Properties

 

 
//Chemin  /wp/v2/blocks/{parent}/revisions/{id}

{ T_wp_v2_blocks__parent__revisions__id__get }

constructor T_wp_v2_blocks__parent__revisions__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{parent}/revisions/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_blocks__parent__revisions__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__parent__revisions__id__get Parameters

function T_wp_v2_blocks__parent__revisions__id__get.parent( _s: String): T_wp_v2_blocks__parent__revisions__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions__id__get.id( _s: String): T_wp_v2_blocks__parent__revisions__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions__id__get.context( _s: String): T_wp_v2_blocks__parent__revisions__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__parent__revisions__id__get Properties

 

 { T_wp_v2_blocks__parent__revisions__id__delete }

constructor T_wp_v2_blocks__parent__revisions__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{parent}/revisions/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_blocks__parent__revisions__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__parent__revisions__id__delete Parameters

function T_wp_v2_blocks__parent__revisions__id__delete.parent( _s: String): T_wp_v2_blocks__parent__revisions__id__delete; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__revisions__id__delete.id( _s: String): T_wp_v2_blocks__parent__revisions__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__parent__revisions__id__delete Properties

function T_wp_v2_blocks__parent__revisions__id__delete.force( _jd: TJSONData): T_wp_v2_blocks__parent__revisions__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/blocks/{id}/autosaves

{ T_wp_v2_blocks__id__autosaves_get }

constructor T_wp_v2_blocks__id__autosaves_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{id}/autosaves';
     Verb:= 'get';
end;

destructor T_wp_v2_blocks__id__autosaves_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__id__autosaves_get Parameters

function T_wp_v2_blocks__id__autosaves_get.parent( _s: String): T_wp_v2_blocks__id__autosaves_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_get.context( _s: String): T_wp_v2_blocks__id__autosaves_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_get.id( _s: String): T_wp_v2_blocks__id__autosaves_get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__id__autosaves_get Properties

 

 { T_wp_v2_blocks__id__autosaves_post }

constructor T_wp_v2_blocks__id__autosaves_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{id}/autosaves';
     Verb:= 'post';
end;

destructor T_wp_v2_blocks__id__autosaves_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__id__autosaves_post Parameters

function T_wp_v2_blocks__id__autosaves_post.id( _s: String): T_wp_v2_blocks__id__autosaves_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__id__autosaves_post Properties

function T_wp_v2_blocks__id__autosaves_post.parent( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.date( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.date_gmt( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.slug( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.status( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.password( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.title( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.content( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.excerpt( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'excerpt', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.meta( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.template( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end;
function T_wp_v2_blocks__id__autosaves_post.wp_pattern_category( _jd: TJSONData): T_wp_v2_blocks__id__autosaves_post; 
begin
     Property_( 'wp_pattern_category', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/blocks/{parent}/autosaves/{id}

{ T_wp_v2_blocks__parent__autosaves__id__get }

constructor T_wp_v2_blocks__parent__autosaves__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/blocks/{parent}/autosaves/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_blocks__parent__autosaves__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_blocks__parent__autosaves__id__get Parameters

function T_wp_v2_blocks__parent__autosaves__id__get.parent( _s: String): T_wp_v2_blocks__parent__autosaves__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__autosaves__id__get.id( _s: String): T_wp_v2_blocks__parent__autosaves__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_blocks__parent__autosaves__id__get.context( _s: String): T_wp_v2_blocks__parent__autosaves__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_blocks__parent__autosaves__id__get Properties

 

 
//Chemin  /wp/v2/templates/{parent}/revisions

{ T_wp_v2_templates__parent__revisions_get }

constructor T_wp_v2_templates__parent__revisions_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{parent}/revisions';
     Verb:= 'get';
end;

destructor T_wp_v2_templates__parent__revisions_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__parent__revisions_get Parameters

function T_wp_v2_templates__parent__revisions_get.parent( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.context( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.page( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.per_page( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.search( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.exclude( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.include( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.offset( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.order( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions_get.orderby( _s: String): T_wp_v2_templates__parent__revisions_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__parent__revisions_get Properties

 

 
//Chemin  /wp/v2/templates/{parent}/revisions/{id}

{ T_wp_v2_templates__parent__revisions__id__get }

constructor T_wp_v2_templates__parent__revisions__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{parent}/revisions/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_templates__parent__revisions__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__parent__revisions__id__get Parameters

function T_wp_v2_templates__parent__revisions__id__get.parent( _s: String): T_wp_v2_templates__parent__revisions__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions__id__get.id( _s: String): T_wp_v2_templates__parent__revisions__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions__id__get.context( _s: String): T_wp_v2_templates__parent__revisions__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__parent__revisions__id__get Properties

 

 { T_wp_v2_templates__parent__revisions__id__delete }

constructor T_wp_v2_templates__parent__revisions__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{parent}/revisions/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_templates__parent__revisions__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__parent__revisions__id__delete Parameters

function T_wp_v2_templates__parent__revisions__id__delete.parent( _s: String): T_wp_v2_templates__parent__revisions__id__delete; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__revisions__id__delete.id( _s: String): T_wp_v2_templates__parent__revisions__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__parent__revisions__id__delete Properties

function T_wp_v2_templates__parent__revisions__id__delete.force( _jd: TJSONData): T_wp_v2_templates__parent__revisions__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/templates/{id}/autosaves

{ T_wp_v2_templates__id__autosaves_get }

constructor T_wp_v2_templates__id__autosaves_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{id}/autosaves';
     Verb:= 'get';
end;

destructor T_wp_v2_templates__id__autosaves_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__id__autosaves_get Parameters

function T_wp_v2_templates__id__autosaves_get.id( _s: String): T_wp_v2_templates__id__autosaves_get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_templates__id__autosaves_get.context( _s: String): T_wp_v2_templates__id__autosaves_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__id__autosaves_get Properties

 

 { T_wp_v2_templates__id__autosaves_post }

constructor T_wp_v2_templates__id__autosaves_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{id}/autosaves';
     Verb:= 'post';
end;

destructor T_wp_v2_templates__id__autosaves_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__id__autosaves_post Parameters

function T_wp_v2_templates__id__autosaves_post.id( _s: String): T_wp_v2_templates__id__autosaves_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__id__autosaves_post Properties

function T_wp_v2_templates__id__autosaves_post.slug( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__autosaves_post.theme( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__autosaves_post.type_( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__autosaves_post.content( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__autosaves_post.title( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__autosaves_post.description( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__autosaves_post.status( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__autosaves_post.author( _jd: TJSONData): T_wp_v2_templates__id__autosaves_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/templates/{parent}/autosaves/{id}

{ T_wp_v2_templates__parent__autosaves__id__get }

constructor T_wp_v2_templates__parent__autosaves__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{parent}/autosaves/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_templates__parent__autosaves__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__parent__autosaves__id__get Parameters

function T_wp_v2_templates__parent__autosaves__id__get.parent( _s: String): T_wp_v2_templates__parent__autosaves__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__autosaves__id__get.id( _s: String): T_wp_v2_templates__parent__autosaves__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_templates__parent__autosaves__id__get.context( _s: String): T_wp_v2_templates__parent__autosaves__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__parent__autosaves__id__get Properties

 

 
//Chemin  /wp/v2/templates

{ T_wp_v2_templates_get }

constructor T_wp_v2_templates_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates';
     Verb:= 'get';
end;

destructor T_wp_v2_templates_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates_get Parameters

function T_wp_v2_templates_get.context( _s: String): T_wp_v2_templates_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_templates_get.wp_id( _s: String): T_wp_v2_templates_get; 
begin
     Parameter_Query( 'wp_id', _s);
     Result:= Self;
end;
function T_wp_v2_templates_get.area( _s: String): T_wp_v2_templates_get; 
begin
     Parameter_Query( 'area', _s);
     Result:= Self;
end;
function T_wp_v2_templates_get.post_type( _s: String): T_wp_v2_templates_get; 
begin
     Parameter_Query( 'post_type', _s);
     Result:= Self;
end; 

// T_wp_v2_templates_get Properties

 

 { T_wp_v2_templates_post }

constructor T_wp_v2_templates_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates';
     Verb:= 'post';
end;

destructor T_wp_v2_templates_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates_post Parameters

 

// T_wp_v2_templates_post Properties

function T_wp_v2_templates_post.slug( _jd: TJSONData): T_wp_v2_templates_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_templates_post.theme( _jd: TJSONData): T_wp_v2_templates_post; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_templates_post.type_( _jd: TJSONData): T_wp_v2_templates_post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_templates_post.content( _jd: TJSONData): T_wp_v2_templates_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_templates_post.title( _jd: TJSONData): T_wp_v2_templates_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_templates_post.description( _jd: TJSONData): T_wp_v2_templates_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_templates_post.status( _jd: TJSONData): T_wp_v2_templates_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_templates_post.author( _jd: TJSONData): T_wp_v2_templates_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/templates/lookup

{ T_wp_v2_templates_lookup_get }

constructor T_wp_v2_templates_lookup_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/lookup';
     Verb:= 'get';
end;

destructor T_wp_v2_templates_lookup_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates_lookup_get Parameters

function T_wp_v2_templates_lookup_get.slug( _s: String): T_wp_v2_templates_lookup_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_templates_lookup_get.is_custom( _s: String): T_wp_v2_templates_lookup_get; 
begin
     Parameter_Query( 'is_custom', _s);
     Result:= Self;
end;
function T_wp_v2_templates_lookup_get.template_prefix( _s: String): T_wp_v2_templates_lookup_get; 
begin
     Parameter_Query( 'template_prefix', _s);
     Result:= Self;
end; 

// T_wp_v2_templates_lookup_get Properties

 

 
//Chemin  /wp/v2/templates/{id}

{ T_wp_v2_templates__id__get }

constructor T_wp_v2_templates__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_templates__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__id__get Parameters

function T_wp_v2_templates__id__get.id( _s: String): T_wp_v2_templates__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_templates__id__get.context( _s: String): T_wp_v2_templates__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__id__get Properties

 

 { T_wp_v2_templates__id__post }

constructor T_wp_v2_templates__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_templates__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__id__post Parameters

function T_wp_v2_templates__id__post.id( _s: String): T_wp_v2_templates__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__id__post Properties

function T_wp_v2_templates__id__post.slug( _jd: TJSONData): T_wp_v2_templates__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__post.theme( _jd: TJSONData): T_wp_v2_templates__id__post; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__post.type_( _jd: TJSONData): T_wp_v2_templates__id__post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__post.content( _jd: TJSONData): T_wp_v2_templates__id__post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__post.title( _jd: TJSONData): T_wp_v2_templates__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__post.description( _jd: TJSONData): T_wp_v2_templates__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__post.status( _jd: TJSONData): T_wp_v2_templates__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__post.author( _jd: TJSONData): T_wp_v2_templates__id__post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end; 

 { T_wp_v2_templates__id__put }

constructor T_wp_v2_templates__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_templates__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__id__put Parameters

function T_wp_v2_templates__id__put.id( _s: String): T_wp_v2_templates__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__id__put Properties

function T_wp_v2_templates__id__put.slug( _jd: TJSONData): T_wp_v2_templates__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__put.theme( _jd: TJSONData): T_wp_v2_templates__id__put; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__put.type_( _jd: TJSONData): T_wp_v2_templates__id__put; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__put.content( _jd: TJSONData): T_wp_v2_templates__id__put; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__put.title( _jd: TJSONData): T_wp_v2_templates__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__put.description( _jd: TJSONData): T_wp_v2_templates__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__put.status( _jd: TJSONData): T_wp_v2_templates__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__put.author( _jd: TJSONData): T_wp_v2_templates__id__put; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end; 

 { T_wp_v2_templates__id__patch }

constructor T_wp_v2_templates__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_templates__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__id__patch Parameters

function T_wp_v2_templates__id__patch.id( _s: String): T_wp_v2_templates__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__id__patch Properties

function T_wp_v2_templates__id__patch.slug( _jd: TJSONData): T_wp_v2_templates__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__patch.theme( _jd: TJSONData): T_wp_v2_templates__id__patch; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__patch.type_( _jd: TJSONData): T_wp_v2_templates__id__patch; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__patch.content( _jd: TJSONData): T_wp_v2_templates__id__patch; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__patch.title( _jd: TJSONData): T_wp_v2_templates__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__patch.description( _jd: TJSONData): T_wp_v2_templates__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__patch.status( _jd: TJSONData): T_wp_v2_templates__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_templates__id__patch.author( _jd: TJSONData): T_wp_v2_templates__id__patch; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end; 

 { T_wp_v2_templates__id__delete }

constructor T_wp_v2_templates__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/templates/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_templates__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_templates__id__delete Parameters

function T_wp_v2_templates__id__delete.id( _s: String): T_wp_v2_templates__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_templates__id__delete Properties

function T_wp_v2_templates__id__delete.force( _jd: TJSONData): T_wp_v2_templates__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/template-parts/{parent}/revisions

{ T_wp_v2_template_parts__parent__revisions_get }

constructor T_wp_v2_template_parts__parent__revisions_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{parent}/revisions';
     Verb:= 'get';
end;

destructor T_wp_v2_template_parts__parent__revisions_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__parent__revisions_get Parameters

function T_wp_v2_template_parts__parent__revisions_get.parent( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.context( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.page( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.per_page( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.search( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.exclude( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.include( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.offset( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.order( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions_get.orderby( _s: String): T_wp_v2_template_parts__parent__revisions_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__parent__revisions_get Properties

 

 
//Chemin  /wp/v2/template-parts/{parent}/revisions/{id}

{ T_wp_v2_template_parts__parent__revisions__id__get }

constructor T_wp_v2_template_parts__parent__revisions__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{parent}/revisions/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_template_parts__parent__revisions__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__parent__revisions__id__get Parameters

function T_wp_v2_template_parts__parent__revisions__id__get.parent( _s: String): T_wp_v2_template_parts__parent__revisions__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions__id__get.id( _s: String): T_wp_v2_template_parts__parent__revisions__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions__id__get.context( _s: String): T_wp_v2_template_parts__parent__revisions__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__parent__revisions__id__get Properties

 

 { T_wp_v2_template_parts__parent__revisions__id__delete }

constructor T_wp_v2_template_parts__parent__revisions__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{parent}/revisions/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_template_parts__parent__revisions__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__parent__revisions__id__delete Parameters

function T_wp_v2_template_parts__parent__revisions__id__delete.parent( _s: String): T_wp_v2_template_parts__parent__revisions__id__delete; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__revisions__id__delete.id( _s: String): T_wp_v2_template_parts__parent__revisions__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__parent__revisions__id__delete Properties

function T_wp_v2_template_parts__parent__revisions__id__delete.force( _jd: TJSONData): T_wp_v2_template_parts__parent__revisions__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/template-parts/{id}/autosaves

{ T_wp_v2_template_parts__id__autosaves_get }

constructor T_wp_v2_template_parts__id__autosaves_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{id}/autosaves';
     Verb:= 'get';
end;

destructor T_wp_v2_template_parts__id__autosaves_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__id__autosaves_get Parameters

function T_wp_v2_template_parts__id__autosaves_get.id( _s: String): T_wp_v2_template_parts__id__autosaves_get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_get.context( _s: String): T_wp_v2_template_parts__id__autosaves_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__id__autosaves_get Properties

 

 { T_wp_v2_template_parts__id__autosaves_post }

constructor T_wp_v2_template_parts__id__autosaves_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{id}/autosaves';
     Verb:= 'post';
end;

destructor T_wp_v2_template_parts__id__autosaves_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__id__autosaves_post Parameters

function T_wp_v2_template_parts__id__autosaves_post.id( _s: String): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__id__autosaves_post Properties

function T_wp_v2_template_parts__id__autosaves_post.slug( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_post.theme( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_post.type_( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_post.content( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_post.title( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_post.description( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_post.status( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_post.author( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__autosaves_post.area( _jd: TJSONData): T_wp_v2_template_parts__id__autosaves_post; 
begin
     Property_( 'area', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/template-parts/{parent}/autosaves/{id}

{ T_wp_v2_template_parts__parent__autosaves__id__get }

constructor T_wp_v2_template_parts__parent__autosaves__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{parent}/autosaves/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_template_parts__parent__autosaves__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__parent__autosaves__id__get Parameters

function T_wp_v2_template_parts__parent__autosaves__id__get.parent( _s: String): T_wp_v2_template_parts__parent__autosaves__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__autosaves__id__get.id( _s: String): T_wp_v2_template_parts__parent__autosaves__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__parent__autosaves__id__get.context( _s: String): T_wp_v2_template_parts__parent__autosaves__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__parent__autosaves__id__get Properties

 

 
//Chemin  /wp/v2/template-parts

{ T_wp_v2_template_parts_get }

constructor T_wp_v2_template_parts_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts';
     Verb:= 'get';
end;

destructor T_wp_v2_template_parts_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts_get Parameters

function T_wp_v2_template_parts_get.context( _s: String): T_wp_v2_template_parts_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts_get.wp_id( _s: String): T_wp_v2_template_parts_get; 
begin
     Parameter_Query( 'wp_id', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts_get.area( _s: String): T_wp_v2_template_parts_get; 
begin
     Parameter_Query( 'area', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts_get.post_type( _s: String): T_wp_v2_template_parts_get; 
begin
     Parameter_Query( 'post_type', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts_get Properties

 

 { T_wp_v2_template_parts_post }

constructor T_wp_v2_template_parts_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts';
     Verb:= 'post';
end;

destructor T_wp_v2_template_parts_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts_post Parameters

 

// T_wp_v2_template_parts_post Properties

function T_wp_v2_template_parts_post.slug( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts_post.theme( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts_post.type_( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts_post.content( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts_post.title( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts_post.description( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts_post.status( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts_post.author( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts_post.area( _jd: TJSONData): T_wp_v2_template_parts_post; 
begin
     Property_( 'area', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/template-parts/lookup

{ T_wp_v2_template_parts_lookup_get }

constructor T_wp_v2_template_parts_lookup_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/lookup';
     Verb:= 'get';
end;

destructor T_wp_v2_template_parts_lookup_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts_lookup_get Parameters

function T_wp_v2_template_parts_lookup_get.slug( _s: String): T_wp_v2_template_parts_lookup_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts_lookup_get.is_custom( _s: String): T_wp_v2_template_parts_lookup_get; 
begin
     Parameter_Query( 'is_custom', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts_lookup_get.template_prefix( _s: String): T_wp_v2_template_parts_lookup_get; 
begin
     Parameter_Query( 'template_prefix', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts_lookup_get Properties

 

 
//Chemin  /wp/v2/template-parts/{id}

{ T_wp_v2_template_parts__id__get }

constructor T_wp_v2_template_parts__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_template_parts__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__id__get Parameters

function T_wp_v2_template_parts__id__get.id( _s: String): T_wp_v2_template_parts__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__get.context( _s: String): T_wp_v2_template_parts__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__id__get Properties

 

 { T_wp_v2_template_parts__id__post }

constructor T_wp_v2_template_parts__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_template_parts__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__id__post Parameters

function T_wp_v2_template_parts__id__post.id( _s: String): T_wp_v2_template_parts__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__id__post Properties

function T_wp_v2_template_parts__id__post.slug( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__post.theme( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__post.type_( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__post.content( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__post.title( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__post.description( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__post.status( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__post.author( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__post.area( _jd: TJSONData): T_wp_v2_template_parts__id__post; 
begin
     Property_( 'area', _jd);
     Result:= Self;
end; 

 { T_wp_v2_template_parts__id__put }

constructor T_wp_v2_template_parts__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_template_parts__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__id__put Parameters

function T_wp_v2_template_parts__id__put.id( _s: String): T_wp_v2_template_parts__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__id__put Properties

function T_wp_v2_template_parts__id__put.slug( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__put.theme( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__put.type_( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__put.content( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__put.title( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__put.description( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__put.status( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__put.author( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__put.area( _jd: TJSONData): T_wp_v2_template_parts__id__put; 
begin
     Property_( 'area', _jd);
     Result:= Self;
end; 

 { T_wp_v2_template_parts__id__patch }

constructor T_wp_v2_template_parts__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_template_parts__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__id__patch Parameters

function T_wp_v2_template_parts__id__patch.id( _s: String): T_wp_v2_template_parts__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__id__patch Properties

function T_wp_v2_template_parts__id__patch.slug( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__patch.theme( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'theme', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__patch.type_( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'type', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__patch.content( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__patch.title( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__patch.description( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__patch.status( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__patch.author( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_template_parts__id__patch.area( _jd: TJSONData): T_wp_v2_template_parts__id__patch; 
begin
     Property_( 'area', _jd);
     Result:= Self;
end; 

 { T_wp_v2_template_parts__id__delete }

constructor T_wp_v2_template_parts__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/template-parts/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_template_parts__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_template_parts__id__delete Parameters

function T_wp_v2_template_parts__id__delete.id( _s: String): T_wp_v2_template_parts__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_template_parts__id__delete Properties

function T_wp_v2_template_parts__id__delete.force( _jd: TJSONData): T_wp_v2_template_parts__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/global-styles/{parent}/revisions

{ T_wp_v2_global_styles__parent__revisions_get }

constructor T_wp_v2_global_styles__parent__revisions_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/global-styles/{parent}/revisions';
     Verb:= 'get';
end;

destructor T_wp_v2_global_styles__parent__revisions_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_global_styles__parent__revisions_get Parameters

function T_wp_v2_global_styles__parent__revisions_get.parent( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_global_styles__parent__revisions_get.context( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_global_styles__parent__revisions_get.page( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_global_styles__parent__revisions_get.per_page( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_global_styles__parent__revisions_get.offset( _s: String): T_wp_v2_global_styles__parent__revisions_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end; 

// T_wp_v2_global_styles__parent__revisions_get Properties

 

 
//Chemin  /wp/v2/global-styles/{parent}/revisions/{id}

{ T_wp_v2_global_styles__parent__revisions__id__get }

constructor T_wp_v2_global_styles__parent__revisions__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/global-styles/{parent}/revisions/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_global_styles__parent__revisions__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_global_styles__parent__revisions__id__get Parameters

function T_wp_v2_global_styles__parent__revisions__id__get.parent( _s: String): T_wp_v2_global_styles__parent__revisions__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_global_styles__parent__revisions__id__get.id( _s: String): T_wp_v2_global_styles__parent__revisions__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_global_styles__parent__revisions__id__get.context( _s: String): T_wp_v2_global_styles__parent__revisions__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_global_styles__parent__revisions__id__get Properties

 

 
//Chemin  /wp/v2/global-styles/themes/{stylesheet}/variations

{ T_wp_v2_global_styles_themes__stylesheet__variations_get }

constructor T_wp_v2_global_styles_themes__stylesheet__variations_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/global-styles/themes/{stylesheet}/variations';
     Verb:= 'get';
end;

destructor T_wp_v2_global_styles_themes__stylesheet__variations_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_global_styles_themes__stylesheet__variations_get Parameters

function T_wp_v2_global_styles_themes__stylesheet__variations_get.stylesheet( _s: String): T_wp_v2_global_styles_themes__stylesheet__variations_get; 
begin
     Parameter_Path( 'stylesheet', _s);
     Result:= Self;
end; 

// T_wp_v2_global_styles_themes__stylesheet__variations_get Properties

 

 
//Chemin  /wp/v2/global-styles/themes/{stylesheet}

{ T_wp_v2_global_styles_themes__stylesheet__get }

constructor T_wp_v2_global_styles_themes__stylesheet__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/global-styles/themes/{stylesheet}';
     Verb:= 'get';
end;

destructor T_wp_v2_global_styles_themes__stylesheet__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_global_styles_themes__stylesheet__get Parameters

function T_wp_v2_global_styles_themes__stylesheet__get.stylesheet( _s: String): T_wp_v2_global_styles_themes__stylesheet__get; 
begin
     Parameter_Path( 'stylesheet', _s);
     Result:= Self;
end; 

// T_wp_v2_global_styles_themes__stylesheet__get Properties

 

 
//Chemin  /wp/v2/global-styles/{id}

{ T_wp_v2_global_styles__id__get }

constructor T_wp_v2_global_styles__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/global-styles/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_global_styles__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_global_styles__id__get Parameters

function T_wp_v2_global_styles__id__get.id( _s: String): T_wp_v2_global_styles__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_global_styles__id__get Properties

 

 { T_wp_v2_global_styles__id__post }

constructor T_wp_v2_global_styles__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/global-styles/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_global_styles__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_global_styles__id__post Parameters

function T_wp_v2_global_styles__id__post.id( _s: String): T_wp_v2_global_styles__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_global_styles__id__post Properties

function T_wp_v2_global_styles__id__post.styles( _jd: TJSONData): T_wp_v2_global_styles__id__post; 
begin
     Property_( 'styles', _jd);
     Result:= Self;
end;
function T_wp_v2_global_styles__id__post.settings( _jd: TJSONData): T_wp_v2_global_styles__id__post; 
begin
     Property_( 'settings', _jd);
     Result:= Self;
end;
function T_wp_v2_global_styles__id__post.title( _jd: TJSONData): T_wp_v2_global_styles__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end; 

 { T_wp_v2_global_styles__id__put }

constructor T_wp_v2_global_styles__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/global-styles/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_global_styles__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_global_styles__id__put Parameters

function T_wp_v2_global_styles__id__put.id( _s: String): T_wp_v2_global_styles__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_global_styles__id__put Properties

function T_wp_v2_global_styles__id__put.styles( _jd: TJSONData): T_wp_v2_global_styles__id__put; 
begin
     Property_( 'styles', _jd);
     Result:= Self;
end;
function T_wp_v2_global_styles__id__put.settings( _jd: TJSONData): T_wp_v2_global_styles__id__put; 
begin
     Property_( 'settings', _jd);
     Result:= Self;
end;
function T_wp_v2_global_styles__id__put.title( _jd: TJSONData): T_wp_v2_global_styles__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end; 

 { T_wp_v2_global_styles__id__patch }

constructor T_wp_v2_global_styles__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/global-styles/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_global_styles__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_global_styles__id__patch Parameters

function T_wp_v2_global_styles__id__patch.id( _s: String): T_wp_v2_global_styles__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_global_styles__id__patch Properties

function T_wp_v2_global_styles__id__patch.styles( _jd: TJSONData): T_wp_v2_global_styles__id__patch; 
begin
     Property_( 'styles', _jd);
     Result:= Self;
end;
function T_wp_v2_global_styles__id__patch.settings( _jd: TJSONData): T_wp_v2_global_styles__id__patch; 
begin
     Property_( 'settings', _jd);
     Result:= Self;
end;
function T_wp_v2_global_styles__id__patch.title( _jd: TJSONData): T_wp_v2_global_styles__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/navigation

{ T_wp_v2_navigation_get }

constructor T_wp_v2_navigation_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation';
     Verb:= 'get';
end;

destructor T_wp_v2_navigation_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation_get Parameters

function T_wp_v2_navigation_get.context( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.page( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.per_page( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.search( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.after( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'after', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.modified_after( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'modified_after', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.before( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'before', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.modified_before( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'modified_before', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.exclude( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.include( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.search_semantics( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'search_semantics', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.offset( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.order( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.orderby( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.search_columns( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'search_columns', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.slug( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_navigation_get.status( _s: String): T_wp_v2_navigation_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation_get Properties

 

 { T_wp_v2_navigation_post }

constructor T_wp_v2_navigation_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation';
     Verb:= 'post';
end;

destructor T_wp_v2_navigation_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation_post Parameters

 

// T_wp_v2_navigation_post Properties

function T_wp_v2_navigation_post.date( _jd: TJSONData): T_wp_v2_navigation_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation_post.date_gmt( _jd: TJSONData): T_wp_v2_navigation_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation_post.slug( _jd: TJSONData): T_wp_v2_navigation_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation_post.status( _jd: TJSONData): T_wp_v2_navigation_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation_post.password( _jd: TJSONData): T_wp_v2_navigation_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation_post.title( _jd: TJSONData): T_wp_v2_navigation_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation_post.content( _jd: TJSONData): T_wp_v2_navigation_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation_post.template( _jd: TJSONData): T_wp_v2_navigation_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/navigation/{id}

{ T_wp_v2_navigation__id__get }

constructor T_wp_v2_navigation__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_navigation__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__id__get Parameters

function T_wp_v2_navigation__id__get.id( _s: String): T_wp_v2_navigation__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__id__get.context( _s: String): T_wp_v2_navigation__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__id__get.password( _s: String): T_wp_v2_navigation__id__get; 
begin
     Parameter_Query( 'password', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__id__get Properties

 

 { T_wp_v2_navigation__id__post }

constructor T_wp_v2_navigation__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_navigation__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__id__post Parameters

function T_wp_v2_navigation__id__post.id( _s: String): T_wp_v2_navigation__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__id__post Properties

function T_wp_v2_navigation__id__post.date( _jd: TJSONData): T_wp_v2_navigation__id__post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__post.date_gmt( _jd: TJSONData): T_wp_v2_navigation__id__post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__post.slug( _jd: TJSONData): T_wp_v2_navigation__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__post.status( _jd: TJSONData): T_wp_v2_navigation__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__post.password( _jd: TJSONData): T_wp_v2_navigation__id__post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__post.title( _jd: TJSONData): T_wp_v2_navigation__id__post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__post.content( _jd: TJSONData): T_wp_v2_navigation__id__post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__post.template( _jd: TJSONData): T_wp_v2_navigation__id__post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 { T_wp_v2_navigation__id__put }

constructor T_wp_v2_navigation__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_navigation__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__id__put Parameters

function T_wp_v2_navigation__id__put.id( _s: String): T_wp_v2_navigation__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__id__put Properties

function T_wp_v2_navigation__id__put.date( _jd: TJSONData): T_wp_v2_navigation__id__put; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__put.date_gmt( _jd: TJSONData): T_wp_v2_navigation__id__put; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__put.slug( _jd: TJSONData): T_wp_v2_navigation__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__put.status( _jd: TJSONData): T_wp_v2_navigation__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__put.password( _jd: TJSONData): T_wp_v2_navigation__id__put; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__put.title( _jd: TJSONData): T_wp_v2_navigation__id__put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__put.content( _jd: TJSONData): T_wp_v2_navigation__id__put; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__put.template( _jd: TJSONData): T_wp_v2_navigation__id__put; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 { T_wp_v2_navigation__id__patch }

constructor T_wp_v2_navigation__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_navigation__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__id__patch Parameters

function T_wp_v2_navigation__id__patch.id( _s: String): T_wp_v2_navigation__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__id__patch Properties

function T_wp_v2_navigation__id__patch.date( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__patch.date_gmt( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__patch.slug( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__patch.status( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__patch.password( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__patch.title( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__patch.content( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__patch.template( _jd: TJSONData): T_wp_v2_navigation__id__patch; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 { T_wp_v2_navigation__id__delete }

constructor T_wp_v2_navigation__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_navigation__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__id__delete Parameters

function T_wp_v2_navigation__id__delete.id( _s: String): T_wp_v2_navigation__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__id__delete Properties

function T_wp_v2_navigation__id__delete.force( _jd: TJSONData): T_wp_v2_navigation__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/navigation/{parent}/revisions

{ T_wp_v2_navigation__parent__revisions_get }

constructor T_wp_v2_navigation__parent__revisions_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{parent}/revisions';
     Verb:= 'get';
end;

destructor T_wp_v2_navigation__parent__revisions_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__parent__revisions_get Parameters

function T_wp_v2_navigation__parent__revisions_get.parent( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.context( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.page( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.per_page( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.search( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.exclude( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.include( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.offset( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.order( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions_get.orderby( _s: String): T_wp_v2_navigation__parent__revisions_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__parent__revisions_get Properties

 

 
//Chemin  /wp/v2/navigation/{parent}/revisions/{id}

{ T_wp_v2_navigation__parent__revisions__id__get }

constructor T_wp_v2_navigation__parent__revisions__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{parent}/revisions/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_navigation__parent__revisions__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__parent__revisions__id__get Parameters

function T_wp_v2_navigation__parent__revisions__id__get.parent( _s: String): T_wp_v2_navigation__parent__revisions__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions__id__get.id( _s: String): T_wp_v2_navigation__parent__revisions__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions__id__get.context( _s: String): T_wp_v2_navigation__parent__revisions__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__parent__revisions__id__get Properties

 

 { T_wp_v2_navigation__parent__revisions__id__delete }

constructor T_wp_v2_navigation__parent__revisions__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{parent}/revisions/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_navigation__parent__revisions__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__parent__revisions__id__delete Parameters

function T_wp_v2_navigation__parent__revisions__id__delete.parent( _s: String): T_wp_v2_navigation__parent__revisions__id__delete; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__revisions__id__delete.id( _s: String): T_wp_v2_navigation__parent__revisions__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__parent__revisions__id__delete Properties

function T_wp_v2_navigation__parent__revisions__id__delete.force( _jd: TJSONData): T_wp_v2_navigation__parent__revisions__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/navigation/{id}/autosaves

{ T_wp_v2_navigation__id__autosaves_get }

constructor T_wp_v2_navigation__id__autosaves_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{id}/autosaves';
     Verb:= 'get';
end;

destructor T_wp_v2_navigation__id__autosaves_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__id__autosaves_get Parameters

function T_wp_v2_navigation__id__autosaves_get.parent( _s: String): T_wp_v2_navigation__id__autosaves_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_get.context( _s: String): T_wp_v2_navigation__id__autosaves_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_get.id( _s: String): T_wp_v2_navigation__id__autosaves_get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__id__autosaves_get Properties

 

 { T_wp_v2_navigation__id__autosaves_post }

constructor T_wp_v2_navigation__id__autosaves_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{id}/autosaves';
     Verb:= 'post';
end;

destructor T_wp_v2_navigation__id__autosaves_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__id__autosaves_post Parameters

function T_wp_v2_navigation__id__autosaves_post.id( _s: String): T_wp_v2_navigation__id__autosaves_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__id__autosaves_post Properties

function T_wp_v2_navigation__id__autosaves_post.parent( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_post.date( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_post.date_gmt( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_post.slug( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_post.status( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_post.password( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_post.title( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_post.content( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_navigation__id__autosaves_post.template( _jd: TJSONData): T_wp_v2_navigation__id__autosaves_post; 
begin
     Property_( 'template', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/navigation/{parent}/autosaves/{id}

{ T_wp_v2_navigation__parent__autosaves__id__get }

constructor T_wp_v2_navigation__parent__autosaves__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/navigation/{parent}/autosaves/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_navigation__parent__autosaves__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_navigation__parent__autosaves__id__get Parameters

function T_wp_v2_navigation__parent__autosaves__id__get.parent( _s: String): T_wp_v2_navigation__parent__autosaves__id__get; 
begin
     Parameter_Path( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__autosaves__id__get.id( _s: String): T_wp_v2_navigation__parent__autosaves__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_navigation__parent__autosaves__id__get.context( _s: String): T_wp_v2_navigation__parent__autosaves__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_navigation__parent__autosaves__id__get Properties

 

 
//Chemin  /wp/v2/font-families

{ T_wp_v2_font_families_get }

constructor T_wp_v2_font_families_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families';
     Verb:= 'get';
end;

destructor T_wp_v2_font_families_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families_get Parameters

function T_wp_v2_font_families_get.context( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.page( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.per_page( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.exclude( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.include( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.search_semantics( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'search_semantics', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.offset( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.order( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.orderby( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_font_families_get.slug( _s: String): T_wp_v2_font_families_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families_get Properties

 

 { T_wp_v2_font_families_post }

constructor T_wp_v2_font_families_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families';
     Verb:= 'post';
end;

destructor T_wp_v2_font_families_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families_post Parameters

 

// T_wp_v2_font_families_post Properties

function T_wp_v2_font_families_post.theme_json_version( _jd: TJSONData): T_wp_v2_font_families_post; 
begin
     Property_( 'theme_json_version', _jd);
     Result:= Self;
end;
function T_wp_v2_font_families_post.font_family_settings( _jd: TJSONData): T_wp_v2_font_families_post; 
begin
     Property_( 'font_family_settings', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/font-families/{id}

{ T_wp_v2_font_families__id__get }

constructor T_wp_v2_font_families__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_font_families__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__id__get Parameters

function T_wp_v2_font_families__id__get.id( _s: String): T_wp_v2_font_families__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__id__get.context( _s: String): T_wp_v2_font_families__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__id__get Properties

 

 { T_wp_v2_font_families__id__post }

constructor T_wp_v2_font_families__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_font_families__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__id__post Parameters

function T_wp_v2_font_families__id__post.id( _s: String): T_wp_v2_font_families__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__id__post Properties

function T_wp_v2_font_families__id__post.theme_json_version( _jd: TJSONData): T_wp_v2_font_families__id__post; 
begin
     Property_( 'theme_json_version', _jd);
     Result:= Self;
end;
function T_wp_v2_font_families__id__post.font_family_settings( _jd: TJSONData): T_wp_v2_font_families__id__post; 
begin
     Property_( 'font_family_settings', _jd);
     Result:= Self;
end; 

 { T_wp_v2_font_families__id__put }

constructor T_wp_v2_font_families__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_font_families__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__id__put Parameters

function T_wp_v2_font_families__id__put.id( _s: String): T_wp_v2_font_families__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__id__put Properties

function T_wp_v2_font_families__id__put.theme_json_version( _jd: TJSONData): T_wp_v2_font_families__id__put; 
begin
     Property_( 'theme_json_version', _jd);
     Result:= Self;
end;
function T_wp_v2_font_families__id__put.font_family_settings( _jd: TJSONData): T_wp_v2_font_families__id__put; 
begin
     Property_( 'font_family_settings', _jd);
     Result:= Self;
end; 

 { T_wp_v2_font_families__id__patch }

constructor T_wp_v2_font_families__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_font_families__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__id__patch Parameters

function T_wp_v2_font_families__id__patch.id( _s: String): T_wp_v2_font_families__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__id__patch Properties

function T_wp_v2_font_families__id__patch.theme_json_version( _jd: TJSONData): T_wp_v2_font_families__id__patch; 
begin
     Property_( 'theme_json_version', _jd);
     Result:= Self;
end;
function T_wp_v2_font_families__id__patch.font_family_settings( _jd: TJSONData): T_wp_v2_font_families__id__patch; 
begin
     Property_( 'font_family_settings', _jd);
     Result:= Self;
end; 

 { T_wp_v2_font_families__id__delete }

constructor T_wp_v2_font_families__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_font_families__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__id__delete Parameters

function T_wp_v2_font_families__id__delete.id( _s: String): T_wp_v2_font_families__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__id__delete Properties

function T_wp_v2_font_families__id__delete.force( _jd: TJSONData): T_wp_v2_font_families__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/font-families/{font_family_id}/font-faces

{ T_wp_v2_font_families__font_family_id__font_faces_get }

constructor T_wp_v2_font_families__font_family_id__font_faces_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{font_family_id}/font-faces';
     Verb:= 'get';
end;

destructor T_wp_v2_font_families__font_family_id__font_faces_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__font_family_id__font_faces_get Parameters

function T_wp_v2_font_families__font_family_id__font_faces_get.font_family_id( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Path( 'font_family_id', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.context( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.page( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.per_page( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.exclude( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.include( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.search_semantics( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'search_semantics', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.offset( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.order( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_get.orderby( _s: String): T_wp_v2_font_families__font_family_id__font_faces_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__font_family_id__font_faces_get Properties

 

 { T_wp_v2_font_families__font_family_id__font_faces_post }

constructor T_wp_v2_font_families__font_family_id__font_faces_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{font_family_id}/font-faces';
     Verb:= 'post';
end;

destructor T_wp_v2_font_families__font_family_id__font_faces_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__font_family_id__font_faces_post Parameters

function T_wp_v2_font_families__font_family_id__font_faces_post.font_family_id( _s: String): T_wp_v2_font_families__font_family_id__font_faces_post; 
begin
     Parameter_Path( 'font_family_id', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__font_family_id__font_faces_post Properties

function T_wp_v2_font_families__font_family_id__font_faces_post.theme_json_version( _jd: TJSONData): T_wp_v2_font_families__font_family_id__font_faces_post; 
begin
     Property_( 'theme_json_version', _jd);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces_post.font_face_settings( _jd: TJSONData): T_wp_v2_font_families__font_family_id__font_faces_post; 
begin
     Property_( 'font_face_settings', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/font-families/{font_family_id}/font-faces/{id}

{ T_wp_v2_font_families__font_family_id__font_faces__id__get }

constructor T_wp_v2_font_families__font_family_id__font_faces__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{font_family_id}/font-faces/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_font_families__font_family_id__font_faces__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__font_family_id__font_faces__id__get Parameters

function T_wp_v2_font_families__font_family_id__font_faces__id__get.font_family_id( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__get; 
begin
     Parameter_Path( 'font_family_id', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces__id__get.id( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces__id__get.context( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__font_family_id__font_faces__id__get Properties

 

 { T_wp_v2_font_families__font_family_id__font_faces__id__delete }

constructor T_wp_v2_font_families__font_family_id__font_faces__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-families/{font_family_id}/font-faces/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_font_families__font_family_id__font_faces__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_families__font_family_id__font_faces__id__delete Parameters

function T_wp_v2_font_families__font_family_id__font_faces__id__delete.font_family_id( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__delete; 
begin
     Parameter_Path( 'font_family_id', _s);
     Result:= Self;
end;
function T_wp_v2_font_families__font_family_id__font_faces__id__delete.id( _s: String): T_wp_v2_font_families__font_family_id__font_faces__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_font_families__font_family_id__font_faces__id__delete Properties

function T_wp_v2_font_families__font_family_id__font_faces__id__delete.force( _jd: TJSONData): T_wp_v2_font_families__font_family_id__font_faces__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/types

{ T_wp_v2_types_get }

constructor T_wp_v2_types_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/types';
     Verb:= 'get';
end;

destructor T_wp_v2_types_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_types_get Parameters

function T_wp_v2_types_get.context( _s: String): T_wp_v2_types_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_types_get Properties

 

 
//Chemin  /wp/v2/types/{type}

{ T_wp_v2_types__type__get }

constructor T_wp_v2_types__type__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/types/{type}';
     Verb:= 'get';
end;

destructor T_wp_v2_types__type__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_types__type__get Parameters

function T_wp_v2_types__type__get.type_( _s: String): T_wp_v2_types__type__get; 
begin
     Parameter_Path( 'type', _s);
     Result:= Self;
end;
function T_wp_v2_types__type__get.context( _s: String): T_wp_v2_types__type__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_types__type__get Properties

 

 
//Chemin  /wp/v2/statuses

{ T_wp_v2_statuses_get }

constructor T_wp_v2_statuses_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/statuses';
     Verb:= 'get';
end;

destructor T_wp_v2_statuses_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_statuses_get Parameters

function T_wp_v2_statuses_get.context( _s: String): T_wp_v2_statuses_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_statuses_get Properties

 

 
//Chemin  /wp/v2/statuses/{status}

{ T_wp_v2_statuses__status__get }

constructor T_wp_v2_statuses__status__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/statuses/{status}';
     Verb:= 'get';
end;

destructor T_wp_v2_statuses__status__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_statuses__status__get Parameters

function T_wp_v2_statuses__status__get.status( _s: String): T_wp_v2_statuses__status__get; 
begin
     Parameter_Path( 'status', _s);
     Result:= Self;
end;
function T_wp_v2_statuses__status__get.context( _s: String): T_wp_v2_statuses__status__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_statuses__status__get Properties

 

 
//Chemin  /wp/v2/taxonomies

{ T_wp_v2_taxonomies_get }

constructor T_wp_v2_taxonomies_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/taxonomies';
     Verb:= 'get';
end;

destructor T_wp_v2_taxonomies_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_taxonomies_get Parameters

function T_wp_v2_taxonomies_get.context( _s: String): T_wp_v2_taxonomies_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_taxonomies_get.type_( _s: String): T_wp_v2_taxonomies_get; 
begin
     Parameter_Query( 'type', _s);
     Result:= Self;
end; 

// T_wp_v2_taxonomies_get Properties

 

 
//Chemin  /wp/v2/taxonomies/{taxonomy}

{ T_wp_v2_taxonomies__taxonomy__get }

constructor T_wp_v2_taxonomies__taxonomy__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/taxonomies/{taxonomy}';
     Verb:= 'get';
end;

destructor T_wp_v2_taxonomies__taxonomy__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_taxonomies__taxonomy__get Parameters

function T_wp_v2_taxonomies__taxonomy__get.taxonomy( _s: String): T_wp_v2_taxonomies__taxonomy__get; 
begin
     Parameter_Path( 'taxonomy', _s);
     Result:= Self;
end;
function T_wp_v2_taxonomies__taxonomy__get.context( _s: String): T_wp_v2_taxonomies__taxonomy__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_taxonomies__taxonomy__get Properties

 

 
//Chemin  /wp/v2/categories

{ T_wp_v2_categories_get }

constructor T_wp_v2_categories_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/categories';
     Verb:= 'get';
end;

destructor T_wp_v2_categories_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_categories_get Parameters

function T_wp_v2_categories_get.context( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.page( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.per_page( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.search( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.exclude( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.include( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.order( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.orderby( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.hide_empty( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'hide_empty', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.parent( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.post( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'post', _s);
     Result:= Self;
end;
function T_wp_v2_categories_get.slug( _s: String): T_wp_v2_categories_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end; 

// T_wp_v2_categories_get Properties

 

 { T_wp_v2_categories_post }

constructor T_wp_v2_categories_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/categories';
     Verb:= 'post';
end;

destructor T_wp_v2_categories_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_categories_post Parameters

 

// T_wp_v2_categories_post Properties

function T_wp_v2_categories_post.description( _jd: TJSONData): T_wp_v2_categories_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_categories_post.name( _jd: TJSONData): T_wp_v2_categories_post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_categories_post.slug( _jd: TJSONData): T_wp_v2_categories_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_categories_post.parent( _jd: TJSONData): T_wp_v2_categories_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_categories_post.meta( _jd: TJSONData): T_wp_v2_categories_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/categories/{id}

{ T_wp_v2_categories__id__get }

constructor T_wp_v2_categories__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/categories/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_categories__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_categories__id__get Parameters

function T_wp_v2_categories__id__get.id( _s: String): T_wp_v2_categories__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_categories__id__get.context( _s: String): T_wp_v2_categories__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_categories__id__get Properties

 

 { T_wp_v2_categories__id__post }

constructor T_wp_v2_categories__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/categories/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_categories__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_categories__id__post Parameters

function T_wp_v2_categories__id__post.id( _s: String): T_wp_v2_categories__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_categories__id__post Properties

function T_wp_v2_categories__id__post.description( _jd: TJSONData): T_wp_v2_categories__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__post.name( _jd: TJSONData): T_wp_v2_categories__id__post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__post.slug( _jd: TJSONData): T_wp_v2_categories__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__post.parent( _jd: TJSONData): T_wp_v2_categories__id__post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__post.meta( _jd: TJSONData): T_wp_v2_categories__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_categories__id__put }

constructor T_wp_v2_categories__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/categories/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_categories__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_categories__id__put Parameters

function T_wp_v2_categories__id__put.id( _s: String): T_wp_v2_categories__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_categories__id__put Properties

function T_wp_v2_categories__id__put.description( _jd: TJSONData): T_wp_v2_categories__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__put.name( _jd: TJSONData): T_wp_v2_categories__id__put; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__put.slug( _jd: TJSONData): T_wp_v2_categories__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__put.parent( _jd: TJSONData): T_wp_v2_categories__id__put; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__put.meta( _jd: TJSONData): T_wp_v2_categories__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_categories__id__patch }

constructor T_wp_v2_categories__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/categories/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_categories__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_categories__id__patch Parameters

function T_wp_v2_categories__id__patch.id( _s: String): T_wp_v2_categories__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_categories__id__patch Properties

function T_wp_v2_categories__id__patch.description( _jd: TJSONData): T_wp_v2_categories__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__patch.name( _jd: TJSONData): T_wp_v2_categories__id__patch; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__patch.slug( _jd: TJSONData): T_wp_v2_categories__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__patch.parent( _jd: TJSONData): T_wp_v2_categories__id__patch; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_categories__id__patch.meta( _jd: TJSONData): T_wp_v2_categories__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_categories__id__delete }

constructor T_wp_v2_categories__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/categories/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_categories__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_categories__id__delete Parameters

function T_wp_v2_categories__id__delete.id( _s: String): T_wp_v2_categories__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_categories__id__delete Properties

function T_wp_v2_categories__id__delete.force( _jd: TJSONData): T_wp_v2_categories__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/tags

{ T_wp_v2_tags_get }

constructor T_wp_v2_tags_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/tags';
     Verb:= 'get';
end;

destructor T_wp_v2_tags_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_tags_get Parameters

function T_wp_v2_tags_get.context( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.page( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.per_page( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.search( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.exclude( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.include( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.offset( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.order( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.orderby( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.hide_empty( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'hide_empty', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.post( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'post', _s);
     Result:= Self;
end;
function T_wp_v2_tags_get.slug( _s: String): T_wp_v2_tags_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end; 

// T_wp_v2_tags_get Properties

 

 { T_wp_v2_tags_post }

constructor T_wp_v2_tags_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/tags';
     Verb:= 'post';
end;

destructor T_wp_v2_tags_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_tags_post Parameters

 

// T_wp_v2_tags_post Properties

function T_wp_v2_tags_post.description( _jd: TJSONData): T_wp_v2_tags_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_tags_post.name( _jd: TJSONData): T_wp_v2_tags_post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_tags_post.slug( _jd: TJSONData): T_wp_v2_tags_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_tags_post.meta( _jd: TJSONData): T_wp_v2_tags_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/tags/{id}

{ T_wp_v2_tags__id__get }

constructor T_wp_v2_tags__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/tags/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_tags__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_tags__id__get Parameters

function T_wp_v2_tags__id__get.id( _s: String): T_wp_v2_tags__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_tags__id__get.context( _s: String): T_wp_v2_tags__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_tags__id__get Properties

 

 { T_wp_v2_tags__id__post }

constructor T_wp_v2_tags__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/tags/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_tags__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_tags__id__post Parameters

function T_wp_v2_tags__id__post.id( _s: String): T_wp_v2_tags__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_tags__id__post Properties

function T_wp_v2_tags__id__post.description( _jd: TJSONData): T_wp_v2_tags__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__post.name( _jd: TJSONData): T_wp_v2_tags__id__post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__post.slug( _jd: TJSONData): T_wp_v2_tags__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__post.meta( _jd: TJSONData): T_wp_v2_tags__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_tags__id__put }

constructor T_wp_v2_tags__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/tags/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_tags__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_tags__id__put Parameters

function T_wp_v2_tags__id__put.id( _s: String): T_wp_v2_tags__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_tags__id__put Properties

function T_wp_v2_tags__id__put.description( _jd: TJSONData): T_wp_v2_tags__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__put.name( _jd: TJSONData): T_wp_v2_tags__id__put; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__put.slug( _jd: TJSONData): T_wp_v2_tags__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__put.meta( _jd: TJSONData): T_wp_v2_tags__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_tags__id__patch }

constructor T_wp_v2_tags__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/tags/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_tags__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_tags__id__patch Parameters

function T_wp_v2_tags__id__patch.id( _s: String): T_wp_v2_tags__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_tags__id__patch Properties

function T_wp_v2_tags__id__patch.description( _jd: TJSONData): T_wp_v2_tags__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__patch.name( _jd: TJSONData): T_wp_v2_tags__id__patch; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__patch.slug( _jd: TJSONData): T_wp_v2_tags__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_tags__id__patch.meta( _jd: TJSONData): T_wp_v2_tags__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_tags__id__delete }

constructor T_wp_v2_tags__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/tags/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_tags__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_tags__id__delete Parameters

function T_wp_v2_tags__id__delete.id( _s: String): T_wp_v2_tags__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_tags__id__delete Properties

function T_wp_v2_tags__id__delete.force( _jd: TJSONData): T_wp_v2_tags__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/menus

{ T_wp_v2_menus_get }

constructor T_wp_v2_menus_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menus';
     Verb:= 'get';
end;

destructor T_wp_v2_menus_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menus_get Parameters

function T_wp_v2_menus_get.context( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.page( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.per_page( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.search( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.exclude( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.include( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.offset( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.order( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.orderby( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.hide_empty( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'hide_empty', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.post( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'post', _s);
     Result:= Self;
end;
function T_wp_v2_menus_get.slug( _s: String): T_wp_v2_menus_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end; 

// T_wp_v2_menus_get Properties

 

 { T_wp_v2_menus_post }

constructor T_wp_v2_menus_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menus';
     Verb:= 'post';
end;

destructor T_wp_v2_menus_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menus_post Parameters

 

// T_wp_v2_menus_post Properties

function T_wp_v2_menus_post.description( _jd: TJSONData): T_wp_v2_menus_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menus_post.name( _jd: TJSONData): T_wp_v2_menus_post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_menus_post.slug( _jd: TJSONData): T_wp_v2_menus_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_menus_post.meta( _jd: TJSONData): T_wp_v2_menus_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_menus_post.locations( _jd: TJSONData): T_wp_v2_menus_post; 
begin
     Property_( 'locations', _jd);
     Result:= Self;
end;
function T_wp_v2_menus_post.auto_add( _jd: TJSONData): T_wp_v2_menus_post; 
begin
     Property_( 'auto_add', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/menus/{id}

{ T_wp_v2_menus__id__get }

constructor T_wp_v2_menus__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menus/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_menus__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menus__id__get Parameters

function T_wp_v2_menus__id__get.id( _s: String): T_wp_v2_menus__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_menus__id__get.context( _s: String): T_wp_v2_menus__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_menus__id__get Properties

 

 { T_wp_v2_menus__id__post }

constructor T_wp_v2_menus__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menus/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_menus__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menus__id__post Parameters

function T_wp_v2_menus__id__post.id( _s: String): T_wp_v2_menus__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menus__id__post Properties

function T_wp_v2_menus__id__post.description( _jd: TJSONData): T_wp_v2_menus__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__post.name( _jd: TJSONData): T_wp_v2_menus__id__post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__post.slug( _jd: TJSONData): T_wp_v2_menus__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__post.meta( _jd: TJSONData): T_wp_v2_menus__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__post.locations( _jd: TJSONData): T_wp_v2_menus__id__post; 
begin
     Property_( 'locations', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__post.auto_add( _jd: TJSONData): T_wp_v2_menus__id__post; 
begin
     Property_( 'auto_add', _jd);
     Result:= Self;
end; 

 { T_wp_v2_menus__id__put }

constructor T_wp_v2_menus__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menus/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_menus__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menus__id__put Parameters

function T_wp_v2_menus__id__put.id( _s: String): T_wp_v2_menus__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menus__id__put Properties

function T_wp_v2_menus__id__put.description( _jd: TJSONData): T_wp_v2_menus__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__put.name( _jd: TJSONData): T_wp_v2_menus__id__put; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__put.slug( _jd: TJSONData): T_wp_v2_menus__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__put.meta( _jd: TJSONData): T_wp_v2_menus__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__put.locations( _jd: TJSONData): T_wp_v2_menus__id__put; 
begin
     Property_( 'locations', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__put.auto_add( _jd: TJSONData): T_wp_v2_menus__id__put; 
begin
     Property_( 'auto_add', _jd);
     Result:= Self;
end; 

 { T_wp_v2_menus__id__patch }

constructor T_wp_v2_menus__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menus/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_menus__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menus__id__patch Parameters

function T_wp_v2_menus__id__patch.id( _s: String): T_wp_v2_menus__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menus__id__patch Properties

function T_wp_v2_menus__id__patch.description( _jd: TJSONData): T_wp_v2_menus__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__patch.name( _jd: TJSONData): T_wp_v2_menus__id__patch; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__patch.slug( _jd: TJSONData): T_wp_v2_menus__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__patch.meta( _jd: TJSONData): T_wp_v2_menus__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__patch.locations( _jd: TJSONData): T_wp_v2_menus__id__patch; 
begin
     Property_( 'locations', _jd);
     Result:= Self;
end;
function T_wp_v2_menus__id__patch.auto_add( _jd: TJSONData): T_wp_v2_menus__id__patch; 
begin
     Property_( 'auto_add', _jd);
     Result:= Self;
end; 

 { T_wp_v2_menus__id__delete }

constructor T_wp_v2_menus__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menus/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_menus__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menus__id__delete Parameters

function T_wp_v2_menus__id__delete.id( _s: String): T_wp_v2_menus__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_menus__id__delete Properties

function T_wp_v2_menus__id__delete.force( _jd: TJSONData): T_wp_v2_menus__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/wp_pattern_category

{ T_wp_v2_wp_pattern_category_get }

constructor T_wp_v2_wp_pattern_category_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/wp_pattern_category';
     Verb:= 'get';
end;

destructor T_wp_v2_wp_pattern_category_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_wp_pattern_category_get Parameters

function T_wp_v2_wp_pattern_category_get.context( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.page( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.per_page( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.search( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.exclude( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.include( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.offset( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.order( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.orderby( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.hide_empty( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'hide_empty', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.post( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'post', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_get.slug( _s: String): T_wp_v2_wp_pattern_category_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end; 

// T_wp_v2_wp_pattern_category_get Properties

 

 { T_wp_v2_wp_pattern_category_post }

constructor T_wp_v2_wp_pattern_category_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/wp_pattern_category';
     Verb:= 'post';
end;

destructor T_wp_v2_wp_pattern_category_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_wp_pattern_category_post Parameters

 

// T_wp_v2_wp_pattern_category_post Properties

function T_wp_v2_wp_pattern_category_post.description( _jd: TJSONData): T_wp_v2_wp_pattern_category_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_post.name( _jd: TJSONData): T_wp_v2_wp_pattern_category_post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_post.slug( _jd: TJSONData): T_wp_v2_wp_pattern_category_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category_post.meta( _jd: TJSONData): T_wp_v2_wp_pattern_category_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/wp_pattern_category/{id}

{ T_wp_v2_wp_pattern_category__id__get }

constructor T_wp_v2_wp_pattern_category__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/wp_pattern_category/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_wp_pattern_category__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_wp_pattern_category__id__get Parameters

function T_wp_v2_wp_pattern_category__id__get.id( _s: String): T_wp_v2_wp_pattern_category__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__get.context( _s: String): T_wp_v2_wp_pattern_category__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_wp_pattern_category__id__get Properties

 

 { T_wp_v2_wp_pattern_category__id__post }

constructor T_wp_v2_wp_pattern_category__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/wp_pattern_category/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_wp_pattern_category__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_wp_pattern_category__id__post Parameters

function T_wp_v2_wp_pattern_category__id__post.id( _s: String): T_wp_v2_wp_pattern_category__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_wp_pattern_category__id__post Properties

function T_wp_v2_wp_pattern_category__id__post.description( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__post.name( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__post.slug( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__post.meta( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_wp_pattern_category__id__put }

constructor T_wp_v2_wp_pattern_category__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/wp_pattern_category/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_wp_pattern_category__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_wp_pattern_category__id__put Parameters

function T_wp_v2_wp_pattern_category__id__put.id( _s: String): T_wp_v2_wp_pattern_category__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_wp_pattern_category__id__put Properties

function T_wp_v2_wp_pattern_category__id__put.description( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__put.name( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__put; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__put.slug( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__put.meta( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_wp_pattern_category__id__patch }

constructor T_wp_v2_wp_pattern_category__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/wp_pattern_category/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_wp_pattern_category__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_wp_pattern_category__id__patch Parameters

function T_wp_v2_wp_pattern_category__id__patch.id( _s: String): T_wp_v2_wp_pattern_category__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_wp_pattern_category__id__patch Properties

function T_wp_v2_wp_pattern_category__id__patch.description( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__patch.name( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__patch; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__patch.slug( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_wp_pattern_category__id__patch.meta( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_wp_pattern_category__id__delete }

constructor T_wp_v2_wp_pattern_category__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/wp_pattern_category/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_wp_pattern_category__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_wp_pattern_category__id__delete Parameters

function T_wp_v2_wp_pattern_category__id__delete.id( _s: String): T_wp_v2_wp_pattern_category__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_wp_pattern_category__id__delete Properties

function T_wp_v2_wp_pattern_category__id__delete.force( _jd: TJSONData): T_wp_v2_wp_pattern_category__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/users

{ T_wp_v2_users_get }

constructor T_wp_v2_users_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users';
     Verb:= 'get';
end;

destructor T_wp_v2_users_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users_get Parameters

function T_wp_v2_users_get.context( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.page( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.per_page( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.search( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.exclude( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.include( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.offset( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.order( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.orderby( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.slug( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.roles( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'roles', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.capabilities( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'capabilities', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.who( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'who', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.has_published_posts( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'has_published_posts', _s);
     Result:= Self;
end;
function T_wp_v2_users_get.search_columns( _s: String): T_wp_v2_users_get; 
begin
     Parameter_Query( 'search_columns', _s);
     Result:= Self;
end; 

// T_wp_v2_users_get Properties

 

 { T_wp_v2_users_post }

constructor T_wp_v2_users_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users';
     Verb:= 'post';
end;

destructor T_wp_v2_users_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users_post Parameters

 

// T_wp_v2_users_post Properties

function T_wp_v2_users_post.username( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'username', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.name( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.first_name( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'first_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.last_name( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'last_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.email( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.url_( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.description( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.locale( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'locale', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.nickname( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'nickname', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.slug( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.roles( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'roles', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.password( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_users_post.meta( _jd: TJSONData): T_wp_v2_users_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/users/{id}

{ T_wp_v2_users__id__get }

constructor T_wp_v2_users__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_users__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__id__get Parameters

function T_wp_v2_users__id__get.id( _s: String): T_wp_v2_users__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_users__id__get.context( _s: String): T_wp_v2_users__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_users__id__get Properties

 

 { T_wp_v2_users__id__post }

constructor T_wp_v2_users__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_users__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__id__post Parameters

function T_wp_v2_users__id__post.id( _s: String): T_wp_v2_users__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_users__id__post Properties

function T_wp_v2_users__id__post.username( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'username', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.name( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.first_name( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'first_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.last_name( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'last_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.email( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.url_( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.description( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.locale( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'locale', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.nickname( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'nickname', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.slug( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.roles( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'roles', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.password( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__post.meta( _jd: TJSONData): T_wp_v2_users__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users__id__put }

constructor T_wp_v2_users__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_users__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__id__put Parameters

function T_wp_v2_users__id__put.id( _s: String): T_wp_v2_users__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_users__id__put Properties

function T_wp_v2_users__id__put.username( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'username', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.name( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.first_name( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'first_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.last_name( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'last_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.email( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.url_( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.description( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.locale( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'locale', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.nickname( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'nickname', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.slug( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.roles( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'roles', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.password( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__put.meta( _jd: TJSONData): T_wp_v2_users__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users__id__patch }

constructor T_wp_v2_users__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_users__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__id__patch Parameters

function T_wp_v2_users__id__patch.id( _s: String): T_wp_v2_users__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_users__id__patch Properties

function T_wp_v2_users__id__patch.username( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'username', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.name( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.first_name( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'first_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.last_name( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'last_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.email( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.url_( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.description( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.locale( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'locale', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.nickname( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'nickname', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.slug( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.roles( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'roles', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.password( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__patch.meta( _jd: TJSONData): T_wp_v2_users__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users__id__delete }

constructor T_wp_v2_users__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_users__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__id__delete Parameters

function T_wp_v2_users__id__delete.id( _s: String): T_wp_v2_users__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_users__id__delete Properties

function T_wp_v2_users__id__delete.force( _jd: TJSONData): T_wp_v2_users__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end;
function T_wp_v2_users__id__delete.reassign( _jd: TJSONData): T_wp_v2_users__id__delete; 
begin
     Property_( 'reassign', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/users/me

{ T_wp_v2_users_me_get }

constructor T_wp_v2_users_me_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/me';
     Verb:= 'get';
end;

destructor T_wp_v2_users_me_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users_me_get Parameters

function T_wp_v2_users_me_get.context( _s: String): T_wp_v2_users_me_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_users_me_get Properties

 

 { T_wp_v2_users_me_post }

constructor T_wp_v2_users_me_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/me';
     Verb:= 'post';
end;

destructor T_wp_v2_users_me_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users_me_post Parameters

 

// T_wp_v2_users_me_post Properties

function T_wp_v2_users_me_post.username( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'username', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.name( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.first_name( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'first_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.last_name( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'last_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.email( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.url_( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.description( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.locale( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'locale', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.nickname( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'nickname', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.slug( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.roles( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'roles', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.password( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_post.meta( _jd: TJSONData): T_wp_v2_users_me_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users_me_put }

constructor T_wp_v2_users_me_put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/me';
     Verb:= 'put';
end;

destructor T_wp_v2_users_me_put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users_me_put Parameters

 

// T_wp_v2_users_me_put Properties

function T_wp_v2_users_me_put.username( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'username', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.name( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.first_name( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'first_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.last_name( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'last_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.email( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.url_( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.description( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.locale( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'locale', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.nickname( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'nickname', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.slug( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.roles( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'roles', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.password( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_put.meta( _jd: TJSONData): T_wp_v2_users_me_put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users_me_patch }

constructor T_wp_v2_users_me_patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/me';
     Verb:= 'patch';
end;

destructor T_wp_v2_users_me_patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users_me_patch Parameters

 

// T_wp_v2_users_me_patch Properties

function T_wp_v2_users_me_patch.username( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'username', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.name( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.first_name( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'first_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.last_name( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'last_name', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.email( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.url_( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.description( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.locale( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'locale', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.nickname( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'nickname', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.slug( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.roles( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'roles', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.password( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_patch.meta( _jd: TJSONData): T_wp_v2_users_me_patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users_me_delete }

constructor T_wp_v2_users_me_delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/me';
     Verb:= 'delete';
end;

destructor T_wp_v2_users_me_delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users_me_delete Parameters

 

// T_wp_v2_users_me_delete Properties

function T_wp_v2_users_me_delete.force( _jd: TJSONData): T_wp_v2_users_me_delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end;
function T_wp_v2_users_me_delete.reassign( _jd: TJSONData): T_wp_v2_users_me_delete; 
begin
     Property_( 'reassign', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/users/{user_id}/application-passwords

{ T_wp_v2_users__user_id__application_passwords_get }

constructor T_wp_v2_users__user_id__application_passwords_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords';
     Verb:= 'get';
end;

destructor T_wp_v2_users__user_id__application_passwords_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords_get Parameters

function T_wp_v2_users__user_id__application_passwords_get.context( _s: String): T_wp_v2_users__user_id__application_passwords_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords_get.user_id( _s: String): T_wp_v2_users__user_id__application_passwords_get; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords_get Properties

 

 { T_wp_v2_users__user_id__application_passwords_post }

constructor T_wp_v2_users__user_id__application_passwords_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords';
     Verb:= 'post';
end;

destructor T_wp_v2_users__user_id__application_passwords_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords_post Parameters

function T_wp_v2_users__user_id__application_passwords_post.user_id( _s: String): T_wp_v2_users__user_id__application_passwords_post; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords_post Properties

function T_wp_v2_users__user_id__application_passwords_post.app_id( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords_post; 
begin
     Property_( 'app_id', _jd);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords_post.name( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords_post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users__user_id__application_passwords_delete }

constructor T_wp_v2_users__user_id__application_passwords_delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords';
     Verb:= 'delete';
end;

destructor T_wp_v2_users__user_id__application_passwords_delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords_delete Parameters

function T_wp_v2_users__user_id__application_passwords_delete.user_id( _s: String): T_wp_v2_users__user_id__application_passwords_delete; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords_delete Properties

 

 
//Chemin  /wp/v2/users/{user_id}/application-passwords/introspect

{ T_wp_v2_users__user_id__application_passwords_introspect_get }

constructor T_wp_v2_users__user_id__application_passwords_introspect_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords/introspect';
     Verb:= 'get';
end;

destructor T_wp_v2_users__user_id__application_passwords_introspect_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords_introspect_get Parameters

function T_wp_v2_users__user_id__application_passwords_introspect_get.context( _s: String): T_wp_v2_users__user_id__application_passwords_introspect_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords_introspect_get.user_id( _s: String): T_wp_v2_users__user_id__application_passwords_introspect_get; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords_introspect_get Properties

 

 
//Chemin  /wp/v2/users/{user_id}/application-passwords/{uuid}

{ T_wp_v2_users__user_id__application_passwords__uuid__get }

constructor T_wp_v2_users__user_id__application_passwords__uuid__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords/{uuid}';
     Verb:= 'get';
end;

destructor T_wp_v2_users__user_id__application_passwords__uuid__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords__uuid__get Parameters

function T_wp_v2_users__user_id__application_passwords__uuid__get.context( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__get.user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__get; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__get.uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__get; 
begin
     Parameter_Path( 'uuid', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords__uuid__get Properties

 

 { T_wp_v2_users__user_id__application_passwords__uuid__post }

constructor T_wp_v2_users__user_id__application_passwords__uuid__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords/{uuid}';
     Verb:= 'post';
end;

destructor T_wp_v2_users__user_id__application_passwords__uuid__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords__uuid__post Parameters

function T_wp_v2_users__user_id__application_passwords__uuid__post.user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__post; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__post.uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__post; 
begin
     Parameter_Path( 'uuid', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords__uuid__post Properties

function T_wp_v2_users__user_id__application_passwords__uuid__post.app_id( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__post; 
begin
     Property_( 'app_id', _jd);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__post.name( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__post; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users__user_id__application_passwords__uuid__put }

constructor T_wp_v2_users__user_id__application_passwords__uuid__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords/{uuid}';
     Verb:= 'put';
end;

destructor T_wp_v2_users__user_id__application_passwords__uuid__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords__uuid__put Parameters

function T_wp_v2_users__user_id__application_passwords__uuid__put.user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__put; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__put.uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__put; 
begin
     Parameter_Path( 'uuid', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords__uuid__put Properties

function T_wp_v2_users__user_id__application_passwords__uuid__put.app_id( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__put; 
begin
     Property_( 'app_id', _jd);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__put.name( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__put; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users__user_id__application_passwords__uuid__patch }

constructor T_wp_v2_users__user_id__application_passwords__uuid__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords/{uuid}';
     Verb:= 'patch';
end;

destructor T_wp_v2_users__user_id__application_passwords__uuid__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords__uuid__patch Parameters

function T_wp_v2_users__user_id__application_passwords__uuid__patch.user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__patch; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__patch.uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__patch; 
begin
     Parameter_Path( 'uuid', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords__uuid__patch Properties

function T_wp_v2_users__user_id__application_passwords__uuid__patch.app_id( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__patch; 
begin
     Property_( 'app_id', _jd);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__patch.name( _jd: TJSONData): T_wp_v2_users__user_id__application_passwords__uuid__patch; 
begin
     Property_( 'name', _jd);
     Result:= Self;
end; 

 { T_wp_v2_users__user_id__application_passwords__uuid__delete }

constructor T_wp_v2_users__user_id__application_passwords__uuid__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/users/{user_id}/application-passwords/{uuid}';
     Verb:= 'delete';
end;

destructor T_wp_v2_users__user_id__application_passwords__uuid__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_users__user_id__application_passwords__uuid__delete Parameters

function T_wp_v2_users__user_id__application_passwords__uuid__delete.user_id( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__delete; 
begin
     Parameter_Path( 'user_id', _s);
     Result:= Self;
end;
function T_wp_v2_users__user_id__application_passwords__uuid__delete.uuid( _s: String): T_wp_v2_users__user_id__application_passwords__uuid__delete; 
begin
     Parameter_Path( 'uuid', _s);
     Result:= Self;
end; 

// T_wp_v2_users__user_id__application_passwords__uuid__delete Properties

 

 
//Chemin  /wp/v2/comments

{ T_wp_v2_comments_get }

constructor T_wp_v2_comments_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/comments';
     Verb:= 'get';
end;

destructor T_wp_v2_comments_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_comments_get Parameters

function T_wp_v2_comments_get.context( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.page( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.per_page( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.search( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.after( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'after', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.author( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'author', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.author_exclude( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'author_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.author_email( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'author_email', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.before( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'before', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.exclude( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.include( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.offset( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.order( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.orderby( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.parent( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'parent', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.parent_exclude( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'parent_exclude', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.post( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'post', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.status( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.type_( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'type', _s);
     Result:= Self;
end;
function T_wp_v2_comments_get.password( _s: String): T_wp_v2_comments_get; 
begin
     Parameter_Query( 'password', _s);
     Result:= Self;
end; 

// T_wp_v2_comments_get Properties

 

 { T_wp_v2_comments_post }

constructor T_wp_v2_comments_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/comments';
     Verb:= 'post';
end;

destructor T_wp_v2_comments_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_comments_post Parameters

 

// T_wp_v2_comments_post Properties

function T_wp_v2_comments_post.author( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.author_email( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'author_email', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.author_ip( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'author_ip', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.author_name( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'author_name', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.author_url( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'author_url', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.author_user_agent( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'author_user_agent', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.content( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.date( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.date_gmt( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.parent( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.post( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.status( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_comments_post.meta( _jd: TJSONData): T_wp_v2_comments_post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/comments/{id}

{ T_wp_v2_comments__id__get }

constructor T_wp_v2_comments__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/comments/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_comments__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_comments__id__get Parameters

function T_wp_v2_comments__id__get.id( _s: String): T_wp_v2_comments__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_comments__id__get.context( _s: String): T_wp_v2_comments__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_comments__id__get.password( _s: String): T_wp_v2_comments__id__get; 
begin
     Parameter_Query( 'password', _s);
     Result:= Self;
end; 

// T_wp_v2_comments__id__get Properties

 

 { T_wp_v2_comments__id__post }

constructor T_wp_v2_comments__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/comments/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_comments__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_comments__id__post Parameters

function T_wp_v2_comments__id__post.id( _s: String): T_wp_v2_comments__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_comments__id__post Properties

function T_wp_v2_comments__id__post.author( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.author_email( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'author_email', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.author_ip( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'author_ip', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.author_name( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'author_name', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.author_url( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'author_url', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.author_user_agent( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'author_user_agent', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.content( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.date( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.date_gmt( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.parent( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.post( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.status( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__post.meta( _jd: TJSONData): T_wp_v2_comments__id__post; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_comments__id__put }

constructor T_wp_v2_comments__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/comments/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_comments__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_comments__id__put Parameters

function T_wp_v2_comments__id__put.id( _s: String): T_wp_v2_comments__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_comments__id__put Properties

function T_wp_v2_comments__id__put.author( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.author_email( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'author_email', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.author_ip( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'author_ip', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.author_name( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'author_name', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.author_url( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'author_url', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.author_user_agent( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'author_user_agent', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.content( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.date( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.date_gmt( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.parent( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.post( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.status( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__put.meta( _jd: TJSONData): T_wp_v2_comments__id__put; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_comments__id__patch }

constructor T_wp_v2_comments__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/comments/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_comments__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_comments__id__patch Parameters

function T_wp_v2_comments__id__patch.id( _s: String): T_wp_v2_comments__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_comments__id__patch Properties

function T_wp_v2_comments__id__patch.author( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'author', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.author_email( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'author_email', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.author_ip( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'author_ip', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.author_name( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'author_name', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.author_url( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'author_url', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.author_user_agent( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'author_user_agent', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.content( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'content', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.date( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'date', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.date_gmt( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'date_gmt', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.parent( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'parent', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.post( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'post', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.status( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__patch.meta( _jd: TJSONData): T_wp_v2_comments__id__patch; 
begin
     Property_( 'meta', _jd);
     Result:= Self;
end; 

 { T_wp_v2_comments__id__delete }

constructor T_wp_v2_comments__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/comments/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_comments__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_comments__id__delete Parameters

function T_wp_v2_comments__id__delete.id( _s: String): T_wp_v2_comments__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_comments__id__delete Properties

function T_wp_v2_comments__id__delete.force( _jd: TJSONData): T_wp_v2_comments__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end;
function T_wp_v2_comments__id__delete.password( _jd: TJSONData): T_wp_v2_comments__id__delete; 
begin
     Property_( 'password', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/search

{ T_wp_v2_search_get }

constructor T_wp_v2_search_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/search';
     Verb:= 'get';
end;

destructor T_wp_v2_search_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_search_get Parameters

function T_wp_v2_search_get.context( _s: String): T_wp_v2_search_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_search_get.page( _s: String): T_wp_v2_search_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_search_get.per_page( _s: String): T_wp_v2_search_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_search_get.search( _s: String): T_wp_v2_search_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_search_get.type_( _s: String): T_wp_v2_search_get; 
begin
     Parameter_Query( 'type', _s);
     Result:= Self;
end;
function T_wp_v2_search_get.subtype( _s: String): T_wp_v2_search_get; 
begin
     Parameter_Query( 'subtype', _s);
     Result:= Self;
end;
function T_wp_v2_search_get.exclude( _s: String): T_wp_v2_search_get; 
begin
     Parameter_Query( 'exclude', _s);
     Result:= Self;
end;
function T_wp_v2_search_get.include( _s: String): T_wp_v2_search_get; 
begin
     Parameter_Query( 'include', _s);
     Result:= Self;
end; 

// T_wp_v2_search_get Properties

 

 
//Chemin  /wp/v2/block-renderer/{name}

{ T_wp_v2_block_renderer__name__get }

constructor T_wp_v2_block_renderer__name__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/block-renderer/{name}';
     Verb:= 'get';
end;

destructor T_wp_v2_block_renderer__name__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_block_renderer__name__get Parameters

function T_wp_v2_block_renderer__name__get.name( _s: String): T_wp_v2_block_renderer__name__get; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end;
function T_wp_v2_block_renderer__name__get.context( _s: String): T_wp_v2_block_renderer__name__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_block_renderer__name__get.attributes( _s: String): T_wp_v2_block_renderer__name__get; 
begin
     Parameter_Query( 'attributes', _s);
     Result:= Self;
end;
function T_wp_v2_block_renderer__name__get.post_id( _s: String): T_wp_v2_block_renderer__name__get; 
begin
     Parameter_Query( 'post_id', _s);
     Result:= Self;
end; 

// T_wp_v2_block_renderer__name__get Properties

 

 { T_wp_v2_block_renderer__name__post }

constructor T_wp_v2_block_renderer__name__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/block-renderer/{name}';
     Verb:= 'post';
end;

destructor T_wp_v2_block_renderer__name__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_block_renderer__name__post Parameters

function T_wp_v2_block_renderer__name__post.name( _s: String): T_wp_v2_block_renderer__name__post; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end; 

// T_wp_v2_block_renderer__name__post Properties

function T_wp_v2_block_renderer__name__post.attributes( _jd: TJSONData): T_wp_v2_block_renderer__name__post; 
begin
     Property_( 'attributes', _jd);
     Result:= Self;
end;
function T_wp_v2_block_renderer__name__post.post_id( _jd: TJSONData): T_wp_v2_block_renderer__name__post; 
begin
     Property_( 'post_id', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/block-types

{ T_wp_v2_block_types_get }

constructor T_wp_v2_block_types_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/block-types';
     Verb:= 'get';
end;

destructor T_wp_v2_block_types_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_block_types_get Parameters

function T_wp_v2_block_types_get.context( _s: String): T_wp_v2_block_types_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_block_types_get.namespace( _s: String): T_wp_v2_block_types_get; 
begin
     Parameter_Query( 'namespace', _s);
     Result:= Self;
end; 

// T_wp_v2_block_types_get Properties

 

 
//Chemin  /wp/v2/block-types/{namespace}

{ T_wp_v2_block_types__namespace__get }

constructor T_wp_v2_block_types__namespace__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/block-types/{namespace}';
     Verb:= 'get';
end;

destructor T_wp_v2_block_types__namespace__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_block_types__namespace__get Parameters

function T_wp_v2_block_types__namespace__get.context( _s: String): T_wp_v2_block_types__namespace__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_block_types__namespace__get.namespace( _s: String): T_wp_v2_block_types__namespace__get; 
begin
     Parameter_Path( 'namespace', _s);
     Result:= Self;
end; 

// T_wp_v2_block_types__namespace__get Properties

 

 
//Chemin  /wp/v2/block-types/{namespace}/{name}

{ T_wp_v2_block_types__namespace___name__get }

constructor T_wp_v2_block_types__namespace___name__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/block-types/{namespace}/{name}';
     Verb:= 'get';
end;

destructor T_wp_v2_block_types__namespace___name__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_block_types__namespace___name__get Parameters

function T_wp_v2_block_types__namespace___name__get.name( _s: String): T_wp_v2_block_types__namespace___name__get; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end;
function T_wp_v2_block_types__namespace___name__get.namespace( _s: String): T_wp_v2_block_types__namespace___name__get; 
begin
     Parameter_Path( 'namespace', _s);
     Result:= Self;
end;
function T_wp_v2_block_types__namespace___name__get.context( _s: String): T_wp_v2_block_types__namespace___name__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_block_types__namespace___name__get Properties

 

 
//Chemin  /wp/v2/settings

{ T_wp_v2_settings_get }

constructor T_wp_v2_settings_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/settings';
     Verb:= 'get';
end;

destructor T_wp_v2_settings_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_settings_get Parameters

 

// T_wp_v2_settings_get Properties

 

 { T_wp_v2_settings_post }

constructor T_wp_v2_settings_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/settings';
     Verb:= 'post';
end;

destructor T_wp_v2_settings_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_settings_post Parameters

 

// T_wp_v2_settings_post Properties

function T_wp_v2_settings_post.title( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.description( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.url_( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.email( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.timezone( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'timezone', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.date_format( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'date_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.time_format( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'time_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.start_of_week( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'start_of_week', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.language( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'language', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.use_smilies( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'use_smilies', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.default_category( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'default_category', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.default_post_format( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'default_post_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.posts_per_page( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'posts_per_page', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.show_on_front( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'show_on_front', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.page_on_front( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'page_on_front', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.page_for_posts( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'page_for_posts', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.default_ping_status( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'default_ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.default_comment_status( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'default_comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.site_logo( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'site_logo', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_post.site_icon( _jd: TJSONData): T_wp_v2_settings_post; 
begin
     Property_( 'site_icon', _jd);
     Result:= Self;
end; 

 { T_wp_v2_settings_put }

constructor T_wp_v2_settings_put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/settings';
     Verb:= 'put';
end;

destructor T_wp_v2_settings_put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_settings_put Parameters

 

// T_wp_v2_settings_put Properties

function T_wp_v2_settings_put.title( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.description( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.url_( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.email( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.timezone( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'timezone', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.date_format( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'date_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.time_format( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'time_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.start_of_week( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'start_of_week', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.language( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'language', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.use_smilies( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'use_smilies', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.default_category( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'default_category', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.default_post_format( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'default_post_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.posts_per_page( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'posts_per_page', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.show_on_front( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'show_on_front', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.page_on_front( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'page_on_front', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.page_for_posts( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'page_for_posts', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.default_ping_status( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'default_ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.default_comment_status( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'default_comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.site_logo( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'site_logo', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_put.site_icon( _jd: TJSONData): T_wp_v2_settings_put; 
begin
     Property_( 'site_icon', _jd);
     Result:= Self;
end; 

 { T_wp_v2_settings_patch }

constructor T_wp_v2_settings_patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/settings';
     Verb:= 'patch';
end;

destructor T_wp_v2_settings_patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_settings_patch Parameters

 

// T_wp_v2_settings_patch Properties

function T_wp_v2_settings_patch.title( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'title', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.description( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'description', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.url_( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'url', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.email( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'email', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.timezone( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'timezone', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.date_format( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'date_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.time_format( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'time_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.start_of_week( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'start_of_week', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.language( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'language', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.use_smilies( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'use_smilies', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.default_category( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'default_category', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.default_post_format( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'default_post_format', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.posts_per_page( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'posts_per_page', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.show_on_front( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'show_on_front', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.page_on_front( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'page_on_front', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.page_for_posts( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'page_for_posts', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.default_ping_status( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'default_ping_status', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.default_comment_status( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'default_comment_status', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.site_logo( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'site_logo', _jd);
     Result:= Self;
end;
function T_wp_v2_settings_patch.site_icon( _jd: TJSONData): T_wp_v2_settings_patch; 
begin
     Property_( 'site_icon', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/themes

{ T_wp_v2_themes_get }

constructor T_wp_v2_themes_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/themes';
     Verb:= 'get';
end;

destructor T_wp_v2_themes_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_themes_get Parameters

function T_wp_v2_themes_get.status( _s: String): T_wp_v2_themes_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end; 

// T_wp_v2_themes_get Properties

 

 
//Chemin  /wp/v2/themes/{stylesheet}

{ T_wp_v2_themes__stylesheet__get }

constructor T_wp_v2_themes__stylesheet__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/themes/{stylesheet}';
     Verb:= 'get';
end;

destructor T_wp_v2_themes__stylesheet__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_themes__stylesheet__get Parameters

function T_wp_v2_themes__stylesheet__get.stylesheet( _s: String): T_wp_v2_themes__stylesheet__get; 
begin
     Parameter_Path( 'stylesheet', _s);
     Result:= Self;
end; 

// T_wp_v2_themes__stylesheet__get Properties

 

 
//Chemin  /wp/v2/plugins

{ T_wp_v2_plugins_get }

constructor T_wp_v2_plugins_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/plugins';
     Verb:= 'get';
end;

destructor T_wp_v2_plugins_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_plugins_get Parameters

function T_wp_v2_plugins_get.context( _s: String): T_wp_v2_plugins_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_plugins_get.search( _s: String): T_wp_v2_plugins_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_plugins_get.status( _s: String): T_wp_v2_plugins_get; 
begin
     Parameter_Query( 'status', _s);
     Result:= Self;
end; 

// T_wp_v2_plugins_get Properties

 

 { T_wp_v2_plugins_post }

constructor T_wp_v2_plugins_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/plugins';
     Verb:= 'post';
end;

destructor T_wp_v2_plugins_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_plugins_post Parameters

 

// T_wp_v2_plugins_post Properties

function T_wp_v2_plugins_post.slug( _jd: TJSONData): T_wp_v2_plugins_post; 
begin
     Property_( 'slug', _jd);
     Result:= Self;
end;
function T_wp_v2_plugins_post.status( _jd: TJSONData): T_wp_v2_plugins_post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/plugins/{plugin}

{ T_wp_v2_plugins__plugin__get }

constructor T_wp_v2_plugins__plugin__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/plugins/{plugin}';
     Verb:= 'get';
end;

destructor T_wp_v2_plugins__plugin__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_plugins__plugin__get Parameters

function T_wp_v2_plugins__plugin__get.context( _s: String): T_wp_v2_plugins__plugin__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_plugins__plugin__get.plugin( _s: String): T_wp_v2_plugins__plugin__get; 
begin
     Parameter_Path( 'plugin', _s);
     Result:= Self;
end; 

// T_wp_v2_plugins__plugin__get Properties

 

 { T_wp_v2_plugins__plugin__post }

constructor T_wp_v2_plugins__plugin__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/plugins/{plugin}';
     Verb:= 'post';
end;

destructor T_wp_v2_plugins__plugin__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_plugins__plugin__post Parameters

function T_wp_v2_plugins__plugin__post.plugin( _s: String): T_wp_v2_plugins__plugin__post; 
begin
     Parameter_Path( 'plugin', _s);
     Result:= Self;
end; 

// T_wp_v2_plugins__plugin__post Properties

function T_wp_v2_plugins__plugin__post.status( _jd: TJSONData): T_wp_v2_plugins__plugin__post; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end; 

 { T_wp_v2_plugins__plugin__put }

constructor T_wp_v2_plugins__plugin__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/plugins/{plugin}';
     Verb:= 'put';
end;

destructor T_wp_v2_plugins__plugin__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_plugins__plugin__put Parameters

function T_wp_v2_plugins__plugin__put.plugin( _s: String): T_wp_v2_plugins__plugin__put; 
begin
     Parameter_Path( 'plugin', _s);
     Result:= Self;
end; 

// T_wp_v2_plugins__plugin__put Properties

function T_wp_v2_plugins__plugin__put.status( _jd: TJSONData): T_wp_v2_plugins__plugin__put; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end; 

 { T_wp_v2_plugins__plugin__patch }

constructor T_wp_v2_plugins__plugin__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/plugins/{plugin}';
     Verb:= 'patch';
end;

destructor T_wp_v2_plugins__plugin__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_plugins__plugin__patch Parameters

function T_wp_v2_plugins__plugin__patch.plugin( _s: String): T_wp_v2_plugins__plugin__patch; 
begin
     Parameter_Path( 'plugin', _s);
     Result:= Self;
end; 

// T_wp_v2_plugins__plugin__patch Properties

function T_wp_v2_plugins__plugin__patch.status( _jd: TJSONData): T_wp_v2_plugins__plugin__patch; 
begin
     Property_( 'status', _jd);
     Result:= Self;
end; 

 { T_wp_v2_plugins__plugin__delete }

constructor T_wp_v2_plugins__plugin__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/plugins/{plugin}';
     Verb:= 'delete';
end;

destructor T_wp_v2_plugins__plugin__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_plugins__plugin__delete Parameters

function T_wp_v2_plugins__plugin__delete.plugin( _s: String): T_wp_v2_plugins__plugin__delete; 
begin
     Parameter_Path( 'plugin', _s);
     Result:= Self;
end; 

// T_wp_v2_plugins__plugin__delete Properties

 

 
//Chemin  /wp/v2/sidebars

{ T_wp_v2_sidebars_get }

constructor T_wp_v2_sidebars_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/sidebars';
     Verb:= 'get';
end;

destructor T_wp_v2_sidebars_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_sidebars_get Parameters

function T_wp_v2_sidebars_get.context( _s: String): T_wp_v2_sidebars_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_sidebars_get Properties

 

 
//Chemin  /wp/v2/sidebars/{id}

{ T_wp_v2_sidebars__id__get }

constructor T_wp_v2_sidebars__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/sidebars/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_sidebars__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_sidebars__id__get Parameters

function T_wp_v2_sidebars__id__get.id( _s: String): T_wp_v2_sidebars__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_sidebars__id__get.context( _s: String): T_wp_v2_sidebars__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_sidebars__id__get Properties

 

 { T_wp_v2_sidebars__id__post }

constructor T_wp_v2_sidebars__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/sidebars/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_sidebars__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_sidebars__id__post Parameters

function T_wp_v2_sidebars__id__post.id( _s: String): T_wp_v2_sidebars__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_sidebars__id__post Properties

function T_wp_v2_sidebars__id__post.widgets( _jd: TJSONData): T_wp_v2_sidebars__id__post; 
begin
     Property_( 'widgets', _jd);
     Result:= Self;
end; 

 { T_wp_v2_sidebars__id__put }

constructor T_wp_v2_sidebars__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/sidebars/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_sidebars__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_sidebars__id__put Parameters

function T_wp_v2_sidebars__id__put.id( _s: String): T_wp_v2_sidebars__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_sidebars__id__put Properties

function T_wp_v2_sidebars__id__put.widgets( _jd: TJSONData): T_wp_v2_sidebars__id__put; 
begin
     Property_( 'widgets', _jd);
     Result:= Self;
end; 

 { T_wp_v2_sidebars__id__patch }

constructor T_wp_v2_sidebars__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/sidebars/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_sidebars__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_sidebars__id__patch Parameters

function T_wp_v2_sidebars__id__patch.id( _s: String): T_wp_v2_sidebars__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_sidebars__id__patch Properties

function T_wp_v2_sidebars__id__patch.widgets( _jd: TJSONData): T_wp_v2_sidebars__id__patch; 
begin
     Property_( 'widgets', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/widget-types

{ T_wp_v2_widget_types_get }

constructor T_wp_v2_widget_types_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widget-types';
     Verb:= 'get';
end;

destructor T_wp_v2_widget_types_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widget_types_get Parameters

function T_wp_v2_widget_types_get.context( _s: String): T_wp_v2_widget_types_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_widget_types_get Properties

 

 
//Chemin  /wp/v2/widget-types/{id}

{ T_wp_v2_widget_types__id__get }

constructor T_wp_v2_widget_types__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widget-types/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_widget_types__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widget_types__id__get Parameters

function T_wp_v2_widget_types__id__get.id( _s: String): T_wp_v2_widget_types__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end;
function T_wp_v2_widget_types__id__get.context( _s: String): T_wp_v2_widget_types__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_widget_types__id__get Properties

 

 
//Chemin  /wp/v2/widget-types/{id}/encode

{ T_wp_v2_widget_types__id__encode_post }

constructor T_wp_v2_widget_types__id__encode_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widget-types/{id}/encode';
     Verb:= 'post';
end;

destructor T_wp_v2_widget_types__id__encode_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widget_types__id__encode_post Parameters

function T_wp_v2_widget_types__id__encode_post.id( _s: String): T_wp_v2_widget_types__id__encode_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_widget_types__id__encode_post Properties

function T_wp_v2_widget_types__id__encode_post.instance( _jd: TJSONData): T_wp_v2_widget_types__id__encode_post; 
begin
     Property_( 'instance', _jd);
     Result:= Self;
end;
function T_wp_v2_widget_types__id__encode_post.form_data( _jd: TJSONData): T_wp_v2_widget_types__id__encode_post; 
begin
     Property_( 'form_data', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/widget-types/{id}/render

{ T_wp_v2_widget_types__id__render_post }

constructor T_wp_v2_widget_types__id__render_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widget-types/{id}/render';
     Verb:= 'post';
end;

destructor T_wp_v2_widget_types__id__render_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widget_types__id__render_post Parameters

function T_wp_v2_widget_types__id__render_post.id( _s: String): T_wp_v2_widget_types__id__render_post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_widget_types__id__render_post Properties

function T_wp_v2_widget_types__id__render_post.instance( _jd: TJSONData): T_wp_v2_widget_types__id__render_post; 
begin
     Property_( 'instance', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/widgets

{ T_wp_v2_widgets_get }

constructor T_wp_v2_widgets_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widgets';
     Verb:= 'get';
end;

destructor T_wp_v2_widgets_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widgets_get Parameters

function T_wp_v2_widgets_get.context( _s: String): T_wp_v2_widgets_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_widgets_get.sidebar( _s: String): T_wp_v2_widgets_get; 
begin
     Parameter_Query( 'sidebar', _s);
     Result:= Self;
end; 

// T_wp_v2_widgets_get Properties

 

 { T_wp_v2_widgets_post }

constructor T_wp_v2_widgets_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widgets';
     Verb:= 'post';
end;

destructor T_wp_v2_widgets_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widgets_post Parameters

 

// T_wp_v2_widgets_post Properties

function T_wp_v2_widgets_post.id( _jd: TJSONData): T_wp_v2_widgets_post; 
begin
     Property_( 'id', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets_post.id_base( _jd: TJSONData): T_wp_v2_widgets_post; 
begin
     Property_( 'id_base', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets_post.sidebar( _jd: TJSONData): T_wp_v2_widgets_post; 
begin
     Property_( 'sidebar', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets_post.instance( _jd: TJSONData): T_wp_v2_widgets_post; 
begin
     Property_( 'instance', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets_post.form_data( _jd: TJSONData): T_wp_v2_widgets_post; 
begin
     Property_( 'form_data', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/widgets/{id}

{ T_wp_v2_widgets__id__get }

constructor T_wp_v2_widgets__id__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widgets/{id}';
     Verb:= 'get';
end;

destructor T_wp_v2_widgets__id__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widgets__id__get Parameters

function T_wp_v2_widgets__id__get.context( _s: String): T_wp_v2_widgets__id__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_widgets__id__get.id( _s: String): T_wp_v2_widgets__id__get; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_widgets__id__get Properties

 

 { T_wp_v2_widgets__id__post }

constructor T_wp_v2_widgets__id__post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widgets/{id}';
     Verb:= 'post';
end;

destructor T_wp_v2_widgets__id__post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widgets__id__post Parameters

function T_wp_v2_widgets__id__post.id( _s: String): T_wp_v2_widgets__id__post; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_widgets__id__post Properties

function T_wp_v2_widgets__id__post.id_base( _jd: TJSONData): T_wp_v2_widgets__id__post; 
begin
     Property_( 'id_base', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__post.sidebar( _jd: TJSONData): T_wp_v2_widgets__id__post; 
begin
     Property_( 'sidebar', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__post.instance( _jd: TJSONData): T_wp_v2_widgets__id__post; 
begin
     Property_( 'instance', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__post.form_data( _jd: TJSONData): T_wp_v2_widgets__id__post; 
begin
     Property_( 'form_data', _jd);
     Result:= Self;
end; 

 { T_wp_v2_widgets__id__put }

constructor T_wp_v2_widgets__id__put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widgets/{id}';
     Verb:= 'put';
end;

destructor T_wp_v2_widgets__id__put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widgets__id__put Parameters

function T_wp_v2_widgets__id__put.id( _s: String): T_wp_v2_widgets__id__put; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_widgets__id__put Properties

function T_wp_v2_widgets__id__put.id_base( _jd: TJSONData): T_wp_v2_widgets__id__put; 
begin
     Property_( 'id_base', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__put.sidebar( _jd: TJSONData): T_wp_v2_widgets__id__put; 
begin
     Property_( 'sidebar', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__put.instance( _jd: TJSONData): T_wp_v2_widgets__id__put; 
begin
     Property_( 'instance', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__put.form_data( _jd: TJSONData): T_wp_v2_widgets__id__put; 
begin
     Property_( 'form_data', _jd);
     Result:= Self;
end; 

 { T_wp_v2_widgets__id__patch }

constructor T_wp_v2_widgets__id__patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widgets/{id}';
     Verb:= 'patch';
end;

destructor T_wp_v2_widgets__id__patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widgets__id__patch Parameters

function T_wp_v2_widgets__id__patch.id( _s: String): T_wp_v2_widgets__id__patch; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_widgets__id__patch Properties

function T_wp_v2_widgets__id__patch.id_base( _jd: TJSONData): T_wp_v2_widgets__id__patch; 
begin
     Property_( 'id_base', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__patch.sidebar( _jd: TJSONData): T_wp_v2_widgets__id__patch; 
begin
     Property_( 'sidebar', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__patch.instance( _jd: TJSONData): T_wp_v2_widgets__id__patch; 
begin
     Property_( 'instance', _jd);
     Result:= Self;
end;
function T_wp_v2_widgets__id__patch.form_data( _jd: TJSONData): T_wp_v2_widgets__id__patch; 
begin
     Property_( 'form_data', _jd);
     Result:= Self;
end; 

 { T_wp_v2_widgets__id__delete }

constructor T_wp_v2_widgets__id__delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/widgets/{id}';
     Verb:= 'delete';
end;

destructor T_wp_v2_widgets__id__delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_widgets__id__delete Parameters

function T_wp_v2_widgets__id__delete.id( _s: String): T_wp_v2_widgets__id__delete; 
begin
     Parameter_Path( 'id', _s);
     Result:= Self;
end; 

// T_wp_v2_widgets__id__delete Properties

function T_wp_v2_widgets__id__delete.force( _jd: TJSONData): T_wp_v2_widgets__id__delete; 
begin
     Property_( 'force', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp/v2/block-directory/search

{ T_wp_v2_block_directory_search_get }

constructor T_wp_v2_block_directory_search_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/block-directory/search';
     Verb:= 'get';
end;

destructor T_wp_v2_block_directory_search_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_block_directory_search_get Parameters

function T_wp_v2_block_directory_search_get.context( _s: String): T_wp_v2_block_directory_search_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_block_directory_search_get.page( _s: String): T_wp_v2_block_directory_search_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_block_directory_search_get.per_page( _s: String): T_wp_v2_block_directory_search_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_block_directory_search_get.term( _s: String): T_wp_v2_block_directory_search_get; 
begin
     Parameter_Query( 'term', _s);
     Result:= Self;
end; 

// T_wp_v2_block_directory_search_get Properties

 

 
//Chemin  /wp/v2/pattern-directory/patterns

{ T_wp_v2_pattern_directory_patterns_get }

constructor T_wp_v2_pattern_directory_patterns_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/pattern-directory/patterns';
     Verb:= 'get';
end;

destructor T_wp_v2_pattern_directory_patterns_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_pattern_directory_patterns_get Parameters

function T_wp_v2_pattern_directory_patterns_get.context( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.page( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.per_page( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.search( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.category( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'category', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.keyword( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'keyword', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.slug( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'slug', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.offset( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'offset', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.order( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'order', _s);
     Result:= Self;
end;
function T_wp_v2_pattern_directory_patterns_get.orderby( _s: String): T_wp_v2_pattern_directory_patterns_get; 
begin
     Parameter_Query( 'orderby', _s);
     Result:= Self;
end; 

// T_wp_v2_pattern_directory_patterns_get Properties

 

 
//Chemin  /wp/v2/block-patterns/patterns

{ T_wp_v2_block_patterns_patterns_get }

constructor T_wp_v2_block_patterns_patterns_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/block-patterns/patterns';
     Verb:= 'get';
end;

destructor T_wp_v2_block_patterns_patterns_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_block_patterns_patterns_get Parameters

 

// T_wp_v2_block_patterns_patterns_get Properties

 

 
//Chemin  /wp/v2/block-patterns/categories

{ T_wp_v2_block_patterns_categories_get }

constructor T_wp_v2_block_patterns_categories_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/block-patterns/categories';
     Verb:= 'get';
end;

destructor T_wp_v2_block_patterns_categories_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_block_patterns_categories_get Parameters

 

// T_wp_v2_block_patterns_categories_get Properties

 

 
//Chemin  /wp/v2/menu-locations

{ T_wp_v2_menu_locations_get }

constructor T_wp_v2_menu_locations_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-locations';
     Verb:= 'get';
end;

destructor T_wp_v2_menu_locations_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_locations_get Parameters

function T_wp_v2_menu_locations_get.context( _s: String): T_wp_v2_menu_locations_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_locations_get Properties

 

 
//Chemin  /wp/v2/menu-locations/{location}

{ T_wp_v2_menu_locations__location__get }

constructor T_wp_v2_menu_locations__location__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/menu-locations/{location}';
     Verb:= 'get';
end;

destructor T_wp_v2_menu_locations__location__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_menu_locations__location__get Parameters

function T_wp_v2_menu_locations__location__get.location( _s: String): T_wp_v2_menu_locations__location__get; 
begin
     Parameter_Path( 'location', _s);
     Result:= Self;
end;
function T_wp_v2_menu_locations__location__get.context( _s: String): T_wp_v2_menu_locations__location__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_menu_locations__location__get Properties

 

 
//Chemin  /wp/v2/font-collections

{ T_wp_v2_font_collections_get }

constructor T_wp_v2_font_collections_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-collections';
     Verb:= 'get';
end;

destructor T_wp_v2_font_collections_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_collections_get Parameters

function T_wp_v2_font_collections_get.context( _s: String): T_wp_v2_font_collections_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_font_collections_get.page( _s: String): T_wp_v2_font_collections_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_font_collections_get.per_page( _s: String): T_wp_v2_font_collections_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end; 

// T_wp_v2_font_collections_get Properties

 

 
//Chemin  /wp/v2/font-collections/{slug}

{ T_wp_v2_font_collections__slug__get }

constructor T_wp_v2_font_collections__slug__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/font-collections/{slug}';
     Verb:= 'get';
end;

destructor T_wp_v2_font_collections__slug__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_font_collections__slug__get Parameters

function T_wp_v2_font_collections__slug__get.context( _s: String): T_wp_v2_font_collections__slug__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_font_collections__slug__get.slug( _s: String): T_wp_v2_font_collections__slug__get; 
begin
     Parameter_Path( 'slug', _s);
     Result:= Self;
end; 

// T_wp_v2_font_collections__slug__get Properties

 

 
//Chemin  /wp/v2/icons

{ T_wp_v2_icons_get }

constructor T_wp_v2_icons_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/icons';
     Verb:= 'get';
end;

destructor T_wp_v2_icons_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_icons_get Parameters

function T_wp_v2_icons_get.context( _s: String): T_wp_v2_icons_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_v2_icons_get.page( _s: String): T_wp_v2_icons_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_v2_icons_get.per_page( _s: String): T_wp_v2_icons_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_v2_icons_get.search( _s: String): T_wp_v2_icons_get; 
begin
     Parameter_Query( 'search', _s);
     Result:= Self;
end; 

// T_wp_v2_icons_get Properties

 

 
//Chemin  /wp/v2/icons/{name}

{ T_wp_v2_icons__name__get }

constructor T_wp_v2_icons__name__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp/v2/icons/{name}';
     Verb:= 'get';
end;

destructor T_wp_v2_icons__name__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_v2_icons__name__get Parameters

function T_wp_v2_icons__name__get.name( _s: String): T_wp_v2_icons__name__get; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end;
function T_wp_v2_icons__name__get.context( _s: String): T_wp_v2_icons__name__get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_v2_icons__name__get Properties

 

 
//Chemin  /wp-site-health/v1

{ T_wp_site_health_v1_get }

constructor T_wp_site_health_v1_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-site-health/v1';
     Verb:= 'get';
end;

destructor T_wp_site_health_v1_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_site_health_v1_get Parameters

function T_wp_site_health_v1_get.namespace( _s: String): T_wp_site_health_v1_get; 
begin
     Parameter_Query( 'namespace', _s);
     Result:= Self;
end;
function T_wp_site_health_v1_get.context( _s: String): T_wp_site_health_v1_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_site_health_v1_get Properties

 

 
//Chemin  /wp-site-health/v1/tests/background-updates

{ T_wp_site_health_v1_tests_background_updates_get }

constructor T_wp_site_health_v1_tests_background_updates_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-site-health/v1/tests/background-updates';
     Verb:= 'get';
end;

destructor T_wp_site_health_v1_tests_background_updates_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_site_health_v1_tests_background_updates_get Parameters

 

// T_wp_site_health_v1_tests_background_updates_get Properties

 

 
//Chemin  /wp-site-health/v1/tests/loopback-requests

{ T_wp_site_health_v1_tests_loopback_requests_get }

constructor T_wp_site_health_v1_tests_loopback_requests_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-site-health/v1/tests/loopback-requests';
     Verb:= 'get';
end;

destructor T_wp_site_health_v1_tests_loopback_requests_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_site_health_v1_tests_loopback_requests_get Parameters

 

// T_wp_site_health_v1_tests_loopback_requests_get Properties

 

 
//Chemin  /wp-site-health/v1/tests/https-status

{ T_wp_site_health_v1_tests_https_status_get }

constructor T_wp_site_health_v1_tests_https_status_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-site-health/v1/tests/https-status';
     Verb:= 'get';
end;

destructor T_wp_site_health_v1_tests_https_status_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_site_health_v1_tests_https_status_get Parameters

 

// T_wp_site_health_v1_tests_https_status_get Properties

 

 
//Chemin  /wp-site-health/v1/tests/dotorg-communication

{ T_wp_site_health_v1_tests_dotorg_communication_get }

constructor T_wp_site_health_v1_tests_dotorg_communication_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-site-health/v1/tests/dotorg-communication';
     Verb:= 'get';
end;

destructor T_wp_site_health_v1_tests_dotorg_communication_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_site_health_v1_tests_dotorg_communication_get Parameters

 

// T_wp_site_health_v1_tests_dotorg_communication_get Properties

 

 
//Chemin  /wp-site-health/v1/tests/authorization-header

{ T_wp_site_health_v1_tests_authorization_header_get }

constructor T_wp_site_health_v1_tests_authorization_header_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-site-health/v1/tests/authorization-header';
     Verb:= 'get';
end;

destructor T_wp_site_health_v1_tests_authorization_header_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_site_health_v1_tests_authorization_header_get Parameters

 

// T_wp_site_health_v1_tests_authorization_header_get Properties

 

 
//Chemin  /wp-site-health/v1/directory-sizes

{ T_wp_site_health_v1_directory_sizes_get }

constructor T_wp_site_health_v1_directory_sizes_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-site-health/v1/directory-sizes';
     Verb:= 'get';
end;

destructor T_wp_site_health_v1_directory_sizes_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_site_health_v1_directory_sizes_get Parameters

 

// T_wp_site_health_v1_directory_sizes_get Properties

 

 
//Chemin  /wp-site-health/v1/tests/page-cache

{ T_wp_site_health_v1_tests_page_cache_get }

constructor T_wp_site_health_v1_tests_page_cache_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-site-health/v1/tests/page-cache';
     Verb:= 'get';
end;

destructor T_wp_site_health_v1_tests_page_cache_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_site_health_v1_tests_page_cache_get Parameters

 

// T_wp_site_health_v1_tests_page_cache_get Properties

 

 
//Chemin  /wp-block-editor/v1

{ T_wp_block_editor_v1_get }

constructor T_wp_block_editor_v1_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-block-editor/v1';
     Verb:= 'get';
end;

destructor T_wp_block_editor_v1_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_block_editor_v1_get Parameters

function T_wp_block_editor_v1_get.namespace( _s: String): T_wp_block_editor_v1_get; 
begin
     Parameter_Query( 'namespace', _s);
     Result:= Self;
end;
function T_wp_block_editor_v1_get.context( _s: String): T_wp_block_editor_v1_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_block_editor_v1_get Properties

 

 
//Chemin  /wp-block-editor/v1/url-details

{ T_wp_block_editor_v1_url_details_get }

constructor T_wp_block_editor_v1_url_details_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-block-editor/v1/url-details';
     Verb:= 'get';
end;

destructor T_wp_block_editor_v1_url_details_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_block_editor_v1_url_details_get Parameters

function T_wp_block_editor_v1_url_details_get.url_( _s: String): T_wp_block_editor_v1_url_details_get; 
begin
     Parameter_Query( 'url', _s);
     Result:= Self;
end; 

// T_wp_block_editor_v1_url_details_get Properties

 

 
//Chemin  /wp-block-editor/v1/export

{ T_wp_block_editor_v1_export_get }

constructor T_wp_block_editor_v1_export_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-block-editor/v1/export';
     Verb:= 'get';
end;

destructor T_wp_block_editor_v1_export_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_block_editor_v1_export_get Parameters

 

// T_wp_block_editor_v1_export_get Properties

 

 
//Chemin  /wp-block-editor/v1/navigation-fallback

{ T_wp_block_editor_v1_navigation_fallback_get }

constructor T_wp_block_editor_v1_navigation_fallback_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-block-editor/v1/navigation-fallback';
     Verb:= 'get';
end;

destructor T_wp_block_editor_v1_navigation_fallback_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_block_editor_v1_navigation_fallback_get Parameters

 

// T_wp_block_editor_v1_navigation_fallback_get Properties

 

 
//Chemin  /wp-abilities/v1

{ T_wp_abilities_v1_get }

constructor T_wp_abilities_v1_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1';
     Verb:= 'get';
end;

destructor T_wp_abilities_v1_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_get Parameters

function T_wp_abilities_v1_get.namespace( _s: String): T_wp_abilities_v1_get; 
begin
     Parameter_Query( 'namespace', _s);
     Result:= Self;
end;
function T_wp_abilities_v1_get.context( _s: String): T_wp_abilities_v1_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_get Properties

 

 
//Chemin  /wp-abilities/v1/categories

{ T_wp_abilities_v1_categories_get }

constructor T_wp_abilities_v1_categories_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/categories';
     Verb:= 'get';
end;

destructor T_wp_abilities_v1_categories_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_categories_get Parameters

function T_wp_abilities_v1_categories_get.context( _s: String): T_wp_abilities_v1_categories_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_abilities_v1_categories_get.page( _s: String): T_wp_abilities_v1_categories_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_abilities_v1_categories_get.per_page( _s: String): T_wp_abilities_v1_categories_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_categories_get Properties

 

 
//Chemin  /wp-abilities/v1/categories/{slug}

{ T_wp_abilities_v1_categories__slug__get }

constructor T_wp_abilities_v1_categories__slug__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/categories/{slug}';
     Verb:= 'get';
end;

destructor T_wp_abilities_v1_categories__slug__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_categories__slug__get Parameters

function T_wp_abilities_v1_categories__slug__get.slug( _s: String): T_wp_abilities_v1_categories__slug__get; 
begin
     Parameter_Path( 'slug', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_categories__slug__get Properties

 

 
//Chemin  /wp-abilities/v1/abilities/{name}/run

{ T_wp_abilities_v1_abilities__name__run_get }

constructor T_wp_abilities_v1_abilities__name__run_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/abilities/{name}/run';
     Verb:= 'get';
end;

destructor T_wp_abilities_v1_abilities__name__run_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_abilities__name__run_get Parameters

function T_wp_abilities_v1_abilities__name__run_get.name( _s: String): T_wp_abilities_v1_abilities__name__run_get; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end;
function T_wp_abilities_v1_abilities__name__run_get.input( _s: String): T_wp_abilities_v1_abilities__name__run_get; 
begin
     Parameter_Query( 'input', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_abilities__name__run_get Properties

 

 { T_wp_abilities_v1_abilities__name__run_post }

constructor T_wp_abilities_v1_abilities__name__run_post.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/abilities/{name}/run';
     Verb:= 'post';
end;

destructor T_wp_abilities_v1_abilities__name__run_post.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_abilities__name__run_post Parameters

function T_wp_abilities_v1_abilities__name__run_post.name( _s: String): T_wp_abilities_v1_abilities__name__run_post; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_abilities__name__run_post Properties

function T_wp_abilities_v1_abilities__name__run_post.input( _jd: TJSONData): T_wp_abilities_v1_abilities__name__run_post; 
begin
     Property_( 'input', _jd);
     Result:= Self;
end; 

 { T_wp_abilities_v1_abilities__name__run_put }

constructor T_wp_abilities_v1_abilities__name__run_put.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/abilities/{name}/run';
     Verb:= 'put';
end;

destructor T_wp_abilities_v1_abilities__name__run_put.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_abilities__name__run_put Parameters

function T_wp_abilities_v1_abilities__name__run_put.name( _s: String): T_wp_abilities_v1_abilities__name__run_put; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_abilities__name__run_put Properties

function T_wp_abilities_v1_abilities__name__run_put.input( _jd: TJSONData): T_wp_abilities_v1_abilities__name__run_put; 
begin
     Property_( 'input', _jd);
     Result:= Self;
end; 

 { T_wp_abilities_v1_abilities__name__run_patch }

constructor T_wp_abilities_v1_abilities__name__run_patch.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/abilities/{name}/run';
     Verb:= 'patch';
end;

destructor T_wp_abilities_v1_abilities__name__run_patch.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_abilities__name__run_patch Parameters

function T_wp_abilities_v1_abilities__name__run_patch.name( _s: String): T_wp_abilities_v1_abilities__name__run_patch; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_abilities__name__run_patch Properties

function T_wp_abilities_v1_abilities__name__run_patch.input( _jd: TJSONData): T_wp_abilities_v1_abilities__name__run_patch; 
begin
     Property_( 'input', _jd);
     Result:= Self;
end; 

 { T_wp_abilities_v1_abilities__name__run_delete }

constructor T_wp_abilities_v1_abilities__name__run_delete.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/abilities/{name}/run';
     Verb:= 'delete';
end;

destructor T_wp_abilities_v1_abilities__name__run_delete.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_abilities__name__run_delete Parameters

function T_wp_abilities_v1_abilities__name__run_delete.name( _s: String): T_wp_abilities_v1_abilities__name__run_delete; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_abilities__name__run_delete Properties

function T_wp_abilities_v1_abilities__name__run_delete.input( _jd: TJSONData): T_wp_abilities_v1_abilities__name__run_delete; 
begin
     Property_( 'input', _jd);
     Result:= Self;
end; 

 
//Chemin  /wp-abilities/v1/abilities

{ T_wp_abilities_v1_abilities_get }

constructor T_wp_abilities_v1_abilities_get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/abilities';
     Verb:= 'get';
end;

destructor T_wp_abilities_v1_abilities_get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_abilities_get Parameters

function T_wp_abilities_v1_abilities_get.context( _s: String): T_wp_abilities_v1_abilities_get; 
begin
     Parameter_Query( 'context', _s);
     Result:= Self;
end;
function T_wp_abilities_v1_abilities_get.page( _s: String): T_wp_abilities_v1_abilities_get; 
begin
     Parameter_Query( 'page', _s);
     Result:= Self;
end;
function T_wp_abilities_v1_abilities_get.per_page( _s: String): T_wp_abilities_v1_abilities_get; 
begin
     Parameter_Query( 'per_page', _s);
     Result:= Self;
end;
function T_wp_abilities_v1_abilities_get.category( _s: String): T_wp_abilities_v1_abilities_get; 
begin
     Parameter_Query( 'category', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_abilities_get Properties

 

 
//Chemin  /wp-abilities/v1/abilities/{name}

{ T_wp_abilities_v1_abilities__name__get }

constructor T_wp_abilities_v1_abilities__name__get.Create( _root_url, _Username, _Password: String);
begin
     inherited Create( _Username, _Password);
     url:= _root_url+'/wp-json/wp-abilities/v1/abilities/{name}';
     Verb:= 'get';
end;

destructor T_wp_abilities_v1_abilities__name__get.Destroy;
begin
     inherited Destroy;
end;

// T_wp_abilities_v1_abilities__name__get Parameters

function T_wp_abilities_v1_abilities__name__get.name( _s: String): T_wp_abilities_v1_abilities__name__get; 
begin
     Parameter_Path( 'name', _s);
     Result:= Self;
end; 

// T_wp_abilities_v1_abilities__name__get Properties

 

   

end.

