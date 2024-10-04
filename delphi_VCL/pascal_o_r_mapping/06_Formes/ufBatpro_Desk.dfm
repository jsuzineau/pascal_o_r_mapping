object fBatpro_Desk: TfBatpro_Desk
  Left = 252
  Top = 114
  Caption = 'fBatpro_Desk'
  ClientHeight = 113
  ClientWidth = 247
  Color = clBtnFace
  DockSite = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnClose = FormClose
  OnCreate = FormCreate
  TextHeight = 13
  object tCreate: TTimer
    Enabled = False
    OnTimer = tCreateTimer
    Left = 24
    Top = 16
  end
  object al: TActionList
    Left = 64
    Top = 16
  end
end
