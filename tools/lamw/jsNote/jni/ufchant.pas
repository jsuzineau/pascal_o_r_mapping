{hint: Pascal files location: ...\AppLAMWProject1\jni }
unit ufChant;

{$mode delphi}

interface

uses
 uAndroid_Midi,
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, AndroidWidget, Laz_And_Controls;
 
type

 { TfChant }

 TfChant = class(jForm)
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
     m.PlayNote( eSoprano.Text, m.p_tenor_sax);
end;

procedure TfChant.bAltoClick(Sender: TObject);
begin
     m.PlayNote( eAlto.Text, m.p_tenor_sax);
end;

procedure TfChant.bTenorClick(Sender: TObject);
begin
     m.PlayNote( eTenor.Text, m.p_tenor_sax);
end;

procedure TfChant.bBasseClick(Sender: TObject);
begin
     m.PlayNote( eBasse.Text, m.p_tenor_sax);
end;

procedure TfChant.bStopClick(Sender: TObject);
begin
     m.Stop;
end;

end.
