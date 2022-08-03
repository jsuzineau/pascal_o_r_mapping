object fBatpro_Informix: TfBatpro_Informix
  Left = 192
  Height = 172
  Top = 107
  Width = 211
  Caption = 'fBatpro_Informix'
  ClientHeight = 172
  ClientWidth = 211
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  Position = poScreenCenter
  LCLVersion = '2.2.0.4'
  object Label1: TLabel
    Left = 8
    Height = 13
    Top = 8
    Width = 48
    Caption = 'Hostname'
  end
  object Label2: TLabel
    Left = 8
    Height = 13
    Top = 32
    Width = 46
    Caption = 'Database'
  end
  object Label3: TLabel
    Left = 8
    Height = 13
    Top = 56
    Width = 50
    Caption = 'UserName'
  end
  object Label4: TLabel
    Left = 8
    Height = 13
    Top = 80
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
    Top = 32
    Width = 121
    TabOrder = 1
    Text = 'eDatabase'
  end
  object eUser_Name: TEdit
    Left = 64
    Height = 21
    Top = 56
    Width = 121
    TabOrder = 2
    Text = 'eUser_Name'
  end
  object ePassWord: TEdit
    Left = 64
    Height = 21
    Top = 80
    Width = 121
    TabOrder = 3
    Text = 'ePassWord'
  end
  object bCancel: TBitBtn
    Left = 112
    Height = 25
    Top = 104
    Width = 75
    Kind = bkCancel
    OnClick = bCancelClick
    TabOrder = 4
  end
  object bOK: TBitBtn
    Left = 8
    Height = 25
    Top = 104
    Width = 75
    Kind = bkOK
    OnClick = bOKClick
    TabOrder = 5
  end
end
