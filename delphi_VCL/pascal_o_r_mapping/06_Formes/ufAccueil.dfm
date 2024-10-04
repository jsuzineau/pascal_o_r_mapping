object fAccueil: TfAccueil
  Left = 471
  Top = 163
  Caption = 'Journal de l'#39'ex'#195#169'cution du programme'
  ClientHeight = 533
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsStayOnTop
  Position = poScreenCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 13
  object Label1: TLabel
    Left = 0
    Top = 0
    Width = 592
    Height = 20
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Titre'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    Font.Style = []
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 0
    Top = 20
    Width = 108
    Height = 513
    Align = alLeft
    BevelOuter = bvNone
    TabOrder = 0
    OnMouseDown = Panel2MouseDown
    object Label2: TLabel
      Left = 29
      Top = 112
      Width = 48
      Height = 13
      Caption = 'les erreurs'
    end
    object bOK: TBitBtn
      Left = 2
      Top = 133
      Width = 103
      Height = 52
      Caption = 'Continuer'
      Kind = bkOK
      NumGlyphs = 2
      TabOrder = 0
      Visible = False
    end
    object bEnregistrer: TButton
      Left = 3
      Top = 256
      Width = 103
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
      Top = 96
      Width = 90
      Height = 23
      Caption = 'S'#39'arr'#195#170'ter sur'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object gbEnvoyer: TGroupBox
      Left = 0
      Top = 288
      Width = 87
      Height = 96
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
      Width = 87
      Height = 25
      Caption = 'T'#195#169'l'#195#169'assistance'
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
  end
  object pc: TPageControl
    Left = 108
    Top = 20
    Width = 484
    Height = 513
    ActivePage = tsErreur_Courante
    Align = alClient
    TabOrder = 1
    object tsErreur_Courante: TTabSheet
      Caption = 'Erreur courante'
      object m: TMemo
        Left = 0
        Top = 41
        Width = 474
        Height = 442
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
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
        Width = 474
        Height = 41
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Erreur'
        Color = clWindow
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Times New Roman'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
      end
    end
    object tsHistorique: TTabSheet
      Caption = 'Historique des erreurs'
      ImageIndex = 1
      object mHistorique: TMemo
        Left = 0
        Top = 0
        Width = 474
        Height = 483
        Align = alClient
        BorderStyle = bsNone
        Font.Charset = DEFAULT_CHARSET
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
      Caption = 'Historique D'#195#169'veloppeur'
      object mHistorique_Developpeur: TMemo
        Left = 0
        Top = 0
        Width = 476
        Height = 485
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'mHistorique_Developpeur')
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.TXT'
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
  object tRefresh: TTimer
    Enabled = False
    Interval = 500
    OnTimer = tRefreshTimer
    Left = 32
    Top = 33
  end
end
