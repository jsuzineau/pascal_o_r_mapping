{Hint: save all files to location: C:\adt32\eclipse\workspace\AppActionBarTabDemo1\jni }
unit ufjsNote;
  
{$mode delphi}
  
interface
  
uses
    uLog,
    uuStrings,
    uOptions,
    uAndroid_Midi,
    uFrequence,
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, actionbartab, midimanager,
  textfilemanager, tablelayout, mediaplayer;
  
type

  { TfjsNote }

TfjsNote
=
 class(jForm)
   bNote: jButton;
   bStart: jButton;
   bStopNote: jButton;
   mm: jMidiManager;
   mp: jMediaPlayer;
   tvLatin: jTextView;
   tvMidi: jTextView;
   wv: jWebView;
   procedure bStartClick(Sender: TObject);
   procedure bStopNoteClick(Sender: TObject);
   procedure fjsNoteJNIPrompt(Sender: TObject);
   procedure bNoteClick(Sender: TObject);
   procedure mpPrepared(Sender: TObject; videoWidth: integer;
    videoHeight: integer);
   procedure wvStatus(Sender: TObject; Status: TWebViewStatus; URL: String;var CanNavi: Boolean);
 //méthodes
 private
   m: TAndroid_Midi;
   function  ProcessURL(URL: string): boolean;
   procedure Play_Note( _Note: String);
 end;
  
var
  fjsNote: TfjsNote;

implementation
  
{$R *.lfm}

{ TfjsNote }

procedure TfjsNote.fjsNoteJNIPrompt(Sender: TObject);
begin
     if nil = m
     then
         m:= TAndroid_Midi.Create( mm);
     //SetIconActionBar('ic_bullets');

     wv.LoadFromHtmlFile('/android_asset','Cle_Sol_8vb.svg');
     //SetTabNavigationModeActionBar;  //this is needed!!!
end;

procedure TfjsNote.bStartClick(Sender: TObject);
begin
     if MM.Active
     then
         begin
         ShowMessage(ClassName+'.bStartClick: Stop');
         MM.Close;
         bStart.Text:= 'Start';
         end
     else
         begin
         ShowMessage(ClassName+'.bStartClick: Start');
         MM.OpenInput('D1P0');
         bStart.Text:= 'Stop';
         end;
end;

procedure TfjsNote.bStopNoteClick(Sender: TObject);
begin
     m.Stop;
end;

procedure TfjsNote.bNoteClick(Sender: TObject);
begin
     m.PlayRandomNote;
end;

procedure TfjsNote.mpPrepared(Sender: TObject; videoWidth: integer; videoHeight: integer);
begin
     mp.Start;
end;

procedure TfjsNote.wvStatus( Sender: TObject; Status: TWebViewStatus; URL: String; var CanNavi: Boolean);
begin
     if status=wvOnBefore
     then
         begin
         CanNavi:= False; // don't let the WebView try to load a page from the internet
         if URL<>''
         then
             if ProcessURL(URL) then exit;
         end;
end;

function TfjsNote.ProcessURL(URL: string): boolean;
var
   S: String;
begin
     Result:= False;
     //ShowMessage(ClassName+'.ProcessURL: '+URL);

     S:= StrTok( ':', URL);
     if 'play' <> S then exit;

     Play_Note( URL);
     Result:= True;
end;

procedure TfjsNote.Play_Note(_Note: String);
var
   Midi: Integer;
   procedure Piano;
   begin
        m.PlayNote( _Note, m.p_Acoustic_Grand_Piano);
   end;
   procedure Tenor_Sax;
   begin
        m.PlayNote( _Note, m.p_tenor_sax);
   end;
   procedure Wave;
   begin
        {$IFDEF AudioTrack}
        //at.Stop;  //si mode AudioTrack.MODE_STATIC 0
        at.Pause;at.Flush;//si mode AudioTrack.MODE_STREAM

        at_Play_Note( _Note);
        at.SetVolume( 2);

        //TAudioTrack.Play( _Note);
        //TAudioTrack.Play_Old( _Note, 5);
        {$ENDIF}
   end;
   procedure MP3( _Repertoire: String);
   var
      Note_normalisee: String;//pour consolider dièse/bémol
      Nom_mp3: String;
      Repertoire: String;
   begin
        Note_normalisee:= Trim(Note_Octave_Latine( Midi_from_Note( _Note)));
        Nom_mp3:= Note_normalisee+'.mp3';
        Log.PrintLn( ClassName+'.Play_Note: Nom_mp3: '+Nom_mp3);
        //Repertoire
        //:=
        //   IncludeTrailingPathDelimiter( GetEnvironmentDirectoryPath( dirDownloads))
        //  +_Repertoire;
        //mp.LoadFromFile( Repertoire, Nom_mp3);
        mp.LoadFromAssets( IncludeTrailingPathDelimiter( _Repertoire)+ Nom_mp3);

   end;
   procedure MP3_432Hz;
   begin
        MP3( 'notes_432Hz_noire');
   end;
   procedure MP3_440Hz;
   begin
        MP3( 'notes_440Hz_noire');
   end;
begin
     if 0 < Pos(':', _Note)
     then
         StrTok( ':', _Note);
     Midi:= Midi_from_note( _Note);
     tvMidi.Text:= 'Midi '+IntToStr( Midi);
     tvLatin.Text:= Note_Octave_Latine( Midi)+', '+Note_Octave( Midi);

     case rgInstrument_CheckedIndex
     of
       rgInstrument_Midi_Piano    : Piano;
       rgInstrument_Midi_Tenor_Sax: Tenor_Sax;
       rgInstrument_Wave          : Wave;
       rgInstrument_MP3_432Hz     : MP3_432Hz;
       rgInstrument_MP3_440Hz     : MP3_440Hz;
       else                         Wave;
       end;
end;


end.


