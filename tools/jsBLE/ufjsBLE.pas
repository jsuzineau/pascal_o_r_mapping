unit ufjsBLE;

{$mode objfpc}{$H+}

interface

uses
    uBLE_Devices,
    uBLE_Client,
 Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

 { TfjsBLE }

 TfjsBLE
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
    bds: TBLE_Devices;
    procedure Liste;
  end;

var
 fjsBLE: TfjsBLE;

implementation

{$R *.lfm}

{ TfjsBLE }

procedure TfjsBLE.FormCreate(Sender: TObject);
begin
     bds:= TBLE_Devices.Create;
end;

procedure TfjsBLE.FormDestroy(Sender: TObject);
begin
     FreeAndNil( bds);
end;

procedure TfjsBLE.tTimer(Sender: TObject);
begin
     t.Enabled:= False;
     Liste;
end;

procedure TfjsBLE.Liste;
begin
     m.Lines.Text:= bds.Liste;
     bds.Remplit_Listbox( lb);
end;

procedure TfjsBLE.bListeClick(Sender: TObject);
begin
     Liste;
end;


procedure TfjsBLE.bServerClick(Sender: TObject);
//const
//     object_path= '/org/bluez/myprofile';
//     service_name= 'jsBlueTooth serveur';
//// Création et exportation du profil
//var
//   sr: TDBUS_BlueTooth_SPP_Server_Register;
//   profile: TBlueTooth_Profile;
begin
     //sr:= TDBUS_BlueTooth_SPP_Server_Register.Create;
     //try
     //   //dbus
     //   sr.Register( object_path, service_name);
     //finally
     //       FreeAndNil( sr);
     //       end;
     //
     //profile := TBlueTooth_Profile.Create( dbus, object_path);
     //// RegisterProfile de BlueZ en utilisant ce objectPath...
end;

procedure TfjsBLE.bClientClick(Sender: TObject);
var
   i: Integer;
   bd: TBLE_Device;
   bc: TBLE_Client;
   s: string;
begin
     i:= lb.ItemIndex;
     if -1 = i then exit;
     bd:= lb.Items.Objects[i] as TBLE_Device;

     bc := TBLE_Client.Create( bds, bd);
     try
       if not bc.Connect
       then
           m.Lines.Add( 'TBLE_Client.Connect:'+bc.sError)
       else
           begin
           m.Lines.Add( 'TBluetooth_Client connecté, envoi');
           if bc.WriteString('Hello from client !')
           then
               m.Lines.Add( 'TBLE_Client.WriteString: OK')
           else
               m.Lines.Add( 'TBLE_Client.WriteString:'+bc.sError);

           // Lecture avec timeout, à adapter à ton usage
           //if bc.ReadString(s) > 0
           //then
           //    m.Lines.Add( 'TBluetooth_Client Reçu:'+s);
           end;
     finally
            bc.Free;
            end;
end;

end.

