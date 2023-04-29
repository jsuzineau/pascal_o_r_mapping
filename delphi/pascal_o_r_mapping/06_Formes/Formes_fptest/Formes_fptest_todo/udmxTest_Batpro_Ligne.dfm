inherited dmxTest_Batpro_Ligne: TdmxTest_Batpro_Ligne
  OnCreate = DataModuleCreate
  Left = 298
  Top = 110
  Height = 297
  Width = 344
  inherited sqlq: TSQLQuery
    SQL.Strings = (
      'select'
      '      *'
      'from'
      '    Test_Batpro_Ligne')
    object sqlqnumero: TIntegerField
      FieldName = 'numero'
    end
    object sqlqtest_string: TStringField
      FieldName = 'test_string'
      FixedChar = True
      Size = 42
    end
    object sqlqtest_memo: TMemoField
      FieldName = 'test_memo'
      BlobType = ftMemo
      Size = 1
    end
    object sqlqtest_date: TDateField
      FieldName = 'test_date'
    end
    object sqlqtest_integer: TIntegerField
      FieldName = 'test_integer'
    end
    object sqlqtest_smallint: TSmallintField
      FieldName = 'test_smallint'
    end
    object sqlqtest_currency: TFMTBCDField
      FieldName = 'test_currency'
      Precision = 16
      Size = 2
    end
    object sqlqtest_datetime: TSQLTimeStampField
      FieldName = 'test_datetime'
    end
    object sqlqtest_double: TFloatField
      FieldName = 'test_double'
    end
  end
  inherited cd: TClientDataSet
    OnCalcFields = cdCalcFields
    object cdnumero: TIntegerField
      FieldName = 'numero'
    end
    object cdtest_string: TStringField
      FieldName = 'test_string'
      FixedChar = True
      Size = 42
    end
    object cdtest_memo: TMemoField
      FieldName = 'test_memo'
      BlobType = ftMemo
      Size = 1
    end
    object cdtest_date: TDateField
      FieldName = 'test_date'
    end
    object cdtest_integer: TIntegerField
      FieldName = 'test_integer'
    end
    object cdtest_smallint: TSmallintField
      FieldName = 'test_smallint'
    end
    object cdtest_currency: TFMTBCDField
      FieldName = 'test_currency'
      Precision = 16
      Size = 2
    end
    object cdtest_datetime: TSQLTimeStampField
      FieldName = 'test_datetime'
    end
    object cdtest_double: TFloatField
      FieldName = 'test_double'
    end
    object cdtest_champ_calcule: TStringField
      DisplayLabel = 'Test  champ  calcul'#233
      FieldKind = fkCalculated
      FieldName = 'test_champ_calcule'
      Calculated = True
    end
  end
end
