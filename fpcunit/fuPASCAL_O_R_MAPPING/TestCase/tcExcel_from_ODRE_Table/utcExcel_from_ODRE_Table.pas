unit utcExcel_from_ODRE_Table;

{$mode objfpc}{$H+}

interface

uses
    //uExcel_from_ODRE_Table,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 TtcExcel_from_ODRE_Table= class(TTestCase)
 protected
  //eot: TExcel_from_ODRE_Table;
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure TestHookUp;
 end;

implementation

procedure TtcExcel_from_ODRE_Table.TestHookUp;
begin
     //TExcel_from_ODRE_Table
     Fail('Écrivez votre propre test');
end;

procedure TtcExcel_from_ODRE_Table.SetUp;
begin
     //eot:= TExcel_from_ODRE_Table.Crea;
end;

procedure TtcExcel_from_ODRE_Table.TearDown;
begin

end;

initialization

 RegisterTest(TtcExcel_from_ODRE_Table);
end.

