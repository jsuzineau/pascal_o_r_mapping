object Dockable: TDockable
  Left = 315
  Top = 128
  Caption = 'Dockable'
  Height = 601
  Width = 854
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnClick = FormClick
  OnDblClick = FormDblClick
  OnKeyDown = DockableKeyDown
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  object sBackground: TShape
    Left = 0
    Height = 640
    Top = 0
    Width = 764
    Anchors = [akTop, akLeft, akRight, akBottom]
    Brush.Color = clBtnFace
    Pen.Style = psClear
  end
  object sSelection: TBatpro_Shape
    Left = 0
    Height = 640
    Top = 0
    Width = 12
    Align = alLeft
    Brush.Style = bsClear
    Pen.Style = psClear
    OnMouseDown = sSelectionMouseDown
    Shape = stCircle
    Batpro_Shape = bstRectangle
  end
end
