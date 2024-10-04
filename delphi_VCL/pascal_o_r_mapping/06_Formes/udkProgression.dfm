inherited dkProgression: TdkProgression
  Left = 221
  Top = 132
  HorzScrollBar.Range = 0
  BorderStyle = bsNone
  Caption = 'dkProgression'
  ClientHeight = 53
  ClientWidth = 422
  OldCreateOrder = True
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited sSelection: TBatpro_Shape
    Top = 51
    Height = 2
  end
  object p: TPanel
    Left = 0
    Top = 0
    Width = 422
    Height = 51
    Align = alTop
    BorderWidth = 1
    ParentBackground = False
    TabOrder = 0
    object g: TGauge
      Left = 2
      Top = 16
      Width = 347
      Height = 33
      Align = alClient
      ForeColor = clLime
      Progress = 1
    end
    object pLabels: TPanel
      Left = 2
      Top = 2
      Width = 418
      Height = 14
      Align = alTop
      BevelOuter = bvNone
      ParentBackground = False
      TabOrder = 0
      object lcompte: TLabel
        Left = 365
        Top = 0
        Width = 53
        Height = 14
        Align = alRight
        Caption = '1000/1000'
      end
      object Label1: TLabel
        Left = 0
        Top = 0
        Width = 365
        Height = 14
        Align = alClient
        Alignment = taCenter
        Caption = 'Label1'
      end
    end
    object pInterrompre: TPanel
      Left = 349
      Top = 16
      Width = 71
      Height = 33
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object bInterrompre: TSpeedButton
        Left = 5
        Top = 4
        Width = 65
        Height = 25
        AllowAllUp = True
        GroupIndex = 1
        Caption = 'Interrompre'
        OnClick = bInterrompreClick
      end
    end
  end
end
