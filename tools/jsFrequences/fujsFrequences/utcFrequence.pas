unit utcFrequence;

{$mode objfpc}{$H+}

interface

uses
    uFrequence,
 Classes, SysUtils, fpcunit, testutils, testregistry;

type

 { TtcFrequence }

 TtcFrequence= class(TTestCase)
 protected
  procedure SetUp; override;
  procedure TearDown; override;
 published
  procedure Test_Midi_from_Note;
  procedure Test_Note_Octave;
  procedure Test_Note_Octave_Latine;
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

procedure TtcFrequence.Test_Note_Octave;
     procedure T( _note: String);
     var
        Midi: Integer;
        Obtenu: String;
     begin
          Midi:= Midi_from_Note(_note);
          Obtenu:= Note_Octave( Midi);
          Check( _note = Obtenu, 'Echec Note_Octave pour '+_note+' obtenu '+Obtenu+' midi '+IntToStr(Midi));
     end;
begin
     T('C1');
     T('A3');
     T('D4');
end;

procedure TtcFrequence.Test_Note_Octave_Latine;
     procedure T( _note: String);
     var
        Midi: Integer;
        Obtenu: String;
     begin
          Midi:= Midi_from_Note(_note);
          Obtenu:= Note_Octave_Latine( Midi);
          Check( _note = Obtenu, 'Echec Note_Octave_Latine pour '+_note+' obtenu '+Obtenu+' midi '+IntToStr(Midi));
     end;
begin
     T('do2');
     T('ré4');
     T('mi3');
     T('fa#3');
     T('sib3');
end;

initialization

 RegisterTest(TtcFrequence);
end.

