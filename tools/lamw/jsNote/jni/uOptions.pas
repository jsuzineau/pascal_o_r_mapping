unit uOptions;

{$mode Delphi}

interface

uses
 Classes, SysUtils, midimanager, preferences;

const
     rgInstrument_Midi_Piano    =0;
     rgInstrument_Midi_Tenor_Sax=1;
     rgInstrument_Wave          =2;
     rgInstrument_MP3_432Hz     =3;
     rgInstrument_MP3_440Hz     =4;
var
   Filename: String= 'jsNote.sqlite';
   rgInstrument_CheckedIndex: Integer= rgInstrument_MP3_440Hz;
   mm: jMidiManager= nil;
   pf: jPreferences = nil;
   Editable: Boolean=False;

procedure Options_Restore;
procedure Options_Save;


implementation

procedure Options_Restore;
begin
     rgInstrument_CheckedIndex:= pf.GetIntData ( 'rgInstrument_CheckedIndex', rgInstrument_CheckedIndex);
     Editable                 := pf.GetBoolData( 'Editable'                 , Editable                 );
end;

procedure Options_Save;
begin
     pf.SetIntData ( 'rgInstrument_CheckedIndex', rgInstrument_CheckedIndex);
     pf.GetBoolData( 'Editable'                 , Editable                 );
end;

end.

