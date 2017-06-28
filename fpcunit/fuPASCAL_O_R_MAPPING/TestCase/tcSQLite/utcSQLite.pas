unit utcSQLite;

{$mode objfpc}{$H+}

interface

uses
 Classes, SysUtils, ufSQLite, fpcunit, testutils, testregistry;

type

 TtcSQLite= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure TestHookUp;
 end;

implementation

procedure TtcSQLite.TestHookUp;
var
   f: TfSQLite;
begin
     try
        f:= TfSQLite.Create( nil);
        f.ShowModal;
     finally
            FreeAndNil( f);
            end;
end;

procedure TtcSQLite.SetUp;
begin

end;

procedure TtcSQLite.TearDown;
begin

end;

initialization

 RegisterTest(TtcSQLite);
end.

