{ This file was automatically created by Lazarus. Do not edit!
  This source is only used to compile and install the package.
 }

unit lmComponents;

{$warn 5023 off : no warning about unused units}
interface

uses
  lmcoordsys, lmfilters, lmnumericedits, lmnumericinputdialogs, lmPointsVec, LazarusPackageIntf;

implementation

procedure Register;
begin
  RegisterUnit('lmcoordsys', @lmcoordsys.Register);
  RegisterUnit('lmfilters', @lmfilters.Register);
  RegisterUnit('lmnumericedits', @lmnumericedits.Register);
end;

initialization
  RegisterPackage('lmComponents', @Register);
end.
