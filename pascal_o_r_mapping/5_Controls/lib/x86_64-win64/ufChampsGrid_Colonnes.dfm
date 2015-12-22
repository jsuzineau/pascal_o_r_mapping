object fChampsGrid_Colonnes: TfChampsGrid_Colonnes
  Left = 208
  Top = 119
  Width = 448
  Height = 403
  Caption = 'fChampsGrid_Colonnes'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 328
    Width = 440
    Height = 41
    Align = alBottom
    ParentBackground = False
    TabOrder = 0
    object bOK: TBitBtn
      Left = 280
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 0
      Kind = bkOK
    end
    object bCancel: TBitBtn
      Left = 360
      Top = 8
      Width = 75
      Height = 25
      TabOrder = 1
      Kind = bkCancel
    end
  end
  object vle: TValueListEditor
    Left = 0
    Top = 0
    Width = 440
    Height = 328
    Align = alClient
    KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
    TabOrder = 1
    TitleCaptions.Strings = (
      'Nom du champ'
      'Libell'#233' de colonne')
    ColWidths = (
      150
      284)
  end
end
