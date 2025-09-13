unit uBLE_Client;

interface

uses
   SysUtils, Classes,
   SimpleBle,
   uBLE_Devices;

type

 { TBLE_Client }

 TBLE_Client
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Devices: TBLE_Devices; _Device: TBLE_Device );
    destructor Destroy; override;
  //Gestion d'erreur
  public
    sError: String;
  //Devices
  private
    Devices: TBLE_Devices;
  //Device
  private
    Device: TBLE_Device;
  //Connexion
  private
    FConnected: Boolean;
  public
    function Connect: Boolean;
    procedure Disconnect;
    function IsConnected: Boolean;
  //Accès bas-niveau
  private
    Peripheral: TSimpleBlePeripheral;
    procedure SetPeripheralFromDevice;
  //Ecriture
  public
    function WriteString( _s: String ):Boolean;
  end;

implementation

{ TBLE_Client }

constructor TBLE_Client.Create(_Devices: TBLE_Devices; _Device: TBLE_Device);
begin
     inherited Create;
     Devices:= _Devices;
     Device := _Device ;
     Peripheral:= 0;
     FConnected:= False;
     sError:= '';
     SetPeripheralFromDevice;
end;

destructor TBLE_Client.Destroy;
begin
     if Peripheral <> 0
     then
         SimpleBlePeripheralReleaseHandle( Peripheral);
     inherited Destroy;
end;

procedure TBLE_Client.SetPeripheralFromDevice;
begin
     Peripheral:= Devices.Peripheral_from_Device( Device);
end;

function TBLE_Client.Connect: Boolean;
begin
     Result:= False;
     if Peripheral = 0
     then
         begin
         sError:= 'Peripheral non initialisé';
         exit;
         end;
     if SIMPLEBLE_SUCCESS = SimpleBlePeripheralConnect( Peripheral)
     then
         begin
         FConnected:= True;
         Result:= True;
         end
     else
        begin
        sError
        :=
           'Erreur de connexion BLE:'
          +SimpleBlePeripheralIdentifier( Peripheral)+','
          +SimpleBlePeripheralAddress   ( Peripheral)+','
          +IntToStr(SimpleBlePeripheralRssi( Peripheral));
        FConnected:= False;
        end;
end;

procedure TBLE_Client.Disconnect;
begin
     if Peripheral <> 0
     then
         begin
         SimpleBlePeripheralDisconnect( Peripheral );
         FConnected:= False;
         end;
end;

function TBLE_Client.IsConnected: Boolean;
var
   ok: Boolean;
begin
     Result:= False;
     if Peripheral = 0 then exit;
     ok:= False;
     if SIMPLEBLE_SUCCESS = SimpleBlePeripheralIsConnected( Peripheral, ok )
     then
         Result:= ok;
end;

function TBLE_Client.WriteString( _s: String): Boolean;
var
   uuidService: TSimpleBleUuid;
   uuidCharacteristic: TSimpleBleUuid;
   Service: TSimpleBleService;
   i, n: NativeUInt;
   found: Boolean;
   p: PChar;
begin
     Result:= False;
     sError:= '';
     if Peripheral = 0
     then
         begin
         sError:= 'Peripheral non initialisé';
         exit;
         end;

     // Copie des UUID sous forme C/Pascal compatible
     FillChar(uuidService, SizeOf(uuidService), 0);
     p:=PChar('6E400001-B5A3-F393-E0A9-E50E24DCCA9E');
     StrPLCopy(uuidService.Value, p, SIMPLEBLE_UUID_STR_LEN-1);

     FillChar(uuidCharacteristic, SizeOf(uuidCharacteristic), 0);
     p:=PChar('6E400002-B5A3-F393-E0A9-E50E24DCCA9E');
     StrPLCopy(uuidCharacteristic.Value, p, SIMPLEBLE_UUID_STR_LEN-1);

     // Recherche du service dans le périphérique pour vérif
     n := SimpleBlePeripheralServicesCount( Peripheral);
     found := False;
     for i := 0 to n - 1
     do
       begin
       if SIMPLEBLE_SUCCESS
          =
          SimpleBlePeripheralServicesGet( Peripheral, i, Service )
       then
           begin
           if StrComp(Service.Uuid.Value, uuidService.Value) = 0
           then
               begin
               found := True;
               break;
               end;
           end;
       end;
     if not found
     then
         begin
         sError:= 'Service BLE non trouvé sur le périphérique';
         exit;
         end;
     // Conversion de la string à envoyer en tableau d’octets
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

end.

