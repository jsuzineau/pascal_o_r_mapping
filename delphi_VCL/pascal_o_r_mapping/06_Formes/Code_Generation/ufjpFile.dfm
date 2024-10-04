object fjpFile: TfjpFile
  Left = 684
  Top = 168
  Caption = 'fjpFile'
  ClientHeight = 809
  ClientWidth = 713
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 180
    Width = 713
    Height = 10
    Cursor = crVSplit
    Align = alTop
    Color = clLime
    ParentColor = False
  end
  object Splitter4: TSplitter
    Left = 0
    Top = 437
    Width = 713
    Height = 10
    Cursor = crVSplit
    Align = alBottom
    Color = clLime
    ParentColor = False
  end
  object p12: TPanel
    Left = 0
    Top = 0
    Width = 713
    Height = 180
    Align = alTop
    Caption = 'p12'
    TabOrder = 0
    object Splitter2: TSplitter
      Left = 1
      Top = 72
      Width = 711
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Color = clLime
      ParentColor = False
    end
    object p1: TPanel
      Left = 1
      Top = 1
      Width = 711
      Height = 71
      Align = alTop
      Caption = 'p1'
      TabOrder = 1
      object Label4: TLabel
        Left = 1
        Top = 1
        Width = 35
        Height = 15
        Align = alTop
        Caption = '01_key'
        Color = clBtnFace
        ParentColor = False
      end
      inline se01: TSynEdit
        Left = 1
        Top = 16
        Width = 709
        Height = 54
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Pitch = fpFixed
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 0
        UseCodeFolding = False
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.Bands = <
          item
            Kind = gbkMarks
            Width = 13
          end
          item
            Kind = gbkLineNumbers
          end
          item
            Kind = gbkFold
          end
          item
            Kind = gbkTrackChanges
          end
          item
            Kind = gbkMargin
            Width = 3
          end>
        Highlighter = shlXML
        Lines.Strings = (
          'se01')
        SelectedColor.Alpha = 0.400000005960464500
        OnStatusChange = seStatusChange
        RemovedKeystrokes = <
          item
            Command = ecDeleteBOL
            ShortCut = 8200
          end
          item
            Command = ecLineBreak
            ShortCut = 8205
          end
          item
            Command = ecContextHelp
            ShortCut = 112
          end
          item
            Command = ecLowerCase
            ShortCut = 16459
            ShortCut2 = 16460
          end
          item
            Command = ecUpperCase
            ShortCut = 16459
            ShortCut2 = 16469
          end
          item
            Command = ecTitleCase
            ShortCut = 16459
            ShortCut2 = 16468
          end
          item
            Command = ecCopyLineUp
            ShortCut = 40998
          end
          item
            Command = ecCopyLineDown
            ShortCut = 41000
          end
          item
            Command = ecMoveLineUp
            ShortCut = 32806
          end
          item
            Command = ecMoveLineDown
            ShortCut = 32808
          end
          item
            Command = ecFoldAll
            ShortCut = 24765
          end
          item
            Command = ecUnfoldAll
            ShortCut = 24763
          end
          item
            Command = ecFoldNearest
            ShortCut = 16575
          end
          item
            Command = ecUnfoldNearest
            ShortCut = 24767
          end
          item
            Command = ecFoldLevel1
            ShortCut = 16459
            ShortCut2 = 16433
          end
          item
            Command = ecFoldLevel2
            ShortCut = 16459
            ShortCut2 = 16434
          end
          item
            Command = ecFoldLevel3
            ShortCut = 16459
            ShortCut2 = 16435
          end
          item
            Command = ecUnfoldLevel1
            ShortCut = 24651
            ShortCut2 = 24625
          end
          item
            Command = ecUnfoldLevel2
            ShortCut = 24651
            ShortCut2 = 24626
          end
          item
            Command = ecUnfoldLevel3
            ShortCut = 24651
            ShortCut2 = 24627
          end>
        AddedKeystrokes = <
          item
            Command = ecDeleteLastChar
            ShortCut = 8200
          end
          item
            Command = ecFoldLevel1
            ShortCut = 41009
          end
          item
            Command = ecFoldLevel2
            ShortCut = 41010
          end
          item
            Command = ecFoldLevel3
            ShortCut = 41011
          end
          item
            Command = ecNone
            ShortCut = 41012
          end
          item
            Command = ecNone
            ShortCut = 41013
          end
          item
            Command = ecNone
            ShortCut = 41014
          end
          item
            Command = ecNone
            ShortCut = 41015
          end
          item
            Command = ecNone
            ShortCut = 41016
          end
          item
            Command = ecNone
            ShortCut = 41017
          end
          item
            Command = ecNone
            ShortCut = 41008
          end
          item
            Command = ecNone
            ShortCut = 41005
          end
          item
            Command = ecNone
            ShortCut = 41003
          end
          item
            Command = ecNone
            ShortCut = 32845
          end
          item
            Command = ecNone
            ShortCut = 40998
          end
          item
            Command = ecNone
            ShortCut = 41000
          end
          item
            Command = ecNone
            ShortCut = 40997
          end
          item
            Command = ecNone
            ShortCut = 40999
          end
          item
            Command = ecNone
            ShortCut = 40994
          end
          item
            Command = ecNone
            ShortCut = 57378
          end
          item
            Command = ecNone
            ShortCut = 40993
          end
          item
            Command = ecNone
            ShortCut = 57377
          end
          item
            Command = ecNone
            ShortCut = 40996
          end
          item
            Command = ecNone
            ShortCut = 40995
          end
          item
            Command = ecNone
            ShortCut = 57380
          end
          item
            Command = ecNone
            ShortCut = 57379
          end>
      end
    end
    object p2: TPanel
      Left = 1
      Top = 77
      Width = 711
      Height = 102
      Align = alClient
      Caption = 'p2'
      TabOrder = 0
      object Label5: TLabel
        Left = 1
        Top = 1
        Width = 47
        Height = 15
        Align = alTop
        Caption = '02_begin'
        Color = clBtnFace
        ParentColor = False
      end
      inline se02: TSynEdit
        Left = 1
        Top = 16
        Width = 709
        Height = 85
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Pitch = fpFixed
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 0
        UseCodeFolding = False
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.Bands = <
          item
            Kind = gbkMarks
            Width = 13
          end
          item
            Kind = gbkLineNumbers
          end
          item
            Kind = gbkFold
          end
          item
            Kind = gbkTrackChanges
          end
          item
            Kind = gbkMargin
            Width = 3
          end>
        Highlighter = shlXML
        Lines.Strings = (
          'se02')
        SelectedColor.Alpha = 0.400000005960464500
        OnStatusChange = seStatusChange
        RemovedKeystrokes = <
          item
            Command = ecDeleteBOL
            ShortCut = 8200
          end
          item
            Command = ecLineBreak
            ShortCut = 8205
          end
          item
            Command = ecContextHelp
            ShortCut = 112
          end
          item
            Command = ecLowerCase
            ShortCut = 16459
            ShortCut2 = 16460
          end
          item
            Command = ecUpperCase
            ShortCut = 16459
            ShortCut2 = 16469
          end
          item
            Command = ecTitleCase
            ShortCut = 16459
            ShortCut2 = 16468
          end
          item
            Command = ecCopyLineUp
            ShortCut = 40998
          end
          item
            Command = ecCopyLineDown
            ShortCut = 41000
          end
          item
            Command = ecMoveLineUp
            ShortCut = 32806
          end
          item
            Command = ecMoveLineDown
            ShortCut = 32808
          end
          item
            Command = ecFoldAll
            ShortCut = 24765
          end
          item
            Command = ecUnfoldAll
            ShortCut = 24763
          end
          item
            Command = ecFoldNearest
            ShortCut = 16575
          end
          item
            Command = ecUnfoldNearest
            ShortCut = 24767
          end
          item
            Command = ecFoldLevel1
            ShortCut = 16459
            ShortCut2 = 16433
          end
          item
            Command = ecFoldLevel2
            ShortCut = 16459
            ShortCut2 = 16434
          end
          item
            Command = ecFoldLevel3
            ShortCut = 16459
            ShortCut2 = 16435
          end
          item
            Command = ecUnfoldLevel1
            ShortCut = 24651
            ShortCut2 = 24625
          end
          item
            Command = ecUnfoldLevel2
            ShortCut = 24651
            ShortCut2 = 24626
          end
          item
            Command = ecUnfoldLevel3
            ShortCut = 24651
            ShortCut2 = 24627
          end>
        AddedKeystrokes = <
          item
            Command = ecDeleteLastChar
            ShortCut = 8200
          end
          item
            Command = ecFoldLevel1
            ShortCut = 41009
          end
          item
            Command = ecFoldLevel2
            ShortCut = 41010
          end
          item
            Command = ecFoldLevel3
            ShortCut = 41011
          end
          item
            Command = ecNone
            ShortCut = 41012
          end
          item
            Command = ecNone
            ShortCut = 41013
          end
          item
            Command = ecNone
            ShortCut = 41014
          end
          item
            Command = ecNone
            ShortCut = 41015
          end
          item
            Command = ecNone
            ShortCut = 41016
          end
          item
            Command = ecNone
            ShortCut = 41017
          end
          item
            Command = ecNone
            ShortCut = 41008
          end
          item
            Command = ecNone
            ShortCut = 41005
          end
          item
            Command = ecNone
            ShortCut = 41003
          end
          item
            Command = ecNone
            ShortCut = 32845
          end
          item
            Command = ecNone
            ShortCut = 40998
          end
          item
            Command = ecNone
            ShortCut = 41000
          end
          item
            Command = ecNone
            ShortCut = 40997
          end
          item
            Command = ecNone
            ShortCut = 40999
          end
          item
            Command = ecNone
            ShortCut = 40994
          end
          item
            Command = ecNone
            ShortCut = 57378
          end
          item
            Command = ecNone
            ShortCut = 40993
          end
          item
            Command = ecNone
            ShortCut = 57377
          end
          item
            Command = ecNone
            ShortCut = 40996
          end
          item
            Command = ecNone
            ShortCut = 40995
          end
          item
            Command = ecNone
            ShortCut = 57380
          end
          item
            Command = ecNone
            ShortCut = 57379
          end>
      end
    end
  end
  object p45: TPanel
    Left = 0
    Top = 447
    Width = 713
    Height = 362
    Align = alBottom
    Caption = 'p45'
    TabOrder = 1
    object Splitter3: TSplitter
      Left = 1
      Top = 72
      Width = 711
      Height = 5
      Cursor = crVSplit
      Align = alTop
      Color = clLime
      ParentColor = False
    end
    object p4: TPanel
      Left = 1
      Top = 1
      Width = 711
      Height = 71
      Align = alTop
      Caption = 'p4'
      TabOrder = 0
      object Label2: TLabel
        Left = 1
        Top = 1
        Width = 72
        Height = 15
        Align = alTop
        Caption = '04_separateur'
        Color = clBtnFace
        ParentColor = False
      end
      inline se04: TSynEdit
        Left = 1
        Top = 16
        Width = 709
        Height = 54
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Pitch = fpFixed
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 0
        UseCodeFolding = False
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.Bands = <
          item
            Kind = gbkMarks
            Width = 13
          end
          item
            Kind = gbkLineNumbers
          end
          item
            Kind = gbkFold
          end
          item
            Kind = gbkTrackChanges
          end
          item
            Kind = gbkMargin
            Width = 3
          end>
        Highlighter = shlXML
        Lines.Strings = (
          'se04')
        SelectedColor.Alpha = 0.400000005960464500
        OnStatusChange = seStatusChange
        RemovedKeystrokes = <
          item
            Command = ecDeleteBOL
            ShortCut = 8200
          end
          item
            Command = ecLineBreak
            ShortCut = 8205
          end
          item
            Command = ecContextHelp
            ShortCut = 112
          end
          item
            Command = ecLowerCase
            ShortCut = 16459
            ShortCut2 = 16460
          end
          item
            Command = ecUpperCase
            ShortCut = 16459
            ShortCut2 = 16469
          end
          item
            Command = ecTitleCase
            ShortCut = 16459
            ShortCut2 = 16468
          end
          item
            Command = ecCopyLineUp
            ShortCut = 40998
          end
          item
            Command = ecCopyLineDown
            ShortCut = 41000
          end
          item
            Command = ecMoveLineUp
            ShortCut = 32806
          end
          item
            Command = ecMoveLineDown
            ShortCut = 32808
          end
          item
            Command = ecFoldAll
            ShortCut = 24765
          end
          item
            Command = ecUnfoldAll
            ShortCut = 24763
          end
          item
            Command = ecFoldNearest
            ShortCut = 16575
          end
          item
            Command = ecUnfoldNearest
            ShortCut = 24767
          end
          item
            Command = ecFoldLevel1
            ShortCut = 16459
            ShortCut2 = 16433
          end
          item
            Command = ecFoldLevel2
            ShortCut = 16459
            ShortCut2 = 16434
          end
          item
            Command = ecFoldLevel3
            ShortCut = 16459
            ShortCut2 = 16435
          end
          item
            Command = ecUnfoldLevel1
            ShortCut = 24651
            ShortCut2 = 24625
          end
          item
            Command = ecUnfoldLevel2
            ShortCut = 24651
            ShortCut2 = 24626
          end
          item
            Command = ecUnfoldLevel3
            ShortCut = 24651
            ShortCut2 = 24627
          end>
        AddedKeystrokes = <
          item
            Command = ecDeleteLastChar
            ShortCut = 8200
          end
          item
            Command = ecFoldLevel1
            ShortCut = 41009
          end
          item
            Command = ecFoldLevel2
            ShortCut = 41010
          end
          item
            Command = ecFoldLevel3
            ShortCut = 41011
          end
          item
            Command = ecNone
            ShortCut = 41012
          end
          item
            Command = ecNone
            ShortCut = 41013
          end
          item
            Command = ecNone
            ShortCut = 41014
          end
          item
            Command = ecNone
            ShortCut = 41015
          end
          item
            Command = ecNone
            ShortCut = 41016
          end
          item
            Command = ecNone
            ShortCut = 41017
          end
          item
            Command = ecNone
            ShortCut = 41008
          end
          item
            Command = ecNone
            ShortCut = 41005
          end
          item
            Command = ecNone
            ShortCut = 41003
          end
          item
            Command = ecNone
            ShortCut = 32845
          end
          item
            Command = ecNone
            ShortCut = 40998
          end
          item
            Command = ecNone
            ShortCut = 41000
          end
          item
            Command = ecNone
            ShortCut = 40997
          end
          item
            Command = ecNone
            ShortCut = 40999
          end
          item
            Command = ecNone
            ShortCut = 40994
          end
          item
            Command = ecNone
            ShortCut = 57378
          end
          item
            Command = ecNone
            ShortCut = 40993
          end
          item
            Command = ecNone
            ShortCut = 57377
          end
          item
            Command = ecNone
            ShortCut = 40996
          end
          item
            Command = ecNone
            ShortCut = 40995
          end
          item
            Command = ecNone
            ShortCut = 57380
          end
          item
            Command = ecNone
            ShortCut = 57379
          end>
      end
    end
    object p5: TPanel
      Left = 1
      Top = 77
      Width = 711
      Height = 234
      Align = alClient
      Caption = 'p5'
      TabOrder = 2
      object Label3: TLabel
        Left = 1
        Top = 1
        Width = 37
        Height = 15
        Align = alTop
        Caption = '05_end'
        Color = clBtnFace
        ParentColor = False
      end
      inline se05: TSynEdit
        Left = 1
        Top = 16
        Width = 709
        Height = 217
        Align = alClient
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -13
        Font.Name = 'Courier New'
        Font.Pitch = fpFixed
        Font.Style = []
        Font.Quality = fqClearTypeNatural
        TabOrder = 0
        UseCodeFolding = False
        Gutter.Font.Charset = DEFAULT_CHARSET
        Gutter.Font.Color = clWindowText
        Gutter.Font.Height = -11
        Gutter.Font.Name = 'Consolas'
        Gutter.Font.Style = []
        Gutter.Bands = <
          item
            Kind = gbkMarks
            Width = 13
          end
          item
            Kind = gbkLineNumbers
          end
          item
            Kind = gbkFold
          end
          item
            Kind = gbkTrackChanges
          end
          item
            Kind = gbkMargin
            Width = 3
          end>
        Highlighter = shlXML
        Lines.Strings = (
          'se05')
        SelectedColor.Alpha = 0.400000005960464500
        OnStatusChange = seStatusChange
        RemovedKeystrokes = <
          item
            Command = ecDeleteBOL
            ShortCut = 8200
          end
          item
            Command = ecLineBreak
            ShortCut = 8205
          end
          item
            Command = ecContextHelp
            ShortCut = 112
          end
          item
            Command = ecLowerCase
            ShortCut = 16459
            ShortCut2 = 16460
          end
          item
            Command = ecUpperCase
            ShortCut = 16459
            ShortCut2 = 16469
          end
          item
            Command = ecTitleCase
            ShortCut = 16459
            ShortCut2 = 16468
          end
          item
            Command = ecCopyLineUp
            ShortCut = 40998
          end
          item
            Command = ecCopyLineDown
            ShortCut = 41000
          end
          item
            Command = ecMoveLineUp
            ShortCut = 32806
          end
          item
            Command = ecMoveLineDown
            ShortCut = 32808
          end
          item
            Command = ecFoldAll
            ShortCut = 24765
          end
          item
            Command = ecUnfoldAll
            ShortCut = 24763
          end
          item
            Command = ecFoldNearest
            ShortCut = 16575
          end
          item
            Command = ecUnfoldNearest
            ShortCut = 24767
          end
          item
            Command = ecFoldLevel1
            ShortCut = 16459
            ShortCut2 = 16433
          end
          item
            Command = ecFoldLevel2
            ShortCut = 16459
            ShortCut2 = 16434
          end
          item
            Command = ecFoldLevel3
            ShortCut = 16459
            ShortCut2 = 16435
          end
          item
            Command = ecUnfoldLevel1
            ShortCut = 24651
            ShortCut2 = 24625
          end
          item
            Command = ecUnfoldLevel2
            ShortCut = 24651
            ShortCut2 = 24626
          end
          item
            Command = ecUnfoldLevel3
            ShortCut = 24651
            ShortCut2 = 24627
          end>
        AddedKeystrokes = <
          item
            Command = ecDeleteLastChar
            ShortCut = 8200
          end
          item
            Command = ecFoldLevel1
            ShortCut = 41009
          end
          item
            Command = ecFoldLevel2
            ShortCut = 41010
          end
          item
            Command = ecFoldLevel3
            ShortCut = 41011
          end
          item
            Command = ecNone
            ShortCut = 41012
          end
          item
            Command = ecNone
            ShortCut = 41013
          end
          item
            Command = ecNone
            ShortCut = 41014
          end
          item
            Command = ecNone
            ShortCut = 41015
          end
          item
            Command = ecNone
            ShortCut = 41016
          end
          item
            Command = ecNone
            ShortCut = 41017
          end
          item
            Command = ecNone
            ShortCut = 41008
          end
          item
            Command = ecNone
            ShortCut = 41005
          end
          item
            Command = ecNone
            ShortCut = 41003
          end
          item
            Command = ecNone
            ShortCut = 32845
          end
          item
            Command = ecNone
            ShortCut = 40998
          end
          item
            Command = ecNone
            ShortCut = 41000
          end
          item
            Command = ecNone
            ShortCut = 40997
          end
          item
            Command = ecNone
            ShortCut = 40999
          end
          item
            Command = ecNone
            ShortCut = 40994
          end
          item
            Command = ecNone
            ShortCut = 57378
          end
          item
            Command = ecNone
            ShortCut = 40993
          end
          item
            Command = ecNone
            ShortCut = 57377
          end
          item
            Command = ecNone
            ShortCut = 40996
          end
          item
            Command = ecNone
            ShortCut = 40995
          end
          item
            Command = ecNone
            ShortCut = 57380
          end
          item
            Command = ecNone
            ShortCut = 57379
          end>
      end
    end
    object Panel1: TPanel
      Left = 1
      Top = 311
      Width = 711
      Height = 50
      Align = alBottom
      TabOrder = 1
      DesignSize = (
        711
        50)
      object bSauver: TButton
        Left = 614
        Top = 8
        Width = 75
        Height = 25
        Action = aSauver
        Anchors = [akTop, akRight]
        TabOrder = 0
      end
    end
  end
  object p3: TPanel
    Left = 0
    Top = 190
    Width = 713
    Height = 247
    Align = alClient
    Caption = 'p3'
    TabOrder = 2
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 60
      Height = 15
      Align = alTop
      Caption = '03_element'
      Color = clBtnFace
      ParentColor = False
    end
    inline se03: TSynEdit
      Left = 1
      Top = 16
      Width = 711
      Height = 230
      Align = alClient
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Courier New'
      Font.Pitch = fpFixed
      Font.Style = []
      Font.Quality = fqClearTypeNatural
      TabOrder = 0
      UseCodeFolding = False
      Gutter.Font.Charset = DEFAULT_CHARSET
      Gutter.Font.Color = clWindowText
      Gutter.Font.Height = -11
      Gutter.Font.Name = 'Consolas'
      Gutter.Font.Style = []
      Gutter.Bands = <
        item
          Kind = gbkMarks
          Width = 13
        end
        item
          Kind = gbkLineNumbers
        end
        item
          Kind = gbkFold
        end
        item
          Kind = gbkTrackChanges
        end
        item
          Kind = gbkMargin
          Width = 3
        end>
      Highlighter = shlXML
      Lines.Strings = (
        'se03')
      SelectedColor.Alpha = 0.400000005960464500
      OnStatusChange = seStatusChange
      RemovedKeystrokes = <
        item
          Command = ecDeleteBOL
          ShortCut = 8200
        end
        item
          Command = ecLineBreak
          ShortCut = 8205
        end
        item
          Command = ecContextHelp
          ShortCut = 112
        end
        item
          Command = ecLowerCase
          ShortCut = 16459
          ShortCut2 = 16460
        end
        item
          Command = ecUpperCase
          ShortCut = 16459
          ShortCut2 = 16469
        end
        item
          Command = ecTitleCase
          ShortCut = 16459
          ShortCut2 = 16468
        end
        item
          Command = ecCopyLineUp
          ShortCut = 40998
        end
        item
          Command = ecCopyLineDown
          ShortCut = 41000
        end
        item
          Command = ecMoveLineUp
          ShortCut = 32806
        end
        item
          Command = ecMoveLineDown
          ShortCut = 32808
        end
        item
          Command = ecFoldAll
          ShortCut = 24765
        end
        item
          Command = ecUnfoldAll
          ShortCut = 24763
        end
        item
          Command = ecFoldNearest
          ShortCut = 16575
        end
        item
          Command = ecUnfoldNearest
          ShortCut = 24767
        end
        item
          Command = ecFoldLevel1
          ShortCut = 16459
          ShortCut2 = 16433
        end
        item
          Command = ecFoldLevel2
          ShortCut = 16459
          ShortCut2 = 16434
        end
        item
          Command = ecFoldLevel3
          ShortCut = 16459
          ShortCut2 = 16435
        end
        item
          Command = ecUnfoldLevel1
          ShortCut = 24651
          ShortCut2 = 24625
        end
        item
          Command = ecUnfoldLevel2
          ShortCut = 24651
          ShortCut2 = 24626
        end
        item
          Command = ecUnfoldLevel3
          ShortCut = 24651
          ShortCut2 = 24627
        end>
      AddedKeystrokes = <
        item
          Command = ecDeleteLastChar
          ShortCut = 8200
        end
        item
          Command = ecFoldLevel1
          ShortCut = 41009
        end
        item
          Command = ecFoldLevel2
          ShortCut = 41010
        end
        item
          Command = ecFoldLevel3
          ShortCut = 41011
        end
        item
          Command = ecNone
          ShortCut = 41012
        end
        item
          Command = ecNone
          ShortCut = 41013
        end
        item
          Command = ecNone
          ShortCut = 41014
        end
        item
          Command = ecNone
          ShortCut = 41015
        end
        item
          Command = ecNone
          ShortCut = 41016
        end
        item
          Command = ecNone
          ShortCut = 41017
        end
        item
          Command = ecNone
          ShortCut = 41008
        end
        item
          Command = ecNone
          ShortCut = 41005
        end
        item
          Command = ecNone
          ShortCut = 41003
        end
        item
          Command = ecNone
          ShortCut = 32845
        end
        item
          Command = ecNone
          ShortCut = 40998
        end
        item
          Command = ecNone
          ShortCut = 41000
        end
        item
          Command = ecNone
          ShortCut = 40997
        end
        item
          Command = ecNone
          ShortCut = 40999
        end
        item
          Command = ecNone
          ShortCut = 40994
        end
        item
          Command = ecNone
          ShortCut = 57378
        end
        item
          Command = ecNone
          ShortCut = 40993
        end
        item
          Command = ecNone
          ShortCut = 57377
        end
        item
          Command = ecNone
          ShortCut = 40996
        end
        item
          Command = ecNone
          ShortCut = 40995
        end
        item
          Command = ecNone
          ShortCut = 57380
        end
        item
          Command = ecNone
          ShortCut = 57379
        end>
    end
  end
  object shlXML: TSynXMLSyn
    DefaultFilter = 
      'Documents XML (*.xml,*.xsd,*.xsl,*.xslt,*.dtd)|*.xml;*.xsd;*.xsl' +
      ';*.xslt;*.dtd'
    Enabled = False
    WantBracesParsed = False
    Left = 128
    Top = 296
  end
  object shlPAS: TSynPasSyn
    Enabled = False
    Left = 75
    Top = 240
  end
  object shlJS: TSynJScriptSyn
    Enabled = False
    Left = 168
    Top = 246
  end
  object al: TActionList
    Left = 507
    Top = 767
    object aSauver: TAction
      Caption = 'Sauver'
      ShortCut = 16467
      OnExecute = aSauverExecute
    end
  end
end
