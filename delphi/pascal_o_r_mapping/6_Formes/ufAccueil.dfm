object fAccueil: TfAccueil
  Left = 838
  Top = 182
  Caption = 'Journal de l'#39'ex'#233'cution du programme'
  ClientHeight = 494
  ClientWidth = 576
  Color = clBtnFace

  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 576
    Height = 20
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Titre'

    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
    ExplicitWidth = 584
  end
  object Panel2: TPanel
    Left = 0
    Top = 20
    Width = 91
    Height = 474
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = Panel2MouseDown
    object Label2: TLabel
      Left = 29
      Top = 128
      Width = 48
      Height = 13
      Caption = 'les erreurs'
    end
    object bOK: TBitBtn
      Left = 8
      Top = 160
      Width = 75
      Height = 25
      Caption = 'Continuer'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      Visible = False
    end
    object bEnregistrer: TButton
      Left = 3
      Top = 256
      Width = 85
      Height = 25
      Caption = 'Enregistrer sous'
      TabOrder = 1
      OnClick = bEnregistrerClick
    end
    object bTerminer: TButton
      Left = 8
      Top = 192
      Width = 75
      Height = 25
      Caption = 'Terminer'
      TabOrder = 2
      OnClick = bTerminerClick
    end
    object bTuer: TButton
      Left = 8
      Top = 224
      Width = 75
      Height = 25
      Caption = 'Tuer'
      TabOrder = 3
      OnClick = bTuerClick
    end
    object cbErreurModal: TCheckBox
      Left = 8
      Top = 112
      Width = 97
      Height = 17
      Caption = 'S'#39'arr'#234'ter sur'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object gbEnvoyer: TGroupBox
      Left = 0
      Top = 288
      Width = 87
      Height = 82
      Caption = 'Envoyer'
      TabOrder = 5
      object bFTP: TButton
        Left = 8
        Top = 48
        Width = 71
        Height = 25
        Caption = 'par FTP'
        TabOrder = 0
        OnClick = bFTPClick
      end
      object bMail: TButton
        Left = 8
        Top = 16
        Width = 71
        Height = 25
        Caption = 'par mail'
        TabOrder = 1
        OnClick = bMailClick
      end
    end
    object bInformix: TButton
      Left = 0
      Top = 392
      Width = 25
      Height = 25
      Caption = 'I'
      TabOrder = 6
      OnClick = bInformixClick
    end
    object bMySQL: TButton
      Left = 30
      Top = 392
      Width = 25
      Height = 25
      Caption = 'M'
      TabOrder = 7
      OnClick = bMySQLClick
    end
    object bVariables_d_environnement: TButton
      Left = 59
      Top = 392
      Width = 29
      Height = 25
      Caption = 'V'
      TabOrder = 8
      OnClick = bVariables_d_environnementClick
    end
    object bTeleassistance: TButton
      Left = 2
      Top = 451
      Width = 81
      Height = 25
      Caption = 'T'#233'l'#233'assistance'
      TabOrder = 9
      OnClick = bTeleassistanceClick
    end
    object bParametres: TButton
      Left = 3
      Top = 421
      Width = 79
      Height = 25
      Caption = 'Parametres'
      TabOrder = 10
      OnClick = bParametresClick
    end
    object bOPN: TButton
      Left = 2
      Top = 373
      Width = 23
      Height = 16
      Hint = 'OPN'
      Caption = 'O'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 11
      OnClick = bOPNClick
    end
    object bOPN_Requeteur: TButton
      Left = 32
      Top = 372
      Width = 34
      Height = 17
      Hint = 'OPN Requ'#234'teur'
      Caption = 'R'
      ParentShowHint = False
      ShowHint = True
      TabOrder = 12
      OnClick = bOPN_RequeteurClick
    end
  end
  object pc: TPageControl
    Left = 91
    Top = 20
    Width = 485
    Height = 474
    ActivePage = tsHistorique_Developpeur
    Align = alClient
    TabOrder = 1
    OnChange = pcChange
    object tsLigne_Courante: TTabSheet
      Caption = 'Ligne courante'
      object m: TMemo
        Left = 42
        Top = 41
        Width = 393
        Height = 364
        Align = alClient
        BorderStyle = bsNone

        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 477
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Color = clWindow

        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 1
      end
      object Panel3: TPanel
        Left = 0
        Top = 405
        Width = 477
        Height = 41
        Align = alBottom
        BevelOuter = bvNone
        Color = clWindow

        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 2
      end
      object Panel4: TPanel
        Left = 0
        Top = 41
        Width = 42
        Height = 364
        Align = alLeft
        BevelOuter = bvNone
        Color = clWindow

        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 3
      end
      object Panel5: TPanel
        Left = 435
        Top = 41
        Width = 42
        Height = 364
        Align = alRight
        BevelOuter = bvNone
        Color = clWindow

        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentBackground = False
        ParentFont = False
        TabOrder = 4
      end
    end
    object tsHistorique: TTabSheet
      Caption = 'Historique'
      ImageIndex = 1
      object mHistorique: TMemo
        Left = 0
        Top = 0
        Width = 477
        Height = 446
        Align = alClient
        BorderStyle = bsNone

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tsHistorique_Developpeur: TTabSheet
      Caption = 'Historique D'#233'veloppeur'
      ImageIndex = 2
      object mHistorique_Developpeur: TMemo
        Left = 0
        Top = 0
        Width = 477
        Height = 446
        Align = alClient
        BorderStyle = bsNone

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = 'TXT'
    Filter = 'Fichier texte|*.TXT'
    Left = 24
    Top = 276
  end
  object tExecute: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tExecuteTimer
    Left = 56
    Top = 316
  end
end
