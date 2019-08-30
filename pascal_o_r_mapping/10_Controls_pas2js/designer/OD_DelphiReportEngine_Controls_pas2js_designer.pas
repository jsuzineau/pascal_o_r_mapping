{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Controls_pas2js_designer;

{$warn 5023 off : no warning about unused units}
interface

uses
 ucWChamp_Edit, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ucWChamp_Edit', @ucWChamp_Edit.Register);
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Controls_pas2js_designer', @Register);
end.
