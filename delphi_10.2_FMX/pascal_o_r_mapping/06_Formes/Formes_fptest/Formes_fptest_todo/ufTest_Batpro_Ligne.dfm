inherited fTest_Batpro_Ligne: TfTest_Batpro_Ligne
  Left = 311
  Top = 213
  Width = 503
  Height = 339
  Caption = 'fTest_Batpro_Ligne'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 215
    Width = 495
  end
  inherited pSociete: TPanel
    Width = 495
    inherited lSociete: TLabel
      Width = 439
    end
    inherited lHeure: TLabel
      Left = 439
    end
  end
  inherited pBas: TPanel
    Top = 174
    Width = 495
    inherited pFermer: TPanel
      Left = 262
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 293
    Width = 495
  end
  inherited pLog: TPanel
    Top = 221
    Width = 495
    inherited lLog: TLabel
      Width = 493
    end
    inherited mLog: TMemo
      Width = 493
    end
  end
  object clkcb: TChamp_Lookup_ComboBox [5]
    Left = 16
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object ce: TChamp_Edit [6]
    Left = 192
    Top = 24
    Width = 121
    Height = 21
    TabOrder = 5
    Text = 'ce'
    Field = 'test_string'
  end
  object cise: TChamp_Integer_SpinEdit [7]
    Left = 328
    Top = 24
    Width = 121
    Height = 22
    MaxValue = 0
    MinValue = 0
    TabOrder = 6
    Value = 0
    Field = 'test_integer'
  end
end
