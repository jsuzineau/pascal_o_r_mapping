object fBloqueur: TfBloqueur
  Left = 212
  Top = 114
  Cursor = crHourGlass
  AlphaBlend = True
  AlphaBlendValue = 160
  BorderStyle = bsNone
  Caption = 'fBloqueur'
  ClientHeight = 622
  ClientWidth = 1134
  Color = clWhite

  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object tShow: TTimer
    Interval = 100
    OnTimer = tShowTimer
    Left = 24
    Top = 24
  end
end
