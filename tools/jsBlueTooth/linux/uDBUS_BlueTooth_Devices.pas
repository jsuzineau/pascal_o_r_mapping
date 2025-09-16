unit uDBUS_BlueTooth_Devices;

{$mode ObjFPC}{$H+}

interface

uses
    uuStrings,
    uDBUS,
  Classes, SysUtils, StdCtrls,fgl,unixtype, dbus;

// Liste tous les périphériques Bluetooth visibles/appairés sur l'ordi
type
 TInterface_Type= (it_Device, it_SPP, it_Unknown);

 { TDevice_Properties }

 TDevice_Properties
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy;
  //Attributs
  public
    Path: String;
    Name: String;
    Address: String;
  end;

 { TSPP_Properties }

 TSPP_Properties
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy;
  //Attributs
  public
    Path: String;
    Channel: Byte;
  end;

 { TBluetoothDevice }

 TBluetoothDevice
 =
  class
   Path: String;
   Address: string;
   Name: string;
   function Libelle: String; virtual;
  end;

 { TBluetooth_SPP }

 TBluetooth_SPP
 =
  class( TBluetoothDevice)
   Channel: byte;
   function Libelle: String; override;
  end;

 TBluetoothDevice_array= array of TBluetoothDevice;
 TBluetoothSPP_array   = array of TBluetooth_SPP;

 { TBluetoothDevices }

 TBluetoothDevices
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _dbus: TDBUS);

    destructor Destroy; override;
  //dbus
  private
    dbus: TDBUS;
  //Interfaces
  public
    slDevices_Properties: TStringList;
  //Interfaces SPP
  public
    slSPPs_Properties: TStringList;
  //Devices
  private
    FDevices: TBluetoothDevice_array;
    FSPPs: TBluetoothSPP_array;
    procedure Libere;
  public
    property Devices: TBluetoothDevice_array read FDevices;
    property SPPs: TBluetoothSPP_array read FSPPs;
  public
  //Initialisation
  private
    initialized: Boolean;
    sError: String;
    function Initialize: Boolean;
    function dp_from_sppp( _sppp: TSPP_Properties): TDevice_Properties;
    procedure _from_Interfaces;
  //Liste
  public
    function Liste: String;
  //Listbox
  public
    procedure Remplit_Listbox( _lb: TListBox);
  end;

implementation

{ TDevice_Properties }

constructor TDevice_Properties.Create;
begin

end;

destructor TDevice_Properties.Destroy;
begin

end;

{ TSPP_Properties }

constructor TSPP_Properties.Create;
begin

end;

destructor TSPP_Properties.Destroy;
begin

end;

{ TBluetoothDevice }

function TBluetoothDevice.Libelle: String;
begin
     Result:= Format( 'Name: %s, Address: %s', [Name, Address]);
end;

{ TBluetooth_SPP }

function TBluetooth_SPP.Libelle: String;
begin
     Result:= Format( 'Name: %s, Address: %s, Channel: %d', [Name, Address, Channel]);
end;

{ TBluetoothDevices }

constructor TBluetoothDevices.Create(_dbus: TDBUS);
begin
     dbus:= _dbus;
     initialized:= False;
     slDevices_Properties:= TStringList.Create;
     slSPPs_Properties       := TStringList.Create;
end;

destructor TBluetoothDevices.Destroy;
begin
     FreeAndNil( slDevices_Properties);
     FreeAndNil( slSPPs_Properties       );
     Libere;
     inherited Destroy;
end;

procedure TBluetoothDevices.Libere;
var
   bd: TBluetoothDevice;
   bspp: TBluetooth_SPP;
begin
     for bd in Devices do bd.Free;
     SetLength( FDevices, 0);

     for bspp in SPPs do bspp.Free;
     SetLength( FSPPs, 0);
end;

function TBluetoothDevices.Initialize:Boolean;
var
   call         : TDBUS_Method_Call;
   reply        : TDBUS_Message;

   Racine       : TDBUS_Iterateur;

   dPaths       : TDBUS_Iterateur;
   iPath        : TDBUS_Iterateur;
   Path: String;

   dInterfaces      : TDBUS_Iterateur;
   iInterface      : TDBUS_Iterateur;
   Interface_Name: String;
   it: TInterface_Type;

   dInterface_Properties    : TDBUS_Iterateur;
   iInterface_Property_Name : TDBUS_Iterateur;
   iInterface_Property_Value: TDBUS_Iterateur;
   Interface_Property_Name: String;

   Fdp: TDevice_Properties;
   Fsppp: TSPP_Properties;
   function dp: TDevice_Properties;
   begin
        if nil = Fdp
        then
            begin
            Fdp:= TDevice_Properties.Create;
            slDevices_Properties.AddObject( Path, Fdp);
            end;
        Result:= Fdp;
   end;
   function sppp: TSPP_Properties;
   begin
        if nil = Fsppp
        then
            begin
            Fsppp:= TSPP_Properties.Create;
            slSPPs_Properties.AddObject( Path, Fsppp);
            end;
        Result:= Fsppp;
   end;
begin
     Result:= False;
     try
        call:= TDBUS_Method_Call.Create( dbus,
                                         'org.bluez',
                                         '/',
                                         'org.freedesktop.DBus.ObjectManager',
                                         'GetManagedObjects'
                                         );
        if '' <> call.sError
        then
            begin
            sError:= call.sError;
            Exit;
            end;
        try
           reply:= call.SendAndBlock(3000);
           if nil = reply
           then
               begin
               sError:= call.sError;
               Exit;
               end;

           Racine:= reply.Iterateur;
           if nil = Racine
           then
               begin
               sError:= reply.sError;
               Exit;
               end;

           dPaths:= Racine.Recurse;
           while dPaths.ArgType = DBUS_TYPE_DICT_ENTRY
           do
             begin
             //Path /org.bluez
             //Path /org/bluez/hci0
             //Path /org/bluez/hci0/dev_FC_58_FA_AC_FD_D6
             iPath:= dPaths.Recurse;
             if iPath.ArgType <> DBUS_TYPE_OBJECT_PATH
             then
                 begin
                 dPaths.Next;
                 continue;
                 end;
             Path:= iPath.Basic_String;
             iPath.Next;

             dInterfaces:= iPath.Recurse;
             while dInterfaces.ArgType = DBUS_TYPE_DICT_ENTRY
             do
               begin
               Fdp  := nil;
               Fsppp:= nil;
               // org.bluez.Adapter1
               // org.bluez.Device1
               iInterface:= dInterfaces.Recurse;
               if iInterface.ArgType = DBUS_TYPE_STRING
               then
                   Interface_Name:= iInterface.Basic_String
               else
                   Interface_Name:= '';
                    if Interface_Name = 'org.bluez.Device1'    then it:= it_Device
               else if Interface_Name = 'org.bluez.SerialPort' then it:= it_SPP
               else                                                 it:= it_Unknown;

               case it
               of
                 it_Device: dp  .Path:= Path;
                 it_SPP   : sppp.Path:= Path;
                 end;

               iInterface.Next;
               dInterface_Properties:= iInterface.Recurse;
               while dInterface_Properties.ArgType = DBUS_TYPE_DICT_ENTRY
               do
                 begin
                 iInterface_Property_Name:= dInterface_Properties.Recurse;
                 Interface_Property_Name:= iInterface_Property_Name.Basic_String;
                 iInterface_Property_Name.Next;

                 iInterface_Property_Value:= iInterface_Property_Name.Recurse;
                 case it
                 of
                   it_Device:
                     begin
                          if 'Address' = Interface_Property_Name
                     then
                         dp.Address:= iInterface_Property_Value.Basic_String
                     else if 'Name' = Interface_Property_Name
                     then
                         dp.Name:= iInterface_Property_Value.Basic_String;
                     end;
                   it_SPP   :
                     begin
                     if 'Channel' = Interface_Property_Name
                     then
                         if DBUS_TYPE_BYTE = iInterface_Property_Value.ArgType
                         then
                             sppp.Channel := iInterface_Property_Value.Basic_Byte;
                     end;
                   end;
                 dInterface_Properties.Next;
                 end;
               dInterfaces.Next;
               end;
             dPaths.Next;
             end;

           initialized := true;
           Result := true;
        finally
               reply.Free;
               end;
     finally
            call.Free;
            end;
     _from_Interfaces;
end;

function TBluetoothDevices.dp_from_sppp( _sppp: TSPP_Properties): TDevice_Properties;
var
   i: Integer;
begin
     Result:= nil;
     for i:= 0 to slDevices_Properties.Count-1
     do
       if 1 = Pos(slDevices_Properties[i], _sppp.Path)
       then
           begin
           Result:= slDevices_Properties.Objects[i] as TDevice_Properties;
           break;
           end;
end;

procedure TBluetoothDevices._from_Interfaces;
var
   I: Integer;
   dp: TDevice_Properties;
   sppp: TSPP_Properties;
   device: TBluetoothDevice;
   spp   : TBluetooth_SPP;
begin
     SetLength( FDevices, slDevices_Properties.Count);
     for i:=Low(Devices) to High(Devices)
     do
       begin
       dp:= slDevices_Properties.Objects[i] as TDevice_Properties;
       device:= TBluetoothDevice.Create;
       device.Path   := dp.Path;
       device.Name   := dp.Name;
       device.Address:= dp.Address;
       Devices[i]:= device;
       end;

     SetLength( FSPPs, slSPPs_Properties.Count);
     for i:=Low(SPPs) to High(SPPs)
     do
       begin
       sppp:= slSPPs_Properties.Objects[i] as TSPP_Properties;
       dp:= dp_from_sppp( sppp);
       if nil = dp then continue;

       spp:= TBluetooth_SPP.Create;
       spp.Path   := sppp.Path;
       spp.Name   := dp.Name;
       spp.Address:= dp.Address;
       spp.Channel:= sppp.Channel;
       SPPs[i]:= spp;
       end;
end;

function TBluetoothDevices.Liste: String;
var
   i: Integer;
   bd: TBluetoothDevice;
   spp: TBluetooth_SPP;
begin
     if not initialized
     then
         Initialize;

     if not initialized then begin Result:= sError; exit; end;

     if 0 = Length( Devices) then begin Result:= 'Pas de périphériques';exit; end;

     Result:= 'Devices:';
     for i:= Low( Devices) to High( Devices)
     do
       begin
       bd:= Devices[i];
       Formate_Liste( Result, #13#10, bd.Libelle);
       end;

     Formate_Liste( Result, #13#10, 'SPP :');
     for i:= Low( SPPs) to High( SPPs)
     do
       begin
       spp:= SPPs[i];
       Formate_Liste( Result, #13#10, spp.Libelle);
       end;
end;

procedure TBluetoothDevices.Remplit_Listbox(_lb: TListBox);
var
   spp: TBluetooth_SPP;
begin
     _lb.Clear;

     if not initialized
     then
         Initialize;

          if not initialized    then exit
     else if 0 = Length( SPPs) then exit
     else
         for spp in SPPs
         do
           _lb.AddItem( spp.Libelle, spp);
end;


end.
























































































