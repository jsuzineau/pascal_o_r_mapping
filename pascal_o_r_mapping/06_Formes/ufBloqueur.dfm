object fBloqueur: TfBloqueur
  Cursor = crHourGlass
  Left = 424
  Height = 622
  Top = 114
  Width = 1134
  AlphaBlend = True
  AlphaBlendValue = 160
  BorderStyle = bsNone
  Caption = 'fBloqueur'
  Color = clWhite
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  LCLVersion = '1.0.1.3'
  object tShow: TTimer
    Interval = 100
    OnTimer = tShowTimer
    left = 24
    top = 24
  end
end