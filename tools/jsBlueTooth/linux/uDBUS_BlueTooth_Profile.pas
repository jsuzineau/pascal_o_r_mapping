unit uDBUS_BlueTooth_Profile;

{$mode ObjFPC}{$H+}

interface

uses
    uDBUS, uBlueZ_BlueTooth_Client,
   Classes, SysUtils, dbus, unixtype, ExtCtrls, Contnrs; // Contnrs pour la table d’export

type
 { TBlueTooth_Profile }

 TBlueTooth_Profile
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _dbus_conn: TDBUS;
                        _objectPath: String);
    destructor Destroy; override;
  //D-Bus
  private
    dbus      : TDBUS;
  //objectPath
  private
    objectPath: String;
  public
    property DBusObjectPath: String read objectPath;
  //Pour callback D-Bus loop (simple, peut être amélioré)
  private
    t: TTimer;
    procedure t_Timer(Sender: TObject);
    function ProcessDBusMessages: Boolean;
  //liste des clients
  private
    clients: TFPHashObjectList;
    procedure clients_Ajoute( _device_path: String; _Socket: cint);
  //Gestion des appels DBus (squelette minimal)
  public
    procedure Handle_Release;
    procedure Handle_RequestDisconnection( _path: String );
    procedure Handle_NewConnection( _device_path: String;
                                    _fd: Integer;
                                    _fd_properties: Pointer // à adapter pour support des dictionnaires
                                    );
  end;

// Table globale et registration
//procedure RegisterDBusProfile1Object( const _objectPath: String;
//                                      _instance: TBlueTooth_Profile
//                                      );
//procedure UnregisterDBusProfile1Object( const _objectPath: String );
//function FindDBusProfile1Object(const _objectPath: String): TBlueTooth_Profile;

procedure uDBUS_BlueTooth_Profile_Abonne( _dbus: TDBUS);

implementation

uses
   BaseUnix;

// Table globale pour rattacher les chemins D-Bus à une instance de Profile
var
   DBUS_Profile1_Objects: TFPHashObjectList = nil;

procedure RegisterDBusProfile1Object( const _objectPath: String;
                                      _instance: TBlueTooth_Profile
                                      );
begin
     if nil = DBUS_Profile1_Objects
     then
         DBUS_Profile1_Objects:= TFPHashObjectList.Create( True );
     if -1 = DBUS_Profile1_Objects.FindIndexOf(_objectPath)
     then
         DBUS_Profile1_Objects.Add( _objectPath, _instance );
end;

procedure UnregisterDBusProfile1Object( const _objectPath: String );
var
   i: Integer;
begin
     if nil = DBUS_Profile1_Objects then exit;

     i:= DBUS_Profile1_Objects.FindIndexOf( _objectPath);
     if -1 = i then exit;

     DBUS_Profile1_Objects.Delete( i);
end;

function FindDBusProfile1Object(const _objectPath: String): TBlueTooth_Profile;
begin
     Result:= nil;
     if Assigned(DBUS_Profile1_Objects)
     then
          Result:= TBlueTooth_Profile(DBUS_Profile1_Objects.Find(_objectPath));
end;


{ TBlueTooth_Profile }

constructor TBlueTooth_Profile.Create( _dbus_conn: TDBUS;
                                       _objectPath: String);
begin
     inherited Create;
     dbus      := _dbus_conn;
     objectPath:= _objectPath;
     t:= TTimer.Create( nil);
     t.Interval:= 250;
     t.OnTimer:= @t_Timer;
     t.Enabled:= True;
     clients:= TFPHashObjectList.Create;
     RegisterDBusProfile1Object( objectPath, Self );
end;

destructor TBlueTooth_Profile.Destroy;
begin
     FreeAndNil( clients);
     FreeAndNil( t);
     UnregisterDBusProfile1Object(objectPath);
     inherited Destroy;
end;

//=================================================
// Gestion Timer : boucle DBus
//=================================================

procedure TBlueTooth_Profile.t_Timer(Sender: TObject);
begin
     t.Enabled:= False;
     ProcessDBusMessages;
     t.Enabled:= True;
end;

function TBlueTooth_Profile.ProcessDBusMessages: Boolean;
begin
     Result:= dbus.HasMessage;
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

//=================================================
// DISPATCH central : reçoit n’importe quel message "Profile1" et redirige
//=================================================
function DBus_Profile1_GlobalDispatch( _connection: PDBusConnection;
                                       _Message: PDBusMessage;
                                       _user_data: Pointer): DBusHandlerResult; cdecl;
var
   Message: TDBUS_Message;
   path      : PChar;
   iface     : PChar;
   method    : PChar;
   sPath     : String;
   sInterface: String;
   sMethod: String;
   profile: TBlueTooth_Profile;
     fd        : cint;
     devPath   : PChar;
   procedure Do_Release;
   begin
        profile.Handle_Release;
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
        iMessage:= Message.Iterateur;

        // Device path
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
        profile.Handle_NewConnection( device_path, fd, nil );
        Result:= DBUS_HANDLER_RESULT_HANDLED;
   end;
   procedure Do_RequestDisconnection;
   begin
        profile.Handle_RequestDisconnection('');
        Result:= DBUS_HANDLER_RESULT_HANDLED;
   end;
begin
     Result:= DBUS_HANDLER_RESULT_NOT_YET_HANDLED;

     Message:= TDBUS_Message.Create( _Message);
     // On récupère le chemin, l’interface et la méthode
     path   := dbus_message_get_path( _Message );
     iface  := dbus_message_get_interface( _Message );
     method := dbus_message_get_member( _Message );

     if (path = nil) or (iface = nil) or (method = nil) then Exit;
     sPath:= StrPas(path);

     profile := FindDBusProfile1Object(sPath);
     if nil = profile then Exit;

     sInterface:= StrPas(iface );
     sMethod   := StrPas(method);

     if 'org.bluez.Profile1' = sInterface
     then
         begin
               if 'Release'              = sMethod then Do_Release
          else if 'NewConnection'        = sMethod then Do_NewConnection
          else if 'RequestDisconnection' = sMethod then Do_RequestDisconnection;
         end;
end;

procedure uDBUS_BlueTooth_Profile_Abonne(_dbus: TDBUS);
begin
     _dbus.Abonne( @DBus_Profile1_GlobalDispatch);
end;

initialization
              //DBUS_Profile1_Objects:= TFPHashObjectList.Create;
finalization
            FreeAndNil( DBUS_Profile1_Objects);
end.

