unit utcFrequences;

{$mode objfpc}{$H+}

interface

uses
    uFrequence,
    uFrequences,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 TtcFrequences= class(TTestCase)
 published
  procedure TestHookUp;
 end;

implementation

procedure TtcFrequences.TestHookUp;
begin
     Check( 0   = Frequences.Octave_from_Midi(60));
     Check( 432 = Frequences.Frequence_from_Midi(Midi_from_Note('la')));
end;



initialization

 RegisterTest(TtcFrequences);
end.

