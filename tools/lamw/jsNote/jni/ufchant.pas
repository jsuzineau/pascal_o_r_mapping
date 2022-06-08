{hint: Pascal files location: ...\AppLAMWProject1\jni }
unit ufChant;

{$mode delphi}

interface

uses
    uFrequence,
    uFrequences,
    uAndroid_Midi,
    uAudioTrack,
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, AndroidWidget, Laz_And_Controls, audiotrack;
 
type

 { TfChant }

 TfChant = class(jForm)
  at: jAudioTrack;
  bAlto: jButton;
  bBasse: jButton;
  bSoprano: jButton;
  bStop: jButton;
  bTenor: jButton;
  eAlto: jEditText;
  eBasse: jEditText;
  eSoprano: jEditText;
  eTenor: jEditText;
  Panel1: jPanel;
  TextView1: jTextView;
  procedure bAltoClick(Sender: TObject);
  procedure bBasseClick(Sender: TObject);
  procedure bSopranoClick(Sender: TObject);
  procedure bStopClick(Sender: TObject);
  procedure bTenorClick(Sender: TObject);
 private
  {private declarations}
  m: TAndroid_Midi;
  procedure Play_Note( _Note: String);
  procedure at_Play_Note( _Note: String);
 public
  {public declarations}
  procedure Initialise( _m: TAndroid_Midi);
 end;

implementation
 
{$R *.lfm}

{ TfChant }

//Malkiat izvor: tout en D4
//Krassiv é Jivota: SA: E4 TB: E3
//Proletna pessen; S E4, A C4, T G3, B C3
procedure TfChant.Initialise( _m: TAndroid_Midi);
begin
     m:= _m;
     InitShowing;
end;

procedure TfChant.bSopranoClick(Sender: TObject);
begin
     Play_Note( eSoprano.Text);
end;

procedure TfChant.bAltoClick(Sender: TObject);
begin
     Play_Note( eAlto.Text);
end;

procedure TfChant.bTenorClick(Sender: TObject);
begin
     Play_Note( eTenor.Text);
end;

procedure TfChant.bBasseClick(Sender: TObject);
begin
     Play_Note( eBasse.Text);
end;

procedure TfChant.Play_Note(_Note: String);
begin
     //m.PlayNote( _Note, m.p_tenor_sax);

     at.Stop;
     at_Play_Note( _Note);

     //TAudioTrack.Play( _Note);
     //TAudioTrack.Play_Old( _Note, 5);
end;

procedure TfChant.at_Play_Note(_Note: String);
var
   Frequence: double;
   i: Integer;
   a: double;
   Sample: double;
begin
     Frequence:= Frequences.Frequence_from_Midi( Midi_from_note( _Note));
     for i:= Low(at.Buffer) to High(at.Buffer)
     do
       begin
       a:= IfThen<double>( i > at.SampleRateInHz, 1, i/at.SampleRateInHz);//montée de volume de 0 à 1 sur la première seconde
       Sample:= a*sin(2 * PI * i / (at.SampleRateInHz / Frequence)); // Sine wave
       at.Buffer[i]:= Trunc(Sample * SmallInt.MaxValue);  // Higher amplitude increases volume
       end;
     at.Write_Buffer_all;
     at.Play;
end;

procedure TfChant.bStopClick(Sender: TObject);
begin
     m.Stop;
     at.Stop;
end;

end.
