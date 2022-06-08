unit utcFrequence;

{$mode objfpc}{$H+}

interface

uses
    uFrequence,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 TtcFrequence= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure Test_Midi_from_Note;
 end;

implementation

procedure TtcFrequence.SetUp;
begin

end;

procedure TtcFrequence.TearDown;
begin

end;

procedure TtcFrequence.Test_Midi_from_Note;
begin
     Check(  0+60 = Midi_from_Note('do  '), 'Echec décodage do  ');
     Check(  1+60 = Midi_from_Note('do# '), 'Echec décodage do# ');
     Check(  2+60 = Midi_from_Note('ré  '), 'Echec décodage ré  ');
     Check(  3+60 = Midi_from_Note('ré# '), 'Echec décodage ré# ');
     Check(  4+60 = Midi_from_Note('mi  '), 'Echec décodage mi  ');
     Check(  5+60 = Midi_from_Note('fa  '), 'Echec décodage fa  ');
     Check(  6+60 = Midi_from_Note('fa# '), 'Echec décodage fa# ');
     Check(  7+60 = Midi_from_Note('sol '), 'Echec décodage sol ');
     Check(  8+60 = Midi_from_Note('sol#'), 'Echec décodage sol#');
     Check(  9+60 = Midi_from_Note('la  '), 'Echec décodage la  ');
     Check( 10+60 = Midi_from_Note('la# '), 'Echec décodage la# ');
     Check( 11+60 = Midi_from_Note('si  '), 'Echec décodage si  ');
     Check(  0+60 = Midi_from_Note('C '), 'Echec décodage C ');
     Check(  1+60 = Midi_from_Note('C#'), 'Echec décodage C#');
     Check(  2+60 = Midi_from_Note('D '), 'Echec décodage D ');
     Check(  3+60 = Midi_from_Note('Eb'), 'Echec décodage Eb');
     Check(  4+60 = Midi_from_Note('E '), 'Echec décodage E ');
     Check(  5+60 = Midi_from_Note('F '), 'Echec décodage F ');
     Check(  6+60 = Midi_from_Note('F#'), 'Echec décodage F#');
     Check(  7+60 = Midi_from_Note('G '), 'Echec décodage G ');
     Check(  8+60 = Midi_from_Note('G#'), 'Echec décodage G#');
     Check(  9+60 = Midi_from_Note('A '), 'Echec décodage A ');
     Check( 10+60 = Midi_from_Note('Bb'), 'Echec décodage Bb');
     Check( 11+60 = Midi_from_Note('B '), 'Echec décodage B ');

     Check( 24 = Midi_from_Note('C1 '), 'Echec décodage C1 ');
     Check( 60 = Midi_from_Note('do3 '), 'Echec décodage do3 (début gamme du diapason) ');
end;

initialization

 RegisterTest(TtcFrequence);
end.

