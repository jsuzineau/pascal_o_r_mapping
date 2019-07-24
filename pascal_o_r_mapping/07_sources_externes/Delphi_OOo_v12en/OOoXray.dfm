object xrayForm1: TxrayForm1
  Left = 279
  Top = 126
  Width = 700
  Height = 483
  BorderIcons = [biSystemMenu, biMinimize]
  Caption = 'Xray / Delphi      Contents of an object'
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
  object PageControl1: TPageControl
    Left = 0
    Top = 73
    Width = 692
    Height = 376
    ActivePage = TabSheet1
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'MS Sans Serif'
    Font.Pitch = fpFixed
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'Properties'
      object propGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 684
        Height = 348
        Align = alClient
        ColCount = 4
        DefaultRowHeight = 20
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        OnContextPopup = propGridContextPopup
        OnDblClick = propGridDblClick
        ColWidths = (
          156
          220
          194
          512)
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Methods'
      ImageIndex = 1
      object methGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 602
        Height = 355
        Align = alClient
        ColCount = 4
        DefaultRowHeight = 20
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColSizing, goRowSelect]
        TabOrder = 0
        OnContextPopup = methGridContextPopup
        OnDblClick = methGridDblClick
        ColWidths = (
          168
          324
          228
          261)
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Services'
      ImageIndex = 2
      object serviceGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 602
        Height = 355
        Align = alClient
        ColCount = 2
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected, goColSizing]
        TabOrder = 0
        ColWidths = (
          267
          295)
      end
    end
    object TabSheet4: TTabSheet
      Caption = 'Interfaces'
      ImageIndex = 4
      object interfaceGrid: TStringGrid
        Left = 0
        Top = 0
        Width = 602
        Height = 355
        Align = alClient
        ColCount = 1
        FixedCols = 0
        RowCount = 2
        Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goDrawFocusSelected]
        TabOrder = 0
        ColWidths = (
          564)
      end
    end
    object TabSheet5: TTabSheet
      Caption = 'Help'
      ImageIndex = 3
      object Memo1: TMemo
        Left = 0
        Top = 0
        Width = 684
        Height = 348
        Align = alClient
        Lines.Strings = (
          ''
          
            #9'Xray / Delphi   version 1.2    _______   Copyright (c) 2004-200' +
            '7 : Bernard Marcelly '
          ''
          'Warning : the tab sheets display much information !'
          '- adjust window dimensions'
          '- use scrollbars'
          '- change column width with the mouse'
          ''
          ''
          #9'Properties tab'
          ''
          
            'To deepen analysis, double-click on the line of a property or cl' +
            'ick Xray button after selecting the line.'
          
            'If a property is a string displayed as < - - - - > deepen analys' +
            'is to display the full text.'
          ''
          
            'Click API doc button to display the SDK documentation on the sel' +
            'ected property.'
          ''
          
            'Right-click in the page to display properties in alphabetical or' +
            'der or original order.'
          ''
          ''
          #9'Methods tab'
          ''
          
            'To deepen analysis, double-click on the line of a method or clic' +
            'k Xray button after selecting the line.'
          
            'This is only possible if the method has no argument and returns ' +
            'something.'
          ''
          
            'Click doc API button to display the SDK documentation on the sel' +
            'ected method.'
          ''
          
            'Right-click in the page to display methods in alphabetical order' +
            ' or original order.'
          ''
          ''
          #9'Services tab'
          ''
          
            'To display the documentation on a service select the cell then c' +
            'lick API doc button.'
          ''
          ''
          #9'Interfaces tab'
          ''
          
            'To display the documentation on an interface select the cell the' +
            'n click API doc button.'
          ''
          ''
          #9'Save button'
          ''
          
            'This button creates a Calc file containing all the object inform' +
            'ation, one Calc sheet per tab.'
          ''
          ''
          #9'Displaying an array'
          ''
          
            'To deepen analysis, double-click on a line or click Xray button ' +
            'after selecting an element.'
          '')
        ReadOnly = True
        ScrollBars = ssVertical
        TabOrder = 0
      end
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 692
    Height = 73
    Align = alTop
    TabOrder = 1
    object Label1: TLabel
      Left = 0
      Top = 8
      Width = 49
      Height = 26
      Alignment = taRightJustify
      Caption = 'Displayed object'
      WordWrap = True
    end
    object Label2: TLabel
      Left = 13
      Top = 44
      Width = 28
      Height = 13
      Alignment = taRightJustify
      Caption = 'Name'
    end
    object ExitBtn: TBitBtn
      Left = 544
      Top = 8
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
    object ImplementName: TEdit
      Left = 56
      Top = 40
      Width = 329
      Height = 21
      TabStop = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'MS Sans Serif'
      Font.Style = []
      ParentFont = False
      ReadOnly = True
      TabOrder = 5
    end
    object searchAPIBtn: TBitBtn
      Left = 416
      Top = 40
      Width = 81
      Height = 25
      Hint = 'Display the SDK page on the current element'
      Caption = '&API doc'
      TabOrder = 2
      OnClick = searchAPIBtnClick
      Glyph.Data = {
        06020000424D0602000000000000760000002800000028000000140000000100
        0400000000009001000000000000000000001000000000000000000000000000
        8000008000000080800080000000800080008080000080808000C0C0C0000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00333333333333
        3333333333FFFFFFFFFFF333333330444444444033333333377777777777F333
        333330066606660033333333377FFF7FFF77F333333330F00000006033333333
        37F777777737F3333333308FE60FFE703333333337F3337F3337F333333330F8
        860F88603333333337F3337F3337F3333333308FE60FFE703333333337F3337F
        3337F333333330F8860F88603333333337F3337F33F7F3333333340FE60FFE04
        33333333377FFF7FFF77333FFF33333000300033330003333337773777333377
        7F33333333333333330E0333333333333333337F7F3333333333333333000333
        33333333333333777F33333333333333330E0333333333333333337F7F333333
        33333333330E00333333333333333F7377F33333333333330000E00333333333
        33337777377F3333333333330E000E033333333333337F77737F333333333333
        0E000E033333333333337F777F7F33333333333300EEE00333333333333377FF
        F773333333333333300000333333333333333777773333333333333333333333
        33333333333333333333}
      NumGlyphs = 2
    end
    object SaveBtn: TBitBtn
      Left = 416
      Top = 8
      Width = 81
      Height = 25
      Hint = 'Create a Calc file filled with object information'
      Caption = '&Save'
      TabOrder = 3
      OnClick = SaveBtnClick
      Glyph.Data = {
        76010000424D7601000000000000760000002800000020000000100000000100
        04000000000000010000120B0000120B00001000000000000000000000000000
        800000800000008080008000000080008000808000007F7F7F00BFBFBF000000
        FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF00555555555555
        5555555FFFFFFFFFF5555550000000000555557777777777F5555550FFFFFFFF
        0555557F5FFFF557F5555550F0000FFF0555557F77775557F5555550FFFFFFFF
        0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
        0555557F5FFFFFF7F5555550F000000F0555557F77777757F5555550FFFFFFFF
        0555557F5FFF5557F5555550F000FFFF0555557F77755FF7F5555550FFFFF000
        0555557F5FF5777755555550F00FF0F05555557F77557F7555555550FFFFF005
        5555557FFFFF7755555555500000005555555577777775555555555555555555
        5555555555555555555555555555555555555555555555555555}
      NumGlyphs = 2
    end
    object XrayBtn: TBitBtn
      Left = 544
      Top = 40
      Width = 81
      Height = 25
      Hint = 'Analyze the current element'
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
    object ObjectPath: TEdit
      Left = 56
      Top = 8
      Width = 329
      Height = 21
      TabStop = False
      ReadOnly = True
      TabOrder = 4
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'ods'
    Filter = 'Calc files|*.ods|All files|*'
    Options = [ofOverwritePrompt, ofHideReadOnly, ofEnableSizing]
    Title = 'Backup file'
    Left = 512
    Top = 8
  end
end
