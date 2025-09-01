unit uWinSock2_BlueTooth_Client;

{$mode objfpc}{$H+}

interface

uses
    uWinUtils,
    uWinSock2_BlueTooth,
  Windows, SysUtils, Winsock2;

type
 TBluetooth_Client
 =
  class
  private
    FSocket: TSocket;
    FConnected: Boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function ConnectTo(Address: TSockAddr_BTH): Boolean;
    function WriteString(const Msg: string): Integer;
    function ReadString(var Msg: string; MaxLen: Integer = 1024): Integer;
    procedure Disconnect;
    property Connected: Boolean read FConnected;
  end;

implementation

constructor TBluetooth_Client.Create;
begin
     inherited;
     FSocket:= INVALID_SOCKET;
     FConnected:= False;
end;

destructor TBluetooth_Client.Destroy;
begin
     Disconnect;
     inherited;
end;

function TBluetooth_Client.ConnectTo(Address: TSockAddr_BTH): Boolean;
//var
   //remoteAddr: TSOCKADDR_BTH;
begin
     Result:= False;
     FConnected:= False;

     FSocket:= socket(AF_BTH, SOCK_STREAM, BTHPROTO_RFCOMM);
     if INVALID_SOCKET = FSocket then Exit;

     //ZeroMemory(@remoteAddr, SizeOf(remoteAddr));
     //remoteAddr.addressFamily:= AF_BTH;
     //remoteAddr.btAddr:= Address;
     //remoteAddr.port  := Channel_Port;
     //remoteAddr.serviceClassId:= ZeroGuid; // ou GUID_NULL, à définir selon besoin


     //if SOCKET_ERROR = connect(FSocket, @remoteAddr, SizeOf(remoteAddr))
     if SOCKET_ERROR = connect(FSocket, @Address, SizeOf(Address))
     then
         begin
         closesocket(FSocket);
         FSocket:= INVALID_SOCKET;
         Exit;
         end;

     FConnected:= True;
     Result:= True;
end;

function TBluetooth_Client.WriteString(const Msg: string): Integer;
var
   buf: RawByteString;
begin
     if not FConnected or (FSocket = INVALID_SOCKET) then Exit(-1);
     buf:= UTF8Encode(Msg);
     Result:= send(FSocket, PAnsiChar(buf)^, Length(buf), 0);
end;

function TBluetooth_Client.ReadString(var Msg: string; MaxLen: Integer): Integer;
var
   buf: array of Byte;
   bytesRead: Integer;
begin
     if not FConnected or (FSocket = INVALID_SOCKET) then Exit(-1);
     SetLength(buf, MaxLen);
     bytesRead:= recv(FSocket, PAnsiChar(@buf[0])^, MaxLen, 0);
     if bytesRead > 0
     then
         SetString(Msg, PAnsiChar(@buf[0]), bytesRead)
     else
         Msg:= '';
     Result:= bytesRead;
end;

procedure TBluetooth_Client.Disconnect;
begin
     if FSocket <> INVALID_SOCKET
     then
         begin
         closesocket(FSocket);
         FSocket:= INVALID_SOCKET;
         FConnected:= False;
         end;
end;

end.

