unit uBLE_Devices;
//{$mode ObjFPC}{$H+}

interface

uses
    uuStrings,
    SimpleBle,
 SysUtils, Classes, StdCtrls;

type
 // --- Liste des périphériques BLE découverts ---

 { TBLE_Device }

 TBLE_Device
 =
  class
  public
    Index: Integer;
    Identifier: string;
    Address: string;
    RSSI: Integer;
    Services: array of TSimpleBleService;
    function Libelle: String;
    function Libelle_avec_services: String;
  end;

 TBLEDeviceList = array of TBLE_Device;

 // --- Gestion du scan et de la liste BLE ---

 { TBLE_Devices }

 TBLE_Devices
 =
  class
  // Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Adapter
  public
    Adapter: TSimpleBleAdapter;
  //Scanner
  public
    procedure Scan( _Duration: Integer);
  //Devices
  private
    procedure Libere;
  public
    Devices: TBLEDeviceList;
  //Initialisation
  private
    initialized: Boolean;
    sError: String;
    function Initialize: Boolean;
  //Liste
  public
    function Liste: String;
  //Listbox
  public
    procedure Remplit_Listbox( _lb: TListBox);
  //Peripheral
  public
    function Peripheral_from_Device( _D: TBLE_Device):TSimpleBlePeripheral;
    procedure Peripheral_Release( _P: TSimpleBlePeripheral);
  end;

implementation

{ TBLE_Device }

function TBLE_Device.Libelle: String;
begin
     Result:= Identifier+','+Address+', '+IntToStr(RSSI);
end;

function TBLE_Device.Libelle_avec_services: String;
var
   s: TSimpleBleService;
begin
     Result:= Libelle;
     if 0 = Length(Services)
     then
         Formate_Liste( Result, #13#10, '  pas de services');
     for s in Services
     do
       Formate_Liste( Result, #13#10, s.Uuid.Value);
end;

{ TBLE_Devices }

constructor TBLE_Devices.Create;
begin
     inherited Create;
     initialized:= False;

     if SimpleBleAdapterGetCount > 0
     then
         Adapter:= SimpleBleAdapterGetHandle(0)
     else
         Adapter:= 0;
end;

destructor TBLE_Devices.Destroy;
begin
     if Adapter <> 0
     then
         SimpleBleAdapterReleaseHandle( Adapter);
     Libere;
     inherited Destroy;
end;

procedure TBLE_Devices.Libere;
var
   bd: TBLE_Device;
begin
     for bd in Devices do bd.Free;
     SetLength( Devices, 0);
end;

procedure TBLE_Devices.Scan( _Duration: Integer);
var
   ResultCode: TSimpleBleErr;
   DeviceCount, I: NativeUInt;
   sbp: TSimpleBlePeripheral;
   bd: TBLE_Device;
   j,n: Integer;
   Service: TSimpleBleService;
begin
     Libere;

     if 0 = Adapter then exit;

     if SIMPLEBLE_SUCCESS <> SimpleBleAdapterScanStart( Adapter) then exit;

     Sleep(_Duration * 1000);

     if SIMPLEBLE_SUCCESS <> SimpleBleAdapterScanStop( Adapter) then exit;

     DeviceCount := SimpleBleAdapterScanGetResultsCount(Adapter);
     if 0 = DeviceCount then exit;

     SetLength( Devices, DeviceCount);
     for I:= 0 to DeviceCount - 1
     do
       begin
       sbp:= SimpleBleAdapterScanGetResultsHandle(Adapter, I);
       bd:= TBLE_Device.Create;
       bd.Index:= I;
       bd.Identifier:= SimpleBlePeripheralIdentifier(sbp);
       bd.Address   := SimpleBlePeripheralAddress   (sbp);
       bd.RSSI      := SimpleBlePeripheralRssi      (sbp);
       // Recherche du service dans le périphérique pour vérif
       n := SimpleBlePeripheralServicesCount( sbp);
       SetLength( bd.Services, n);
       for j:= 0 to n - 1
       do
         begin
         if SIMPLEBLE_SUCCESS
            =
            SimpleBlePeripheralServicesGet( sbp, j, bd.Services[i])
         then
             raise Exception.Create( 'TBLE_Devices.Scan: Echec de SimpleBlePeripheralServicesGet');
         end;
       Devices[I]:= bd;
       SimpleBlePeripheralReleaseHandle(sbp);
       end;
end;

function TBLE_Devices.Initialize: Boolean;
begin
     Scan( 2);
     initialized:= True;
     Result:= initialized;
end;

function TBLE_Devices.Liste: String;
var
   bd: TBLE_Device;
begin
     if not initialized
     then
         Initialize;

     if 0 = Length( Devices) then begin Result:= 'Pas de périphériques';exit; end;

     Result:= 'Devices:';
     for bd in Devices
     do
       Formate_Liste( Result, #13#10, bd.Libelle_avec_services);
end;

procedure TBLE_Devices.Remplit_Listbox( _lb: TListBox);
var
   bd: TBLE_Device;
begin
     _lb.Clear;

     if not initialized
     then
         Initialize;

          if not initialized    then exit
     else if 0 = Length( Devices) then exit
     else
         for bd in Devices
         do
           _lb.AddItem( bd.Identifier, bd);
end;

function TBLE_Devices.Peripheral_from_Device(_D: TBLE_Device): TSimpleBlePeripheral;
begin
     Result:= 0;
     if 0 = Adapter then exit;

     Result:= SimpleBleAdapterScanGetResultsHandle(Adapter, _D.Index);
end;

procedure TBLE_Devices.Peripheral_Release(_P: TSimpleBlePeripheral);
begin
     SimpleBlePeripheralReleaseHandle( _P);
end;

end.

