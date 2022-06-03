unit uAndroid_Midi;

{$mode delphi}

interface

uses
 Classes, SysUtils, midimanager;

type
    { TAndroid_Midi }
    TAndroid_Midi
    =
     class
     //Gestion du cycle de vie
     public
       constructor Create( _mm: jMidiManager);
       destructor Destroy; override;
     //Constantes
     public const
       p_tenor_sax            =67;//tenor sax            //
       p_orgue                =20;//orgue                //
       p_violon               =41;//violon               //
       p_choeur_Aaah          =53;//choeur Aaah          //
       p_Acoustic_Grand_Piano = 1;//Acoustic Grand Piano //
     //Méthodes
     public
       mm: jMidiManager;
       Last_note: Integer;
       procedure Stop;
       procedure PlayNote( _N: Integer; _Patch: Integer = p_Acoustic_Grand_Piano); overload;
       procedure PlayNote( _S: String; _Patch: Integer = p_Acoustic_Grand_Piano); overload;
       procedure PlayRandomNote;
       class function Midi_from_note( _note: String): Integer;
     end;

implementation

{ TAndroid_Midi }

constructor TAndroid_Midi.Create( _mm: jMidiManager);
begin
     mm:= _mm;
     Last_note:= 0;
end;

destructor TAndroid_Midi.Destroy;
begin
 inherited Destroy;
end;

procedure TAndroid_Midi.Stop;
begin
     if 0 = Last_note then exit;

     MM.PlayChNoteVol(1, Last_note, 0);
end;

procedure TAndroid_Midi.PlayNote(_N: Integer; _Patch: Integer = p_Acoustic_Grand_Piano);
begin
     if not MM.Active then exit;

     if 0 <> Last_note then MM.PlayChNoteVol(1, Last_note, 0);
     Last_note:= _N;

     //ShowMessage(ClassName+'.PlayNote: '+IntToStr( _N));
     MM.SetChPatch(1, _Patch);
     MM.SetChVol(1, 90);  // channel 1 volume 90
     MM.PlayChNoteVol(1, _N, 80);  // play the note
     //Sleep(500);  // wait a little
     //MM.PlayChNoteVol(1, _N, 0); // silence the note
end;

procedure TAndroid_Midi.PlayNote(_S: String; _Patch: Integer = p_Acoustic_Grand_Piano);
begin
     PlayNote( Midi_from_note( _S), _Patch);
end;

procedure TAndroid_Midi.PlayRandomNote;
var
   patch: Integer;
  N: integer;
begin
     if not MM.Active then exit;


     patch:= random(80);
     N := 48 + random(25); // choose a random note between C4 and C6;
     //mm.ShowMessage(ClassName+'.PlayRandomNote: '+IntToStr( N)+', patch '+IntToStr( patch));

     MM.SetChPatch(1, patch); // select a random patch among the first 80
     MM.SetChVol(1, 90);  // channel 1 volume 90
     MM.PlayChNoteVol(1, N, 80);  // play the note
     Sleep(500);  // wait a little
     MM.PlayChNoteVol(1, N, 0); // silence the note
end;

class function TAndroid_Midi.Midi_from_note( _note: String): Integer;
//C4=60
   function Base_from_Octave( _Octave:Integer): Integer;
   begin
        case _Octave
        of
          -1:   Result:=   0;
           0:   Result:=  12;
           1:   Result:=  24;
           2:   Result:=  36;
           3:   Result:=  48;
           4:   Result:=  60;
           5:   Result:=  72;
           6:   Result:=  84;
           7:   Result:=  96;
           8:   Result:= 108;
          else Result:= 0;
          end;
   end;
   function Offset_from_Note( _Note: Char): Integer;
   begin
        case _Note
        of
          'C':   Result:=  0;
          'D':   Result:=  2;
          'E':   Result:=  4;
          'F':   Result:=  5;
          'G':   Result:=  7;
          'A':   Result:=  9;
          'B':   Result:= 11;
          else   Result:=  0;
          end;
   end;
var
   Octave: Integer;
   Note: Char;
begin
     Octave:= StrToInt( Copy(_Note, 2, 1));
     Note:= _Note[1];
     Result:= Base_from_Octave( Octave)+Offset_from_Note( Note);
end;

end.

