{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit LazSerialPort_special_Raspberry_Pi; 

interface

uses
  LazSerial, synaser, LazarusPackageIntf;

implementation

procedure Register; 
begin
  RegisterUnit('LazSerial', @LazSerial.Register); 
end; 

initialization
  RegisterPackage('LazSerialPort_special_Raspberry_Pi', @Register); 
end.
