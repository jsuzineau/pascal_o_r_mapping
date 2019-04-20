inherited dmaNomTable: TdmaNomTable
  Left = 683
  Top = 289
  Height = 278
  Width = 232
  inherited q: TmySQLQuery
    OnCalcFields = qCalcFields
    SQL.Strings = (
      'select'
      '      *'
      'from'
      '    NomTable'
      'order by'
      '      Order_By_Key')
    object qNumero: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'Numero'
    end
    object qLibelle: TStringField
      FieldKind = fkCalculated
      FieldName = 'Libelle'
      Size = 42
      Calculated = True
    end
  end
end
