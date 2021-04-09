unit utcQuasi_prime;

{$mode objfpc}{$H+}

interface

uses
    uQuasi_prime,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { TtcQuasi_prime }

 TtcQuasi_prime= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 private
  procedure T( _i1, _i2: Integer);
 published
  procedure _1891;
  procedure Test_Batch;
 end;

implementation

procedure TtcQuasi_prime.SetUp;
begin

end;

procedure TtcQuasi_prime.TearDown;
begin

end;

procedure TtcQuasi_prime._1891;
//31*61=1891 Mean 46 Ecart 15
var
   c: TCalcul;
begin
     c:= Decompose( 1891);
     AssertEquals('P1', C.P1, 31);
     AssertEquals('P2', C.P2, 61);
     AssertEquals('Mean', C.Mean, 46);
     AssertEquals('Distance', C.Distance, 15);
     //Fail('Écrivez votre propre test');
end;

const
     prime: array of integer
     =
      (
      {2,3,5,}7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73,79,83,89,97
      );

procedure TtcQuasi_prime.T(_i1, _i2: Integer);
var
   C: TCalcul_Test;
begin
     C:= Decompose_Test( _i1 , _i2);
     Assert( not C.Erreur_Test, C.Log);
end;

procedure TtcQuasi_prime.Test_Batch;
var
   i,j: Integer;
begin
     for i:= Low(prime) to High(prime)
     do
       for j:= Low(prime) to High(prime)
       do
         T(  prime[i],  prime[j]);
end;

initialization

 RegisterTest(TtcQuasi_prime);
end.

