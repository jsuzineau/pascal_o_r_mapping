inherited dmdNomTable: TdmdNomTable
  inherited t: TmySQLTable
    AfterPost = qAfterPost
    OnCalcFields = qCalcFields
    TableName = 'NomTable'
    object qNumero: TIntegerField
      AutoGenerateValue = arAutoInc
      FieldName = 'Numero'
      Visible = False
    end
    object qLibelle: TStringField
      FieldKind = fkCalculated
      FieldName = 'Libelle'
      Visible = False
      Size = 42
      Calculated = True
    end
  end
end
