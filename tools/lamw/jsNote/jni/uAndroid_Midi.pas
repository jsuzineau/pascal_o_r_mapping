unit uAndroid_Midi;

{$mode delphi}

interface

uses
    uFrequence,
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
     Writeln(Classname+'.PlayNote(',_N,',',_Patch,')');
     if not MM.Active then exit;

     if 0 <> Last_note then MM.PlayChNoteVol(1, Last_note, 0);
     Last_note:= _N;

     //ShowMessage(ClassName+'.PlayNote: '+IntToStr( _N));
     MM.SetChPatch(1, _Patch);
     MM.SetChVol(1, 90);  // channel 1 volume 90
     Writeln(Classname+'.PlayNote: avant MM.PlayChNoteVol');
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

end.

