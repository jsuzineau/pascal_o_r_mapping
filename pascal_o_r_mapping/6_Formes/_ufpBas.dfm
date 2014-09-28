inherited fpBas: TfpBas
  Left = 379
  Height = 613
  Top = 344
  Width = 821
  Caption = 'fpBas'
  ClientHeight = 613
  ClientWidth = 821
  OnShow = FormShow
  inherited pSociete: TPanel
    Width = 821
    ClientWidth = 821
    TabOrder = 1
    inherited lSociete: TLabel
      Width = 764
    end
    inherited lHeure: TLabel
      Left = 764
    end
    inherited animation: TAnimate
      Left = 741
    end
  end
  object sLog: TSplitter[1]
    Cursor = crVSplit
    Left = 0
    Height = 6
    Top = 514
    Width = 821
    Align = alBottom
    Color = clLime
    ParentColor = False
    ResizeAnchor = akBottom
    Visible = False
  end
  object pBas: TPanel[2]
    Left = 0
    Height = 41
    Top = 473
    Width = 821
    Align = alBottom
    ClientHeight = 41
    ClientWidth = 821
    TabOrder = 0
    object pFermer: TPanel
      Left = 588
      Height = 39
      Top = 1
      Width = 232
      Align = alRight
      BevelOuter = bvNone
      ClientHeight = 39
      ClientWidth = 232
      TabOrder = 0
      object bAbandon: TBitBtn
        Left = 128
        Height = 25
        Top = 8
        Width = 96
        Action = aAbandon
        Cancel = True
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
          0000
        }
        ModalResult = 2
        NumGlyphs = 2
        TabOrder = 0
      end
      object bValidation: TBitBtn
        Left = 8
        Height = 25
        Top = 8
        Width = 112
        Action = aValidation
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
          0000
        }
        ModalResult = 1
        NumGlyphs = 2
        PopupMenu = pmValidation
        TabOrder = 1
      end
    end
  end
  object StatusBar1: TStatusBar[3]
    Left = 0
    Height = 21
    Top = 592
    Width = 821
    AutoHint = True
    Panels = <>
  end
  object pLog: TPanel[4]
    Left = 0
    Height = 72
    Top = 520
    Width = 821
    Align = alBottom
    Caption = 'pLog'
    ClientHeight = 72
    ClientWidth = 821
    TabOrder = 3
    Visible = False
    object lLog: TLabel
      Left = 1
      Height = 15
      Top = 1
      Width = 819
      Align = alTop
      Caption = 'Journal des opérations'
      ParentColor = False
    end
    object mLog: TMemo
      Left = 1
      Height = 55
      Top = 16
      Width = 819
      Align = alClient
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Lines.Strings = (
        'mLog'
      )
      OnMouseDown = mLogMouseDown
      ParentFont = False
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
  object al: TActionList[5]
    left = 496
    top = 328
    object aValidation: TAction
      Caption = 'Validation (F7)'
      OnExecute = aValidationExecute
      ShortCut = 118
    end
    object aAbandon: TAction
      Caption = 'Abandon (F9)'
      OnExecute = aAbandonExecute
      ShortCut = 120
    end
  end
  object pmValidation: TPopupMenu[6]
    left = 544
    top = 449
    object miModele: TMenuItem
      Caption = 'Modèle'
      Visible = False
      OnClick = miModeleClick
    end
  end
end