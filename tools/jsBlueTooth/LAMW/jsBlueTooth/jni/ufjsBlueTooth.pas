unit ufjsBlueTooth;
//initialisé à partir  de
// lamw_manager\LAMW\lazandroidmodulewizard
// \demos\GUI\AppBluetoothClientSocketDemo1\jni\unit1.pas
{$mode delphi}

interface

uses
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, AndroidWidget, bluetooth, bluetoothclientsocket,
 bluetoothserversocket, bluetoothlowenergy, Laz_And_Controls,
 autocompletetextview;
 
type

 { TfjsBlueTooth }

 TfjsBlueTooth = class(jForm)
  bt: jBluetooth;
  btLowEnergy: jBluetoothLowEnergy;
  btsClient: jBluetoothClientSocket;
  btsServer: jBluetoothServerSocket;
  bSearch: jButton;
  bSend: jButton;
  jdp: jDialogProgress;
  lv: jListView;
  tv: jTextView;
  procedure bSearchClick(Sender: TObject);
  procedure bSendClick(Sender: TObject);
  procedure btDeviceFound(Sender: TObject; deviceName: string;
   deviceAddress: string);
  procedure btDisabled(Sender: TObject);
  procedure btDiscoveryFinished(Sender: TObject; countFoundedDevices: integer;
   countPairedDevices: integer);
  procedure btDiscoveryStarted(Sender: TObject);
  procedure btEnabled(Sender: TObject);
  procedure btsClientConnected(Sender: TObject; deviceName: string;
   deviceAddress: string);
  procedure btsClientDisconnected(Sender: TObject);
  procedure btsClientIncomingData(Sender: TObject;
   var dataContent: TDynArrayOfJByte; dataHeader: TDynArrayOfJByte);
  procedure fjsBlueToothJNIPrompt(Sender: TObject);
  procedure fjsBlueToothRequestPermissionResult(Sender: TObject;
   requestCode: integer; manifestPermission: string;
   grantResult: TManifestPermissionResult);
  procedure lvClickItem(Sender: TObject; itemIndex: integer;
   itemCaption: string);
 private
  {private declarations}
  FDeviceAddress: string;
  FDeviceName: string;

  FIsDiscovering: boolean;
 public
  {public declarations}
 end;

var
 fjsBlueTooth: TfjsBlueTooth;

 
implementation
 
 
{$R *.lfm}
 

 
{ TfjsBlueTooth }

procedure TfjsBlueTooth.fjsBlueToothJNIPrompt(Sender: TObject);
begin
     if IsRuntimePermissionNeed()
     then   // that is, if target API >= 23
         begin
         tv.AppendLn('Requesting Runtime Permission....');
         Self.RequestRuntimePermission
           ([ 'android.permission.ACCESS_COARSE_LOCATION',
              'android.permission.ACCESS_FINE_LOCATION'],
              1010);   //handled by OnRequestPermissionResult
         end;
end;

procedure TfjsBlueTooth.fjsBlueToothRequestPermissionResult( Sender: TObject;
                                                             requestCode: integer;
                                                             manifestPermission: string;
                                                             grantResult: TManifestPermissionResult
                                                             );
begin
     case requestCode
     of
       1010:
         begin
         if grantResult = PERMISSION_GRANTED
         then
             begin
             if manifestPermission = 'android.permission.ACCESS_COARSE_LOCATION'
             then
                 tv.AppendLn('"'+manifestPermission+'"  granted!');
             if manifestPermission = 'android.permission.ACCESS_FINE_LOCATION'
             then
                 tv.AppendLn('"'+manifestPermission+'"  granted!');
             end
         else//PERMISSION_DENIED
             begin
             tv.AppendLn('Sorry... "['+manifestPermission+']" not granted... ' );
             end;
         end;
       end;
end;

procedure TfjsBlueTooth.btEnabled(Sender: TObject);
begin
     tv.AppendLn('Bluetooth On');
end;

procedure TfjsBlueTooth.btDisabled(Sender: TObject);
begin
     tv.AppendLn('Bluetooth Off');
end;

procedure TfjsBlueTooth.bSearchClick(Sender: TObject);
begin
     if not IsRuntimePermissionGranted('android.permission.ACCESS_COARSE_LOCATION')
     then
         begin
         tv.AppendLn('Sorry... "android.permission.ACCESS_COARSE_LOCATION');
         Exit;
         end;

     if not IsRuntimePermissionGranted('android.permission.ACCESS_FINE_LOCATION')
     then
         begin
         tv.AppendLn('Sorry... "android.permission.ACCESS_FINE_LOCATION');
         Exit;
         end;

     lv.Clear;
     bt.Discovery(); //handled by: OnDiscoveryStarted, OnDeviceFound and OnDiscoveryFinished
     jdp.Show();
end;

procedure TfjsBlueTooth.btDiscoveryStarted(Sender: TObject);
begin
     FIsDiscovering:= True;
     tv.AppendLn('Starting Discovering News Devices..');
end;

procedure TfjsBlueTooth.btDeviceFound( Sender: TObject;
                                       deviceName: string;
                                       deviceAddress: string
                                       );
begin
     tv.AppendLn('deviceName: ' +deviceName +' : deviceAddress: '+deviceAddress);
     lv.Add(deviceName + '|' + deviceAddress);
end;

procedure TfjsBlueTooth.btDiscoveryFinished( Sender: TObject;
                                             countFoundedDevices: integer;
                                             countPairedDevices: integer);
begin
     //ShowMessage('***Discovery Finished! Founded Devices = '+IntToStr(countFoundedDevices));
     //ShowMessage('...Discovery Finished! Reachable Paired Devices = '+IntToStr(countPairedDevices));
     //ShowMessage('Discovery Finished!');
     jdp.Stop;
     FIsDiscovering:= False;
     //ShowNewDevices();
end;

procedure TfjsBlueTooth.lvClickItem( Sender: TObject;
                                      itemIndex: integer;
                                      itemCaption: string
                                      );
var
   deviceName, deviceAddress: string;
begin
     if itemIndex = 0 then Exit;

     deviceAddress:= itemCaption; // format: name|address
     deviceName:= SplitStr(deviceAddress, '|');

     FDeviceAddress:= deviceAddress;
     FDeviceName:= deviceName;

     if Pos('null', deviceAddress) <= 0
     then
         begin
         if bt.IsReachablePairedDevice(deviceAddress)
         then
             begin
             btsClient.SetDevice(bt.GetReachablePairedDeviceByAddress(deviceAddress));
             //well known SPP UUID
             btsClient.SetUUID('00001101-0000-1000-8000-00805F9B34FB'); //default
             btsClient.Connect();
             end
         else
             tv.AppendLn('Not ReachablePairedDevice...');
     end;
end;

procedure TfjsBlueTooth.btsClientConnected( Sender: TObject;
                                            deviceName: string;
                                            deviceAddress: string
                                            );
begin
     tv.AppendLn('Connected to server: ['+deviceName+'] ['+deviceAddress+']');
end;

procedure TfjsBlueTooth.btsClientDisconnected( Sender: TObject);
begin
     tv.AppendLn('Disconnected...');
     lv.Clear;
end;

procedure TfjsBlueTooth.btsClientIncomingData( Sender: TObject;
                                               var dataContent: TDynArrayOfJByte;
                                               dataHeader: TDynArrayOfJByte
                                               );
var
   S: String;
begin
     if btsClient.DataHeaderReceiveEnabled
     then //[Demo 1 ---> False]
         begin
         //if dataHeader <> nil then ...
         end
     else  //NO header ... DataHeaderReceiveEnabled = False
         begin
         //guess data format!
         S:= btsClient.JByteArrayToString(dataContent);
         tv.AppendLn( S);
         tv.AppendLn('Received from Server: "'+ S+'"');
         end;
end;

procedure TfjsBlueTooth.bSendClick(Sender: TObject);
var
   S: String;
begin
     if btsClient.IsConnected()
     then
         begin
         S:= 'Hi, Good Job!';
         btsClient.WriteMessage(S);  //NO header!
         tv.AppendLn('Sent: '+S);
         end
     else
         tv.AppendLn('Not Connected yet...');
end;


end.
