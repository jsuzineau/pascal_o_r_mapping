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
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object tAutoHide: TTimer
    Enabled = False
    Interval = 2000
    OnTimer = tAutoHideTimer
    Left = 13
    Top = 13
  end
end
