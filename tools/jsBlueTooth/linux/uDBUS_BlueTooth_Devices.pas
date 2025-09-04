unit uDBUS_BlueTooth_Devices;

{$mode ObjFPC}{$H+}

interface

uses
    uuStrings,
  Classes, SysUtils, StdCtrls,fgl,unixtype, dbus;

// Liste tous les périphériques Bluetooth visibles/appairés sur l'ordi
type
 { TBluetoothDevice }

 TBluetoothDevice
 =
  class
   Address: string;
   Name: string;
   Channel: byte;
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

{ TBluetoothDevice }

function TBluetoothDevice.Libelle: String;
begin
     if Channel > 0
     then
         Result:= Format( 'Name: %s, Address: %s, Channel: %d', [Name, Address, Channel])
     else
         Result:= Format( 'Name: %s, Address: %s', [Name, Address]);
end;

{ TBluetoothDevices }

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
   Conn: PDBusConnection;
   Msg, Reply: PDBusMessage;
   Err: DBusError;
   Iter, DictIter, ItemIter, PropIter: DBusMessageIter;
   VariantIter, ValueIter: DBusMessageIter;
   Path: PAnsiChar;
   InterfaceName: string;
   device: TBluetoothDevice;
   found_devices: Integer;
   KeyIter, ValIter: DBusMessageIter;
   KeyStr: PAnsiChar;
   StrVal: PAnsiChar;
   channelByte: Byte;

   PropIterChild, VariantIterChild, ValueIterChild: DBusMessageIter;
   KeyIterChild, ValIterChild: DBusMessageIter;
   KeyStrChild: PAnsiChar;
   PathChild: PAnsiChar;
   InterfaceNameChild: string;
   ChannelFound: Boolean;

begin
     Result := False;
     initialized := False;

     dbus_error_init(@Err);
     Conn := dbus_bus_get(DBUS_BUS_SYSTEM, @Err);
     if Conn = nil
     then
         begin
         sError := 'Erreur DBus: ' + Err.message;
         Exit;
         end;

     // Appel GetManagedObjects sur le service org.bluez
     Msg := dbus_message_new_method_call('org.bluez', '/', 'org.freedesktop.DBus.ObjectManager', 'GetManagedObjects');
     if Msg = nil
     then
         begin
         sError := 'Erreur DBus: création message, dbus_message_new_method_call';
         Exit;
         end;

     Reply := dbus_connection_send_with_reply_and_block(Conn, Msg, 3000, @Err);
     dbus_message_unref(Msg);
     if (Reply = nil) or (dbus_error_is_set(@Err) <> 0)
     then
         begin
         sError := 'Erreur DBus (reply), dbus_connection_send_with_reply_and_block: ' + Err.message;
         Exit;
         end;

     // Init itérateur
     if 0 = dbus_message_iter_init(Reply, @Iter)
     then
         begin
         sError := 'Erreur DBus, dbus_message_iter_init: structure réponse inattendue';
         dbus_message_unref(Reply);
         Exit;
         end;

     // Parcours le dictionnaire (a{oa{sa{sv}}})
     dbus_message_iter_recurse(@Iter, @DictIter);

     found_devices := 0;
     SetLength(FItems, 0);

     while DBUS_TYPE_DICT_ENTRY = dbus_message_iter_get_arg_type(@DictIter)
     do
       begin
       dbus_message_iter_recurse(@DictIter, @ItemIter);
       // Première entrée : chemin de l'objet
       if dbus_message_iter_get_arg_type(@ItemIter) = DBUS_TYPE_OBJECT_PATH
       then
           begin
           dbus_message_iter_get_basic(@ItemIter, @Path); // path = /org/bluez/hci0/dev_XX_XX_XX_XX_XX_XX
           Inc(found_devices);
           end
       else
           begin
           dbus_message_iter_next(@DictIter);
           Continue;
           end;

       dbus_message_iter_next(@ItemIter); // Va vers le dictionnaire d'interfaces

       // Parcours des interfaces de l'objet
       dbus_message_iter_recurse(@ItemIter, @PropIter);

       while DBUS_TYPE_DICT_ENTRY = dbus_message_iter_get_arg_type(@PropIter)
       do
         begin
         dbus_message_iter_recurse(@PropIter, @VariantIter);
         // Interface name
         if dbus_message_iter_get_arg_type(@VariantIter) = DBUS_TYPE_STRING
         then
             begin
             dbus_message_iter_get_basic(@VariantIter, @Path); // Interface name comme chaîne (bizarrement stockée dans Path ici)
             InterfaceName := StrPas(Path);
             end
         else
             InterfaceName := '';

         dbus_message_iter_next(@VariantIter); // Vers le dictionnaire des propriétés (a{sv})

         if InterfaceName = 'org.bluez.Device1'
         then
             begin
             dbus_message_iter_recurse(@VariantIter, @ValueIter);

             device := TBluetoothDevice.Create;
             device.Name := '';
             device.Address := '';
             device.Channel := 0;  // Initialisation

             // Ensuite, boucler sur chaque propriété...
             while DBUS_TYPE_DICT_ENTRY = dbus_message_iter_get_arg_type(@ValueIter)
             do
               begin
               dbus_message_iter_recurse(@ValueIter, @KeyIter);
               dbus_message_iter_get_basic(@KeyIter, @KeyStr); // Propriété ("Address", "Name", etc.)
               dbus_message_iter_next(@KeyIter);
               dbus_message_iter_recurse(@KeyIter, @ValIter);

               if StrPas(KeyStr) = 'Address'
               then
                   begin
                   dbus_message_iter_get_basic(@ValIter, @StrVal);
                   device.Address := StrPas(StrVal);
                   end
               else if StrPas(KeyStr) = 'Name'
               then
                   begin
                   dbus_message_iter_get_basic(@ValIter, @StrVal);
                   device.Name := StrPas(StrVal);
                   end;

               dbus_message_iter_next(@ValueIter);
               end;

             // Recherche des canaux RFCOMM dans les interfaces enfants du device (services)
             // Parcours dictionnaire d’objets encore (Proxy DBus)

             // Parcourir sous-objets enfants (services) liés à cet objet device
             // C’est le DictIter (principal) qui contient tous les objets, on cherche qui ont un préfixe correspondant à device

             // Parcours des objets pour vérifier les services enfants
             // Comme le code fait une seule passe du GetManagedObjects, parcourir DictIter dans la boucle externe ci-dessous

             ChannelFound := False;

             // Pour parcourir enfants liés au device (avec chemin commençant par Path)
             dbus_message_iter_recurse(@Iter, @DictIter);

             while DBUS_TYPE_DICT_ENTRY = dbus_message_iter_get_arg_type(@DictIter)
             do
               begin
               dbus_message_iter_recurse(@DictIter, @ItemIter);

               if dbus_message_iter_get_arg_type(@ItemIter) = DBUS_TYPE_OBJECT_PATH
               then
                   begin
                   dbus_message_iter_get_basic(@ItemIter, @PathChild);
                   if Pos(StrPas(Path), StrPas(PathChild)) = 1
                   then // enfant du device
                       begin
                       dbus_message_iter_next(@ItemIter);
                       dbus_message_iter_recurse(@ItemIter, @PropIterChild);

                       while DBUS_TYPE_DICT_ENTRY = dbus_message_iter_get_arg_type(@PropIterChild)
                       do
                         begin
                         dbus_message_iter_recurse(@PropIterChild, @VariantIterChild);
                         if dbus_message_iter_get_arg_type(@VariantIterChild) = DBUS_TYPE_STRING
                         then
                             begin
                             dbus_message_iter_get_basic(@VariantIterChild, @Path);
                             InterfaceNameChild := StrPas(Path);
                             end
                         else
                             InterfaceNameChild := '';

                         dbus_message_iter_next(@VariantIterChild);

                         if DBUS_TYPE_ARRAY = dbus_message_iter_get_arg_type(@VariantIterChild)
                         then
                             begin
                             dbus_message_iter_recurse(@VariantIterChild, @ValueIterChild);

                             if InterfaceNameChild = 'org.bluez.SerialPort'
                             then
                                 begin
                                 while DBUS_TYPE_DICT_ENTRY = dbus_message_iter_get_arg_type(@ValueIterChild)
                                 do
                                   begin
                                   dbus_message_iter_recurse(@ValueIterChild, @KeyIterChild);
                                   dbus_message_iter_get_basic(@KeyIterChild, @KeyStrChild);
                                   dbus_message_iter_next(@KeyIterChild);
                                   dbus_message_iter_recurse(@KeyIterChild, @ValIterChild);
                                   if StrPas(KeyStrChild) = 'Channel'
                                   then
                                       begin
                                       if dbus_message_iter_get_arg_type(@ValIterChild) = DBUS_TYPE_BYTE
                                       then
                                           begin
                                           dbus_message_iter_get_basic(@ValIterChild, @channelByte);
                                           device.Channel := channelByte;
                                           ChannelFound := True;
                                           end;
                                       end;
                                   dbus_message_iter_next(@ValueIterChild);
                                   end;
                                 end;
                             end;

                         dbus_message_iter_next(@PropIterChild);
                         end;

                       if ChannelFound then Break;
                       end;
                   end;
               dbus_message_iter_next(@DictIter);
               end;

             // Ajoute device si on a au moins l'addresse:
             if device.Address <> ''
             then
                 begin
                 SetLength(FItems, Length(FItems)+1);
                 FItems[High(FItems)] := device;
                 end
             else
                 device.Free;
             end;

         dbus_message_iter_next(@PropIter); // Prochaine interface
       end;
       dbus_message_iter_next(@DictIter); // Prochain objet
     end;

     dbus_message_unref(Reply);

     initialized := True;
     Result := True;
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

