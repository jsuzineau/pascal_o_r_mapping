object fOpenDocument_DelphiReportEngine: TfOpenDocument_DelphiReportEngine
  Left = 136
  Height = 656
  Top = 185
  Width = 1142
  Caption = 'fOpenDocument_DelphiReportEngine'
  ClientHeight = 656
  ClientWidth = 1142
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnDropFiles = FormDropFiles
  OnShow = FormShow
  LCLVersion = '1.0.1.3'
  object pc: TPageControl
    Left = 0
    Height = 656
    Top = 0
    Width = 1142
    ActivePage = tsODRE_Table
    Align = alClient
    TabIndex = 4
    TabOrder = 0
    object tsContent: TTabSheet
      Caption = 'Content.xml'
      ClientHeight = 628
      ClientWidth = 1138
      object tvContent: TTreeView
        Left = 0
        Height = 594
        Top = 0
        Width = 1126
        Align = alClient
        Indent = 19
        TabOrder = 0
      end
    end
    object tsStyles: TTabSheet
      Caption = 'Styles.xml'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 1
      object tvStyles: TTreeView
        Left = 0
        Height = 594
        Top = 0
        Width = 1126
        Align = alClient
        Indent = 19
        TabOrder = 0
      end
    end
    object tsTV_Insertion: TTabSheet
      Caption = 'Insertion de champs dans le modèle'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 2
      object Panel3: TPanel
        Left = 0
        Height = 41
        Top = 553
        Width = 1126
        Align = alBottom
        ClientHeight = 41
        ClientWidth = 1126
        TabOrder = 0
        object bInserer: TButton
          Left = 8
          Height = 25
          Top = 8
          Width = 134
          Caption = 'Insérer dans le document'
          OnClick = bInsererClick
          TabOrder = 0
        end
        object cbOptimiserInsertion: TCheckBox
          Left = 184
          Height = 17
          Top = 12
          Width = 65
          Caption = 'Optimiser'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
      end
      object tvi: TTreeView
        Left = 0
        Height = 553
        Top = 0
        Width = 1126
        Align = alClient
        Indent = 19
        TabOrder = 1
      end
    end
    object tsTV: TTabSheet
      Caption = 'Modification de valeurs'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 1
      object tv: TTreeView
        Left = 0
        Height = 522
        Top = 0
        Width = 1126
        Align = alClient
        Indent = 19
        TabOrder = 0
        OnEditing = tvEditing
      end
      object Panel1: TPanel
        Left = 0
        Height = 72
        Top = 522
        Width = 1126
        Align = alBottom
        ClientHeight = 72
        ClientWidth = 1126
        TabOrder = 1
        object bArborescence_from_Natif: TButton
          Left = 8
          Height = 25
          Top = 7
          Width = 145
          Caption = 'Arborescence_from_Natif'
          OnClick = bArborescence_from_NatifClick
          TabOrder = 0
        end
        object bToutOuvrir: TButton
          Left = 8
          Height = 25
          Top = 40
          Width = 75
          Caption = 'Tout ouvrir'
          OnClick = bToutOuvrirClick
          TabOrder = 1
        end
        object bToutFermer: TButton
          Left = 88
          Height = 25
          Top = 40
          Width = 75
          Caption = 'Tout fermer'
          OnClick = bToutFermerClick
          TabOrder = 2
        end
        object gbBranche: TGroupBox
          Left = 168
          Height = 64
          Top = 2
          Width = 401
          Caption = 'Pour la branche sélectionnée'
          ClientHeight = 48
          ClientWidth = 397
          TabOrder = 3
          object bDupliquer: TButton
            Left = 70
            Height = 25
            Top = 24
            Width = 58
            Caption = 'Dupliquer'
            OnClick = bDupliquerClick
            TabOrder = 0
          end
          object bSupprimer: TButton
            Left = 6
            Height = 25
            Top = 24
            Width = 58
            Caption = 'Supprimer'
            OnClick = bSupprimerClick
            TabOrder = 1
          end
          object bExporter: TButton
            Left = 136
            Height = 25
            Top = 24
            Width = 54
            Caption = 'Exporter'
            OnClick = bExporterClick
            TabOrder = 2
          end
          object bImporter: TButton
            Left = 200
            Height = 25
            Top = 24
            Width = 54
            Caption = 'Importer'
            OnClick = bImporterClick
            TabOrder = 3
          end
          object bOuvrir: TButton
            Left = 264
            Height = 25
            Top = 24
            Width = 59
            Caption = 'Ouvrir'
            OnClick = bOuvrirClick
            TabOrder = 4
          end
          object bFermer: TButton
            Left = 330
            Height = 25
            Top = 24
            Width = 59
            Caption = 'Fermer'
            OnClick = bFermerClick
            TabOrder = 5
          end
        end
        object bFrom_Document: TButton
          Left = 648
          Height = 25
          Top = 8
          Width = 97
          Caption = 'From Document'
          OnClick = bFrom_DocumentClick
          TabOrder = 4
        end
        object bChrono: TButton
          Left = 904
          Height = 25
          Top = 24
          Width = 75
          Caption = 'Chrono'
          OnClick = bChronoClick
          TabOrder = 5
        end
      end
    end
    object tsODRE_Table: TTabSheet
      Caption = 'ODRE_Table'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 11
      object lbODRE_Table: TListBox
        Left = 0
        Height = 97
        Top = 0
        Width = 1138
        Align = alTop
        ItemHeight = 0
        OnClick = lbODRE_TableClick
        ScrollWidth = 1136
        TabOrder = 0
        TopIndex = -1
      end
      object Panel5: TPanel
        Left = 0
        Height = 531
        Top = 97
        Width = 1138
        Align = alClient
        ClientHeight = 531
        ClientWidth = 1138
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Height = 15
          Top = 8
          Width = 68
          Caption = 'NbColonnes'
          ParentColor = False
        end
        object speODRE_Table_NbColonnes: TSpinEdit
          Left = 72
          Height = 24
          Top = 7
          Width = 69
          MaxValue = 0
          TabOrder = 0
        end
        object mODRE_Table_Colonnes: TMemo
          Left = 8
          Height = 137
          Top = 32
          Width = 297
          Lines.Strings = (
            'mOD_Table_Colonnes'
          )
          TabOrder = 1
        end
        object bSupprimerColonne: TButton
          Left = 360
          Height = 25
          Top = 8
          Width = 104
          Caption = 'SupprimerColonne'
          OnClick = bSupprimerColonneClick
          TabOrder = 2
        end
        object speSupprimerColonne_Numero: TSpinEdit
          Left = 469
          Height = 24
          Top = 9
          Width = 38
          MaxValue = 0
          TabOrder = 3
        end
      end
    end
    object tsVLE: TTabSheet
      Caption = 'Format natif'
      ClientHeight = 628
      ClientWidth = 1138
      object vle: TValueListEditor
        Left = 0
        Height = 594
        Top = 0
        Width = 1126
        Align = alClient
        FixedCols = 0
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        ParentFont = False
        TabOrder = 0
        TitleFont.Color = clWindowText
        TitleFont.Height = -11
        TitleFont.Name = 'Courier New'
        KeyOptions = [keyEdit, keyAdd, keyUnique]
        ColWidths = (
          317
          803
        )
      end
    end
    object tsContent_XML: TTabSheet
      Caption = 'tsContent_XML'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 5
      object mContent_XML: TMemo
        Left = 0
        Height = 553
        Top = 0
        Width = 1126
        Align = alClient
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Lines.Strings = (
          'mContent_XML'
        )
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Height = 41
        Top = 553
        Width = 1126
        Align = alBottom
        ClientHeight = 41
        ClientWidth = 1126
        TabOrder = 1
        object bContent_Enregistrer: TButton
          Left = 8
          Height = 25
          Top = 8
          Width = 75
          Caption = 'Valider'
          OnClick = bContent_EnregistrerClick
          TabOrder = 0
        end
      end
    end
    object tsStyles_XML: TTabSheet
      Caption = 'tsStyles_XML'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 6
      object mStyles_XML: TMemo
        Left = 0
        Height = 553
        Top = 0
        Width = 1126
        Align = alClient
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Lines.Strings = (
          'mStyles_XML'
        )
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 0
        Height = 41
        Top = 553
        Width = 1126
        Align = alBottom
        ClientHeight = 41
        ClientWidth = 1126
        TabOrder = 1
        object bStyles_Enregistrer: TButton
          Left = 8
          Height = 25
          Top = 8
          Width = 75
          Caption = 'Valider'
          OnClick = bStyles_EnregistrerClick
          TabOrder = 0
        end
      end
    end
    object tsMIMETYPE: TTabSheet
      Caption = 'tsMIMETYPE'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 7
      object mMIMETYPE: TMemo
        Left = 0
        Height = 594
        Top = 0
        Width = 1126
        Align = alClient
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Lines.Strings = (
          'mMIMETYPE'
        )
        ParentFont = False
        TabOrder = 0
      end
    end
    object tsMETA_XML: TTabSheet
      Caption = 'tsMETA_XML'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 8
      object mMETA_XML: TMemo
        Left = 0
        Height = 594
        Top = 0
        Width = 1126
        Align = alClient
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Lines.Strings = (
          'mMETA_XML'
        )
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tsSETTINGS_XML: TTabSheet
      Caption = 'tsSETTINGS_XML'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 9
      object mSETTINGS_XML: TMemo
        Left = 0
        Height = 594
        Top = 0
        Width = 1126
        Align = alClient
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Lines.Strings = (
          'mSETTINGS_XML'
        )
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tsMETA_INF_manifest_xml: TTabSheet
      Caption = 'tsMETA_INF_manifest_xml'
      ClientHeight = 628
      ClientWidth = 1138
      ImageIndex = 10
      object mMETA_INF_manifest_xml: TMemo
        Left = 0
        Height = 594
        Top = 0
        Width = 1126
        Align = alClient
        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Lines.Strings = (
          'mMETA_INF_manifest_xml'
        )
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object odODF: TOpenDialog
    DefaultExt = '.ott'
    Filter = 'modèle devis|DEV*.ott|texte odt|*.odt|modèle texte ott|*.ott'
    FilterIndex = 3
    InitialDir = '\\linuxm\a\modeles_oo'
    left = 40
    top = 16
  end
  object sd: TSaveDialog
    DefaultExt = '.txt'
    left = 324
    top = 491
  end
  object od: TOpenDialog
    DefaultExt = '.TXT'
    left = 385
    top = 491
  end
  object tShow: TTimer
    Enabled = False
    OnTimer = tShowTimer
    left = 108
    top = 136
  end
end