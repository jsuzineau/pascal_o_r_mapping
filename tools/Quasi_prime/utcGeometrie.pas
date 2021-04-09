unit utcGeometrie;

{$mode objfpc}{$H+}

interface

uses
    uGeometrie,Math,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { TtcGeometrie }

 TtcGeometrie= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 private
  procedure Test_TAffine_Create_from_tan_cos( _alpha: ValReal);
  procedure Test_TAffine_Create_from_alpha( _alpha: ValReal);
 published
  procedure Test_TAffine_alpha;
  procedure Test_TAffine_Vertical;
 end;

implementation

procedure TtcGeometrie.SetUp;
begin

end;

procedure TtcGeometrie.TearDown;
begin

end;

procedure TtcGeometrie.Test_TAffine_Create_from_tan_cos(_alpha: ValReal);
var
   A: TAffine;
begin
     A:= TAffine.Create_from_tan_cos( tan(_alpha), cos(_alpha), 1);
     try
        AssertEquals( 'test Create_from_tan_cos', A.alpha, _alpha);
     finally
            FreeAndNil( A);
            end;
end;

procedure TtcGeometrie.Test_TAffine_Create_from_alpha(_alpha: ValReal);
var
   A: TAffine;
begin
     A:= TAffine.Create( _alpha, 1);
     try
        AssertEquals( 'test Create_from_tan_cos', A.alpha, _alpha);
     finally
            FreeAndNil( A);
            end;
end;

procedure TtcGeometrie.Test_TAffine_alpha;
var
   alpha_deg: integer;
begin
     for alpha_deg:= 0 to 360
     do
       Test_TAffine_Create_from_tan_cos( PI*alpha_deg/360);
     Test_TAffine_Create_from_tan_cos(  PI/2);
     //Test_TAffine_Create_from_tan_cos( -PI/2);
     Test_TAffine_Create_from_alpha(  PI/2);
     Test_TAffine_Create_from_alpha( -PI/2);
end;

procedure TtcGeometrie.Test_TAffine_Vertical;
var
   A: TAffine;
begin
     A:= TAffine.Create_Vertical( -2);
     try
        AssertEquals( 'Test_TAffine_Vertical', A.Vertical_x, -2);
     finally
            FreeAndNil( A);
            end;
end;

initialization

 RegisterTest(TtcGeometrie);
end.

