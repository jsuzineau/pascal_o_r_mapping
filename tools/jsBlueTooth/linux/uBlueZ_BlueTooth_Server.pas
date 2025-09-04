unit uBlueZ_BlueTooth_Server;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, unixtype, sockets, bluetooth,baseunix;

const
  DEFAULT_BT_PORT = 1; // Can be adjusted or parameterized

type

  { TBluetooth_Server }

  TBluetooth_Server
  =
   class
   //Gestion du cycle de vie
   public
     constructor Create;
     destructor Destroy; override;
   //méthodes
   private
     FSocket: cint;
     FClientSocket: cint;
     FIsInitialized: Boolean;
     FIsListening: Boolean;
   public
     sError: String;
     function Initialize: Boolean;
     function Listen: Boolean;
     function GetServerAddress: string;
     function RegisterService(const AServiceName: string): Boolean;
     function Write(const Msg: string): Integer;
     procedure Disconnect;

     property IsInitialized: Boolean read FIsInitialized;
     property IsListening: Boolean read FIsListening;
   end;

implementation

const
     BDADDR_ANY: bdaddr_t = (b:(0, 0, 0, 0, 0, 0));

procedure bacpy(var dest: bdaddr_t; const src: Pbdaddr_t);
begin
  Move(src^, dest, SizeOf(bdaddr_t));
end;

function htobs(val: Word): Word;
begin
  Result:= ((val shr 8) and $FF) or ((val and $FF) shl 8);
end;

{ TBluetooth_Server }

constructor TBluetooth_Server.Create;
begin
     inherited Create;
     FSocket:= -1;
     FClientSocket:= -1;
     FIsInitialized:= False;
     FIsListening:= False;
end;

destructor TBluetooth_Server.Destroy;
begin
     Disconnect;
     inherited Destroy;
end;

function TBluetooth_Server.Initialize: Boolean;
var
   Addr: sockaddr_l2;
begin
     Result:= False;

     sError:= 'Echec de fpSocket';
     FSocket:= fpSocket(AF_BLUETOOTH, SOCK_STREAM, BTPROTO_RFCOMM);
     if FSocket < 0 then Exit;

     FillByte(Addr, SizeOf(Addr), 0);
     Addr.l2_family:= AF_BLUETOOTH;
     bacpy(Addr.l2_bdaddr, @BDADDR_ANY);
     Addr.l2_psm:= htobs(DEFAULT_BT_PORT);

     sError:= 'Echec de fpBind';
     if fpBind(FSocket, @Addr, SizeOf(Addr)) < 0
     then
         begin
         fpClose(FSocket);
         FSocket:= -1;
         Exit;
         end;

     FIsInitialized:= True;
     Result:= True;
end;

function TBluetooth_Server.Listen: Boolean;
begin
     Result:= False;
     if FSocket < 0 then Exit;

     sError:= 'Echec de fpListen';
     if fpListen(FSocket, 1) < 0 then Exit;

     FIsListening:= True;
     Result:= True;
end;

function TBluetooth_Server.GetServerAddress: string;
var
   Addr: sockaddr_l2;
   Len: socklen_t;
begin
     Result:= '';
     if FSocket < 0 then Exit;

     sError:= 'Echec de fpGetsockname';
     Len:= SizeOf(Addr);
     if fpGetsockname(FSocket, @Addr, @Len) < 0 then Exit;

     Result:= Format('Address: %2.2X:%2.2X:%2.2X:%2.2X:%2.2X:%2.2X  Port: %d',
       [Addr.l2_bdaddr.b[0], Addr.l2_bdaddr.b[1], Addr.l2_bdaddr.b[2],
        Addr.l2_bdaddr.b[3], Addr.l2_bdaddr.b[4], Addr.l2_bdaddr.b[5],
        htobs(Addr.l2_psm)]);
end;

function TBluetooth_Server.RegisterService(const AServiceName: string): Boolean;
begin
     // TODO: Implement proper SDP registration with BlueZ if required
     // This is a placeholder returning true for interface completeness
     Result:= True;
end;

function TBluetooth_Server.Write(const Msg: string): Integer;
var
  Buf: TBytes;
begin
     Result:= -1;
     if FClientSocket < 0 then Exit;

     Buf:= TEncoding.UTF8.GetBytes(Msg);
     Result:= fpsend(FClientSocket, @Buf[0], Length(Buf), 0);
end;

procedure TBluetooth_Server.Disconnect;
begin
     if FClientSocket >= 0
     then
         begin
         fpClose(FClientSocket);
         FClientSocket:= -1;
         end;

     if FSocket >= 0
     then
         begin
         fpClose(FSocket);
         FSocket:= -1;
         end;

     FIsInitialized:= False;
     FIsListening:= False;
end;

end.

