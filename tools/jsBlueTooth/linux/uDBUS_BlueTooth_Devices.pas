unit uDBUS_BlueTooth_Devices;

{$mode ObjFPC}{$H+}

interface

uses
    uuStrings,
    uDBUS,
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
    function Initialize_V1: Boolean;
    function Initialize_V2: Boolean;
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

function TBluetoothDevices.Initialize_V1: Boolean;
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

function TBluetoothDevices.Initialize_V2:Boolean;
var
   dbus         : TDBUS;
   call         : TDBUS_Method_Call;
   reply        : TDBUS_Reply;
   Racine       : TDBUS_Iterateur;
   Niveau1      : TDBUS_Iterateur;
   Niveau2      : TDBUS_Iterateur;
   Niveau3      : TDBUS_Iterateur;
   Niveau4      : TDBUS_Iterateur;
   Niveau5      : TDBUS_Iterateur;
   Niveau6      : TDBUS_Iterateur;
   Niveau7      : TDBUS_Iterateur;
   Basic2,Basic4: PAnsiChar;
   interfaceName: String;
   device       : TBluetoothDevice;
   foundDevices : Integer;
   Basic6       : PAnsiChar;
   Basic7       : PAnsiChar;
   Basic7Child  : Byte;
   Niveau1Child,
   Niveau2Child,
   Niveau3Child: TDBUS_Iterateur;
   Niveau4Child:TDBUS_Iterateur;
   Niveau5Child: TDBUS_Iterateur;
   Niveau6Child : TDBUS_Iterateur;
   Niveau7Child : TDBUS_Iterateur;
   Basic6Child  : PAnsiChar;
   Basic2Child, Basic4Child   : PAnsiChar;
   interfaceNameChild:String;
   channelFound : Boolean;
begin
     Result:= False;
     foundDevices:= 0;
     SetLength(FItems,0);

     dbus:= TDBUS.Create;
     try
        dbus.Conn:= dbus_bus_get( DBUS_BUS_SYSTEM, @dbus.Err);
        if not Assigned(dbus.Conn)
        then
            begin
            sError:= 'Erreur DBus: Connexion échouée: '+ dbus.Err.message;;
            Exit;
            end;

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

           Niveau1:= Racine.Recurse;
           while Niveau1.ArgType = DBUS_TYPE_DICT_ENTRY
           do
             begin
             //Path /org.bluez
             Niveau2:= Niveau1.Recurse;
             if Niveau2.ArgType = DBUS_TYPE_OBJECT_PATH
             then
                 begin
                 Niveau2.GetBasic(Basic2);
                 Inc(foundDevices);
                 end
             else
                 begin
                 Niveau1.Next;
                 Continue;
                 end;


             Niveau2.Next;

             //Path /org/bluez/hci0
             //Path /org/bluez/hci0/dev_FC_58_FA_AC_FD_D6
             Niveau3:= Niveau2.Recurse;
             while Niveau3.ArgType = DBUS_TYPE_DICT_ENTRY
             do
               begin
               // org.bluez.Adapter1
               // org.bluez.Device1
               Niveau4:= Niveau3.Recurse;
               if Niveau4.ArgType = DBUS_TYPE_STRING
               then
                   begin
                   Niveau4.GetBasic(Basic4);
                   interfaceName:= StrPas(Basic4);
                   end
               else
                   interfaceName:= '';

               Niveau4.Next;

               if interfaceName = 'org.bluez.Device1'
               then
                   begin
                   device:= TBluetoothDevice.Create;
                   device.Address:= '';
                   device.Name:= '';
                   device.Channel:= 0;

                   //Address
                   Niveau5:= Niveau4.Recurse;
                   while Niveau5.ArgType = DBUS_TYPE_DICT_ENTRY
                   do
                     begin
                     Niveau6:= Niveau5.Recurse;
                     Niveau6.GetBasic(Basic6);
                     Niveau6.Next;

                     Niveau7:= Niveau6.Recurse;
                     if StrPas(Basic6) = 'Address'
                     then
                         begin
                         Niveau7.GetBasic(Basic7);
                         device.Address:= StrPas(Basic7);
                         end
                     else if StrPas(Basic6) = 'Name'
                     then
                         begin
                         Niveau7.GetBasic(Basic7);
                         device.Name:= StrPas(Basic7);
                         end;
                     Niveau5.Next;
                     end;

                    channelFound := false;
                    Niveau1Child:= Racine.Recurse;
                    while Niveau1Child.ArgType = DBUS_TYPE_DICT_ENTRY
                    do
                      begin
                      Niveau2Child:= Niveau1Child.Recurse;
                      if Niveau2Child.ArgType = DBUS_TYPE_OBJECT_PATH
                      then
                          begin
                          Niveau2Child.GetBasic(Basic2Child);
                          if Pos(StrPas(Basic2), StrPas(Basic2Child)) = 1
                          then
                              begin
                              Niveau2Child.Next;
                              Niveau3Child:= Niveau2Child.Recurse;
                              while Niveau3Child.ArgType = DBUS_TYPE_DICT_ENTRY
                              do
                                begin
                                Niveau4Child := Niveau3Child.Recurse;
                                if Niveau4Child.ArgType = DBUS_TYPE_STRING
                                then
                                    begin
                                    Niveau4Child.GetBasic(Basic4Child);
                                    interfaceNameChild := StrPas(Basic4Child);
                                    end
                                else
                                    interfaceNameChild := '';
                                Niveau4Child.Next;

                                if Niveau4Child.ArgType = DBUS_TYPE_ARRAY
                                then
                                    begin
                                    Niveau5Child := Niveau4Child.Recurse;
                                    if interfaceNameChild = 'org.bluez.SerialPort'
                                    then
                                        begin
                                        while Niveau5Child.ArgType = DBUS_TYPE_DICT_ENTRY
                                        do
                                          begin
                                          Niveau6Child := Niveau5Child.Recurse;
                                          Niveau6Child.GetBasic(Basic6Child);
                                          Niveau6Child.Next;

                                          Niveau7Child := Niveau6Child.Recurse;

                                          if StrPas(Basic6Child) = 'Channel'
                                          then
                                              begin
                                              if Niveau7Child.ArgType = DBUS_TYPE_BYTE
                                              then
                                                  begin
                                                  Niveau7Child.GetBasic(Basic7Child);
                                                  device.Channel := Basic7Child;
                                                  channelFound := true;
                                                  end;
                                              end;
                                          Niveau5Child.Next;
                                          end;
                                        end;
                                    end;
                                Niveau3Child.Next;
                                end;
                              if channelFound then Break;
                              end;
                          end;
                      Niveau1Child.Next;
                      end;

                    if device.Address <> ''
                    then
                        begin
                        SetLength(FItems, Length(FItems) + 1);
                        FItems[High(FItems)] := device
                        end
                    else
                        device.Free;
                  end;

               Niveau3.Next;
               end;

             Niveau1.Next;
             end;

           initialized := true;
           Result := true;
        finally
               reply.Free;
               end;
     finally
            call.Free;
            dbus.Free;
            end;
end;

function TBluetoothDevices.Initialize:Boolean;
begin
     Result:= Initialize_V2;
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
























































































