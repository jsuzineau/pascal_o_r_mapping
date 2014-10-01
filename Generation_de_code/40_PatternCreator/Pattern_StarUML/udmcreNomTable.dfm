inherited dmcreNomTable: TdmcreNomTable
  Height = 242
  Width = 355
  inherited tbl: TmySQLTable
    TableName = 'NomTable'
  end
  object q: TmySQLQuery
    Database = dmDatabase.db
    SQL.Strings = (
      'CREATE_TABLE')
    Left = 72
    Top = 40
  end
end
