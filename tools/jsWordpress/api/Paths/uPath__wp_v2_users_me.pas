unit uPath__wp_v2_users_me;
//Chemin  Path./wp/v2/users/me
{$mode Delphi}

interface

uses
    uuStrings,
    uMimeType,
    uWordpress_verb,
    ubluser,

 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type
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
 
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tbluser;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tbluser;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tbluser;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tbluser;  
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
     //Responses
     public
       // Réponse 200 OK
       
        function R_200( _i: Integer=0): Tbluser;  
     end;

 

implementation

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

 

// T_wp_v2_users_me_get Responses

// Réponse 200 OK

function T_wp_v2_users_me_get.R_200( _i: Integer=0): Tbluser;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tbluser;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tbluser.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tbluser.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
end; 
 
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

// T_wp_v2_users_me_post Responses

// Réponse 200 OK

function T_wp_v2_users_me_post.R_200( _i: Integer=0): Tbluser;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tbluser;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tbluser.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tbluser.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_users_me_put Responses

// Réponse 200 OK

function T_wp_v2_users_me_put.R_200( _i: Integer=0): Tbluser;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tbluser;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tbluser.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tbluser.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_users_me_patch Responses

// Réponse 200 OK

function T_wp_v2_users_me_patch.R_200( _i: Integer=0): Tbluser;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tbluser;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tbluser.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tbluser.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
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

// T_wp_v2_users_me_delete Responses

// Réponse 200 OK

function T_wp_v2_users_me_delete.R_200( _i: Integer=0): Tbluser;
//var
//   i: Integer;
//   ja: TJSONArray;
//   r: Tbluser;
begin
     //if False
     //then
     //    begin
     //    ja:= jdResult as TJSONArray;
     //    SetLength( Result, ja.Count);
     //    for i:= 0 to ja.Count-1
     //    do
     //      begin
     //      r:= Tbluser.Create(nil,nil,nil);
     //      r.JSON:= ja.Items[i].AsJSON;
     //      Result[ i]:= r;
     //      end;
     //    end
     //else
     //    begin
         Result:= Tbluser.Create(nil,nil,nil);
         Result.JSON:= sResult;
     //    end;
end; 
 
 

end.

