inherited fAutomatic_Genere_tout_sl: TfAutomatic_Genere_tout_sl
  Left = 677
  Height = 238
  Top = 525
  Width = 563
  Caption = 'fAutomatic_Genere_tout_sl'
  ClientHeight = 238
  ClientWidth = 563
  OnCreate = FormCreate
  Position = poScreenCenter
  inherited pSociete: TPanel
    Width = 563
    ClientWidth = 563
    inherited lSociete: TLabel
      Width = 507
    end
    inherited lHeure: TLabel
      Left = 507
      Width = 56
    end
  end
  inherited sLog: TSplitter
    Top = 137
    Width = 563
  end
  inherited pBas: TPanel
    Top = 96
    Width = 563
    ClientWidth = 563
    TabOrder = 2
    inherited pFermer: TPanel
      Left = 330
    end
    object bFromINI: TButton[1]
      Left = 104
      Height = 25
      Top = 8
      Width = 75
      Caption = 'bFromINI'
      OnClick = bFromINIClick
      TabOrder = 1
    end
    object bToINI: TButton[2]
      Left = 184
      Height = 25
      Top = 8
      Width = 75
      Caption = 'bToINI'
      OnClick = bToINIClick
      TabOrder = 2
    end
    object bFromDatabase: TButton[3]
      Left = 8
      Height = 25
      Top = 8
      Width = 91
      Caption = 'bFromDatabase'
      OnClick = bFromDatabaseClick
      TabOrder = 3
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 215
    Width = 563
  end
  inherited pLog: TPanel
    Top = 143
    Width = 563
    ClientWidth = 563
    inherited lLog: TLabel
      Width = 561
    end
    inherited mLog: TMemo
      Width = 561
      Lines.Strings = (
        'mLog'
      )
    end
  end
  object m: TMemo[5]
    Left = 0
    Height = 78
    Top = 18
    Width = 563
    Align = alClient
    Lines.Strings = (
      'm'
    )
    TabOrder = 0
  end
  inherited al: TActionList[6]
  end
  inherited pmValidation: TPopupMenu[7]
  end
end
