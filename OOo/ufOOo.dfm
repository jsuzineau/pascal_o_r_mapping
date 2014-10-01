inherited fOOo: TfOOo
  Left = 429
  Top = 134
  Width = 732
  Height = 656
  Caption = 'fOOo'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 526
    Width = 724
    Height = 5
  end
  inherited pSociete: TPanel
    Width = 724
    inherited lSociete: TLabel
      Width = 652
    end
    inherited lHeure: TLabel
      Left = 668
    end
    inherited animation: TAnimate
      Left = 652
    end
  end
  inherited pBas: TPanel
    Top = 471
    Width = 724
    Height = 55
    inherited pFermer: TPanel
      Left = 1
      Width = 722
      Height = 53
      Align = alClient
      DesignSize = (
        722
        53)
      inherited bAbandon: TBitBtn
        Left = 417
        Height = 37
        Anchors = [akTop, akRight]
      end
      inherited bValidation: TBitBtn
        Height = 41
        Caption = 'Visualisation (F7)'
      end
      object bVers_GED: TButton
        Left = 288
        Top = 8
        Width = 113
        Height = 39
        Caption = 'Envoyer vers la GED'
        ModalResult = 1
        TabOrder = 2
        OnClick = bVers_GEDClick
      end
      object gbImprimer: TGroupBox
        Left = 127
        Top = 3
        Width = 153
        Height = 47
        Caption = 'Imprimer'
        TabOrder = 3
        object lExemplaires: TLabel
          Left = 81
          Top = 18
          Width = 61
          Height = 13
          Caption = 'exemplaire(s)'
        end
        object bImprimer: TBitBtn
          Left = 7
          Top = 16
          Width = 32
          Height = 25
          Hint = 'Imprimer'
          ModalResult = 1
          TabOrder = 0
          OnClick = bImprimerClick
          Glyph.Data = {
            76010000424D7601000000000000760000002800000020000000100000000100
            04000000000000010000130B0000130B00001000000000000000000000000000
            800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
            FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00300000000000
            00033FFFFFFFFFFFFFFF0888888888888880777777777777777F088888888888
            8880777777777777777F0000000000000000FFFFFFFFFFFFFFFF0F8F8F8F8F8F
            8F80777777777777777F08F8F8F8F8F8F9F0777777777777777F0F8F8F8F8F8F
            8F807777777777777F7F0000000000000000777777777777777F3330FFFFFFFF
            03333337F3FFFF3F7F333330F0000F0F03333337F77773737F333330FFFFFFFF
            03333337F3FF3FFF7F333330F00F000003333337F773777773333330FFFF0FF0
            33333337F3FF7F3733333330F08F0F0333333337F7737F7333333330FFFF0033
            33333337FFFF7733333333300000033333333337777773333333}
          NumGlyphs = 2
        end
        object seNbExemplaires: TSpinEdit
          Left = 41
          Top = 15
          Width = 38
          Height = 26
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Arial'
          Font.Style = []
          MaxValue = 0
          MinValue = 0
          ParentFont = False
          TabOrder = 1
          Value = 1
        end
      end
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 603
    Width = 724
  end
  inherited pLog: TPanel
    Top = 531
    Width = 724
    inherited lLog: TLabel
      Width = 722
    end
    inherited mLog: TMemo
      Width = 722
    end
  end
  object pModeles: TPanel [5]
    Left = 0
    Top = 18
    Width = 724
    Height = 95
    Align = alTop
    ParentBackground = False
    TabOrder = 4
    object lModele: TLabel
      Left = 1
      Top = 1
      Width = 722
      Height = 16
      Align = alTop
      Caption = 'lModele'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object pListesModeles: TPanel
      Left = 1
      Top = 17
      Width = 722
      Height = 77
      Align = alClient
      Caption = 'pListesModeles'
      TabOrder = 0
      object Splitter: TSplitter
        Left = 186
        Top = 1
        Height = 75
        Color = clLime
        ParentColor = False
      end
      object gbModeles_np: TGroupBox
        Left = 1
        Top = 1
        Width = 185
        Height = 75
        Align = alLeft
        Caption = 'Standard'
        TabOrder = 0
        object flbModeles_np: TFileListBox
          Left = 2
          Top = 15
          Width = 181
          Height = 58
          Align = alClient
          ItemHeight = 13
          Mask = '*.ott;*.ots'
          TabOrder = 0
          OnClick = flbModeles_npClick
        end
      end
      object gbModeles: TGroupBox
        Left = 189
        Top = 1
        Width = 532
        Height = 75
        Align = alClient
        Caption = 'Personnalis'#233's'
        TabOrder = 1
        object flbModeles: TFileListBox
          Left = 2
          Top = 15
          Width = 528
          Height = 58
          Align = alClient
          ItemHeight = 13
          Mask = '*.ott;*.ots'
          TabOrder = 0
          OnClick = flbModelesClick
        end
      end
    end
  end
  inherited al: TActionList
    Left = 536
    inherited aValidation: TAction
      Caption = 'Visualisation (F7)'
    end
  end
  inherited pmValidation: TPopupMenu
    inherited miModele: TMenuItem
      Visible = True
    end
    object miOD: TMenuItem
      Caption = 'OpenDocument'
      Visible = False
      OnClick = miODClick
    end
  end
end
