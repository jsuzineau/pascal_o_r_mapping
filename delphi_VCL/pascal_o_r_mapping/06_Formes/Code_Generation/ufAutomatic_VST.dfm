object fAutomatic_VST: TfAutomatic_VST
  Left = 812
  Top = 226
  Caption = 'fAutomatic_VST'
  ClientHeight = 413
  ClientWidth = 691
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 691
    Height = 106
    Align = alTop
    TabOrder = 0
    DesignSize = (
      691
      106)
    object bExecute: TButton
      Left = 8
      Top = 40
      Width = 75
      Height = 25
      Caption = 'Execute'
      Default = True
      TabOrder = 0
      OnClick = bExecuteClick
    end
    object e: TEdit
      Left = 88
      Top = 40
      Width = 519
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 1
    end
    object bGenere: TButton
      Left = 11
      Top = 72
      Width = 75
      Height = 25
      Caption = 'G'#195#169'n'#195#168're'
      TabOrder = 2
      OnClick = bGenereClick
    end
    object bGenere_Tout: TButton
      Left = 101
      Top = 72
      Width = 147
      Height = 25
      Caption = 'G'#195#169'n'#195#168're Tout'
      TabOrder = 3
      OnClick = bGenere_ToutClick
    end
    object cbDatabases: TComboBox
      Left = 95
      Top = 11
      Width = 100
      Height = 23
      TabOrder = 4
      Text = 'cbDatabases'
    end
    object bSaveSQL: TButton
      Left = 609
      Top = 48
      Width = 75
      Height = 25
      Anchors = [akTop, akRight]
      Caption = 'bSaveSQL'
      TabOrder = 5
      OnClick = bSaveSQLClick
    end
    object cbSchemas: TComboBox
      Left = 219
      Top = 11
      Width = 100
      Height = 23
      TabOrder = 6
      Text = 'cbSchemas'
      Visible = False
    end
    object bGenereFromQueryFile: TButton
      Left = 280
      Top = 72
      Width = 136
      Height = 25
      Caption = 'bGenereFromQueryFile'
      TabOrder = 7
      OnClick = bGenereFromQueryFileClick
    end
    object eQueryFileName: TEdit
      Left = 440
      Top = 78
      Width = 217
      Height = 23
      Anchors = [akLeft, akTop, akRight]
      TabOrder = 8
      Text = 'eQueryFileName'
    end
    object bod: TButton
      Left = 662
      Top = 78
      Width = 26
      Height = 23
      Caption = '...'
      TabOrder = 9
      OnClick = bodClick
    end
    object Button1: TButton
      Left = 12
      Top = 1
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 10
      OnClick = Button1Click
    end
  end
  object vst: TVirtualStringTree
    Left = 0
    Top = 106
    Width = 691
    Height = 307
    Align = alClient
    DefaultNodeHeight = 21
    Header.AutoSizeIndex = 0
    Header.DefaultHeight = 17
    Header.Height = 17
    Header.MainColumn = -1
    Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs]
    TabOrder = 1
    Touch.InteractiveGestures = [igPan, igPressAndTap]
    Touch.InteractiveGestureOptions = [igoPanSingleFingerHorizontal, igoPanSingleFingerVertical, igoPanInertia, igoPanGutter, igoParentPassthrough]
    Columns = <>
  end
  object od: TOpenDialog
    Left = 424
    Top = 72
  end
end
