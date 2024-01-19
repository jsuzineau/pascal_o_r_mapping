unit utcDataUtilsU;

{$mode objfpc}{$H+}

interface

uses
    uDataUtilsU,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { TtcDataUtilsU }

 TtcDataUtilsU= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure Test_Try_DateTime_from_DateTimeSQL_sans_quotes;
 end;

implementation

procedure TtcDataUtilsU.Test_Try_DateTime_from_DateTimeSQL_sans_quotes;
     procedure T( sDT: String;
                  Attendu_D, Attendu_M, Attendu_Y: Word;
                  Attendu_H, Attendu_N, Attendu_S, Attendu_MS: Word
                  );
     var
        dt: TDateTime;
        D, M, Y: Word;
        H, N, S, MS: Word;
     begin
          if not Try_DateTime_from_DateTimeSQL_sans_quotes( sDT, DT)
          then
              Fail('Echec de Try_DateTime_from_DateTimeSQL_sans_quotes');

          DecodeDate( dt, Y, M, D);
          if    (Attendu_D <> D)
             or (Attendu_M <> M)
             or (Attendu_Y <> Y)
          then
              Fail
                (
                Format
                  (
                  'Attendu: %d-%d-%d Obtenu: %d-%d-%d',
                  [Attendu_D, Attendu_M, Attendu_Y, D, M, Y]
                  )
                );

          DecodeTime( dt, H, N, S, MS);
          if    (Attendu_H  <> H )
             or (Attendu_N  <> N )
             or (Attendu_S  <> S )
             or (Attendu_MS <> MS)
          then
              Fail
                (
                Format
                  (
                  'Attendu: %d:%d:%d.%d Obtenu: %d:%d:%d.%d',
                  [Attendu_H, Attendu_N, Attendu_S, Attendu_MS, H, N, S, MS]
                  )
                );

     end;
begin
     T('2024-01-19 10:42:50.503', 19,1,2024,10,42,50,  0);
     T('2024-01-19 10:42:50'    , 19,1,2024,10,42,50,  0);
     T('2024-01-19 '            , 19,1,2024, 0, 0, 0,  0);
     T('2024-01-19'             , 19,1,2024, 0, 0, 0,  0);
end;

procedure TtcDataUtilsU.SetUp;
begin

end;

procedure TtcDataUtilsU.TearDown;
begin

end;

initialization

 RegisterTest(TtcDataUtilsU);
end.

