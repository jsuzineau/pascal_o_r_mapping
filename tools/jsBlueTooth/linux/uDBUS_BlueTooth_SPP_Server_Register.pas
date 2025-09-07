unit uDBUS_BlueTooth_SPP_Server_Register;

{$mode ObjFPC}{$H+}

interface

uses
   uDBUS,
   Classes, SysUtils, dbus, unixtype;

type
 { TDBUS_BlueTooth_SPP_Server_Register }

 TDBUS_BlueTooth_SPP_Server_Register
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Méthode d'enregistrement
  public
    function Register( _objectPath: String;
                                    _serviceName: String;
                                    _uuid: String = '00001101-0000-1000-8000-00805F9B34FB'
                                    ): Boolean;
  //Erreur
  private
    FLastError: String;
  public
    property LastError: String read FLastError;
  end;

implementation

constructor TDBUS_BlueTooth_SPP_Server_Register.Create;
begin
   inherited Create;
   FLastError:= '';
end;

destructor TDBUS_BlueTooth_SPP_Server_Register.Destroy;
begin
   inherited Destroy;
end;

// Enregistrement du profil Serial Port (SPP) via RegisterProfile D-Bus
function TDBUS_BlueTooth_SPP_Server_Register.Register( _objectPath: String;
                                                       _serviceName: String;
                                                       _uuid: String
                                                       ): Boolean;
var
   dbus       : TDBUS;
   call       : TDBUS_Method_Call;
   iParameters: TDBUS_Iterateur;
   iOptions   : TDBUS_Iterateur;
   iOption_Name: TDBUS_Iterateur;
   iOption_Role: TDBUS_Iterateur;
   reply      : TDBUS_Reply;

   // Chaine ObjectPath et UUID doivent vivre assez longtemps le temps de l'appel
   NameBuf,
   RoleBuf    : array[0..255] of Char;
begin
   Result:= False;
   FLastError:= '';

   dbus := TDBUS.Create;
   try
      // La plupart des options SDP sont déduites par BlueZ, on renseigne le minimum
      // Format D-Bus RegisterProfile(o sa{sv})
      call := TDBUS_Method_Call.Create(
                  dbus,
                  'org.bluez',
                  '/org/bluez',
                  'org.bluez.ProfileManager1',
                  'RegisterProfile'
               );

      iParameters:= call.Parameters_append;

      // Paramètre 1: ObjectPath (le chemin D-Bus exporté de votre Profile1)
      iParameters.AppendBasic_String( DBUS_TYPE_OBJECT_PATH, _objectPath);

      // Paramètre 2: profil UUID de Serial Port
      iParameters.AppendBasic_String( DBUS_TYPE_STRING, _uuid);

      // Paramètre 3: options (a{sv})
      iOptions:= iParameters.open_container( DBUS_TYPE_ARRAY, '{sv}');
        // Option "Name"
        iOption_Name:= iOptions.open_container( DBUS_TYPE_DICT_ENTRY, nil);
          iOption_Name.AppendBasic_String( DBUS_TYPE_STRING, 'Name');
          iOption_Name.AppendBasic_String( DBUS_TYPE_VARIANT, _serviceName);
        iOptions.close_container( iOption_Name);

        // Option "Role" (obligatoire: 'server')
        iOption_Role:= iOptions.open_container( DBUS_TYPE_DICT_ENTRY, nil);
          iOption_Role.AppendBasic_String( DBUS_TYPE_STRING, 'Role');
          iOption_Role.AppendBasic_String( DBUS_TYPE_VARIANT, 'server');
        iOptions.close_container( iOption_Role);
      iParameters.close_container( iOptions);

      try
         reply:= call.SendAndBlock( 3000 );
         Result:= (reply <> nil) and (reply.sError = '');
         if not Result
         then
             begin
             if reply <> nil
             then
                 FLastError := reply.sError
             else
                 FLastError := call.sError;
             end;
      finally
             FreeAndNil( reply);
             end;
   finally
          FreeAndNil( call);
          FreeAndNil( dbus);
   end;
end;

end.

