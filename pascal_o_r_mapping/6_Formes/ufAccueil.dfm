object fAccueil: TfAccueil
  Left = 471
  Height = 533
  Top = 163
  Width = 592
  Caption = 'Journal de l''exécution du programme'
  ClientHeight = 533
  ClientWidth = 592
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  FormStyle = fsStayOnTop
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  Position = poScreenCenter
  LCLVersion = '1.8.0.6'
  object Label1: TLabel
    Left = 0
    Height = 20
    Top = 0
    Width = 592
    Align = alTop
    Alignment = taCenter
    AutoSize = False
    Caption = 'Titre'
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'MS Sans Serif'
    ParentColor = False
    ParentFont = False
  end
  object Panel2: TPanel
    Left = 0
    Height = 513
    Top = 20
    Width = 108
    Align = alLeft
    BevelOuter = bvNone
    ClientHeight = 513
    ClientWidth = 108
    TabOrder = 0
    OnMouseDown = Panel2MouseDown
    object Label2: TLabel
      Left = 29
      Height = 14
      Top = 128
      Width = 62
      Caption = 'les erreurs'
      ParentColor = False
    end
    object bOK: TBitBtn
      Left = 2
      Height = 30
      Top = 155
      Width = 85
      Caption = 'Continuer'
      Kind = bkOK
      ModalResult = 1
      TabOrder = 0
      Visible = False
    end
    object bEnregistrer: TButton
      Left = 3
      Height = 25
      Top = 256
      Width = 103
      Caption = 'Enregistrer sous'
      OnClick = bEnregistrerClick
      TabOrder = 1
    end
    object bTerminer: TButton
      Left = 8
      Height = 25
      Top = 192
      Width = 75
      Caption = 'Terminer'
      OnClick = bTerminerClick
      TabOrder = 2
    end
    object bTuer: TButton
      Left = 8
      Height = 25
      Top = 224
      Width = 75
      Caption = 'Tuer'
      OnClick = bTuerClick
      TabOrder = 3
    end
    object cbErreurModal: TCheckBox
      Left = 8
      Height = 24
      Top = 112
      Width = 110
      Caption = 'S''arrêter sur'
      Checked = True
      State = cbChecked
      TabOrder = 4
    end
    object gbEnvoyer: TGroupBox
      Left = 0
      Height = 96
      Top = 288
      Width = 87
      Caption = 'Envoyer'
      ClientHeight = 80
      ClientWidth = 83
      TabOrder = 5
      object bFTP: TButton
        Left = 8
        Height = 25
        Top = 48
        Width = 71
        Caption = 'par FTP'
        OnClick = bFTPClick
        TabOrder = 0
      end
      object bMail: TButton
        Left = 8
        Height = 25
        Top = 16
        Width = 71
        Caption = 'par mail'
        OnClick = bMailClick
        TabOrder = 1
      end
    end
    object bInformix: TButton
      Left = 0
      Height = 25
      Top = 392
      Width = 25
      Caption = 'I'
      OnClick = bInformixClick
      TabOrder = 6
    end
    object bMySQL: TButton
      Left = 30
      Height = 25
      Top = 392
      Width = 25
      Caption = 'M'
      OnClick = bMySQLClick
      TabOrder = 7
    end
    object bVariables_d_environnement: TButton
      Left = 59
      Height = 25
      Top = 392
      Width = 29
      Caption = 'V'
      OnClick = bVariables_d_environnementClick
      TabOrder = 8
    end
    object bTeleassistance: TButton
      Left = 2
      Height = 25
      Top = 451
      Width = 87
      Caption = 'Téléassistance'
      OnClick = bTeleassistanceClick
      TabOrder = 9
    end
    object bParametres: TButton
      Left = 3
      Height = 25
      Top = 421
      Width = 79
      Caption = 'Parametres'
      OnClick = bParametresClick
      TabOrder = 10
    end
  end
  object pc: TPageControl
    Left = 108
    Height = 513
    Top = 20
    Width = 484
    ActivePage = tsHistorique_Developpeur
    Align = alClient
    TabIndex = 2
    TabOrder = 1
    object tsErreur_Courante: TTabSheet
      Caption = 'Erreur courante'
      ClientHeight = 485
      ClientWidth = 480
      object m: TMemo
        Left = 0
        Height = 446
        Top = 41
        Width = 476
        Align = alClient
        BorderStyle = bsNone
        Font.Color = clWindowText
        Font.Height = -16
        Font.Name = 'Times New Roman'
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
      object Panel1: TPanel
        Left = 0
        Height = 41
        Top = 0
        Width = 476
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Erreur'
        Color = clWindow
        Font.Color = clWindowText
        Font.Height = -19
        Font.Name = 'Times New Roman'
        ParentColor = False
        ParentFont = False
        TabOrder = 1
      end
    end
    object tsHistorique: TTabSheet
      Caption = 'Historique des erreurs'
      ClientHeight = 485
      ClientWidth = 480
      ImageIndex = 1
      object mHistorique: TMemo
        Left = 0
        Height = 487
        Top = 0
        Width = 476
        Align = alClient
        BorderStyle = bsNone
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        ParentFont = False
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
    object tsHistorique_Developpeur: TTabSheet
      Caption = 'Historique Développeur'
      ClientHeight = 485
      ClientWidth = 480
      object mHistorique_Developpeur: TMemo
        Left = 0
        Height = 485
        Top = 0
        Width = 480
        Align = alClient
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Lines.Strings = (
          'mHistorique_Developpeur'
        )
        ParentFont = False
        TabOrder = 0
      end
    end
  end
  object SaveDialog: TSaveDialog
    DefaultExt = '.TXT'
    Filter = 'Fichier texte|*.TXT'
    left = 24
    top = 276
  end
  object tExecute: TTimer
    Enabled = False
    Interval = 200
    OnTimer = tExecuteTimer
    left = 56
    top = 316
  end
end
