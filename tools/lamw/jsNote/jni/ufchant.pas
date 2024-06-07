{hint: Pascal files location: ...\AppLAMWProject1\jni }
unit ufChant;

{$mode delphi}

interface

uses
    uuStrings,
    uForms,
    uFrequence,
    uFrequences,
    uAndroid_Midi,
    uAudioTrack,

    ujsDataContexte,
    uSGBD,
    uSQLite_Android,
    uLog,
    uAndroid_Database,
    uChamps,
    ublChant,

    udmDatabase,
    upool,
    upoolChant,

    uRequete,


    ufAccueil_Erreur,
    ufUtilitaires,

    uchChamp_Edit, uchChamp_Button,
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, AndroidWidget, Laz_And_Controls,
 {$IFDEF AudioTrack}
 audiotrack,
 {$ENDIF}
 menu, And_jni,
 radiogroup, midimanager, downloadmanager, mediaplayer;
 
type

 { TfChant }

 TfChant
 =
  class(jForm)
    {$IFDEF AudioTrack}
    at: jAudioTrack;
    {$ENDIF}
    bN2: jButton;
    bN4: jButton;
    bN1: jButton;
    bStart: jButton;
    bStop: jButton;
    bN3: jButton;
    bPrecedent: jButton;
    bSuivant: jButton;
    bUtilitaires: jButton;
    bTelechargement: jButton;
    bTutti: jButton;
    eTitre: jEditText;
    eN2: jEditText;
    eN4: jEditText;
    eN1: jEditText;
    eN3: jEditText;
    hcbT2: ThChamp_Button;
    hcbT3: ThChamp_Button;
    hcbT4: ThChamp_Button;
    hceTitre: ThChamp_Edit;
    hceN2: ThChamp_Edit;
    hceN4: ThChamp_Edit;
    hceN1: ThChamp_Edit;
    hceN3: ThChamp_Edit;
    hcbT1: ThChamp_Button;
    jm: jMenu;
    mp: jMediaPlayer;
    mm: jMidiManager;
    Panel1: jPanel;
    rgInstrument: jRadioGroup;
    sc: jSqliteCursor;
    sda: jSqliteDataAccess;
    tvMidi: jTextView;
    tvLatin: jTextView;
    procedure bN2Click(Sender: TObject);
    procedure bN4Click(Sender: TObject);
    procedure bPrecedentClick(Sender: TObject);
    procedure bN1Click(Sender: TObject);
    procedure bStartClick(Sender: TObject);
    procedure bStopClick(Sender: TObject);
    procedure bSuivantClick(Sender: TObject);
    procedure bN3Click(Sender: TObject);
    procedure bTelechargementClick(Sender: TObject);
    procedure bTuttiClick(Sender: TObject);
    procedure bUtilitairesClick(Sender: TObject);
    procedure fChantClickOptionMenuItem(Sender: TObject; jObjMenuItem: jObject;
     itemID: integer; itemCaption: string; checked: boolean);
    procedure fChantCreateOptionMenu(Sender: TObject; jObjMenu: jObject);
    procedure fChantJNIPrompt(Sender: TObject);
    procedure fChantRequestPermissionResult(Sender: TObject;
     requestCode: integer; manifestPermission: string;
     grantResult: TManifestPermissionResult);
    procedure mpCompletion(Sender: TObject);
    procedure mpPrepared(Sender: TObject; videoWidth: integer;
     videoHeight: integer);
  private const
    rgInstrument_Midi_Piano    =0;
    rgInstrument_Midi_Tenor_Sax=1;
    rgInstrument_Wave          =2;
    rgInstrument_MP3_432Hz     =3;
    rgInstrument_MP3_440Hz     =4;
  private
    sl: TslChant;
    NbChants: Integer;
    Filename: String;
    procedure Play_Note( _Note: String);
    procedure at_Play_Note( _Note: String);
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //Gestion de l'affichage
  public
    bl: TblChant;
    Index_Courant: Integer;
    procedure Affiche( _Index: Integer);
  //Gestion Midi
  public
    m: TAndroid_Midi;
  //Tutti
  public
    nTutti: Integer;
  end;

var
  fChant: TfChant;

implementation
 
{$R *.lfm}

{ TfChant }

//Malkiat izvor: tout en D4 ré3
//Krassiv é Jivota: SA: E4 mi3          TB: E3 mi2
//Proletna pessen ; S E4 mi3, A C4 do3, T G3 sol2, B C3 do2

//Vecer Soutrin tout en A3 la2
//Aoum  SAT A3 la2, basse A2 la1
//Otche Nach S F4 fa3, A D4 ré3, T A3 la2, B D3 ré2
constructor TfChant.Create(AOwner: TComponent);
begin
     inherited Create(AOwner);
     sl:= TslChant.Create( ClassName+'.sl');
     Index_Courant:= -1;
     m:= nil;
     nTutti:= 0;
end;

destructor TfChant.Destroy;
begin
     FreeAndNil( m);
     FreeAndNil( sl);
     inherited Destroy;
end;

procedure TfChant.fChantJNIPrompt(Sender: TObject);
var
   NbChants_ok: Boolean;
begin
     m:= TAndroid_Midi.Create( mm);

     Filename:= 'jsNote.sqlite';

     poolChant.ToutCharger( sl);
     WriteLn( Classname+'.fChantJNIPrompt: sl.Count=',sl.Count);
     Affiche( sl.Count-1);

     NbChants_ok:= Requete.Integer_from( 'select count(*) as NbLignes from Chant', 'NbLignes', NbChants);
     WriteLn( Classname+'.fChantJNIPrompt: Requete NbLignes= ',NbChants, ', NbLignes_ok= ',NbChants_ok);

     rgInstrument.CheckedIndex:= rgInstrument_MP3_432Hz;
end;

procedure TfChant.Affiche( _Index: Integer);
begin
          if 0        > _Index then _Index:= NbChants-1
     else if NbChants < _Index then _Index:= 0         ;

     Index_Courant:= _Index;
     bl:= blChant_from_sl( sl, Index_Courant);
     WriteLn( Classname+'.Affiche: Index_Courant=',Index_Courant);
     Champs_Affecte( bl, [ hceTitre,
                           hceN1,hcbT1,
                           hceN2,hcbT2,
                           hceN3,hcbT3,
                           hceN4,hcbT4]);
end;

procedure TfChant.bSuivantClick(Sender: TObject);
begin
     Affiche( Index_Courant+1);
end;
procedure TfChant.bPrecedentClick(Sender: TObject);
begin
     Affiche( Index_Courant-1);
end;
procedure TfChant.bTuttiClick(Sender: TObject);
begin
     nTutti:= 2;
     Play_Note( eN1.Text);
end;

procedure TfChant.bN1Click(Sender: TObject);
begin
     Play_Note( eN1.Text);
end;

procedure TfChant.bN2Click(Sender: TObject);
begin
     Play_Note( eN2.Text);
end;

procedure TfChant.bN3Click(Sender: TObject);
begin
     Play_Note( eN3.Text);
end;

procedure TfChant.bN4Click(Sender: TObject);
begin
     Play_Note( eN4.Text);
end;

procedure TfChant.Play_Note(_Note: String);
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

     case rgInstrument.CheckedIndex
     of
       rgInstrument_Midi_Piano    : Piano;
       rgInstrument_Midi_Tenor_Sax: Tenor_Sax;
       rgInstrument_Wave          : Wave;
       rgInstrument_MP3_432Hz     : MP3_432Hz;
       rgInstrument_MP3_440Hz     : MP3_440Hz;
       else                         Wave;
       end;
end;

procedure TfChant.at_Play_Note(_Note: String);
{$IFDEF AudioTrack}
var
   Midi: Integer;
   Frequence: double;
   i: Integer;
   a: double;
   Sample: double;
{$ENDIF}
begin
     {$IFDEF AudioTrack}
     Midi:= Midi_from_note( _Note)+12;//+12 correction provisoire différence de n° d'octave avec MuseScore
     Frequence:= Frequences.Frequence_from_Midi( Midi);
     for i:= Low(at.Buffer) to High(at.Buffer)
     do
       begin
       a:= IfThen<double>( i > at.SampleRateInHz, 1, i/at.SampleRateInHz);//montée de volume de 0 à 1 sur la première seconde
       Sample:= a*sin(2 * PI * i / (at.SampleRateInHz / Frequence)); // Sine wave
       at.Buffer[i]:= Trunc(Sample * SmallInt.MaxValue);  // Higher amplitude increases volume
       end;
     at.Write_Buffer_all;
     WriteLn( ClassName+'.at_Play_Note: aprés at.Write_Buffer_all, ',
              'at.GetState=',at.GetState,', ',
              'at.getMaxVolume=',at.GetMaxVolume);
     at.Play;
     {$ENDIF}
end;

procedure TfChant.bStartClick(Sender: TObject);
begin
     if mm.Active
     then
         begin
         mm.Close;
         bStart.Text:= 'Midi Start';
         end
     else
         begin
         mm.OpenInput('D1P0');
         bStart.Text:= 'Midi Stop';
         end;
end;

procedure TfChant.bStopClick(Sender: TObject);
begin
     m.Stop;

     {$IFDEF AudioTrack}
     //at.Stop;  //si mode AudioTrack.MODE_STATIC 0
     at.Pause;at.Flush;//si mode AudioTrack.MODE_STREAM
     {$ENDIF}
end;

procedure TfChant.fChantCreateOptionMenu(Sender: TObject; jObjMenu: jObject);
begin
     jm.AddItem( jObjMenu, 1, 'Utilitaires', 'ic_launcher', mitDefault, misIfRoomWithText);
end;

procedure TfChant.fChantClickOptionMenuItem( Sender: TObject;
                                             jObjMenuItem: jObject;
                                             itemID: integer;
                                             itemCaption: string;
                                             checked: boolean);
begin
     case itemID
     of
       1: fUtilitaires( Filename).Show;
       end;
end;

procedure TfChant.bUtilitairesClick(Sender: TObject);
begin
     uAndroid_Database_Recree_Base( Self, FileName);
end;

procedure TfChant.bTelechargementClick(Sender: TObject);
begin
     uAndroid_Database_from_Downloads( Self, FileName);
end;

procedure TfChant.fChantRequestPermissionResult( Sender: TObject;
                                                 requestCode: integer;
                                                 manifestPermission: string;
                                                 grantResult: TManifestPermissionResult);
begin
     case requestCode
     of
       permission_READ_EXTERNAL_STORAGE_request_code:
         if grantResult = PERMISSION_GRANTED
         then
             ShowMessage('Succés! ['+manifestPermission+'] Permission accordée !!! ' )
         else  //PERMISSION_DENIED
             ShowMessage('Désolé... ['+manifestPermission+'] Permission non accordée ... ' );
       end;
end;

procedure TfChant.mpPrepared( Sender: TObject; videoWidth: integer; videoHeight: integer);
begin
     mp.Start;
end;

procedure TfChant.mpCompletion(Sender: TObject);
     procedure Process_nTutti;
     var
        Note: String;
     begin
          case nTutti
          of
            2:begin Note:= eN2.Text; Inc(nTutti); end;
            3:begin Note:= eN3.Text; Inc(nTutti); end;
            4:begin Note:= eN4.Text; Inc(nTutti); end;
            end;
          if '' <> Note
          then
              Play_Note( Note);
     end;
begin
     mp.Reset();
     Process_nTutti;
end;

end.

/storage/emulated/0/Download/jsNote.sqlite
/storage/emulated/0/Download/jsNote.sqlite

