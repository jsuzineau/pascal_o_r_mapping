{Hint: save all files to location: C:\adt32\eclipse\workspace\AppActionBarTabDemo1\jni }
unit ufjsNote;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
    Laz_And_Controls_Events, AndroidWidget, actionbartab, midimanager;
  
type

  { TfjsNote }

  TfjsNote = class(jForm)
      abt: jActionBarTab;
      jButton1: jButton;
      jButton2: jButton;
      bNote: jButton;
      jCheckBox1: jCheckBox;
      jEditText1: jEditText;
      jEditText2: jEditText;
      il: jImageList;
      jImageView1: jImageView;
      jImageView3: jImageView;
      jListView1: jListView;
      mm: jMidiManager;
      pTab1: jPanel;
      pTab2: jPanel;
      pTab3_custom_tab_view: jPanel;
      pTab3: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;

      procedure fjsNoteJNIPrompt(Sender: TObject);
      procedure abtTabSelected(Sender: TObject; view: jObject; title: string);
      procedure abtUnSelected(Sender: TObject; view: jObject; title: string);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure bNoteClick(Sender: TObject);
      procedure jCheckBox1Click(Sender: TObject);
      procedure pTab1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure pTab2FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure pTab3FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure jTextView3Click(Sender: TObject);
  //méthodes
  private
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

    //prepare custom tab view - pTab3_custom_tab_view
    pTab3_custom_tab_view.MatchParent();
    //pTab3_custom_tab_view.CenterInParent();
    jTextView3.TextTypeFace:= tfBold;
    jImageView1.SetImageByResIdentifier('ic_bullet_red');    //...\res\drawable-xxx
    jCheckBox1.Checked:= True;

    abt.Add('NAME'   , pTab1.View {sheet view}, 'ic_bullet_green');    // ...\res\drawable-xxx
    abt.Add('ADDRESS', pTab2.View {sheet view}, 'ic_bullet_yellow'); //...\res\drawable-xxx
    abt.Add('ADDLIST', pTab3.View {sheet view}, pTab3_custom_tab_view.View {custom tab view!});

    SetTabNavigationModeActionBar;  //this is needed!!!
end;

procedure TfjsNote.abtTabSelected(Sender: TObject;
  view: jObject; title: string);
begin
    //ShowMessage('Tab Selected: '+title);
end;

procedure TfjsNote.abtUnSelected(Sender: TObject;
  view: jObject; title: string);
begin
   //ShowMessage('Tab Un Selected: '+title);
end;

procedure TfjsNote.jButton1Click(Sender: TObject);
begin

  if jCheckBox1.Checked then
  begin
     jListView1.Add(jEditText1.Text);
     ShowMessage(jEditText1.Text + ': Added to List ...')
  end
  else ShowMessage(jEditText1.Text + ': Not Listed!');
end;

procedure TfjsNote.jButton2Click(Sender: TObject);
begin
    if jCheckBox1.Checked then
    begin
      jListView1.Add(jEditText2.Text);
      ShowMessage(jEditText2.Text + ': Added to List ... ');
    end
    else ShowMessage(jEditText2.Text + ': Not Listed!');
end;

procedure TfjsNote.bNoteClick(Sender: TObject);
begin
     MM.OpenInput('D1P0');
     try
        PlayRandomNote;
     finally
            MM.Close;
            end;
end;

procedure TfjsNote.jCheckBox1Click(Sender: TObject);
begin
  abt.SelectTabByIndex(2);
end;

procedure TfjsNote.pTab1FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
   case flingGesture of
     fliLeftToRight: abt.SelectTabByIndex(2);
     fliRightToLeft: abt.SelectTabByIndex(1);
  end;
end;

procedure TfjsNote.pTab2FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
   case flingGesture of
     fliLeftToRight: abt.SelectTabByIndex(0);
     fliRightToLeft: abt.SelectTabByIndex(2);
  end;
end;

procedure TfjsNote.pTab3FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
  case flingGesture of
    fliLeftToRight: abt.SelectTabByIndex(1);
    fliRightToLeft: abt.SelectTabByIndex(3);
  end;
end;

procedure TfjsNote.jTextView3Click(Sender: TObject);
begin
  abt.SelectTabByIndex(2);
end;

procedure TfjsNote.PlayRandomNote;
var
  N: integer;
begin
     if not MM.Active then exit;


     MM.SetChPatch(1, random(80)); // select a random patch among the first 80
     MM.SetChVol(1, 90);  // channel 1 volume 90
     N := 48 + random(25); // choose a random note between C4 and C6;
     MM.PlayChNoteVol(1, N, 80);  // play the note
     Sleep(500);  // wait a little
     MM.PlayChNoteVol(1, N, 0); // silence the note
end;

end.

