unit uPath__wp_v2_pages;
//Chemin  Path./wp/v2/pages
{$mode Delphi}

interface

uses
    uuStrings,
    uMimeType,
    uWordpress_verb,
    ublpage,

 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type
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
 
     //Responses
     public
       // Réponse 200 OK
       type Tpage_array = array of Tblpage;
        function R_200( _i: Integer=0): Tpage_array;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tblpage;  
     end;

 

implementation

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

 

// T_wp_v2_pages_get Responses

// Réponse 200 OK

function T_wp_v2_pages_get.R_200( _i: Integer=0): Tpage_array;
var
   i: Integer;
   ja: TJSONArray;
   r: Tblpage;
begin
     //if True
     //then
     //    begin
         ja:= jdResult as TJSONArray;
         SetLength( Result, ja.Count);
         for i:= 0 to ja.Count-1
         do
           begin
           r:= Tblpage.Create(nil,nil,nil);
           r.JSON:= ja.Items[i].AsJSON;
           Result[ i]:= r;
           end;
     //    end
     //else
     //    begin
     //    Result:= Tblpage.Create(nil,nil,nil);
     //    Result.JSON:= sResult;
     //    end;
end; 
 
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

// T_wp_v2_pages_post Responses

// Réponse 200 OK

function T_wp_v2_pages_post.R_200( _i: Integer=0): Tblpage;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tblpage;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tblpage.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsString;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tblpage.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
end; 
 
 

end.

