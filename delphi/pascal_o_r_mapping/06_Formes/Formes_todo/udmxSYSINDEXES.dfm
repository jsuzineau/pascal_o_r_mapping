inherited dmxSYSINDEXES: TdmxSYSINDEXES
  Left = 287
  Top = 107
  Height = 286
  Width = 323
  inherited sqlq: TSQLQuery
    Params = <
      item
        DataType = ftString
        Name = 'idxname'
        ParamType = ptInput
        Value = '0'
      end
      item
        DataType = ftString
        Name = 'tabname'
        ParamType = ptInput
        Value = '0'
      end>
    SQL.Strings = (
      'select'
      '      sysindexes.*'
      'from'
      '    sysindexes'
      'where'
      '         (sysindexes.idxname = :idxname)'
      '     and ( sysindexes.tabid in'
      '           ('
      '           select'
      '                 systables.tabid'
      '           from'
      '               systables'
      '           where'
      '                systables.tabname = :tabname'
      '           )'
      '         )'
      '')
    object sqlqidxname: TStringField
      FieldName = 'idxname'
      FixedChar = True
      Size = 18
    end
    object sqlqowner: TStringField
      FieldName = 'owner'
      FixedChar = True
      Size = 8
    end
    object sqlqtabid: TIntegerField
      FieldName = 'tabid'
    end
    object sqlqidxtype: TStringField
      FieldName = 'idxtype'
      FixedChar = True
      Size = 1
    end
    object sqlqclustered: TStringField
      FieldName = 'clustered'
      FixedChar = True
      Size = 1
    end
    object sqlqpart1: TSmallintField
      FieldName = 'part1'
    end
    object sqlqpart2: TSmallintField
      FieldName = 'part2'
    end
    object sqlqpart3: TSmallintField
      FieldName = 'part3'
    end
    object sqlqpart4: TSmallintField
      FieldName = 'part4'
    end
    object sqlqpart5: TSmallintField
      FieldName = 'part5'
    end
    object sqlqpart6: TSmallintField
      FieldName = 'part6'
    end
    object sqlqpart7: TSmallintField
      FieldName = 'part7'
    end
    object sqlqpart8: TSmallintField
      FieldName = 'part8'
    end
    object sqlqpart9: TSmallintField
      FieldName = 'part9'
    end
    object sqlqpart10: TSmallintField
      FieldName = 'part10'
    end
    object sqlqpart11: TSmallintField
      FieldName = 'part11'
    end
    object sqlqpart12: TSmallintField
      FieldName = 'part12'
    end
    object sqlqpart13: TSmallintField
      FieldName = 'part13'
    end
    object sqlqpart14: TSmallintField
      FieldName = 'part14'
    end
    object sqlqpart15: TSmallintField
      FieldName = 'part15'
    end
    object sqlqpart16: TSmallintField
      FieldName = 'part16'
    end
    object sqlqlevels: TSmallintField
      FieldName = 'levels'
    end
    object sqlqleaves: TIntegerField
      FieldName = 'leaves'
    end
    object sqlqnunique: TIntegerField
      FieldName = 'nunique'
    end
    object sqlqclust: TIntegerField
      FieldName = 'clust'
    end
  end
  inherited cd: TClientDataSet
    object cdidxname: TStringField
      FieldName = 'idxname'
      FixedChar = True
      Size = 18
    end
    object cdowner: TStringField
      FieldName = 'owner'
      FixedChar = True
      Size = 8
    end
    object cdtabid: TIntegerField
      FieldName = 'tabid'
    end
    object cdidxtype: TStringField
      FieldName = 'idxtype'
      FixedChar = True
      Size = 1
    end
    object cdclustered: TStringField
      FieldName = 'clustered'
      FixedChar = True
      Size = 1
    end
    object cdpart1: TSmallintField
      FieldName = 'part1'
    end
    object cdpart2: TSmallintField
      FieldName = 'part2'
    end
    object cdpart3: TSmallintField
      FieldName = 'part3'
    end
    object cdpart4: TSmallintField
      FieldName = 'part4'
    end
    object cdpart5: TSmallintField
      FieldName = 'part5'
    end
    object cdpart6: TSmallintField
      FieldName = 'part6'
    end
    object cdpart7: TSmallintField
      FieldName = 'part7'
    end
    object cdpart8: TSmallintField
      FieldName = 'part8'
    end
    object cdpart9: TSmallintField
      FieldName = 'part9'
    end
    object cdpart10: TSmallintField
      FieldName = 'part10'
    end
    object cdpart11: TSmallintField
      FieldName = 'part11'
    end
    object cdpart12: TSmallintField
      FieldName = 'part12'
    end
    object cdpart13: TSmallintField
      FieldName = 'part13'
    end
    object cdpart14: TSmallintField
      FieldName = 'part14'
    end
    object cdpart15: TSmallintField
      FieldName = 'part15'
    end
    object cdpart16: TSmallintField
      FieldName = 'part16'
    end
    object cdlevels: TSmallintField
      FieldName = 'levels'
    end
    object cdleaves: TIntegerField
      FieldName = 'leaves'
    end
    object cdnunique: TIntegerField
      FieldName = 'nunique'
    end
    object cdclust: TIntegerField
      FieldName = 'clust'
    end
  end
end
