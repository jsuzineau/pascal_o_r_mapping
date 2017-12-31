unit ucChamp_Float_SpinEdit;
{                                                                               |
    Author: Jean SUZINEAU <Jean.Suzineau@wanadoo.fr>                            |
            partly as freelance: http://www.mars42.com                          |
        and partly as employee : http://www.adinfo.com                          |
                                 http://www.adi-bat.com                         |
    Copyright 2017 Jean SUZINEAU - MARS42                                       |
    Copyright 2017 GROUPE ADINFO SOFTWARE                                       |
                                                                                |
    This program is free software: you can redistribute it and/or modify        |
    it under the terms of the GNU Lesser General Public License as published by |
    the Free Software Foundation, either version 3 of the License, or           |
    (at your option) any later version.                                         |
                                                                                |
    This program is distributed in the hope that it will be useful,             |
    but WITHOUT ANY WARRANTY; without even the implied warranty of              |
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the               |
    GNU Lesser General Public License for more details.                         |
                                                                                |
    You should have received a copy of the GNU Lesser General Public License    |
    along with this program.  If not, see <http://www.gnu.org/licenses/>.       |
                                                                                |
|                                                                               }

interface

uses
    uChamps,
    uChamp,
  SysUtils, Windows, Classes, Controls, StdCtrls, Spin,
  ExtCtrls, Messages, Forms, Graphics, Menus, Buttons;

type
 TChamp_Float_SpinEdit
 =
  class( TCustomEdit, IChampsComponent)
  //Gestion du cycle de vie
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  //recopié de TSpinEdit
  private
    FMinValue: LongInt;
    FMaxValue: LongInt;
    FIncrement: LongInt;
    FButton: TSpinButton;
    FEditorEnabled: Boolean;
    function GetMinHeight: Integer;
    procedure SetEditRect;
    procedure WMSize(var Message: TWMSize); message WM_SIZE;
    procedure CMEnter(var Message: TCMGotFocus); message CM_ENTER;
    procedure WMPaste(var Message: TWMPaste);   message WM_PASTE;
    procedure WMCut(var Message: TWMCut);   message WM_CUT;
  protected
    procedure GetChildren(Proc: TGetChildProc; Root: TComponent); override;
    function IsValidChar(Key: Char): Boolean; virtual;
    procedure KeyDown(var Key: Word; Shift: TShiftState); override;
    procedure KeyPress(var Key: Char); override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
  public
    property Button: TSpinButton read FButton;
  published
    property Anchors;
    property AutoSelect;
    property AutoSize;
    property Color;
    property Constraints;
    property Ctl3D;
    property DragCursor;
    property DragMode;
    property EditorEnabled: Boolean read FEditorEnabled write FEditorEnabled default True;
    property Enabled;
    property Font;
    property Increment: LongInt read FIncrement write FIncrement default 1;
    property MaxLength;
    property MaxValue: LongInt read FMaxValue write FMaxValue;
    property MinValue: LongInt read FMinValue write FMinValue;
    property ParentColor;
    property ParentCtl3D;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ReadOnly;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnChange;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  //Général
  private
    procedure CMExit(var Message: TCMExit);   message CM_EXIT;
  protected
    procedure Loaded; override;
    procedure Change; override;
  //Propriété Champs
  private
    FChamps: TChamps;
    function GetChamps: TChamps;
    procedure SetChamps( Value: TChamps);
  public
    property Champs: TChamps read GetChamps write SetChamps;
  // Propriété Field
  private
    FField: String;
  published
    property Field: String read FField write FField;
  //Champ
  private
    Champ: TChamp;
    function Champ_OK: Boolean;
  //Gestion des mises à jours avec TChamps
  private
    Champs_Changing: Boolean;
    procedure _from_Champs;
    procedure _to_Champs;
  //accesseur à partir de l'interface
  private
    function GetComponent: TComponent;
  //Gestion des incréments
  protected
    procedure UpClick (Sender: TObject); virtual;
    procedure DownClick (Sender: TObject); virtual;
  //Valeur
  private
    function  FloatCheckValue( NewValue: double): double;
    function  GetFloatValue: double;
    procedure SetFloatValue(const NewValue: double);
  public
    property FloatValue: double read GetFloatValue write SetFloatValue;
  published
    property Value     : double read GetFloatValue write SetFloatValue;
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TChamp_Float_SpinEdit]);
end;

{ TChamp_Float_SpinEdit }

constructor TChamp_Float_SpinEdit.Create(AOwner: TComponent);
begin
     inherited;
     FButton := TSpinButton.Create(Self);
     FButton.Width := 15;
     FButton.Height := 17;
     FButton.Visible := True;
     FButton.Parent := Self;
     FButton.FocusControl := Self;
     FButton.OnUpClick := UpClick;
     FButton.OnDownClick := DownClick;
     Text := '0';
     ControlStyle := ControlStyle - [csSetCaption];
     FIncrement := 1;
     FEditorEnabled := True;
     ParentBackground := False;

     FChamps:= nil;
     Champs_Changing:= False;
end;

destructor TChamp_Float_SpinEdit.Destroy;
begin
     FButton := nil;
     inherited;
end;

//recopié de TSpinEdit

procedure TChamp_Float_SpinEdit.GetChildren(Proc: TGetChildProc; Root: TComponent);
begin
end;

procedure TChamp_Float_SpinEdit.KeyDown(var Key: Word; Shift: TShiftState);
begin
  if Key = VK_UP then UpClick (Self)
  else if Key = VK_DOWN then DownClick (Self);
  inherited KeyDown(Key, Shift);
end;

procedure TChamp_Float_SpinEdit.KeyPress(var Key: Char);
begin
  if not IsValidChar(Key) then
  begin
    Key := #0;
    MessageBeep(0)
  end;
  if Key <> #0 then inherited KeyPress(Key);
end;

function TChamp_Float_SpinEdit.IsValidChar(Key: Char): Boolean;
begin
  Result := (Key in [DecimalSeparator, '+', '-', '0'..'9']) or
    ((Key < #32) and (Key <> Chr(VK_RETURN)));
  if not FEditorEnabled and Result and ((Key >= #32) or
      (Key = Char(VK_BACK)) or (Key = Char(VK_DELETE))) then
    Result := False;
end;

procedure TChamp_Float_SpinEdit.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
{  Params.Style := Params.Style and not WS_BORDER;  }
  Params.Style := Params.Style or ES_MULTILINE or WS_CLIPCHILDREN;
end;

procedure TChamp_Float_SpinEdit.CreateWnd;
begin
  inherited CreateWnd;
  SetEditRect;
end;

procedure TChamp_Float_SpinEdit.SetEditRect;
var
  Loc: TRect;
begin
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));
  Loc.Bottom := ClientHeight + 1;  {+1 is workaround for windows paint bug}
  Loc.Right := ClientWidth - FButton.Width - 2;
  Loc.Top := 0;  
  Loc.Left := 0;  
  SendMessage(Handle, EM_SETRECTNP, 0, LongInt(@Loc));
  SendMessage(Handle, EM_GETRECT, 0, LongInt(@Loc));  {debug}
end;

procedure TChamp_Float_SpinEdit.WMSize(var Message: TWMSize);
var
  MinHeight: Integer;
begin
  inherited;
  MinHeight := GetMinHeight;
    { text edit bug: if size to less than minheight, then edit ctrl does
      not display the text }
  if Height < MinHeight then   
    Height := MinHeight
  else if FButton <> nil then
  begin
    if NewStyleControls and Ctl3D then
      FButton.SetBounds(Width - FButton.Width - 5, 0, FButton.Width, Height - 5)
    else FButton.SetBounds (Width - FButton.Width, 1, FButton.Width, Height - 3);
    SetEditRect;
  end;
end;

function TChamp_Float_SpinEdit.GetMinHeight: Integer;
var
  DC: HDC;
  SaveFont: HFont;
  I: Integer;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  GetTextMetrics(DC, SysMetrics);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  I := SysMetrics.tmHeight;
  if I > Metrics.tmHeight then I := Metrics.tmHeight;
  Result := Metrics.tmHeight + I div 4 + GetSystemMetrics(SM_CYBORDER) * 4 + 2;
end;

procedure TChamp_Float_SpinEdit.WMPaste(var Message: TWMPaste);
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TChamp_Float_SpinEdit.WMCut(var Message: TWMPaste);   
begin
  if not FEditorEnabled or ReadOnly then Exit;
  inherited;
end;

procedure TChamp_Float_SpinEdit.CMEnter(var Message: TCMGotFocus);
begin
  if AutoSelect and not (csLButtonDown in ControlState) then
    SelectAll;
  inherited;
end;

//fin recopié de TSpinEdit

procedure TChamp_Float_SpinEdit.Loaded;
begin
     inherited;
end;

function TChamp_Float_SpinEdit.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_Float_SpinEdit.SetChamps(Value: TChamps);
begin
     if Assigned( Champ)
     then
         Champ.OnChange.Desabonne( Self, _from_Champs);

     FChamps:= Value;
     if not Champ_OK then exit;

     Champ.OnChange.Abonne( Self, _from_Champs);
     _from_Champs;
end;

procedure TChamp_Float_SpinEdit.Change;
var
   Valeur: double;
begin
     inherited;
     if not Champ_OK then exit;
     if not TryStrToFloat( Text, Valeur) then exit;

     _to_Champs;
end;

procedure TChamp_Float_SpinEdit._from_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        Text:= Champ.Chaine;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_Float_SpinEdit._to_Champs;
var
   Champ_asDouble: double;
begin
     if Champ.asDouble = FloatValue then exit;

     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        Champ.asDouble:= FloatValue;

        Champ_asDouble:= Champ.asDouble;
        if Champ_asDouble <> FloatValue
        then
            FloatValue:= Champ_asDouble;
     finally
            Champs_Changing:= False;
            end;
     if Champ.Bounce then _from_Champs;
end;

function TChamp_Float_SpinEdit.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_Float_SpinEdit.GetComponent: TComponent;
begin
     Result:= Self;
end;

procedure TChamp_Float_SpinEdit.UpClick(Sender: TObject);
begin
     if ReadOnly
     then
         MessageBeep(0)
     else
         FloatValue:= FloatValue + Increment;
end;

procedure TChamp_Float_SpinEdit.DownClick(Sender: TObject);
begin
     if ReadOnly
     then
         MessageBeep(0)
     else
         FloatValue:= FloatValue - Increment;
end;

function TChamp_Float_SpinEdit.GetFloatValue: double;
begin
     if not TryStrToFloat( Text, Result)
     then
         Result:= MinValue;
end;

procedure TChamp_Float_SpinEdit.SetFloatValue(const NewValue: double);
begin
     Text := FloatToStr( FloatCheckValue( NewValue));
end;

function TChamp_Float_SpinEdit.FloatCheckValue( NewValue: double): double;
begin
     Result := NewValue;
     if (MaxValue <> MinValue)
     then
         begin
              if NewValue < MinValue then Result := MinValue
         else if NewValue > MaxValue then Result := MaxValue;
         end;
end;

procedure TChamp_Float_SpinEdit.CMExit(var Message: TCMExit);
begin
     inherited;

     if Self = nil then exit;//ajouté au cas où

     if FloatCheckValue( FloatValue) <> FloatValue
     then
         SetFloatValue( FloatValue);
end;

end.
