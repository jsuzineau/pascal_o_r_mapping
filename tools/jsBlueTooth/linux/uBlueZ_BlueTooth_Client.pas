unit uBlueZ_BlueTooth_Client;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, bluetooth, Sockets,unixtype;

type
  TBluetooth_Client
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //méthodes
   private
     FSocket: cint; // socket file descriptor sous Linux
     FConnected: Boolean;
   public
     sError: String;
     function ConnectTo(const Address: string; Channel: Byte): Boolean;
     function WriteString(const Msg: string): Integer;
     function ReadString(var Msg: string; MaxLen: Integer = 1024): Integer;
     procedure Disconnect;

     property Connected: Boolean read FConnected;
   end;

implementation

uses
    BaseUnix;

constructor TBluetooth_Client.Create;
begin
    inherited Create;
    FSocket := -1;
    FConnected := False;
end;

destructor TBluetooth_Client.Destroy;
begin
     Disconnect;
     inherited Destroy;
end;

function TBluetooth_Client.ConnectTo(const Address: string; Channel: Byte): Boolean;
var
   SockAddr: sockaddr_rc;
   bdaddr: bdaddr_t;
begin
     Result := False;
     FConnected := False;

     if str2ba(PCChar(PAnsiChar(AnsiString(Address))), @bdaddr) <> 0 then Exit;

     sError:= 'Echec de fpSocket';
     FSocket := fpSocket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
     if FSocket < 0 then Exit;

     FillChar(SockAddr, SizeOf(SockAddr), 0);
     SockAddr.rc_family := AF_BLUETOOTH;
     SockAddr.rc_channel := Channel;
     Move(bdaddr, SockAddr.rc_bdaddr, SizeOf(bdaddr_t));

     sError:= 'Echec de fpConnect';
     if fpConnect(FSocket, @SockAddr, SizeOf(SockAddr)) <> 0
     then
         begin
         fpClose(FSocket);
         FSocket := -1;
         Exit;
         end;

     FConnected := True;
     Result := True;
end;

function TBluetooth_Client.WriteString(const Msg : string) : integer;
var
   Buffer: ansistring;
begin
     if not FConnected then Exit(-1);

     Buffer := ansistring(Msg);
     Result := fpSend(FSocket, @Buffer[1], Length(Buffer), 0);
end;

function TBluetooth_Client.ReadString(var Msg: string; MaxLen: Integer): Integer;
var
   Buffer: array of Byte;
   BytesRead: Integer;
begin
     if not FConnected then Exit(-1);

     SetLength(Buffer, MaxLen);
     BytesRead := fpRecv(FSocket, @Buffer[0], MaxLen, 0);

     if BytesRead > 0
     then
         Msg := TEncoding.UTF8.GetString(Buffer, 0, BytesRead)
     else
         Msg := '';

     Result := BytesRead;
end;

procedure TBluetooth_Client.Disconnect;
begin
     if FConnected and (FSocket >= 0)
     then
         begin
         fpClose(FSocket);
         FSocket := -1;
         FConnected := False;
         end;
end;

end.

