unit uOptions;

{$mode Delphi}

interface

uses
 Classes, SysUtils, midimanager;

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

implementation

end.

