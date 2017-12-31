inherited fBatproReport: TfBatproReport
  Left = 300
  Top = 107
  Width = 870
  Height = 640
  Caption = 'fBatproReport'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 499
    Width = 862
    Height = 3
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
    Top = 502
    Width = 862
    Height = 81
    object Label1: TLabel [0]
      Left = 176
      Top = 11
      Width = 76
      Height = 13
      Caption = 'Afficher page n'#176
    end
    object g: TGauge [1]
      Left = 1
      Top = 74
      Width = 860
      Height = 6
      Align = alBottom
      BackColor = clBlue
      ForeColor = clLime
      Progress = 50
      ShowText = False
    end
    inherited pFermer: TPanel
      Left = 629
      Height = 73
      object bDessinne: TButton
        Left = 8
        Top = 40
        Width = 57
        Height = 25
        Caption = 'Dessinne'
        TabOrder = 2
        OnClick = bDessinneClick
      end
      object bArretDessin: TButton
        Left = 72
        Top = 40
        Width = 97
        Height = 25
        Caption = 'Arr'#234'ter le dessin'
        TabOrder = 3
        Visible = False
        OnClick = bArretDessinClick
      end
      object speImpression_Font_Size_Multiplier: TSpinEdit
        Left = 176
        Top = 40
        Width = 43
        Height = 32
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Arial'
        Font.Style = []
        MaxValue = 0
        MinValue = 0
        ParentFont = False
        TabOrder = 4
        Value = 0
        OnChange = speImpression_Font_Size_MultiplierChange
      end
      object cbLargeur: TCheckBox
        Left = 72
        Top = 58
        Width = 97
        Height = 17
        Caption = 'Largeur'
        TabOrder = 5
      end
    end
    object bPrinterSetup: TButton
      Left = 8
      Top = 8
      Width = 155
      Height = 25
      Caption = 'R'#233'glage de l'#39'imprimante'
      TabOrder = 1
      OnClick = bPrinterSetupClick
    end
    object spe: TSpinEdit
      Left = 256
      Top = 9
      Width = 51
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 1
      OnChange = speChange
    end
    object cbPageAffichee: TCheckBox
      Left = 17
      Top = 32
      Width = 200
      Height = 17
      Caption = 'Imprimer seulement la page affich'#233'e'
      TabOrder = 3
    end
    object rgMultipages: TRadioGroup
      Left = 320
      Top = 0
      Width = 297
      Height = 71
      Caption = 'Modes d'#39'impression'
      Items.Strings = (
        '( Imprimer sur une seule page )'
        'La largeur de la grille doit prendre la largeur de la page')
      TabOrder = 4
      OnClick = rgMultipagesClick
    end
    object cbAfficherLogo: TCheckBox
      Left = 16
      Top = 47
      Width = 97
      Height = 17
      Caption = 'Afficher le logo'
      Checked = True
      State = cbChecked
      TabOrder = 5
      OnClick = cbAfficherLogoClick
    end
    object bPoliceTitre: TButton
      Left = 216
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Police Titre'
      TabOrder = 6
      OnClick = bPoliceTitreClick
    end
    object cbStretch: TCheckBox
      Left = 112
      Top = 47
      Width = 97
      Height = 17
      Caption = #201'tirer'
      Checked = True
      State = cbChecked
      TabOrder = 7
      OnClick = cbStretchClick
    end
    object bSaveAs: TButton
      Left = 488
      Top = 0
      Width = 137
      Height = 25
      Caption = 'Enregistrer sous ...'
      TabOrder = 8
      OnClick = bSaveAsClick
    end
    object bCopy: TButton
      Left = 488
      Top = 24
      Width = 137
      Height = 25
      Caption = 'Copier dans presse papiers'
      TabOrder = 9
      OnClick = bCopyClick
    end
    object cbAfficherTitre: TCheckBox
      Left = 16
      Top = 62
      Width = 97
      Height = 12
      Caption = 'Afficher le titre'
      Checked = True
      State = cbChecked
      TabOrder = 10
      OnClick = cbAfficherTitreClick
    end
    object cbGrille: TCheckBox
      Left = 112
      Top = 62
      Width = 97
      Height = 12
      Caption = 'Afficher grille'
      TabOrder = 11
      OnClick = cbGrilleClick
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 587
    Width = 862
  end
  inherited pLog: TPanel
    Top = 583
    Width = 862
    Height = 4
    inherited lLog: TLabel
      Width = 860
    end
    inherited mLog: TMemo
      Width = 860
      Height = 0
    end
  end
  object pc: TPageControl [5]
    Left = 0
    Top = 18
    Width = 862
    Height = 481
    ActivePage = ts
    Align = alClient
    TabOrder = 4
    object ts: TTabSheet
      Caption = 'Page 1'
      object i: TImage
        Left = 0
        Top = 0
        Width = 854
        Height = 453
        Align = alClient
        Proportional = True
        Stretch = True
      end
    end
  end
  object PrinterSetupDialog: TPrinterSetupDialog
    Left = 48
    Top = 483
  end
  object FontDialog: TFontDialog
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    Left = 304
    Top = 550
  end
  object tShow: TTimer
    OnTimer = tShowTimer
    Left = 192
    Top = 549
  end
  object sd: TSaveDialog
    DefaultExt = '.emf'
    Filter = 'M'#233'tafichier '#233'tendu (*.emf)|*.emf'
    Left = 528
    Top = 498
  end
end
