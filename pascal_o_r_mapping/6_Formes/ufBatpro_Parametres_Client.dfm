object fBatpro_Parametres_Client: TfBatpro_Parametres_Client
  Left = 254
  Height = 700
  Top = 114
  Width = 1024
  Caption = 'fBatpro_Parametres_Client'
  ClientHeight = 700
  ClientWidth = 1024
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '1.0.1.3'
  object m: TMemo
    Left = 0
    Height = 659
    Top = 41
    Width = 1024
    Align = alClient
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier'
    Lines.Strings = (
      'm'
    )
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Height = 41
    Top = 0
    Width = 1024
    Align = alTop
    ClientHeight = 41
    ClientWidth = 1024
    TabOrder = 1
    object bSaveAs: TButton
      Left = 40
      Height = 25
      Top = 8
      Width = 105
      Caption = 'Enregistrer sous'
      OnClick = bSaveAsClick
      TabOrder = 0
    end
  end
  object sd: TSaveDialog
    left = 152
    top = 8
  end
end