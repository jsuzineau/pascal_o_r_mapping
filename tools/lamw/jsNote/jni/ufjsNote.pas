{Hint: save all files to location: C:\adt32\eclipse\workspace\AppActionBarTabDemo1\jni }
unit ufjsNote;
  
{$mode delphi}
  
interface
  
uses
    uuStrings,
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
  Laz_And_Controls_Events, AndroidWidget, actionbartab, midimanager,
  textfilemanager;
  
type

  { TfjsNote }

  TfjsNote = class(jForm)
      bNote: jButton;
      abt: jActionBarTab;
      bStart: jButton;
      wv: jWebView;
      mm: jMidiManager;
      pTab1: jPanel;

      procedure bStartClick(Sender: TObject);
      procedure fjsNoteJNIPrompt(Sender: TObject);
      procedure bNoteClick(Sender: TObject);
      procedure wvStatus(Sender: TObject; Status: TWebViewStatus; URL: String;var CanNavi: Boolean);
  //méthodes
  private
    function  ProcessURL(URL: string): boolean;
    procedure PlayNote( _N: Integer);
    procedure PlayRandomNote;
  end;
  
var
  fjsNote: TfjsNote;

implementation
  
{$R *.lfm}

{ TfjsNote }

procedure TfjsNote.fjsNoteJNIPrompt(Sender: TObject);
begin
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
         MM.Close;
         bStart.Text:= 'Start';
         end
     else
         begin
         MM.OpenInput('D1P0');
         bStart.Text:= 'Stop';
         end;
end;

procedure TfjsNote.bNoteClick(Sender: TObject);
begin
     PlayRandomNote;
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

function Midi_from_note( _note: String): Integer;
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
function TfjsNote.ProcessURL(URL: string): boolean;
var
   S: String;
begin
     Result:= False;
     ShowMessage(ClassName+'.ProcessURL: '+URL);

     S:= StrTok( ':', URL);
     if 'play' <> S then exit;

     PlayNote( Midi_from_note( URL));
     Result:= True;
end;

procedure TfjsNote.PlayNote( _N: Integer);
begin
     if not MM.Active then exit;

     ShowMessage(ClassName+'.PlayNote: '+IntToStr( _N));
     //MM.SetChPatch(1, 67{tenor sax});
     //MM.SetChPatch(1, 20);//orgue
     //MM.SetChPatch(1, 41);//violon
     //MM.SetChPatch(1, 53);//choeur Aaah
     MM.SetChPatch(1, 1);//Acoustic Grand Piano
     MM.SetChVol(1, 90);  // channel 1 volume 90
     MM.PlayChNoteVol(1, _N, 80);  // play the note
     //Sleep(500);  // wait a little
     //MM.PlayChNoteVol(1, _N, 0); // silence the note
end;


procedure TfjsNote.PlayRandomNote;
var
   patch: Integer;
  N: integer;
begin
     if not MM.Active then exit;


     patch:= random(80);
     N := 48 + random(25); // choose a random note between C4 and C6;
     ShowMessage(ClassName+'.PlayRandomNote: '+IntToStr( N)+', patch '+IntToStr( patch));

     MM.SetChPatch(1, patch); // select a random patch among the first 80
     MM.SetChVol(1, 90);  // channel 1 volume 90
     MM.PlayChNoteVol(1, N, 80);  // play the note
     Sleep(500);  // wait a little
     MM.PlayChNoteVol(1, N, 0); // silence the note
end;

end.

