{Hint: save all files to location: E:\01_Projets\01_pascal_o_r_mapping\electronic\Arduino\AMS_Spectrometer\lamw\AMS_Spectrometer\jni }
unit ufAMS_Spectrometer;

{$mode delphi}

interface

uses
 Classes, SysUtils, AndroidWidget, Laz_And_Controls, bluetooth;
 
type

 { TfAMS_Spectrometer }

 TfAMS_Spectrometer = class(jForm)
  e: jEditText;
  Bluetooth: jBluetooth;
  procedure BluetoothDeviceBondStateChanged(Sender: TObject; state: integer;
   deviceName: string; deviceAddress: string);
 private
  {private declarations}
 public
  {public declarations}
 end;

var
 fAMS_Spectrometer: TfAMS_Spectrometer;

implementation
 
{$R *.lfm}
 

{ TfAMS_Spectrometer }

procedure TfAMS_Spectrometer.BluetoothDeviceBondStateChanged(Sender: TObject;
 state: integer; deviceName: string; deviceAddress: string);
begin

end;

end.
