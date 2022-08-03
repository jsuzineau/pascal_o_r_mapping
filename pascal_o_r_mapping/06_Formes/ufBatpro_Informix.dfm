object fBatpro_Informix: TfBatpro_Informix
  Left = 690
  Height = 172
  Top = 438
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
    Height = 16
    Top = 8
    Width = 53
    Caption = 'Hostname'
  end
  object Label2: TLabel
    Left = 8
    Height = 16
    Top = 40
    Width = 48
    Caption = 'Database'
  end
  object Label3: TLabel
    Left = 8
    Height = 16
    Top = 72
    Width = 54
    Caption = 'UserName'
  end
  object Label4: TLabel
    Left = 8
    Height = 16
    Top = 104
    Width = 50
    Caption = 'Password'
  end
  object eHostName: TEdit
    Left = 64
    Height = 33
    Top = 8
    Width = 121
    TabOrder = 0
    Text = 'eHostName'
  end
  object eDatabase: TEdit
    Left = 64
    Height = 33
    Top = 40
    Width = 121
    TabOrder = 1
    Text = 'eDatabase'
  end
  object eUser_Name: TEdit
    Left = 64
    Height = 33
    Top = 72
    Width = 121
    TabOrder = 2
    Text = 'eUser_Name'
  end
  object ePassWord: TEdit
    Left = 64
    Height = 33
    Top = 104
    Width = 121
    EchoMode = emPassword
    PasswordChar = '*'
    TabOrder = 3
    Text = 'ePassWord'
  end
  object bCancel: TBitBtn
    Left = 110
    Height = 25
    Top = 138
    Width = 95
    Kind = bkCancel
    OnClick = bCancelClick
    TabOrder = 4
  end
  object bOK: TBitBtn
    Left = 8
    Height = 25
    Top = 138
    Width = 94
    Kind = bkOK
    OnClick = bOKClick
    TabOrder = 5
  end
end
