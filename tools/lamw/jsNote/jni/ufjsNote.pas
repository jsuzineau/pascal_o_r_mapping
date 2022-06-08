{Hint: save all files to location: C:\adt32\eclipse\workspace\AppActionBarTabDemo1\jni }
unit ufjsNote;
  
{$mode delphi}
  
interface
  
uses
    uuStrings,
    uAndroid_Midi,
    ufChant,
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, actionbartab, midimanager,
  textfilemanager, tablelayout;
  
type

  { TfjsNote }

  TfjsNote = class(jForm)
   bfChant: jButton;
      bNote: jButton;
      abt: jActionBarTab;
      bStart: jButton;
      bStopNote: jButton;
      TableLayout1: jTableLayout;
      wv: jWebView;
      mm: jMidiManager;
      pTab1: jPanel;

      procedure bfChantClick(Sender: TObject);
      procedure bStartClick(Sender: TObject);
      procedure bStopNoteClick(Sender: TObject);
      procedure fjsNoteJNIPrompt(Sender: TObject);
      procedure bNoteClick(Sender: TObject);
      procedure wvStatus(Sender: TObject; Status: TWebViewStatus; URL: String;var CanNavi: Boolean);
  //méthodes
  private
    m: TAndroid_Midi;
    FfChant: TfChant;
    procedure fChant_Show;
    function  ProcessURL(URL: string): boolean;
  end;
  
var
  fjsNote: TfjsNote;

implementation
  
{$R *.lfm}

{ TfjsNote }

procedure TfjsNote.fjsNoteJNIPrompt(Sender: TObject);
begin
     FfChant:= nil;
     m:= TAndroid_Midi.Create( mm);
     SetIconActionBar('ic_bullets');

     abt.Add('NAME', pTab1.View{sheet view}, 'ic_bullet_green');    // ...\res\drawable-xxx
     wv.LoadFromHtmlFile('/android_asset','Cle_Sol_8vb.svg');
     SetTabNavigationModeActionBar;  //this is needed!!!
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

procedure TfjsNote.bfChantClick(Sender: TObject);
begin
     fChant_Show;
end;

procedure TfjsNote.bStopNoteClick(Sender: TObject);
begin
     m.Stop;
end;

procedure TfjsNote.bNoteClick(Sender: TObject);
begin
     m.PlayRandomNote;
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

procedure TfjsNote.fChant_Show;
begin
     if nil = FfChant
     then
         begin
         gApp.CreateForm( TfChant, FfChant);
         FfChant.Initialise( m);
         end
     else
         FfChant.Show;
end;

function TfjsNote.ProcessURL(URL: string): boolean;
var
   S: String;
begin
     Result:= False;
     ShowMessage(ClassName+'.ProcessURL: '+URL);

     S:= StrTok( ':', URL);
     if 'play' <> S then exit;

     m.PlayNote( URL);
     Result:= True;
end;


end.


