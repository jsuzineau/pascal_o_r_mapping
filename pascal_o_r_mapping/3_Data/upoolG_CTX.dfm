inherited poolG_CTX: TpoolG_CTX
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  left = 430
  top = 155
  Height = 194
  HorizontalOffset = 465
  VerticalOffset = 57
  Width = 552
  object sqlqID_contextes: TSQLQuery[0]
    FieldDefs = <>
    Database = dmDatabase.sqlc
    Params = <>
    left = 320
    top = 16
    object sqlqID_contextesid: TLongintField
      DisplayWidth = 10
      FieldKind = fkData
      FieldName = 'id'
      Index = 0
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = False
    end
  end
  object sqlqID_contextetype: TSQLQuery[1]
    FieldDefs = <>
    Database = dmDatabase.sqlc
    SQL.Strings = (
      'select'
      '      id'
      'from'
      '    g_ctx'
      'where'
      '     contextetype = :contextetype'
    )
    Params = <    
      item
        DataType = ftUnknown
        Name = 'contextetype'
        ParamType = ptInput
      end>
    left = 440
    top = 16
    object sqlqID_contextetypeid: TLongintField
      DisplayWidth = 10
      FieldKind = fkData
      FieldName = 'id'
      Index = 0
      LookupCache = False
      ProviderFlags = [pfInUpdate, pfInWhere]
      ReadOnly = False
      Required = False
    end
  end
end