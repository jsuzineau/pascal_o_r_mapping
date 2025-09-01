unit uWinSock2_BlueTooth_Devices;

{$mode ObjFPC}{$H+}

interface

uses
    uuStrings,
    uWinUtils,
    uWinSock2_BlueTooth,
 Classes, SysUtils, Windows, Winsock2,StdCtrls,fgl;

// Liste tous les périphériques Bluetooth visibles/appairés sur l'ordi
type

    { TBluetoothDevice }

    TBluetoothDevice
    =
     class
      Name: string;
      Address: TSockAddr_BTH;
      Connected: Boolean;
      Remembered: Boolean;
      Authenticated: Boolean;
      function Libelle: String;
     end;

    TBluetoothDevice_array= array of TBluetoothDevice;

    { TBluetoothDevices }

    TBluetoothDevices
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create;
       destructor Destroy; override;
     //Items
     private
       FItems: TBluetoothDevice_array;
       procedure Libere;
     public
       property Items: TBluetoothDevice_array read FItems;
     //code d'erreur windows
     private
       sError: String;
     //Initialisation
     private
       initialized: Boolean;
       function Initialize: Boolean;
     //Liste
     public
       function Liste: String;
     //Listbox
     public
       procedure Remplit_Listbox( _lb: TListBox);
     end;


implementation

{ TBluetoothDevice }

function TBluetoothDevice.Libelle: String;
begin
     Result:= Format( 'Device: %s, Addr: %x:%d',[Name,Address.btAddr, Address.port]);
end;

constructor TBluetoothDevices.Create;
begin
     initialized:= False;
end;

destructor TBluetoothDevices.Destroy;
begin
     Libere;
     inherited Destroy;
end;

procedure TBluetoothDevices.Libere;
var
   bd: TBluetoothDevice;
begin
     for bd in Items do bd.Free;
end;

function TBluetoothDevices.Initialize: Boolean;
const
     Flags
     =    LUP_CONTAINERS  //Retourne uniquement des conteneurs.
       or LUP_RETURN_NAME //Récupère le nom en tant que lpszServiceInstanceName.
       or LUP_RETURN_ADDR //Récupère les adresses en tant que lpcsaBuffer.
       or LUP_RETURN_TYPE //Récupère le type en tant que lpServiceClassId.
       or LUP_RETURN_BLOB;//Récupère les données privées en tant que lpBlob.
var
   querySet: TWSAQuerySetW;
   hLookup: THandle;

   buf: array[0..4095] of Byte;
   pResults: PWSAQuerySetW;
   dwBufLen: DWORD;
   device: TBluetoothDevice;
   addrinfo: PCSADDR_INFO;
   count: Integer;
begin
     Result:= False;
     ZeroMemory(@querySet, SizeOf(querySet));
     querySet.dwSize:= SizeOf(querySet);
     querySet.dwNameSpace:= NS_BTH;

     if WSALookupServiceBeginW(@querySet, Flags, @hLookup) <> 0
     then
         begin
         sError:= WSALastError_Message;
         exit;
         end;

     Libere;
     count:= 0;
     dwBufLen:= SizeOf(buf);
     pResults:= @buf[0];
     SetLength(FItems, 0);

     while WSALookupServiceNextW(hLookup, Flags, dwBufLen, pResults) = 0
     do
       begin
       device:= TBluetoothDevice.Create;
       device.Name:= WideCharToString(pResults^.lpszServiceInstanceName);
       if Assigned(pResults^.lpcsaBuffer)
       then
           begin
           addrinfo      := pResults^.lpcsaBuffer;
           device.Address:= PSockAddr_BTH(addrinfo^.RemoteAddr.lpSockaddr)^;
           end;
       device.Connected   := (pResults^.dwOutputFlags and $01) <> 0; // BTHNS_RESULT_DEVICE_CONNECTED
       device.Remembered  := (pResults^.dwOutputFlags and $02) <> 0; // BTHNS_RESULT_DEVICE_REMEMBERED
       device.Authenticated:= (pResults^.dwOutputFlags and $04) <> 0; // BTHNS_RESULT_DEVICE_AUTHENTICATED

       SetLength(FItems, count + 1);
       FItems[count]:= device;
       Inc(count);
       dwBufLen:= SizeOf(buf);
       end;

     WSALookupServiceEnd(hLookup);
     Result:= True;
     initialized:= True;
end;

function TBluetoothDevices.Liste: String;
var
   i: Integer;
   bd: TBluetoothDevice;
begin
     if not initialized
     then
         Initialize;

          if not initialized    then Result:= sError
     else if 0 = Length( items) then Result:= 'Pas de périphériques'
     else
         begin
         Result:= '';
         for i:= Low( items) to High( items)
         do
           begin
           bd:= items[i];
           Formate_Liste( Result, #13#10, Items[i].Libelle);
           end;
         end;
end;

procedure TBluetoothDevices.Remplit_Listbox(_lb: TListBox);
var
   bd: TBluetoothDevice;
begin
     _lb.Clear;

     if not initialized
     then
         Initialize;

          if not initialized    then exit
     else if 0 = Length( items) then exit
     else
         for bd in items
         do
           _lb.AddItem( bd.Libelle, bd);
end;


end.

