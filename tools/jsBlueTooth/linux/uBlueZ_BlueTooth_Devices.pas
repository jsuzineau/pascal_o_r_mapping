unit uBlueZ_BlueTooth_Devices;

{$mode ObjFPC}{$H+}

interface

uses
    uuStrings,
    Bluetooth,
  Classes, SysUtils, StdCtrls,fgl,unixtype;

 // Liste tous les périphériques Bluetooth visibles/appairés sur l'ordi
 type

     { TBluetoothDevice }

     TBluetoothDevice
     =
      class
       Dev: string; //Bluetooth Device Address (bdaddr) DevName
       Remote: string;
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
      //Host
      public
        Host_id  : cint;
        Host_sock: cint;
      //Items
      private
        FItems: TBluetoothDevice_array;
        procedure Libere;
      public
        property Items: TBluetoothDevice_array read FItems;
      //code d'erreur
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
      Result:= Format( 'Device bdaddr: %s, Remote: %s',[Dev,Remote]);
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
 var
    scan_info: array[0..254] of inquiry_info;
    scan_info_ptr: Pinquiry_info;
    found_devices: cint;
    device: TBluetoothDevice;
    DevName: array[0..255] of Char;
    PDevName: PCChar;
    RemoteName: array[0..255] of Char;
    PRemoteName: PCChar;
    i: Integer;
    flags: clong;
    timeout1: Integer = 5;
    timeout2: Integer = 5000;
 begin
      Result:= False;

      // get the id of the first bluetooth device.
      sError:= 'Echec de hci_get_route';
      Host_id := hci_get_route(nil);
      if Host_id < 0 then exit;

      // create a socket to the device
      sError:= 'Echec de hci_open_dev';
      Host_sock := hci_open_dev(Host_id);
      if Host_sock < 0 then exit;

      // scan for bluetooth devices for 'timeout1' seconds
      sError:= 'Echec de hci_inquiry_1';
      scan_info_ptr:=@scan_info[0];
      FillByte(scan_info[0],Length(scan_info)*SizeOf(inquiry_info),0);
      flags:= IREQ_CACHE_FLUSH;
      //flags:= 0;
      found_devices
      :=
        hci_inquiry_1( Host_id, timeout1, Length(scan_info), nil, @scan_info_ptr, flags);
      if found_devices < 0 then exit;

      SetLength(FItems, found_devices);

      for i:= 0 to found_devices-1
      do
        begin
        device:= TBluetoothDevice.Create;
        PDevName:=@DevName[0];
        ba2str(@scan_info[i].bdaddr, PDevName);
        device.Dev:= PChar(PDevName);

        PRemoteName:=@RemoteName[0];
        // Read the remote name for 'timeout2' milliseconds
        if 0 > hci_read_remote_name( Host_sock,
                                     @scan_info[0].bdaddr,255,PRemoteName,timeout2)
        then
            device.Remote:= 'No remote name found, check timeout.'
        else
            device.Remote:= PChar(RemoteName);
        FItems[i]:= device;
        end;

      //c_close(Host_sock);
      hci_close_dev(Host_sock);
      Result:= True;
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

