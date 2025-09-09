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
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

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
    t: TTimer;
    procedure bClientClick(Sender: TObject);
    procedure bListeClick(Sender: TObject);
    procedure bServerClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tTimer(Sender: TObject);
  private
    procedure Liste;
    procedure Bluez_Server;
  public
  //Serveur
  private
    dbus: TDBUS;
  end;

var
 fjsBlueTooth: TfjsBlueTooth;

implementation

{$R *.lfm}

{ TfjsBlueTooth }

procedure TfjsBlueTooth.FormCreate(Sender: TObject);
begin
     dbus:= TDBUS.Create;
     uDBUS_BlueTooth_Profile_Abonne( dbus);
end;

procedure TfjsBlueTooth.FormDestroy(Sender: TObject);
begin
     FreeAndNil(dbus);
end;

procedure TfjsBlueTooth.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     Liste;
end;

procedure TfjsBlueTooth.Liste;
var
   bds: TBluetoothDevices;
begin
     bds:= TBluetoothDevices.Create;
     try
        m.Lines.Text:= bds.Liste;
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
     object_path= '/org/bluez/myprofile';
     service_name= 'jsBlueTooth serveur';
// Création et exportation du profil
var
   sr: TDBUS_BlueTooth_SPP_Server_Register;
   profile: TBlueTooth_Profile;
begin
     sr:= TDBUS_BlueTooth_SPP_Server_Register.Create;
     try
        //dbus
        sr.Register( object_path, service_name);
     finally
            FreeAndNil( sr);
            end;

     profile := TBlueTooth_Profile.Create( dbus, object_path);
     // RegisterProfile de BlueZ en utilisant ce objectPath...
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

