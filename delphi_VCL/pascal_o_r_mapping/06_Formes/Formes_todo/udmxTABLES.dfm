inherited dmxTABLES: TdmxTABLES
  OnCreate = DataModuleCreate
  Left = 285
  Top = 127
  Height = 288
  Width = 322
  inherited sqlq: TSQLQuery
    Params = <
      item
        DataType = ftUnknown
        Name = 'table_schema'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'table_name'
        ParamType = ptUnknown
      end>
    SQL.Strings = (
      'select'
      '      *'
      'from'
      '    information_schema.tables'
      'where'
      '         table_schema = :table_schema'
      '     and table_name   = :table_name')
  end
end
