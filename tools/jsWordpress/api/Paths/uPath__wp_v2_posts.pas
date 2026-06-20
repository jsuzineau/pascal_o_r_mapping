unit uPath__wp_v2_posts;
//Chemin  Path./wp/v2/posts
{$mode Delphi}

interface

uses
    uuStrings,
    uMimeType,
    uWordpress_verb,
    ublpost,

 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type
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
 
     //Responses
     public
       // Réponse 200 OK
       type Tpost_array = array of Tblpost;
        function R_200( _i: Integer=0): Tpost_array;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblpost;  
     end;

 

implementation

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

 

// T_wp_v2_posts_get Responses

// Réponse 200 OK

function T_wp_v2_posts_get.R_200( _i: Integer=0): Tpost_array;
var
   i: Integer;
   ja: TJSONArray;
   r: Tblpost;
begin
     //if True
     //then
     //    begin
         ja:= jdResult as TJSONArray;
         SetLength( Result, ja.Count);
         for i:= 0 to ja.Count-1
         do
           begin
           r:= Tblpost.Create(nil,nil,nil);
           r.JSON:= ja.Items[i].AsJSON;
           Result[ i]:= r;
           end;
    //     end
    // else
    //     begin
    //     Result:= Tblpost.Create(nil,nil,nil);
    //     Result.JSON:= sResult;
    //     end;
end; 
 
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

// T_wp_v2_posts_post Responses

// Réponse 200 OK

function T_wp_v2_posts_post.R_200( _i: Integer=0): Tblpost;
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

