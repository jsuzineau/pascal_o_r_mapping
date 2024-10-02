inherited dmxSYSCOLUMNS: TdmxSYSCOLUMNS
  Left = 297
  Top = 224
  Height = 479
  inherited sqlq: TSQLQuery
    Params = <
      item
        DataType = ftString
        Name = 'tabname'
        ParamType = ptInput
        Value = 'a_lci'
      end
      item
        DataType = ftString
        Name = 'colname'
        ParamType = ptInput
        Value = 'libelle'
      end>
    SQL.Strings = (
      'select'
      '      rowid,*'
      'from'
      '    syscolumns'
      'where'
      
        '         (tabid in (select tabid from systables where tabname = ' +
        ':tabname))'
      '     and (colname = :colname)'
      ' ')
    object sqlqrowid: TIntegerField
      FieldName = 'rowid'
    end
    object sqlqcolname: TStringField
      FieldName = 'colname'
      FixedChar = True
      Size = 18
    end
    object sqlqtabid: TIntegerField
      FieldName = 'tabid'
    end
    object sqlqcolno: TSmallintField
      FieldName = 'colno'
    end
    object sqlqcoltype: TSmallintField
      FieldName = 'coltype'
    end
    object sqlqcollength: TSmallintField
      FieldName = 'collength'
    end
    object sqlqcolmin: TIntegerField
      FieldName = 'colmin'
    end
    object sqlqcolmax: TIntegerField
      FieldName = 'colmax'
    end
  end
  inherited cd: TClientDataSet
    object cdrowid: TIntegerField
      FieldName = 'rowid'
    end
    object cdcolname: TStringField
      FieldName = 'colname'
      FixedChar = True
      Size = 18
    end
    object cdtabid: TIntegerField
      FieldName = 'tabid'
    end
    object cdcolno: TSmallintField
      FieldName = 'colno'
    end
    object cdcoltype: TSmallintField
      FieldName = 'coltype'
    end
    object cdcollength: TSmallintField
      FieldName = 'collength'
    end
    object cdcolmin: TIntegerField
      FieldName = 'colmin'
    end
    object cdcolmax: TIntegerField
      FieldName = 'colmax'
    end
  end
end
