unit uTULEAP;
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
    ublJSON,
    upoolJSON,
 Classes, SysUtils,
 //fphttpclient,
 httpsend,
 base64;

type

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
    Root_URL: String;
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
  //API Explorer
  public
    function API_Explorer_URL: String;
  //Project List
  public
    function json_Projects: String;
    procedure Charge_Projects( _slLoaded: TslJSON);
  end;

implementation

{ TTULEAP }

constructor TTULEAP.Create;
begin
     http:= THTTPSend.Create;

     Streaming:= False;
     Root_URL:= 'https://192.168.1.35/'
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
     http.Headers.Add( '"Accept": "application/json; charset=UTF-8"');
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

procedure TTULEAP.Header_Streaming;
begin
     if not Streaming then exit;
     http.Headers.Add( '"X-Stream": "true"');
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
            Result:= 'Echec de '+_NomFonction+', GET:'#13#10+http.Document.ToString
        else
            Result:= http.Document.ToString;
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
            Result:= 'Echec de '+_NomFonction+', POST'
        else
            Result:= http.Document.ToString;
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

function TTULEAP.json_Projects: String;
begin
     Result:= GET( 'Projects', Root_URL+'api/projects?limit=10');
end;

procedure TTULEAP.Charge_Projects(_slLoaded: TslJSON);
begin
     poolJSON.Charge_from_JSON( json_Projects, _slLoaded);
end;

end.

