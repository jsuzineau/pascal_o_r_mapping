object fProgression: TfProgression
  Left = 631
  Top = 275
  BorderStyle = bsNone
  Caption = 'fProgression'
  ClientHeight = 214
  ClientWidth = 422
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object dsb: TDockScrollbox
    Left = 0
    Top = 0
    Width = 422
    Height = 214
    Align = alClient
    BevelInner = bvNone
    BevelOuter = bvNone
    BorderStyle = bsNone
    TabOrder = 0
    HauteurLigne = 51
    Zebrage = False
    Zebrage1 = clBlack
    Zebrage2 = clBlack
  end
  object tAutoHide: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = tAutoHideTimer
    Left = 13
    Top = 13
  end
end
