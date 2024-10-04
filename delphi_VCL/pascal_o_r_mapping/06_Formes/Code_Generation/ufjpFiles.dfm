object fjpFiles: TfjpFiles
  Left = 670
  Top = 221
  Caption = 'fjpFiles'
  ClientHeight = 311
  ClientWidth = 552
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Menu = mm
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object mm: TMainMenu
    Left = 101
    Top = 1
    object miFichier: TMenuItem
      Caption = 'Fichier'
      object miNouveau: TMenuItem
        Caption = 'Nouveau'
        OnClick = miNouveauClick
      end
      object miOuvrir: TMenuItem
        Caption = 'Ouvrir'
        OnClick = miOuvrirClick
      end
    end
    object miFenetres: TMenuItem
      Caption = 'Fen'#195#170'tres'
    end
  end
end
