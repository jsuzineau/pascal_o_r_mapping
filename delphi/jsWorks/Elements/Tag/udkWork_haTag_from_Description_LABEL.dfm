inherited dkWork_haTag_from_Description_LABEL: TdkWork_haTag_from_Description_LABEL
  Left = 640
  Height = 77
  Top = 171
  Width = 320
  Caption = 'dkWork_haTag_from_Description_LABEL'
  ClientHeight = 77
  ClientWidth = 320
  inherited sSelection: TBatpro_Shape
    Height = 77
  end
  object clName: TChamp_Label[1]
    Left = 8
    Height = 13
    Top = 0
    Width = 310
    Anchors = [akTop, akLeft, akRight]
    Caption = 'clName'
    ParentColor = False
    ParentShowHint = False
    ShowHint = True
    OnClick = FormClick
    Field = 'Name'
  end
  object sbDetruire: TSpeedButton[2]
    Left = 298
    Height = 22
    Hint = 'Supprimer'
    Top = 0
    Width = 22
    Anchors = [akTop, akRight]
    Caption = '<'
    OnClick = sbDetruireClick
  end
end
