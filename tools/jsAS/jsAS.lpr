program jsAS;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            http://www.mars42.com                                               |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
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
    along with this program.  If not, see <http://www.gnu.org/licenses/>. 1     |
                                                                                |
|                                                                               }

{Adapted from The Micro Pascal WebServer, http://wiki.freepascal.org/Networking }

{$mode objfpc}{$H+}
{$ifdef windows}
{$apptype console}
{$endif}

uses
    {$ifdef unix}
      cthreads,
      cmem, // the c memory manager is on some systems much faster for multi-threading
    {$endif}
    Interfaces,
    uLog,
    uEXE_INI,
    uuStrings,
    ublSession,
    upoolSession,
  Classes, blcksock, sockets, Synautil, SysUtils,fphttpclient,process, syncobjs;

var
   csDatabase: TCriticalSection= nil;

const
     s_Validation         ='Validation';
     s_Validation_Response='pascal_o_r_mapping';

var
   Afficher_Log: Boolean= False;

function http_getS( _URL: String): String;
var
   c: TFPHttpClient;
begin
     try
        c:= TFPHttpClient.Create( nil);
        try
           Result:= c.Get( _URL);
        finally
               FreeAndNil( c);
               end;
     except
           on E: Exception
           do
             begin
             Result:= '';
             if Afficher_Log then Writeln( 'http_getS( '+_URL+'): '+E.Message);
             end;
           end;

     if Afficher_Log
     then
         begin
         Writeln( 'http_getS( '+_URL+')= ');
         WriteLn('################');
         Writeln( Result);
         WriteLn('################')
         end;
end;

function http_get( _URL: String; out _Content_Type, _Server: String; _Body: String= ''): String;
var
   c: TFPHttpClient;
   procedure Parse_headers;
   var
      I: Integer;
      S: String;
      Key, Value: String;
   begin
        _Content_Type:= '';
        _Server      := '';
        for I:= 0 to c.ResponseHeaders.Count-1
        do
          begin
          S:= c.ResponseHeaders.Strings[I];
          Key:= StrToK(':', S); Key:= UpperCase( Key);
          Value:= S;
               if 'CONTENT-TYPE'= Key then _Content_Type:= Value
          else if 'SERVER'      = Key then _Server      := Value;
          end;
   end;
begin
     if Afficher_Log then Writeln( 'http_get( '+_URL+')= ');
     try
        c:= TFPHttpClient.Create( nil);
        try
           if '' = _Body
           then
               Result:= c.Get( _URL)
           else
               Result:= c.FormPost( _URL, _Body);
           Parse_headers;
           if Afficher_Log
           then
               begin
               WriteLn('####Headers#####');
               WriteLn(c.ResponseHeaders.Text);

               WriteLn('#########');
               WriteLn('_Content_Type='+_Content_Type);
               WriteLn('_Server='      +_Server      );
               end;
        finally
               FreeAndNil( c);
               end;
     except
           on E: Exception
           do
             begin
             Result:= '';
             if Afficher_Log then Writeln( 'http_get( '+_URL+'): '+E.Message);
             end;
           end;

     if Afficher_Log
     then
         begin
         WriteLn('###Result#####');
         Writeln( Result);
         WriteLn('################');
         end;
end;

function http_Port_Valide( _Port: String): Boolean;
var
   URL: String;
begin
     URL:= 'http://localhost:'+_Port+'/'+s_Validation;
     Result:= s_Validation_Response = http_getS( URL);
end;

function httpProgramme_Execute( _NomProgramme: String; _blSession: TblSession): String;
const Taille=1024;
var
   p: TProcess;
   procedure Result_from_stdout;
   var
      Read_Length: Integer;
   begin
        SetLength( Result, Taille);
        Read_Length:= p.Output.Read( Result[1], Taille);
        SetLength( Result, Read_Length);
        Result:= Trim(Result);
   end;
begin
     p:= TProcess.Create( nil);
     try
        p.Executable:= _NomProgramme;
        p.Options := [poUsePipes];
        p.Parameters.Add(_blSession.cookie_id);
        if Afficher_Log then WriteLn('httpProgramme_Execute: avant TProcess.execute sur '+_NomProgramme);
        p.Execute;
        if Afficher_Log then WriteLn('httpProgramme_Execute: aprés TProcess.execute');
        Result_from_stdout;

        if Afficher_Log then WriteLn('httpProgramme_Execute: Result= '+Result);
     finally
            FreeAndNil( p);
            end;
end;

procedure AttendConnection(ASocket: TTCPBlockSocket);
const
     s_cookie_id='cookie_id';
var
   timeout: integer;
   s: string;
   method, uri, protocol: string;

   ApplicationKey: String;

   Has_Body: Boolean;
   Content_Length: Integer;

   slCookies: TStringList;
   cookie_id: String;
   blSession: TblSession;

   Referer: String;

   function notMatch_header_name( _header_name: String): Boolean;
   var
      len: Integer;
      sc: String;
   begin
        len:= Length( _header_name);
        sc:= LowerCase( Copy(s, 1, len));
        Result:= _header_name <> sc;
        if Result then exit;
        Delete( s, 1, len);
   end;
   function notTraite_Content_Length: Boolean;
   const
        s_Content_Length='content-length:';
   begin
        Result:= notMatch_header_name( s_Content_Length);
        if Result then exit;
        Has_Body:= TryStrToInt( s, Content_Length);
   end;
   function notTraite_Cookie: Boolean;
   const
        s_Cookie='cookie:';
        procedure Traite_cookie( _cookie: String);
        var
           cookie_Name : String;
           cookie_Value: String;
        begin
             cookie_Name := StrTok( '=', _cookie);
             cookie_Value:= _cookie;
             if s_cookie_id = cookie_Name
             then
                 cookie_id:= cookie_Value;

             slCookies.Values[cookie_Name]:= cookie_Value;
        end;
   begin
        Result:= notMatch_header_name( s_Cookie);
        if Result then exit;

        Log.Print( uri);
        Log.Print( s);
        StrToK(s_Cookie, s);
        while s <> ''
        do
          Traite_cookie( TrimLeft(StrTok( ';', s)));
   end;
   function notTraite_Referer: Boolean;
   const
        s_Referer='referer:';
   begin
        Result:= notMatch_header_name( s_Referer);
        if Result then exit;

        Referer:= TrimLeft( s);
   end;
   procedure Send_Not_found;
   begin
        ASocket.SendString('HTTP/1.0 404' + CRLF);
   end;
   procedure Send_Redirect( _URL: String);
   begin
        ASocket.SendString('HTTP/1.1 303 See Other' + CRLF);
        ASocket.SendString('Location: '+ _URL+ CRLF);
   end;
   function Traite_Validation: Boolean;
   begin
        Result:= s_Validation = ApplicationKey;
        if not Result then exit;

        ASocket.SendString('HTTP/1.0 200' + CRLF);
        ASocket.SendString('Content-type: text/plain' + CRLF);
        ASocket.SendString('Content-length: ' + IntTostr(Length(s_Validation_Response)) + CRLF);
        ASocket.SendString('Connection: close' + CRLF);
        ASocket.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
        ASocket.SendString('Server: jsAS' + CRLF);
        ASocket.SendString('' + CRLF);

       //  if ASocket.lasterror <> 0 then HandleError;

        ASocket.SendString(s_Validation_Response);
   end;
   procedure Send_Forward;
   var
      Forward_URL: String;
      Body: String;
      Forward_Result      : String;
      Forward_Content_Type: String;
      Forward_Server      : String;
   begin
        Forward_URL:= blSession.URL_interne+uri;

        if Has_Body
        then
            Body:= ASocket.RecvBufferStr( Content_Length, timeout)
        else
            Body:= '';

        Forward_Result:= http_get( Forward_URL, Forward_Content_Type, Forward_Server, Body);

        ASocket.SendString('HTTP/1.0 200' + CRLF);
        ASocket.SendString('Content-type: '+Forward_Content_Type + CRLF);
        ASocket.SendString('Content-length: ' + IntTostr(Length(Forward_Result)) + CRLF);
        ASocket.SendString('Connection: close' + CRLF);
        ASocket.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
        ASocket.SendString('Access-Control-Allow-Origin: http://localhost:1500/'+ApplicationKey + CRLF);
        ASocket.SendString('Access-Control-Allow-Credentials: true' + CRLF);
        //Set-Cookie: id=a3fWa; Expires=Wed, 21 Oct 2015 07:28:00 GMT; Secure; HttpOnly
        ASocket.SendString('Set-Cookie: ' + s_cookie_id+'='+blSession.cookie_id+'; SameSite=None'{+'; HttpOnly'} + CRLF);
        ASocket.SendString('Server: '+Forward_Server + CRLF);
        Log.Print( 'SendForward, Server: '+Forward_Server);
        ASocket.SendString('' + CRLF);
        {
        if '' = uri
        then
            Forward_Result:= StringReplace( Forward_Result, '<base href="/">', '<base href="/'+blSession.cookie_id+'/">', [rfReplaceAll]);
        }
        ASocket.SendString(Forward_Result);
   end;
   procedure poolSession_Assure;
   begin
        csDatabase.Acquire;
        try
           blSession:= poolSession.Assure( cookie_id);
        finally
               csDatabase.Release;
               end;
   end;
   procedure poolSession_Get_by_Cle( _cookie_id: String);
   begin
        csDatabase.Acquire;
        try
           blSession:= poolSession.Get_by_Cle( _cookie_id);
        finally
               csDatabase.Release;
               end;
   end;
   procedure blSession_Save;
   begin
        csDatabase.Acquire;
        try
           blSession.Save_to_database;
        finally
               csDatabase.Release;
               end;
   end;
   procedure Instantiate_Application;
   var
      NomProgramme: String;
      procedure Cree_cookie_id;
      //inspired from function TCustomSession.GetSessionID: String;
      //in unit HTTPDefs,
      //lazarus\fpc\3.2.2\source\packages\fcl-web\src\base\httpdefs.pp
      var
         guid: TGUID;
      begin
           CreateGUID( guid);
           cookie_id:= GUIDToString( guid);
           cookie_id:= Copy(cookie_id, 2, 36);
      end;
   begin
        NomProgramme:= EXE_INI.ReadString( 'Application', ApplicationKey, '#');
        if Afficher_Log then WriteLn( 'Instantiate_Application: NomProgramme('+ApplicationKey+')='+NomProgramme);
        if '#' = NomProgramme            then begin Send_Not_found; exit;end;
        if not FileExists( NomProgramme) then begin Send_Not_found; exit;end;
        if Afficher_Log then WriteLn( 'Instantiate_Application: OK');

        Cree_cookie_id;
        poolSession_Assure;
        blSession.ApplicationKey:= ApplicationKey;
        blSession.Port:= httpProgramme_Execute( NomProgramme, blSession);
        blSession_Save;

        //Send_Redirect( blSession.URL_externe);
        Send_Forward;
   end;
   function Session_found: Boolean;
   begin
        poolSession_Get_by_Cle( ApplicationKey);
        Result:= Assigned( blSession);
        if Result then exit;

        poolSession_Get_by_Cle( cookie_id);
        Result:= Assigned( blSession);

        // http://localhost:1500/34683931-C7E6-494C-96EA-0447392D5570/
        StrToK( 'http://localhost:1500/', Referer);
        poolSession_Get_by_Cle( StrToK( '/', Referer));
        Result:= Assigned( blSession);
   end;
begin
     cookie_id:= '';
     Referer:= '';
     blSession:= nil;

     slCookies:= TStringList.Create;
     try
        timeout := 120000;

        if Afficher_Log then WriteLn('Received headers+document from browser:');

        //read request line
        s := ASocket.RecvString(timeout);
        if Afficher_Log then WriteLn(s);
        method  := fetch( s, ' ');
        uri     := fetch( s, ' ');
        protocol:= fetch( s, ' ');

        Has_Body:= False;
        Content_Length:= 0;
        //read request headers
        repeat
              s:= ASocket.RecvString(Timeout);
              if '' = s then break;

              if Afficher_Log then WriteLn(s);
                   if notTraite_Content_Length
              then if notTraite_Cookie
              then if notTraite_Referer
              then begin end;
        until false;

        // Now write the document to the output stream
                         StrTok( '/', uri);
        ApplicationKey:= StrTok( '/', uri);
        Log.Print( 'traite uri '+uri);

        if Traite_Validation then exit;

        if Session_found
        then
            Send_Forward
        else
            Instantiate_Application;
            //Send_Not_found;

     finally
            FreeAndNil( slCookies);
            end;
end;

procedure Traite_Socket( _Socket: Tsocket);
var
   ConnectionSocket: TTCPBlockSocket;
begin
     ConnectionSocket:= TTCPBlockSocket.Create;
     try
        ConnectionSocket.Socket:= _Socket;
        if Afficher_Log then WriteLn('Attending Connection. Error code (0=Success): ', ConnectionSocket.lasterror);
        AttendConnection(ConnectionSocket);
        ConnectionSocket.CloseSocket;
     finally
            ConnectionSocket.Free;
            end;
end;

type

 { TConnectionThread }

 TConnectionThread
 =
  class( TThread)
  //Gestion du cycle de vie
  public
    constructor Create( _Socket: Tsocket);
  //Attributs
  public
    Socket: Tsocket;
  //Méthodes surchargées
  protected
    procedure Execute; override;
  end;

{ TConnectionThread }

constructor TConnectionThread.Create( _Socket: Tsocket);
begin
     Socket:= _Socket;
     FreeOnTerminate := True;
     inherited Create( False);
end;

procedure TConnectionThread.Execute;
begin
     Traite_Socket( Socket);
end;

var
   ListenerSocket: TTCPBlockSocket;

begin
     if ParamCount > 0
     then
         begin
         if '--help' = ParamStr(1)
         then
             begin
             WriteLn( 'Paramètres:');
             WriteLn( '  --help  aide ');
             WriteLn( '  -v  affichage du log');
             Halt;
             end
         else if '-v' = ParamStr(1)
         then
             Afficher_Log:= True;
         end;

     csDatabase:= TCriticalSection.Create;

     ListenerSocket:= TTCPBlockSocket.Create;
     try
        ListenerSocket.CreateSocket;
        ListenerSocket.setLinger(true,10);
        ListenerSocket.bind('0.0.0.0','1500');
        ListenerSocket.listen;
        if Afficher_Log then WriteLn('jsAS listen on ', ListenerSocket.GetLocalSinPort);

        repeat
              if not ListenerSocket.canread( 1000) then continue;

              TConnectionThread.Create( ListenerSocket.accept);
        until false;

     finally
            FreeAndNil( ListenerSocket);

            FreeAndNil( csDatabase    );
            end;
end.

