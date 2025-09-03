unit ufjsBlueTooth;

{$mode objfpc}{$H+}

interface

uses
    uDBUS_BlueTooth_Devices,
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
  public

  end;

var
 fjsBlueTooth: TfjsBlueTooth;

implementation

{$R *.lfm}

{ TfjsBlueTooth }

procedure TfjsBlueTooth.FormCreate(Sender: TObject);
begin
end;

procedure TfjsBlueTooth.FormDestroy(Sender: TObject);
begin
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

procedure TfjsBlueTooth.bServerClick(Sender: TObject);
//var
//   bts: TBluetooth_Server;
begin
      //bts := TBluetooth_Server.Create;
      //try
      //  if not bts.Initialize
      //  then
      //      m.Lines.Add( 'TBluetooth_Server.Initialize:'+WSALastError_Message)
      //  else
      //      begin
      //      m.Lines.Add( 'Bluetooth server initialized:');
      //      m.Lines.Add( bts.GetServerAddress);
      //
      //      if not bts.Listen
      //      then
      //          m.Lines.Add( 'TBluetooth_Server.Listen:'+WSALastError_Message)
      //      else
      //          begin
      //          m.Lines.Add( 'Client connected.');
      //          bts.Write('Hello from Bluetooth server!');
      //          end;
      //      end;
      //finally
      //       bts.Free;
      //end;
end;

procedure TfjsBlueTooth.bClientClick(Sender: TObject);
//var
//   i: Integer;
//   bd: TBluetoothDevice;
//   bc: TBluetooth_Client;
//   s: string;
begin
     //i:= lb.ItemIndex;
     //if -1 = i then exit;
     //bd:= lb.Items.Objects[i] as TBluetoothDevice;
     //bc := TBluetooth_Client.Create;
     //try
     //  if not bc.ConnectTo( bd.Address)
     //  then
     //      m.Lines.Add( 'TBluetooth_Client.ConnectTo:'+WSALastError_Message)
     //  else
     //      begin
     //      m.Lines.Add( 'TBluetooth_Client connecté, envoi');
     //      bc.WriteString('Hello from client !');
     //      // Lecture avec timeout, à adapter à ton usage
     //      if bc.ReadString(s) > 0
     //      then
     //          m.Lines.Add( 'TBluetooth_Client Reçu:'+s);
     //      end;
     //finally
     //       bc.Free;
     //       end;
end;

end.

