object Dockable: TDockable
  Left = 573
  Height = 640
  Top = 116
  Width = 764
  Caption = 'Dockable'
  ClientHeight = 640
  ClientWidth = 764
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  LCLVersion = '4.0.0.4'
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
    Shape = stCircle
    OnMouseDown = sSelectionMouseDown
    Batpro_Shape = bstRectangle
  end
end
