unit utcStrings;

{$mode objfpc}{$H+}

interface

uses
    uuStrings,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { TtcStrings }

 TtcStrings= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure TestHookUp;

 //test
 private
    procedure  Test_EncodeUrl( _Entree, _Sortie_attendue: String);
    procedure  Test_DecodeUrl( _Entree, _Sortie_attendue: String);
 end;

implementation

procedure TtcStrings.Test_EncodeUrl( _Entree, _Sortie_attendue: String);
var
   Sortie: String;
begin
     Sortie:= EncodeUrl( _Entree);
     if Sortie = _Sortie_attendue then exit;
     Fail( 'Echec de Test_EncodeUrl, entrée: >'+_Entree+'<, sortie attendue: >'+_Sortie_attendue+'<, sortie obtenue: '+Sortie);
end;

procedure TtcStrings.Test_DecodeUrl( _Entree, _Sortie_attendue: String);
var
   Sortie: String;
begin
     Sortie:= DecodeUrl( _Entree);
     if Sortie = _Sortie_attendue then exit;
     Fail( 'Echec de Test_DecodeUrl, entrée: >'+_Entree+'<, sortie attendue: >'+_Sortie_attendue+'<, sortie obtenue: '+Sortie);
end;

procedure TtcStrings.TestHookUp;
const
     { tests initiaux

     decoded_test= 'A0a*@._- %';
     encoded_test= 'A0a*@._-+%25';

     encoded_test_www_urlencoder_org= 'A0a%2A%40._-%20%25';//pour decoded_test en entrée, * et @ échappés en plus
     decoded_test_www_urlencoder_org= 'A0a*@._-+%';//pour encoded_test en entrée, espace non retraduit
     }
     decoded_test= 'A0a*@._- %';
     encoded_test= 'A0a%2A%40._-%20%25';
begin
     Test_EncodeUrl( decoded_test, encoded_test);
     Test_DecodeUrl( encoded_test, decoded_test);
end;

procedure TtcStrings.SetUp;
begin

end;

procedure TtcStrings.TearDown;
begin

end;

initialization

 RegisterTest(TtcStrings);
end.

