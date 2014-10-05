inherited dmlkNomTable: TdmlkNomTable
  inherited q: TmySQLQuery
    OnCalcFields = qCalcFields
    SQL.Strings = (
      'select'
      '      *'
      'from'
      '    NomTable'
      '')
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
