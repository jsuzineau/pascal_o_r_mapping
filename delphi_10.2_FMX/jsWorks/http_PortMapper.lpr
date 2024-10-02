program http_PortMapper;
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

uses
    {$ifdef unix}
      cthreads,
      cmem, // the c memory manager is on some systems much faster for multi-threading
    {$endif}
    uuStrings,
    uEXE_INI,
  Classes, blcksock, sockets, Synautil, SysUtils,fphttpclient,process;

{$ifdef windows}
{$apptype console}
{$endif}

const
     s_Validation         ='Validation';
     s_Validation_Response='pascal_o_r_mapping';

var
   Afficher_Log: Boolean= False;

function StrToK( Key: String; var S: String): String;
var
   I: Integer;
begin
     I:= Pos( Key, S);
     if I = 0
     then
         begin
         Result:= S;
         S:= '';
         end
     else
         begin
         Result:= Copy( S, 1, I-1);
         Delete( S, 1, (I-1)+Length( Key));
         end;
end;

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

function httpProgramme_Execute( _NomProgramme: String): String;
const Taille=1024;
var
   NomResultat: String;
   p: TProcess;
   procedure Result_from_NomResultat;
   var
      NbTests: Integer;
   begin
        NbTests:= 0;
        repeat
              Result:= String_from_File( NomResultat);
              if '' <> Result then break;
              Sleep( 1000);
        until NbTests > 5;
        Result:= Trim(Result);
   end;
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
     NomResultat:= ChangeFileExt( _NomProgramme, '_URL.txt');
     DeleteFile( NomResultat);
     p:= TProcess.Create( nil);
     try
        p.Executable:= _NomProgramme;
        p.Options := [poUsePipes];
        if Afficher_Log then WriteLn('httpProgramme_Execute: avant TProcess.execute sur '+_NomProgramme);
        p.Execute;
        if Afficher_Log then WriteLn('httpProgramme_Execute: aprés TProcess.execute');
        //Result_from_NomResultat;
        Result_from_stdout;

        if Afficher_Log then WriteLn('httpProgramme_Execute: Result= '+Result);
     finally
            FreeAndNil( p);
            end;
end;

procedure AttendConnection(ASocket: TTCPBlockSocket);
var
   timeout: integer;
   s: string;
   method, uri, protocol: string;

   sPort: String;
   nPort: Integer;

   Has_Body: Boolean;
   Content_Length: Integer;

   procedure Traite_Content_Length;
   const
        s_Content_Length='content-length:';
   begin
        s:= LowerCase( s);
        if 1 <> Pos(s_Content_Length, s) then exit;
        StrToK(s_Content_Length, s);
        Has_Body:= TryStrToInt( s, Content_Length);
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
   procedure Send_Validation;
   begin
        ASocket.SendString('HTTP/1.0 200' + CRLF);
        ASocket.SendString('Content-type: text/plain' + CRLF);
        ASocket.SendString('Content-length: ' + IntTostr(Length(s_Validation_Response)) + CRLF);
        ASocket.SendString('Connection: close' + CRLF);
        ASocket.SendString('Date: ' + Rfc822DateTime(now) + CRLF);
        ASocket.SendString('Server: http_PortMapper' + CRLF);
        ASocket.SendString('' + CRLF);

       //  if ASocket.lasterror <> 0 then HandleError;

        ASocket.SendString(s_Validation_Response);
   end;
   procedure Send_Forward;
   var
      Body: String;
      Forward_URL: String;
      Forward_Result      : String;
      Forward_Content_Type: String;
      Forward_Server      : String;
   begin
        if not http_Port_Valide( sPort)
        then
            begin
            Send_Not_found;
            exit;
            end;

        Forward_URL:= 'http://localhost:'+sPort+'/'+uri;

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
        ASocket.SendString('Server: '+Forward_Server + CRLF);
        ASocket.SendString('' + CRLF);
        ASocket.SendString(Forward_Result);
   end;
   function httpLauncher_: Boolean;
   var
      Key: String;
      NomProgramme: String;
   begin
        Result:= True;

        Key:= sPort; //pas propre, il faudrait renommer sPort
        NomProgramme:= EXE_INI.ReadString( 'httpLauncher', Key, '#');
        if Afficher_Log then WriteLn( 'httpLauncher_: NomProgramme('+Key+')='+NomProgramme);
        if '#' = NomProgramme            then exit;
        if not FileExists( NomProgramme) then exit;
        if Afficher_Log then WriteLn( 'httpLauncher_: OK');
        Send_Redirect( httpProgramme_Execute( NomProgramme));
        Result:= False;
   end;
begin
     timeout := 120000;

     if Afficher_Log then WriteLn('Received headers+document from browser:');

     //read request line
     s := ASocket.RecvString(timeout);
     if Afficher_Log then WriteLn(s);
     method := fetch(s, ' ');
     uri := fetch(s, ' ');
     protocol := fetch(s, ' ');

     Has_Body:= False;
     Content_Length:= 0;
     //read request headers
     repeat
           s:= ASocket.RecvString(Timeout);
           if Afficher_Log then WriteLn(s);
           Traite_Content_Length;
     until s = '';

     // Now write the document to the output stream
     StrTok( '/', uri);
     sPort:= StrTok( '/', uri);

          if TryStrToInt( sPort, nPort) then Send_Forward
     else if s_Validation = sPort       then Send_Validation
     else if httpLauncher_              then Send_Not_found;
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

     ListenerSocket  := TTCPBlockSocket.Create;

     ListenerSocket.CreateSocket;
     ListenerSocket.setLinger(true,10);
     ListenerSocket.bind('0.0.0.0','1500');
     ListenerSocket.listen;
     if Afficher_Log then WriteLn('http_PortMapper listen on ', ListenerSocket.GetLocalSinPort);

     repeat
           if not ListenerSocket.canread( 1000) then continue;

           TConnectionThread.Create( ListenerSocket.accept);
     until false;

     ListenerSocket.Free;
end.


