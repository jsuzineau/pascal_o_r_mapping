unit uTuleap;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2015 Jean SUZINEAU - MARS42                                       |
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

{$mode delphi}

interface

uses
    uClean,
    upoolJSON,
 Classes, SysUtils,
 //fphttpclient,
 httpsend,
 ssl_openssl,
 fpjson, jsonparser,
 base64;

type

 { TTULEAP_token }

 TTULEAP_token
 =
  object
    user_id: String;
    token  : String;
    uri    : String;
    procedure Clear;
  end;

 { TTULEAP }

 TTULEAP
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //http
  private
    http:THTTPSend;
    User, Password: String;
    procedure Header_Clear;
    procedure Header_accept_json;
    procedure Header_content_type_json;
    procedure Header_Authorization;
    function String_from_http: String;
  //Root_URL
  public
    Root_URL: String;
  //Streaming
  private
    procedure Header_Streaming;
  public
    Streaming: Boolean;
  //Get
  public
    function GET( _NomFonction, _URL: String): String;
  //POST
  public
    function POST( _NomFonction, _URL: String; _Request_Body: String= ''): String;
  //API Explorer
  public
    function API_Explorer_URL: String;
  //Token
  private
    token: TTULEAP_token;
    procedure Token_from_json( _json: String);
  public
    function Authenticate( _User, _Password: String): String;
  //Project List
  public
    function json_Projects: String;
    procedure Charge_Projects( _slLoaded: TslJSON);
  //Tracker List from Project
  public
    function json_Trackers( _Project_id: String): String;
    procedure Charge_Trackers( _Project_id: String; _slLoaded: TslJSON);
  end;

implementation

{ TTULEAP_token }

procedure TTULEAP_token.Clear;
begin
     user_id:= '';
     token  := '';
     uri    := '';
end;

{ TTULEAP }

constructor TTULEAP.Create;
begin
     http:= THTTPSend.Create;
     http.Sock.SSL.VerifyCert:= False;

     Streaming:= False;
     Root_URL:= 'https://192.168.1.35/';
     User:= '';
     Password:= '';
     token.Clear;
end;

destructor TTULEAP.Destroy;
begin
     Free_nil( http);
     inherited Destroy;
end;

procedure TTULEAP.Header_Clear;
begin
     http.Headers.Clear;
end;

procedure TTULEAP.Header_accept_json;
begin
     //http.Headers.Add( 'Accept: application/json; charset=UTF-8');
     http.Headers.Add( 'Accept: application/json');
end;

procedure TTULEAP.Header_content_type_json;
begin
     http.Headers.Add( 'Content-type: application/json');
end;

procedure TTULEAP.Header_Authorization;
var
   sUser_Password: String;
   sBase64: String;
begin
     sUser_Password:= User+':'+Password;
     sBase64:= EncodeStringBase64( sUser_Password);
     http.Headers.Add( '"Authorization": "Basic '+sBase64+'"');
end;

function TTULEAP.String_from_http: String;
var
   ss: TStringStream;
begin
     ss:= TStringStream.Create('');
     try
        http.Document.SaveToStream( ss);
        Result:= ss.DataString;
     finally
            Free_nil( ss);
            end;
end;

procedure TTULEAP.Header_Streaming;
begin
     if not Streaming then exit;
     http.Headers.Add( 'X-Stream: true');
end;

function TTULEAP.GET(_NomFonction, _URL: String): String;
begin
     Header_Clear;
     Header_accept_json;
     //Header_Authorization;
     //Header_Streaming;
     try
        if not http.HTTPMethod( 'GET', _URL)
        then
            Result:= 'Echec de '+_NomFonction+', GET:'#13#10+String_from_http
        else
            Result:= String_from_http;
     except
           on E: Exception
           do
             Result:= 'Echec de '+_NomFonction+', GET:'#13#10+E.Message;
           end;
end;

function TTULEAP.POST(_NomFonction, _URL: String; _Request_Body: String= ''): String;
var
   ss: TStringStream;
begin
     Header_Clear;
     Header_accept_json;
     Header_Authorization;
     Header_Streaming;
     try
        ss:= TStringStream.Create( _Request_Body);
        http.Document.LoadFromStream( ss);
     finally
            Free_nil( ss);
            end;
     try
        if not http.HTTPMethod( 'POST', _URL)
        then
            Result:= 'Echec de '+_NomFonction+', POST'#13#10+String_from_http
        else
            Result:= String_from_http;
     except
           on E: Exception
           do
             Result:= 'Echec de '+_NomFonction+', POST:'#13#10+E.Message;
           end;
end;

function TTULEAP.API_Explorer_URL: String;
begin
     Result:= Root_URL+'api/explorer/';
end;

procedure TTULEAP.Token_from_json( _json: String);
var
   jsp: TJSONParser;
   jso: TJSONObject;
begin
     jsp:= TJSONParser.Create( _json);
     jso:= jsp.Parse as TJSONObject;
     try
        token.user_id:= jso.Strings['user_id'];
        token.token  := jso.Strings['token'  ];
        token.uri    := jso.Strings['uri'    ];
     finally
            Free_nil( jsp);
            end;
end;

function TTULEAP.Authenticate( _User, _Password: String): String;
var
   ss: TStringStream;
   sToken: String;
begin
     User    := _User;
     Password:= _Password;
     Header_Clear;
     Header_content_type_json;
     try
        ss:= TStringStream.Create( '{"username":"'+User+'", "password":"'+Password+'"}');
        http.Document.LoadFromStream( ss);
     finally
            Free_nil( ss);
            end;
     try
        try
           if not http.HTTPMethod( 'POST', Root_URL+'api/tokens')
           then
               Result:= 'Echec de Authenticate, POST'#13#10+String_from_http
           else
               begin
               sToken:= String_from_http;
               Token_from_json( sToken);
               Result:= sToken;
               end;
        except
              on E: Exception
              do
                Result:= 'Echec de Authenticate, POST:'#13#10+E.Message;
              end;

     finally
            http.Document.Clear;
            end;
end;

function TTULEAP.json_Projects: String;
begin
     Result:= GET( 'Projects', Root_URL+'api/projects?limit=10');
end;

procedure TTULEAP.Charge_Projects(_slLoaded: TslJSON);
begin
     poolJSON.Charge_from_JSON( json_Projects, _slLoaded);
end;

function TTULEAP.json_Trackers(_Project_id: String): String;
begin
     Result:= GET( 'Trackers', Root_URL+'api/projects/'+_Project_id+'/trackers?limit=10');
end;

procedure TTULEAP.Charge_Trackers(_Project_id: String; _slLoaded: TslJSON);
begin
     poolJSON.Charge_from_JSON( json_Trackers( _Project_id), _slLoaded);
end;

end.

