{Hint: save all files to location: C:\adt32\eclipse\workspace\AppActionBarTabDemo1\jni }
unit ufjsNote;
  
{$mode delphi}
  
interface
  
uses
  Classes, SysUtils, And_jni, And_jni_Bridge, Laz_And_Controls,
    Laz_And_Controls_Events, AndroidWidget, actionbartab;
  
type

  { TfjsNote }

  TfjsNote = class(jForm)
      abt: jActionBarTab;
      jButton1: jButton;
      jButton2: jButton;
      jCheckBox1: jCheckBox;
      jEditText1: jEditText;
      jEditText2: jEditText;
      il: jImageList;
      jImageView1: jImageView;
      jImageView2: jImageView;
      jImageView3: jImageView;
      jListView1: jListView;
      jPanel1: jPanel;
      jPanel2: jPanel;
      jPanel3: jPanel;
      jPanel4: jPanel;
      pCle_Sol_8vb: jPanel;
      jTextView1: jTextView;
      jTextView2: jTextView;
      jTextView3: jTextView;

      procedure fjsNoteJNIPrompt(Sender: TObject);
      procedure abtTabSelected(Sender: TObject; view: jObject; title: string);
      procedure abtUnSelected(Sender: TObject; view: jObject; title: string);
      procedure jButton1Click(Sender: TObject);
      procedure jButton2Click(Sender: TObject);
      procedure jCheckBox1Click(Sender: TObject);
      procedure jPanel1FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure jPanel2FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure jPanel4FlingGesture(Sender: TObject; flingGesture: TFlingGesture);
      procedure jTextView3Click(Sender: TObject);
      procedure pCle_Sol_8vbFlingGesture(Sender: TObject;
        flingGesture: TFlingGesture);

    private
      {private declarations}
    public
      {public declarations}
  end;
  
var
  fjsNote: TfjsNote;

implementation
  
{$R *.lfm}

{ TfjsNote }

procedure TfjsNote.fjsNoteJNIPrompt(Sender: TObject);
begin
    Self.SetIconActionBar('ic_bullets');

    //prepare custom tab view - jPanel3
    jPanel3.MatchParent();
    //jPanel3.CenterInParent();
    jTextView3.TextTypeFace:= tfBold;
    jImageView1.SetImageByResIdentifier('ic_bullet_red');    //...\res\drawable-xxx
    jCheckBox1.Checked:= True;
    pCle_Sol_8vb.MatchParent;

    abt.Add('NAME', jPanel1.View{sheet view}, 'ic_bullet_green');    // ...\res\drawable-xxx
    abt.Add('ADDRESS', jPanel2.View {sheet view}, 'ic_bullet_yellow'); //...\res\drawable-xxx
    abt.Add('ADDLIST', jPanel4.View{sheet view}, jPanel3.View {custom tab view!});
    abt.Add('Clé Sol 8vb', pCle_Sol_8vb.View{sheet view}, jPanel4.View {custom tab view!});

    Self.SetTabNavigationModeActionBar;  //this is needed!!!

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

procedure TfjsNote.jCheckBox1Click(Sender: TObject);
begin
  abt.SelectTabByIndex(2);
end;

procedure TfjsNote.jPanel1FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
   case flingGesture of
     fliLeftToRight: abt.SelectTabByIndex(2);
     fliRightToLeft: abt.SelectTabByIndex(1);
  end;
end;

procedure TfjsNote.jPanel2FlingGesture(Sender: TObject;
  flingGesture: TFlingGesture);
begin
   case flingGesture of
     fliLeftToRight: abt.SelectTabByIndex(0);
     fliRightToLeft: abt.SelectTabByIndex(2);
  end;
end;

procedure TfjsNote.jPanel4FlingGesture(Sender: TObject;
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

procedure TfjsNote.pCle_Sol_8vbFlingGesture( Sender: TObject; flingGesture: TFlingGesture);
begin
     case flingGesture
     of
       fliLeftToRight: abt.SelectTabByIndex(2);
       fliRightToLeft: abt.SelectTabByIndex(0);
     end;
end;

end.

