object fBatpro_MySQL: TfBatpro_MySQL
  Left = 192
  Height = 173
  Top = 107
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
  LCLVersion = '1.0.1.3'
  object Label1: TLabel
    Left = 8
    Height = 15
    Top = 8
    Width = 58
    Caption = 'Hostname'
    ParentColor = False
  end
  object Label2: TLabel
    Left = 8
    Height = 15
    Top = 32
    Width = 54
    Caption = 'Database'
    ParentColor = False
  end
  object Label3: TLabel
    Left = 8
    Height = 15
    Top = 56
    Width = 60
    Caption = 'UserName'
    ParentColor = False
  end
  object Label4: TLabel
    Left = 8
    Height = 15
    Top = 80
    Width = 55
    Caption = 'Password'
    ParentColor = False
  end
  object eHostName: TEdit
    Left = 64
    Height = 24
    Top = 8
    Width = 121
    TabOrder = 0
    Text = 'eHostName'
  end
  object eDatabase: TEdit
    Left = 64
    Height = 24
    Top = 32
    Width = 121
    TabOrder = 1
    Text = 'eDatabase'
  end
  object eUser_Name: TEdit
    Left = 64
    Height = 24
    Top = 56
    Width = 121
    TabOrder = 2
    Text = 'eUser_Name'
  end
  object ePassWord: TEdit
    Left = 64
    Height = 24
    Top = 80
    Width = 121
    TabOrder = 3
    Text = 'ePassWord'
  end
  object bOK: TBitBtn
    Left = 8
    Height = 25
    Top = 104
    Width = 75
    Kind = bkOK
    ModalResult = 1
    OnClick = bOKClick
    TabOrder = 4
  end
  object bCancel: TBitBtn
    Left = 112
    Height = 25
    Top = 104
    Width = 75
    Kind = bkCancel
    ModalResult = 2
    OnClick = bCancelClick
    TabOrder = 5
  end
end