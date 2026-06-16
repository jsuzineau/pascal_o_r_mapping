unit uPath__wp_v2_media;
//Chemin  Path./wp/v2/media
{$mode Delphi}

interface

uses
    uuStrings,
    uMimeType,
    uWordpress_verb,
    ublattachment,

 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type
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
 
     //Responses
     public
       // Réponse 200 OK
       type Tattachment_array = array of Tblattachment;
        function R_200( _i: Integer=0): Tattachment_array;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblattachment;  
     end;

 

implementation

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

 

// T_wp_v2_media_get Responses

// Réponse 200 OK

function T_wp_v2_media_get.R_200( _i: Integer=0): Tattachment_array;
var
   i: Integer;
   ja: TJSONArray;
   r: Tblattachment;
begin
     //if True
     //then
     //    begin
         ja:= jdResult as TJSONArray;
         SetLength( Result, ja.Count);
         for i:= 0 to ja.Count-1
         do
           begin
           r:= Tblattachment.Create(nil,nil,nil);
           r.JSON:= ja.Items[i].AsString;
           Result[ i]:= r;
           end;
    //     end
    // else
    //     begin
    //     Result:= Tblattachment.Create(nil,nil,nil);
    //     Result.JSON:= sResult;
    //     end;
end; 
 
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

// T_wp_v2_media_post Responses

// Réponse 200 OK

function T_wp_v2_media_post.R_200( _i: Integer=0): Tblattachment;
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

