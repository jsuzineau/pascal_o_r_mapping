object Dockable: TDockable
  Left = 260
  Height = 640
  Top = 56
  Width = 764
  Caption = 'Dockable'
  ClientHeight = 640
  ClientWidth = 764
  Color = clBtnFace
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  OnClick = FormClick
  OnDblClick = FormDblClick
  OnKeyDown = DockableKeyDown
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  LCLVersion = '1.6.0.4'
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
