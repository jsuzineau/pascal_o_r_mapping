object fcb: Tfcb
  Left = 191
  Top = 107
  BorderStyle = bsNone
  Caption = 'fcb'
  ClientHeight = 273
  ClientWidth = 419
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dbg: TDBGrid
    Left = 0
    Top = 0
    Width = 419
    Height = 273
    Align = alClient
    BorderStyle = bsNone
    Options = [dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = dbgCellClick
    OnKeyDown = dbgKeyDown
    Columns = <
      item
        Expanded = False
        Visible = True
      end>
  end
end
