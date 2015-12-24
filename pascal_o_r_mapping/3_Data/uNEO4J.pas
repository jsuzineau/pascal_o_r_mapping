unit uNEO4J;
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
 Classes, SysUtils, fphttpclient, base64;

type

 { TNEO4J }

 TNEO4J
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //http
  private
    http: TFPHTTPClient;
    User, Password: String;
    procedure Header_Clear;
    procedure Header_accept_json;
    procedure Header_Authorization;
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
  //Authentification
  public
    function Authenticate( _User, _Password: String): String;
  //Service Root
  public
    function ServiceRoot: String;
  //Property Keys
  public
    function Property_Keys: String;
  //Create node
  public
    function Create_node( _Request_Body: String= ''): String;
  //Get node by id
  public
    function Get_node( _id: Integer): String;
    function Node_from_id( _id: Integer): TblJSON;
  end;

implementation

{ TNEO4J }

constructor TNEO4J.Create;
begin
     http:= TFPHTTPClient.Create( nil);
     Streaming:= False;
end;

destructor TNEO4J.Destroy;
begin
     Free_nil( http);
     inherited Destroy;
end;

procedure TNEO4J.Header_Clear;
begin
     http.RequestHeaders.Clear;
end;

procedure TNEO4J.Header_accept_json;
begin
     http.AddHeader( 'Accept', 'application/json; charset=UTF-8');
end;

procedure TNEO4J.Header_Authorization;
var
   sUser_Password: String;
   sBase64: String;
begin
     sUser_Password:= User+':'+Password;
     sBase64:= EncodeStringBase64( sUser_Password);
     http.AddHeader( 'Authorization', 'Basic '+sBase64);
end;

procedure TNEO4J.Header_Streaming;
begin
     if not Streaming then exit;
     http.AddHeader( 'X-Stream', 'true');
end;

function TNEO4J.GET(_NomFonction, _URL: String): String;
begin
     Header_Clear;
     Header_accept_json;
     Header_Authorization;
     Header_Streaming;
     try
        Result:= http.Get( _URL);
     except
           on E: Exception
           do
             Result:= 'Echec de '+_NomFonction+', GET:'#13#10+E.Message;
           end;
end;

function TNEO4J.POST(_NomFonction, _URL: String; _Request_Body: String= ''): String;
var
   ss: TStringStream;
begin
     Header_Clear;
     Header_accept_json;
     Header_Authorization;
     Header_Streaming;
     ss:= TStringStream.Create( _Request_Body);
     try
        http.RequestBody:= ss;
        try
           Result:= http.Post( _URL);
        except
              on E: Exception
              do
                Result:= 'Echec de '+_NomFonction+', POST:'#13#10+E.Message;
              end;
     finally
            http.RequestBody:= nil;
            Free_nil( ss);
            end;
end;

function TNEO4J.Authenticate( _User, _Password: String): String;
begin
     User    := _User;
     Password:= _Password;
     Result:= GET( 'Authenticate', 'http://localhost:7474/user/'+User);
end;

function TNEO4J.ServiceRoot: String;
begin
     Result:= GET( 'ServiceRoot', 'http://localhost:7474/db/data/');
end;

function TNEO4J.Property_Keys: String;
begin
     Result:= GET( 'Property_Keys', 'http://localhost:7474/db/data/propertykeys');
end;

function TNEO4J.Create_node( _Request_Body: String= ''): String;
begin
     Result:= POST( 'Create_node', 'http://localhost:7474/db/data/node', _Request_Body);
end;

function TNEO4J.Get_node(_id: Integer): String;
begin
     Result:= GET( 'Get_node', 'http://localhost:7474/db/data/node/'+IntToStr(_id));
end;

function TNEO4J.Node_from_id(_id: Integer): TblJSON;
begin
     Result:= poolJSON.Get_from_JSON( Get_node( _id));
end;

end.

