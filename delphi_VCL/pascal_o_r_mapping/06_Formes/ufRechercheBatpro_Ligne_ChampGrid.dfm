inherited fRechercheBatpro_Ligne_ChampGrid: TfRechercheBatpro_Ligne_ChampGrid
  Left = 192
  Caption = 'fRechercheBatpro_Ligne_ChampGrid'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 427
  end
  inherited pBas: TPanel
    Top = 433
    Height = 55
    inherited pFermer: TPanel
      Height = 53
      inherited bValidation: TBitBtn
        Default = True
      end
    end
    object gbSaisie: TGroupBox
      Left = 8
      Top = 0
      Width = 178
      Height = 48
      Caption = 'Saisie'
      TabOrder = 1
      object bCreationModification: TButton
        Left = 8
        Top = 16
        Width = 121
        Height = 25
        Caption = 'Cr'#233'ation / Modification'
        TabOrder = 0
      end
    end
  end
  object pHaut: TPanel [3]
    Left = 0
    Top = 18
    Width = 813
    Height = 41
    Align = alTop
    ParentBackground = False
    TabOrder = 4
  end
  object pSG: TPanel [6]
    Left = 0
    Top = 59
    Width = 813
    Height = 368
    Align = alClient
    Caption = 'pSG'
    ParentBackground = False
    TabOrder = 5
    object lTri: TLabel
      Left = 1
      Top = 1
      Width = 811
      Height = 13
      Align = alTop
      Caption = 'lTri'
      Visible = False
    end
    object cg: TChampsGrid
      Left = 1
      Top = 14
      Width = 811
      Height = 353
      Align = alClient
      ColCount = 1
      FixedCols = 0
      RowCount = 1
      FixedRows = 0
      Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
      TabOrder = 0
      OnDblClick = cgDblClick
      Persistance = True
    end
  end
end