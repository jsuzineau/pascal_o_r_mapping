unit ucChamp_DateTimePicker;
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
    SysUtils, Classes, Controls, ComCtrls, DB, Windows, Messages, Graphics,
    CommCtrl, RTLConsts, ComStrs;

type
  TChamp_CommonCalendar = class;
  TChamp_MonthCalColors = class(TPersistent)
  private
    Owner: TChamp_CommonCalendar;
    FBackColor: TColor;
    FTextColor: TColor;
    FTitleBackColor: TColor;
    FTitleTextColor: TColor;
    FMonthBackColor: TColor;
    FTrailingTextColor: TColor;
    procedure SetColor(Index: Integer; Value: TColor);
    procedure SetAllColors;
  public
    constructor Create(AOwner: TChamp_CommonCalendar);
    procedure Assign(Source: TPersistent); override;
  published
    property BackColor: TColor index 0 read FBackColor write SetColor default clWindow;
    property TextColor: TColor index 1 read FTextColor write SetColor default clWindowText;
    property TitleBackColor: TColor index 2 read FTitleBackColor write SetColor default clActiveCaption;
    property TitleTextColor: TColor index 3 read FTitleTextColor write SetColor default clWhite;
    property MonthBackColor: TColor index 4 read FMonthBackColor write SetColor default clWhite;
    property TrailingTextColor: TColor index 5 read FTrailingTextColor
      write SetColor default clInactiveCaptionText;
  end;

  TChamp_CommonCalendar = class(TWinControl)
  private
    FCalColors: TChamp_MonthCalColors;
    FCalExceptionClass: ExceptClass;
    FDateTime: TDateTime;
    FEndDate: TDate;
    FFirstDayOfWeek: TCalDayOfWeek;
    FMaxDate: TDate;
    FMaxSelectRange: Integer;
    FMinDate: TDate;
    FMonthDelta: Integer;
    FMultiSelect: Boolean;
    FShowToday: Boolean;
    FShowTodayCircle: Boolean;
    FWeekNumbers: Boolean;
    FOnGetMonthInfo: TOnGetMonthInfoEvent;
    function DoStoreEndDate: Boolean;
    function DoStoreMaxDate: Boolean;
    function DoStoreMinDate: Boolean;
    function GetDate: TDate;
    procedure SetCalColors(Value: TChamp_MonthCalColors);
    procedure SetDate(Value: TDate);
    procedure SetDateTime(Value: TDateTime);
    procedure SetEndDate(Value: TDate);
    procedure SetFirstDayOfWeek(Value: TCalDayOfWeek);
    procedure SetMaxDate(Value: TDate);
    procedure SetMaxSelectRange(Value: Integer);
    procedure SetMinDate(Value: TDate);
    procedure SetMonthDelta(Value: Integer);
    procedure SetMultiSelect(Value: Boolean);
    procedure SetRange(MinVal, MaxVal: TDate);
    procedure SetSelectedRange(Date, EndDate: TDate);
    procedure SetShowToday(Value: Boolean);
    procedure SetShowTodayCircle(Value: Boolean);
    procedure SetWeekNumbers(Value: Boolean);
  protected
    procedure CheckEmptyDate; virtual;
    procedure CheckValidDate(Value: TDate); virtual;
    procedure CreateWnd; override;
    function GetCalendarHandle: HWND; virtual; abstract;
    function GetCalStyles: DWORD; virtual;
    function MsgSetCalColors(ColorIndex: Integer; ColorValue: TColor): Boolean; virtual; abstract;
    function MsgSetDateTime(Value: TSystemTime): Boolean; virtual; abstract;
    function MsgSetRange(Flags: Integer; SysTime: PSystemTime): Boolean; virtual; abstract;
    property CalColors: TChamp_MonthCalColors read FCalColors write SetCalColors;
    property CalendarHandle: HWND read GetCalendarHandle;
    property CalExceptionClass: ExceptClass read FCalExceptionClass write FCalExceptionClass;
    property Date: TDate read GetDate write SetDate;
    property DateTime: TDateTime read FDateTime write SetDateTime;
    property EndDate: TDate read FEndDate write SetEndDate stored DoStoreEndDate;
    property FirstDayOfWeek: TCalDayOfWeek read FFirstDayOfWeek write SetFirstDayOfWeek
      default dowLocaleDefault;
    property MaxDate: TDate read FMaxDate write SetMaxDate stored DoStoreMaxDate;
    property MaxSelectRange: Integer read FMaxSelectRange write SetMaxSelectRange default 31;
    property MinDate: TDate read FMinDate write SetMinDate stored DoStoreMinDate;
    property MonthDelta: Integer read FMonthDelta write SetMonthDelta default 1;
    property MultiSelect: Boolean read FMultiSelect write SetMultiSelect default False;
    property ShowToday: Boolean read FShowToday write SetShowToday default True;
    property ShowTodayCircle: Boolean read FShowTodayCircle write
      SetShowTodayCircle default True;
    property WeekNumbers: Boolean read FWeekNumbers write SetWeekNumbers default False;
    property OnGetMonthInfo: TOnGetMonthInfoEvent read FOnGetMonthInfo write FOnGetMonthInfo;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure BoldDays(Days: array of LongWord; var MonthBoldInfo: LongWord);
  end;

 TChamp_DateTimePicker
 =
  class(TChamp_CommonCalendar, IChampsComponent)
  private
    FCalAlignment: TDTCalAlignment;
    FChanging: Boolean;
    FChecked: Boolean;
    FDateFormat: TDTDateFormat;
    FDateMode: TDTDateMode;
    FDroppedDown: Boolean;
    FKind: TDateTimeKind;
    FLastChange: TSystemTime;
    FParseInput: Boolean;
    FShowCheckbox: Boolean;
    FOnUserInput: TDTParseInputEvent;
    FOnCloseUp: TNotifyEvent;
    FOnChange: TNotifyEvent;
    FOnDropDown: TNotifyEvent;
    FFormat: String;
    procedure AdjustHeight;
    function GetTime: TTime;
    procedure SetCalAlignment(Value: TDTCalAlignment);
    procedure SetChecked(Value: Boolean);
    procedure SetDateMode(Value: TDTDateMode);
    procedure SetDateFormat(Value: TDTDateFormat);
    procedure SetKind(Value: TDateTimeKind);
    procedure SetParseInput(Value: Boolean);
    procedure SetShowCheckbox(Value: Boolean);
    procedure SetTime(Value: TTime);
    procedure CMColorChanged(var Message: TMessage); message CM_COLORCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNNotify(var Message: TWMNotify); message CN_NOTIFY;
    procedure SetFormat(const Value: String);
  protected
    procedure CheckEmptyDate; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Change; dynamic;
    function GetCalendarHandle: HWND; override;
    function MsgSetCalColors(ColorIndex: Integer; ColorValue: TColor): Boolean; override;
    function MsgSetDateTime(Value: TSystemTime): Boolean; override;
    function MsgSetRange(Flags: Integer; SysTime: PSystemTime): Boolean; override;
  public
    constructor Create(AOwner: TComponent); override;
    property DateTime;
    property DroppedDown: Boolean read FDroppedDown;
  published
    property Anchors;
    property BevelEdges;
    property BevelInner;
    property BevelOuter;
    property BevelKind default bkNone;
    property BevelWidth;
    property BiDiMode;
    property CalAlignment: TDTCalAlignment read FCalAlignment write SetCalAlignment default dtaLeft;
    property CalColors;
    property Constraints;
    // The Date, Time, ShowCheckbox, and Checked properties must be in this order:
    property Date;
    property Format: String read FFormat write SetFormat;
    property Time: TTime read GetTime write SetTime;
    property ShowCheckbox: Boolean read FShowCheckbox write SetShowCheckbox default False;
    property Checked: Boolean read FChecked write SetChecked default True;
    property Color stored True default clWindow;
    property DateFormat: TDTDateFormat read FDateFormat write SetDateFormat default dfShort;
    property DateMode: TDTDateMode read FDateMode write SetDateMode default dmComboBox;
    property DragCursor;
    property DragKind;
    property DragMode;
    property Enabled;
    property Font;
    property ImeMode;
    property ImeName;
    property Kind: TDateTimeKind read FKind write SetKind default dtkDate;
    property MaxDate;
    property MinDate;
    property ParseInput: Boolean read FParseInput write SetParseInput default False;
    property ParentBiDiMode;
    property ParentColor default False;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop default True;
    property Visible;
    property OnClick;
    property OnCloseUp: TNotifyEvent read FOnCloseUp write FOnCloseUp;
    property OnChange: TNotifyEvent read FOnChange write FOnChange;
    property OnContextPopup;
    property OnDropDown: TNotifyEvent read FOnDropDown write FOnDropDown;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDock;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnStartDock;
    property OnStartDrag;
    property OnUserInput: TDTParseInputEvent read FOnUserInput write FOnUserInput;
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
  end;

procedure Register;

implementation

procedure Register;
begin
     RegisterComponents('Batpro', [TChamp_DateTimePicker]);
end;

{ TChamp_MonthCalColors }

const
  ColorIndex: array[0..5] of Integer = (MCSC_BACKGROUND, MCSC_TEXT,
    MCSC_TITLEBK, MCSC_TITLETEXT, MCSC_MONTHBK, MCSC_TRAILINGTEXT);

constructor TChamp_MonthCalColors.Create(AOwner: TChamp_CommonCalendar);
begin
  Owner := AOwner;
  FBackColor := clWindow;
  FTextColor := clWindowText;
  FTitleBackColor := clActiveCaption;
  FTitleTextColor := clWhite;
  FMonthBackColor := clWhite;
  FTrailingTextColor := clInactiveCaptionText;
end;

procedure TChamp_MonthCalColors.Assign(Source: TPersistent);
var
  SourceName: string;
begin
  if Source = nil then SourceName := 'nil'
  else SourceName := Source.ClassName;
  if (Source = nil) or not (Source is TChamp_MonthCalColors) then
    raise EConvertError.CreateResFmt(@SAssignError, [SourceName, ClassName]);
  FBackColor := TChamp_MonthCalColors(Source).BackColor;
  FTextColor := TChamp_MonthCalColors(Source).TextColor;
  FTitleBackColor := TChamp_MonthCalColors(Source).TitleBackColor;
  FTitleTextColor := TChamp_MonthCalColors(Source).TitleTextColor;
  FMonthBackColor := TChamp_MonthCalColors(Source).MonthBackColor;
  FTrailingTextColor := TChamp_MonthCalColors(Source).TrailingTextColor;
end;

procedure TChamp_MonthCalColors.SetColor(Index: Integer; Value: TColor);
begin
  case Index of
    0: FBackColor := Value;
    1: FTextColor := Value;
    2: FTitleBackColor := Value;
    3: FTitleTextColor := Value;
    4: FMonthBackColor := Value;
    5: FTrailingTextColor := Value;
  end;
  if Owner.HandleAllocated then
    Owner.MsgSetCalColors(ColorIndex[Index], ColorToRGB(Value));
end;

procedure TChamp_MonthCalColors.SetAllColors;
begin
  SetColor(0, FBackColor);
  SetColor(1, FTextColor);
  SetColor(2, FTitleBackColor);
  SetColor(3, FTitleTextColor);
  SetColor(4, FMonthBackColor);
  SetColor(5, FTrailingTextColor);
end;

{ TChamp_CommonCalendar }

constructor TChamp_CommonCalendar.Create(AOwner: TComponent);
begin
  CheckCommonControl(ICC_DATE_CLASSES);
  inherited Create(AOwner);
  FShowToday := True;
  FShowTodayCircle := True;
  ControlStyle := [csOpaque, csClickEvents, csDoubleClicks, csReflector];
  FCalColors := TChamp_MonthCalColors.Create(Self);
  FDateTime := Now;
  FFirstDayOfWeek := dowLocaleDefault;
  FMaxSelectRange := 31;
  FMonthDelta := 1;
end;

destructor TChamp_CommonCalendar.Destroy;
begin
  inherited Destroy;
  FCalColors.Free;
end;

procedure TChamp_CommonCalendar.BoldDays(Days: array of LongWord; var MonthBoldInfo: LongWord);
var
  I: LongWord;
begin
  MonthBoldInfo := 0;
  for I := Low(Days) to High(Days) do
    if (Days[I] > 0) and (Days[I] < 32) then
      MonthBoldInfo := MonthBoldInfo or ($00000001 shl (Days[I] - 1));
end;

procedure TChamp_CommonCalendar.CheckEmptyDate;
begin
  // do nothing
end;

procedure TChamp_CommonCalendar.CheckValidDate(Value: TDate);
begin
  if (FMaxDate <> 0.0) and (Value > FMaxDate) then
    raise CalExceptionClass.CreateFmt(SDateTimeMax, [DateToStr(FMaxDate)]);
  if (FMinDate <> 0.0) and (Value < FMinDate) then
    raise CalExceptionClass.CreateFmt(SDateTimeMin, [DateToStr(FMinDate)]);
end;

procedure TChamp_CommonCalendar.CreateWnd;
begin
  inherited CreateWnd;
  FCalColors.SetAllColors;
  SetRange(FMinDate, FMaxDate);
  SetMaxSelectRange(FMaxSelectRange);
  SetMonthDelta(FMonthDelta);
  SetFirstDayOfWeek(FFirstDayOfWeek);
  if FMultiSelect then
    SetSelectedRange(FDateTime, FEndDate)
  else
    SetDateTime(FDateTime);
end;

function TChamp_CommonCalendar.GetCalStyles: DWORD;
const
  ShowTodayFlags: array[Boolean] of DWORD = (MCS_NOTODAY, 0);
  ShowTodayCircleFlags: array[Boolean] of DWORD = (MCS_NOTODAYCIRCLE, 0);
  WeekNumFlags: array[Boolean] of DWORD = (0, MCS_WEEKNUMBERS);
  MultiSelFlags: array[Boolean] of DWORD = (0, MCS_MULTISELECT);
begin
  Result := MCS_DAYSTATE or ShowTodayFlags[FShowToday] or
    ShowTodayCircleFlags[FShowTodayCircle] or WeekNumFlags[FWeekNumbers] or
    MultiSelFlags[FMultiSelect];
end;

function TChamp_CommonCalendar.DoStoreEndDate: Boolean;
begin
  Result := FMultiSelect;
end;

function TChamp_CommonCalendar.DoStoreMaxDate: Boolean;
begin
  Result := FMaxDate <> 0.0;
end;

function TChamp_CommonCalendar.DoStoreMinDate: Boolean;
begin
  Result := FMinDate <> 0.0;
end;

function TChamp_CommonCalendar.GetDate: TDate;
begin
  Result := TDate(FDateTime);
end;

procedure TChamp_CommonCalendar.SetCalColors(Value: TChamp_MonthCalColors);
begin
  if FCalColors <> Value then FCalColors.Assign(Value);
end;

procedure TChamp_CommonCalendar.SetDate(Value: TDate);
begin
  ReplaceTime(TDateTime(Value), FDateTime);
  if Value = 0.0 then CheckEmptyDate;
  try
    CheckValidDate(Trunc(Value));
    SetDateTime(Value);
  except
    SetDateTime(FDateTime);
    raise;
  end;
end;

procedure TChamp_CommonCalendar.SetDateTime(Value: TDateTime);
var
  ST: TSystemTime;
begin
  DateTimeToSystemTime(Value, ST);
  if FMultiSelect then
    SetSelectedRange(Value, FEndDate)
  else begin
    if HandleAllocated then
      if not MsgSetDateTime(ST) then
        raise ECommonCalendarError.CreateRes(@sFailSetCalDateTime);
    FDateTime := Value;
  end;
end;

procedure TChamp_CommonCalendar.SetEndDate(Value: TDate);
var
  TruncValue: TDate;
begin
  TruncValue := Trunc(Value);
  if Trunc(FEndDate) <> TruncValue then
  begin
    Value := TruncValue + 0.0;
    if Value = 0.0 then CheckEmptyDate;
    SetSelectedRange(Date, TruncValue);
  end;
end;

procedure TChamp_CommonCalendar.SetFirstDayOfWeek(Value: TCalDayOfWeek);
var
  DOWFlag: Integer;
  A: array[0..1] of char;
begin
  if HandleAllocated then
  begin
    if Value = dowLocaleDefault then
    begin
      GetLocaleInfo(LOCALE_USER_DEFAULT, LOCALE_IFIRSTDAYOFWEEK, A, SizeOf(A));
      DOWFlag := Ord(A[0]) - Ord('0');
    end
    else
      DOWFlag := Ord(Value);
    if CalendarHandle <> 0 then
      MonthCal_SetFirstDayOfWeek(CalendarHandle, DOWFlag);
  end;
  FFirstDayOfWeek := Value;
end;

procedure TChamp_CommonCalendar.SetMaxDate(Value: TDate);
begin
  if (FMinDate <> 0.0) and (Value < FMinDate) then
    raise CalExceptionClass.CreateFmt(SDateTimeMin, [DateToStr(FMinDate)]);
  if FMaxDate <> Value then
  begin
    SetRange(FMinDate, Value);
    FMaxDate := Value;
  end;
end;

procedure TChamp_CommonCalendar.SetMaxSelectRange(Value: Integer);
begin
  if FMultiSelect and HandleAllocated then
    if not MonthCal_SetMaxSelCount(CalendarHandle, Value) then
      raise ECommonCalendarError.CreateRes(@sFailSetCalMaxSelRange);
  FMaxSelectRange := Value;
end;

procedure TChamp_CommonCalendar.SetMinDate(Value: TDate);
begin
  if (FMaxDate <> 0.0) and (Value > FMaxDate) then
    raise CalExceptionClass.CreateFmt(SDateTimeMax, [DateToStr(FMaxDate)]);
  if FMinDate <> Value then
  begin
    SetRange(Value, FMaxDate);
    FMinDate := Value;
  end;
end;

procedure TChamp_CommonCalendar.SetMonthDelta(Value: Integer);
begin
  if HandleAllocated and (CalendarHandle <> 0) then
    MonthCal_SetMonthDelta(CalendarHandle, Value);
  FMonthDelta := Value;
end;

procedure TChamp_CommonCalendar.SetMultiSelect(Value: Boolean);
begin
  if FMultiSelect <> Value then
  begin
    FMultiSelect := Value;
    if Value then FEndDate := FDateTime
    else FEndDate := 0.0;
    RecreateWnd;
  end;
end;

procedure TChamp_CommonCalendar.SetRange(MinVal, MaxVal: TDate);
var
  STA: packed array[1..2] of TSystemTime;
  Flags: DWORD;
  TruncDate, TruncEnd, TruncMin, TruncMax: Int64;
begin
  Flags := 0;
  TruncMin := Trunc(MinVal);
  TruncMax := Trunc(MaxVal);
  TruncDate := Trunc(FDateTime);
  TruncEnd := Trunc(FEndDate);
  if TruncMin <> 0 then
  begin
    if TruncDate < TruncMin then SetDate(MinVal);
    if TruncEnd < TruncMin then SetEndDate(MinVal);
    Flags := Flags or GDTR_MIN;
    DateTimeToSystemTime(TruncMin, STA[1]);
  end;
  if TruncMax <> 0 then
  begin
    if TruncDate > TruncMax then SetDate(MaxVal);
    if TruncEnd > TruncMax then SetEndDate(MaxVal);
    Flags := Flags or GDTR_MAX;
    DateTimeToSystemTime(TruncMax, STA[2]);
  end;
  if HandleAllocated then
    if not MsgSetRange(Flags, @STA[1]) then
      raise ECommonCalendarError.CreateRes(@sFailSetCalMinMaxRange);
end;

procedure TChamp_CommonCalendar.SetSelectedRange(Date, EndDate: TDate);
var
  DateArray: array[1..2] of TSystemTime;
begin
  if not FMultiSelect then
    SetDateTime(Date)
  else begin
    DateTimeToSystemTime(Date, DateArray[1]);
    DateTimeToSystemTime(EndDate, DateArray[2]);
    if HandleAllocated then
      if not MonthCal_SetSelRange(Handle, @DateArray[1]) then
        raise ECommonCalendarError.CreateRes(@sFailsetCalSelRange);
    FDateTime := Date;
    FEndDate := EndDate;
  end;
end;

procedure SetComCtlStyle(Ctl: TWinControl; Value: Integer; UseStyle: Boolean);
var
  Style: Integer;
begin
  if Ctl.HandleAllocated then
  begin
    Style := GetWindowLong(Ctl.Handle, GWL_STYLE);
    if not UseStyle then Style := Style and not Value
    else Style := Style or Value;
    SetWindowLong(Ctl.Handle, GWL_STYLE, Style);
  end;
end;


procedure TChamp_CommonCalendar.SetShowToday(Value: Boolean);
begin
  if FShowToday <> Value then
  begin
    FShowToday := Value;
    SetComCtlStyle(Self, MCS_NOTODAY, not Value);
  end;
end;

procedure TChamp_CommonCalendar.SetShowTodayCircle(Value: Boolean);
begin
  if FShowTodayCircle <> Value then
  begin
    FShowTodayCircle := Value;
    SetComCtlStyle(Self, MCS_NOTODAYCIRCLE, not Value);
  end;
end;

procedure TChamp_CommonCalendar.SetWeekNumbers(Value: Boolean);
begin
  if FWeekNumbers <> Value then
  begin
    FWeekNumbers := Value;
    SetComCtlStyle(Self, MCS_WEEKNUMBERS, Value);
  end;
end;

{ TChamp_DateTimePicker }

constructor TChamp_DateTimePicker.Create(AOwner: TComponent);
begin
  FCalExceptionClass := EDateTimeError;
  FChanging := False;
  inherited Create(AOwner);
  DateTimeToSystemTime(FDateTime, FLastChange);
  FShowCheckbox := False;
  FChecked := True;
  ControlStyle := ControlStyle + [csFixedHeight, csReflector];
  Color := clWindow;
  ParentColor := False;
  TabStop := True;
  Width := 186;
  AdjustHeight;
  FCalAlignment := dtaLeft;
  FDateFormat := dfShort;
  FDateMode := dmComboBox;
  FKind := dtkDate;
  FParseInput := false;

     FChamps:= nil;
     Champs_Changing:= False;
end;

procedure TChamp_DateTimePicker.AdjustHeight;
var
  DC: HDC;
  SaveFont: HFont;
  SysMetrics, Metrics: TTextMetric;
begin
  DC := GetDC(0);
  try
    GetTextMetrics(DC, SysMetrics);
    SaveFont := SelectObject(DC, Font.Handle);
    GetTextMetrics(DC, Metrics);
    SelectObject(DC, SaveFont);
  finally
    ReleaseDC(0, DC);
  end;
  Height := Metrics.tmHeight + (GetSystemMetrics(SM_CYBORDER) * 8);
end;

procedure TChamp_DateTimePicker.CheckEmptyDate;
begin
  if not FShowCheckbox then raise EDateTimeError.CreateRes(@SNeedAllowNone);
  FChecked := False;
  Invalidate;
end;

procedure TChamp_DateTimePicker.CreateParams(var Params: TCreateParams);
const
  Formats: array[TDTDateFormat] of DWORD = (DTS_SHORTDATEFORMAT,
    DTS_LONGDATEFORMAT);
var
  ACalAlignment: TDTCalAlignment;
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, DATETIMEPICK_CLASS);
  with Params do
  begin
    if FDateMode = dmUpDown then Style := Style or DTS_UPDOWN;
    if FKind = dtkTime then
      Style := Style or DTS_TIMEFORMAT
    else
      Style := Style or Formats[FDateFormat];
    ACalAlignment := FCalAlignment;
    if UseRightToLeftAlignment then
      if ACalAlignment = dtaLeft then
        ACalAlignment := dtaRight
      else
        ACalAlignment := dtaLeft;
    if ACalAlignment = dtaRight then Style := Style or DTS_RIGHTALIGN;
    if FParseInput then Style := Style or DTS_APPCANPARSE;
    if FShowCheckbox then Style := Style or DTS_SHOWNONE;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TChamp_DateTimePicker.Change;
begin
  if Assigned(FOnChange) then FOnChange(Self);
end;

procedure TChamp_DateTimePicker.CreateWnd;
begin
  inherited CreateWnd;
  SetChecked(FChecked);
  if Length(FFormat) > 0 then
    SendMessage(Handle, DTM_SETFORMAT, 0 , Integer(PChar(FFormat)));
end;

procedure TChamp_DateTimePicker.CMColorChanged(var Message: TMessage);
begin
  inherited;
  InvalidateRect(Handle, nil, True);
end;

procedure TChamp_DateTimePicker.CMFontChanged(var Message: TMessage);
begin
  inherited;
  AdjustHeight;
  InvalidateRect(Handle, nil, True);
end;

function IsBlankSysTime(const ST: TSystemTime): Boolean;
type
  TFast = array [0..3] of DWORD;
begin
  Result := (TFast(ST)[0] or TFast(ST)[1] or TFast(ST)[2] or TFast(ST)[3]) = 0;
end;

procedure TChamp_DateTimePicker.CNNotify(var Message: TWMNotify);
var
   DT: TDateTime;
   AllowChange: Boolean;
begin
     with Message, NMHdr^
     do
       begin
       Result := 0;
       case code
       of
         DTN_CLOSEUP:
           begin
           FDroppedDown := False;
           SetDate(SystemTimeToDateTime(FLastChange));
           if Assigned(FOnCloseUp) then FOnCloseUp(Self);
           if Champ_OK then _to_Champs;
           end;
         DTN_DATETIMECHANGE:
           begin
           with PNMDateTimeChange(NMHdr)^
           do
             begin
             if FDroppedDown and (dwFlags = GDT_VALID)
             then
                 begin
                 FLastChange := st;
                 FDateTime := SystemTimeToDateTime(FLastChange);
                 end
             else
                 begin
                 if FShowCheckbox and IsBlankSysTime(st)
                 then
                     FChecked := False
                 else
                     if dwFlags = GDT_VALID
                     then
                         begin
                         FLastChange := st;
                         DT := SystemTimeToDateTime(st);
                         if Kind = dtkDate
                         then
                             SetDate(DT)
                         else
                             SetTime(DT);
                         if FShowCheckbox then FChecked := True;
                         end;
                 end;
             Change;
             end;
           end;
         DTN_DROPDOWN:
           begin
           DateTimeToSystemTime(Date, FLastChange);
           FDroppedDown := True;
           if Assigned(FOnDropDown) then FOnDropDown(Self);
           end;
         DTN_USERSTRING:
           begin
           with PNMDateTimeString(NMHdr)^
           do
             begin
             DT:= StrToDateTime(pszUserString);
             if Assigned(FOnUserInput)
             then
                 begin
                 AllowChange := True;
                 FOnUserInput(Self, pszUserString, DT, AllowChange);
                 dwFlags := Ord(not AllowChange);
                 end
             else
                 dwFlags := Ord(False);
             DateTimeToSystemTime(DT, st);
             end;
           if Champ_OK then _to_Champs;
           end;
       else
         inherited;
       end;
     end;
end;

function TChamp_DateTimePicker.GetCalendarHandle: HWND;
begin
  Result := DateTime_GetMonthCal(Handle);
end;

function TChamp_DateTimePicker.GetTime: TTime;
begin
  Result := TTime(FDateTime);
end;

function TChamp_DateTimePicker.MsgSetCalColors(ColorIndex: Integer; ColorValue: TColor): Boolean;
begin
  Result := True;
  if HandleAllocated then
    Result := DateTime_SetMonthCalColor(Handle, ColorIndex, ColorValue) <> DWORD($FFFFFFFF);
end;

function TChamp_DateTimePicker.MsgSetDateTime(Value: TSystemTime): Boolean;
begin
  Result := True;
  if HandleAllocated then
    if not FChanging then
    begin
      FChanging := True;
      try
        Result := DateTime_SetSystemTime(Handle, GDT_VALID, Value);
        if FShowCheckbox and not (csLoading in ComponentState)then
          FChecked := Result;
      finally
        FChanging := False;
      end;
    end;
end;

function TChamp_DateTimePicker.MsgSetRange(Flags: Integer; SysTime: PSystemTime): Boolean;
begin
  Result := True;
  if HandleAllocated then
    if Flags <> 0 then Result := DateTime_SetRange(Handle, Flags, SysTime);
end;

procedure TChamp_DateTimePicker.SetCalAlignment(Value: TDTCalAlignment);
begin
  if FCalAlignment <> Value then
  begin
    FCalAlignment := Value;
    if not (csDesigning in ComponentState) then
      SetComCtlStyle(Self, DTS_RIGHTALIGN, Value = dtaRight);
  end;
end;

procedure TChamp_DateTimePicker.SetChecked(Value: Boolean);
var
  ST: TSystemTime;
begin
  FChecked := Value;
  if FShowCheckbox then
  begin
    if Value then SetDateTime(FDateTime)
    else DateTime_SetSystemTime(Handle, GDT_NONE, ST);
    Invalidate;
  end;
end;

procedure TChamp_DateTimePicker.SetDateFormat(Value: TDTDateFormat);
begin
  if FDateFormat <> Value then
  begin
    FDateFormat := Value;
    RecreateWnd;
  end;
end;

procedure TChamp_DateTimePicker.SetDateMode(Value: TDTDateMode);
begin
  if FDateMode <> Value then
  begin
    FDateMode := Value;
    RecreateWnd;
  end;
end;

procedure TChamp_DateTimePicker.SetKind(Value: TDateTimeKind);
begin
  if FKind <> Value then
  begin
    FKind := Value;
    RecreateWnd;
  end;
end;

procedure TChamp_DateTimePicker.SetParseInput(Value: Boolean);
begin
  if FParseInput <> Value then
  begin
    FParseInput := Value;
    if not (csDesigning in ComponentState) then
      SetComCtlStyle(Self, DTS_APPCANPARSE, Value);
  end;
end;

procedure TChamp_DateTimePicker.SetShowCheckbox(Value: Boolean);
begin
  if FShowCheckbox <> Value then
  begin
    FShowCheckbox := Value;
    RecreateWnd;
  end;
end;

procedure TChamp_DateTimePicker.SetTime(Value: TTime);
begin
  if Abs(Frac(FDateTime)) <> Abs(Frac(Value)) then
  begin
    ReplaceDate(TDateTime(Value), FDateTime);
    if Value = 0.0 then
    begin
      if not FShowCheckbox then raise EDateTimeError.CreateRes(@SNeedAllowNone);
      FChecked := False;
      Invalidate;
    end
    else
      SetDateTime(Value);
  end;
end;

procedure TChamp_DateTimePicker.SetFormat(const Value: String);
begin
  if FFormat <> Value then
  begin
    FFormat := Value;
    SendMessage(Handle, DTM_SETFORMAT, 0 , Integer(PChar(FFormat)));
  end;
end;

function TChamp_DateTimePicker.Champ_OK: Boolean;
begin
     Champ:= nil;

     Result:= Assigned( FChamps);
     if not Result then exit;

     Champ:= Champs.Champ_from_Field( Field);
     Result:= Assigned( Champ);
end;

procedure TChamp_DateTimePicker.SetChamps(Value: TChamps);
begin
     if Assigned( Champ)
     then
         Champ.OnChange.Desabonne( Self, _from_Champs);

     FChamps:= Value;

     if not Champ_OK then exit;

     Champ.OnChange.Abonne( Self, _from_Champs);
     _from_Champs;
end;

procedure TChamp_DateTimePicker._from_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        case Champ.Definition.Typ
        of
          ftDate     : DateTime:= PDateTime( Champ.Valeur)^;
          ftDateTime : DateTime:= PDateTime( Champ.Valeur)^;
          ftTimeStamp: DateTime:= PDateTime( Champ.Valeur)^;
          end;
     finally
            Champs_Changing:= False;
            end;
end;

procedure TChamp_DateTimePicker._to_Champs;
begin
     if Champs_Changing then exit;
     try
        Champs_Changing:= True;

        case Champ.Definition.Typ
        of
          ftDate     : Champ.asDatetime:= DateTime;
          ftDateTime : Champ.asDatetime:= DateTime;
          ftTimeStamp: Champ.asDatetime:= DateTime;
          end;
        Champ.Publie_Modifications;
     finally
            Champs_Changing:= False;
            end;
     _from_Champs;
end;

function TChamp_DateTimePicker.GetChamps: TChamps;
begin
     Result:= FChamps;
end;

function TChamp_DateTimePicker.GetComponent: TComponent;
begin
     Result:= Self;
end;

end.
