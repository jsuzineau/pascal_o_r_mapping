unit uDBUS_BlueTooth_Profile;

{$mode ObjFPC}{$H+}

interface

uses
    uDBUS, uBlueZ_BlueTooth_Client,
   Classes, SysUtils, dbus, unixtype,Contnrs;

type
 { TBlueTooth_Profile }

 TBlueTooth_Profile
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _dbus: TDBUS; _ObjectPath: String);
    destructor Destroy; override;
  //D-Bus
  private
    dbus      : TDBUS;
  //ObjectPath
  public
    ObjectPath: String;
  //DBUS_Object
  private
    Object_: TDBUS_Object;
  //liste des clients
  private
    clients: TFPHashObjectList;
    procedure clients_Ajoute( _device_path: String; _Socket: cint);
  //Gestion des appels DBus (squelette minimal)
  private
    procedure Handle_Release;
    procedure Handle_RequestDisconnection( _path: String );
    procedure Handle_NewConnection( _device_path: String;
                                    _fd: Integer;
                                    _fd_properties: Pointer // à adapter pour support des dictionnaires
                                    );
  public
    function HandleMessage( _Message: TDBUS_Message): DBusHandlerResult;
  end;

implementation

uses
   BaseUnix;

function DBusObjectPathMessage( _connection: PDBusConnection;
                                _Message: PDBusMessage;
                                _user_data: Pointer): DBusHandlerResult; cdecl;
var
   O: TObject;
   p: TBlueTooth_Profile;
   Message: TDBUS_Message;
begin
     Result:= DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
     uDBUS_Log( 'DBusObjectPathMessage');
     if nil = _user_data then exit;

     O:= TObject( _user_data);
     if not (O is TBlueTooth_Profile) then exit;

     Message:= TDBUS_Message.Create( _Message);
     try
        p:= TBlueTooth_Profile( O);
        Result:= p.HandleMessage( Message);
     finally
            FreeAndNil( Message);
            end;
end;


{ TBlueTooth_Profile }

constructor TBlueTooth_Profile.Create( _dbus: TDBUS;
                                       _ObjectPath: String);
begin
     inherited Create;
     dbus      := _dbus;
     ObjectPath:= _ObjectPath;
     Object_:= TDBUS_Object.Create( Self, dbus, ObjectPath, @DBusObjectPathMessage);
     if Object_.sError <> ''
     then
         uDBUS_Log(  'TBlueTooth_Profile.Create:'#13#10
                    +'  erreur de TDBUS_Object.Create:'
                    +'    '+Object_.sError);
     clients:= TFPHashObjectList.Create;
     uDBUS_Log(  'TBlueTooth_Profile.Create:'#13#10
                +'  '+ObjectPath);
end;

destructor TBlueTooth_Profile.Destroy;
begin
     FreeAndNil( clients);
     FreeAndNil( Object_);
     inherited Destroy;
end;

//=================================================
// Gestion des clients RFCOMM (FDs reçus)
//=================================================

procedure TBlueTooth_Profile.clients_Ajoute( _device_path: String; _Socket: cint);
var
   L: Integer;
   c: TBluetooth_Client;
begin
     c:= TBluetooth_Client.Create;
     c.Socket:= _Socket;
     clients.Add( _device_path, c);
end;

//=================================================
// HANDLERS Profile1 (Release/NewConnection/Disconnection)
//=================================================

procedure TBlueTooth_Profile.Handle_Release;
begin
     clients.Clear;
end;

// Méthode D-Bus: org.bluez.Profile1.RequestDisconnection
procedure TBlueTooth_Profile.Handle_RequestDisconnection( _path: String );
var
   i: Integer;
begin
     i:= clients.FindIndexOf( _path);
     if -1 = i then exit;
     clients.Delete( i);
end;

// Méthode D-Bus: org.bluez.Profile1.NewConnection
procedure TBlueTooth_Profile.Handle_NewConnection( _device_path: String;
                                                   _fd: Integer;
                                                   _fd_properties: Pointer
                                                   );
begin
     // BlueZ fournit le _fd du socket RFCOMM : le passer au TBluetooth_Server
     clients_Ajoute( _device_path, _fd);
end;

function TBlueTooth_Profile.HandleMessage(_Message: TDBUS_Message): DBusHandlerResult;
var
   Interface_: String;
   Method    : String;

   procedure Do_Release;
   begin
        Handle_Release;
        Result:= DBUS_HANDLER_RESULT_HANDLED;
   end;
   procedure Do_NewConnection;
   var
        iMessage,
        var_fdprops: TDBUS_Iterateur;
        device_path: String;
        fd: Integer;
        unixfdarr: array[0..63] of cint;
        nfd: Integer;
   begin
        // Initialisation
        device_path:= '';
        fd:= -1;

        // 1. Récupérer l'itérateur principal (signature s h a{sv})
        iMessage:= _Message.Iterateur;

        // Device Path
        if iMessage.ArgType = DBUS_TYPE_OBJECT_PATH
        then
            begin
            device_path:= iMessage.Basic_String;
            iMessage.Next;
            end;

        // File descriptor (handle/sock)
        if iMessage.ArgType = DBUS_TYPE_UNIX_FD
        then
            begin
            fd:= iMessage.Basic_cint;
            iMessage.Next;
            end
        else if iMessage.ArgType = DBUS_TYPE_ARRAY
        then
            begin
             // Certains BlueZ renvoient un fd dans un tableau (cas rare, à vérifier)
             nfd:=0;
             while (iMessage.ArgType = DBUS_TYPE_UNIX_FD)
             do
               begin
               fd:= iMessage.Basic_cint;
               inc(nfd);
               iMessage.Next;
               end;
             end;

        // a{sv} : on avance sans rien parser ici mais on peut faire :
        if iMessage.ArgType = DBUS_TYPE_ARRAY
        then
            begin
            var_fdprops:= iMessage.Recurse;
            // (tu peux parser le dictionnaire si besoin)
            // Pour l'instant, on ne fait rien
            end;

        // Appel méthode principale serveur
        Handle_NewConnection( device_path, fd, nil );
        Result:= DBUS_HANDLER_RESULT_HANDLED;
   end;
   procedure Do_RequestDisconnection;
   begin
        Handle_RequestDisconnection('');
        Result:= DBUS_HANDLER_RESULT_HANDLED;
   end;
   procedure Do_Introspect;
   const
        XML=
 '<!DOCTYPE node PUBLIC "-//freedesktop//DTD D-BUS Object Introspection 1.0//EN"'#13#10
+' "http://www.freedesktop.org/standards/dbus/1.0/introspect.dtd">              '#13#10
+'<node>                                                                        '#13#10
+'  <interface name="org.bluez.Profile1">                                       '#13#10
+'    <method name="Release" />                                                 '#13#10
+'    <method name="NewConnection">                                             '#13#10
+'      <arg direction="in" type="o" name="device" />                           '#13#10
+'      <arg direction="in" type="h" name="fd" />                               '#13#10
+'      <arg direction="in" type="a{sv}" name="options" />                      '#13#10
+'    </method>                                                                 '#13#10
+'    <method name="RequestDisconnection">                                      '#13#10
+'      <arg direction="in" type="o" name="device" />                           '#13#10
+'    </method>                                                                 '#13#10
+'  </interface>                                                                '#13#10
+'  <interface name="org.freedesktop.DBus.Introspectable">                      '#13#10
+'    <method name="Introspect">                                                '#13#10
+'      <arg direction="out" type="s" />                                        '#13#10
+'    </method>                                                                 '#13#10
+'  </interface>                                                                '#13#10
+'</node>                                                                       '#13#10;
   var
      Reply: TDBUS_Message;
       iParameters: TDBUS_Iterateur;
   begin
        Reply:= _Message.Reply;
        try
           iParameters:= Reply.Parameters_append;
           iParameters.Append_String( XML);
           dbus.Send( Reply);
        finally
               FreeAndNil( Reply);
               end;
   end;
   procedure Do_org_bluez_Profile1;
   begin
             if 'Release'              = Method then Do_Release
        else if 'NewConnection'        = Method then Do_NewConnection
        else if 'RequestDisconnection' = Method then Do_RequestDisconnection;
   end;
   procedure Do_org_freedesktop_DBus_Introspectable;
   begin
        if 'Introspect' = Method then Do_Introspect;
   end;
begin
     Result:= DBUS_HANDLER_RESULT_NOT_YET_HANDLED;

     Interface_:= _Message.Interface_;
     Method    := _Message.Member    ;
     uDBUS_Log(  'TBlueTooth_Profile.HandleMessage:'#13#10
                +'  interface:'+Interface_+#13#10
                +'  Method   :'+Method+#13#10
                );
          if 'org.bluez.Profile1'                  = Interface_ then Do_org_bluez_Profile1
     else if 'org.freedesktop.DBus.Introspectable' = Interface_ then Do_org_freedesktop_DBus_Introspectable;
end;

end.

