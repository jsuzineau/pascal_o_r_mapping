unit uBLE;
//{$mode ObjFPC}{$H+}

interface

uses
    uuStrings,
    SimpleBle,
 SysUtils, Classes, StdCtrls;

type
 // --- Liste des périphériques BLE découverts ---

 TBLE_Adapter = class;

 { TBLE_Peripheral }

 TBLE_Peripheral
 =
  class
  // Gestion du cycle de vie
  public
    constructor Create( _ba: TBLE_Adapter; _Index: Integer);
    destructor Destroy; override;
  //Attributs
  public
    ba: TBLE_Adapter;
    Index: Integer;

    Identifier: string;
    Address: string;
    RSSI: Integer;
    function Libelle: String;
  //Gestion d'erreur
  public
    sError: String;
  //Peripheral
  public
    Peripheral: TSimpleBlePeripheral;
  //Connexion
  public
    Connected: Boolean;
    function Connect: Boolean;
    procedure Disconnect;
    function ElseWhere_Connected: Boolean;
  //Services
  public
    Services_Initialized: Boolean;
    Services: array of TSimpleBleService;
    procedure Initialise_Services;
    function Liste_services: String;
    function Provide_Service( _uuid: TSimpleBleUuid): Boolean;
  //Ecriture
  public
    function WriteString( _s: String ):Boolean;
  end;

 { TBLE_Adapter }

 TBLE_Adapter
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
    Peripherals: array of TBLE_Peripheral;
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

function Uuid_from_String( _S: String): TSimpleBleUuid;

implementation

function Uuid_from_String( _S: String): TSimpleBleUuid;
begin
     FillChar(Result, SizeOf(Result), 0);
     StrPLCopy( Result.Value, LowerCase(_S), SIMPLEBLE_UUID_STR_LEN-1);
end;

{ TBLE_Peripheral }

constructor TBLE_Peripheral.Create(_ba: TBLE_Adapter; _Index: Integer);
begin
     ba:= _ba;
     Index:= _Index;
     Peripheral:= SimpleBleAdapterScanGetResultsHandle(ba.Adapter, Index);

     Identifier:= SimpleBlePeripheralIdentifier( Peripheral);
     Address   := SimpleBlePeripheralAddress   ( Peripheral);
     RSSI      := SimpleBlePeripheralRssi      ( Peripheral);

     Services_Initialized:= False;
end;

destructor TBLE_Peripheral.Destroy;
begin
     if Connected then Disconnect;
     SimpleBlePeripheralReleaseHandle( Peripheral);
     inherited Destroy;
end;

function TBLE_Peripheral.Libelle: String;
begin
     Result:= Identifier+','+Address+', '+IntToStr(RSSI);
end;

function TBLE_Peripheral.Connect: Boolean;
begin
     Result:= False;
     sError:= '';

     if Peripheral = 0
     then
         begin
         sError:= 'Peripheral non initialisé';
         exit;
         end;
     Connected:= SIMPLEBLE_SUCCESS = SimpleBlePeripheralConnect( Peripheral);
     if not Connected
     then
        sError
        :=
           'Erreur de connexion BLE sur '
          +SimpleBlePeripheralIdentifier( Peripheral)+','
          +SimpleBlePeripheralAddress   ( Peripheral)+','
          +IntToStr(SimpleBlePeripheralRssi( Peripheral));
     Result:= Connected;
end;

procedure TBLE_Peripheral.Disconnect;
begin
     if 0 = Peripheral then exit;

     SimpleBlePeripheralDisconnect( Peripheral);
     Connected:= False;
end;

function TBLE_Peripheral.ElseWhere_Connected: Boolean;
begin
     Result:= False;
     if Peripheral = 0 then exit;

     if SIMPLEBLE_SUCCESS <> SimpleBlePeripheralIsConnected( Peripheral, Result)
     then
         Result:= False;
end;

procedure TBLE_Peripheral.Initialise_Services;
var
   ServicesCount: NativeUInt;
   I:Integer;
begin
     ServicesCount := SimpleBlePeripheralServicesCount( Peripheral);

     SetLength( Services, ServicesCount);
     for I:= Low(Services) to High(Services)
     do
       begin
       if SIMPLEBLE_FAILURE
          =
          SimpleBlePeripheralServicesGet( Peripheral, I, Services[i])
       then
           raise Exception.Create( 'TBLE_Devices.Scan: Echec de SimpleBlePeripheralServicesGet');
       end;

     Services_Initialized:= True;
end;

function TBLE_Peripheral.Liste_services: String;
var
   s: TSimpleBleService;
begin
     Result:= 'Services:';
     if not Services_Initialized
     then
         Initialise_Services;
     if 0 = Length(Services)
     then
         Formate_Liste( Result, #13#10, '  pas de services');
     for s in Services
     do
       Formate_Liste( Result, #13#10, '  '+s.Uuid.Value);
end;

function TBLE_Peripheral.Provide_Service( _uuid: TSimpleBleUuid): Boolean;
var
   Service: TSimpleBleService;
begin
     Result:= False;
     if not Services_Initialized
     then
         Initialise_Services;
     for Service in Services
     do
       begin
       Result:= StrComp( Service.Uuid.Value, _uuid.Value) = 0;
       if Result then break;
       end;
end;

function TBLE_Peripheral.WriteString(_s: String): Boolean;
var
   uuidService: TSimpleBleUuid;
   uuidCharacteristic: TSimpleBleUuid;
begin
     Result:= False;
     sError:= '';
     if Peripheral = 0
     then
         begin
         sError:= 'Peripheral non initialisé';
         exit;
         end;

     uuidService       := Uuid_from_String( '6E400001-B5A3-F393-E0A9-E50E24DCCA9E');
     uuidCharacteristic:= Uuid_from_String( '6E400002-B5A3-F393-E0A9-E50E24DCCA9E');

     if not Provide_Service( uuidService)
     then
         begin
         sError:= 'Service BLE non trouvé sur le périphérique';
         exit;
         end;

     if SIMPLEBLE_SUCCESS
        =
        SimpleBlePeripheralWriteRequest( Peripheral,
                                         uuidService,
                                         uuidCharacteristic,
                                         PByte(PChar(_s)),
                                         Length(_s)
                                         )
     then
          sError:= ''
     else
         begin
         sError:= 'Erreur lors de l''écriture BLE';
         exit;
         end;
     Result:= True;
end;

{ TBLE_Adapter }

constructor TBLE_Adapter.Create;
begin
     inherited Create;
     initialized:= False;

     if SimpleBleAdapterGetCount > 0
     then
         Adapter:= SimpleBleAdapterGetHandle(0)
     else
         Adapter:= 0;
end;

destructor TBLE_Adapter.Destroy;
begin
     if Adapter <> 0
     then
         SimpleBleAdapterReleaseHandle( Adapter);
     Libere;
     inherited Destroy;
end;

procedure TBLE_Adapter.Libere;
var
   bd: TBLE_Peripheral;
begin
     for bd in Peripherals do bd.Free;
     SetLength( Peripherals, 0);
end;

procedure TBLE_Adapter.Scan( _Duration: Integer);
var
   DeviceCount: NativeUInt;
   I: Integer;
begin
     Libere;

     if 0 = Adapter then exit;

     if SIMPLEBLE_SUCCESS <> SimpleBleAdapterScanStart( Adapter) then exit;

     Sleep(_Duration * 1000);

     if SIMPLEBLE_SUCCESS <> SimpleBleAdapterScanStop( Adapter) then exit;

     DeviceCount := SimpleBleAdapterScanGetResultsCount(Adapter);
     if 0 = DeviceCount then exit;

     SetLength( Peripherals, DeviceCount);
     for I:= Low(Peripherals) to High(Peripherals)
     do
       Peripherals[I]:= TBLE_Peripheral.Create( Self, I);
end;

function TBLE_Adapter.Initialize: Boolean;
begin
     Scan( 2);
     initialized:= True;
     Result:= initialized;
end;

function TBLE_Adapter.Liste: String;
var
   bd: TBLE_Peripheral;
begin
     if not initialized
     then
         Initialize;

     if 0 = Length( Peripherals) then begin Result:= 'Pas de périphériques';exit; end;

     Result:= 'Devices:';
     for bd in Peripherals
     do
       Formate_Liste( Result, #13#10, bd.Libelle);
end;

procedure TBLE_Adapter.Remplit_Listbox( _lb: TListBox);
var
   bd: TBLE_Peripheral;
begin
     _lb.Clear;

     if not initialized
     then
         Initialize;

          if not initialized    then exit
     else if 0 = Length( Peripherals) then exit
     else
         for bd in Peripherals
         do
           _lb.AddItem( bd.Identifier, bd);
end;

end.

