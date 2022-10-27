object fPatternMainMenu: TfPatternMainMenu
  Left = 0
  Top = 0
  Width = 320
  Height = 240
  Caption = 'fPatternMainMenu'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object mm: TMainMenu
    Left = 88
    Top = 96
    object miBase: TMenuItem
      Caption = 'Base'
      object miVide: TMenuItem
        Caption = 'Vide'
      end
    end
    object miRelations: TMenuItem
      Caption = 'Relations'
      object miRelationVide: TMenuItem
        Caption = 'Vide'
      end
    end
    object miBaseCalcule: TMenuItem
      Caption = 'Base, calcul'#233
      object miBaseCalculeVide: TMenuItem
        Caption = 'Vide'
      end
    end
    object miRelationsCalcule: TMenuItem
      Caption = 'Relations, Calcul'#233
      object miRelationsCalculeVide: TMenuItem
        Caption = 'Vide'
      end
    end
  end
end
