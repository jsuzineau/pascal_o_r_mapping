inherited fPool: TfPool
  Left = 198
  Top = 114
  Width = 463
  Height = 498
  Caption = 'fPool'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 367
    Width = 455
  end
  inherited pSociete: TPanel
    Width = 455
    inherited lSociete: TLabel
      Width = 383
    end
    inherited lHeure: TLabel
      Left = 383
    end
    inherited animation: TAnimate
      Left = 439
    end
  end
  inherited pBas: TPanel
    Top = 326
    Width = 455
    inherited pFermer: TPanel
      Left = 323
      Width = 131
      inherited bAbandon: TBitBtn
        Left = 16
        Visible = False
      end
    end
    object bRecharger: TButton
      Left = 8
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Recharger'
      TabOrder = 1
      OnClick = bRechargerClick
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 445
    Width = 455
  end
  inherited pLog: TPanel
    Top = 373
    Width = 455
    inherited lLog: TLabel
      Width = 453
    end
    inherited mLog: TMemo
      Width = 453
    end
  end
  object clb: TCheckListBox [5]
    Left = 0
    Top = 18
    Width = 455
    Height = 308
    Align = alClient

    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ItemHeight = 14
    ParentFont = False
    TabOrder = 4
  end
  inherited al: TActionList
    Left = 8
    Top = 368
  end
end
