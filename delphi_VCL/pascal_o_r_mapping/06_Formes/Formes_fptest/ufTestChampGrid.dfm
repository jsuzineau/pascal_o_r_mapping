inherited fTestChampGrid: TfTestChampGrid
  Left = 298
  Top = 110
  Width = 870
  Height = 640
  Caption = 'fTestChampGrid'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 509
    Width = 862
  end
  inherited pSociete: TPanel
    Width = 862
    inherited lSociete: TLabel
      Width = 790
    end
    inherited lHeure: TLabel
      Left = 806
    end
    inherited animation: TAnimate
      Left = 790
    end
  end
  inherited pBas: TPanel
    Top = 468
    Width = 862
    inherited pFermer: TPanel
      Left = 629
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 587
    Width = 862
  end
  inherited pLog: TPanel
    Top = 515
    Width = 862
    inherited lLog: TLabel
      Width = 860
    end
    inherited mLog: TMemo
      Width = 860
    end
  end
  object cg: TChampsGrid [5]
    Left = 0
    Top = 18
    Width = 862
    Height = 450
    Align = alClient
    ColCount = 1
    FixedCols = 0
    RowCount = 1
    FixedRows = 0
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSizing, goColSizing, goRowMoving, goColMoving, goEditing, goAlwaysShowEditor]
    TabOrder = 4
    Persistance = False
  end
end
