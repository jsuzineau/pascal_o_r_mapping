unit ufOptions;

{$mode delphi}

interface

uses
    uAndroid_Database,
    uOptions,
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, AndroidWidget, radiogroup, Laz_And_Controls, preferences;
 
type

 { TfOptions }

 TfOptions = class(jForm)
  bDatabase_from_Assets: jButton;
  bDatabase_from_Downloads: jButton;
  bStart: jButton;
  Panel1: jPanel;
  Preferences1: jPreferences;
  rgInstrument: jRadioGroup;
  procedure bStartClick(Sender: TObject);
  procedure bDatabase_from_DownloadsClick(Sender: TObject);
  procedure bDatabase_from_AssetsClick(Sender: TObject);
  procedure fOptionsJNIPrompt(Sender: TObject);
  procedure rgInstrumentCheckedChanged(Sender: TObject; checkedIndex: integer;
   checkedCaption: string);
 private
  {private declarations}
 public
  {public declarations}
 end;

var
 fOptions: TfOptions;

 
implementation

{$R *.lfm}

{ TfOptions }

procedure TfOptions.fOptionsJNIPrompt(Sender: TObject);
begin
     rgInstrument.CheckedIndex:= rgInstrument_CheckedIndex;
end;

procedure TfOptions.rgInstrumentCheckedChanged( Sender: TObject;
                                                checkedIndex: integer;
                                                checkedCaption: string);
begin
     rgInstrument_CheckedIndex:= checkedIndex;
end;

procedure TfOptions.bDatabase_from_AssetsClick(Sender: TObject);
begin
     uAndroid_Database_from_Assets( Self, FileName);
end;

procedure TfOptions.bDatabase_from_DownloadsClick(Sender: TObject);
begin
     uAndroid_Database_from_Downloads( Self, FileName);
end;

procedure TfOptions.bStartClick(Sender: TObject);
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

end.
