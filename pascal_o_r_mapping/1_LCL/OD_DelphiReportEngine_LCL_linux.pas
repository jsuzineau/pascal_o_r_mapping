{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_LCL_linux;

interface

uses
 ActiveX, ComObj, Consts, ShellAPI, ShlObj, Windows, uWindows, WinSock, 
 uDessin, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_LCL_linux', @Register);
end.
