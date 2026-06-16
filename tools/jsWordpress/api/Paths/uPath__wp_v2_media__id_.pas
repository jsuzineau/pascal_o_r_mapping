unit uPath__wp_v2_media__id_;
//Chemin  Path./wp/v2/media/{id}
{$mode Delphi}

interface

uses
    uuStrings,
    uMimeType,
    uWordpress_verb,
    ublattachment,

 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type
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
 
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblattachment;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblattachment;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblattachment;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblattachment;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblattachment;  
     end;

 

implementation

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

 

// T_wp_v2_media__id__get Responses

// Réponse 200 OK

function T_wp_v2_media__id__get.R_200( _i: Integer=0): Tblattachment;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tblattachment;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblattachment.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsString;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblattachment.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
end; 
 
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

// T_wp_v2_media__id__post Responses

// Réponse 200 OK

function T_wp_v2_media__id__post.R_200( _i: Integer=0): Tblattachment;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tblattachment;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblattachment.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsString;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblattachment.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_media__id__put Responses

// Réponse 200 OK

function T_wp_v2_media__id__put.R_200( _i: Integer=0): Tblattachment;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tblattachment;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblattachment.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsString;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblattachment.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_media__id__patch Responses

// Réponse 200 OK

function T_wp_v2_media__id__patch.R_200( _i: Integer=0): Tblattachment;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tblattachment;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblattachment.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsString;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblattachment.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_media__id__delete Responses

// Réponse 200 OK

function T_wp_v2_media__id__delete.R_200( _i: Integer=0): Tblattachment;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tblattachment;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblattachment.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsString;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblattachment.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
end; 
 
 

end.

