inherited dmxcreTest_Batpro_Ligne: TdmxcreTest_Batpro_Ligne
  Left = 298
  Top = 110
  Height = 303
  Width = 388
  object sqlq: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQL.Strings = (
      'CREATE TABLE Test_Batpro_Ligne'
      '  ('
      '  Numero        SERIAL  ,'
      '  Test_String   CHAR(42),'
      '  Test_Memo     TEXT    ,'
      '  Test_Date     DATE    ,'
      '  Test_Integer  INTEGER ,'
      '  Test_SmallInt SMALLINT,'
      '  Test_Currency MONEY   ,'
      '  Test_Datetime DATETIME YEAR TO SECOND,'
      '  Test_Double   FLOAT   ,'
      '  PRIMARY KEY ( Numero)'
      '  )')
    SQLConnection = dmDatabase.sqlc
    Left = 32
    Top = 16
  end
  object sqlINSERT: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftUnknown
        Name = 'Numero'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Test_String'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Test_Memo'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Test_Date'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Test_Integer'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Test_SmallInt'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Test_Currency'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Test_Datetime'
        ParamType = ptUnknown
      end
      item
        DataType = ftUnknown
        Name = 'Test_Double'
        ParamType = ptUnknown
      end>
    SQL.Strings = (
      'insert'
      'into'
      '    Test_Batpro_Ligne'
      '    ('
      '    Numero       ,'
      '    Test_String  ,'
      '    Test_Memo    ,'
      '    Test_Date    ,'
      '    Test_Integer ,'
      '    Test_SmallInt,'
      '    Test_Currency,'
      '    Test_Datetime,'
      '    Test_Double'
      '    )'
      'values'
      '      ('
      '      :Numero       ,'
      '      :Test_String  ,'
      '      :Test_Memo    ,'
      '      :Test_Date    ,'
      '      :Test_Integer ,'
      '      :Test_SmallInt,'
      '      :Test_Currency,'
      '      :Test_Datetime,'
      '      :Test_Double'
      '      )')
    SQLConnection = dmDatabase.sqlc
    Left = 32
    Top = 72
  end
end
