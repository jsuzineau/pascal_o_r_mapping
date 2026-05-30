unit uPascal_nom_app_API_Client;

{$mode Delphi}

interface

uses

 Classes, SysUtils, fpjson, httpsend;

type

    { TWordpress_verb }

    TWordpress_verb
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create;
       destructor Destroy; override;
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
     //Exécution
     public
       function Execute: String;
     end;

//Pascal_Paths_interface

implementation

{ TWordpress_verb }

constructor TWordpress_verb.Create;
begin
     url:= '';
     Verb:= '';
     Properties:= TJSONObject.Create;
end;

destructor TWordpress_verb.Destroy;
begin
 inherited Destroy;
end;

procedure TWordpress_verb.Parameter_Path( _name: String; _Value: String);
begin
     url:= StringReplace( url, '{'+_name+'}', _Value, []);
end;

procedure TWordpress_verb.Parameter_Query( _name: String; _Value: String);
begin
     if -1 = Pos('?', url)
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

function TWordpress_verb.Execute: String;
var
   http: THTTPSend;
begin
     Verb:= Uppercase( Verb);
     http:= THTTPSend.Create;
     try
        http.Sock.SSL.VerifyCert:= False;
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
     finally
            FreeAndNil( http);
            end;

end;

//Pascal_Paths_implementation

end.

