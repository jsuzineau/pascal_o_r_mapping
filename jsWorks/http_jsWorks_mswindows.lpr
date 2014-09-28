program http_jsWorks_mswindows;
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

//{$mode objfpc}{$H+}

uses
  uBatpro_StringList,
  uuStrings,
  ublCategorie, ublDevelopment,
  ublProject, ublState, ublWork,
  uhfCategorie, uhfDevelopment,
  uhfJour_ferie, uhfProject, uhfState, uhfWork, upoolCategorie,
  upoolDevelopment, upoolProject, upoolState, upoolWork, uPool,
  upoolG_BECP, uHTTP_Interface,
  Interfaces, // this includes the LCL widgetset
Classes, blcksock, sockets, Synautil,SysUtils;

{$ifdef fpc}
 {$mode delphi}
{$endif}

//{$apptype console}

{@@
 Attends a connection. Reads the headers and gives an
 appropriate response
}
procedure AttendConnection(ASocket: TTCPBlockSocket);
var
   timeout: integer;
   s: string;
   method, uri, protocol: string;
   OutputDataString: string;
   ResultCode: integer;
   function Prefixe( _Prefixe: String): Boolean;
   begin
        Result:= 1=Pos( _Prefixe,uri);
        if not Result then exit;
        StrTok( _Prefixe, uri);
   end;
begin
     HTTP_Interface.S:= ASocket;

     timeout := 120000;

     //WriteLn('Received headers+document from browser:');

     //read request line
     s := ASocket.RecvString(timeout);
     //WriteLn(s);
     method := fetch(s, ' ');
     uri := fetch(s, ' ');
     protocol := fetch(s, ' ');

     //read request headers
     repeat
           s:= ASocket.RecvString(Timeout);
           //WriteLn(s);
     until s = '';

     // Now write the document to the output stream
     HTTP_Interface.Traite( uri);
end;

var
   ListenerSocket, ConnectionSocket: TTCPBlockSocket;
begin
     poolCategorie.ToutCharger;
     poolState    .ToutCharger;

     HTTP_Interface.Racine:= ExtractFilePath(ParamStr(0))+'..'+PathDelim+'www'+PathDelim+'index.html';
     HTTP_Interface.Register_pool( poolProject    );
     HTTP_Interface.Register_pool( poolWork       );
     HTTP_Interface.Register_pool( poolDevelopment);
     HTTP_Interface.Register_pool( poolCategorie  );
     HTTP_Interface.Register_pool( poolState      );

     ListenerSocket  := TTCPBlockSocket.Create;
     ConnectionSocket:= TTCPBlockSocket.Create;

     ListenerSocket.CreateSocket;
     ListenerSocket.setLinger(true,10);
     ListenerSocket.bind('0.0.0.0','1500');
     ListenerSocket.listen;

     repeat
           if not ListenerSocket.canread( 1000) then continue;

           ConnectionSocket.Socket := ListenerSocket.accept;
           //WriteLn('Attending Connection. Error code (0=Success): ', ConnectionSocket.lasterror);
           AttendConnection(ConnectionSocket);
           ConnectionSocket.CloseSocket;
     until false;

     ListenerSocket.Free;
     ConnectionSocket.Free;
end.
