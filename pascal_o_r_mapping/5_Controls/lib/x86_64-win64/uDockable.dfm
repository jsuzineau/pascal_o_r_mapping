object Dockable: TDockable
  Left = 315
  Top = 128
  Width = 870
  Height = 640
  Caption = 'Dockable'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  OnClick = FormClick
  OnDblClick = FormDblClick
  OnKeyDown = DockableKeyDown
  OnMouseWheelDown = FormMouseWheelDown
  OnMouseWheelUp = FormMouseWheelUp
  PixelsPerInch = 96
  TextHeight = 13
  object sSelection: TBatpro_Shape
    Left = 0
    Top = 0
    Width = 12
    Height = 606
    Align = alLeft
    Brush.Style = bsClear
    Pen.Style = psClear
    Shape = stCircle
    OnMouseDown = sSelectionMouseDown
    Batpro_Shape = bstRectangle
  end
end
