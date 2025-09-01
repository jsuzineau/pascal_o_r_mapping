unit utc_uuStrings;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { Ttc_uuStrings }

 Ttc_uuStrings= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure Test_Bytes_from_String;
  procedure Test_Bytes_from_Hex;
 end;

implementation

procedure Ttc_uuStrings.SetUp;
begin

end;

procedure Ttc_uuStrings.TearDown;
begin

end;

procedure Ttc_uuStrings.Test_Bytes_from_String;
const
     sTest= 'TtcBlueChain.Test_Bytes_from_String;';
var
   B: TBytes;
   sTest_back: String;
begin
     B:= Bytes_from_String( sTest);
     sTest_back:= String_from_Bytes( B);
     Assert( sTest = sTest_back,'Echec Bytes_from_String / String_from_Bytes');

     //Fail('Écrivez votre propre test');
end;

procedure Ttc_uuStrings.Test_Bytes_from_Hex;
const
     sTest= 'ba9dc581eaa6ce5ad8b5ace18511a8a7';
var
   B: TBytes;
   sTest_back: String;
begin
     B:= Bytes_from_Hex( sTest);
     sTest_back:= Hex_from_Bytes( B);
     Assert( sTest = sTest_back,'Echec Bytes_from_Hex / Hex_from_Bytes');

     //Fail('Écrivez votre propre test');
end;

initialization

 RegisterTest(Ttc_uuStrings);
end.

