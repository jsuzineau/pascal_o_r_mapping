{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lclextensions_package;

interface

uses
 DelphiCompat, oleutils, LclExt, LazarusPackageIntf;

implementation

procedure Register;
begin
end;

initialization
  RegisterPackage('lclextensions_package', @Register);
end.
