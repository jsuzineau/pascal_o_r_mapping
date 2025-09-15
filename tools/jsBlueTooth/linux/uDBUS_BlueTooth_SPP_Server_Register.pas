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
  public
    sError: String;
  end;

implementation

constructor TDBUS_BlueTooth_SPP_Server_Register.Create;
begin
     inherited Create;
     sError:= '';
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
   iOption_Name_Value: TDBUS_Iterateur;
   iOption_Role: TDBUS_Iterateur;
   reply      : TDBUS_Message;

   // Chaine ObjectPath et UUID doivent vivre assez longtemps le temps de l'appel
   NameBuf,
   RoleBuf    : array[0..255] of Char;
begin
   Result:= False;
   sError:= '';

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

      iParameters.Append_OBJECT_PATH( _objectPath);
      iParameters.Append_String     ( _uuid      );
      // Paramètre 3: options (a{sv})
      iOptions:= iParameters.open_container( DBUS_TYPE_ARRAY, '{sv}');
        iOptions.Append_DICT_String( 'Name', _serviceName);
        iOptions.Append_DICT_String( 'Role', 'server'    );
      iParameters.close_container( iOptions);

      try
         reply:= call.SendAndBlock( 3000 );
         Result:= (reply <> nil) and (reply.sError = '');
         if not Result
         then
             begin
             if reply <> nil
             then
                 sError := reply.sError
             else
                 sError := call.sError;
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

