inherited dmxSHOW_TABLES: TdmxSHOW_TABLES
  OnCreate = DataModuleCreate
  Left = 285
  Top = 127
  Height = 288
  Width = 322
  inherited sqlq: TSQLQuery
    SQL.Strings = (
      'show tables')
  end
end
