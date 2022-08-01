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
    uLog,
    upoolJSON,
    uuStrings,
 Classes, SysUtils,
 fphttpclient,
 httpsend,
 ssl_openssl,
 fpjson, jsonparser,
 base64;

type
 TTradingView_Interval
 =
  (
  tvi_1_MINUTE  ,
  tvi_5_MINUTES ,
  tvi_15_MINUTES,
  tvi_30_MINUTES,
  tvi_1_HOUR    ,
  tvi_2_HOURS   ,
  tvi_4_HOURS   ,
  tvi_1_DAY     ,
  tvi_1_WEEK    ,
  tvi_1_MONTH
  );

 TTradingView_log= procedure (_s: String) of object;
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
    on_log: TTradingView_log;
    log_on_file: Boolean;
    procedure Log( _S: String);
  //Attributs
  public
    Screener: String;
    Symbol_Name, Indicator_Name: array of String;
    Interval: TTradingView_Interval;
    procedure Initialise( _Screener: String;
                          _Symbol_Name, _Indicator_Name: array of String;
                          _Interval: TTradingView_Interval
                          );
  //Indicators
  public
    function json_Indicators: String;
    procedure Charge_Indicators( _slLoaded: TslJSON);
  end;

const
     TradingView_Interval_Suffix: array[TTradingView_Interval] of String
     =
      (
      '|1'  , //"1m":   tvi_1_MINUTE
      '|5'  , //"5m":   tvi_5_MINUTES
      '|15' , //"15m":  tvi_15_MINUTES
      '|30' , //"30m":  tvi_30_MINUTES
      '|60' , //"1h":   tvi_1_HOUR
      '|120', //"2h":   tvi_2_HOURS
      '|240', //"4h":   tvi_4_HOURS
      ''    , //'1d'    tvi_1_DAY
      '|1W' , //"1W":   tvi_1_WEEK
      '|1M'   //"1M":   tvi_1_MONTH
      );


implementation

{ TTradingView }

constructor TTradingView.Create;
begin
     http:= THTTPSend.Create;
     http.Sock.SSL.VerifyCert:= False;

     hc:= TFPHTTPClient.Create(nil);

     Streaming:= False;
     Root_URL:= 'https://scanner.tradingview.com/';
     on_log:= nil;
     log_on_file:= False;
end;

destructor TTradingView.Destroy;
begin
     Free_nil( http);
     inherited Destroy;
end;

procedure TTradingView.Header_Clear;
begin
     http.Headers.Clear;
     hc.
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
        Log( ClassName+'.POST');
        Log( '_NomFonction='+_NomFonction);
        Log( '_URL='+_URL);
        Log( '_Request_Body:' );
        Log( _Request_Body );
        Log( '<end _Request_Body>' );
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
             Result:= 'Exception dans '+_NomFonction+', POST:'#13#10+E.Message;
           end;
end;

procedure TTradingView.Log(_S: String);
begin
     if log_on_file
     then
         uLog.Log.Println( _S);

     if nil = @on_log then exit;

     on_log( _S);
end;

procedure TTradingView.Initialise( _Screener: String;
                                   _Symbol_Name   ,
                                   _Indicator_Name: array of String;
                                   _Interval: TTradingView_Interval);
var
   I: Integer;
begin
     Screener      := _Screener      ;

     SetLength(Symbol_Name   , Length(_Symbol_Name   ));
     SetLength(Indicator_Name, Length(_Indicator_Name));

     for I:= Low(_Symbol_Name   ) to High(_Symbol_Name   ) do Symbol_Name   [I]:= _Symbol_Name   [I];
     for I:= Low(_Indicator_Name) to High(_Indicator_Name) do Indicator_Name[I]:= _Indicator_Name[I];
     Interval      := _Interval      ;
end;

function TTradingView.json_Indicators: String;
var
   tickers_list: String;
   columns_list: String;
   Request_Body: String;
   procedure Compose_tickers_list;
   var
      I: Integer;
   begin
        tickers_list:= '';
        for I:= Low(Symbol_Name) to High( Symbol_Name)
        do
          Formate_Liste( tickers_list, ',', '"'+Symbol_Name[I]+'"');
   end;
   procedure Compose_columns_list;
   var
      I: Integer;
      Interval_Suffix: String;
   begin
        Interval_Suffix:= TradingView_Interval_Suffix[ Interval];
        columns_list:= '';
        for I:= Low(Indicator_Name) to High( Indicator_Name)
        do
          Formate_Liste( columns_list, ',', '"'+Indicator_Name[I]+Interval_Suffix+'"');
   end;

begin
     Compose_tickers_list;
     Compose_columns_list;
     Request_Body
     :=
        '{"symbols": {"tickers": ['+tickers_list+'], "query": {"types": []}}, '
       + '"columns": ['+columns_list+']}';
     Result:= POST( 'Indicators', Root_URL+Screener+'/scan',Request_Body);
end;

procedure TTradingView.Charge_Indicators( _slLoaded: TslJSON);
var
   json: String;
begin
     json:= json_Indicators;

     poolJSON.Charge_from_JSON( json, _slLoaded);
end;

end.

