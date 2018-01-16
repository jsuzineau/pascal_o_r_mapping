object fBatpro_Form: TfBatpro_Form
  Left = 644
  Top = 363
  BorderIcons = [biSystemMenu, biMinimize, biMaximize, biHelp]
  Caption = 'fBatpro_Form'
  ClientHeight = 228
  ClientWidth = 354
  Color = clBtnFace

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
    Width = 354
    Height = 18
    Align = alTop
    BevelOuter = bvNone
    ParentBackground = False
    TabOrder = 0
    object lSociete: TLabel
      Left = 0
      Top = 0
      Width = 298
      Height = 18
      Align = alClient
      Caption = 'lSociete'
      Color = 16744576

      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ExplicitWidth = 56
      ExplicitHeight = 14
    end
    object lHeure: TLabel
      Left = 298
      Top = 0
      Width = 56
      Height = 18
      Align = alRight
      Alignment = taRightJustify
      Caption = '23:59:59'
      Color = 16744576

      Font.Color = clWindowText
      Font.Height = -11
      Font.Name = 'Courier New'
      Font.Style = []
      ParentColor = False
      ParentFont = False
      ExplicitHeight = 14
    end
  end
end
