unit lmnumericedits;

{$mode objfpc}{$H+}
interface

uses
  Classes, Controls, SysUtils, StdCtrls, StrUtils, Clipbrd, uTypes;

type

  { TFloatEdit }

  TFloatEdit = class(TEdit)
  private
    FDecimals: Integer;
    FValue: Float;
    FValueEmpty: Boolean;
  protected
    procedure TextChanged; override;
    procedure SetDecimals(ADecimals: Integer); virtual;
    procedure SetValue(const AValue: Float); virtual;
    procedure SetValueEmpty(const AValue: Boolean); virtual;
    procedure KeyPress(var Key: char); override;
  public
    constructor Create(TheOwner: TComponent); override;
    procedure PasteFromClipboard; override;
    function ValueToStr(const AValue: Float): String; virtual;
  published
    property DecimalPlaces: Integer read FDecimals write SetDecimals default 2;
    property Value: Float read FValue write SetValue;
    property ValueEmpty: Boolean read FValueEmpty write SetValueEmpty default False;
  end;

procedure Register;

implementation

procedure TFloatEdit.TextChanged;
var
  NewValue:Float;
begin
  FValueEmpty := not TryStrToFloat(Text,NewValue);
  if not FValueEmpty then
    FValue := NewValue;
  inherited;
end;

procedure TFloatEdit.SetValueEmpty(const AValue: Boolean);
begin
  FValueEmpty := AValue;
  if FValueEmpty then
    Text := '';
end;

procedure TFloatEdit.KeyPress(var Key: char);
begin
  if (Key in ['.',',']) then
  begin
    Key := DefaultFormatSettings.Decimalseparator;
    if Pos(Key,Text) <> 0 then
      Key := #0;
  end;
  if not (Key in ['0'..'9','E','e',DefaultFormatSettings.DecimalSeparator,'+','-',#8,#9,^C,^X,^V,^Z]) then Key := #0;
  if (Key in ['+','-']) and not ((SelStart = 0) or (Text[SelStart] in ['e','E'])) then Key := #0;
  if (Key = 'e') then Key := 'E';
  if (Key = 'E') and ((SelStart = 0) or ((SelStart = 1) and (Text[1] in ['-','+'])) or (Pos('E',Text) <> 0)) then Key := #0;
  if (Key = DefaultFormatSettings.DecimalSeparator) and (FDecimals = 0) then Key := #0;
  inherited KeyPress(Key);
end;

procedure TFloatEdit.SetValue(const AValue: Float);
begin
  FValue := AValue;
  Text := ValueToStr(FValue);
end;

procedure TFloatEdit.SetDecimals(ADecimals: Integer);
begin
  if FDecimals = ADecimals then Exit;
  FDecimals := ADecimals;
  Invalidate;
end;

constructor TFloatEdit.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  FValue := 0;
  FDecimals := 3;
end;

procedure TFloatEdit.PasteFromClipboard;
var
  NewText:string;
  NewVal:float;
  ErrCode:integer;
begin
  if Text <> '' then
    NewText := StuffString(Text,SelStart+1,SelLength,Trim(Clipboard.AsText))
  else
    NewText := Clipboard.AsText;
  Val(NewText,NewVal,ErrCode);
  if ErrCode = 0 then
  begin
    FValue := NewVal;
    Text := NewText;
    FValueEmpty := false;
  end;
end;

function TFloatEdit.ValueToStr(const AValue: Float): String;
begin
  Result := FloatToStrF(AValue, ffFixed, 20, DecimalPlaces);
end;

procedure Register;
begin
  RegisterComponents('LMComponents', [TFloatEdit]);
end;


end.
