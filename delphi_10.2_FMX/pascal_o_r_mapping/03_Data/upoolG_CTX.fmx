inherited poolG_CTX: TpoolG_CTX
  Left = 430
  Top = 155
  Width = 552
  object sqlqID_contextes: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.sqlc
    Left = 320
    Top = 16
    object sqlqID_contextesid: TIntegerField
      FieldName = 'id'
    end
  end
  object sqlqID_contextetype: TSQLQuery
    MaxBlobSize = -1
    Params = <
      item
        DataType = ftUnknown
        Name = 'contextetype'
        ParamType = ptUnknown
      end>
    SQL.Strings = (
      'select'
      '      id'
      'from'
      '    g_ctx'
      'where'
      '     contextetype = :contextetype')
    SQLConnection = dmDatabase.sqlc
    Left = 440
    Top = 16
    object sqlqID_contextetypeid: TIntegerField
      FieldName = 'id'
    end
  end
end
