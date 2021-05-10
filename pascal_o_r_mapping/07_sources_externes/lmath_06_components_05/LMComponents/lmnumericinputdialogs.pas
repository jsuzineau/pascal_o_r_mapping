unit lmnumericinputdialogs;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Controls, StdCtrls, Forms, Dialogs, uTypes, uIntervals, lmNumericEdits,
  Buttons, ButtonPanel, Spin;

// input dialog with two float edits. Sets TInterval; one edit is fot Low, other for High.
// Returns True if was closed with OK, false otherwise
function IntervalQuery(ACaption, APrompt1, APrompt2 : string; var AInterval:TInterval):boolean;

// input dialog for Float input. True if closed with OK
function FloatInputDialog(const InputCaption, InputPrompt : String; var AValue : Float) : Boolean;

function IntegerInputDialog(const InputCaption, InputPrompt : String; var AValue : Integer;
  AMinValue : integer = 0; AMaxValue : integer = 100; AIncrement : integer = 1) : Boolean;

implementation
{$R lmnumericinputdialogs.lfm}

type
  { TIntervalEditDialog }
  TIntervalEditDialog = class(TForm)
    OkBtn: TBitBtn;
    CancelBtn: TBitBtn;
    LoEditLabel: TLabel;
    HiEditLabel: TLabel;
    LowEdit: TFloatEdit;
    HiEdit: TFloatEdit;
    procedure OKClick(Sender: TObject);
  end;

var
  IntervalEditDialog: TIntervalEditDialog;

function BuildForm(const InputCaption, InputPrompt : String; out Prompt:TLabel):TForm;
var
  Form:TForm;
begin
  Form := TForm(TForm.NewInstance);
  Form.DisableAutoSizing;
  Form.CreateNew(nil, 0);
  with Form do
  begin
    PopupMode := pmAuto;
    BorderStyle := bsDialog;
    Caption := InputCaption;
    Position := poScreenCenter;
    Prompt := TLabel.Create(Form);
    with Prompt do
    begin
      Parent := Form;
      Caption := InputPrompt;
      Align := alTop;
      AutoSize := True;
    end;
    with TButtonPanel.Create(Form) do
    begin
      Top := Prompt.Height * 3;
      Parent := Form;
      ShowBevel := False;
      ShowButtons := [pbOK, pbCancel];
      Align := alTop;
    end;
    ChildSizing.TopBottomSpacing := 6;
    ChildSizing.LeftRightSpacing := 6;
    AutoSize := True;
    EnableAutoSizing;
  end;
  Result := Form;
end;

function FloatInputDialog(const InputCaption, InputPrompt : String; var AValue : Float) : Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TFloatEdit;
begin
  Result := False;
  Form := BuildForm(InputCaption, InputPrompt, Prompt);
  Edit := TFloatEdit.Create(Form);
  with Edit do
  begin
    Parent := Form;
    Top := Prompt.Height;
    Align := alTop;
    BorderSpacing.Top := 3;
    Constraints.MinWidth := 150;
    Edit.Value := AValue;
    TabStop := True;
    TabOrder := 0;
  end;
  // upon show, the edit control will be focused for editing, because it's
  // the first in the tab order
  if (Form.ShowModal = mrOk) and not Edit.ValueEmpty then
  begin
    AValue := Edit.Value;
    Result := True;
  end;
  Form.Free;
end;

function IntegerInputDialog(const InputCaption, InputPrompt : String; var AValue : Integer;
  AMinValue : integer = 0; AMaxValue : integer = 100; AIncrement : integer = 1) : Boolean;
var
  Form: TForm;
  Prompt: TLabel;
  Edit: TSpinEdit;
begin
  Result := False;
  Form := BuildForm(InputCaption, InputPrompt,Prompt);
  Edit := TSpinEdit.Create(Form);
  with Edit do
  begin
    Parent := Form;
    Top := Prompt.Height;
    Align := alTop;
    BorderSpacing.Top := 3;
    Constraints.MinWidth := 150;
    Value := AValue;
    TabStop := True;
    TabOrder := 0;
    Increment := AIncrement;
    MaxValue := AMaxValue;
    MinValue := AMinValue;
  end;
  // upon show, the edit control will be focused for editing, because it's
  // the first in the tab order
  if (Form.ShowModal = mrOk) and not Edit.ValueEmpty then
  begin
    AValue := Edit.Value;
    Result := True;
  end;
  Form.Free;
end;

function IntervalQuery(ACaption, APrompt1, APrompt2 : string; var AInterval:TInterval):boolean;
begin
  Application.CreateForm(TIntervalEditDialog,IntervalEditDialog);
  with IntervalEditDialog do
  begin
    OKBtn.ModalResult := mrNone;
    OKBtn.OnClick := @(IntervalEditDialog.OKClick);
    LowEdit.Value := AInterval.Lo;
    HiEdit.Value := AInterval.Hi;
    Caption := ACaption;
    LoEditLabel.Caption := APrompt1;
    HiEditLabel.Caption := APrompt2;
    Result := ShowModal = mrOK;
    if Result then
    begin
      if not LowEdit.ValueEmpty then AInterval.Lo := LowEdit.Value;
      if not HiEdit.ValueEmpty then AInterval.Hi := HiEdit.Value;
    end;
  end;
  FreeAndNil(IntervalEditDialog);
end;

procedure TIntervalEditDialog.OKClick(Sender: TObject);
begin
  if LowEdit.ValueEmpty then
  begin
    LowEdit.SetFocus;
    LowEdit.SelectAll;
    ModalResult := mrNone;
  end else
  if HiEdit.ValueEmpty then
  begin
    HiEdit.SetFocus;
    LowEdit.SelectAll;
    ModalResult := mrNone;
  end else
    ModalResult := mrOK;
end;

end.

