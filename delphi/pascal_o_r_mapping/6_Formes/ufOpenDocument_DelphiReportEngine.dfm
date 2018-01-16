object fOpenDocument_DelphiReportEngine: TfOpenDocument_DelphiReportEngine
  Left = 240
  Top = 185
  Width = 1142
  Height = 656
  Caption = 'fOpenDocument_DelphiReportEngine'
  Color = clBtnFace

  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pc: TPageControl
    Left = 0
    Top = 0
    Width = 1134
    Height = 622
    ActivePage = tsTV_Insertion
    Align = alClient
    TabOrder = 0
    object tsContent: TTabSheet
      Caption = 'Content.xml'
      object tvContent: TTreeView
        Left = 0
        Top = 0
        Width = 1126
        Height = 594
        Align = alClient
        Indent = 19
        TabOrder = 0
      end
    end
    object tsStyles: TTabSheet
      Caption = 'Styles.xml'
      ImageIndex = 1
      object tvStyles: TTreeView
        Left = 0
        Top = 0
        Width = 1126
        Height = 594
        Align = alClient
        Indent = 19
        TabOrder = 0
      end
    end
    object tsTV_Insertion: TTabSheet
      Caption = 'Insertion de champs dans le mod'#232'le'
      ImageIndex = 2
      object Panel3: TPanel
        Left = 0
        Top = 522
        Width = 1126
        Height = 72
        Align = alBottom
        TabOrder = 0
        object bInserer: TButton
          Left = 8
          Top = 8
          Width = 134
          Height = 25
          Caption = 'Ins'#233'rer dans le document'
          TabOrder = 0
          OnClick = bInsererClick
        end
        object cbOptimiserInsertion: TCheckBox
          Left = 184
          Top = 12
          Width = 65
          Height = 17
          Caption = 'Optimiser'
          Checked = True
          State = cbChecked
          TabOrder = 1
        end
        object gbBranche_Insertion: TGroupBox
          Left = 280
          Top = 2
          Width = 185
          Height = 64
          Caption = 'Pour la branche s'#233'lectionn'#233'e ...'
          TabOrder = 2
          object bSupprimer_Insertion: TButton
            Left = 6
            Top = 24
            Width = 58
            Height = 25
            Caption = 'Supprimer'
            TabOrder = 0
            OnClick = bSupprimer_InsertionClick
          end
        end
      end
      object tvi: TTreeView
        Left = 0
        Top = 0
        Width = 1126
        Height = 522
        Align = alClient
        Indent = 19
        TabOrder = 1
      end
    end
    object tsTV: TTabSheet
      Caption = 'Modification de valeurs'
      ImageIndex = 1
      object tv: TTreeView
        Left = 0
        Top = 0
        Width = 1126
        Height = 522
        Align = alClient
        Indent = 19
        TabOrder = 0
        OnEditing = tvEditing
      end
      object Panel1: TPanel
        Left = 0
        Top = 522
        Width = 1126
        Height = 72
        Align = alBottom
        TabOrder = 1
        object bArborescence_from_Natif: TButton
          Left = 8
          Top = 7
          Width = 145
          Height = 25
          Caption = 'Arborescence_from_Natif'
          TabOrder = 0
          OnClick = bArborescence_from_NatifClick
        end
        object bToutOuvrir: TButton
          Left = 8
          Top = 40
          Width = 75
          Height = 25
          Caption = 'Tout ouvrir'
          TabOrder = 1
          OnClick = bToutOuvrirClick
        end
        object bToutFermer: TButton
          Left = 88
          Top = 40
          Width = 75
          Height = 25
          Caption = 'Tout fermer'
          TabOrder = 2
          OnClick = bToutFermerClick
        end
        object gbBranche: TGroupBox
          Left = 168
          Top = 2
          Width = 401
          Height = 64
          Caption = 'Pour la branche s'#233'lectionn'#233'e'
          TabOrder = 3
          object bDupliquer: TButton
            Left = 70
            Top = 24
            Width = 58
            Height = 25
            Caption = 'Dupliquer'
            TabOrder = 0
            OnClick = bDupliquerClick
          end
          object bSupprimer: TButton
            Left = 6
            Top = 24
            Width = 58
            Height = 25
            Caption = 'Supprimer'
            TabOrder = 1
            OnClick = bSupprimerClick
          end
          object bExporter: TButton
            Left = 136
            Top = 24
            Width = 54
            Height = 25
            Caption = 'Exporter'
            TabOrder = 2
            OnClick = bExporterClick
          end
          object bImporter: TButton
            Left = 200
            Top = 24
            Width = 54
            Height = 25
            Caption = 'Importer'
            TabOrder = 3
            OnClick = bImporterClick
          end
          object bOuvrir: TButton
            Left = 264
            Top = 24
            Width = 59
            Height = 25
            Caption = 'Ouvrir'
            TabOrder = 4
            OnClick = bOuvrirClick
          end
          object bFermer: TButton
            Left = 330
            Top = 24
            Width = 59
            Height = 25
            Caption = 'Fermer'
            TabOrder = 5
            OnClick = bFermerClick
          end
        end
        object bFrom_Document: TButton
          Left = 648
          Top = 8
          Width = 97
          Height = 25
          Caption = 'From Document'
          TabOrder = 4
          OnClick = bFrom_DocumentClick
        end
        object bChrono: TButton
          Left = 904
          Top = 24
          Width = 75
          Height = 25
          Caption = 'Chrono'
          TabOrder = 5
          OnClick = bChronoClick
        end
      end
    end
    object tsODRE_Table: TTabSheet
      Caption = 'ODRE_Table'
      ImageIndex = 11
      object lbODRE_Table: TListBox
        Left = 0
        Top = 0
        Width = 1126
        Height = 97
        Align = alTop
        ItemHeight = 13
        TabOrder = 0
        OnClick = lbODRE_TableClick
      end
      object Panel5: TPanel
        Left = 0
        Top = 97
        Width = 1126
        Height = 497
        Align = alClient
        TabOrder = 1
        object Label1: TLabel
          Left = 8
          Top = 8
          Width = 58
          Height = 13
          Caption = 'NbColonnes'
        end
        object speODRE_Table_NbColonnes: TSpinEdit
          Left = 72
          Top = 7
          Width = 69
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 0
          Value = 0
        end
        object mODRE_Table_Colonnes: TMemo
          Left = 8
          Top = 32
          Width = 297
          Height = 137
          Lines.Strings = (
            'mOD_Table_Colonnes')
          TabOrder = 1
        end
        object bSupprimerColonne: TButton
          Left = 360
          Top = 8
          Width = 156
          Height = 25
          Caption = 'SupprimerColonne'
          TabOrder = 2
          OnClick = bSupprimerColonneClick
        end
        object speSupprimerColonne_Numero: TSpinEdit
          Left = 525
          Top = 9
          Width = 38
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 3
          Value = 0
        end
        object bInsererColonne: TButton
          Left = 360
          Top = 40
          Width = 156
          Height = 25
          Caption = 'Inserer Colonne Apr'#233's'
          TabOrder = 4
          OnClick = bInsererColonneClick
        end
        object speInsererColonne_Numero: TSpinEdit
          Left = 525
          Top = 41
          Width = 38
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 5
          Value = 0
        end
        object bDecalerChampsApresColonne: TButton
          Left = 360
          Top = 80
          Width = 156
          Height = 25
          Caption = 'DecalerChampsApresColonne'
          TabOrder = 6
          OnClick = bDecalerChampsApresColonneClick
        end
        object speDecalerChampsApresColonne_Numero: TSpinEdit
          Left = 525
          Top = 81
          Width = 38
          Height = 22
          MaxValue = 0
          MinValue = 0
          TabOrder = 7
          Value = 0
        end
      end
    end
    object tsVLE: TTabSheet
      Caption = 'Format natif'
      object vle: TValueListEditor
        Left = 0
        Top = 0
        Width = 1126
        Height = 594
        Align = alClient

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        KeyOptions = [keyEdit, keyAdd, keyUnique]
        ParentFont = False
        TabOrder = 0
        ColWidths = (
          317
          803)
      end
    end
    object tsContent_XML: TTabSheet
      Caption = 'tsContent_XML'
      ImageIndex = 5
      object mContent_XML: TMemo
        Left = 0
        Top = 0
        Width = 1126
        Height = 553
        Align = alClient

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'mContent_XML')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Panel2: TPanel
        Left = 0
        Top = 553
        Width = 1126
        Height = 41
        Align = alBottom
        TabOrder = 1
        object bContent_Enregistrer: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Valider'
          TabOrder = 0
          OnClick = bContent_EnregistrerClick
        end
        object eContent_XML_Chercher: TEdit
          Left = 184
          Top = 8
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object bContent_XML_Chercher: TButton
          Left = 312
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Chercher'
          TabOrder = 2
          OnClick = bContent_XML_ChercherClick
        end
      end
    end
    object tsStyles_XML: TTabSheet
      Caption = 'tsStyles_XML'
      ImageIndex = 6
      object mStyles_XML: TMemo
        Left = 0
        Top = 0
        Width = 1126
        Height = 553
        Align = alClient

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'mStyles_XML')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 0
        Top = 553
        Width = 1126
        Height = 41
        Align = alBottom
        TabOrder = 1
        object bStyles_Enregistrer: TButton
          Left = 8
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Valider'
          TabOrder = 0
          OnClick = bStyles_EnregistrerClick
        end
        object eStyles_XML_Chercher: TEdit
          Left = 184
          Top = 8
          Width = 121
          Height = 21
          TabOrder = 1
        end
        object bStyles_XML_Chercher: TButton
          Left = 312
          Top = 8
          Width = 75
          Height = 25
          Caption = 'Chercher'
          TabOrder = 2
          OnClick = bStyles_XML_ChercherClick
        end
      end
    end
    object tsMIMETYPE: TTabSheet
      Caption = 'tsMIMETYPE'
      ImageIndex = 7
      object mMIMETYPE: TMemo
        Left = 0
        Top = 0
        Width = 1126
        Height = 594
        Align = alClient

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'mMIMETYPE')
        ParentFont = False
        TabOrder = 0
      end
    end
    object tsMETA_XML: TTabSheet
      Caption = 'tsMETA_XML'
      ImageIndex = 8
      object mMETA_XML: TMemo
        Left = 0
        Top = 0
        Width = 1126
        Height = 594
        Align = alClient

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'mMETA_XML')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tsSETTINGS_XML: TTabSheet
      Caption = 'tsSETTINGS_XML'
      ImageIndex = 9
      object mSETTINGS_XML: TMemo
        Left = 0
        Top = 0
        Width = 1126
        Height = 594
        Align = alClient

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'mSETTINGS_XML')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object tsMETA_INF_manifest_xml: TTabSheet
      Caption = 'tsMETA_INF_manifest_xml'
      ImageIndex = 10
      object mMETA_INF_manifest_xml: TMemo
        Left = 0
        Top = 0
        Width = 1126
        Height = 594
        Align = alClient

        Font.Color = clWindowText
        Font.Height = -11
        Font.Name = 'Courier New'
        Font.Style = []
        Lines.Strings = (
          'mMETA_INF_manifest_xml')
        ParentFont = False
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
  end
  object odODF: TOpenDialog
    DefaultExt = 'ott'
    Filter = 'mod'#232'le devis|DEV*.ott|texte odt|*.odt|mod'#232'le texte ott|*.ott'
    FilterIndex = 3
    InitialDir = '\\linuxm\a\modeles_oo'
    Left = 40
    Top = 16
  end
  object sd: TSaveDialog
    DefaultExt = 'txt'
    Left = 324
    Top = 491
  end
  object od: TOpenDialog
    DefaultExt = 'TXT'
    Left = 385
    Top = 491
  end
  object tShow: TTimer
    Enabled = False
    OnTimer = tShowTimer
    Left = 108
    Top = 136
  end
end
