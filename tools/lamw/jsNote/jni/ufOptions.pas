unit ufOptions;

{$mode delphi}

interface

uses
    uAndroid_Database,
    uOptions,
 {$IFDEF UNIX}{$IFDEF UseCThreads}
 cthreads,
 {$ENDIF}{$ENDIF}
 Classes, SysUtils, AndroidWidget, radiogroup, Laz_And_Controls, preferences,
 opendialog;
 
type

 { TfOptions }

 TfOptions = class(jForm)
  bDatabase_from_Assets: jButton;
  bDatabase_from_Downloads: jButton;
  bStart: jButton;
  bDatabase_to_Downloads: jButton;
  bEmptyDatabase: jButton;
  cbEditable: jCheckBox;
  od: jOpenDialog;
  Panel1: jPanel;
  rgInstrument: jRadioGroup;
  procedure bDatabase_to_DownloadsClick(Sender: TObject);
  procedure bEmptyDatabaseClick(Sender: TObject);
  procedure bStartClick(Sender: TObject);
  procedure bDatabase_from_DownloadsClick(Sender: TObject);
  procedure bDatabase_from_AssetsClick(Sender: TObject);
  procedure cbEditableClick(Sender: TObject);
  procedure fOptionsJNIPrompt(Sender: TObject);
  procedure odFileSelected(Sender: TObject; path: string; fileName: string);
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
     WriteLn( Classname+'.fOptionsJNIPrompt: début');
     rgInstrument.CheckedIndex:= rgInstrument_CheckedIndex;
     WriteLn( Classname+'.fOptionsJNIPrompt: aprés rgInstrument.CheckedIndex:= rgInstrument_CheckedIndex;');
     cbEditable.Checked:= uOptions.Editable;
     WriteLn( Classname+'.fOptionsJNIPrompt: aprés cbEditable.Checked:= uOptions.Editable;');
end;

procedure TfOptions.rgInstrumentCheckedChanged( Sender: TObject;
                                                checkedIndex: integer;
                                                checkedCaption: string);
begin
     rgInstrument_CheckedIndex:= checkedIndex;
     Options_Save;
end;

procedure TfOptions.bDatabase_from_AssetsClick(Sender: TObject);
begin
     uAndroid_Database_from_Assets( Self, FileName, FileName);
end;

procedure TfOptions.bEmptyDatabaseClick(Sender: TObject);
begin
     uAndroid_Database_from_Assets( Self, 'base_test.sqlite', FileName);
end;

procedure TfOptions.bDatabase_from_DownloadsClick(Sender: TObject);
begin
     uAndroid_Database_require_permission_READ_EXTERNAL_STORAGE( Self);
     od.Show;
end;

procedure TfOptions.odFileSelected( Sender: TObject; path: string; fileName: string);
begin
     uAndroid_Database_from_Downloads( Self,  fileName, uOptions.FileName);
end;

procedure TfOptions.bDatabase_to_DownloadsClick(Sender: TObject);
begin
     uAndroid_Database_to_Downloads( Self,  uOptions.FileName, uOptions.FileName);
end;

procedure TfOptions.cbEditableClick(Sender: TObject);
begin
     uOptions.Editable:= cbEditable.Checked;
     Options_Save;
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
