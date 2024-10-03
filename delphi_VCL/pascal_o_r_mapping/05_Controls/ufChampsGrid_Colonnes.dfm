object fChampsGrid_Colonnes: TfChampsGrid_Colonnes
  Left = 208
  Top = 119
  Caption = 'fChampsGrid_Colonnes'
  ClientHeight = 364
  ClientWidth = 432
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 323
    Width = 432
    Height = 41
    Align = alBottom
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 328
    ExplicitWidth = 440
    object bOK: TBitBtn
      Left = 280
      Top = 8
      Width = 75
      Height = 25
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
    end
    object bCancel: TBitBtn
      Left = 360
      Top = 8
      Width = 75
      Height = 25
      Kind = bkCancel
      NumGlyphs = 2
      TabOrder = 1
    end
  end
  object vle: TValueListEditor
    Left = 0
    Top = 0
    Width = 432
    Height = 323
    Align = alClient
    KeyOptions = [keyEdit, keyAdd, keyDelete, keyUnique]
    TabOrder = 1
    TitleCaptions.Strings = (
      'Nom du champ'
      'Libell'#233' de colonne')
    ExplicitWidth = 440
    ExplicitHeight = 328
    ColWidths = (
      150
      284)
  end
end
