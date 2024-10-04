object ftcDockableScrollbox: TftcDockableScrollbox
  Left = 704
  Top = 420
  Caption = 'ftcDockableScrollbox'
  ClientHeight = 240
  ClientWidth = 320
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 174
    Width = 320
    Height = 66
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 0
    object m: TMemo
      Left = 1
      Top = 1
      Width = 318
      Height = 64
      Align = alClient
      Lines.Strings = (
        'm')
      TabOrder = 0
    end
    object Button1: TButton
      Left = 237
      Top = 22
      Width = 75
      Height = 25
      Caption = 'Button1'
      ModalResult = 1
      TabOrder = 1
    end
  end
  object dsb: TDockableScrollbox
    Left = 0
    Top = 0
    Width = 320
    Height = 174
    Align = alClient
    Caption = 'dsb'
    TabOrder = 1
    HauteurLigne = 24
    BordureLignes = True
    Zebrage = False
    Zebrage1 = 15138790
    Zebrage2 = 16777192
    _LectureSeule = False
  end
end
