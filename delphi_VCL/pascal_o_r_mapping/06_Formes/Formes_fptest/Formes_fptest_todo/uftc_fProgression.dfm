object ftc_fProgression: Tftc_fProgression
  Left = 330
  Top = 199
  Width = 246
  Height = 150
  Caption = 'ftc_fProgression'
  Color = clBtnFace

  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object bDemarre: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 25
    Caption = 'bDemarre'
    TabOrder = 0
    OnClick = bDemarreClick
  end
  object bAjoute: TButton
    Left = 8
    Top = 40
    Width = 75
    Height = 25
    Caption = 'bAjoute'
    TabOrder = 1
    OnClick = bAjouteClick
  end
  object bTermine: TButton
    Left = 8
    Top = 72
    Width = 75
    Height = 25
    Caption = 'bTermine'
    TabOrder = 2
    OnClick = bTermineClick
  end
end
