unit uDBUS;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, dbus, unixtype;

//--------------------------------------------------
// TDBUS : Connexion et gestion des erreurs D-Bus
//--------------------------------------------------

type
 { TDBUS }

 TDBUS
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create;
    destructor Destroy; override;
  //Connexion / Erreur
  public
    Conn: PDBusConnection;
    Err : DBusError;
    procedure InitError;
  end;

//--------------------------------------------------
// TDBUS_Method_Call : Appel méthode D-Bus
//--------------------------------------------------

type
 TDBUS_Reply =class;

 { TDBUS_Method_Call }

 TDBUS_Method_Call
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _dbus: TDBUS;
                        _Bus_Name,
                        _Path,
                        _Interface,
                        _Method: string
                        );
    destructor Destroy; override;
  //Gestion d'erreur
  public
    sError: String;
  //Appel
  private
    Msg : PDBusMessage;
    dbus  : TDBUS;
  public
    function SendAndBlock( _Timeout: Integer = 3000): TDBUS_Reply;
  end;

//--------------------------------------------------
// TDBUS_Reply : Réponse à une méthode D-Bus
//--------------------------------------------------

type
 TDBUS_Iterateur = class;
 { TDBUS_Reply }

 TDBUS_Reply
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create(_dbus: TDBUS; _Reply: PDBusMessage);
    destructor Destroy; override;
  //Gestion d'erreur
  public
    sError: String;
  //Accès
  public
    dbus   : TDBUS;
    Reply: PDBusMessage;
    function Iterateur: TDBUS_Iterateur;
  end;

//--------------------------------------------------
// TDBUS_Iterateur : Encapsule DBusMessageIter
//--------------------------------------------------

type
 { TDBUS_Iterateur }

 TDBUS_Iterateur
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create(_Iter: DBusMessageIter);
  //Itérateurs et utilitaires
  public
    Iter: DBusMessageIter;
    function Recurse: TDBUS_Iterateur;
    function ArgType: cint;
    procedure GetBasic(var _Dest);
    function Next: Boolean;
  end;

implementation

//--- TDBUS -----------------------------------------------------

constructor TDBUS.Create;
begin
     inherited Create;
     Conn:= nil;
     InitError;
end;

destructor TDBUS.Destroy;
begin
     inherited Destroy;
end;

procedure TDBUS.InitError;
begin
     dbus_error_init(@Err);
end;

//--- TDBUS_Method_Call -----------------------------------------

constructor TDBUS_Method_Call.Create( _dbus: TDBUS;
                                      _Bus_Name,
                                      _Path,
                                      _Interface,
                                      _Method: string
                                      );
begin
     inherited Create;
     dbus := _dbus;
     Msg:= dbus_message_new_method_call( PChar(_Bus_Name ),
                                         PChar(_Path     ),
                                         PChar(_Interface),
                                         PChar(_Method   )
                                         );
     if Msg = nil
     then
         sError:= 'Erreur DBus: création message, dbus_message_new_method_call'
     else
         sError:= '';
end;

destructor TDBUS_Method_Call.Destroy;
begin
     if Assigned(Msg)
     then
          dbus_message_unref(Msg);
     inherited Destroy;
end;

function TDBUS_Method_Call.SendAndBlock(_Timeout: Integer = 3000): TDBUS_Reply;
var
   Reply: PDBusMessage;
begin
     Result:= nil;
     sError:= '';

     Reply
     :=
       dbus_connection_send_with_reply_and_block( dbus.Conn,
                                                  Msg,
                                                  _Timeout,
                                                  @dbus.Err
                                                  );
     if (Reply = nil) or (dbus_error_is_set(@dbus.Err) <> 0)
     then
         sError:= 'Erreur DBus (reply), dbus_connection_send_with_reply_and_block: ' + dbus.Err.message
     else
         Result:= TDBUS_Reply.Create( dbus, Reply);
end;

//--- TDBUS_Reply -----------------------------------------------

constructor TDBUS_Reply.Create(_dbus: TDBUS; _Reply: PDBusMessage);
begin
     inherited Create;
     dbus   := _dbus;
     Reply:= _Reply;
     sError:= '';
end;

destructor TDBUS_Reply.Destroy;
begin
     if Assigned(Reply)
     then
          dbus_message_unref( Reply);
     inherited Destroy;
end;

function TDBUS_Reply.Iterateur: TDBUS_Iterateur;
var
   Iter: DBusMessageIter;
begin
     if 0 = dbus_message_iter_init( Reply, @Iter)
     then
         begin
         sError:= 'Erreur DBus, dbus_message_iter_init: structure réponse inattendue';
         Result:= nil;
         end
     else
         begin
         sError:= '';
         Result:= TDBUS_Iterateur.Create( Iter);
         end;
end;

//--- TDBUS_Iterateur -------------------------------------------

constructor TDBUS_Iterateur.Create(_Iter: DBusMessageIter);
begin
     inherited Create;
     Iter:= _Iter;
end;

function TDBUS_Iterateur.Recurse: TDBUS_Iterateur;
var
   ResultIter: DBusMessageIter;
begin
     dbus_message_iter_recurse(@Iter, @ResultIter);
     Result:= TDBUS_Iterateur.Create( ResultIter);
end;

function TDBUS_Iterateur.ArgType: cint;
begin
     Result:= dbus_message_iter_get_arg_type(@Iter);
end;

procedure TDBUS_Iterateur.GetBasic(var _Dest);
begin
     dbus_message_iter_get_basic(@Iter, @_Dest);
end;

function TDBUS_Iterateur.Next: Boolean;
begin
     Result:= dbus_message_iter_next(@Iter) <> 0;
end;

end.

