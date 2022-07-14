unit uTradingView;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2022 Jean SUZINEAU - MARS42                                       |
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
// Source: python-tradingview-ta
// https://python-tradingview-ta.readthedocs.io/en/latest/index.html

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

 { TTradingView }

 TTradingView
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //http
  private
    http:THTTPSend;
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
  //Indicators
  public
    function json_Indicators( _Screener: String; Symbol_Name, Indicator_Name: array of String): String;
    procedure Charge_Indicators( _slLoaded: TslJSON; _Screener: String; Symbol_Name, Indicator_Name: array of String);
  end;

implementation

{ TTradingView }

constructor TTradingView.Create;
begin
     http:= THTTPSend.Create;
     http.Sock.SSL.VerifyCert:= False;

     Streaming:= False;
     Root_URL:= 'https://scanner.tradingview.com/';
end;

destructor TTradingView.Destroy;
begin
     Free_nil( http);
     inherited Destroy;
end;

procedure TTradingView.Header_Clear;
begin
     http.Headers.Clear;
end;

procedure TTradingView.Header_user_agent;
begin
     http.Headers.Add( 'User-Agent: tradingview_ta/3.2.10');
end;

procedure TTradingView.Header_accept_json;
begin
     //http.Headers.Add( 'Accept: application/json; charset=UTF-8');
     http.Headers.Add( 'Accept: application/json');
end;

procedure TTradingView.Header_content_type_json;
begin
     http.Headers.Add( 'Content-type: application/json');
end;

function TTradingView.String_from_http: String;
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

procedure TTradingView.Header_Streaming;
begin
     if not Streaming then exit;
     http.Headers.Add( 'X-Stream: true');
end;

function TTradingView.GET(_NomFonction, _URL: String): String;
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

function TTradingView.POST(_NomFonction, _URL: String; _Request_Body: String= ''): String;
var
   ss: TStringStream;
begin
     Header_Clear;
     Header_user_agent;
     //Header_accept_json;
     //Header_Streaming;
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

function TTradingView.json_Indicators( _Screener: String; Symbol_Name, Indicator_Name: array of String): String;
var
   Request_Body: String;
begin
     Request_Body:= '{"symbols": {"tickers": ["HITBTC:CSOVUSD"], "query": {"types": []}}, "columns": ["open|1", "close|1", "change|1", "low|1", "high|1"]}';
     Result:= POST( 'Indicators', Root_URL+_Screener+'/scan',Request_Body);
end;

procedure TTradingView.Charge_Indicators( _slLoaded: TslJSON;
                                          _Screener: String;
                                          Symbol_Name, Indicator_Name: array of String);
var
   json: String;
begin
     json:= json_Indicators( _Screener, Symbol_Name, Indicator_Name);

     poolJSON.Charge_from_JSON( json, _slLoaded);
end;

end.

