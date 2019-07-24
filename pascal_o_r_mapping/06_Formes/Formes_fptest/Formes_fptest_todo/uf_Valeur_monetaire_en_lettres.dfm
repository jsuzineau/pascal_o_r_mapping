inherited f_Valeur_monetaire_en_lettres: Tf_Valeur_monetaire_en_lettres
  Left = 296
  Top = 107
  Width = 870
  Height = 640
  Caption = 'f_Valeur_monetaire_en_lettres'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 516
    Width = 862
  end
  inherited pSociete: TPanel
    Width = 862
    TabOrder = 0
    inherited lSociete: TLabel
      Width = 806
    end
    inherited lHeure: TLabel
      Left = 806
    end
  end
  inherited pBas: TPanel
    Top = 475
    Width = 862
    TabOrder = 1
    inherited pFermer: TPanel
      Left = 629
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 594
    Width = 862
  end
  inherited pLog: TPanel
    Top = 522
    Width = 862
    TabOrder = 2
    inherited lLog: TLabel
      Width = 860
    end
    inherited mLog: TMemo
      Width = 860
    end
  end
  object Panel1: TPanel [5]
    Left = 0
    Top = 15
    Width = 862
    Height = 58
    Align = alTop
    Caption = 'Panel1'
    TabOrder = 4
    object l: TLabel
      Left = 136
      Top = 32
      Width = 2
      Height = 13
      Caption = 'l'
    end
    object Label1: TLabel
      Left = 8
      Top = 8
      Width = 125
      Height = 13
      Caption = 'Tapez la valeur en chiffres'
    end
    object Label2: TLabel
      Left = 48
      Top = 32
      Width = 76
      Height = 13
      Caption = 'Valeur en lettres'
    end
    object e: TEdit
      Left = 137
      Top = 5
      Width = 312
      Height = 21
      TabOrder = 0
      Text = 'e'
      OnChange = eChange
    end
  end
  object m: TMemo [6]
    Left = 0
    Top = 73
    Width = 862
    Height = 402
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -13
    Font.Name = 'Courier New'
    Font.Style = []
    Lines.Strings = (
      'm')
    ParentFont = False
    TabOrder = 5
  end
  object mSources: TMemo [7]
    Left = 448
    Top = 176
    Width = 185
    Height = 89
    Lines.Strings = (
      '10 EUR'
      '20 MAD'
      '1.5 FRF'
      '1'
      '2'
      '3'
      '4'
      '5'
      '6'
      '7'
      '8'
      '9'
      '-446577.06 MAD')
    TabOrder = 6
    Visible = False
  end
end
