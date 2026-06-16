unit uWordpress_verb;

{$mode Delphi}

interface

uses
    uuStrings,
    uMimeType,
 Classes, SysUtils, fpjson, httpsend,base64,synautil,fphttpclient;

type
    TWordpress_verb_content_type= (ct_json, ct_multipart_form_data, ct_attachment);

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
     //Request Body
     public
       rbssRequestBody: TRawByteStringStream;
     //Content type
     public
       Content_type: TWordpress_verb_content_type;
     //multipart/form-data
     private
       multipart_form_data_boundary: String;
       procedure Write_Boundary;
       procedure Write_Boundary_Final;
       procedure Write_String( _s: RawByteString);
     public
       procedure Set_multipart_form_data;
       procedure Add_File( _NomFichier: String; _MimeType:String='');
       procedure Set_attachment;
     //Exécution
     public
       sResult: String;
       jdResult: TJSONData;
       function Execute: String;
     end;

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

     Content_type:= ct_json;
     rbssRequestBody:= TRawByteStringStream.Create('');
end;

destructor TWordpress_verb.Destroy;
begin
     FreeAndNil( rbssRequestBody);
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
     case Content_type
     of
       ct_json:
         Properties.Add( _name, _Value);
       ct_multipart_form_data:
         begin
         Write_Boundary;
         Write_String( 'Content-Disposition: form-data; name="'+_name+'"');
         Write_String( '');
         if    (jtObject = _Value.JSONType)
            or (jtArray = _Value.JSONType)
         then
             Write_String( _Value.AsJSON) //non testé
         else
             Write_String( _Value.AsString);
         end;
       ct_attachment: begin end;
       end;
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

procedure TWordpress_verb.Write_String(_s: RawByteString);
begin
     rbssRequestBody.WriteString( _s);
end;

procedure TWordpress_verb.Write_Boundary;
begin
     Write_String( '--'+multipart_form_data_boundary);
end;

procedure TWordpress_verb.Write_Boundary_Final;
begin
     Write_String( '--'+multipart_form_data_boundary+'--');
end;

procedure TWordpress_verb.Set_multipart_form_data;
begin
     Content_type:= ct_multipart_form_data;
     multipart_form_data_boundary:= 'abcd1234efgh5678';
end;

procedure TWordpress_verb.Set_attachment;
begin
     Content_type:= ct_attachment;
end;

procedure TWordpress_verb.Add_File( _NomFichier: String; _MimeType: String);
var
   Contenu_Fichier: String;
begin
     if '' = _MimeType then _MimeType:= MimeType_from_Extension( ExtractFileExt( _NomFichier));
     Contenu_Fichier:= String_from_File( _NomFichier);

     case Content_type
     of
       ct_multipart_form_data:
         begin
         Write_Boundary;
         //Write_String( 'Content-Disposition: form-data; name="file"; filename="'+_NomFichier+'"');
         Write_String( 'Content-Disposition: form-data; name="data"; filename="'+ExtractFileName(_NomFichier)+'"');
         Write_String( 'Content-Type: '+_MimeType);
         Write_String( '');
         Write_String( Contenu_Fichier);
         end;
       ct_attachment:
         begin
         hc.AddHeader( 'Content-Disposition', 'attachment; filename="'+ExtractFileName(_NomFichier)+'"');
         hc.AddHeader( 'Content-Type'       , _MimeType                                );
         Write_String( Contenu_Fichier);
         end;
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

     case Content_type
     of
       ct_json:
         begin
           Write_String( Properties.AsJSON);
           //hc.AddHeader( 'Content-type','application/x-www-form-urlencoded');
           hc.AddHeader( 'Content-type','application/json');
         end;
       ct_multipart_form_data:
         begin
         Write_Boundary_Final;
         hc.AddHeader('Content-type', 'multipart/form-data; boundary='+multipart_form_data_boundary);
         hc.AddHeader('Content-Length', IntToStr(rbssRequestBody.Size));
         end;
       ct_attachment:
         begin
         end
       end;

     rbssRequestBody.Position:= 0;
     hc.RequestBody:= rbssRequestBody;
     try
        ss:= TStringStream.Create( '');
        try
           hc.HTTPMethod( Verb, URL, ss, []);
           sResult:= ss.DataString;
           jdResult:= GetJSON( sResult);
           Result:= sResult;
        except
              on E: Exception
              do
                Result:= 'Echec de '+URL+', GET:'#13#10+E.Message;
              end;
     finally
            FreeAndNil( ss);
            end;
end;

end.

