inherited fHelp_Creator: TfHelp_Creator
  Caption = 'fHelp_Creator'
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  inherited sLog: TSplitter
    Top = 150
    ExplicitTop = 410
  end
  inherited pBas: TPanel
    Top = 156
    Height = 72
    ExplicitTop = 416
    ExplicitHeight = 72
    inherited pFermer: TPanel
      Left = 683
      Width = 129
      Height = 70
      ExplicitLeft = 683
      ExplicitWidth = 129
      ExplicitHeight = 70
      inherited bAbandon: TBitBtn
        Left = 16
        Visible = False
        ExplicitLeft = 16
      end
      object bKomposer: TButton
        Left = 24
        Top = 40
        Width = 75
        Height = 25
        Caption = 'Komposer'
        TabOrder = 2
        OnClick = bKomposerClick
      end
    end
    object bHTML: TButton
      Left = 448
      Top = 8
      Width = 50
      Height = 25
      Caption = 'HTML'
      TabOrder = 1
      OnClick = bHTMLClick
    end
    object bAll: TButton
      Left = 448
      Top = 40
      Width = 249
      Height = 25
      Caption = 'ScreenShot JPEG puis HTML puis visualisation'
      Default = True
      TabOrder = 2
      OnClick = bAllClick
    end
    object gbScreenShots: TGroupBox
      Left = 152
      Top = 8
      Width = 287
      Height = 59
      Caption = 'ScreenShots'
      TabOrder = 3
      object bScreenShotEMF: TButton
        Left = 8
        Top = 16
        Width = 33
        Height = 25
        Caption = 'EMF'
        TabOrder = 0
        OnClick = bScreenShotEMFClick
      end
      object bScreenShotBMP: TButton
        Left = 88
        Top = 16
        Width = 34
        Height = 25
        Caption = 'BMP'
        TabOrder = 1
        OnClick = bScreenShotBMPClick
      end
      object GroupBox1: TGroupBox
        Left = 128
        Top = 8
        Width = 137
        Height = 43
        Caption = 'JPEG'
        TabOrder = 2
        object Label2: TLabel
          Left = 8
          Top = 16
          Width = 33
          Height = 13
          Caption = 'Qualit'#233
        end
        object speJPEGQuality: TSpinEdit
          Left = 45
          Top = 13
          Width = 37
          Height = 22
          MaxValue = 100
          MinValue = 1
          TabOrder = 0
          Value = 90
        end
        object bScreenShotJPEG: TButton
          Left = 88
          Top = 12
          Width = 41
          Height = 25
          Caption = 'JPEG'
          TabOrder = 1
          OnClick = bScreenShotJPEGClick
        end
      end
      object bScreenShotWMF: TButton
        Left = 48
        Top = 16
        Width = 33
        Height = 25
        Caption = 'WMF'
        TabOrder = 3
        OnClick = bScreenShotWMFClick
      end
    end
    object Button1: TButton
      Left = 64
      Top = 24
      Width = 75
      Height = 25
      Caption = 'Button1'
      TabOrder = 4
      OnClick = Button1Click
    end
  end
  inherited StatusBar1: TStatusBar
    Top = 131
  end
  inherited pLog: TPanel
    Top = 59
  end
  object Panel1: TPanel [5]
    Left = 0
    Top = 18
    Width = 354
    Height = 41
    Align = alClient
    Caption = 'Panel1'
    TabOrder = 4
    ExplicitWidth = 813
    ExplicitHeight = 392
    object Splitter1: TSplitter
      Left = 1
      Top = -146
      Width = 352
      Height = 6
      Cursor = crVSplit
      Align = alBottom
      Color = clLime
      ParentColor = False
      ExplicitTop = 205
      ExplicitWidth = 811
    end
    object m: TMemo
      Left = 1
      Top = 1
      Width = 352
      Height = 204
      Align = alClient
      Lines.Strings = (
        'm')
      TabOrder = 0
      ExplicitWidth = 811
    end
    object Panel2: TPanel
      Left = 1
      Top = -140
      Width = 352
      Height = 180
      Align = alBottom
      Caption = 'Panel2'
      TabOrder = 1
      ExplicitTop = 211
      ExplicitWidth = 811
      object Label1: TLabel
        Left = 1
        Top = 1
        Width = 350
        Height = 13
        Align = alTop
        Caption = 
          '"pattern" pour cr'#233'ation du HTML. %0:s = titre de la fiche , %1:s' +
          ' = nom du fichier de l'#39'image (sans r'#233'pertoire)'
        ExplicitWidth = 502
      end
      object mHTMLPattern: TMemo
        Left = 1
        Top = 14
        Width = 350
        Height = 165
        Align = alClient
        Lines.Strings = (
          '<html>'
          '<head>'
          '  <title>%0:s</title>'
          '</head>'
          '<body>'
          '<h1>%0:s<br>'
          ' </h1>'
          ' <img src="%1:s" alt="%1:s">'
          ' <br>'
          '</body>'
          '</html>')
        TabOrder = 0
        ExplicitWidth = 809
      end
    end
  end
  object SaveDialogEMF: TSaveDialog
    DefaultExt = 'EMF'
    Filter = '(*.EMF) image Enhanced MetaFile|*.EMF'
    Left = 280
    Top = 398
  end
  object SaveDialogHTML: TSaveDialog
    DefaultExt = 'HTM'
    Filter = '(*.HTM) document HyperText Markup Language|*.HTM'
    Left = 544
    Top = 382
  end
  object SaveDialogBMP: TSaveDialog
    DefaultExt = 'BMP'
    Filter = '(*.BMP) image Bitmap|*.BMP'
    Left = 320
    Top = 397
  end
  object SaveDialogJPEG: TSaveDialog
    DefaultExt = 'JPG'
    Filter = '(*.JPG) image JPEG|*.JPG'
    Left = 448
    Top = 397
  end
end
