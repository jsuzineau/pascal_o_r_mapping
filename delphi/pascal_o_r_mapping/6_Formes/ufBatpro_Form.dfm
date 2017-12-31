object fBatpro_Form: TfBatpro_Form
  Left = 644
  Top = 363
  Width = 370
  Height = 267
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'fBatpro_Form'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object pSociete: TPanel
    Left = 0
    Top = 0
    Width = 362
    Height = 18
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object lSociete: TLabel
      Left = 0
      Top = 0
      Width = 290
      Height = 18
      Align = alClient
      Caption = 'lSociete'
      Color = 16744576
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lHeure: TLabel
      Left = 290
      Top = 0
      Width = 56
      Height = 18
      Align = alRight
      Alignment = taRightJustify
      Caption = '23:59:59'
      Color = 16744576
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object animation: TAnimate
      Left = 346
      Top = 0
      Width = 16
      Height = 18
      Align = alRight
      CommonAVI = aviFindComputer
      StopFrame = 8
    end
  end
end
