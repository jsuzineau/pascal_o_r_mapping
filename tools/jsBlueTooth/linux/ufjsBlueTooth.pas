unit ufjsBlueTooth;

{$mode objfpc}{$H+}

interface

uses
    uDBUS,
    uDBUS_BlueTooth_Devices,
    uDBUS_BlueTooth_Profile,
    uDBUS_BlueTooth_SPP_Server_Register,
    uBlueZ_BlueTooth_Client,
    uBlueZ_BlueTooth_Server,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,dbus;

type

 { TfjsBlueTooth }

 TfjsBlueTooth
 =
  class(TForm)
    bListe: TButton;
    bServer: TButton;
    bClient: TButton;
    lb: TListBox;
    m: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    Splitter1: TSplitter;
    tDBUS_ProcessMessage: TTimer;
    tListe: TTimer;
    procedure bClientClick(Sender: TObject);
    procedure bListeClick(Sender: TObject);
    procedure bServerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tDBUS_ProcessMessageTimer(Sender: TObject);
    procedure tTimer(Sender: TObject);
  private
    procedure Liste;
    procedure Bluez_Server;
  private
    dbus: TDBUS;
    profile: TBlueTooth_Profile;
    function dbus_HandleMessage( _Message: TDBUS_Message): DBusHandlerResult;
  end;

var
 fjsBlueTooth: TfjsBlueTooth;

implementation

{$R *.lfm}

{ TfjsBlueTooth }

procedure TfjsBlueTooth.FormCreate(Sender: TObject);
begin
     profile:= nil;
     uDBUS.m:= m;
     dbus:= TDBUS.Create;
     //dbus.OnHandleMessage:= @dbus_HandleMessage; Messages traités en double
     dbus.Request_Name( 'org.bluez.jsBlueTooth');
     tDBUS_ProcessMessage.Enabled:= True;
end;

procedure TfjsBlueTooth.FormDestroy(Sender: TObject);
begin
     FreeAndNil(dbus);
     uDBUS.m:= nil;
end;

function TfjsBlueTooth.dbus_HandleMessage( _Message: TDBUS_Message): DBusHandlerResult;
var
   Path: String;
begin
     Result:= DBUS_HANDLER_RESULT_NOT_YET_HANDLED;

     Path:= _Message.Path      ;
     m.Lines.Add(  'TfjsBlueTooth.dbus_HandleMessage:'#13#10
                  +'  path     :'+Path+#13#10
                  +'  interface:'+_Message.Interface_+#13#10
                  +'  member:   '+_Message.Member
                  );

     if nil = profile              then exit;
     if profile.ObjectPath <> Path then exit;

     Result:= profile.HandleMessage( _Message);
end;

procedure TfjsBlueTooth.tTimer(Sender: TObject);
begin
     tListe.Enabled:= False;
     Liste;
end;

procedure TfjsBlueTooth.tDBUS_ProcessMessageTimer(Sender: TObject);
begin
     tDBUS_ProcessMessage.Enabled:= False;
     dbus.HasMessage;//Traitement messages DBUS
     tDBUS_ProcessMessage.Enabled:= True;
end;

procedure TfjsBlueTooth.Liste;
var
   bds: TBluetoothDevices;
begin
     bds:= TBluetoothDevices.Create( dbus);
     try
        m.Lines.Add( bds.Liste);
        bds.Remplit_Listbox( lb);
     finally
            FreeAndNil( bds);
            end;
end;

procedure TfjsBlueTooth.bListeClick(Sender: TObject);
begin
     Liste;
end;

procedure TfjsBlueTooth.Bluez_Server;
var
   bts: TBluetooth_Server;
begin
      bts := TBluetooth_Server.Create;
      try
        if not bts.Initialize
        then
            m.Lines.Add( 'TBluetooth_Server.Initialize:'+bts.sError)
        else
            begin
            m.Lines.Add( 'Bluetooth server initialized:');
            m.Lines.Add( bts.GetServerAddress);

            if not bts.Listen
            then
                m.Lines.Add( 'TBluetooth_Server.Listen:'+bts.sError)
            else
                begin
                m.Lines.Add( 'Client connected.');
                bts.Write('Hello from Bluetooth server!');
                end;
            end;
      finally
             bts.Free;
      end;
end;

procedure TfjsBlueTooth.bServerClick(Sender: TObject);
const
     object_path= '/org/bluez/jsBlueTooth';
     service_name= 'jsBlueTooth serveur';
// Création et exportation du profil
var
   sr: TDBUS_BlueTooth_SPP_Server_Register;
begin
     profile := TBlueTooth_Profile.Create( dbus, object_path);

     sr:= TDBUS_BlueTooth_SPP_Server_Register.Create;
     try
        //dbus
        if not sr.Register( object_path, service_name)
        then
            m.Lines.Add( 'Echec de TDBUS_BlueTooth_SPP_Server_Register.Register');

     finally
            FreeAndNil( sr);
            end;
end;

procedure TfjsBlueTooth.bClientClick(Sender: TObject);
var
   i: Integer;
   spp: TBluetooth_SPP;
   bc: TBluetooth_Client;
   s: string;
begin
     i:= lb.ItemIndex;
     if -1 = i then exit;
     spp:= lb.Items.Objects[i] as TBluetooth_SPP;
     bc := TBluetooth_Client.Create;
     try
       if not bc.ConnectTo( spp.Address,spp.Channel)
       then
           m.Lines.Add( 'TBluetooth_Client.ConnectTo:'+bc.sError)
       else
           begin
           m.Lines.Add( 'TBluetooth_Client connecté, envoi');
           bc.WriteString('Hello from client !');
           // Lecture avec timeout, à adapter à ton usage
           if bc.ReadString(s) > 0
           then
               m.Lines.Add( 'TBluetooth_Client Reçu:'+s);
           end;
     finally
            bc.Free;
            end;
end;

end.


