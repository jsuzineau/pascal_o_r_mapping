object f_f_dbgKeyPress_Key_Pattern: Tf_f_dbgKeyPress_Key_Pattern
  Left = 154
  Top = 100
  Caption = 'f_f_dbgKeyPress_Key_Pattern'
  ClientHeight = 601
  ClientWidth = 854
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  TextHeight = 13
  object m: TMemo
    Left = 0
    Top = 0
    Width = 417
    Height = 233
    Lines.Strings = (
      '     case Key'
      '     of'
      '       '#39' '#39':'
      '         begin'
      '         F:= dbg.SelectedField;'
      '         I:= dbg.SelectedIndex;'
      '         if Assigned( F) and (I <> -1)'
      '         then'
      '             if    %s'
      '             then'
      '                 dbgCellClick( dbg.Columns[I]);'
      '         end;'
      '       #13:'
      '         Key:= #0;'
      '       end;')
    TabOrder = 0
  end
  object mVariables: TMemo
    Left = 112
    Top = 264
    Width = 353
    Height = 89
    Lines.Strings = (
      'var'
      '   F: TField;'
      '   I: Integer;')
    TabOrder = 1
  end
end
