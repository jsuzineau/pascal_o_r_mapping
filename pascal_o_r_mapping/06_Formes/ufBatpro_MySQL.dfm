object fBatpro_MySQL: TfBatpro_MySQL
  Left = 1052
  Height = 173
  Top = 1540
  Width = 211
  Caption = 'fBatpro_MySQL'
  ClientHeight = 173
  ClientWidth = 211
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  OnShow = FormShow
  Position = poScreenCenter
  LCLVersion = '2.2.0.4'
  object Label1: TLabel
    Left = 8
    Height = 13
    Top = 15
    Width = 48
    Caption = 'Hostname'
  end
  object Label2: TLabel
    Left = 8
    Height = 13
    Top = 47
    Width = 46
    Caption = 'Database'
  end
  object Label3: TLabel
    Left = 8
    Height = 13
    Top = 79
    Width = 50
    Caption = 'UserName'
  end
  object Label4: TLabel
    Left = 8
    Height = 13
    Top = 111
    Width = 46
    Caption = 'Password'
  end
  object eHostName: TEdit
    Left = 64
    Height = 21
    Top = 8
    Width = 121
    TabOrder = 0
    Text = 'eHostName'
  end
  object eDatabase: TEdit
    Left = 64
    Height = 21
    Top = 40
    Width = 121
    TabOrder = 1
    Text = 'eDatabase'
  end
  object eUser_Name: TEdit
    Left = 64
    Height = 21
    Top = 72
    Width = 121
    TabOrder = 2
    Text = 'eUser_Name'
  end
  object ePassWord: TEdit
    Left = 64
    Height = 21
    Top = 104
    Width = 121
    TabOrder = 3
    Text = 'ePassWord'
  end
  object bOK: TBitBtn
    Left = 8
    Height = 25
    Top = 144
    Width = 100
    Kind = bkOK
    ModalResult = 1
    OnClick = bOKClick
    TabOrder = 4
  end
  object bCancel: TBitBtn
    Left = 120
    Height = 25
    Top = 144
    Width = 88
    Kind = bkCancel
    ModalResult = 2
    OnClick = bCancelClick
    TabOrder = 5
  end
end
