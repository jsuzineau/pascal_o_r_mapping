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
  end;

//--------------------------------------------------
// TDBUS_Method_Call : Appel méthode D-Bus
//--------------------------------------------------

type
 TDBUS_Iterateur = class;
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
  //Paramètres
  public
    function Parameters_append: TDBUS_Iterateur;
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
 { TDBUS_Reply }

 TDBUS_Reply
 =
  class
  //Gestion du cycle de vie
  public
    constructor Create(_dbus: TDBUS; _Reply: PDBusMessage);
    destructor Destroy; override;
  //Attributs
  private
    dbus   : TDBUS;
    Reply: PDBusMessage;
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
  //Ajout Basic
  private
    Basic_Strings: array of PAnsiChar;
    procedure Basic_Strings_Libere;
    procedure Basic_Strings_Add( _lpstr: PAnsiChar);
  public
    procedure AppendBasic(_type: cint; var _Source);
    procedure AppendBasic_String(_type: cint; _S: String);
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
                                                  @dbus.Error
                                                  );
     if (Reply = nil) or dbus.Error_is_set
     then
         sError:= 'Erreur DBus (reply), dbus_connection_send_with_reply_and_block: ' + dbus.Error.message
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
     SetLength(Basic_Strings,0);
end;

destructor TDBUS_Iterateur.Destroy;
begin
     Basic_Strings_Libere;
     inherited Destroy;
end;

procedure TDBUS_Iterateur.Basic_Strings_Libere;
var
   lpstr: PAnsiChar;
begin
     for lpstr in Basic_Strings do StrDispose( lpstr);
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
     dbus_message_iter_open_container(@Iter, _type, _contained_signature, @ResultIter);
     Result:= TDBUS_Iterateur.Create( ResultIter);
end;

procedure TDBUS_Iterateur.close_container( _sub: TDBUS_Iterateur);
begin
     dbus_message_iter_close_container(@Iter, @_sub);
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

procedure TDBUS_Iterateur.AppendBasic(_type: cint; var _Source);
begin
     dbus_message_iter_append_basic(@Iter, _type, @_Source);
end;

procedure TDBUS_Iterateur.Basic_Strings_Add(_lpstr: PAnsiChar);
begin
     SetLength( Basic_Strings, Length( Basic_Strings)+1);
     Basic_Strings[High(Basic_Strings)]:= _lpstr;
end;

procedure TDBUS_Iterateur.AppendBasic_String(_type: cint; _S: String);
var
   L: Integer;
   lpstr: PAnsiChar;
begin
     L:= Length(_S)+1;
     lpstr:= StrAlloc( L);
     StrPLCopy( lpstr, _s, L);
     Basic_Strings_Add( lpstr);
     AppendBasic( _type, lpstr^);//pas trop propre
end;

function TDBUS_Iterateur.Next: Boolean;
begin
     Result:= dbus_message_iter_next(@Iter) <> 0;
end;

end.

