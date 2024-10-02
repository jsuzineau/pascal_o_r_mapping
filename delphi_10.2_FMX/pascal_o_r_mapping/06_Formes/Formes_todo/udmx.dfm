inherited dmx: Tdmx
  OldCreateOrder = True
  Left = 490
  Width = 713
  object ds: TDataSource
    DataSet = cd
    Left = 24
    Top = 160
  end
  object bvqd: TbvQuery_Datasource
    bv2_to_bv0 = False
    bv2Query = sqlq
    Left = 56
    Top = 16
  end
  object sqlq: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = dmDatabase.sqlc
    Left = 24
    Top = 16
  end
  object cd: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'p'
    Left = 24
    Top = 112
  end
  object p: TDataSetProvider
    DataSet = sqlq
    Left = 24
    Top = 64
  end
end
