inherited dkTag_LABEL: TdkTag_LABEL
  Left = 636
  Height = 77
  Top = 169
  Width = 320
  Caption = 'dkTag_LABEL'
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
end
