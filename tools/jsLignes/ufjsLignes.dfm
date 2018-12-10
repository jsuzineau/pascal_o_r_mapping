object fjsLignes: TfjsLignes
  Left = 527
  Height = 480
  Top = 148
  Width = 696
  Caption = 'jsLignes'
  ClientHeight = 480
  ClientWidth = 696
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClose = FormClose
  LCLVersion = '1.8.4.0'
  object Splitter1: TSplitter
    Left = 508
    Height = 415
    Top = 65
    Width = 3
    Align = alRight
    ResizeAnchor = akRight
  end
  object Tree: TTreeView
    Left = 0
    Height = 415
    Top = 65
    Width = 508
    Align = alClient
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Indent = 19
    ParentFont = False
    PopupMenu = PopupMenu1
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Height = 65
    Top = 0
    Width = 696
    Align = alTop
    Caption = 'Panel1'
    ClientHeight = 65
    ClientWidth = 696
    TabOrder = 1
    object Label1: TLabel
      Left = 288
      Height = 14
      Top = 40
      Width = 155
      Caption = 'Nombre de lignes par page'
      ParentColor = False
    end
    object bAnalyser: TButton
      Left = 568
      Height = 25
      Top = 8
      Width = 113
      Caption = 'Analyser le répertoire'
      OnClick = bAnalyserClick
      TabOrder = 0
    end
    object eRootPath: TEdit
      Left = 8
      Height = 24
      Top = 8
      Width = 473
      OnChange = eRootPathChange
      TabOrder = 1
      Text = '/home/jean/01_Projets/14_pascal_o_r_mapping_branch_TjsDataContexte/pascal_o_r_mapping/tools/test_gICAPI/angular-test-gICAPI'
    end
    object bParcourir: TButton
      Left = 488
      Height = 25
      Top = 8
      Width = 75
      Caption = 'Parcourir'
      OnClick = bParcourirClick
      TabOrder = 2
    end
    object bImport_from_du: TButton
      Left = 8
      Height = 25
      Top = 32
      Width = 225
      Caption = 'Importation à partir de la sortie de GNU du'
      OnClick = bImport_from_duClick
      TabOrder = 3
    end
    object speLignes_Page: TSpinEdit
      Left = 424
      Height = 24
      Top = 40
      Width = 81
      MaxValue = 0
      TabOrder = 4
      Value = 150
    end
  end
  object mExclus: TMemo
    Left = 511
    Height = 415
    Top = 65
    Width = 185
    Align = alRight
    TabOrder = 2
  end
  object Open_du_Result: TOpenDialog
    FileName = '\\Darkstar\c\resultat_du.txt'
    Filter = 'du XXX > fichier|*.*'
    left = 240
    top = 32
  end
  object PopupMenu1: TPopupMenu
    left = 400
    top = 48
    object Exclure1: TMenuItem
      Caption = 'Exclure'
      OnClick = Exclure1Click
    end
  end
end
