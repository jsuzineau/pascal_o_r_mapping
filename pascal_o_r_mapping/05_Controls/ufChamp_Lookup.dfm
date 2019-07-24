object fChamp_Lookup: TfChamp_Lookup
  Left = 423
  Top = 201
  BorderStyle = bsNone
  Caption = 'fChamp_Lookup'
  ClientHeight = 157
  ClientWidth = 194
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 194
    Height = 157
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 0
    object lb: TListBox
      Left = 0
      Top = 0
      Width = 192
      Height = 157
      ItemHeight = 13
      TabOrder = 0
      OnClick = lbClick
      OnKeyDown = lbKeyDown
    end
  end
end
