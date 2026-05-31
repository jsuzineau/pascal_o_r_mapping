unit uPascal_nom_app_API_Client;

{$mode Delphi}

interface

uses

 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type

    { TWordpress_verb }

    TWordpress_verb
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create( _Username, _Password: String);
       destructor Destroy; override;
     //identification
     public
       Username, Password: String;
       token: String;
     //url
     public
       url: String;
     //Verb
     public
       Verb: String;
     //Gestion des paramètres
     public
       procedure Parameter_Path ( _name: String; _Value: String);
       procedure Parameter_Query( _name: String; _Value: String);
     //Gestion des properties
     public
       Properties: TJSONObject;
       procedure Property_( _name: String; _Value: TJSONData);
     //http
     public
       http: THTTPSend;
       hc: TFPHTTPClient;
       function String_from_http: String;
     //Exécution
     public
       function Execute: String;
     end;

//Pascal_Paths_interface

implementation

{ TWordpress_verb }

constructor TWordpress_verb.Create( _Username, _Password: String);
begin
     url:= '';
     Verb:= '';
     Properties:= TJSONObject.Create;
     Username:= _Username;
     Password:= _Password;
     token:= EncodeStringBase64( Username+':'+_Password);
     http:= THTTPSend.Create;
     http.Headers.Add( 'Authorization: Basic '+token);
     http.Headers.Add( 'User-Agent: jsWordpress');

     hc:= TFPHTTPClient.Create(nil);
     hc  .AddHeader  ( 'Authorization','Basic '+token);
     hc  .AddHeader  ( 'User-Agent','jsWordpress');
end;

destructor TWordpress_verb.Destroy;
begin
     FreeAndNil( hc);
     FreeAndNil( http);
     inherited Destroy;
end;

procedure TWordpress_verb.Parameter_Path( _name: String; _Value: String);
begin
     url:= StringReplace( url, '{'+_name+'}', _Value, []);
end;

procedure TWordpress_verb.Parameter_Query( _name: String; _Value: String);
begin
     if 0 = Pos('?', url)
     then
         url:= url+ '?'
     else
         url:= url + '&';
     url:= url+_name+'='+_Value;
end;

procedure TWordpress_verb.Property_(_name: String; _Value: TJSONData);
begin
     Properties.Add( _name, _Value);
end;

function TWordpress_verb.String_from_http: String;
var
   ss: TStringStream;
begin
     ss:= TStringStream.Create('');
     try
        http.Document.SaveToStream( ss);
        Result:= ss.DataString;
     finally
            FreeAndNil( ss);
            end;
end;

{
function TWordpress_verb.Execute: String;
begin
     Verb:= Uppercase( Verb);

     http.Sock.SSL.VerifyCert:= False;
     WriteStrToStream( HTTP.Document, Properties.ToString);
     HTTP.MimeType := 'application/x-www-form-urlencoded';
     try
        if not http.HTTPMethod( Verb, URL)
        then
            Result:= 'Echec de '+URL+', '+Verb+':'#13#10+String_from_http
        else
            Result:= String_from_http;
     except
           on E: Exception
           do
             Result:= 'Echec de '+URL+', GET:'#13#10+E.Message;
           end;
end;
}
function TWordpress_verb.Execute: String;
var
   ss: TStringStream;
begin
     Verb:= Uppercase( Verb);

     hc.RequestBody:= TRawByteStringStream.Create(Properties.AsJSON);
     //hc.AddHeader  ( 'Content-type','application/x-www-form-urlencoded');
     hc.AddHeader  ( 'Content-type','application/json');
     try
        ss:= TStringStream.Create( '');
        try
           hc.HTTPMethod( Verb, URL, ss, []);
           Result:= ss.DataString;
        except
              on E: Exception
              do
                Result:= 'Echec de '+URL+', GET:'#13#10+E.Message;
              end;
     finally
            FreeAndNil( ss);
            end;
end;

//Pascal_Paths_implementation

end.

