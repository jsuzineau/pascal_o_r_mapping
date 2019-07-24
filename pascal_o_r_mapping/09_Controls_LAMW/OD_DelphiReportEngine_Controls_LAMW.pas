{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Controls_LAMW;

{$warn 5023 off : no warning about unused units}
interface

uses
 ucjChamp_Edit, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ucjChamp_Edit', @ucjChamp_Edit.Register);
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Controls_LAMW', @Register);
end.
