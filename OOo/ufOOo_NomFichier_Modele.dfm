inherited fOOo_NomFichier_Modele: TfOOo_NomFichier_Modele
  Left = 267
  Top = 103
  Width = 503
  Height = 189
  Caption = 'Cr'#233'ation de mod'#232'le'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 129
    Width = 495
    Height = 4
  end
  object Label1: TLabel [1]
    Left = 0
    Top = 16
    Width = 490
    Height = 14
    AutoSize = False
    Caption = 'Aucun fichier n'#39'a '#233't'#233' trouv'#233' correspondant au masque suivant:'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object lMasque: TLabel [2]
    Left = 0
    Top = 29
    Width = 490
    Height = 14
    AutoSize = False
    Caption = 'lMasque'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label2: TLabel [3]
    Left = 0
    Top = 40
    Width = 490
    Height = 14
    AutoSize = False
    Caption = 'Un nouveau mod'#232'le va '#234'tre cr'#233#233'.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  object Label3: TLabel [4]
    Left = 0
    Top = 52
    Width = 490
    Height = 14
    AutoSize = False
    Caption = 
      'Vous pouvez saisir ci-dessous un suffixe (facultatif) vous perme' +
      'ttant d'#39'identifier le mod'#232'le.'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Arial'
    Font.Style = []
    ParentFont = False
  end
  inherited pSociete: TPanel
    Width = 495
    inherited lSociete: TLabel
      Width = 423
    end
    inherited lHeure: TLabel
      Left = 423
    end
    inherited animation: TAnimate
      Left = 479
    end
  end
  inherited pBas: TPanel
    Top = 88
    Width = 495
    inherited pFermer: TPanel
      Left = 262
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 136
    Width = 495
  end
  inherited pLog: TPanel
    Top = 133
    Width = 495
    Height = 3
    inherited lLog: TLabel
      Width = 493
    end
    inherited mLog: TMemo
      Width = 493
      Height = 0
    end
  end
  object eSuffixe: TEdit [9]
    Left = 0
    Top = 72
    Width = 489
    Height = 21
    TabOrder = 4
    Text = 'eSuffixe'
  end
  inherited al: TActionList
    Left = 264
    Top = 65520
  end
end
