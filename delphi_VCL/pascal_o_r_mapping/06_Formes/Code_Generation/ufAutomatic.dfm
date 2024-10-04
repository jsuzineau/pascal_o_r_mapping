object fAutomatic: TfAutomatic
  Left = 290
  Top = 177
  Caption = 'fAutomatic'
  ClientHeight = 413
  ClientWidth = 596
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 596
    Height = 74
    Align = alTop
    TabOrder = 0
    DesignSize = (
      596
      74)
    object bExecute: TButton
      Left = 8
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Execute'
      Default = True
      TabOrder = 0
      OnClick = bExecuteClick
    end
    object e: TEdit
      Left = 88
      Top = 16
      Width = 496
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
      Text = 'select * from Work  limit 0,5'
    end
    object bGenere: TButton
      Left = 11
      Top = 48
      Width = 75
      Height = 25
      Caption = 'G'#195#169'n'#195#168're'
      TabOrder = 2
      OnClick = bGenereClick
    end
    object bGenere_Tout: TButton
      Left = 101
      Top = 48
      Width = 147
      Height = 25
      Caption = 'G'#195#169'n'#195#168're Tout'
      TabOrder = 3
      OnClick = bGenere_ToutClick
    end
  end
end
