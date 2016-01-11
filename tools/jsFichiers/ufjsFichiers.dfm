object fjsFichiers: TfjsFichiers
  Left = 567
  Height = 480
  Top = 933
  Width = 644
  Caption = 'jsFichiers'
  ClientHeight = 480
  ClientWidth = 644
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  LCLVersion = '1.4.0.4'
  object Tree: TTreeView
    Left = 0
    Height = 415
    Top = 65
    Width = 644
    Align = alClient
    DefaultItemHeight = 16
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Indent = 19
    ParentFont = False
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Height = 65
    Top = 0
    Width = 644
    Align = alTop
    ClientHeight = 65
    ClientWidth = 644
    TabOrder = 1
    object bAnalyser: TButton
      Left = 491
      Height = 25
      Top = 8
      Width = 145
      Anchors = [akTop, akRight]
      Caption = 'Analyser le répertoire'
      OnClick = bAnalyserClick
      TabOrder = 0
    end
    object eRootPath: TEdit
      Left = 8
      Height = 24
      Top = 8
      Width = 396
      Anchors = [akTop, akLeft, akRight]
      TabOrder = 1
      Text = 'C:\'
    end
    object bParcourir: TButton
      Left = 411
      Height = 25
      Top = 8
      Width = 75
      Anchors = [akTop, akRight]
      Caption = 'Parcourir'
      OnClick = bParcourirClick
      TabOrder = 2
    end
    object bImport_from_du: TButton
      Left = 8
      Height = 25
      Top = 32
      Width = 312
      Caption = 'Importation à partir de la sortie de GNU du'
      OnClick = bImport_from_duClick
      TabOrder = 3
    end
  end
  object Open_du_Result: TOpenDialog
    FileName = '\\Darkstar\c\resultat_du.txt'
    Filter = 'du XXX > fichier|*.*'
    left = 288
    top = 48
  end
end
