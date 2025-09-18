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
    constructor Create( _dbus: TDBUS;
                        _ObjectPath: String;
                        _ServiceName: String);
    destructor Destroy; override;
  //D-Bus
  private
    dbus      : TDBUS;
  //ObjectPath
  public
    ObjectPath: String;
  //ServiceName
  public
    ServiceName: String;
  //uuid
  public
    uuid: String;
  //Channel
  public
    Channel: cuint16;
  //Gestion d'erreur
  public
    sError: String;
  //DBUS_Object
  private
    Object_: TDBUS_Object;
  //Register
  private
    function DBUS_Register: Boolean;
    function Bluez_Register: Boolean; //RegisterProfile in Bluez
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


function GenerateUUID: string;
var
   Guid: TGUID;
begin
     if CreateGUID(Guid) = 0
     then
         begin
         Result := GUIDToString(Guid);
         Delete(Result,Length(Result),1);
         Delete(Result,1,1);
         end
     else
         Result := '';
end;

{ TBlueTooth_Profile }

constructor TBlueTooth_Profile.Create( _dbus: TDBUS;
                                       _ObjectPath: String;
                                       _ServiceName: String);
begin
     inherited Create;

     dbus       := _dbus;
     ObjectPath := _ObjectPath;
     ServiceName:= _ServiceName;
     uuid       := '00001101-0000-1000-8000-00805f9b34fb';//GenerateUUID;
     Channel    := 14;

     sError:= '';
     Object_:= nil;

     DBUS_Register;
     Bluez_Register;
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

function TBlueTooth_Profile.DBUS_Register: Boolean;
begin
     Object_:= TDBUS_Object.Create( Self, dbus, ObjectPath, @DBusObjectPathMessage);
     Result:= Object_.sError = '';
     if not Result
     then
         uDBUS_Log(  'TBlueTooth_Profile.DBUS_Register:'#13#10
                    +'  erreur de TDBUS_Object.Create:'
                    +'    '+Object_.sError);
end;

function TBlueTooth_Profile.Bluez_Register: Boolean;
var
   call       : TDBUS_Method_Call;
   iParameters: TDBUS_Iterateur;
   iOptions   : TDBUS_Iterateur;
   iOption_Name: TDBUS_Iterateur;
   iOption_Name_Value: TDBUS_Iterateur;
   iOption_Role: TDBUS_Iterateur;
   reply      : TDBUS_Message;
   RequireAuthentication: dbus_bool_t;
   RequireAuthorization : dbus_bool_t;
   AutoConnect          : dbus_bool_t;
begin
      Result:= False;
      sError:= '';
      RequireAuthentication:= 0;
      RequireAuthorization := 0;
      AutoConnect          := 0;

      // La plupart des options SDP sont déduites par BlueZ, on renseigne le minimum
      // Format D-Bus RegisterProfile(o sa{sv})
      call := TDBUS_Method_Call.Create( dbus,
                                        'org.bluez',
                                        '/org/bluez',
                                        'org.bluez.ProfileManager1',
                                        'RegisterProfile'
                                        );
      try
         iParameters:= call.Parameters_append;

         iParameters.Append_OBJECT_PATH( ObjectPath);
         iParameters.Append_String     ( uuid      );
         // Paramètre 3: options (a{sv})
         iOptions:= iParameters.open_container( DBUS_TYPE_ARRAY, '{sv}');
           iOptions.Append_DICT_String     ( 'Name'                 , ServiceName          );
           iOptions.Append_DICT_String     ( 'Role'                 , 'server'             );
           iOptions.Append_DICT_dbus_bool_t( 'RequireAuthentication', RequireAuthentication);
           iOptions.Append_DICT_dbus_bool_t( 'RequireAuthorization' , RequireAuthorization );
           iOptions.Append_DICT_dbus_bool_t( 'AutoConnect'          , AutoConnect          );
           //iOptions.Append_DICT_cuint16    ( 'Channel'              , Channel              );
         iParameters.close_container( iOptions);

         try
            reply:= call.SendAndBlock( 3000 );
            Result:= Assigned( reply);
            if not Result
            then
                sError := call.sError
            else
                begin
                Result:= reply.sError = '';
                if not Result
                then
                    sError := reply.sError;
                end;
         finally
                FreeAndNil( reply);
                end;
      finally
             FreeAndNil( call);
             end;
     if Result
     then
         uDBUS_Log(  'TBlueTooth_Profile.Bluez_Register:'#13#10
                    +'  ObjectPath :'+ObjectPath +#13#10
                    +'  uuid       :'+uuid       +#13#10
                    +'  ServiceName:'+ServiceName+#13#10
                    //+'  Channel    :'+IntToStr(Channel)+#13#10
                    )
     else
         uDBUS_Log(  'TBlueTooth_Profile.Bluez_Register:'#13#10
                    +'  erreur lors de RegisterProfile:'#13#10
                    +'    '+sError+#13#10
                    +'  ObjectPath :'+ObjectPath +#13#10
                    +'  uuid       :'+uuid       +#13#10
                    +'  ServiceName:'+ServiceName+#13#10
                    //+'  Channel    :'+IntToStr(Channel)+#13#10
                    );
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
     c.WriteString( 'Hello from Linux !');
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
   procedure Do_org_freedesktop_DBus_Properties_GetAll;
   var
      Reply: TDBUS_Message;
      iParameters: TDBUS_Iterateur;
      iArray: TDBUS_Iterateur;
   begin
        Reply:= _Message.Reply;
        try
           iParameters:= Reply.Parameters_append;
           iArray:= iParameters.open_container( DBUS_TYPE_ARRAY, 'a{sv}');
           iParameters.close_container(iArray);
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
   procedure Do_org_freedesktop_DBus_Properties;
   begin
        if 'GetAll' = Method then Do_org_freedesktop_DBus_Properties_GetAll;
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
     else if 'org.freedesktop.DBus.Introspectable' = Interface_ then Do_org_freedesktop_DBus_Introspectable
     else if 'org.freedesktop.DBus.Properties'     = Interface_ then Do_org_freedesktop_DBus_Properties;
end;

end.

