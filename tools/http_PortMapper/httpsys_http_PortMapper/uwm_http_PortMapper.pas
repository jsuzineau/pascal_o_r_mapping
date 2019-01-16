unit uwm_http_PortMapper;

{$mode objfpc}{$H+}

interface

uses
    uEXE_INI,
  SysUtils, Classes, httpdefs, fpHTTP, fpWeb, webutil,fpHTTPSys;

type

 { Twm_http_PortMapper }

 Twm_http_PortMapper
 =
  class(TFPWebModule)
    procedure Request( _Sender: TObject; _Request: TRequest;
                       _Response: TResponse; var _Handled: Boolean);
  private
    procedure Request_Dump( _Sender: TObject; _Request: TRequest;
                            _Response: TResponse; var _Handled: Boolean);
  end;

var
  wm_http_PortMapper: Twm_http_PortMapper;

procedure Traite_URLs;

implementation

{$R *.lfm}

var
   suburl_pm: String;
   suburl_redirect: String;
procedure Traite_URLs;
   procedure Add( _suburl: String);
   begin
        if '' <> _suburl
        then
            Application.Urls.Add( 'http://+:80'+_suburl);
   end;
begin
     suburl_pm:= EXE_INI.Assure_String( 'suburl_pm', '/pm');
     suburl_redirect:= EXE_INI.Assure_String( 'suburl_redirect', '');
     Add( suburl_pm      );
     Add( suburl_redirect);
end;

{ Twm_http_PortMapper }

procedure Twm_http_PortMapper.Request_Dump( _Sender: TObject;
                                            _Request: TRequest;
                                            _Response: TResponse;
                                            var _Handled: Boolean);
var
   S: TStrings;
begin
     S:=TStringList.Create;
     try
        // Analyze request.
        DumpRequest( _Request, S);
        S.Insert(0, '_Request.URI:'+_Request.URI+'<br>');


        _Response.Contents:=S;
        _Handled:=True;
     finally
            S.Free;
            end;
end;

procedure Twm_http_PortMapper.Request( _Sender: TObject;
                                                 _Request: TRequest;
                                                 _Response: TResponse;
                                                 var _Handled: Boolean);
begin
     Request_Dump( _Sender, _Request, _Response, _Handled);
end;

initialization
              RegisterHTTPModule( 'TEchoModule', Twm_http_PortMapper);
end.

