unit utcOpenDocument;

{$mode objfpc}{$H+}

interface

uses
    uOpenDocument,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 TtcOpenDocument= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure TestHookUp;
 end;

implementation

procedure TtcOpenDocument.TestHookUp;
begin
 Fail('Écrivez votre propre test');
end;

procedure TtcOpenDocument.SetUp;
begin

end;

procedure TtcOpenDocument.TearDown;
begin

end;

initialization

 RegisterTest(TtcOpenDocument);
end.

