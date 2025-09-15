unit uDBUS;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, dbus, unixtype;

const
     DBUS_TYPE_UNIX_FD= Integer('h');
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
  //Erreur
  public
    Error: DBusError;
    procedure InitError;
    function Error_is_set: Boolean;
  //Connexion
  private
    FConn: PDBusConnection;
    function GetConn: PDBusConnection;
  public
    property Conn: PDBusConnection read GetConn;
  //HasMessage
  public
    function HasMessage: Boolean;
  //Abonnement à des messages
  public
    procedure Abonne( _message_handler: DBusHandleMessageFunction);
  end;

//--------------------------------------------------
// TDBUS_Method_Call : Appel méthode D-Bus
//--------------------------------------------------

type
 TDBUS_Iterateur = class;
 TDBUS_Message =class;

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
  //Paramètres
  public
    function Parameters_append: TDBUS_Iterateur;
  //Appel
  private
    Msg : PDBusMessage;
    dbus  : TDBUS;
  public
    function SendAndBlock( _Timeout: Integer = 3000): TDBUS_Message;
  end;

//--------------------------------------------------
// TDBUS_Reply : Réponse à une méthode D-Bus
//--------------------------------------------------

type
 { TDBUS_Message }

 TDBUS_Message
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _Message: PDBusMessage);
    destructor Destroy; override;
  //Attributs
  private
    Message: PDBusMessage;
  //Gestion d'erreur
  public
    sError: String;
  //Accès
  public
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
    destructor Destroy; override;
  //Type
  public
    function ArgType: cint;
  //Lecture Basic
  public
    procedure GetBasic(var _Dest);
    function Basic_String: String;
    function Basic_Byte: Byte;
    function Basic_cint: cint;
  //Ajout Basic
  private
    Basic_Strings: array of PChar;
    procedure Basic_Strings_Libere;
    function Basic_Strings_Add(_s: String): PPChar;
  public
    procedure AppendBasic(_type: cint; _Source: Pointer);
    procedure AppendBasic_type_String(_type: cint; _S: String);
    procedure Append_OBJECT_PATH( _S: String);
    procedure Append_String( _S: String);
  //Ajout variant
  public
    procedure Append_Variant_String( _S: String);
  //Ajout entrée de DICT
  public
    procedure Append_DICT_String( _Name, _Value: String);
  //itération
  private
    Iter: DBusMessageIter;
  public
    function Next: Boolean;
  //sous itérateur
  public
    function Recurse: TDBUS_Iterateur;
  //ajout de container
  public
    function open_container( _type: cint; const _contained_signature: PChar): TDBUS_Iterateur;
    procedure close_container( _sub: TDBUS_Iterateur);
  end;

implementation

//--- TDBUS -----------------------------------------------------

constructor TDBUS.Create;
begin
     inherited Create;
     FConn:= nil;
     InitError;
end;

destructor TDBUS.Destroy;
begin
     inherited Destroy;
end;

procedure TDBUS.InitError;
begin
     dbus_error_init(@Error);
end;

function TDBUS.Error_is_set: Boolean;
begin
     Result:= dbus_error_is_set(@Error) <> 0;
end;

function TDBUS.GetConn: PDBusConnection;
begin
     Result:= nil;
     if nil = FConn
     then
         begin
         FConn:= dbus_bus_get( DBUS_BUS_SYSTEM, @Error);
         if nil = FConn
         then
             raise Exception.Create('Erreur de la connexion à DBus: '+ Error.message);
         end;
     Result:= FConn;
end;

function TDBUS.HasMessage: Boolean;
begin
     Result:= False;
     if nil = Conn then Exit;
     Result:= dbus_connection_read_write_dispatch( Conn, 0) <> 0;
end;

procedure TDBUS.Abonne(_message_handler: DBusHandleMessageFunction);
begin
     // À ajouter dans l’initialisation du serveur D-Bus de ton application
     dbus_connection_add_filter( Conn, _message_handler, nil, nil );
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

function TDBUS_Method_Call.Parameters_append: TDBUS_Iterateur;
var
   Iter: DBusMessageIter;
begin
     dbus_message_iter_init_append(Msg, @Iter);
     sError:= '';
     Result:= TDBUS_Iterateur.Create( Iter);
end;

function TDBUS_Method_Call.SendAndBlock(_Timeout: Integer = 3000): TDBUS_Message;
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
                                                  @dbus.Error
                                                  );
     if (Reply = nil) or dbus.Error_is_set
     then
         sError:= 'Erreur DBus (reply), dbus_connection_send_with_reply_and_block: ' + dbus.Error.message
     else
         Result:= TDBUS_Message.Create( Reply);
end;

//--- TDBUS_Message -----------------------------------------------

constructor TDBUS_Message.Create(_Message: PDBusMessage);
begin
     inherited Create;
     Message:= _Message;
     sError:= '';
end;

destructor TDBUS_Message.Destroy;
begin
     if Assigned(Message)
     then
          dbus_message_unref( Message);
     inherited Destroy;
end;

function TDBUS_Message.Iterateur: TDBUS_Iterateur;
var
   Iter: DBusMessageIter;
begin
     if 0 = dbus_message_iter_init( Message, @Iter)
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
     SetLength(Basic_Strings,0);
end;

destructor TDBUS_Iterateur.Destroy;
begin
     Basic_Strings_Libere;
     inherited Destroy;
end;

procedure TDBUS_Iterateur.Basic_Strings_Libere;
begin
     SetLength( Basic_Strings,0);
end;

function TDBUS_Iterateur.Recurse: TDBUS_Iterateur;
var
   ResultIter: DBusMessageIter;
begin
     dbus_message_iter_recurse(@Iter, @ResultIter);
     Result:= TDBUS_Iterateur.Create( ResultIter);
end;

function TDBUS_Iterateur.open_container( _type: cint;
                                         const _contained_signature: PChar): TDBUS_Iterateur;
var
   ResultIter: DBusMessageIter;
begin
     if 0 = dbus_message_iter_open_container(@Iter, _type, _contained_signature, @ResultIter)
     then
         raise Exception.Create('Call to dbus_message_iter_open_container failed');
     Result:= TDBUS_Iterateur.Create( ResultIter);
end;

procedure TDBUS_Iterateur.close_container( _sub: TDBUS_Iterateur);
begin
     dbus_message_iter_close_container(@Iter, @_sub.Iter);
end;

function TDBUS_Iterateur.ArgType: cint;
begin
     Result:= dbus_message_iter_get_arg_type(@Iter);
end;

procedure TDBUS_Iterateur.GetBasic(var _Dest);
begin
     dbus_message_iter_get_basic(@Iter, @_Dest);
end;

function TDBUS_Iterateur.Basic_String: String;
var
   lpstr: PAnsiChar;
begin
     GetBasic( lpstr);
     Result:= StrPas( lpstr);
end;

function TDBUS_Iterateur.Basic_Byte: Byte;
begin
     GetBasic( Result);
end;

function TDBUS_Iterateur.Basic_cint: cint;
begin
     GetBasic( Result);
end;

procedure TDBUS_Iterateur.AppendBasic(_type: cint; _Source: Pointer);
begin
     if 0 = dbus_message_iter_append_basic(@Iter, _type, _Source)
     then
         raise Exception.Create('Out Of Memory while calling dbus_message_iter_append_basic');
end;

function TDBUS_Iterateur.Basic_Strings_Add(_s: String): PPChar;
var
   i: Integer;
begin
     SetLength( Basic_Strings, Length( Basic_Strings)+1);
     i:= High(Basic_Strings);
     Basic_Strings[i]:= PChar(_s);
     Result:= @Basic_Strings[i];
end;

procedure TDBUS_Iterateur.AppendBasic_type_String(_type: cint; _S: String);
var
   L: Integer;
   lplpstr: PPAnsiChar;
begin
     L:= Length(_S)+1;
     lplpstr:= Basic_Strings_Add( _S);
     AppendBasic( _type, lplpstr);
end;

procedure TDBUS_Iterateur.Append_OBJECT_PATH(_S: String);
begin
     AppendBasic_type_String( DBUS_TYPE_OBJECT_PATH, _S);
end;

procedure TDBUS_Iterateur.Append_String( _S: String);
begin
     AppendBasic_type_String( DBUS_TYPE_STRING, _S);
end;

procedure TDBUS_Iterateur.Append_Variant_String( _S: String);
var
   i: TDBUS_Iterateur;
begin
     i:= open_container( DBUS_TYPE_VARIANT, 's');
       i.Append_String( _S);
     close_container( i);
end;

procedure TDBUS_Iterateur.Append_DICT_String(_Name, _Value: String);
var
   i: TDBUS_Iterateur;
begin
     i:= open_container( DBUS_TYPE_DICT_ENTRY, nil);
       i.Append_String        ( _Name );
       i.Append_Variant_String( _Value);
     close_container( i);
end;

function TDBUS_Iterateur.Next: Boolean;
begin
     Result:= dbus_message_iter_next(@Iter) <> 0;
end;

end.

