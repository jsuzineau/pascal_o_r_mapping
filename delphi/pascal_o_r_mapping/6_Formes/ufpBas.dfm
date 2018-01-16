inherited fpBas: TfpBas
  Left = 376
  Top = 139
  Caption = 'fpBas'
  OldCreateOrder = True
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object sLog: TSplitter [0]
    Left = 0
    Top = 131
    Width = 354
    Height = 6
    Cursor = crVSplit
    Align = alBottom
    Color = clLime
    ParentColor = False
    Visible = False
    ExplicitTop = 478
    ExplicitWidth = 809
  end
  inherited pSociete: TPanel
    TabOrder = 1
    ExplicitWidth = 809
    inherited lSociete: TLabel
      Width = 56
      Height = 14
    end
    inherited lHeure: TLabel
      Left = 753
      Height = 14
      ExplicitLeft = 753
    end
  end
  object pBas: TPanel
    Left = 0
    Top = 90
    Width = 354
    Height = 41
    Align = alBottom
    ParentBackground = False
    TabOrder = 0
    ExplicitTop = 437
    ExplicitWidth = 809
    object pFermer: TPanel
      Left = 576
      Top = 1
      Width = 232
      Height = 39
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 0
      object bAbandon: TBitBtn
        Left = 128
        Top = 8
        Width = 96
        Height = 25
        Action = aAbandon
        Cancel = True
        Caption = 'Abandon (F9)'
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          333333333333333333333333000033338833333333333333333F333333333333
          0000333911833333983333333388F333333F3333000033391118333911833333
          38F38F333F88F33300003339111183911118333338F338F3F8338F3300003333
          911118111118333338F3338F833338F3000033333911111111833333338F3338
          3333F8330000333333911111183333333338F333333F83330000333333311111
          8333333333338F3333383333000033333339111183333333333338F333833333
          00003333339111118333333333333833338F3333000033333911181118333333
          33338333338F333300003333911183911183333333383338F338F33300003333
          9118333911183333338F33838F338F33000033333913333391113333338FF833
          38F338F300003333333333333919333333388333338FFF830000333333333333
          3333333333333333333888330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        TabOrder = 0
      end
      object bValidation: TBitBtn
        Left = 8
        Top = 8
        Width = 112
        Height = 25
        Action = aValidation
        Caption = 'Validation (F7)'
        Glyph.Data = {
          DE010000424DDE01000000000000760000002800000024000000120000000100
          0400000000006801000000000000000000001000000000000000000000000000
          80000080000000808000800000008000800080800000C0C0C000808080000000
          FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
          3333333333333333333333330000333333333333333333333333F33333333333
          00003333344333333333333333388F3333333333000033334224333333333333
          338338F3333333330000333422224333333333333833338F3333333300003342
          222224333333333383333338F3333333000034222A22224333333338F338F333
          8F33333300003222A3A2224333333338F3838F338F33333300003A2A333A2224
          33333338F83338F338F33333000033A33333A222433333338333338F338F3333
          0000333333333A222433333333333338F338F33300003333333333A222433333
          333333338F338F33000033333333333A222433333333333338F338F300003333
          33333333A222433333333333338F338F00003333333333333A22433333333333
          3338F38F000033333333333333A223333333333333338F830000333333333333
          333A333333333333333338330000333333333333333333333333333333333333
          0000}
        NumGlyphs = 2
        PopupMenu = pmValidation
        TabOrder = 1
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 209
    Width = 354
    Height = 19
    AutoHint = True
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    Panels = <>
    UseSystemFont = False
    ExplicitTop = 556
    ExplicitWidth = 809
  end
  object pLog: TPanel
    Left = 0
    Top = 137
    Width = 354
    Height = 72
    Align = alBottom
    Caption = 'pLog'
    ParentBackground = False
    TabOrder = 3
    Visible = False
    ExplicitTop = 484
    ExplicitWidth = 809
    object lLog: TLabel
      Left = 1
      Top = 1
      Width = 352
      Height = 13
      Align = alTop
      Caption = 'Journal des op'#233'rations'
      ExplicitWidth = 106
    end
    object mLog: TMemo
      Left = 1
      Top = 14
      Width = 352
      Height = 57
      Align = alClient

      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        'mLog')
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
      OnMouseDown = mLogMouseDown
    end
  end
  object al: TActionList
    Left = 496
    Top = 328
    object aValidation: TAction
      Caption = 'Validation (F7)'
      ShortCut = 118
      OnExecute = aValidationExecute
    end
    object aAbandon: TAction
      Caption = 'Abandon (F9)'
      ShortCut = 120
      OnExecute = aAbandonExecute
    end
  end
  object pmValidation: TPopupMenu
    Left = 544
    Top = 449
    object miModele: TMenuItem
      Caption = 'Mod'#232'le'
      Visible = False
      OnClick = miModeleClick
    end
    object miOPN_fpBas: TMenuItem
      Caption = 'OPN'
      OnClick = miOPN_fpBasClick
    end
    object miOPN_Requeteur_fpBas: TMenuItem
      Caption = 'OPN Requ'#234'teur'
      OnClick = miOPN_Requeteur_fpBasClick
    end
    object miValidation_fAccueil: TMenuItem
      Caption = 'Afficher la fen'#234'tre de log'
      OnClick = miValidation_fAccueilClick
    end
    object miValidation_AfficherLog: TMenuItem
      Caption = 'Afficher le log en bas'
      OnClick = miValidation_AfficherLogClick
    end
    object miClassName: TMenuItem
    end
  end
end
