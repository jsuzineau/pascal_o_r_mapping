inherited fSchemateur: TfSchemateur
  Left = 198
  Top = 114
  Width = 1142
  Height = 656
  Caption = 'fSchemateur'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 525
    Width = 1134
  end
  inherited pSociete: TPanel
    Width = 1134
    inherited lSociete: TLabel
      Width = 1062
    end
    inherited lHeure: TLabel
      Left = 1078
    end
    inherited animation: TAnimate
      Left = 1062
    end
  end
  inherited pBas: TPanel
    Top = 484
    Width = 1134
    inherited pFermer: TPanel
      Left = 901
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 603
    Width = 1134
  end
  inherited pLog: TPanel
    Top = 531
    Width = 1134
    inherited lLog: TLabel
      Width = 1132
    end
    inherited mLog: TMemo
      Width = 1132
    end
  end
end
