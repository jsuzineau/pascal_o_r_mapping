inherited fClientDataset: TfClientDataset
  Left = 286
  Top = 107
  Width = 701
  Height = 516
  Caption = 'fClientDataset'
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 456
    Width = 693
    Height = 3
  end
  object Splitter1: TSplitter [1]
    Left = 0
    Top = 306
    Width = 693
    Height = 7
    Cursor = crVSplit
    Align = alBottom
    Color = clLime
    ParentColor = False
    Visible = False
  end
  inherited pSociete: TPanel
    Width = 693
    inherited lSociete: TLabel
      Width = 637
    end
    inherited lHeure: TLabel
      Left = 637
    end
  end
  inherited pBas: TPanel
    Top = 415
    Width = 693
    object lUpdateStatus: TLabel [0]
      Left = 16
      Top = 8
      Width = 67
      Height = 13
      Caption = 'lUpdateStatus'
    end
    inherited pFermer: TPanel
      Left = 559
      Width = 133
      inherited bAbandon: TBitBtn
        Left = 16
        Visible = False
      end
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 470
    Width = 693
  end
  inherited pLog: TPanel
    Top = 459
    Width = 693
    Height = 11
    inherited lLog: TLabel
      Width = 691
    end
    inherited mLog: TMemo
      Width = 691
      Height = 0
    end
  end
  object dbg: TDBGrid [6]
    Left = 0
    Top = 15
    Width = 693
    Height = 291
    Align = alClient
    DataSource = ds
    TabOrder = 4
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    OnCellClick = dbgCellClick
  end
  object Panel1: TPanel [7]
    Left = 0
    Top = 313
    Width = 693
    Height = 102
    Align = alBottom
    Caption = 'Panel1'
    TabOrder = 5
    object Panel2: TPanel
      Left = 1
      Top = 1
      Width = 128
      Height = 100
      Align = alLeft
      Caption = 'Panel2'
      TabOrder = 0
      object mField: TMemo
        Left = 1
        Top = 22
        Width = 126
        Height = 77
        Align = alClient
        BorderStyle = bsNone
        Color = clBtnFace
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clBtnText
        Font.Height = -11
        Font.Name = 'MS Sans Serif'
        Font.Style = []
        Lines.Strings = (
          'mField')
        ParentFont = False
        TabOrder = 0
      end
      object Panel4: TPanel
        Left = 1
        Top = 1
        Width = 126
        Height = 21
        Align = alTop
        BevelOuter = bvNone
        Caption = 'Panel4'
        TabOrder = 1
        object edbmField: TEdit
          Left = 0
          Top = 0
          Width = 124
          Height = 21
          TabOrder = 0
          Text = 'edbmField'
          OnChange = edbmFieldChange
        end
      end
    end
    object pc: TPageControl
      Left = 129
      Top = 1
      Width = 563
      Height = 100
      ActivePage = tsMemo
      Align = alClient
      TabOrder = 1
      object tsMemo: TTabSheet
        Caption = 'Memo'
        object dbm: TDBMemo
          Left = 0
          Top = 0
          Width = 555
          Height = 72
          Align = alClient
          TabOrder = 0
        end
      end
      object tsImage: TTabSheet
        Caption = 'Image'
        ImageIndex = 1
        object Panel3: TPanel
          Left = 0
          Top = 0
          Width = 73
          Height = 72
          Align = alLeft
          TabOrder = 0
          object bSaveAs: TButton
            Left = 0
            Top = 40
            Width = 75
            Height = 25
            Caption = 'Save As'
            TabOrder = 0
            OnClick = bSaveAsClick
          end
          object bOpen: TButton
            Left = -2
            Top = 8
            Width = 75
            Height = 25
            Caption = 'Open'
            TabOrder = 1
            OnClick = bOpenClick
          end
        end
        object dbi: TDBImage
          Left = 73
          Top = 0
          Width = 651
          Height = 72
          Align = alClient
          TabOrder = 1
        end
      end
    end
  end
  object ds: TDataSource
    Left = 72
    Top = 72
  end
  object OpenDialog: TOpenDialog
    Left = 5
    Top = 353
  end
  object SaveDialog: TSaveDialog
    Left = 5
    Top = 377
  end
end
