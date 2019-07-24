{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit OD_DelphiReportEngine_Components;

interface

uses
 ucBatproVerifieur, ucbvCustomConnection, ucbvQuery_Datasource, 
 LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('ucbvCustomConnection', @ucbvCustomConnection.Register);
  RegisterUnit('ucbvQuery_Datasource', @ucbvQuery_Datasource.Register);
end;

initialization
  RegisterPackage('OD_DelphiReportEngine_Components', @Register);
end.
