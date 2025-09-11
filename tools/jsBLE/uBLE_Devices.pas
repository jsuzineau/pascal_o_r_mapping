unit uBLE_Devices;
//{$mode ObjFPC}{$H+}

interface

uses
    uuStrings,
    SimpleBle,
 SysUtils, Classes, StdCtrls;

type
 // --- Liste des périphériques BLE découverts ---
 TBLE_Device
 =
  record
  Identifier: string;
  Address: string;
  RSSI: Integer;
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
  //Scanner
  private
    Adapter: TSimpleBleAdapter;
  public
    procedure Scan( _Duration: Integer);
  //Devices
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
  end;

implementation

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
     inherited Destroy;
end;

procedure TBLE_Devices.Scan( _Duration: Integer);
var
   ResultCode: TSimpleBleErr;
   DeviceCount, I: NativeUInt;
   sbp: TSimpleBlePeripheral;
   bd: TBLE_Device;
begin
     SetLength(Devices, 0);

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
       bd.Identifier:= SimpleBlePeripheralIdentifier(sbp);
       bd.Address   := SimpleBlePeripheralAddress   (sbp);
       bd.RSSI      := SimpleBlePeripheralRssi      (sbp);
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
   i: Integer;
   bd: TBLE_Device;
begin
     if not initialized
     then
         Initialize;

     if 0 = Length( Devices) then begin Result:= 'Pas de périphériques';exit; end;

     Result:= 'Devices:';
     for i:= Low( Devices) to High( Devices)
     do
       begin
       bd:= Devices[i];
       Formate_Liste( Result, #13#10, bd.Identifier+','+bd.Address+', '+IntToStr(bd.RSSI));
       end;
end;

procedure TBLE_Devices.Remplit_Listbox( _lb: TListBox);
//var
//   spp: TBluetooth_SPP;
begin
     _lb.Clear;

     if not initialized
     then
         Initialize;

     //     if not initialized    then exit
     //else if 0 = Length( SPPs) then exit
     //else
     //    for spp in SPPs
     //    do
     //      _lb.AddItem( spp.Libelle, spp);
end;

end.

