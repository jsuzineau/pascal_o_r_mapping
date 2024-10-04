object fcbBase: TfcbBase
  Left = 221
  Top = 112
  BorderStyle = bsNone
  Caption = 'fcbBase'
  ClientHeight = 188
  ClientWidth = 225
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object dbg: TDBGrid
    Left = 0
    Top = 20
    Width = 225
    Height = 127
    Align = alClient
    Options = [dgColumnResize, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = dbgCellClick
    OnDblClick = dbgDblClick
    OnKeyDown = dbgKeyDown
    Columns = <
      item
        Expanded = False
        FieldName = 'Code'
        ReadOnly = True
        Visible = True
      end>
  end
  object Panel1: TPanel
    Left = 0
    Top = 147
    Width = 225
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object bCancel: TBitBtn
      Left = 0
      Top = 19
      Width = 225
      Height = 22
      TabOrder = 0
      Kind = bkCancel
    end
    object bNouveau: TBitBtn
      Left = 0
      Top = 0
      Width = 225
      Height = 17
      Caption = '&NOUVEAU  ...'
      ModalResult = 3
      TabOrder = 1
      OnClick = bNouveauClick
      NumGlyphs = 2
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 225
    Height = 20
    Align = alTop
    BevelOuter = bvNone
    Caption = 'Panel2'
    TabOrder = 2
    object eFiltre: TEdit
      Left = 1
      Top = 0
      Width = 224
      Height = 21
      TabOrder = 0
      Text = 'eFiltre'
      OnChange = eFiltreChange
      OnKeyDown = eFiltreKeyDown
    end
  end
end
