unit uAPI_Client;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2023 Jean SUZINEAU - MARS42                                       |
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
    uDataUtilsU,
    uLog,
    uuStrings,
 Classes, SysUtils,
 fphttpclient, opensslsockets,
 httpsend, ssl_openssl,
 fpjson, jsonparser,
 base64;

type
 TAPI_Client_log= procedure (_s: String) of object;
 { TAPI_Client }

 TAPI_Client
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //http
  private
    http:THTTPSend;
    hc: TFPHTTPClient;
    procedure Header_Clear;
    procedure Header_user_agent;
    procedure Header_accept_json;
    procedure Header_content_type_json;
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
  //log
  public
    on_log: TAPI_Client_log;
    log_on_file: Boolean;
    procedure Log( _S: String);
  //Attributs
  public
    procedure Initialise;virtual;
  end;


implementation

{ TAPI_Client }

constructor TAPI_Client.Create;
begin
     http:= THTTPSend.Create;
     http.Sock.SSL.VerifyCert:= False;

     hc:= TFPHTTPClient.Create(nil);

     Streaming:= False;
     Root_URL:= 'https://localhost/';
     on_log:= nil;
     log_on_file:= False;
end;

destructor TAPI_Client.Destroy;
begin
     Free_nil( http);
     inherited Destroy;
end;

procedure TAPI_Client.Header_Clear;
begin
     http.Headers.Clear;
     hc.RequestHeaders.Clear;
end;

procedure TAPI_Client.Header_user_agent;
begin
     //http.Headers.Add( 'User-Agent: API_Client_ta/3.2.10');
     //hc  .AddHeader  ( 'User-Agent','API_Client_ta/3.2.10');
end;

procedure TAPI_Client.Header_accept_json;
begin
     //http.Headers.Add( 'Accept: application/json');
     //hc  .AddHeader  ( 'Accept','application/json');
end;

procedure TAPI_Client.Header_content_type_json;
begin
     //http.Headers.Add( 'Content-type: application/json');
     //hc  .AddHeader  ( 'Content-type','application/json');
end;

function TAPI_Client.String_from_http: String;
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

procedure TAPI_Client.Header_Streaming;
begin
     if not Streaming then exit;
     //http.Headers.Add( 'X-Stream: true');
     //hc  .AddHeader  ('X-Stream','true');
end;

function TAPI_Client.GET(_NomFonction, _URL: String): String;
begin
     Header_Clear;
     Header_user_agent;
     //Header_accept_json;
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

function TAPI_Client.POST(_NomFonction, _URL: String; _Request_Body: String= ''): String;
   procedure Traite_Request_Body;
   var
      ss: TStringStream;
   begin
        try
           ss:= TStringStream.Create( _Request_Body);
           http.Document.LoadFromStream( ss);
           hc.RequestBody:= TRawByteStringStream.Create(_Request_Body);
        finally
               Free_nil( ss);
               end;
   end;
   procedure httpPOST;
   begin
        try
           if not http.HTTPMethod( 'POST', _URL)
           then
               Result:= 'Echec de '+_NomFonction+', POST'#13#10+String_from_http
           else
               Result:= String_from_http;
        except
              on E: Exception
              do
                Result:= 'Exception dans '+_NomFonction+', POST:'#13#10+E.Message;
              end;
   end;
   procedure hcPOST;
   var
      ss: TStringStream;
   begin
        try
           ss:= TStringStream.Create( '');
           try
              hc.Post( _URL, ss);
              Result:= ss.DataString;
           except
                 on E: Exception
                 do
                   Result:= 'Exception dans '+_NomFonction+', POST:'#13#10+E.Message;
                 end;
        finally
               Free_nil( ss);
               end;
   end;
begin
     Log( ClassName+'.POST');
     Log( '_NomFonction='+_NomFonction);
     Log( '_URL='+_URL);
     Log( '_Request_Body:' );
     Log( _Request_Body );
     Log( '<end _Request_Body>' );

     Header_Clear;
     Header_user_agent;
     //Header_accept_json;
     //Header_Streaming;

     Traite_Request_Body;

     //httpPOST;
     hcPOST;
end;

procedure TAPI_Client.Log(_S: String);
begin
     if log_on_file
     then
         uLog.Log.Println( _S);

     if nil = @on_log then exit;

     on_log( _S);
end;

procedure TAPI_Client.Initialise;
begin
end;

end.

