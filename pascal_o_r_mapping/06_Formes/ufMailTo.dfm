inherited fMailTo: TfMailTo
  Left = 320
  Top = 114
  Width = 433
  Height = 388
  Caption = 'Envoi par Mail'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 325
    Width = 425
  end
  object Splitter1: TSplitter [1]
    Left = 0
    Top = 161
    Width = 425
    Height = 6
    Cursor = crVSplit
    Align = alTop
    Color = clBtnFace
    ParentColor = False
    Visible = False
  end
  inherited pSociete: TPanel
    Width = 425
    inherited lSociete: TLabel
      Width = 353
    end
    inherited lHeure: TLabel
      Left = 369
    end
    inherited animation: TAnimate
      Left = 353
    end
  end
  inherited pBas: TPanel
    Top = 284
    Width = 425
    inherited pFermer: TPanel
      Left = 192
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 335
    Width = 425
  end
  inherited pLog: TPanel
    Top = 331
    Width = 425
    Height = 4
    inherited lLog: TLabel
      Width = 423
    end
    inherited mLog: TMemo
      Width = 423
      Height = 0
    end
  end
  object Panel1: TPanel [6]
    Left = 0
    Top = 18
    Width = 425
    Height = 143
    Align = alTop
    TabOrder = 4
    object Label3: TLabel
      Left = 1
      Top = 129
      Width = 423
      Height = 13
      Align = alBottom
      Caption = 'Corps'
    end
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 423
      Height = 78
      Align = alTop
      TabOrder = 0
      DesignSize = (
        423
        78)
      object Label1: TLabel
        Left = 8
        Top = 8
        Width = 56
        Height = 13
        Caption = 'Destinataire'
      end
      object Label2: TLabel
        Left = 8
        Top = 32
        Width = 24
        Height = 13
        Caption = 'Sujet'
      end
      object Label4: TLabel
        Left = 8
        Top = 61
        Width = 65
        Height = 13
        Caption = 'Pi'#232'ces jointes'
      end
      object eTo: TEdit
        Left = 76
        Top = 5
        Width = 341
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 0
      end
      object eSubject: TEdit
        Left = 76
        Top = 32
        Width = 341
        Height = 21
        Anchors = [akLeft, akTop, akRight]
        TabOrder = 1
      end
      object bPieceJointe_Ajouter: TButton
        Left = 88
        Top = 58
        Width = 123
        Height = 19
        Caption = 'Ajouter une pi'#232'ce jointe'
        TabOrder = 2
        OnClick = bPieceJointe_AjouterClick
      end
      object bPieceJointe_Afficher: TButton
        Left = 240
        Top = 58
        Width = 151
        Height = 19
        Caption = 'Afficher les pi'#232'ces jointes'
        TabOrder = 3
        OnClick = bPieceJointe_AfficherClick
      end
    end
    object mPiecesJointes: TMemo
      Left = 1
      Top = 79
      Width = 423
      Height = 50
      Align = alClient
      TabOrder = 1
    end
  end
  object mBody: TMemo [7]
    Left = 0
    Top = 167
    Width = 425
    Height = 117
    Align = alClient
    TabOrder = 5
  end
  inherited al: TActionList
    Left = 40
    Top = 48
  end
  object tShow: TTimer
    Enabled = False
    Interval = 10
    OnTimer = tShowTimer
    Left = 232
    Top = 82
  end
  object odPieceJointe: TOpenDialog
    Left = 217
    Top = 75
  end
end
