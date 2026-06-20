unit uPath__wp_v2_posts__id_;
//Chemin  Path./wp/v2/posts/{id}
{$mode Delphi}

interface

uses
    uuStrings,
    uMimeType,
    uWordpress_verb,
    ublpost,

 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type
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
 
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblpost;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblpost;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblpost;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblpost;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblpost;  
     end;

 

implementation

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

 

// T_wp_v2_posts__id__get Responses

// Réponse 200 OK

function T_wp_v2_posts__id__get.R_200( _i: Integer=0): Tblpost;
var
   i: Integer;
   ja: TJSONArray;
   r: Tblpost;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblpost.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblpost.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
end; 
 
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

// T_wp_v2_posts__id__post Responses

// Réponse 200 OK

function T_wp_v2_posts__id__post.R_200( _i: Integer=0): Tblpost;
var
   i: Integer;
   ja: TJSONArray;
   r: Tblpost;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblpost.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblpost.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_posts__id__put Responses

// Réponse 200 OK

function T_wp_v2_posts__id__put.R_200( _i: Integer=0): Tblpost;
var
   i: Integer;
   ja: TJSONArray;
   r: Tblpost;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblpost.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblpost.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_posts__id__patch Responses

// Réponse 200 OK

function T_wp_v2_posts__id__patch.R_200( _i: Integer=0): Tblpost;
var
   i: Integer;
   ja: TJSONArray;
   r: Tblpost;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblpost.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblpost.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_posts__id__delete Responses

// Réponse 200 OK

function T_wp_v2_posts__id__delete.R_200( _i: Integer=0): Tblpost;
var
   i: Integer;
   ja: TJSONArray;
   r: Tblpost;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblpost.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblpost.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
end; 
 
 

end.

