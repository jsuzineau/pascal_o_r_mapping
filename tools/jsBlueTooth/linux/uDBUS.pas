unit uDBUS;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils, dbus, unixtype,StdCtrls;

const
     DBUS_TYPE_UNIX_FD= Integer('h');
//--------------------------------------------------
// TDBUS : Connexion et gestion des erreurs D-Bus
//--------------------------------------------------

type
 TDBUS_Message =class;

 TDBUS_HandleMessage_Event
 =
  function ( _Message: TDBUS_Message): DBusHandlerResult of object;

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
    FConnection: PDBusConnection;
    function GetConnection: PDBusConnection;
  public
    property Connection: PDBusConnection read GetConnection;
  //HasMessage
  public
    function HasMessage: Boolean;
  //Abonnement à des messages
  private
    message_handler: DBusHandleMessageFunction;
    procedure Abonne( _message_handler: DBusHandleMessageFunction);
    procedure DesAbonne;
    function Do_HandleMessage( _Message: TDBUS_Message): DBusHandlerResult;
  private
    FOnHandleMessage: TDBUS_HandleMessage_Event;
  public
    property OnHandleMessage: TDBUS_HandleMessage_Event read FOnHandleMessage write FOnHandleMessage;
  //Envoi
  public
    function Send( _m: TDBUS_Message): Boolean;
  //Request Name
  public
    function Request_Name(_Name: String): String;
  end;

//--------------------------------------------------
// TDBUS_Method_Call : Appel méthode D-Bus
//--------------------------------------------------

type
 TDBUS_Iterateur = class;

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
    constructor Create( _Message: PDBusMessage; _unref_on_destroy: Boolean= False);
    destructor Destroy; override;
  //Attributs
  private
    unref_on_destroy: Boolean;
    Message: PDBusMessage;
  public
    function Path      : String;
    function Interface_: String;
    function Member    : String;
  //Gestion d'erreur
  public
    sError: String;
  //Accès
  public
    function Iterateur: TDBUS_Iterateur;
  //Réponse
  public
    function Reply: TDBUS_Message;
  //Append args
  public
    function Append_String( _S: String):Boolean;//non testé positivement
  //Paramètres
  public
    function Parameters_append: TDBUS_Iterateur;
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
    procedure Append_String ( _S: String);
    procedure Append_cuint16(var _n: cuint16);
    procedure Append_dbus_bool_t  (var _b: dbus_bool_t);
  //Ajout variant
  public
    procedure Append_Variant_String ( _S: String);
    procedure Append_Variant_cuint16(var _n: cuint16);
    procedure Append_Variant_dbus_bool_t  (var _b: dbus_bool_t);
  //Ajout entrée de DICT
  public
    procedure Append_DICT_String( _Name, _Value: String);
    procedure Append_DICT_cuint16(_Name: String; var _Value: cuint16);
    procedure Append_DICT_dbus_bool_t(_Name: String; var _Value: dbus_bool_t);
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

type

 { TDBUS_Object }

 TDBUS_Object
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create( _O: TObject;
                        _dbus: TDBUS;
                        _Path: String;
                        _callback: DBusObjectPathMessageFunction);
    destructor Destroy; override;
  //DBUS
  private
    dbus  : TDBUS;
  //Path
  private
    Path: String;
  //VMT
  private
    vmt: DBusObjectPathVTable;
  //Erreur
  public
    sError: String;
  end;

var
   m: TMemo= nil;
procedure uDBUS_Log( _s: String);

implementation

procedure uDBUS_Log(_s: String);
begin
     if Assigned(m) then m.Lines.Add( _s);
     WriteLn( _s);
end;

function DBusHandleMessage( _connection: PDBusConnection;
                            _Message: PDBusMessage;
                            _user_data: Pointer): DBusHandlerResult; cdecl;
var
   O: TObject;
   dbus: TDBUS;
   Message: TDBUS_Message;
begin
     Result:= DBUS_HANDLER_RESULT_NOT_YET_HANDLED;

     if nil = _user_data then exit;

     O:= TObject( _user_data);
     if not (O is TDBUS) then exit;

     Message:= TDBUS_Message.Create( _Message);
     try
        dbus:= TDBUS( O);
        Result:= dbus.Do_HandleMessage( Message);
     finally
            FreeAndNil( Message);
            end;
end;

//--- TDBUS -----------------------------------------------------

constructor TDBUS.Create;
begin
     inherited Create;
     FConnection:= nil;
     message_handler:= nil;
     FOnHandleMessage:= nil;
     InitError;
end;

destructor TDBUS.Destroy;
begin
     DesAbonne;
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

function TDBUS.GetConnection: PDBusConnection;
begin
     Result:= nil;
     if nil = FConnection
     then
         begin
         FConnection:= dbus_bus_get( DBUS_BUS_SYSTEM, @Error);
         if nil = FConnection
         then
             raise Exception.Create('Erreur de la connexion à DBus: '+ Error.message);
         Abonne( @DBusHandleMessage);
         end;
     Result:= FConnection;
end;

function TDBUS.HasMessage: Boolean;
begin
     Result:= False;
     if nil = FConnection then Exit;
     Result:= dbus_connection_read_write_dispatch( Connection, 0) <> 0;
end;

procedure TDBUS.Abonne(_message_handler: DBusHandleMessageFunction);
begin
     if Assigned( message_handler) then exit;

     message_handler:= message_handler;
     if 0 = dbus_connection_add_filter( Connection, _message_handler, Self, nil )
     then
         raise Exception.Create( 'TDBUS.Abonne: Out of memory while calling dbus_connection_add_filter');
end;

procedure TDBUS.DesAbonne;
begin
     if nil = message_handler then exit;

     dbus_connection_remove_filter( Connection, message_handler, nil);
end;

function TDBUS.Do_HandleMessage(_Message: TDBUS_Message): DBusHandlerResult;
begin
     Result:= DBUS_HANDLER_RESULT_NOT_YET_HANDLED;
     if Assigned( OnHandleMessage)
     then
         Result:= OnHandleMessage( _Message);
end;

function TDBUS.Send(_m: TDBUS_Message): Boolean;
begin
     Result:= 0 <> dbus_connection_send( Connection, _m.Message, nil);
end;

function TDBUS.Request_Name(_Name: String): String;
var
   Resultat: cint;
begin
     Resultat
     :=
       dbus_bus_request_name( Connection,
                              PChar( _Name),
                              DBUS_NAME_FLAG_REPLACE_EXISTING,
                              @Error);
     case Resultat
     of
       DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER: Result:= 'Service has become the primary owner of the requested name';
       DBUS_REQUEST_NAME_REPLY_IN_QUEUE     : Result:= 'Service could not become the primary owner and has been placed in the queue';
       DBUS_REQUEST_NAME_REPLY_EXISTS       : Result:= 'Service is already in the queue';
       DBUS_REQUEST_NAME_REPLY_ALREADY_OWNER: Result:= 'Service is already the primary owner';
       else                                   Result:= IntToStr(Resultat)+#13#10'Erreur '+Error.name+':'#13#10'  '+Error.message;
       end;
     uDBUS_Log( 'TDBUS.Request_Name('+_Name+'): '+Result);
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
       dbus_connection_send_with_reply_and_block( dbus.Connection,
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

constructor TDBUS_Message.Create( _Message: PDBusMessage;
                                  _unref_on_destroy: Boolean= False);
begin
     inherited Create;
     Message:= _Message;
     unref_on_destroy:= _unref_on_destroy;
     sError:= '';
end;

destructor TDBUS_Message.Destroy;
begin
     if Assigned(Message) and unref_on_destroy
     then
          dbus_message_unref( Message);
     inherited Destroy;
end;

function TDBUS_Message.Path: String;
begin
     Result:= dbus_message_get_path( Message );
end;

function TDBUS_Message.Interface_: String;
begin
     Result:= dbus_message_get_interface( Message );
end;

function TDBUS_Message.Member: String;
begin
     Result:= dbus_message_get_member( Message );
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

function TDBUS_Message.Reply: TDBUS_Message;
var
   mReply: PDBusMessage;
begin
     mReply := dbus_message_new_method_return( Message);
     Result:= TDBUS_Message.Create( mReply, True);
end;

function TDBUS_Message.Append_String( _S: String): Boolean;
begin
     Result
     :=
       0
       <>
       dbus_message_append_args( Message,
                                 DBUS_TYPE_STRING,
                                 [ PChar( _S), DBUS_TYPE_INVALID]
                                 );
end;

function TDBUS_Message.Parameters_append: TDBUS_Iterateur;
var
   Iter: DBusMessageIter;
begin
     dbus_message_iter_init_append(Message, @Iter);
     sError:= '';
     Result:= TDBUS_Iterateur.Create( Iter);
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

procedure TDBUS_Iterateur.Append_cuint16(var _n: cuint16);
begin
     AppendBasic( DBUS_TYPE_UINT16, @_n);
end;

procedure TDBUS_Iterateur.Append_dbus_bool_t(var _b: dbus_bool_t);
begin
     AppendBasic( DBUS_TYPE_BOOLEAN, @_b);
end;

procedure TDBUS_Iterateur.Append_Variant_String( _S: String);
var
   i: TDBUS_Iterateur;
begin
     i:= open_container( DBUS_TYPE_VARIANT, 's');
       i.Append_String( _S);
     close_container( i);
end;

procedure TDBUS_Iterateur.Append_Variant_cuint16(var _n: cuint16);
var
   i: TDBUS_Iterateur;
begin
     i:= open_container( DBUS_TYPE_VARIANT, 'q');
       i.Append_cuint16( _n);
     close_container( i);
end;

procedure TDBUS_Iterateur.Append_Variant_dbus_bool_t(var _b: dbus_bool_t);
var
   i: TDBUS_Iterateur;
begin
     i:= open_container( DBUS_TYPE_VARIANT, 'b');
       i.Append_dbus_bool_t( _b);
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

procedure TDBUS_Iterateur.Append_DICT_cuint16(_Name: String; var _Value: cuint16);
var
   i: TDBUS_Iterateur;
begin
     i:= open_container( DBUS_TYPE_DICT_ENTRY, nil);
       i.Append_String         ( _Name );
       i.Append_Variant_cuint16( _Value);
     close_container( i);
end;

procedure TDBUS_Iterateur.Append_DICT_dbus_bool_t(_Name: String; var _Value: dbus_bool_t);
var
   i: TDBUS_Iterateur;
begin
     i:= open_container( DBUS_TYPE_DICT_ENTRY, nil);
       i.Append_String         ( _Name );
       i.Append_Variant_dbus_bool_t( _Value);
     close_container( i);
end;

function TDBUS_Iterateur.Next: Boolean;
begin
     Result:= dbus_message_iter_next(@Iter) <> 0;
end;

{ TDBUS_Object }

constructor TDBUS_Object.Create( _O: TObject;
                                 _dbus: TDBUS;
                                 _Path: String;
                                 _callback: DBusObjectPathMessageFunction);
begin
     dbus:= _dbus;
     Path:= _Path;
     FillChar( vmt, SizeOf(vmt),0);
     vmt.message_function:= _callback;
     uDBUS_Log(  'TDBUS_Object.Create:'#13#10
                +'  '+Path+#13#10);
     sError:= '';
     if 0 = dbus_connection_register_object_path( dbus.Connection, PChar(Path), @vmt, _O)
     then
         sError:= dbus.Error.name+':'+dbus.Error.message;
end;

destructor TDBUS_Object.Destroy;
begin
     dbus_connection_unregister_object_path( dbus.Connection, PChar(Path));
     inherited Destroy;
end;

end.

