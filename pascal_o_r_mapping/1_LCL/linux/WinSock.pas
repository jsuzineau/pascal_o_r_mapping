unit WinSock;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.batpro.com                          |
    Contact: gilles.doutre@batpro.com                                           |
                                                                                |
    Copyright 2014 Jean SUZINEAU - MARS42                                       |
    Copyright 2014 Cabinet Gilles DOUTRE - BATPRO                               |
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

{$mode delphi}

interface

uses
  Classes, SysUtils, Sockets,NetDB;

type
 TInAddr= Sockets.TInAddr;
 PInAddr= Sockets.PInAddr;
 TWSAData
 =
  record
  end;
 THostEntry=NetDB.THostEntry;

function gethostname( _Buff: PChar; _Size: Integer): Integer;
function WSAGetLastError: DWORD;
procedure WSAStartup( _truc: integer; _LData: TWSAData);
function ResolveHostByName(HostName : String; Var H : THostEntry) : Boolean;

implementation

function gethostname( _Buff: PChar; _Size: Integer): Integer;
begin
     //Result:= OldLinux.GetHostName;
end;
function WSAGetLastError: DWORD;
begin

end;
procedure WSAStartup( _truc: integer; _LData: TWSAData);
begin

end;
function ResolveHostByName(HostName : String; Var H : THostEntry) : Boolean;
begin
     Result:= NetDB.ResolveHostByName( HostName, H);
end;
end.

