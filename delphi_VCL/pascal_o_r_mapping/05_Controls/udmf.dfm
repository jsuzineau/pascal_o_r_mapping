object dmf: Tdmf
  Left = 193
  Top = 107
  Caption = 'dmf'
  ClientHeight = 197
  ClientWidth = 599
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object m: TMemo
    Left = 0
    Top = 0
    Width = 185
    Height = 89
    Lines.Strings = (
      '')
    TabOrder = 0
  end
  object cd: TClientDataSet
    Aggregates = <>
    Params = <>
    Left = 16
    Top = 104
  end
  object ds: TDataSource
    DataSet = cd
    Left = 16
    Top = 136
  end
end
