unit uWinSock2_BlueTooth_Server;

{$mode ObjFPC}{$H+}

interface

uses
    uWinSock2_BlueTooth,
 Classes, SysUtils, Windows, WinSock2;

type

  { TBluetooth_Server }

  TBluetooth_Server
  =
   class
   private
     SPP_SERVICE_CLASS_ID: TGUID;
     Bind_s : TSocket;
     Bind_sa: TSockAddr_BTH;
     Accept_s : TSocket;
     Accept_sa: TSockAddr_BTH;
     function RegisterService_BTH_SET_SERVICE(const ServiceName: WideString): Boolean;
   public
     constructor Create;
     destructor Destroy; override;

     function Initialize: Boolean;
     function Listen: Boolean;
     function GetServerAddress: string;
     function RegisterService_lpcsaBuffer(const ServiceName: String): Boolean;
     function Write(const Msg: string): Integer;
   end;

implementation

{ TBluetooth_Server }

constructor TBluetooth_Server.Create;
begin
     inherited;
     Bind_s      := INVALID_SOCKET;
     Accept_s:= INVALID_SOCKET;

     //Pour un serveur RFCOMM classique, utiliser l’UUID SPP (Serial Port Profile)
     SPP_SERVICE_CLASS_ID:= StringToGUID('{00001101-0000-1000-8000-00805F9B34FB}');
end;

destructor TBluetooth_Server.Destroy;
begin
     if INVALID_SOCKET = Accept_s then closesocket( Accept_s);
     if INVALID_SOCKET = Bind_s   then closesocket(   Bind_s);
     inherited;
end;

function TBluetooth_Server.Initialize: Boolean;
begin
     Result:= False;

     // Create Bluetooth RFCOMM socket
     Bind_s:= socket(AF_BTH, SOCK_STREAM, BTHPROTO_RFCOMM);
     if INVALID_SOCKET = Bind_s then Exit;

     FillChar(Bind_sa, SizeOf(Bind_sa), 0);
     Bind_sa.addressFamily := AF_BTH;
     Bind_sa.btAddr        :=      0; // Any local adapter
     Bind_sa.serviceClassId:=  SPP_SERVICE_CLASS_ID;
     Bind_sa.port          :=      0; // system assigned channel

     if SOCKET_ERROR = bind(Bind_s, @Bind_sa, SizeOf(Bind_sa)) then Exit;

     // Enregistrer le service SDP avec un nom explicite
     if not RegisterService_lpcsaBuffer('jsBluetooth SPP Server') then Exit;

     Result:= True;
end;

function TBluetooth_Server.Listen: Boolean;
var
   Accept_sa_size: Integer;
begin
     Result := False;

     if INVALID_SOCKET = Bind_s                     then exit;
     if SOCKET_ERROR   = WinSock2.listen(Bind_s, 1) then exit;

     Accept_sa_size := SizeOf(Accept_sa);
     Accept_s := accept(Bind_s, @Accept_sa, @Accept_sa_size);
     if INVALID_SOCKET = Accept_s then exit;

     Result:= True;
end;

function TBluetooth_Server.Write(const Msg: string): Integer;
var
   bytesSent: Integer;
   buf: TBytes;
begin
     Result:= SOCKET_ERROR;

     if INVALID_SOCKET = Accept_s then exit;

     buf:= TEncoding.UTF8.GetBytes(Msg);
     bytesSent:= send(Accept_s, PAnsiChar(@buf[0]), Length(buf), 0);
     if SOCKET_ERROR = bytesSent  then Exit;

     Result:= bytesSent;
end;

function TBluetooth_Server.GetServerAddress: string;
var
   btAddr64: UInt64;
   btAddrBytes: array[0..5] of Byte;
   i: Integer;
   channel: ULONG;
begin
     Result:= '';
     if INVALID_SOCKET = Bind_s then exit;

     btAddr64:= Bind_sa.btAddr;
     // Extraire les 6 octets significatifs (adresse Bluetooth 48 bits)
     for i := 0 to 5
     do
       btAddrBytes[i]:= (btAddr64 shr (8 * i)) and $FF;

     // Construire la chaîne au format classique hexadécimal inversé (MSB): "AA:BB:CC:DD:EE:FF"
     Result:= Format( '%.2X:%.2X:%.2X:%.2X:%.2X:%.2X',
                       [
                       btAddrBytes[5],
                       btAddrBytes[4],
                       btAddrBytes[3],
                       btAddrBytes[2],
                       btAddrBytes[1],
                       btAddrBytes[0]]);

     channel:= Bind_sa.port;
     Result:= Result + Format(':Channel=%d', [channel]);
end;

function TBluetooth_Server.RegisterService_lpcsaBuffer(const ServiceName: String): Boolean;
var
   csAddrInfo: CSADDR_INFO;
   querySet: TWSAQuerySetA;
begin
     Result:= False;
     if INVALID_SOCKET = Bind_s then exit;

     // Prépare la structure CSADDR_INFO
     ZeroMemory(@csAddrInfo, SizeOf(csAddrInfo));
     csAddrInfo.LocalAddr.lpSockaddr     := @Bind_sa;
     csAddrInfo.LocalAddr.iSockaddrLength:= SizeOf(Bind_sa);
     csAddrInfo.RemoteAddr.lpSockaddr     := nil;
     csAddrInfo.RemoteAddr.iSockaddrLength:= 0;
     csAddrInfo.iSocketType:= SOCK_STREAM;
     csAddrInfo.iProtocol:= BTHPROTO_RFCOMM;

     ZeroMemory(@querySet, SizeOf(querySet));
     querySet.dwSize:= SizeOf(querySet);
     querySet.lpszServiceInstanceName:= PChar(ServiceName);
     querySet.lpServiceClassId:= @SPP_SERVICE_CLASS_ID;
     querySet.lpszComment     := 'Serveur de test';
     querySet.dwNameSpace:= NS_BTH;
     querySet.dwNumberOfCsAddrs:= 1;
     querySet.lpcsaBuffer:= @csAddrInfo;

     // Enregistrer le service SDP
     Result:= 0 = WSASetServiceA(@querySet, RNRSERVICE_REGISTER, 0);
end;

function TBluetooth_Server.RegisterService_BTH_SET_SERVICE(const ServiceName: WideString): Boolean;
//à revoir, TBTHSetService non affecté
type
    PBTHSetService = ^TBTHSetService;
    TBTHSetService = packed record
        pSdpVersion: PULONG;
        pRecordHandle: PHANDLE;
        fCodService: ULONG;
        Reserved: array[0..4] of ULONG;
        ulRecordLength: ULONG;
        // Tableau ouvert, en Pascal normalement déclaré comme tableau d'octets dynamique
        pRecord: array[0..0] of Byte;
      end;
const
     BLUETOOTH_SERVICE_ENABLE          = $00000001;
     BLUETOOTH_SERVICE_NOAUTHENTICATE  = $00000002;
     BLUETOOTH_SERVICE_ENCRYPT         = $00000004;
var
   querySet: TWSAQuerySetW;
   csAddrInfo: CSADDR_INFO;
   b: BLOB;
   bthss: TBTHSetService;
   protocol: Integer;
   ret: Integer;
begin
     Result:= False;
     if INVALID_SOCKET = Bind_s then exit;

     // Préparer CSADDR_INFO
     ZeroMemory(@csAddrInfo, SizeOf(csAddrInfo));
     csAddrInfo.LocalAddr.lpSockaddr:= PSockAddr(@Bind_sa);
     csAddrInfo.LocalAddr.iSockaddrLength:= SizeOf(Bind_sa);
     csAddrInfo.RemoteAddr.lpSockaddr:= nil;
     csAddrInfo.RemoteAddr.iSockaddrLength:= 0;
     csAddrInfo.iSocketType:= SOCK_STREAM;
     csAddrInfo.iProtocol:= BTHPROTO_RFCOMM;

     // Préparer BTH_SET_SERVICE
     // https://learn.microsoft.com/fr-fr/windows/win32/api/ws2bth/ns-ws2bth-bth_set_service
     ZeroMemory(@bthss, SizeOf(bthss));
     //bthss.dwSize:= SizeOf(bthss);
     //bthss.dwServiceFlags:= BLUETOOTH_SERVICE_ENABLE or BLUETOOTH_SERVICE_NOAUTHENTICATE;
     //bthss.ServiceClassId:= SPP_SERVICE_CLASS_ID;
     //bthss.dwNumberOfCsAddrs:= 1;
     //bthss.rgCsAddrs:= @csAddrInfo;

     b.pBlobData:= @bthss;
     b.cbSize:= sizeof(bthss);

     // Préparer WSAQUERYSETW
     FillChar(querySet, SizeOf(querySet), 0);
     querySet.dwSize:= SizeOf(querySet);
     querySet.lpServiceClassId:= @SPP_SERVICE_CLASS_ID;
     querySet.lpszServiceInstanceName:= PWideChar(ServiceName);
     querySet.dwNameSpace:= NS_BTH;
     querySet.dwNumberOfProtocols:= 1;
     protocol:= AF_BTH;
     querySet.lpafpProtocols:= @protocol;
     querySet.lpcsaBuffer:= nil;
     querySet.dwOutputFlags:= 0;
     querySet.lpBlob:= @b;

     // Enregistrer le service
     //https://learn.microsoft.com/fr-fr/windows/win32/bluetooth/bluetooth-and-wsaqueryset-for-set-service
     ret:= WSASetServiceW(@querySet, RNRSERVICE_REGISTER, 0);
     Result:= (ret = 0);
end;

end.

