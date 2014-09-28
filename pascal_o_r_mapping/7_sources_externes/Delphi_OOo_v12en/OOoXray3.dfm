object xrayForm3: TxrayForm3
  Left = 280
  Top = 196
  Width = 603
  Height = 380
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Xray / Delphi      Contents of an array'
  Color = clBtnFace
  Constraints.MinHeight = 24
  Constraints.MinWidth = 160
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDefaultPosOnly
  ShowHint = True
  PixelsPerInch = 96
  TextHeight = 13
  object arrayGrid: TStringGrid
    Left = 0
    Top = 73
    Width = 595
    Height = 280
    Align = alClient
    ColCount = 3
    RowCount = 2
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goColSizing, goRowSelect]
    TabOrder = 0
    OnDblClick = arrayGridDblClick
    ColWidths = (
      46
      273
      540)
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 595
    Height = 73
    Align = alTop
    TabOrder = 1
    object Label2: TLabel
      Left = 0
      Top = 8
      Width = 49
      Height = 26
      Alignment = taRightJustify
      Caption = 'Displayed object'
      WordWrap = True
    end
    object Label3: TLabel
      Left = 12
      Top = 42
      Width = 45
      Height = 13
      Alignment = taRightJustify
      Caption = 'Index min'
    end
    object Label4: TLabel
      Left = 121
      Top = 42
      Width = 48
      Height = 13
      Alignment = taRightJustify
      Caption = 'Index max'
    end
    object ExitBtn: TBitBtn
      Left = 440
      Top = 40
      Width = 81
      Height = 25
      Caption = '&Close'
      Default = True
      ModalResult = 1
      TabOrder = 0
      Glyph.Data = {
        DE010000424DDE01000000000000760000002800000024000000120000000100
        0400000000006801000000000000000000001000000000000000000000000000
        80000080000000808000800000008000800080800000C0C0C000808080000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00388888888877
        F7F787F8888888888333333F00004444400888FFF444448888888888F333FF8F
        000033334D5007FFF4333388888888883338888F0000333345D50FFFF4333333
        338F888F3338F33F000033334D5D0FFFF43333333388788F3338F33F00003333
        45D50FEFE4333333338F878F3338F33F000033334D5D0FFFF43333333388788F
        3338F33F0000333345D50FEFE4333333338F878F3338F33F000033334D5D0FFF
        F43333333388788F3338F33F0000333345D50FEFE4333333338F878F3338F33F
        000033334D5D0EFEF43333333388788F3338F33F0000333345D50FEFE4333333
        338F878F3338F33F000033334D5D0EFEF43333333388788F3338F33F00003333
        4444444444333333338F8F8FFFF8F33F00003333333333333333333333888888
        8888333F00003333330000003333333333333FFFFFF3333F00003333330AAAA0
        333333333333888888F3333F00003333330000003333333333338FFFF8F3333F
        0000}
      NumGlyphs = 2
    end
    object XrayBtn: TBitBtn
      Left = 296
      Top = 40
      Width = 81
      Height = 25
      Hint = 'Analyze current element'
      Caption = '&Xray'
      TabOrder = 1
      OnClick = XrayBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000130B0000130B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        33033333333333333F7F3333333333333000333333333333F777333333333333
        000333333333333F777333333333333000333333333333F77733333333333300
        033333333FFF3F777333333700073B703333333F7773F77733333307777700B3
        33333377333777733333307F8F8F7033333337F333F337F3333377F8F9F8F773
        3333373337F3373F3333078F898F870333337F33F7FFF37F333307F99999F703
        33337F377777337F3333078F898F8703333373F337F33373333377F8F9F8F773
        333337F3373337F33333307F8F8F70333333373FF333F7333333330777770333
        333333773FF77333333333370007333333333333777333333333}
      NumGlyphs = 2
    end
    object ObjPath: TEdit
      Left = 56
      Top = 8
      Width = 361
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 2
    end
    object indexMin: TEdit
      Left = 64
      Top = 40
      Width = 41
      Height = 21
      ReadOnly = True
      TabOrder = 3
    end
    object indexmax: TEdit
      Left = 176
      Top = 40
      Width = 41
      Height = 21
      ReadOnly = True
      TabOrder = 4
    end
  end
end
