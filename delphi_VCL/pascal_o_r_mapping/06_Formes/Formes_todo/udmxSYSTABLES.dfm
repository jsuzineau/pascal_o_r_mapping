inherited dmxSYSTABLES: TdmxSYSTABLES
  Left = 285
  Top = 161
  Height = 479
  Width = 741
  inherited sqlq: TSQLQuery
    Params = <
      item
        DataType = ftString
        Name = 'tabname'
        ParamType = ptInput
        Value = ''
      end>
    SQL.Strings = (
      'select'
      '      *'
      'from'
      '    systables'
      'where'
      '     tabname = :tabname')
    object sqlqtabname: TStringField
      FieldName = 'tabname'
      FixedChar = True
      Size = 18
    end
    object sqlqowner: TStringField
      FieldName = 'owner'
      FixedChar = True
      Size = 8
    end
    object sqlqpartnum: TIntegerField
      FieldName = 'partnum'
    end
    object sqlqtabid: TIntegerField
      FieldName = 'tabid'
    end
    object sqlqrowsize: TSmallintField
      FieldName = 'rowsize'
    end
    object sqlqncols: TSmallintField
      FieldName = 'ncols'
    end
    object sqlqnindexes: TSmallintField
      FieldName = 'nindexes'
    end
    object sqlqnrows: TIntegerField
      FieldName = 'nrows'
    end
    object sqlqcreated: TDateField
      FieldName = 'created'
    end
    object sqlqversion: TIntegerField
      FieldName = 'version'
    end
    object sqlqtabtype: TStringField
      FieldName = 'tabtype'
      FixedChar = True
      Size = 1
    end
    object sqlqlocklevel: TStringField
      FieldName = 'locklevel'
      FixedChar = True
      Size = 1
    end
    object sqlqnpused: TIntegerField
      FieldName = 'npused'
    end
    object sqlqfextsize: TIntegerField
      FieldName = 'fextsize'
    end
    object sqlqnextsize: TIntegerField
      FieldName = 'nextsize'
    end
    object sqlqflags: TSmallintField
      FieldName = 'flags'
    end
    object sqlqsite: TStringField
      FieldName = 'site'
      FixedChar = True
      Size = 18
    end
    object sqlqdbname: TStringField
      FieldName = 'dbname'
      FixedChar = True
      Size = 18
    end
  end
  inherited cd: TClientDataSet
    object cdtabname: TStringField
      FieldName = 'tabname'
      Origin = 'DMDATABASE_DB.systables.tabname'
      FixedChar = True
      Size = 18
    end
    object cdowner: TStringField
      FieldName = 'owner'
      Origin = 'DMDATABASE_DB.systables.owner'
      FixedChar = True
      Size = 8
    end
    object cdpartnum: TIntegerField
      FieldName = 'partnum'
      Origin = 'DMDATABASE_DB.systables.partnum'
    end
    object cdtabid: TIntegerField
      FieldName = 'tabid'
      Origin = 'DMDATABASE_DB.systables.tabid'
    end
    object cdrowsize: TSmallintField
      FieldName = 'rowsize'
      Origin = 'DMDATABASE_DB.systables.rowsize'
    end
    object cdncols: TSmallintField
      FieldName = 'ncols'
      Origin = 'DMDATABASE_DB.systables.ncols'
    end
    object cdnindexes: TSmallintField
      FieldName = 'nindexes'
      Origin = 'DMDATABASE_DB.systables.nindexes'
    end
    object cdnrows: TIntegerField
      FieldName = 'nrows'
      Origin = 'DMDATABASE_DB.systables.nrows'
    end
    object cdcreated: TDateField
      FieldName = 'created'
      Origin = 'DMDATABASE_DB.systables.created'
    end
    object cdversion: TIntegerField
      FieldName = 'version'
      Origin = 'DMDATABASE_DB.systables.version'
    end
    object cdtabtype: TStringField
      FieldName = 'tabtype'
      Origin = 'DMDATABASE_DB.systables.tabtype'
      FixedChar = True
      Size = 1
    end
    object cdlocklevel: TStringField
      FieldName = 'locklevel'
      Origin = 'DMDATABASE_DB.systables.locklevel'
      FixedChar = True
      Size = 1
    end
    object cdnpused: TIntegerField
      FieldName = 'npused'
      Origin = 'DMDATABASE_DB.systables.npused'
    end
    object cdfextsize: TIntegerField
      FieldName = 'fextsize'
      Origin = 'DMDATABASE_DB.systables.fextsize'
    end
    object cdnextsize: TIntegerField
      FieldName = 'nextsize'
      Origin = 'DMDATABASE_DB.systables.nextsize'
    end
    object cdflags: TSmallintField
      FieldName = 'flags'
      Origin = 'DMDATABASE_DB.systables.flags'
    end
    object cdsite: TStringField
      FieldName = 'site'
      Origin = 'DMDATABASE_DB.systables.site'
      FixedChar = True
      Size = 18
    end
    object cddbname: TStringField
      FieldName = 'dbname'
      Origin = 'DMDATABASE_DB.systables.dbname'
      FixedChar = True
      Size = 18
    end
  end
end
