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
  Classes, blcksock, sockets, Synautil, SysUtils,fphttpclient;

{$ifdef fpc}
 {$mode delphi}
{$endif}

{$apptype console}

const
     s_Validation         ='Validation';
     s_Validation_Response='pascal_o_r_mapping';

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
             Writeln( 'http_getS( '+_URL+'): '+E.Message);
             end;
           end;

     Writeln( 'http_getS( '+_URL+')= ');
     WriteLn('################');
     Writeln( Result);
     WriteLn('################')
end;

function http_get( _URL: String; out _Content_Type, _Server: String; _Body: String= ''): String;
var
   c: TFPHttpClient;
begin
     try
        c:= TFPHttpClient.Create( nil);
        try
           if '' = _Body
           then
               Result:= c.Get( _URL)
           else
               Result:= c.FormPost( _URL, _Body);
           _Content_Type:= c.ResponseHeaders.Values[ 'Content-type'];
           _Server      := c.ResponseHeaders.Values[ 'Server'      ];
        finally
               FreeAndNil( c);
               end;
     except
           on E: Exception
           do
             begin
             Result:= '';
             Writeln( 'http_get( '+_URL+'): '+E.Message);
             end;
           end;

     Writeln( 'http_get( '+_URL+')= ');
     WriteLn('################');
     Writeln( Result);
     WriteLn('################')
end;

function http_Port_Valide( _Port: String): Boolean;
var
   URL: String;
begin
     URL:= 'http://localhost:'+_Port+'/'+s_Validation;
     Result:= s_Validation_Response = http_getS( URL);
end;

procedure AttendConnection(ASocket: TTCPBlockSocket);
var
   timeout: integer;
   s: string;
   method, uri, protocol: string;
   OutputDataString: string;
   ResultCode: integer;

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
            Body:= ASocket.RecvBufferStr( Content_Length, timeout);

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
begin
     timeout := 120000;

     WriteLn('Received headers+document from browser:');

     //read request line
     s := ASocket.RecvString(timeout);
     WriteLn(s);
     method := fetch(s, ' ');
     uri := fetch(s, ' ');
     protocol := fetch(s, ' ');

     Has_Body:= False;
     Content_Length:= 0;
     //read request headers
     repeat
           s:= ASocket.RecvString(Timeout);
           WriteLn(s);
           Traite_Content_Length;
     until s = '';

     // Now write the document to the output stream
     StrTok( '/', uri);
     sPort:= StrTok( '/', uri);

          if TryStrToInt( sPort, nPort) then Send_Forward
     else if s_Validation = sPort       then Send_Validation
     else                                    Send_Not_found;
end;

var
   ListenerSocket, ConnectionSocket: TTCPBlockSocket;
begin
     ListenerSocket  := TTCPBlockSocket.Create;
     ConnectionSocket:= TTCPBlockSocket.Create;

     ListenerSocket.CreateSocket;
     ListenerSocket.setLinger(true,10);
     ListenerSocket.bind('0.0.0.0','1500');
     ListenerSocket.listen;
     WriteLn('http_PortMapper listen on ', ListenerSocket.GetLocalSinPort);

     repeat
           if not ListenerSocket.canread( 1000) then continue;

           ConnectionSocket.Socket := ListenerSocket.accept;
           WriteLn('Attending Connection. Error code (0=Success): ', ConnectionSocket.lasterror);
           AttendConnection(ConnectionSocket);
           ConnectionSocket.CloseSocket;
     until false;

     ListenerSocket.Free;
     ConnectionSocket.Free;
end.


